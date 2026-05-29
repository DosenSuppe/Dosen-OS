#include "../shell_util.h"
#include "../fs.h"
#include "../../utils/stdio.h"

void touch(int argc, int **argv) {
    if (argc < 2) {
        prints("touch: missing filename", 1);
        return;
    }

    const char *name = argv[1];
    const int nameLen = strLength(name);

    if (nameLen > 60) {
        prints("touch: filename too long (max 60)", 1);
        return;
    }

    if (fs_find(name, nameLen) != 0) {
        prints("touch: already exists", 1);
        return;
    }

    int *e = fs_create(name, nameLen);
    if (e == 0) {
        prints("touch: no free slots", 1);
        return;
    }

    prints("Created.", 1);
}
