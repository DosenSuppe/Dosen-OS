#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../../utils/stdio.h"

const int CHAR_ENTER = 0xA;

// Print the file's contents to TTY.
void cat(int argc, int **argv) {
    if (argc < 2) {
        prints("Invalid arguments. Expected at least 1! cat <filename> ", 1);
        return;
    }

    const char *name = argv[1];
    const int nameLen = strLength(name);

    int *e = fs_find(name, nameLen);
    if (e == 0) {
        prints("File not found!", 1);
        return;
    }

    int size = e[1];
    if (size == 0) {
        prints("(file is empty)", 1);
        return;
    }

    int *data = fs_data_ptr(e);
    int i = 0;
    while (i < size) {
        int ch = data[i];
        if (ch == 0) { break; }
        ttyWriteChar(ch);
        i++;
    }

    ttyWriteChar(CHAR_ENTER);
}
