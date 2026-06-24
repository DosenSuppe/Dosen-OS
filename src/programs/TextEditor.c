#include "../shell/fs.h"
#include "../shell/os_bridge.h"
#include "../utils/stdio.h"
#include "../utils/string.h"
#include "../shell/shell.h"

#define KEY_BACKSPACE 0x8
#define KEY_ENTER     0xA
#define KEY_ESC       0x1B

#define CURSOR_CHAR   0x5F   // '_' drawn at the (end-of-buffer) cursor

// Working buffer: a flat copy of the file, one char per word, '\n' (0xA) as the
// line separator. The cursor is always editLength. As of now, there is no arrow
// keys support to move it.
#define EDIT_MAX 1024

int editBuffer[EDIT_MAX];
int editLength;
int editName[64];            // null-terminated copy of the filename
int editDirty;               // 1 => the screen needs a redraw on the next tick

// Copy argv[1] into editName so we still know the target once the shell's argv
// goes away.
void _copyName(int *name) {
    int i = 0;
    while (name[i] != 0 && i < 60) {
        editName[i] = name[i];
        i++;
    }
    editName[i] = 0;
}

// Load the file's contents into editBuffer. Missing file => start empty (it's
// created on save).
void _load() {
    editLength = 0;

    int *entry = fs_find(editName, stringLen(editName));
    if (entry == 0) {
        return;
    }

    int size = entry[1];
    int *data = fs_data_ptr(entry);

    int i = 0;
    while (i < size && i < EDIT_MAX) {
        int ch = data[i];
        if (ch == 0) {
            break;
        }
        editBuffer[i] = ch;
        i++;
    }
    editLength = i;
}

// Flush editBuffer back to the file, creating it if needed, and mark the slot
// dirty so the host persists it.
void _save() {
    int nameLen = stringLen(editName);

    int *entry = fs_find(editName, nameLen);

    if (entry == 0) {
        entry = fs_create(editName, nameLen);

        if (entry == 0) {
            return;
        }
    }

    int *data = fs_data_ptr(entry);
    int i = 0;

    while (i < editLength) {
        data[i] = editBuffer[i];
        i++;
    }
    
    if (i < EDIT_MAX) {
        data[i] = 0;
    }

    entry[1] = editLength;
    fs_mark_dirty(entry);
}

// Redraw the whole screen: a status header, then the buffer, then the cursor.
// The TTY auto-scrolls to the end, so the cursor stays in view.
void _render(void) {
    ttyClearScreen();

    prints("-- EDIT ", 0);
    prints(editName, 0);
    prints(" --  ESC:save&exit  ENTER:newline  BKSP:delete", 1);

    int i = 0;
    while (i < editLength) {
        ttyWriteChar(editBuffer[i]);
        i++;
    }

    ttyWriteChar(CURSOR_CHAR);
}

void noop() {
    return;
}

void main() {
    if (editDirty) {
        _render();
        editDirty = 0;
    }

    char ch = ttyReadChar();
    if (ch == 0) {
        return;                // nothing pending; we'll be called again
    }

    if (ch == KEY_ESC) {
        _save();
        popProc();             // restore the shell process
        shellInitialize();     // and its prompt
        return;
    }

    if (ch == KEY_BACKSPACE) {
        if (editLength > 0) {
            editLength--;
        }
        editDirty = 1;
        return;
    }

    if (ch == KEY_ENTER) {
        if (editLength < EDIT_MAX - 1) {
            editBuffer[editLength] = KEY_ENTER;
            editLength++;
        }
        editDirty = 1;
        return;
    }

    if (editLength < EDIT_MAX - 1) {
        editBuffer[editLength] = ch;
        editLength++;
    }
    editDirty = 1;
}

void texteditor(int argc, int **argv) {
    if (argc < 2) {
        prints("edit: usage: run edit <file>", 1);
        return;
    }

    _copyName(argv[1]);
    _load();
    editDirty = 1;

    pushProc(main, noop);
}
