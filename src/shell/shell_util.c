#include "os_bridge.h"
#include "../utils/stdio.h"

const int CHAR_SPACE = 0x20;

// Returns 1 iff str (null-terminated) equals the first `len` chars of buf.
// The trailing-null check on str catches "str is longer than expected" so the
// caller doesn't have to length-check both sides.
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

// Splits `str` in-place on spaces, populating argv with pointers to each token
// and setting *argc. Modifies str (replaces spaces with NULs).
void tokenize(char *str, int *argc, int **argv) {
    int i = 0;
    int inToken = 0;
    *argc = 0;

    while (str[i] != '\0') {
        if (str[i] == CHAR_SPACE) {
            str[i] = 0;
            inToken = 0;
        } else if (!inToken) {
            argv[*argc] = &str[i];
            (*argc)++;
            inToken = 1;
        }
        i++;
    }
}

int strLength(int *str) {
    int i;
    for (i = 0; str[i] != '\0'; i++) {}
    return i;
}
