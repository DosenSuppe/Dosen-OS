#include "../shell_util.h"
#include "../fs.h"
#include "../../utils/stdio.h"

void touch(int *name, int name_len) {
    if (name == 0 || name_len <= 0) {
        prints("touch: missing filename", 1);
        return;
    }
    
    if (name_len > 12) {
        prints("touch: filename too long (max 12)", 1);
        return;
    }

    if (fs_find(name, name_len) != 0) {
        prints("touch: already exists", 1);
        return;
    }

    int *e = fs_create(name, name_len);
    if (e == 0) {
        prints("touch: no free slots", 1);
        return;
    }

    prints("Created.", 1);
}
