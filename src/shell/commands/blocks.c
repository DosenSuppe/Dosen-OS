#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../../utils/stdio.h"

// Visualizes the block pool: which of the 32 blocks are allocated and which
// file slot (0..7) owns each. Free blocks render as '.'; a block flagged
// used in the header but unclaimed by any slot renders as '?' (shouldn't
// happen — useful as an FS sanity check).
//
// Layout matches fs.h:
//   buf[0]      = file_count
//   buf[1..32]  = block_used[32]
//   buf[33..]   = entries[8], 25 words each
void blocks(int argc, int **argv) {
    int *buf;
    int *e;
    int owner[32];
    int i;
    int j;
    int k;
    int slot;
    int off;
    int bc;
    int bid;
    int used;
    int row;
    int col;
    int o;
    int any;
    int nl;

    buf = files_buffer();

    i = 0;
    while (i < 32) {
        owner[i] = 0 - 1;
        i++;
    }

    slot = 0;
    while (slot < 8) {
        off = 33 + slot * 25;
        e = &buf[off];
        
        if (e[0] == 1) {
        
            bc = e[16];
            k  = 0;
        
            while (k < bc) {
                bid = e[17 + k];
                if (bid >= 0) {
                    if (bid < 32) {
                        owner[bid] = slot;
                    }
                }
                k++;
            }
        }
        slot++;
    }

    used = 0;
    i = 0;
    while (i < 32) {
        if (buf[1 + i] != 0) {
            used++;
        }
        i++;
    }

    prints("Block map (32 blocks x 64 words):", 1);

    row = 0;
    while (row < 4) {
        col = 0;

        while (col < 8) {
            bid = row * 8 + col;

            if (bid < 10) {
                tty_write_char(' ');
            }

            printi(bid, 0);
            tty_write_char(':');
            
            o = owner[bid];
            
            if (o < 0) {
                if (buf[1 + bid] != 0) {
                    tty_write_char('?');
                } else {
                    tty_write_char('.');
                }
            } else {
                tty_write_char('0' + o);
            }

            tty_write_char(' ');
            col++;
        }

        tty_write_char(0xA);
        row++;
    }

    prints("Used: ", 0);
    printi(used, 0);
    prints("/32  Free: ", 0);
    printi(32 - used, 0);
    tty_write_char(0xA);

    any  = 0;
    slot = 0;
    while (slot < 8) {
        off = 33 + slot * 25;
        e = &buf[off];

        if (e[0] == 1) {
            if (any == 0) {
                prints("Files:", 1);
                any = 1;
            }

            tty_write_char(' ');
            tty_write_char('0' + slot);
            prints(": ", 0);

            nl = e[1];
            j = 0;

            while (j < nl) {
                tty_write_char(e[2 + j]);
                j++;
            }

            while (j < 12) {
                tty_write_char(' ');
                j++;
            }

            prints("  blocks: ", 0);
            bc = e[16];

            if (bc == 0) {
                prints("(none)", 0);
            } else {
                k = 0;

                while (k < bc) {
                    if (k > 0) {
                        prints(", ", 0);
                    }
                    printi(e[17 + k], 0);
                    k++;
                }
            }
            tty_write_char(0xA);
        }

        slot++;
    }
}
