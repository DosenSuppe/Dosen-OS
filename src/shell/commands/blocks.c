#include "../shell_util.h"
#include "../os_bridge.h"
#include "../fs.h"
#include "../../utils/stdio.h"

// FS debug view: walks all 64 device slots, shows status + name + size.
// Status codes match the PermaStorageDevice protocol:
//   P = present (1)   D = dirty / pending flush (2)
void blocks(int argc, int **argv) {
    int *e;
    int st;
    int nameLen;
    int j;
    int used = 0;
    int dirty = 0;
    int slot = 0;

    while (slot < 64) {
        e = fs_entry_by_slot(slot);
        st = e[0];

        if (st != 0) { used++; }
        if (st == 2) { dirty++; }

        slot++;
    }

    prints("Slots used: ", 0);
    printi(used, 0);
    prints("/64  Dirty: ", 0);
    printi(dirty, 0);
    ttyWriteChar(0xA);

    if (used == 0) { return; }

    prints("Files:", 1);

    slot = 0;
    while (slot < 64) {
        e = fs_entry_by_slot(slot);
        st = e[0];

        if (st != 0) {
            ttyWriteChar(' ');
            if (slot < 10) { ttyWriteChar(' '); }
            printi(slot, 0);
            prints(": ", 0);

            if (st == 2) {
                ttyWriteChar('D');
            } else {
                ttyWriteChar('P');
            }
            ttyWriteChar(' ');

            nameLen = fs_name_length(e);
            j = 0;
            while (j < nameLen) {
                ttyWriteChar(e[4 + j]);
                j++;
            }

            prints("  (", 0);
            printi(e[1], 0);
            prints(" bytes)", 1);
        }

        slot++;
    }
}
