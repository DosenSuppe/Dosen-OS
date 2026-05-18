#pragma once

extern void ls(int argc, int **argv);
extern void cmd_touch(int *name, int name_len);
extern void cmd_del(int *name, int name_len);
extern void cmd_cat(int *name, int name_len);
extern void cmd_write(int *args, int args_len);
extern void dofile(int *name, int name_len);
extern void cmd_blocks(int argc, int **argv);
extern void cmd_edit(int *name, int name_len);
