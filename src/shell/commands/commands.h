#pragma once

extern void ls(int argc, int **argv);
extern void touch(int *name, int name_len);
extern void del(int *name, int name_len);
extern void cat(int *name, int name_len);
extern void write(int *args, int args_len);
extern void dofile(int *name, int name_len);
extern void blocks(int argc, int **argv);
