#include "shell_util.h"

// See fs.h for layout. Constants are inlined below since the cc.py compiler's
// #define support is unverified in this project.
//
//   MAX_FILES      = 8
//   NAME_MAX       = 12
//   BLOCK_SIZE     = 64
//   TOTAL_BLOCKS   = 32
//   MAX_BLOCKS_PER_FILE = 8
//   ENTRY_SIZE     = 25
//   HEADER_SIZE    = 1 + 32 = 33

int *fs_storage(void) {
    asm("LDI REA, $FileStorage.Start");
}

int *fs_entry_ptr(int slot) {
    int *buf = files_buffer();
    int off  = 33 + slot * 25;
    return &buf[off];
}

void fs_init(void) {
    int *buf = files_buffer();
    int i = 0;

    buf[0] = 0;

    while (i < 32) {
        buf[1 + i] = 0;
        i = i + 1;
    }

    i = 0;
    while (i < 8) {
        int *e = fs_entry_ptr(i);
        e[0] = 0;
        i++;
    }
}

int fs_file_count(void) {
    int *buf = files_buffer();
    return buf[0];
}

int *fs_entry_by_idx(int idx) {
    int active = 0;
    int slot = 0;

    while (slot < 8) {
        int *e = fs_entry_ptr(slot);
        if (e[0] == 1) {
            if (active == idx) { return e; }
            active++;
        }
        slot++;
    }
    return 0;
}

int fs_name_equals(int *entry, int *name, int name_len) {
    if (entry[1] != name_len) { return 0; }
    
    int i = 0;

    while (i < name_len) {
        if (entry[2 + i] != name[i]) { return 0; }
        i++;
    }
    return 1;
}

int *fs_find(int *name, int name_len) {
    int slot = 0;

    while (slot < 8) {
        int *e = fs_entry_ptr(slot);
        if (e[0] == 1) {
            if (fs_name_equals(e, name, name_len) == 1) { return e; }
        }
        slot++;
    }

    return 0;
}

int *fs_create(int *name, int name_len) {
    if (name_len <= 0)  { return 0; }
    if (name_len > 12)  { return 0; }
    if (fs_find(name, name_len) != 0) { return 0; }

    int slot = 0;

    while (slot < 8) {
        int *e = fs_entry_ptr(slot);
        if (e[0] == 0) {
            e[0] = 1;
            e[1] = name_len;
            
            int i = 0;

            while (i < name_len) {
                e[2 + i] = name[i];
                i++;
            }

            e[14] = 0;
            e[15] = 0;
            e[16] = 0;

            int *buf = files_buffer();
            buf[0]++; // TODO: check if this works

            return e;
        }
        slot++;
    }
    return 0;
}

int fs_delete(int *name, int name_len) {
    int *e = fs_find(name, name_len);
    if (e == 0) { return 0; }

    int *buf = files_buffer();
    int bc = e[16];
    int i = 0;

    while (i < bc) {
        int bid = e[17 + i];
        buf[1 + bid] = 0;
        i++;
    }

    e[0] = 0;
    buf[0] = buf[0] - 1;

    return 1;
}

// Releases every block the file owns back to the pool and resets its
// block_count to 0. The entry itself stays in_use.
void fs_free_blocks(int *entry) {
    int *buf = files_buffer();
    int bc = entry[16];
    int i = 0;

    while (i < bc) {
        int bid = entry[17 + i];
        buf[1 + bid] = 0;
        i++;
    }

    entry[16] = 0;
}

// Finds any free block, marks it used, appends to entry's block list.
// Returns block id on success, or -1 if the file is full / pool is full.
int fs_alloc_block(int *entry) {
    if (entry[16] >= 8) { return 0 - 1; }

    int *buf = files_buffer();
    int i = 0;

    while (i < 32) {
        if (buf[1 + i] == 0) {
            buf[1 + i] = 1;
            entry[17 + entry[16]] = i;
            entry[16] = entry[16] + 1;

            return i;
        }
        i++;
    }

    return 0 - 1;
}

int *fs_block_data(int block_id) {
    int *base = fs_storage();
    return &base[block_id * 64];
}
