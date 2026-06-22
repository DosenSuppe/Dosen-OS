# Writing Programs

This page covers the program loader: how commands and programs get registered,
how the loader runs them, the user-program ABI, and the syscall table that lets
externally-loaded programs reach kernel services.

The plumbing lives in [`main.asm`](../src/main.asm) (`.UserPrograms` segment), [`run.c`](../src/shell/commands/run.c) (the loader in C), 
and [`os_bridge.asm`](../src/shell/os_bridge.asm) (the low-level move/ launch helpers).

---

## The program registry

There is one registry (`ProgramRegistry` in [main.asm](../src/main.asm)) and it is the **single source of truth**
for command dispatch. It's a table of 3-word entries:

```
[ name pointer ]  [ body start ]  [ body end ]
```

A null name marks the end. `run` walks this table on every invocation.
Two ways to add an entry, both done at boot in `registerBuiltins` ([run.c](../src/shell/commands/run.c)):

### 1. `register_builtin(name, kernelFn)` - wrap a kernel C function

This is how almost every command is registered (`ls`, `cat`, `halt`, `pong`,
`edit`, ...). It copies a small **wrapper template** (`BuiltinWrapperTemplate` in
[main.asm](../src/main.asm)) into the loader arena and patches the kernel
function's address into it. The wrapper reads `argc`/`argv` off its stack,
pushes them in C order, and calls your function. **Adding a command is one line:**

```c
register_builtin("mycmd", mycmd);   // void mycmd(int argc, int **argv)
```

### 2. `register_program(name, start, end)` - a static program blob

For a program written as a raw blob in the `.UserPrograms` segment (with the
3-word ABI header described below), this copies the name into the arena and adds
a registry entry pointing at the blob's start/end labels.

### Loader arena

`loaderInit` sets a bump pointer to `ArenaBase` (end of the `.UserPrograms`
segment). `register_*` calls append name strings and wrapper copies there as
they run. There are 32 registry slots.

---

## The user-program ABI (v1)

Every *loadable* program (one that `run` copies and launches, as opposed to a
plain kernel function) begins with a **3-word header**:

| Word  | Field     | Value                                               |
| ----- | --------- | --------------------------------------------------- |
| `[0]` | magic     | `0x444FF1`: sanity check before the loader jumps in |
| `[1]` | version   | `1`: ABI version                                    |
| `[2]` | entry_off | offset of the entry function within the body        |

The loader (`loadAndRun` in [run.c](../src/shell/commands/run.c)):

1. Checks the magic (`run: bad magic` on mismatch).
2. Copies the **body** (everything after the 3-word header) into the
   `.UserCode` window with `MMIOCopy`.
3. `CALL`s `body_base + entry_off` with `argc`/`argv` pushed C-style (`launchProgram`).

On entry the program sees `argc` at `[FP+12]` and `argv` at `[FP+16]` (frame
slots 3 and 4, times 4 bytes per word). It returns with `RTS`, exit code in
`REA` (`0` = success).

---

## How `run` resolves a name

`run(argc, argv)` ([run.c](../src/shell/commands/run.c)) gets argv where `argv[0]` is `"run"` and `argv[1]` is the program name; it shifts by one so the launched program sees its own name at `argv[0]`.
Then:

1. Walk `ProgramRegistry`; if a name matches, `loadAndRun` its body: native
   32-bit words copied straight into `.UserCode`. (This covers all built-ins and
   bundled programs.)
2. Otherwise look the name up in the [file system](./File-System.md); if found,
   load it with `loadAndRunPacked` (see below). (This is how user-installed
   programs on the storage device run.)
3. Otherwise print `run: program not found`.

---

## Packed disk-program format

Disk programs can't be stored as raw words: the storage device holds one byte
per word (the low byte), and a flush keeps only that byte. So an on-disk program
stores every 32-bit instruction word as **4 big-endian device words** (4
host-file bytes). The file layout, in device words after the host loads it, is:

| Device words | Field      | Packed value |
| ------------ | ---------- | ------------ |
| `[0..3]`     | magic      | `0x444FF1` |
| `[4..7]`     | version    | `1` |
| `[8..11]`    | entry_off  | entry offset within the body (words) |
| `[12..]`     | body       | 4 device words per instruction word |

`loadAndRunPacked` ([run.c](../src/shell/commands/run.c)) verifies the magic,
reads `entry_off`, then reassembles each instruction with
`_pack4 = (b0<<24)|(b1<<16)|(b2<<8)|b3` directly into `.UserCode`, and launches
`entry_off` with argc/argv. Same as `loadAndRun`, just unpacking as it copies.

### Building a disk program

A worked example lives in [`userland/hello.dasm`](../userland/hello.dasm). The
toolchain is:

```powershell
.\BuildProgram.ps1 -Source .\userland\hello.dasm
# -> writes a packed program to ..\PermStorage\hello
# boot the OS, then:  run hello
```

[`BuildProgram.ps1`](../BuildProgram.ps1) does three things:

1. **Assemble** the program (`dasm`) to its own `.obj`.
2. **Link + pack** it with [`tools/PackProgram.py`](../tools/PackProgram.py),
   which drives the project linker in-process so the program is based at
   `$UserCode.Start` (via [`userland/program.cfg`](../userland/program.cfg)),
   the same address the loader copies it to, so every local label resolves to
   its real runtime address. The packer prepends the 3-word header and writes
   4 bytes per word.
3. **Drop** the result into the host `PermStorage/` folder, where the emulator
   syncs it into a file-system slot at boot.

Because the body is based at the load address and kernel services are reached
through the fixed-address [syscall table](#the-syscall-table) (whose addresses
never move), the program needs no runtime relocation. It just works once copied
into `.UserCode`.

> Keep the entry as the **first** instruction in the `.Program` segment so
> `entry_off` stays `0`. Author the program in DASM (not C): cc.py output is
> based in `.CCode` and entangled with the OS link, whereas a hand-written
> program is cleanly based at `.UserCode`.

---

## The syscall table

Programs copied into `.UserCode` can't link against kernel symbols directly,
since their addresses aren't known at compile time. Instead the kernel exposes a
**fixed-address jump table** at `0x00010000` (`.SyscallTable`, see [Memory Map](./Memory-Map.md)),
defined in [`syscall_table.asm`](../src/syscall_table.asm). Each slot holds a
32-bit address, so consecutive slots are 4 bytes apart.

A program invokes a service by loading the function address from the table and
calling it:

```asm
LDI REA, [SYS_ttyWriteChar]   ; load the kernel function address from the slot
CALL REA                      ; call it
```

Current slots (order is fixed; append only, never reorder, or already-compiled programs break):

| Symbol               | Slot         | Service |
| -------------------- | ------------ | ------- |
| `SYS_prints`         | `0x00010000` | Print a string |
| `SYS_ttyWriteChar`   | `0x00010004` | Write a character |
| `SYS_ttyClearScreen` | `0x00010008` | Clear the TTY |
| `SYS_cpuHalt`        | `0x0001000C` | Halt the CPU |
| `SYS_printi`         | `0x00010010` | Print an integer |
| `SYS_printc`         | `0x00010014` | Print a char (via font) |
| `SYS_ttyReadChar`    | `0x00010018` | Read a key (0 if none) |
| `SYS_fs_find`        | `0x0001001C` | Find a file entry |
| `SYS_fs_data_ptr`    | `0x00010020` | Get a file's data pointer |
| `SYS_fs_create`      | `0x00010024` | Create a file |
| `SYS_fs_delete`      | `0x00010028` | Delete a file |
| `SYS_fs_file_count`  | `0x0001002C` | Count files |
| `SYS_fs_mark_dirty`  | `0x00010030` | Mark a file dirty for flush |

> Built-in commands and bundled programs are compiled into the OS image, so they
> call these functions by name and don't need the syscall table. The table
> exists for programs loaded at runtime from the file system.

---

## Choosing a process style

Once launched, a program decides how it runs (see [Architecture](./Architecture.md#the-cooperative-process-model)):

- **Run-once:** do the work and `return`/`RTS`. Control goes back to the shell.
  (`dibmap`, `fontwriter`.)
- **Foreground takeover:** call `pushProc(mainFn, onKeyFn)` and return. The
  kernel then drives `mainFn` each tick (and routes keys to `onKeyFn`) until the
  program calls `popProc()`. (`pong`, `edit`.)
