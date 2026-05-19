#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../../utils/stdio.h"

// Print the file's contents to TTY. Stops at the first NUL byte if encountered,
// otherwise prints up to block_count * 64 chars.
void cat(int *name, int name_len) {
    if (name == 0 || name_len <= 0) {
        prints("cat: missing filename", 1);
        return;
    }

    int *e = fs_find(name, name_len);
    if (e == 0) {
        prints("cat: not found", 1);
        return;
    }

    int bc = e[16];
    if (bc == 0) {
        prints("(empty)", 1);
        return;
    }

    int b = 0;
    while (b < bc) {
        int *blk = fs_block_data(e[17 + b]);
        int i = 0;
    
        while (i < 64) {
            int ch = blk[i];
    
            if (ch == 0) {
                tty_write_char(0xA);
                return;
            }
    
            tty_write_char(ch);
    
            i++;
        }
    
        b++;
    }

    tty_write_char(0xA);
}
