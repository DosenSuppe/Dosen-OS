// Don't include NewScreenDriver.h here — cc.py treats `extern void DrawPixel`
// from the header as a redeclaration of the definition below.

#define SCREEN_WIDTH 320
#define CLEAR_SCREEN_MODE 0xF0000
#define FILL_SCREEN_MODE 0xF0001

#define PI 3.1415

// Framebuffer base — $MemDevice2.Start (0xA00000). One word per pixel, row-major.
int *framebufferBase(void) {
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
void DrawPixel(int x, int y, int color) {
    int *fb = framebufferBase();
    
    fb[y * SCREEN_WIDTH + x] = color;

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
void DrawRectangle(int x, int y, int w, int h, int color, int fill) {
    int *fb = framebufferBase();

    for (int wi=0; wi < w; wi++) {
        for (int hi=0; hi < h; hi++) {
            int offsetX = x + wi;
            int offsetY = y + hi;
            fb[offsetY * SCREEN_WIDTH + offsetX] = color;
        }
    }

    return;
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
void DrawCircle(int x, int y, int r, int color, int mode) {
    int cx = 0;
    int cy = r;
    int d = 1 - r;

    if (mode == 0) {
        // fill the circle

    } else {
        // outline only

        while (cy >= cx) {
            DrawPixel(x + cx, y + cy, color);
            DrawPixel(x - cx, y + cy, color);
            DrawPixel(x + cx, y - cy, color);
            DrawPixel(x - cx, y - cy, color);

            DrawPixel(x + cy, y + cx, color);
            DrawPixel(x - cy, y + cx, color);
            DrawPixel(x + cy, y - cx, color);
            DrawPixel(x - cy, y - cx, color);

            
            if (d > 0) {
                d = d + 4 * (cx - cy) + 10;
                cy--;
            } else {
                d = d + 4 * cx + 6;
            }

            cx++;
        }
    }
}

/**
 * ClearScreen:
 *  Clears the screen (to black).
 * 
 * @returns void
 */
void ClearScreen() {
    int *fb = framebufferBase();

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
void FillScreen(int color) {
    int *fb = framebufferBase();

    fb[FILL_SCREEN_MODE] = color;

    return;
}
