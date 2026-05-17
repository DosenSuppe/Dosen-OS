#include "os_bridge.h"

/**
 * Prints a string.
 *
 * if newLine is set to 1, a new-line char will be added to the end.
 * if newLine is set to 0, no new-line char will be added to the end.
 */
void prints(int *str, int newLine) {
    int i = 0;

    while (str[i] != 0) {
        tty_write_char(str[i]);
        i++;
    }

    if (newLine) {
        tty_write_char(0xA);
    }
}

void printi(int val, int newLine) {
    char result[10];
    
    int_to_decimal_string(val, result);
    prints(result, 0);

    if (newLine == 1) {
        tty_write_char(0xA); // new-line character
    }
}

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
        if (buf[i + 1] != str[i]) {
            return 0;
        }
        i++;
    }
    
    if (str[len]) {
        return 0;
    }
    
    return 1;
}

void int_to_decimal_string(int num, char *buffer) {
    char temp[10];
    int i = 0;
    int j = 0;
    int is_negative = 0;

    // Handle 0 explicitly
    if (num == 0) {
        buffer[0] = '0';
        buffer[1] = 0;
        return;
    }

    // Handle negative numbers (assuming signed 2's complement semantics)
    if (num < 0) {
        is_negative = 1;
        num = -num; 
        
        // Edge case: Minimum negative value -8388608
        // If your compiler/hardware overflows on `-num`, 
        // you may need to handle -8388608 as a special case.
        if (num < 0) { 
            // Manual fallback for -8388608
            buffer[0] = '-'; buffer[1] = '8'; buffer[2] = '3';
            buffer[3] = '8'; buffer[4] = '8'; buffer[5] = '6';
            buffer[6] = '0'; buffer[7] = '8'; buffer[8] = 0;
            return;
        }
    }

    // Extract digits from right to left into a temporary buffer
    while (num > 0) {
        int digit = num % 10;
        temp[i] = '0' + digit; // '0' is 48
        i = i + 1;
        num = num / 10;
    }

    // Append negative sign if needed
    if (is_negative) {
        buffer[j] = '-';
        j = j + 1;
    }

    // Reverse the temporary buffer into the final buffer
    while (i > 0) {
        i = i - 1;
        buffer[j] = temp[i];
        j = j + 1;
    }

    // Null terminate the string
    buffer[j] = 0;
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
