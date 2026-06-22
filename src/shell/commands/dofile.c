#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../../utils/stdio.h"
#include "../../utils/string.h"

// Demo: ensure <name> exists, write "Hi!" to it, flush.
// Useful for verifying the FS end-to-end (slot allocation, data write, host flush).
void dofile(int argc, int **argv) {
    if (argc < 2) {
        prints("Invalid arguments. Expected at least 1! dofile <filename> ", 1);
        return;
    }

    const char *name = argv[1];
    const int nameLen = stringLen(name);

    int *e = fs_find(name, nameLen);
    if (e == 0) {
        e = fs_create(name, nameLen);
        if (e == 0) {
            prints("dofile: cannot create", 1);
            return;
        }
    }

    int *data = fs_data_ptr(e);
    data[0] = 'H';
    data[1] = 'i';
    data[2] = '!';
    data[3] = 0;
    e[1] = 3;
    fs_mark_dirty(e);

    prints("Wrote 'Hi!' to ", 0);
    int j = 0;
    while (j < nameLen) {
        ttyWriteChar(name[j]);
        j++;
    }
    ttyWriteChar(0xA);
}
