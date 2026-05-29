#pragma once

// `run` is the single dispatcher every shell command flows through.
// Forward decls of individual commands (ls, cat, etc.) live in run.c —
// cc.py rejects redeclaring a function in the same translation unit, so
// commands.h is kept to the one symbol shell.c actually needs.
extern void run(int argc, int **argv);
