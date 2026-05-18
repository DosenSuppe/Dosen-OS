#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../editor.h"

// Usage: edit <name>
//
// Enters the line-append editor. File is created if it doesn't exist;
// otherwise its current contents are preloaded into the draft. See
// editor.h for the sentinel commands.
void cmd_edit(int *name, int name_len) {
    if (name == 0 || name_len <= 0) {
        prints("edit: missing filename", 1);
        return;
    }
    if (name_len > 12) {
        prints("edit: filename too long (max 12)", 1);
        return;
    }

    int *e = fs_find(name, name_len);
    if (e == 0) {
        e = fs_create(name, name_len);
        if (e == 0) {
            prints("edit: cannot create (no free slots)", 1);
            return;
        }
    }

    prints("Editing ", 0);
    int i = 0;
    while (i < name_len) {
        tty_write_char(name[i]);
        i = i + 1;
    }
    prints(" -- '.' saves, '!q' cancels, '!c' clears.", 1);

    editor_start(name, name_len);
    editor_print_draft();
}
