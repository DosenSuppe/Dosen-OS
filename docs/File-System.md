# File System

The file system is backed by the **PermaStorageDevice**, an MMIO device reached
through slot 7 at `0xF8000000` (`.MemDevice7`). Unlike normal RAM it is
persistent: the host watches the device and flushes changes back to real files,
so data survives a reboot.

Defined in [`fs.h`](../src/shell/fs.h), implemented in [`fs.c`](../src/shell/fs.c).

## Host auto-flush protocol

Each file occupies one **slot**. A slot's first word is its **status**:

| Status  | Value | Meaning |
| ------- | ----- | ------- |
| empty   | `0`   | Slot is free. |
| present | `1`   | Slot holds a file, in sync with the host. |
| dirty   | `2`   | Slot was modified; the host needs to flush it. |

When the OS writes data and wants it persisted it sets the slot's status to
DIRTY (`fs_mark_dirty`). The host sees the transition, flushes the slot to its
host-side file within about 250 ms, then resets the status to PRESENT. The OS
never blocks on this. It marks the slot and moves on.

## On-device layout

The device is byte-addressed and the OS reaches it through slot 7, so
`fs_device_base()` returns `0xF8000000`. The first region is the file table
(one 256-byte entry per file); the rest is the file data area.

Entry fields are 32-bit words, so the OS indexes them by word: entry N starts at
`base[N * 64]` (256 bytes / 4), and the field offsets are word indices:

| Word index | Field         | Notes |
| ---------- | ------------- | ----- |
| `[0]`      | `status`      | 0 = empty, 1 = present, 2 = dirty |
| `[1]`      | `size`        | File length in bytes |
| `[2]`      | `data_offset` | Device BYTE offset where the file's data starts |
| `[3]`      | `reserved`    | |
| `[4..]`    | `filename`    | ASCII, one char per word, null-terminated, up to 60 chars |

Two byte-vs-word details to keep straight:

- **File data is one byte per word.** Byte `i` of a file lives at device byte
  `data_offset + i*4`.
- **`data_offset` is a device BYTE offset**, so `fs_data_ptr` shifts it right by
  2 to turn it into a word index before adding it to the base pointer.

The OS-side constants in `fs.c` mirror the device. They must match the device's
own constants (`MaxFiles`, `EntryBytes`, `DataStart`): `FS_MAX_FILES` is the
slot count, `FS_ENTRY_WORDS` is `EntryBytes / 4`, and `FS_DATA_AREA` is the
device's `DataStart`.

## C API

```c
void  fs_init(void);                       // initialize the table at boot
int   fs_file_count(void);                 // number of non-empty slots
int  *fs_entry_by_idx(int idx);            // sequential index, skipping empties
int  *fs_entry_by_slot(int slot);          // raw slot
int  *fs_find(int *name, int name_len);    // entry pointer, or 0 if absent
int  *fs_create(int *name, int name_len);  // new entry, or 0 if no free slot
int   fs_delete(int *name, int name_len);  // 0 if not found, nonzero on success
int  *fs_data_ptr(int *entry);             // OS pointer to the entry's data area
int   fs_name_length(int *entry);          // walks the name field; 0..60
void  fs_mark_dirty(int *entry);           // status -> DIRTY, so the host flushes
```

### Typical write flow

```c
int *e = fs_find(name, len);

if (e == 0)
    e = fs_create(name, len);      // create if absent

int *data = fs_data_ptr(e);

for (int i = 0; i < n; i++)
    data[i] = text[i];

data[n] = 0;                       // null-terminate
e[1] = n;                          // update size (bytes)
fs_mark_dirty(e);                  // hand off to the host
```

This is what `write`, `dofile`, and the `edit` program do. The reader side
(`cat`, `dibmap`, and so on) just calls `fs_find` then `fs_data_ptr` and reads up
to `e[1]` bytes.

## Limits

- **Max files:** `FS_MAX_FILES` slots (must equal the device's `MaxFiles`).
- **Filename:** up to 60 characters, null-terminated, ASCII.
- **File size:** bounded by the per-slot data slice. Individual writers also cap
  their own output (`write` at `WRITE_MAX_FILE_BYTES`, the `edit` buffer at
  `EDIT_MAX`), so raise those too if you want bigger files.
