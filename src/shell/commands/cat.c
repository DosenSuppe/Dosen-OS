#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../../utils/stdio.h"

const int CHAR_ENTER = 0xA;

// Print the file's contents to TTY. Stops at the first NUL byte if encountered,
// otherwise prints up to block_count * 64 chars.
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

    int bc = e[16];
    if (bc == 0) {
        prints("(file is empty)", 1);
        return;
    }

    int b = 0;
    while (b < bc) {
        int *blk = fs_block_data(e[17 + b]);
        int i = 0;
    
        while (i < 64) {
            int ch = blk[i];
    
            if (ch == 0) {
                tty_write_char(CHAR_ENTER);
                return;
            }
    
            tty_write_char(ch);
    
            i++;
        }
    
        b++;
    }

    tty_write_char(CHAR_ENTER);
}
