#include "../shell/fs.h"
#include "../utils/stdio.h"
#include "../utils/string.h"
#include "../drivers/ScreenDriver.h"

#define SCREEN_WIDTH 320

/**
 * Validates a file and return's it data pointer if found, else 0.
 * 
 * @param filename pointer for the filename string
 * 
 * @returns pointer for the file data
 */
int *_validateFile(int *filename) {
    int *fileEntry = fs_find(filename, stringLen(filename));

    if (fileEntry == 0) {
        prints("Dibmap: File not found!", 1);
        return 0;
    }

    int *fileData = fs_data_ptr(fileEntry);

    if (fileData == 0) {
        prints("Dibmap: Invalid file data!", 1);
        return 0;
    }

    return fileData;
}

/**
 * Packs two bytes into one value.
 * 
 * @param ptr pointer of the first byte to index
 * 
 * @returns value of packed bytes
 */
int _pack2(int *ptr) {
    int val = ptr[0];
    val <<= 8;
    val |= ptr[1];
    return val;
}

// Draws a [spanX x spanY] window of the image, with its top-left at source
// pixel (srcX, srcY), onto the screen at (posX, posY) magnified by `scale`.
// ImageData is always full-image row-major, so both the whole-image and the
// single-chunk paths are just different windows into it.
void _drawRegion(int *data, int posX, int posY, int scale,
                 int srcX, int srcY, int spanX, int spanY) {
    int sizeX = _pack2(&data[1]);
    int sizeY = _pack2(&data[3]);

    int colorPtrOff = _pack2(&data[7]);
    int imagePtrOff = _pack2(&data[9]);

    int *colorData = &data[colorPtrOff];
    int *imageData = &data[imagePtrOff];

    if (scale < 1) {
        scale = 1;
    }

    int *buf = renderTarget();

    for (int y=0; y<spanY; y++) {
        int imgY = srcY + y;
        if (imgY >= sizeY) {
            continue;
        }

        int srcRow = imgY * sizeX;
        int dstRow = (posY + y * scale) * SCREEN_WIDTH + posX;

        for (int x=0; x<spanX; x++) {
            int imgX = srcX + x;
            if (imgX >= sizeX) {
                continue;
            }

            int index = imageData[srcRow + imgX];
            int *colorPtr = &colorData[index * 3];
            int color = buildRGB(colorPtr[0], colorPtr[1], colorPtr[2]);

            int rowStart = dstRow + x * scale;

            for (int sy=0; sy<scale; sy++) {
                for (int sx=0; sx<scale; sx++) {
                    buf[rowStart + sx] = color;
                }

                rowStart = rowStart + SCREEN_WIDTH;
            }
        }
    }

    return;
}

/**
 * Renders an entire Dibmap-file ignoring chunk data.
 * 
 * @param filename pointer for the filename string
 * @param posX X position for drawing the dibmap
 * @param posY Y position for drawing the dibmap
 * @param scale Scale of the dibmap image
 * 
 * @returns void
 */
void renderDIBmap(int *filename, int posX, int posY, int scale) {
    int *data = _validateFile(filename);

    if (data == 0) {
        return;
    }

    int sizeX = _pack2(&data[1]);
    int sizeY = _pack2(&data[3]);

    _drawRegion(data, posX, posY, scale, 0, 0, sizeX, sizeY);
}

/**
 * Renders a single chunk of a dibmap image. If the dibmap file has no chunk-data
 * it will fallback to rendering the entire dibmap image.
 * 
 * @param filename pointer for the filename string
 * @param posX X position for drawing the dibmap chunk
 * @param posY Y position for drawing the dibmap chunk
 * @param scale Scale of the dibmap chunk image
 * @param offset chunk index from the whole dibmap image starting 0
 * 
 * @return void
 */
void renderDIBmapOffset(int *filename, int posX, int posY, int scale, int offset) {
    int *data = _validateFile(filename);

    if (data == 0) {
        return;
    }

    int sizeX = _pack2(&data[1]);
    int sizeY = _pack2(&data[3]);

    int chunkPtr = _pack2(&data[5]);

    // Default window: the whole image.
    int srcX = 0;
    int srcY = 0;
    int spanX = sizeX;
    int spanY = sizeY;

    if (chunkPtr != 0) {
        int *chunkData = &data[chunkPtr];
        int chunkX = _pack2(&chunkData[0]);
        int chunkY = _pack2(&chunkData[2]);

        if (chunkX > 0 && chunkY > 0) {
            int chunksPerRow = sizeX / chunkX;
            if (chunksPerRow < 1) {
                chunksPerRow = 1;
            }

            srcX = (offset % chunksPerRow) * chunkX;
            srcY = (offset / chunksPerRow) * chunkY;
            spanX = chunkX;
            spanY = chunkY;
        }
    }

    _drawRegion(data, posX, posY, scale, srcX, srcY, spanX, spanY);
}

void dibmap(int argc, int **argv) {
    if (argc < 2) {
        prints("DIBmapReader: usage: run DIBmapReader <file>", 1);
        return;
    }

    // argv0 is the "dibmap" program name
    renderDIBmap(argv[1], 0, 0, 1);
}
