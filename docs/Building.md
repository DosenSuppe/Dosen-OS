# Building the Image

The whole OS is built into a single C32R image (default `os.bin`) by the
[`Build.ps1`](../Build.ps1) script in the project root. The emulator loads that
file directly.

## Quick start

```powershell
# C32R sparse binary named os.bin (the default)
.\Build.ps1 -o "os.bin"

# Choose the output name
.\Build.ps1 -o "myimage.bin"

# Legacy Logisim text format, for debugging only
.\Build.ps1 -t -o "os.o"
```

The default output is the C32R sparse binary the emulator expects. `-t` switches
to the old Logisim `v2.0 raw` text dump, which is kept only for inspecting the
image by hand.

| Format | Flag      | Notes |
| ------ | --------- | ----- |
| C32R   | (default) | Sparse segment binary the emulator loads. Only stores regions with code or data. |
| Text   | `-t`      | Legacy Logisim `v2.0 raw`. Huge, debugging only. |

## What the script does

[`Build.ps1`](../Build.ps1) runs three stages:

1. **Compile C.** Finds every `*.c` under `src/` (recursively) and compiles
   each with `dasm-cc <file> --no-entry --silent`, producing the `gen-*.asm`
   next to it.
2. **Assemble.** Runs `dasm .\src\main.asm`, which `!IMPORT`s all the driver
   asm and the generated C asm and produces `bin/main.obj`.
3. **Link.** Runs the linker with [`mem.cfg`](../mem.cfg) to place every segment
   at its target byte address (see [Memory Map](./Memory-Map.md)) and write the
   final image. Default is the C32R sparse binary; `-t` writes the legacy text
   image instead.

If the output file isn't produced, the script errors out.

## After editing code

- **Edited a `.c` file?** Re-run `.\Build.ps1`; the `gen-*.asm` is
  regenerated automatically. Don't edit the generated asm by hand; it's
  overwritten.
- **Added a new `.c` file?** It's picked up automatically by the recursive glob,
  but you still need to `!IMPORT` its `gen-*.asm` in
  [`main.asm`](../src/main.asm) (and, for a new command/ program, register it in
  `registerBuiltins`. see [Writing Programs](./Writing-Programs.md)).
- **Added a new driver/asm module?** Add its `!IMPORT` to
  [`main.asm`](../src/main.asm) and a segment for it in [`mem.cfg`](../mem.cfg).

## Building a disk-loadable program

`Build.ps1` builds the OS image. To build a standalone program that lives on
"disk" and is loaded at runtime via `run`, use
[`BuildProgram.ps1`](../BuildProgram.ps1) instead:

```powershell
.\BuildProgram.ps1 -Source .\userland\hello.dasm
# assembles, links at $UserCode.Start, byte-packs, and writes ..\PermStorage\hello
# then in the booted OS:  run hello
```

See [Writing Programs → Packed disk-program format](./Writing-Programs.md#packed-disk-program-format).

## Toolchain

`Build.ps1` prefers running the toolchain SOURCE through the project venv
(`CPU-24bit/.venv`), since the installed `dasm-*.exe` shims can lag the DevTools
source while the platform is changing. It falls back to the exes on `PATH` if
the venv isn't there:
- `dasm-cc` / `CCompiler.py`: the C to DASM compiler.
- `dasm` / `Compiler.py`: the DASM assembler.
- `dasm-linker` / `Linker.py`: the segment-placing linker (emits C32R).

`BuildProgram.ps1` likewise drives `Linker.py` in-process to pack a single
program without writing a full image.
