#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../../utils/stdio.h"
#include "../../utils/string.h"
#include "../../drivers/ScreenDriver.h"
#include "../../programs/DIBmapReader.h"
#include "../../programs/FontWriter.h"
#include "../../programs/TextEditor.h"
#include "../../programs/Pong.h"
#include "../../programs/Assembler.h"
#include "../../programs/Bitmap.h"

#include "./net/netprog.h"

#include "../../utils/malloc.h"

#define PROGRAM_MAGIC 0x444FF1

// Kernel functions wrapped by runtime-registered builtins. Their addresses
// get patched into wrapper copies at boot.
extern void ls(int argc, int **argv);
extern void cat(int argc, int **argv);
extern void del(int argc, int **argv);
extern void touch(int argc, int **argv);
extern void write(int argc, int **argv);
extern void dofile(int argc, int **argv);
extern void blocks(int argc, int **argv);
extern void time(int argc, int **argv);

// ---------------------------------------------------------------------------
// Symbol fetchers — resolved by the linker from labels in main.asm.
// ---------------------------------------------------------------------------
int *arenaBaseAddr(void)         { asm("LDI REA, ArenaBase"); }
int *wrapperTemplateAddr(void)   { asm("LDI REA, BuiltinWrapperTemplate"); }
int *wrapperTemplateEndAddr(void){ asm("LDI REA, BuiltinWrapperEnd"); }
int *wrapperPatchSlotAddr(void)  { asm("LDI REA, WrapperPatchSlot"); }
int **programRegistry(void)      { asm("LDI REA, ProgramRegistry"); }

// ---------------------------------------------------------------------------
// Loader state
// ---------------------------------------------------------------------------
// Bump pointer into the .UserPrograms arena. Set by loaderInit, advanced by
// register_program / register_builtin as they consume space.
int *arenaTop;

// Called from main.asm before any register_* call.
void loaderInit(void) {
    arenaTop = arenaBaseAddr();
}

// ---------------------------------------------------------------------------
// Arena + registry helpers
// ---------------------------------------------------------------------------
// Copy a null-terminated string into the arena. Returns its new address.
int *arenaStrdup(int *src) {
    int *out = arenaTop;
    int i = 0;
    while (src[i] != 0) {
        arenaTop[0] = src[i];
        arenaTop = arenaTop + 1;
        i = i + 1;
    }
    arenaTop[0] = 0;
    arenaTop = arenaTop + 1;
    return out;
}

// Walk to the first empty 3-word registry slot and write {name, start, end}.
void registryAppend(int *name, int *start, int *end) {
    int **reg = programRegistry();
    int i = 0;
    while (reg[i] != 0) {
        i = i + 3;
    }
    reg[i]     = name;
    reg[i + 1] = start;
    reg[i + 2] = end;
}

void register_program(int *name, int *start, int *end) {
    int *namePtr = arenaStrdup(name);
    registryAppend(namePtr, start, end);
}

// Register a "builtin": a runtime-generated trampoline around a kernel C
// function. Copies BuiltinWrapperTemplate into the arena, patches the kernel
// function's address into the WrapperPatchSlot, and adds the registry entry.
void register_builtin(int *name, int *fnAddr) {
    int *templateSrc = wrapperTemplateAddr();
    int *templateEnd = wrapperTemplateEndAddr();
    int *patchSlot   = wrapperPatchSlotAddr();
    int templateSize = templateEnd - templateSrc;
    int patchOffset  = patchSlot - templateSrc;

    int *namePtr      = arenaStrdup(name);
    int *wrapperStart = arenaTop;

    MMIOCopy(arenaTop, templateSrc, templateSize);
    arenaTop = arenaTop + templateSize;
    int *wrapperEnd = arenaTop;

    wrapperStart[patchOffset] = fnAddr;

    registryAppend(namePtr, wrapperStart, wrapperEnd);
}

// ---------------------------------------------------------------------------
// Boot-time command registration. ADDING A NEW COMMAND IS ONE LINE HERE.
// ---------------------------------------------------------------------------
void registerBuiltins(void) {
    // Trampoline wrappers around kernel C functions.
    register_builtin("ls",     ls);
    register_builtin("cat",    cat);
    register_builtin("del",    del);
    register_builtin("touch",  touch);
    register_builtin("write",  write);
    register_builtin("dofile", dofile);
    register_builtin("blocks", blocks);
    register_builtin("halt",   cpuHalt);
    register_builtin("cls",    ttyClearScreen);

    // Program in programs/ — entry is its `main(argc, argv)`.
    register_builtin("dibmap", dibmap);
    register_builtin("fontwriter", fontwriter);
    register_builtin("edit", texteditor);
    register_builtin("pong", pong);
    register_builtin("asm", assemblerRun);
    register_builtin("bmp", bitmap);
    
    register_builtin("arp", arp);
    register_builtin("ping", ping);
    register_builtin("dns", dns);
    register_builtin("time", time);
}

// ---------------------------------------------------------------------------
// Loader proper: validates the ABI header, copies the body into .UserCode,
// CALLs the entry with argc/argv on the stack.
//
// This native variant is for in-image blobs (the builtin/program registry),
// whose words are already real 24-bit values. Disk programs go through
// loadAndRunPacked below.
// ---------------------------------------------------------------------------
void loadAndRun(int *programStart, int *programEnd, int argc, int **argv) {
    if (programStart[0] != PROGRAM_MAGIC) {
        prints("run: bad magic - not a program", 1);
        return;
    }

    int entry_off = programStart[2];
    int *body = programStart + 3;
    int body_size = programEnd - body;
    int *dst = userCodeBase();

    MMIOCopy(dst, body, body_size);
    launchProgram(dst + entry_off, argc, argv);
}

// Reassemble a 32-bit word from 4 consecutive byte-wide device words (big-endian).
int _pack4(int *p) {
    int v = p[0] & 0xFF;
    v = (v << 8) | (p[1] & 0xFF);
    v = (v << 8) | (p[2] & 0xFF);
    v = (v << 8) | (p[3] & 0xFF);
    return v;
}

// ---------------------------------------------------------------------------
// Disk loader: programs stored in the file system are byte-packed, because the
// storage device holds one byte per word. Each 32-bit instruction is stored as
// 4 big-endian device words (BYTES_PER_WORD). Layout:
//   [0..3]   magic      (0x444FF1, packed)
//   [4..7]   version    (packed)
//   [8..11]  entry_off  (packed)
//   [12..]   body       (4 device words per instruction word)
// We unpack the body into .UserCode and launch entry_off, just like loadAndRun.
// `size` is the file's length in bytes (entry size = one byte per device word).
// ---------------------------------------------------------------------------
void loadAndRunPacked(int *data, int size, int argc, int **argv) {
    if (size < 12) {
        prints("run: not a program (too small)", 1);
        return;
    }

    if (_pack4(&data[0]) != PROGRAM_MAGIC) {
        prints("run: bad magic - not a program", 1);
        return;
    }

    // data[4..7] = version (reserved for future ABI changes)
    int entry_off = _pack4(&data[8]);

    int bodyWords = (size - 12) / 4;
    int *dst = userCodeBase();

    int i = 0;
    while (i < bodyWords) {
        dst[i] = _pack4(&data[12 + i * 4]);
        i++;
    }

    launchProgram(dst + entry_off, argc, argv);
}

void listCommands() {
    prints("Available Commands:", 1);
    printc("\n");

    int **registry = programRegistry();

    int i = 0;

    while (registry[i] != 0) {
        printi(i/3, 0);
        prints(": ", 0);
        prints(registry[i], 1);
        i += 3;
    }

    return;
}

// ---------------------------------------------------------------------------
// The shell hands us argv where argv[0] = "run", argv[1] = program name,
// argv[2..] = program args. We shift one slot before dispatching so the
// loaded program sees its own name at argv[0].
// ---------------------------------------------------------------------------
void run(int argc, int **argv) {
    int *name;
    int nameLen;
    int forwardArgc;
    int **forwardArgv;
    int **registry;
    int i;
    int *fsEntry;
    int *src;

    if (argc < 2) {
        prints("run: missing program name", 1);
        return;
    }

    name        = argv[1];
    nameLen     = stringLen(name);
    forwardArgc = argc - 1;
    forwardArgv = &argv[1];

    // handle -h (help) tag.
    if (matches(name, nameLen, "-h")) {
        listCommands();
        return;
    }

    // Walk the registry - single source of truth for built-in commands.
    registry = programRegistry();
    i = 0;
    while (registry[i] != 0) {
        if (matches(name, nameLen, registry[i])) {
            loadAndRun(registry[i + 1], registry[i + 2], forwardArgc, forwardArgv);
            return;
        }
        i = i + 3;
    }

    // FS fallback for user-installed programs on the storage device. These are
    // byte-packed (the device is byte-wide), so they use the unpacking loader.
    fsEntry = fs_find(name, nameLen);
    if (fsEntry != 0) {
        src = fs_data_ptr(fsEntry);
        loadAndRunPacked(src, fsEntry[1], forwardArgc, forwardArgv);
        return;
    }

    prints("run: program not found", 1);
}
