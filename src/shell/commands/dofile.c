#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"

// Demo: ensure <name> exists, allocate a new block, write "Hi!" into it.
// Useful for verifying the FS layer end-to-end (alloc, non-contiguous block
// assignment, persistence across commands within a session).
void dofile(int *name, int name_len) {
    if (name == 0 || name_len <= 0) {
        prints("dofile: missing filename", 1);
        return;
    }

    int *e = fs_find(name, name_len);
    if (e == 0) {
        e = fs_create(name, name_len);
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
    while (j < name_len) {
        tty_write_char(name[j]);
        j++;
    }

    tty_write_char(0xA);
}
