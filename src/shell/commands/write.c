#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../../utils/stdio.h"
#include "../../utils/string.h"

const int WRITE_MAX_FILE_BYTES = 0x1000;

// Usage: write <name> <text>
//
// Overwrites <name>'s contents with <text>. File must already exist
// (use touch first). Marks the slot DIRTY so the host flushes it within ~250ms.
void write(int argc, int **argv) {
    if (argc < 3) {
        prints("write: usage: write <name> <text>", 1);
        return;
    }

    const char *name = argv[1];
    const char *text = argv[2];

    const int nameLen = stringLen(name);
    const int textLen = stringLen(text);

    int *e = fs_find(name, nameLen);
    if (e == 0) {
        prints("write: not found (touch it first)", 1);
        return;
    }

    int limit = textLen;
    if (limit > WRITE_MAX_FILE_BYTES) { limit = WRITE_MAX_FILE_BYTES; }

    int *data = fs_data_ptr(e);
    int i = 0;
    while (i < limit) {
        data[i] = text[i];
        i++;
    }
    if (i < WRITE_MAX_FILE_BYTES) {
        data[i] = 0;
    }

    e[1] = limit;
    fs_mark_dirty(e);

    prints("Wrote ", 0);
    printi(limit, 0);
    prints(" chars.", 1);
}
