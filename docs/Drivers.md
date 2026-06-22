# Drivers

Dosen-OS has three drivers: the keyboard, the TTY, and the framebuffer
(ScreenDriver). The keyboard and TTY are register-ABI DASM routines; the
ScreenDriver is a C graphics library that writes directly to framebuffer MMIO.

---

## KeyboardDriver

[`src/drivers/KeyboardDriver.asm`](../src/drivers/KeyboardDriver.asm)
MMIO base `0xC0000000` (`.MemDevice0`).

Reading local address 0 (the slot base) pops the next keycode from the device,
or returns 0 if the FIFO is empty. The driver exposes two modes selected by
`REA`:

| `REA` | Mode          | Behavior |
| ----- | ------------- | -------- |
| `0x01`| Read-and-Draw | Reads a char from the keyboard and echoes it to the TTY. |
| `0x02`| Read          | Reads a char from the keyboard and returns it in `REB`. |

The C wrapper `ttyReadChar` ([os_bridge.asm](../src/shell/os_bridge.asm)) uses
the plain **Read** mode. `ttyReadChar()` returns `0` when the FIFO is empty,
which is how the shell and polling programs (`pong`, `edit`) detect "no key this
tick".

---

## TTYDriver

[`src/drivers/TTYDriver.asm`](../src/drivers/TTYDriver.asm)
MMIO base `0xC8000000` (`.MemDevice1`).

The TTY interprets writes to specific local addresses as commands:

- `ClearScreen` -> write anything to local `+4` (`0xC8000004`).
- `WriteCharacter` (`REA = char`) -> write the character to local `+8` (`0xC8000008`); the low 8 bits are appended.

The TTY auto-scrolls, so output always stays in view. From C you reach these
through [`stdio.h`](../src/utils/stdio.h) (`prints`, `printi`, `printc`) and [`os_bridge.h`](../src/shell/os_bridge.h)
(`ttyWriteChar`, `ttyClearScreen`).

---

## ScreenDriver (framebuffer + graphics)

[`src/drivers/ScreenDriver.c`](../src/drivers/ScreenDriver.c) / [`.h`](../src/drivers/ScreenDriver.h)
framebuffer base `0xD0000000` (`.MemDevice2`).

The framebuffer is **320×200, one 32-bit word per pixel, row-major** (the color
lives in the low 24 bits). Pixel N sits at byte `+N*4`. C code gets a pointer to
it with `renderTarget()`, then indexes `fb[y * 320 + x]` (the `int*` arithmetic
scales by 4 for you).

### Command offsets

A few addresses above the pixel area are control registers. Writing to them
triggers a device action rather than setting a pixel. The C macros are word
indices into the `int*` framebuffer, so they are the device byte offset divided
by 4:

| Macro                 | C value   | Byte offset | Effect |
| --------------------- | --------- | ----------- | ------ |
| `CLEAR_SCREEN_MODE`   | `0x3C000` | `0xF0000`   | Clear the framebuffer to black. |
| `FILL_SCREEN_MODE`    | `0x3C001` | `0xF0004`   | Fill the framebuffer with a color. |
| `DOUBLE_BUFFER_MODE`  | `0x3C002` | `0xF0008`   | Enable (1) / disable (0) double buffering. |
| `SWAP_MODE`           | `0x3C003` | `0xF000C`   | Present: swap the back buffer to the screen. |

These are wrapped by `clearScreen()`, `fillScreen(color)`,
`doubleBuffered(on)`, and `present()` so callers never touch the raw offsets.

### Graphics API

Declared in [`ScreenDriver.h`](../src/drivers/ScreenDriver.h):

```c
int  *renderTarget(void);                                  // framebuffer pointer
int   buildRGB(int r, int g, int b);                       // pack 0..255 RGB into a word

void  drawPixel(int x, int y, int color);
void  drawRectangle(int x, int y, int w, int h, int color);// filled rectangle
void  drawCircle(int x, int y, float r, int color, int mode); // mode 0 = filled, 1 = outline
void  drawBuffer(int *src);                                // blit a full-screen buffer

void  clearScreen(void);
void  fillScreen(int color);

void  doubleBuffered(int on);                              // turn double buffering on/off
void  present(void);                                       // swap back buffer -> screen
```

Notes:

- `drawCircle` takes a **`float`** radius and uses the `math`/`float` libraries
  (`cos`, `sin`, `sqrt`-free distance test). The filled path clamps its bounding
  box to the screen; the outline path walks the circumference by angle. See
  [C Standard Library](./C-Standard-Library.md).
- For animation, enable `doubleBuffered(1)`, draw into the back buffer each
  frame, then call `present()`. `pong` does exactly this.
- `buildRGB` packs `R<<16 | G<<8 | B`; one word per color, matching the
  framebuffer format.

> **Header:** `ScreenDriver.c` intentionally does **not** include its own
> header, `dasm-cc` treats the `extern` prototype as a redeclaration of the
> definition. The header is for *callers*, not the implementation file.
