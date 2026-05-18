# Dosen-OS

Dosen-OS is a small operating system written in DASM (Dosen-Assembly) with a
growing C component, targeting a custom [24-bit CPU](https://github.com/DosenSuppe/CPU-24bit)
implemented in Logisim. The OS boots into an interactive shell with a basic
in-memory file system, keyboard input, TTY output, and a framebuffer driver.

---

## Table of Contents

- [Overview](#overview)
- [System architecture](#system-architecture)
- [Memory map](#memory-map)
- [Boot flow](#boot-flow)
- [Interrupts and input](#interrupts-and-input)
- [Drivers](#drivers)
- [Shell](#shell)
- [File system](#file-system)
- [C/Assembly bridge](#cassembly-bridge)
- [Source layout](#source-layout)
- [Building the OS](#building-the-os)
- [Upcoming features](#upcoming-features)

---

## Overview

The machine is word-addressable with 24-bit words. Everything — instructions,
characters, FS entries — is one word per element. Peripherals are
memory-mapped at `0x800000`+ and accessed through driver routines.

The OS is split across two languages:

- **DASM** (`*.asm`): kernel entry, interrupt vector, drivers, and the
  C-to-driver bridge.
- **C** (`*.c`, compiled by an external `cc.py` to DASM): shell, command
  implementations, file system, and string utilities. The compiled output
  lives alongside the source as `*.asm` files (e.g. `shell.asm`, `fs.asm`).

The C compiler emits stack-frame-based DASM that uses a calling convention
distinct from the register-based driver ABI. The `os_bridge.asm` module
adapts between the two.

---

## System architecture

```
+--------------------------------------------------------------+
|                      Hardware (24-bit CPU)                   |
|  RAM  |  Keyboard@0x800000 | TTY@0x900000 | FB@0xA00000 ...  |
+--------------------------------------------------------------+
                  ^                ^             ^
                  |                |             |
            KeyboardDriver    TTYDriver    ScreenDriver
                  |                |
                  |                +--- os_bridge.asm (C ABI -> driver ABI)
                  |                              |
                  |                          shell_util / commands (C)
                  |                              |
            Interrupt vector ---------------> shell.c (dispatcher)
                                                   |
                                                fs.c (file system)
```

- The keyboard generates IRQs. The interrupt vector in [main.asm](src/main.asm)
  echoes characters to the TTY, maintains the command buffer at
  `.CommandCharacterBuffer`, and on `Enter` calls `shell_execute`.
- `shell_execute` parses the buffer, dispatches to a command, and the shell
  redraws its prompt.
- Commands talk to the FS through [fs.h](src/shell/fs.h) and write output
  through `tty_write_char` / `prints`.

---

## Memory map

Defined in [mem.cfg](mem.cfg). All addresses are in 24-bit word space.

| Segment                  | Start     | Size    | Purpose                                       |
| ------------------------ | --------- | ------- | --------------------------------------------- |
| `.Kernel`                | 0x000000  | 0x0FFF  | Kernel entry, main loop                       |
| `.Stack`                 | 0x001000  | 0x00FF  | Call stack                                    |
| `.InterruptVector`       | 0x001100  | 0x00FF  | IRQ handler                                   |
| `.StringLib`             | 0x001200  | 0x02FF  | Legacy ASM string helpers                     |
| `.KeyboardDriver`        | 0x002000  | 0x0FFF  | Keyboard read routines                        |
| `.TTYDriver`             | 0x003000  | 0x00FF  | Character/clear-screen routines               |
| `.ScreenDriver`          | 0x000600  | 0x00FF  | Framebuffer routines                          |
| `.CharactersMapping`     | 0x003100  | 0x00FF  | ASCII constants                               |
| `.Shell`                 | 0x003200  | 0x0DFF  | Legacy ASM shell (superseded by C port)       |
| `.CommandCharacterBuffer`| 0x004000  | 0x001F  | Live input buffer (word 0 = length)           |
| `.Commands`              | 0x004020  | 0x04DF  | Reserved for command code                     |
| `.FilenameStorage`       | 0x004300  | 0x03FF  | FS header + entry table                       |
| `.FileStorage`           | 0x005000  | 0x0FFC  | Block pool (32 blocks × 64 words)             |
| `.CCode`                 | 0x006000  | 0x1FFF  | Compiled C code (shell, FS, commands)         |
| `.CData`                 | 0x008000  | 0x0FFF  | C globals and string literals                 |
| `.CBridge`               | 0x009000  | 0x0FFF  | ASM wrappers exposing drivers to C            |
| `.MemDevice0` (keyboard) | 0x800000  | 0x0FFFFF| Keyboard MMIO                                 |
| `.MemDevice1` (TTY)      | 0x900000  | 0x0FFFFF| TTY MMIO                                      |
| `.MemDevice2` (time)     | 0xA00000  | 0x0FFFFF| Reserved (WIP)                                |
| `.MemDevice3..7`         | 0xB00000+ | 0x0FFFFF| Unused                                        |

> Note: the ScreenDriver actually uses framebuffer base `0xA00000` (see
> `FB_BASE` in [ScreenDriver.asm](src/drivers/ScreenDriver.asm)), which
> overlaps `.MemDevice2`. The `.ScreenDriver` segment only holds the routine
> code; the framebuffer itself is the MMIO region.

---

## Boot flow

[main.asm](src/main.asm) wires everything together:

1. `SET_SP $Stack.Start` — initialize stack pointer.
2. `SET_IVR $InterruptVector.Start` — install the interrupt vector.
3. `CALL fs_init` — zero the FS header, mark all 32 blocks free, mark all
   8 entry slots free.
4. `CALL shell_initialize` — zero the command buffer and print `You >`.
5. `CALL ScreenDriver.DrawCenterRedLine` — paints a 320×3 red bar across the
   middle of the framebuffer (visual proof-of-life).
6. Falls into `Prog: NOP / JP Prog` — the CPU idles here. All further work
   happens inside the interrupt handler.

---

## Interrupts and input

The keyboard fires an IRQ on every keypress. The handler (in
[main.asm](src/main.asm)) does this per character:

1. Read interrupt ID; if it's not the keyboard, return immediately.
2. Read the character from the keyboard MMIO via `KeyboardDriver.Read`
   (returns the char in `REB`).
3. If the character is `Backspace` and the command buffer is empty, drop it
   (prevents eating into the `> ` prompt).
4. Otherwise echo the character to the TTY.
5. If the character is `NewLine`, call `shell_execute` then
   `shell_initialize` (redraws prompt with a fresh empty buffer).
6. Otherwise update the command buffer: increment its length and store the
   character (or decrement length on Backspace).

The command buffer (`.CommandCharacterBuffer`) is laid out as:

```
buf[0]      = current length (in words)
buf[1..len] = characters, one per word
```

This contract is shared between the ASM interrupt handler and the C shell
([shell.c](src/shell/shell.c)).

---

## Drivers

### KeyboardDriver
[`src/drivers/KeyboardDriver.asm`](src/drivers/KeyboardDriver.asm)

Two modes, selected by `REA`:

| `REA` | Mode          | Behavior                                                          |
| ----- | ------------- | ----------------------------------------------------------------- |
| 0x01  | Read-and-Draw | Reads from `MemDevice0` and writes the char to the TTY.           |
| 0x02  | Read          | Reads from `MemDevice0` and returns the value in `REB`.           |

The interrupt vector in [main.asm](src/main.asm) calls `Read` directly
(it handles echo itself, with backspace special-cased).

### TTYDriver
[`src/drivers/TTYDriver.asm`](src/drivers/TTYDriver.asm)

MMIO-based at base `0x900000`:

- `WriteCharacter` (`REA = char`) → stores `REA` to `0x900002`.
- `ClearScreen` → stores anything to `0x900001`.

The TTY hardware interprets writes to specific addresses as commands.

### ScreenDriver
[`src/drivers/ScreenDriver.asm`](src/drivers/ScreenDriver.asm)

Framebuffer at `0xA00000`, 320 pixels per row, 24-bit color (one word per
pixel). Currently exposes only `DrawCenterRedLine`, which paints a 320×3
red bar centered on y=100.

---

## Shell

The shell is a C program — [shell.c](src/shell/shell.c) — driven by the
interrupt handler. On each `Enter`:

1. Strip leading spaces from the input buffer.
2. Find the first space → split into `command` (length `cmd_len`) and
   `args` (the rest).
3. Copy args into a local buffer (commands receive `args` as a flat
   word-per-char array).
4. Dispatch by `cmd_len` then exact string match via
   [`matches`](src/shell/shell_util.c).

### Built-in commands

| Command  | Args               | Description                                              |
| -------- | ------------------ | -------------------------------------------------------- |
| `ls`     | —                  | List all active files with block count.                  |
| `cls`    | —                  | Clear the TTY screen.                                    |
| `touch`  | `<name>`           | Create an empty file (name ≤ 12 chars).                  |
| `cat`    | `<name>`           | Print file contents to the TTY.                          |
| `write`  | `<name> <text>`    | Overwrite file with text (file must exist).              |
| `del`    | `<name>`           | Delete a file and release its blocks.                    |
| `dofile` | `<name>`           | Demo: create-if-absent and append a block containing `Hi!`. |
| `run`    | `<name>`           | Stub (`TODO`).                                           |
| `halt`   | —                  | Execute `HALT` (CPU stops).                              |

Anything else prints `Command not found!`.

### Shell utilities
[`src/shell/shell_util.c`](src/shell/shell_util.c)

- `prints(str, newLine)` — print a null-terminated string; append `\n` iff `newLine==1`.
- `printi(val, newLine)` — print a decimal integer (handles negatives).
- `matches(buf, len, str)` — compare `buf[1..len]` with C string `str`; the
  trailing check `if (str[len])` ensures the C string is exactly `len` chars
  (no false matches against a longer command name).
- `commands_buffer()` / `files_buffer()` — return raw segment pointers via
  inline `asm()` that emits an `LDI REA, $Segment.Start`.

### Limits

- Input buffer: 31 words (≤ 30 chars per command line).
- Filename: ≤ 12 characters.
- Max files: 8.
- File size: ≤ 8 blocks × 64 chars = 512 chars per file.
- Total FS capacity: 32 blocks shared across files = 2048 chars.

---

## File system

Defined in [fs.h](src/shell/fs.h) and implemented in [fs.c](src/shell/fs.c).
The FS is fully in-memory; nothing persists across reboots.

### Layout in `.FilenameStorage`

```
[0]               file_count       — number of active entries
[1..32]           block_used[32]   — 0 = free, 1 = used
[33..]            entries[8]       — 25 words each
```

### Entry (25 words)

| Offset    | Field         | Notes                                    |
| --------- | ------------- | ---------------------------------------- |
| `[0]`     | `in_use`      | 0 = free slot, 1 = used                  |
| `[1]`     | `name_length` | 1..12                                    |
| `[2..13]` | `name[12]`    | one char per word                        |
| `[14]`    | `created`     | placeholder (no RTC yet)                 |
| `[15]`    | `modified`    | placeholder                              |
| `[16]`    | `block_count` | 0..8                                     |
| `[17..24]`| `block_ids[8]`| ids into the block pool, in alloc order  |

### Block pool

`.FileStorage` is 32 blocks × 64 words = 2048 words. Blocks are allocated
on demand by `fs_alloc_block` and released by `fs_free_blocks` /
`fs_delete`. Allocation is first-fit. Files own non-contiguous blocks.

### Public API

```c
void  fs_init(void);
int   fs_file_count(void);
int  *fs_entry_by_idx(int idx);        // walk active entries
int  *fs_find(int *name, int name_len);
int  *fs_create(int *name, int name_len);
int   fs_delete(int *name, int name_len);
int   fs_alloc_block(int *entry);      // returns block id or -1
void  fs_free_blocks(int *entry);      // releases all blocks, keeps entry
int  *fs_block_data(int block_id);     // pointer to 64-word block
```

---

## C/Assembly bridge

The C compiler (`cc.py`) uses a stack-based calling convention: arguments
are pushed onto the stack at `[FP+2..]`, the return value is in `REA`. The
DASM drivers use a register-based ABI (`REA` = arg). The bridge in
[`os_bridge.asm`](src/shell/os_bridge.asm) glues the two together.

Example wrapper (`tty_write_char`):

```asm
tty_write_char:
    PUSH REX
    GET_SP REX
    MOV REY, REX
    LDI REZ, #3
    ADD REY, REZ           ; arg0 at [FP+3] (push-decrement stack)
    LDI REA, [REY]
    CALL TTYDriver.WriteCharacter
    POP REX
    RTS
```

Three wrappers exist today ([os_bridge.h](src/shell/os_bridge.h)):

```c
void tty_write_char(int ch);
void tty_clear_screen(void);
void cpu_halt(void);          // never returns
```

The bridge lives in its own segment `.CBridge` so it doesn't collide with
the compiled C output in `.CCode` (the linker places each object at its
segment base + 0, so two objects sharing a segment overwrite each other).

---

## Source layout

```
src/
├── main.asm                  Kernel entry + interrupt vector
├── drivers/
│   ├── KeyboardDriver.asm    MMIO read for keyboard
│   ├── TTYDriver.asm         Character output + clear-screen
│   └── ScreenDriver.asm      Framebuffer demo (red bar)
├── mappings/
│   └── Characters.asm        ASCII constants for use in DASM
├── utils/
│   └── String.asm            Legacy ASM string routines
└── shell/
    ├── shell.c / .asm        Command dispatcher (C → compiled .asm)
    ├── shell_util.c / .h     prints / printi / matches / segment accessors
    ├── fs.c / .h / .asm      File system
    ├── os_bridge.asm / .h    C ABI → driver ABI wrappers
    └── commands/
        ├── commands.h        Command function prototypes
        ├── ls.c   / .asm     List files
        ├── touch.c / .asm    Create empty file
        ├── cat.c   / .asm    Print file contents
        ├── write.c / .asm    Overwrite file with text
        ├── del.c   / .asm    Delete file
        └── dofile.c / .asm   Demo: create + append "Hi!"
```

`*.asm` files alongside `*.c` files are compiler output from `cc.py`. Edit
the `.c` source; the `.asm` is regenerated.

---

## Building the OS

```
> dasm src/main.dasm
> dasm-linker bin/main.obj mem.cfg os.o
```

The linker uses [mem.cfg](mem.cfg) to lay each segment into its target
address range. The final `os.o` is the image loaded by the CPU.

---

## Upcoming features

- Running programs (`run <name>`).
- Persistent file storage.
- More keyboard modes (modifier keys, key release).
- A real-time clock backing the `created` / `modified` entry fields.
