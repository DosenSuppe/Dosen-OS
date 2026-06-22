#include "../utils/stdio.h"
#include "../utils/string.h"
#include "../shell/fs.h"
#include "../drivers/ScreenDriver.h"

#define DATA_OFFSET 0xA
#define COLORS_USED 0x2E
#define COLOR_TABLE 0x36
#define WIDTH 0x12
#define HEIGHT 0x16
#define BITS_PER_PIXEL 0x1C

/**
 * Reads a bit of an integer element.
 * 
 * @param data pointer for the data
 * @param offset offset relative to data
 * @param bitIdx index of the bit (right to left)
 * 
 * @returns value of bit
 */
int _readBit(int *data, int offset, int bitIdx) {
    return (data[offset] >> bitIdx) & 1;
}

/**
 * Packs integers into a single value. 
 * 
 * @param data pointer for the data
 * @param offset offset relative to data
 * @param size how many bytes to pack 
 * 
 * @returns packed byte
 */
int _packBytes(int *data, int offset, int size) {
    int packedBytes = 0;
    
    for (int i = 0; i < size; i++) {
        packedBytes |= ((data[offset + i] & 0xFF) << (i * 8));
    }
    
    return packedBytes;
}

/**
 * Get the color from byte data.
 * 
 * @param data pointer for the data
 * @param colorIdx color index (relative to color table)
 * 
 * @returns color value
 */
int _getColor(int *data, int colorIdx) {
    // we skip the 4th byte. Value should look like: 0x--RRGGBB
    return _packBytes(&data[COLOR_TABLE + (colorIdx * 4)], 0, 3);
}

/**
 * entry function for the bitmap program
 */
void bitmap(int argc, int **argv) {
    if (argc < 2) {
        prints("Bitmap requires a filename to run! bmp <filename> ", 1);
        return;
    }

    int *filename = argv[1];
    int nameSize = stringLen(filename);
    int *file = fs_find(filename, nameSize);

    if (!file) {
        prints("Bitmap could not find file: ", 0);
        prints(filename, 1);
        return;
    }

    int *fileData = fs_data_ptr(file);

    if (!fileData) {
        prints("Bitmap could not find data for file: ", 0);
        prints(filename, 1);
        return;
    }

    int imgWidth = _packBytes(fileData, WIDTH, 4);
    int imgHeight = _packBytes(fileData, HEIGHT, 4);
    int bitsPerPixel = _packBytes(fileData, BITS_PER_PIXEL, 2);

    int dataOffset = _packBytes(fileData, DATA_OFFSET, 4);
    int rowSize = ((imgWidth * bitsPerPixel + 31) / 32) * 4;

    clearScreen();

    for (int y = 0; y < imgHeight; y++) {
        int invertedY = (imgHeight - 1) - y;
        
        int rowStartOffset = dataOffset + (invertedY * rowSize);

        for (int x = 0; x < imgWidth; x++) {
            int byteOffsetForPixel = x / 8;
            int totalByteOffset = rowStartOffset + byteOffsetForPixel;
            
            int bitIdx = 7 - (x % 8);
            
            int colorIdx = _readBit(fileData, totalByteOffset, bitIdx);
            int color = _getColor(fileData, colorIdx);

            drawPixel(x, y, color);
        }
    }

    present();
}