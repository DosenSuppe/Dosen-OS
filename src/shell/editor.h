#pragma once

// Line-append editor — modal state shared by the `edit` command and the
// shell dispatcher.
//
// While active, every line typed at the shell is appended (with a trailing
// 0x0A) to an in-memory draft buffer instead of being parsed as a command.
// Three sentinels exit the loop:
//   "."   save the draft to the file and exit edit mode
//   "!q"  discard the draft and exit edit mode
//   "!c"  clear the draft (stay in edit mode)
//
// State lives in the .EditorState segment (see mem.cfg):
//   [0]        active           — 0 = shell mode, 1 = edit mode
//   [1]        name_length
//   [2..13]    name chars (max 12)
//   [14]       content_length   — chars in draft (0..512)
//   [15..526]  content chars    — draft text, one char per word

extern void editor_init(void);
extern int *editor_state(void);
extern int  editor_is_active(void);
extern void editor_start(int *name, int name_len);
extern void editor_print_draft(void);
extern void editor_handle_line(void);
