#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../../utils/stdio.h"
#include "../../drivers/NewScreenDriver.h"

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

// ---------------------------------------------------------------------------
// Symbol fetchers — resolved by the linker from labels in main.asm.
// ---------------------------------------------------------------------------
int *arenaBaseAddr(void)         { asm("LDI REA, ArenaBase"); }
int *wrapperTemplateAddr(void)   { asm("LDI REA, BuiltinWrapperTemplate"); }
int *wrapperTemplateEndAddr(void){ asm("LDI REA, BuiltinWrapperEnd"); }
int *wrapperPatchSlotAddr(void)  { asm("LDI REA, WrapperPatchSlot"); }
int **programRegistry(void)      { asm("LDI REA, ProgramRegistry"); }
int *helloProgramAddr(void)      { asm("LDI REA, HelloProgramStart"); }
int *helloProgramEnd(void)       { asm("LDI REA, HelloProgramEnd"); }

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

// Register a program whose bytecode is already laid out in memory (a static
// blob like HelloProgramStart). Only the name gets copied into the arena;
// the registry entry points at the existing blob in place.
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
    // Static syscall-using program (no kernel callback).
    register_program("hello", helloProgramAddr(), helloProgramEnd());

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
}

// ---------------------------------------------------------------------------
// Loader proper: validates the ABI header, copies the body into .UserCode,
// CALLs the entry with argc/argv on the stack.
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
    int *end;

    if (argc < 2) {
        prints("run: missing program name", 1);
        return;
    }

    name        = argv[1];
    nameLen     = strLength(name);
    forwardArgc = argc - 1;
    forwardArgv = &argv[1];

    // Walk the registry — single source of truth for built-in commands.
    registry = programRegistry();
    i = 0;
    while (registry[i] != 0) {
        if (matches(name, nameLen, registry[i])) {
            loadAndRun(registry[i + 1], registry[i + 2], forwardArgc, forwardArgv);
            return;
        }
        i = i + 3;
    }

    // FS fallback for user-installed programs on the storage device.
    fsEntry = fs_find(name, nameLen);
    if (fsEntry != 0) {
        src = fs_data_ptr(fsEntry);
        end = src + fsEntry[1];
        loadAndRun(src, end, forwardArgc, forwardArgv);
        return;
    }

    
    DrawCircle(40, 40, 15, 0x00FF00, 1);
    prints("run: program not found", 1);
}
