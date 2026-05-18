#pragma once

// File system public API.
//
// Layout in .FilenameStorage (header + entry table):
//   [0]              file_count        — number of active entries
//   [1..32]          block_used[32]    — 0 = free, 1 = used
//   [33..]           entries[8], each 25 words
//
// Entry layout (25 words):
//   [0]      in_use            — 0 = free slot, 1 = used
//   [1]      name_length       — number of chars in name (1..12)
//   [2..13]  name[12]          — name characters
//   [14]     created           — placeholder (no RTC yet)
//   [15]     modified          — placeholder
//   [16]     block_count       — number of blocks owned (0..8)
//   [17..24] block_ids[8]      — block ids owned by this file (any order)
//
// Block pool in .FileStorage: 32 blocks of 64 words each = 2048 words.

extern void fs_init(void);
extern int  fs_file_count(void);
extern int *fs_entry_by_idx(int idx);
extern int *fs_find(int *name, int name_len);
extern int *fs_create(int *name, int name_len);
extern int  fs_delete(int *name, int name_len);
extern int  fs_alloc_block(int *entry);
extern void fs_free_blocks(int *entry);
extern int *fs_block_data(int block_id);
