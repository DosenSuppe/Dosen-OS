# Architecture

Dosen-OS runs on a byte-addressed 32-bit CPU (a software emulator). A word is
4 bytes, stored big-endian, and addresses are byte addresses, so consecutive
words are 4 apart. Peripherals are memory-mapped at `0xC0000000+` and reached
through driver routines.

The OS is split across two languages:

- **DASM** (`*.asm`): the kernel entry point and main loop, the interrupt
  vector, the cooperative process stack, the drivers, the user-program loader
  plumbing, the syscall table, and the C-to-driver bridge.
- **C** (`*.c`): the shell, the commands, the file system, the bundled
  programs, and the `utils/` standard library. The C compiler emits stack-frame
  based DASM with a calling convention distinct from the register-based driver
  ABI. [`os_bridge.asm`](../src/shell/os_bridge.asm) adapts between the two.

```
+--------------------------------------------------------------------------+
|                         CPU (32-bit, byte-addressed)                     |
| Keyboard@0xC0000000  TTY@0xC8000000  Framebuffer@0xD0000000  Storage@0xF8 |
+--------------------------------------------------------------------------+
          ^                ^                ^                  ^
   KeyboardDriver      TTYDriver       ScreenDriver         fs.c
          |                |                |                  |
          |                +----------------+--- os_bridge.asm (C ABI -> driver ABI)
          |                                            |
   Interrupt vector --> on-key handler            shell / commands / programs (C)
          |                                            |
   KernelDispatch loop --> foreground process main routine
```

See [Memory Map](./Memory-Map.md) for where each of these lives in address
space, and [Drivers](./Drivers.md) for the driver routines.

## Boot flow

[`main.asm`](../src/main.asm) wires everything together, in order:

1. `SET_SP $Stack.Start`: initialize the stack pointer.
2. `SET_IVR $InterruptVector.Start`: install the interrupt vector.
3. `CALL fs_init`: initialize the file system (see [File System](./File-System.md)).
4. Zero `$ProcStackTop`: the process stack starts empty.
5. `CALL loaderInit` then `CALL registerBuiltins`: bring up the program loader
   and register every built-in command and program into the registry. From here
   the registry is the single source of truth for command dispatch (see
   [Writing Programs](./Writing-Programs.md)).
6. Push the **shell** as the default foreground process: its main routine is
   `Shell.shellMain` and its on-key handler is `Shell.shellNoop`. The shell
   polls the keyboard in its main routine, so the ISR handler does nothing.
7. `CALL Shell.shellInitialize`: clear the input buffer and print the `You >`
   prompt.
8. Fall into `KernelDispatch`: the kernel's main loop.

## The kernel dispatch loop

`KernelDispatch` in [`main.asm`](../src/main.asm) is the heartbeat of the OS.
On each iteration it looks at the top of the process stack and reads that
process's main-routine slot:

- If the main routine is null, the process is purely event-driven. The loop
  just spins and lets the interrupt handler do the work.
- Otherwise the loop `CALL`s the main routine, then loops again. This runs in
  normal (non-interrupt) context, so the main routine can do long-running work,
  poll the keyboard, and draw to the screen. The shell, `pong`, and `edit` all
  work this way.

## Interrupts and input

The keyboard fires an IRQ on every keypress. The interrupt vector in
[`main.asm`](../src/main.asm):

1. Saves registers and reads the interrupt ID with `GET_INT_ID`.
2. If the ID isn't the keyboard device (`0x01`), returns immediately (`RTI`).
3. Otherwise looks up the on-key handler of the current foreground process (the
   slot beneath the main-routine slot on the process stack) and `CALL`s it.

The shell's on-key handler is `shellNoop`, which does nothing. The shell instead
drains the keyboard with `ttyReadChar()` from `shellMain` in normal context.
Keeping the line editing and command execution out of the interrupt handler
matters: a long command (the assembler, for example) handled inside the ISR
would wedge keyboard input. A program is free to install a real on-key handler
if it wants to be event-driven instead.

## The cooperative process model

Dosen-OS has no preemptive scheduler. It keeps a small process stack
(`.ProcStack`, with the current depth in `.ProcStackTop`). Each process is two
words:

```
[ on-key handler ]   <- called by the interrupt vector on each keypress
[ main routine    ]   <- called repeatedly by KernelDispatch (or null = event-driven)
```

Two kernel routines manage it, exposed to C through
[`os_bridge.asm`](../src/shell/os_bridge.asm) as `pushProc` / `popProc`:

- **`pushProc(mainFn, onKeyFn)`**: makes the caller the foreground process. The
  caller returns normally; the kernel then begins driving the new process. Pass
  `0` for `mainFn` to be purely event-driven.
- **`popProc()`**: pops the current process, restoring the one beneath it
  (usually the shell). A program calls this from its main routine to exit.

This is how a program takes over the machine and later hands control back. For
example, `edit` pushes `editorMain` + `editorNoop` and runs until ESC, at which
point it saves the file, calls `popProc`, and reprints the shell prompt. See
[Programs](./Programs.md) and [Writing Programs](./Writing-Programs.md).

## The C / Assembly bridge

The C compiler uses a stack-based calling convention. After the callee's
`PUSH REX; GET_SP REX` prologue, argument 0 sits at `[FP+12]`, argument 1 at
`[FP+16]`, and so on (frame slot 3, 4, ... times 4 bytes per word). The return
value comes back in `REA`. The DASM drivers use a register-based ABI (argument
in `REA`).

[`os_bridge.asm`](../src/shell/os_bridge.asm) holds the thin wrappers that
translate between them: `ttyWriteChar`, `ttyReadChar`, `ttyClearScreen`,
`cpuHalt`, plus the loader and process plumbing (`MMIOCopy`, `userCodeBase`,
`launchProgram`, `pushProc`, `popProc`). C code includes
[`os_bridge.h`](../src/shell/os_bridge.h) to call them. Because the bridge does
its own frame math by hand, those byte offsets (`+12`, `+16`, `+4` per word) are
spelled out in the asm rather than scaled by the compiler.

The bridge lives in its own segment (`.CBridge`) so it doesn't collide with the
compiled C output in `.CCode`: the linker places each object at its segment
base, so two objects sharing one segment would overwrite each other.
