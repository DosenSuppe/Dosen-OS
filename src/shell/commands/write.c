#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../../utils/stdio.h"

// Usage: write <name> <text>
//
// Overwrites <name>'s contents with <text>. File must already exist
// (use touch / dofile first). Blocks are reallocated from scratch.
void write(int argc, int **argv) {
    if (argc < 3) {
        prints("write: usage: write <name> <text>", 1);
        return;
    }

    const char *name = argv[1];
    const char *text = argv[2];

    const int nameLen = strLength(name);
    const int textLen = strLength(text);

    int *e = fs_find(name, nameLen);
    if (e == 0) {
        prints("write: not found (touch it first)", 1);
        return;
    }

    fs_free_blocks(e);

    int written = 0;
    int i = 0;
    while (written < textLen) {
        const int bid = fs_alloc_block(e);

        if (bid < 0) {
            prints("write: out of blocks", 1);
            return;
        }
        
        int *blk = fs_block_data(bid);

        i = 0;
        while (i < 64) {
            blk[i] = 0;
            i++;
        }

        i = 0;
        while (i < 64 && written < textLen) {
            blk[i] = text[written];
            written = written + 1;
            i++;
        }
    }

    prints("Wrote ", 0);
    printi(textLen, 0);
    prints(" chars.", 1);
}
