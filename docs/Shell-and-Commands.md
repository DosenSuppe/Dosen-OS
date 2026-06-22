# Shell & Commands

The shell is a C program ([`shell.c`](../src/shell/shell.c)) installed as the default foreground 
process at boot. It is a **polling** process: its on-key ISR handler
(`shellNoop`) does nothing, and `shellMain`, called by `KernelDispatch` in
normal context, drains the keyboard itself. Keeping the line editing and command
execution out of the interrupt handler matters, since a long command (the
assembler, say) handled inside the ISR would wedge keyboard input.

---

## The line editor

`shellMain` ([shell.c](../src/shell/shell.c)) maintains a 64-char input buffer (`cmdStringBuffer`).
Each tick it polls one key, and if there is one:

1. Reads the character with `ttyReadChar()` (0 means nothing pending).
2. Renders the character with the bitmap font (`renderChar`, from [FontWriter](./Programs.md)).
3. On **Enter** (`0xA`): runs `shellExecute()`, then `shellInitialize()` to
   reprint the prompt with a fresh buffer.
4. On **Backspace** (`0x8`): drops the last char (no-op if the buffer is empty,
   so you can't backspace into the prompt).
5. Otherwise: appends the char, enforcing the 63-char limit (it prints
   `Command too long!` and re-shows the line if you'd overflow).

The prompt is `You >`, printed by `newShellLine`.

---

## Dispatch: everything goes through `run`

The shell knows about exactly **one** command: `run`. Every other word you type
is treated as a program name. `shellExecute()`:

1. Tokenizes the input line into `argc` / `argv` (`tokenize`, from [shell_util](../src/shell/shell_util.c)).
2. If `argv[0]` is `"run"`, calls `run(argc, argv)` directly.
3. Otherwise it **shifts** argv right and inserts `"run"` at the front, so
   `X args...` becomes `run X args...`, then calls `run`.

So these are equivalent:

```
cls          ==  run cls
pong         ==  run pong
edit notes   ==  run edit notes
```

`run` ([run.c](../src/shell/commands/run.c)) resolves the name against the **program registry** first, then falls back to the **file system** for user-installed programs. See [Writing Programs](./Writing-Programs.md) for how registration and loading work. Adding or removing a command no longer touches `shell.c`, you register it in `registerBuiltins`.

---

## Built-in commands

All of these are registered in `registerBuiltins` ([run.c](../src/shell/commands/run.c)) and implemented in [`src/shell/commands/`](../src/shell/commands/).

| Command  | Usage                 | Description                                                                                                                             |
| -------- | --------------------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| `ls`     | `ls`                  | List active files: index, name, size in bytes.                                                                                          |
| `cls`    | `cls`                 | Clear the TTY screen.                                                                                                                   |
| `touch`  | `touch <name>`        | Create an empty file (name ≤ 60 chars). Errors if it already exists or there are no free slots.                                         |
| `cat`    | `cat <name>`          | Print a file's contents to the TTY.                                                                                                     |
| `write`  | `write <name> <text>` | Overwrite an existing file's contents with `<text>` (≤ 4096 chars) and flush. File must exist (`touch` it first).                       |
| `del`    | `del <name>`          | Delete a file.                                                                                                                          |
| `dofile` | `dofile <name>`       | Demo: create `<name>` if absent, write `"Hi!"`, flush. Used to verify the FS end-to-end.                                                |
| `blocks` | `blocks`              | FS debug view: walks the device slots and prints used/dirty counts plus each file's status (`P`=present, `D`=dirty), name, and size. |
| `halt`   | `halt`                | Execute `HALT`; the CPU stops.                                                                                                          |

Anything that doesn't resolve to a registered program or a file prints
`run: program not found`.

---

## Shell utilities

[`shell_util.c`](../src/shell/shell_util.c) / [`.h`](../src/shell/shell_util.h):

- `tokenize(str, &argc, argv)`: split the input line into argument pointers.
- `matches(buf, len, str)`: compare the first `len` chars of `buf` against the
  C string `str`, also checking `str` is exactly `len` chars (no false match
  against a longer name).

Text output goes through [`stdio.h`](../src/utils/stdio.h): 
- `prints(str, newLine)`
- `printi(val, newLine)`
- `printc(ch)`

See [C Standard Library](./C-Standard-Library.md).
