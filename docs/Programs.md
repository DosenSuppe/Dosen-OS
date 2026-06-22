# Bundled Programs

These programs live in [`src/programs/`](../src/programs/) and are registered at
boot alongside the built-in commands (in `registerBuiltins`,
[run.c](../src/shell/commands/run.c)). Run any of them through the shell's implicit `run` prefix.

`pong` is the same as `run pong`.

They illustrate the two ways a program interacts with the OS:

- **Event-driven / foreground takeover** via `pushProc` / `popProc` (see
  [Architecture](./Architecture.md#the-cooperative-process-model)).
- **Run-once** programs that draw something and return immediately.

---

## `pong` - single-player Pong

[`Pong.c`](../src/programs/Pong.c)

A ball bounces around the 320×200 screen; you move a paddle on the left with
**W** / **S** and bounce the ball back. **ESC** quits.

How it works:

- `pong()` initializes the ball/paddle state, enables double buffering
  (`doubleBuffered(1)`), and pushes `main` as the foreground process's main
  routine (with a no-op key handler) via `pushProc`.
- The kernel dispatch loop then calls `main` every tick. Each tick reads a key
  with `ttyReadChar()` (W/S move the paddle, ESC exits), updates the ball every
  60 ticks, checks paddle intersection, and re-renders.
- Rendering clears the back buffer, draws the paddle (`drawRectangle`) and ball
  (`drawCircle`), then `present()`s.
- On ESC, `_end()` disables double buffering, clears the screen, and
  `popProc()`s back to the shell.

Demonstrates: double-buffered animation, the [ScreenDriver](./Drivers.md)
graphics API, and the cooperative main-routine model.

---

## `edit` - text editor

[`TextEditor.c`](../src/programs/TextEditor.c) ·
[memory note: `texteditor-program`]

Usage: `run edit <file>` (or just `edit <file>`).

A minimal full-screen editor. It loads `<file>` into a 1024-word working buffer
(empty if the file doesn't exist, it's created on save), and installs
`editorMain` as the foreground process.

Keys:

| Key           | Action                                                                                 |
| ------------- | -------------------------------------------------------------------------------------- |
| printable     | Append the character at the cursor (always end-of-buffer, there are no arrow keys).    |
| **Enter**     | Insert a newline.                                                                      |
| **Backspace** | Delete the last character.                                                             |
| **ESC**       | Save to the file (flushing via [the FS](./File-System.md)) and exit back to the shell. |

Each tick `editorMain` repaints only when the buffer changed (`editDirty`),
then polls one key. The screen shows a status header, the buffer, and a `_`
cursor. On ESC it saves, `popProc`s, and reprints the shell prompt.

Demonstrates: the foreground-process model, reading/writing files, and TTY
full-screen rendering.

---

## `dibmap` - DIBmap image viewer

[`DIBmapReader.c`](../src/programs/DIBmapReader.c) 
[`.h`](../src/programs/DIBmapReader.h)

Usage: `run dibmap <file>` renders a **DIBmap** (Dosen Interpreted Bitmap)
image file to the screen at the top-left, unscaled.

A DIBmap file is a palette-indexed bitmap stored one word per element, with a
small header:

| Field      | Words     | Meaning                                                            |
| ---------- | --------- | ------------------------------------------------------------------ |
| `sizeX`    | `[1..2]`  | Image width (packed from two bytes).                               |
| `sizeY`    | `[3..4]`  | Image height.                                                      |
| `chunkPtr` | `[5..6]`  | Offset to optional chunk metadata (0 = none).                      |
| `colorPtr` | `[7..8]`  | Offset to the palette (RGB triples).                               |
| `imagePtr` | `[9..10]` | Offset to the index data (row-major, one palette index per pixel). |

The reader resolves each pixel's palette index, builds the color with
`buildRGB`, and writes it to the framebuffer, with optional integer `scale`
magnification.

It exposes two entry points used by other code:

- `renderDIBmap(file, x, y, scale)`: draw the whole image.
- `renderDIBmapOffset(file, x, y, scale, offset)`: draw a single **chunk**
  (sub-rectangle), selected by linear chunk index. This is how the font is
  drawn glyph-by-glyph.

Demonstrates: reading structured binary from the [FS](./File-System.md) and
blitting to the [framebuffer](./Drivers.md).

---

## `fontwriter` - bitmap font glyph renderer

[`FontWriter.c`](../src/programs/FontWriter.c)
[`.h`](../src/programs/FontWriter.h)

Renders a single character using `Font.dib`, a chunked DIBmap where each glyph
is one chunk. `renderChar(ch)` maps the character to a chunk offset
(`a`–`z` -> 0–25, `0`–`9` -> 26–35, space -> 59, anything else -> a "not found"
glyph), advances a cursor, and draws the glyph via `renderDIBmapOffset`. After
20 characters it wraps and clears the screen.

This is the routine the **shell** calls to echo typed characters graphically
(see [Shell & Commands](./Shell-and-Commands.md)). It depends on a `Font.dib` file being present
in the [file system](./File-System.md).
