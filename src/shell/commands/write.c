#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"

// Usage: write <name> <text>
//
// Overwrites <name>'s contents with <text>. File must already exist
// (use touch / dofile first). Blocks are reallocated from scratch.
void cmd_write(int *args, int args_len) {
    int sp;
    int name_len;
    int text_len;
    int *text;
    int *e;
    int written;
    int i;
    int bid;
    int *blk;

    if (args == 0 || args_len <= 0) {
        prints("write: missing filename", 1);
        return;
    }

    sp = 0;
    while (sp < args_len && args[sp] != 0x20) {
        sp = sp + 1;
    }

    if (sp >= args_len) {
        prints("write: missing text", 1);
        return;
    }

    name_len = sp;
    text     = &args[sp + 1];
    text_len = args_len - sp - 1;

    e = fs_find(args, name_len);
    if (e == 0) {
        prints("write: not found (touch it first)", 1);
        return;
    }

    fs_free_blocks(e);

    written = 0;
    while (written < text_len) {
        bid = fs_alloc_block(e);
        if (bid < 0) {
            prints("write: out of blocks", 1);
            return;
        }
        blk = fs_block_data(bid);

        i = 0;
        while (i < 64) {
            blk[i] = 0;
            i = i + 1;
        }

        i = 0;
        while (i < 64 && written < text_len) {
            blk[i] = text[written];
            written = written + 1;
            i = i + 1;
        }
    }

    prints("Wrote ", 0);
    printi(text_len, 0);
    prints(" chars.", 1);
}
