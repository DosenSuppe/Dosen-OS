#include "../shell_util.h"
#include "../os_bridge.h"

void ls(int argc, int **argv) {
    int *files = files_buffer();
    int count  = files[0];

    if (!count) {
        prints("No files.", 1);
        return;
    }

    prints("All files:", 1);

    for (int i = 0; i < count; i++) {
        int *file   = files[i + 1];
        int nameLen = file[0];

        printi(i, 0);
        prints(" : ", 0);

        // Filename is length-prefixed, not null-terminated, so prints() won't
        // work here — walk it by hand.
        for (int j = 0; j < nameLen; j++) {
            tty_write_char(file[j + 1]);
        }
        tty_write_char(0xA);
    }
}