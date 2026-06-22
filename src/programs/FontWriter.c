#include "./DIBmapReader.h"
#include "../utils/stdio.h"
#include "../drivers/ScreenDriver.h"
#include "../utils/string.h"

#define CHAR_START 0x61
#define CHAR_END 0x7A

#define CHAR_SPACE 0x20

#define DIGIT_START 0x30
#define DIGIT_END 0x39
#define DIGIT_OFFSET 26

#define SCALE 1
#define SIZE 8
#define SPACING 1

/**
 * Renders a single character to the screen.
 * 
 * @param character Character to be rendered to the screen
 * @param x X position of the character
 * @param y Y position of the character
 * 
 * @return void
 */
void renderChar(char character, int x, int y) {
    int offset;

    if (character >= CHAR_START && character <= CHAR_END) {
        offset = character - CHAR_START;
    } else if (character >= DIGIT_START && character <= DIGIT_END) {
        if (character == DIGIT_START) {
            offset = character - DIGIT_START + DIGIT_OFFSET + 9; // 0 comes after 9 instead of before 1 in the current Font.dib file
        } else {
            offset = character - DIGIT_START + DIGIT_OFFSET - 1;
        }
    } else if (character == CHAR_SPACE) {
        offset = 59;
    } else {
        offset = 41; // character not found char
    }

    renderDIBmapOffset("Font.dib", x, y, SCALE, offset);

    return;
}

/**
 * Renders a given String to the screen using the Font.dib dibmap.
 * 
 * @param str pointer for the string
 * @param x X starting position of the text
 * @param y Y starting position of the text
 * 
 * @returns void
 */
void renderText(int *str, int x, int y) {
    int strLen = stringLen(str);

    for (int i=0; i<strLen; i++) {
        int posX = x + i * (SIZE + SPACING) * SCALE;
        renderChar(str[i], posX, y);
    }

    return;
}

/**
 * Entry function for the fontwriter program
 */
void fontwriter(int argc, int **argv) {
    renderChar(*argv[1], 10, 10);
}
