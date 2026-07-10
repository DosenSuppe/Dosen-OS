#pragma once

#define MAX_PROCESS_COUNT   8
#define STACK_SIZE  0x4000  // 16 KiB per process

#define PROC_FREE   0
#define PROC_READY  1
#define PROC_RUN    2
#define PROC_ZOMBIE 3

#define USER_LEVEL   0
#define SYSTEM_LEVEL 1

struct Process {
    int state;
    int level;
    int parent;
    int savedSP;
    int stackBase;
};

extern struct Process processes[MAX_PROCESS_COUNT];
extern int currentPid;

extern void schedInit(void);
extern int  pickNext(void);
extern int  spawn(int entry, int level, int parent);
extern int  kill(int pid);
extern int *savedSPSlot(int pid);

// provided by switch.asm
extern void procYield(void);
