#include "../utils/stdio.h"

// Device constants — see PermaStorageDevice changelog.
const int FS_MAX_FILES      = 64;
const int FS_ENTRY_WORDS    = 64;
const int FS_DATA_AREA      = 0x1000;   // device-internal start of data
const int FS_MAX_FILE_BYTES = 0x1000;   // 4 KW quota per slot

const int FS_E_STATUS       = 0;
const int FS_E_SIZE         = 1;
const int FS_E_DATA_OFFSET  = 2;
const int FS_E_RESERVED     = 3;
const int FS_E_NAME         = 4;
const int FS_NAME_MAX       = 60;

const int FS_ST_EMPTY       = 0;
const int FS_ST_PRESENT     = 1;
const int FS_ST_DIRTY       = 2;

// Returns the OS address of slot 6 — also the device's offset-0.
int *fs_device_base(void) {
    asm("LDI REA, $MemDevice6.Start");
}

void fs_init(void) {
    // No-op. Any slots populated by the host on boot stay; empty slots stay 0.
}

int *fs_entry_by_slot(int slot) {
    if (slot < 0) { return 0; }
    if (slot >= FS_MAX_FILES) { return 0; }

    int *base = fs_device_base();
    return &base[slot * FS_ENTRY_WORDS];
}

int fs_file_count(void) {
    int count = 0;
    int slot = 0;
    while (slot < FS_MAX_FILES) {
        int *e = fs_entry_by_slot(slot);
        if (e[FS_E_STATUS] != FS_ST_EMPTY) {
            count++;
        }
        slot++;
    }
    return count;
}

int *fs_entry_by_idx(int idx) {
    int active = 0;
    int slot = 0;
    while (slot < FS_MAX_FILES) {
        int *e = fs_entry_by_slot(slot);
        if (e[FS_E_STATUS] != FS_ST_EMPTY) {
            if (active == idx) { return e; }
            active++;
        }
        slot++;
    }
    return 0;
}

int fs_name_length(int *entry) {
    int i = 0;
    while (i < FS_NAME_MAX) {
        if (entry[FS_E_NAME + i] == 0) { return i; }
        i++;
    }
    return FS_NAME_MAX;
}

int fs_name_equals(int *entry, int *name, int name_len) {
    if (fs_name_length(entry) != name_len) { return 0; }

    int i = 0;
    while (i < name_len) {
        if (entry[FS_E_NAME + i] != name[i]) { return 0; }
        i++;
    }
    return 1;
}

int *fs_find(int *name, int name_len) {
    int slot = 0;
    while (slot < FS_MAX_FILES) {
        int *e = fs_entry_by_slot(slot);
        if (e[FS_E_STATUS] != FS_ST_EMPTY) {
            if (fs_name_equals(e, name, name_len) == 1) {
                return e;
            }
        }
        slot++;
    }
    return 0;
}

int *fs_create(int *name, int name_len) {
    if (name_len <= 0)              { return 0; }
    if (name_len > FS_NAME_MAX)     { return 0; }
    if (fs_find(name, name_len))    { return 0; }

    int slot = 0;
    while (slot < FS_MAX_FILES) {
        int *e = fs_entry_by_slot(slot);
        if (e[FS_E_STATUS] == FS_ST_EMPTY) {
            // Fill the entry except status. Status is set LAST so a host
            // peek can't observe a half-written slot as present.
            e[FS_E_SIZE]        = 0;
            e[FS_E_DATA_OFFSET] = FS_DATA_AREA + slot * FS_MAX_FILE_BYTES;
            e[FS_E_RESERVED]    = 0;

            int i = 0;
            while (i < name_len) {
                e[FS_E_NAME + i] = name[i];
                i++;
            }
            while (i < FS_NAME_MAX) {
                e[FS_E_NAME + i] = 0;
                i++;
            }

            // DIRTY so the host creates the on-disk file.
            e[FS_E_STATUS] = FS_ST_DIRTY;
            return e;
        }
        slot++;
    }
    return 0;
}

int fs_delete(int *name, int name_len) {
    int *e = fs_find(name, name_len);
    if (e == 0) { return 0; }

    // Per changelog: setting status to 0 does NOT delete the host file.
    e[FS_E_STATUS] = FS_ST_EMPTY;
    return 1;
}

int *fs_data_ptr(int *entry) {
    int *base = fs_device_base();
    return &base[entry[FS_E_DATA_OFFSET]];
}

void fs_mark_dirty(int *entry) {
    entry[FS_E_STATUS] = FS_ST_DIRTY;
}
