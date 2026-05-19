#include "../shell_util.h"
#include "../fs.h"
#include "../../utils/stdio.h"

void del(int argc, int **argv) {
    if (argc < 2) {
        prints("Invalid arguments. Expected at least 1! del <filename> ", 1);
        return;
    }
    
    const char *name = argv[1];
    if (name == 0) {
        prints("del: missing filename", 1);
        return;
    }

    const int nameLen = strLength(name);

    if (fs_delete(name, nameLen) == 0) {
        prints("File ", 0);
        prints(name, 0);
        prints(" not found! File not deleted!", 1);
        return;
    }

    prints("File deleted.", 1);
}
