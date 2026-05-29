#pragma once

// C-callable wrappers for the asm drivers and the user-program loader. The
// drivers themselves use register-based calling conventions; the wrappers
// translate to the stack-based one cc.py emits.

// --- Drivers ---
extern void ttyWriteChar(int ch);
extern void ttyClearScreen(void);
extern void cpuHalt(void);
extern char ttyReadChar(void);

// --- Loader plumbing ---
// MMIOCopy: word-copy that works for any pair of addresses (RAM, MMIO, both).
//   Used by the loader to move a program into the .UserCode window.
// userCodeBase: returns the OS address of the .UserCode window.
// launchUserCode: fixed CALL into $UserCode.Start; the program RTSes back here.
// launchProgram: like launchUserCode but to an arbitrary target, with argc/argv
//   pushed on the stack first (C calling convention).
extern void MMIOCopy(int *dst, int *src, int count);
extern int *userCodeBase(void);
extern void launchUserCode(void);
extern void launchProgram(int *target, int argc, int **argv);
