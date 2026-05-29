#pragma once

// File system, backed by PermaStorageDevice (MMIO slots 6 + 7, 0xE00000..0xFFFFFF).
// The host auto-flushes any slot whose status transitions to DIRTY within ~250ms,
// then resets it to PRESENT.
//
// Device layout (24-bit word addresses, OS view):
//   [0xE00000..0xE00FFF]  File table — 64 entries × 64 words
//   [0xE01000..]          File data area (bump-allocated per slot)
//
// Entry layout (64 words each, entry N starts at 0xE00000 + N * 64):
//   [0]      status        0 = empty, 1 = present, 2 = dirty
//   [1]      size          file length in bytes (= words; 1 char per word)
//   [2]      data_offset   device-internal word offset where data starts
//   [3]      reserved
//   [4..63]  filename      ASCII, null-terminated, max 60 chars

extern void fs_init(void);

extern int  fs_file_count(void);
extern int *fs_entry_by_idx(int idx);     // sequential index, skipping empty
extern int *fs_entry_by_slot(int slot);   // raw slot 0..63
extern int *fs_find(int *name, int name_len);
extern int *fs_create(int *name, int name_len);
extern int  fs_delete(int *name, int name_len);

// Returns OS-address pointer to entry's data area (in MMIO).
extern int *fs_data_ptr(int *entry);

// Walks the entry's name field; returns 0..60.
extern int  fs_name_length(int *entry);

// Sets entry's status to DIRTY so the host flushes it to its host-side file.
extern void fs_mark_dirty(int *entry);
