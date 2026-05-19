#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../../utils/stdio.h"

void ls(int argc, int **argv) {
    int count = fs_file_count();

    if (count == 0) {
        prints("No files.", 1);
        return;
    }

    prints("All files:", 1);

    int i = 0;
    while (i < count) {
        int *entry  = fs_entry_by_idx(i);
        int nameLen = entry[1];

        printi(i, 0);
        prints(" : ", 0);

        int j = 0;
        while (j < nameLen) {
            tty_write_char(entry[2 + j]);
            j++;
        }

        prints(" (", 0);
        printi(entry[16], 0);
        prints(" blocks)", 1);

        i++;
    }
}
