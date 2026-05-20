#include "os_bridge.h"
#include "../utils/stdio.h"

const int CHAR_SPACE = 0x20;

void print_not_impl(int *str) {
    prints(str, 0);
    prints(": TODO", 1);
}

/**
 * Checks if the given values matches the given buffer values
 */
int matches(int *buf, int len, int *str) {
    int i = 0;
    
    while (i < len) {
        if (buf[i] != str[i]) {
            return 0;
        }
        i++;
    }
    
    if (str[len]) {
        return 0;
    }
    
    return 1;
}

/**
 * Returns the pointer for the files buffer.
 */
int *files_buffer(void) {
    asm("LDI REA, $FilenameStorage.Start");
}

/**
 * Tokenizes given string and updates argc and argv accordingly.
 * 
 */
void tokenize(char *str, int *argc, int **argv) {
    int i = 0;
    int inToken = 0;
    *argc = 0;

    while (str[i] != '\0') {
        if (str[i] == CHAR_SPACE) {
            str[i] = 0;                   // terminate current token (if any)
            inToken = 0;
        } else if (!inToken) {
            argv[*argc] = &str[i];        // entering a new token - record start
            (*argc)++;
            inToken = 1;
        }
        i++;
    }
}

/**
 * Counts the length of given string.
 * 
 * @returns Length of given string
 */
int strLength(int *str) {
    int i;
    for (i = 0; str[i] != '\0'; i++) {}
    return i;
}
