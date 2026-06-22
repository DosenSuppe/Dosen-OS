// Shell - line editor + dispatcher to `run`.
//
// shell.c knows about exactly one program: `run`. 
// Everything else is treated as a program name.
// argv is shifted right and dispatched to run.
// So:
//  run cls   -> run(2, ["run", "cls"])
//  cls       -> run(2, ["run", "cls"])    (implicit prefix)
//  run       -> run(1, ["run"])           (prints missing-name error)
//
// Input model: 
//  the shell is a polling foreground process. Its on-key ISR handler (shellNoop) does nothing; 
//  shellMain is run by KernelDispatch and polls the keyboard with ttyReadChar() and also
//  does the line editing and command execution. Keeping keyboard work and
//  command execution OUT of the interrupt handler is essential: 
//      a long command (e.g. the assembler) handled inside the ISR wedges keyboard input.

#include "shell_util.h"
#include "os_bridge.h"
#include "commands/commands.h"
#include "../utils/stdio.h"
#include "../utils/string.h"
#include "../programs/FontWriter.h"

#define CHAR_BACKSPACE 0x8
#define CHAR_ENTER 0xA
#define MAX_BUFFER_SIZE 64

int cmdStringBufferSize = 0;
char cmdStringBuffer[64];

void shellInitialize(void) {
    clearBuffer();
    newShellLine(0);
}

void clearBuffer(void) {
    cmdStringBufferSize = 0;
    cmdStringBuffer[0] = 0;
}

void newShellLine(int *str) {
    prints("You >", 0);

    if (str != 0) {
        prints(str, 0);
    }
}

// On-key ISR handler. The shell polls in shellMain instead, so this does
// nothing — it just lets the keyboard IRQ complete. (Mirrors editorNoop.)
void shellNoop(void) {
    return;
}

void shellExecute(void) {
    int argc;
    int *argv[8];
    int *shifted[8];
    int *cmd;
    int len;
    int i;

    if (cmdStringBufferSize == 0) { return; }

    argc = 0;
    tokenize(cmdStringBuffer, &argc, argv);
    if (argc == 0) { return; }

    cmd = argv[0];
    len = stringLen(cmd);

    // Explicit `run X args...` — argv already has the shape run expects.
    if (matches(cmd, len, "run")) {
        run(argc, argv);
        return;
    }

    // Implicit prefix: turn `X args...` into `run X args...`.
    shifted[0] = "run";
    i = 0;
    while (i < argc) {
        if (i + 1 >= 8) { break; }
        shifted[i + 1] = argv[i];
        i++;
    }
    run(argc + 1, shifted);
}

// The shell's main routine, run repeatedly by KernelDispatch in normal context.
// Polls one key per tick; ttyReadChar returns 0 when the keyboard FIFO is empty,
// so an idle tick is just one read and a return.
void shellMain(void) {
    char character = ttyReadChar();
    if (character == 0) {
        return;                 // nothing pending
    }

    renderChar(character, 10, 10);

    if (character == CHAR_ENTER) {
        ttyWriteChar(CHAR_ENTER);

        shellExecute();
        shellInitialize();
        return;
    }

    if (character == CHAR_BACKSPACE) {
        if (cmdStringBufferSize == 0) {
            return;
        }
        cmdStringBufferSize--;
        cmdStringBuffer[cmdStringBufferSize] = 0;
    }

    if (cmdStringBufferSize + 1 >= MAX_BUFFER_SIZE && character != CHAR_BACKSPACE) {
        ttyWriteChar(CHAR_ENTER);
        prints("Command too long! Max: ", 0);
        printi(MAX_BUFFER_SIZE, 0);
        prints(" characters.", 1);

        newShellLine(cmdStringBuffer);
        return;
    }

    if (character != CHAR_BACKSPACE) {
        cmdStringBuffer[cmdStringBufferSize] = character;
        cmdStringBufferSize++;
        cmdStringBuffer[cmdStringBufferSize] = '\0';
    }

    printc(character);
}
