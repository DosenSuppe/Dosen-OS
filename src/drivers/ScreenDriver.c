#include "../utils/float.h"
#include "../utils/math.h"

#define SCREEN_WIDTH 320
#define SCREEN_HEIGHT 200
#define PIXELS SCREEN_HEIGHT * SCREEN_WIDTH

// Framebuffer command ports live at byte offset 0xF0000+ in the slot. These are
// WORD indices into the (int*) framebuffer, so they're the byte offset / 4:
#define CLEAR_SCREEN_MODE 0x3C000   // clear  byte 0xF0000 -> index 0x3C000
#define FILL_SCREEN_MODE 0x3C001    // fill   byte 0xF0004 -> index 0x3C001
#define DOUBLE_BUFFER_MODE 0x3C002  // dblbuf byte 0xF0008 -> index 0x3C002
#define SWAP_MODE 0x3C003           // swap   byte 0xF000C -> index 0x3C003

#define PI 3.1415

// Framebuffer base: $MemDevice2.Start (0xD0000000)
// Pixel N at byte N*4 with byte-addressed int* arithmetic, 
// fb[N] indexes pixel N directly.
int *renderTarget(void) {
    asm("LDI REA, $MemDevice2.Start");
}

/**
 * DrawPixel:
 *  Draws a single pixel in given color.
 * 
 * @param x X-Coordinate of the pixel
 * @param y Y-Coordinate of the pixel
 * @param color 24bit color value
 *
 * @returns void
 */
void drawPixel(int x, int y, int color) {
    int *fb = renderTarget(); 
    fb[y * SCREEN_WIDTH + x] = color;
    return;
}

/**
 * Sets double buffered mode.
 * 
 * @param on setting-flag for double buffered mode
 */
void doubleBuffered(int on) {
    int *buf = renderTarget();
    buf[DOUBLE_BUFFER_MODE] = on;
    return;
}

/**
 * Present the screen buffer.
 */
void present(void) {
    int *buf = renderTarget();
    buf[SWAP_MODE] = 1;
    return;
}

/**
 * Copies another buffer into the render buffer.
 * 
 * @param src pointer of source buffer
 */
void drawBuffer(int *src) {
    int *des = renderTarget();

    for (int i=0; i<PIXELS; i++) {
        des[i] = src[i];
    }

    return;
}

/**
 * DrawRectangle:
 *  Draws a rectangle at x, y with size being w, h and given color.
 * 
 * @param x X-Coordinate of the pixel
 * @param y Y-Coordinate of the pixel
 * @param w width of the rectangle
 * @param h height of the rectangle
 * @param color 24bit color value
 * @param fill 0 => fill, 1 => outline
 * 
 * @returns void
 */
void drawRectangle(int x, int y, int w, int h, int color, int fill) {
    int *fb = renderTarget();

    for (int wi=0; wi < w; wi++) {
        for (int hi=0; hi < h; hi++) {
            int offsetX = x + wi;
            int offsetY = y + hi;
            fb[offsetY * SCREEN_WIDTH + offsetX] = color;
        }
    }

    return;
}

void _drawCircleOutline(int x, int y, float r, int color) {
    if (r <= F_EPSILON) return;
    int *fb = renderTarget();

    int numSteps = (int)(2.0f * F_PI * r * 1.5f);
    float angleStep = F_TWO_PI / numSteps;

    for (int i=0; i <= numSteps; i++) {
        float angle = i * angleStep;

        int px = (int)(x + r * cos(angle) + 0.5f);
        int py = (int)(y + r * sin(angle) + 0.5f);

        if (px >= 0 && px < SCREEN_WIDTH && py >= 0 && py < SCREEN_HEIGHT) {
            fb[py * SCREEN_WIDTH + px] = color;
        }
    }
}

void _drawCircleFilled(int x, int y, float r, int color) {
    int *buf = renderTarget();

    int minX = clamp((int)(x-r), 0, SCREEN_WIDTH-1);
    int maxX = clamp((int)(x+r), 0, SCREEN_WIDTH-1);
    int minY = clamp((int)(y-r), 0, SCREEN_HEIGHT-1);
    int maxY = clamp((int)(y+r), 0, SCREEN_HEIGHT-1);

    float rSquared = r * r;

    for (int py = minY; py <= maxY; py++) {
        float dy = (float)(py - y);
        float dy_squared = dy * dy; // Optimize: Calculate Y squared once per row!

        int base_idx = py * SCREEN_WIDTH;

        for (int px = minX; px <= maxX; px++) {
            float dx = (float)(px - x);

            if ((dx * dx) + dy_squared <= rSquared) {
                buf[base_idx + px] = color;
            }
        }
    }

    return;
}

/**
 * buildRGB:
 *  Builds a color using given R, G, and B values.
 * 
 * @param r Red value (0-255)
 * @param g Green value (0-255)
 * @param b Blue value (0-255)
 * 
 * @returns color
 */
int buildRGB(int r, int g, int b) {
    int color = r;
    
    color <<= 8;
    color |= g;
    color <<= 8;
    color |= b;

    return color;
}

/**
 * DrawCircle:
 *  Draws a circle.
 * 
 * @param x X-Coordinate of the pixel
 * @param y Y-Coordinate of the pixel
 * @param r Radius of the circle
 * @param color 24bit color value
 * @param mode 0 => fill, 1 => outline
 * 
 * @returns void
 */
void drawCircle(int x, int y, float r, int color, int mode) {
    if (mode == 0) {
        // fill the circle
        _drawCircleFilled(x, y, r, color);
    } else {
        // outline only
        _drawCircleOutline(x, y, r, color);
    }
}

/**
 * ClearScreen:
 *  Clears the screen (to black).
 * 
 * @returns void
 */
void clearScreen() {
    int *fb = renderTarget();

    fb[CLEAR_SCREEN_MODE] = 1;

    return;
}

/**
 * FillScreen:
 *  Fills the entire screen with the provided color.
 * 
 * @param color 24bit color value
 * @returns void
 */
void fillScreen(int color) {
    int *fb = renderTarget();

    fb[FILL_SCREEN_MODE] = color;

    return;
}
