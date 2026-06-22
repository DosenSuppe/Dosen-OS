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

// MMIOCopy: 
//      word-copy that works for any pair of addresses (RAM, MMIO, both).
//      Used by the loader to move a program into the .UserCode window.
extern void MMIOCopy(int *dst, int *src, int count);

// userCodeBase:
//      returns the OS address of the .UserCode window.
extern int *userCodeBase(void);

// launchUserCode:
//      fixed CALL into $UserCode.Start;
//      the program RTS-es back here.
extern void launchUserCode(void);

// launchProgram: 
//      like launchUserCode but to an arbitrary target,
//       with argc/argv pushed on the stack first (C calling convention).
extern void launchProgram(int *target, int argc, int **argv);

// --- Cooperative foreground-process switching ---

// pushProc: 
//      make the calling program the foreground process.
//      `mainFn` is run repeatedly by the kernel dispatch loop; 
//      `onKeyFn` is the per-IRQ handler;
//  
//      A program that does its work by polling should pass its loop body as `mainFn` and a do-nothing handler as `onKeyFn`.
//      Pass 0 for `mainFn` to be purely event-driven.
//      
//      The caller returns normally; the kernel then drives the new process.
extern void pushProc(int *mainFn, int *onKeyFn);

// popProc: 
//      pop the current process, restoring the one beneath it (e.g. the shell).
//      Call it from `mainFn` when the program wants to exit.
extern void popProc(void);
