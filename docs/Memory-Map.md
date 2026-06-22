# Memory Map

All addresses are 32-bit byte addresses. A word is 4 bytes, stored big-endian,
so the linker places word `i` of a segment at `Start + i*4` and C pointer
arithmetic scales by 4. The authoritative source is [`mem.cfg`](../mem.cfg); if
this page and that file ever disagree, `mem.cfg` wins.

RAM is `0x00000000 - 0xBFFFFFFF` (3 GiB, sparse-paged on the host). MMIO lives at
`0xC0000000+`. Segments are spaced out generously because the C32R ROM format
only stores regions that actually hold code or data, so empty gaps cost nothing.

## RAM segments

| Segment            | Start        | Purpose |
| ------------------ | ------------ | ------- |
| `.Kernel`          | `0x00000000` | Boot code, `KernelDispatch`, `PushProc`/`PopProc`. The CPU resets to PC 0, so this has to start here. |
| `.SyscallTable`    | `0x00010000` | Fixed jump table. Programs `CALL [SYS_x]` to reach kernel services. Entries are 4 bytes apart. |
| `.InterruptVector` | `0x00011000` | IRQ handler. |
| `.KeyboardDriver`  | `0x00012000` | Keyboard read routines. |
| `.TTYDriver`       | `0x00013000` | TTY char output and clear. |
| `.ScreenDriver`    | `0x00013100` | Reserved name. The graphics code is compiled C in `.CCode`; the framebuffer itself is MMIO. |
| `.ProcStack`       | `0x00014000` | Foreground-process slot stack (on-key + main routine per process). |
| `.ProcStackTop`    | `0x00014100` | Current proc-stack pointer. |
| `.Stack`           | `0x00080000` | Call stack. `SET_SP` loads `.Stack.Start` and the stack grows down into the empty gap below it (toward `0x00014104`). |
| `.CCode`           | `0x00100000` | Compiled C code (shell, FS, commands, programs, utils). |
| `.CBridge`         | `0x00200000` | ASM wrappers adapting the C ABI to the drivers ([os_bridge.asm](../src/shell/os_bridge.asm)). |
| `.Heap`            | `0x00210000` | Heap for `malloc`. |
| `.CData`           | `0x00400000` | C globals and string literals. |
| `.UserPrograms`    | `0x01400000` | Built-in program blobs, the `ProgramRegistry`, and the loader arena. |
| `.UserCode`        | `0x01500000` | Window the loader copies a running program into before calling it. |

## Memory-mapped devices

MMIO starts at `0xC0000000`. Each slot is 128 MiB (`0x08000000`); the slot index
is `(addr >> 27) & 7` and the local address is the low 27 bits.

| Segment       | Start        | Device |
| ------------- | ------------ | ------ |
| `.MemDevice0` | `0xC0000000` | Keyboard. Reading local 0 pops a keycode (0 if the FIFO is empty). |
| `.MemDevice1` | `0xC8000000` | TTY. Clear at `+4`, write-char at `+8` (low 8 bits of the value). |
| `.MemDevice2` | `0xD0000000` | Framebuffer. Pixel N at `+N*4`; command ports at `+0xF0000` (see [Drivers](./Drivers.md)). |
| `.MemDevice3` | `0xD8000000` | Free. |
| `.MemDevice4` | `0xE0000000` | Free. |
| `.MemDevice5` | `0xE8000000` | Free. |
| `.MemDevice6` | `0xF0000000` | Free. |
| `.MemDevice7` | `0xF8000000` | PermaStorage. The OS reaches the whole 2 MiB device through this one slot (see [File System](./File-System.md)). |

The framebuffer base (`0xD0000000`) is also read in C via `renderTarget()` in
[ScreenDriver.c](../src/drivers/ScreenDriver.c). The file system reaches the
storage device through `.MemDevice7` at `0xF8000000`, and the host auto-flushes
any slot it sees go DIRTY.
