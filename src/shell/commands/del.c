#include "../shell_util.h"
#include "../fs.h"

void cmd_del(int *name, int name_len) {
    if (name == 0 || name_len <= 0) {
        prints("del: missing filename", 1);
        return;
    }

    if (fs_delete(name, name_len) == 0) {
        prints("del: not found", 1);
        return;
    }

    prints("Deleted.", 1);
}
