#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../../utils/stdio.h"

// Demo: ensure <name> exists, allocate a new block, write "Hi!" into it.
// Useful for verifying the FS layer end-to-end (alloc, non-contiguous block
// assignment, persistence across commands within a session).
void dofile(int argc, int **argv) {
    if (argc < 2) {
        prints("Invalid arguments. Expected at least 1! dofile <filename> ", 1);
        return;
    }

    const char *name = argv[1];
    const int nameLen = strLength(name);

    int *e = fs_find(name, nameLen);
    if (e == 0) {
        e = fs_create(name, nameLen);

        if (e == 0) {
            prints("dofile: cannot create", 1);
            return;
        }
    }

    int bid = fs_alloc_block(e);
    if (bid < 0) {
        prints("dofile: no free blocks", 1);
        return;
    }

    int *blk = fs_block_data(bid);
    blk[0] = 'H';
    blk[1] = 'i';
    blk[2] = '!';
    blk[3] = 0;

    prints("Wrote block ", 0);
    printi(bid, 0);
    prints(" to ", 0);

    int j = 0;
    while (j < nameLen) {
        tty_write_char(name[j]);
        j++;
    }

    tty_write_char(0xA);
}
