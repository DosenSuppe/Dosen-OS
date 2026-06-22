# C Standard Library (`utils/`)

A small standard library lives in [`src/utils/`](../src/utils/). Each module is
a `*.c` / `*.h` pair (compiled to `gen-*.asm`). Include the header to use it.

> **Word model reminder.** Everything is a 32-bit word (4 bytes, byte-addressed).
> A "string" is an array of words, one ASCII char per word, null-terminated.
> `int` is one word.

---

## `stdio` - text output

[`stdio.h`](../src/utils/stdio.h)

```c
void prints(int *str, int newLine);   // print a string; append '\n' if newLine != 0
void printi(int val, int newLine);    // print a decimal integer (handles negatives)
void printc(char character);          // print one character (via the bitmap font)
```

These write to the TTY (see [Drivers](./Drivers.md)). `prints` takes the
string and a newline flag so callers can build a line from several pieces and
only break at the end.

---

## `string`

[`string.h`](../src/utils/string.h)

```c
int stringLen(int *str);              // length of a null-terminated word-string
```

---

## `math`

[`math.h`](../src/utils/math.h)

Integer and floating-point helpers. The `…f` variants take/return `float`; the
plain ones work on `int`.

```c
int   abs(int n);       
float absf(float n);

int   neg(int n);
float negf(float n);

float ceil(float n);  // WIP
float floor(float n);  // WIP
float round(float n);  // WIP
float sqrt(float n);  // WIP

float sin(float deg);
float cos(float deg);
float tan(float deg);  // WIP
float atan2(float x, float y); // WIP

float toFloat(int n);
int   toInt(float n);  // explicit conversions

int   max(int a, int b);
float maxf(float a, float b);
int   min(int a, int b);
float minf(float a, float b);
int   clamp(int v, int lo, int hi);
float clampf(float v, float lo, float hi);

float lerp(float a, float b, float t);  // WIP
float mod(float n, float d);  // WIP
```

> The C compiler does **not** auto-convert `int` to `float` when passing arguments. 
> If a function wants a `float`, pass a `float`: use `toFloat(n)` (and `toInt()` to
> go back). This is why, e.g., `pong` calls `drawCircle(x, y, toFloat(size), color, 0)`.

---

## `float` - floating-point constants

[`float.h`](../src/utils/float.h)

Named constants so code doesn't sprinkle magic floats. The literal suffix `f`
marks a float literal.

| Macro | Value | | Macro | Value |
| ----- | ----- |-| ----- | ----- |
| `F_ZERO` / `F_ONE` / `F_NEG_ONE` | 0 / 1 / -1 | | `F_HALF` | 0.5 |
| `F_PI` / `F_NEG_PI` | ±3.14159 | | `F_TWO_PI` | 6.28318 |
| `F_HALF_PI` | 1.57079 | | `F_EPSILON` | 0.00001 |
| `F_DEG_TO_RAD` | 0.01745 | | `F_RAD_TO_DEG` | 57.2958 |
| `F_INFINITY` | 65504.0 | | | |

The [ScreenDriver](./Drivers.md)'s circle routines use these (`F_PI`, `F_TWO_PI`, `F_EPSILON`).

---

## `malloc` - heap allocation

[`malloc.h`](../src/utils/malloc.h)

```c
int *malloc(int nWords);              // allocate nWords words from the .Heap segment
```

Backed by the `.Heap` segment (see [Memory Map](./Memory-Map.md)). Returns a
pointer to `nWords` contiguous words.
