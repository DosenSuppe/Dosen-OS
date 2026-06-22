#pragma once

extern void clearScreen();

extern void drawPixel(int x, int y, int color);
extern void fillScreen(int color);
extern void drawRectangle(int x, int y, int w, int h, int color);
extern void drawCircle(int x, int y, float r, int color, int mode);

extern void drawSprite(int x, int y, int spriteOffset);

extern int buildRGB(int r, int g, int b);

extern int *renderTarget(void);
extern void drawBuffer(int *src);
extern void doubleBuffered(int on);
extern void present(void);
