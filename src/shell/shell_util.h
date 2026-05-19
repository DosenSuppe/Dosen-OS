#pragma once

extern int matches(int *buf, int len, int *str);
extern int *commands_buffer(void);
extern int *files_buffer(void);
extern void print_not_impl(int *str);
extern void tokenize(int *str, int *argc, int **argv);
extern int strLength(int *str);
