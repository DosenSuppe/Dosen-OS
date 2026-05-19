#include "os_bridge.h"
#include "../utils/stdio.h"

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
 * Returns the pointer for the commands buffer.
 */
int *commands_buffer(void) {
    asm("LDI REA, $CommandCharacterBuffer.Start");
}

/**
 * Returns the pointer for the files buffer.
 */
int *files_buffer(void) {
    asm("LDI REA, $FilenameStorage.Start");
}
