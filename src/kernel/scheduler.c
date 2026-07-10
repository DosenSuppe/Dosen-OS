
#include "../utils/stdio.h"
#include "../shell/shell.h"

#define MAX_PROCESS_COUNT 8
#define STACK_SIZE  0x4000

#define PROC_FREE 0
#define PROC_READY 1
#define PROC_RUN 2
#define PROC_ZOMBIE 3

#define USER_LEVEL 0
#define SYSTEM_LEVEL 1

extern void procYield(void);   // switch.asm

// MUST equal the number of general registers switch.asm pushes per tick.
// If they disagree, the fake stack below won't line up and the first
// switch into a new process jumps into garbage.
// TODO: take above note into the docs
#define NUM_SAVED_REGS 16

struct Process {
    int state;      // Free, Ready, Run, Zombie
    int level;      // User- or System level
    int parent;     // parent process Id
    int savedSP;    // register context linked to the process
    int stackBase;  // base of its stack region (for cleanup) 
};

struct Process processes[MAX_PROCESS_COUNT];
int currentPid;

int procStacksBase(void) {
    asm("LDI REA, $ProcStacks.Start");
}

// Bridge for switch.asm
int *savedSPSlot(int pid) {
    return &processes[pid].savedSP;
}

void scheduleInit(void) {
    for (int i=0; i < MAX_PROCESS_COUNT; i++) {
        processes[i].state = PROC_FREE;
    }

    struct Process *firstProc = &processes[0];

    firstProc->state = PROC_RUN;
    firstProc->level = SYSTEM_LEVEL;
    firstProc->parent = -1;
    firstProc->stackBase = procStacksBase();

    currentPid = 0;
}

int scheduleSwitch(int currentSP) {
    struct Process *process = &processes[currentPid];

    process->savedSP = currentSP;

    if (process->state == PROC_ZOMBIE)
        process->state = PROC_FREE;
    else if (process->state == PROC_RUN)
        process->state = PROC_READY;

    currentPid = pickNext();
    processes[currentPid].state = PROC_RUN;
    
    return processes[currentPid].savedSP;
}

/**
 * @returns slot id or -1 when non avail.
 */
int allocSlot(void) {
    for (int i = 1; i < MAX_PROCESS_COUNT; i++) {
        if (processes[i].state == PROC_FREE) return i;
    }

    return -1;
}

/**
 * End of a finishing process.
 * 
 * @returns void
 */
void procExit(void) {
    processes[currentPid].state = PROC_ZOMBIE;

    int gp = processes[currentPid].parent;
    
    for (int i = 0; i < MAX_PROCESS_COUNT; i++) {
        if (processes[i].state != PROC_FREE && processes[i].parent == currentPid)
            processes[i].parent = gp;
    }

    procYield();
}

/**
 * Spawns a new Process.
 * 
 * @param entry 
 * @param level Level of the process (USER_LEVEL, SYSTEM_LEVEL)
 * @param parent Parent PID
 *
 * @returns pid
 */
int  spawn(int entry, int level, int parent) {
    if (level > processes[currentPid].level) return -1;

    int pid = allocSlot();
    if (pid < 0) return -1;

    struct Process *process = &processes[pid];
    process->stackBase = procStacksBase() + pid * STACK_SIZE;

    // Build the initial ("as if interrupted") context using word INDEXING, not
    // sp--. cc.py's pointer decrement subtracts 1, not sizeof(int)=4, so sp--
    // walks byte-by-byte and scrambles the frame. Indexing (stack[i]) scales
    // by 4 correctly.
    int *stack = process->stackBase;   // int* at the slot base
    int top = STACK_SIZE / 4;          // stack size in words

    stack[top - 1] = procExit;         // RTS return addr (if entry ever returns)
    stack[top - 2] = entry;            // PC — RTI jumps here on the first schedule
    stack[top - 3] = 0;                // FR (flags)
    for (int i = 0; i < NUM_SAVED_REGS; i++) {
        stack[top - 4 - i] = 0;        // 16 zeroed registers
    }

    // savedSP = byte address one word BELOW the lowest register. POP is
    // pre-increment, matching where the ISR's GET_SP lands after 16 PUSHes.
    process->savedSP = process->stackBase + (top - 20) * 4;
    process->level = level;
    process->parent = parent;
    process->state = PROC_READY;

    return pid;
}

/**
 * Kills a given process.
 * 
 * @param pid Process to be killed.
 * 
 * @returns WIP
 */
int  kill(int pid) {
    if (pid < 1 || pid >= MAX_PROCESS_COUNT) return -1;
    if (processes[pid].state == PROC_FREE) return -1;

    int me = currentPid;
    struct Process *meProcess = &processes[me];
    struct Process *victimProcess = &processes[pid];

    if (meProcess->level == USER_LEVEL) {
        if (pid != me && victimProcess->parent != me) return -1;
        if (victimProcess->level == SYSTEM_LEVEL) return -1;
    }

    int gp = victimProcess->parent;

    for (int i=0; i < MAX_PROCESS_COUNT; i++) {
        if (processes[i].state != PROC_FREE && processes[i].parent == pid)
            processes[i].parent = gp;
    }

    // TODO: kernel-owned cleanup. Free any open files, render surfaces, etc.
    // NOTE: The stack region is fixed per slot so freeing the slot reclaims it.
    victimProcess->state = PROC_FREE;

    if (pid == me) procYield();
    return 0;
}

/**
 * Pick next process to handle.
 * 
 * @returns pid of next process to handle.
 */
int  pickNext(void) {
    int i = currentPid;

    for (int n = 0; n < MAX_PROCESS_COUNT; n++) {
        i = (i + 1) % MAX_PROCESS_COUNT;

        if (processes[i].state == PROC_READY || processes[i].state == PROC_RUN)
            return i;
    }

    return currentPid;
}

// ---------------------------------------------------------------------------
// BENCH (temporary): two processes that prove preemption by interleaving TTY
// output. Remove this block and the `CALL Scheduler.benchStart` in main.asm
// once the scheduler is confirmed and you switch to real processes.
// ---------------------------------------------------------------------------
int *timerDev(void) { asm("LDI REA, $MemDevice4.Start"); }

void systemBoot(void) {
    spawn(shellProcess, SYSTEM_LEVEL, 0);

    int *t = timerDev();
    t[2] = 50;

    procYield();
}
