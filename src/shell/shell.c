// Shell — line editor + dispatcher to `run`.
//
// shell.c knows about exactly one program: `run`. Everything else is treated
// as a program name — argv is shifted right and dispatched to run. So:
//   run cls    → run(2, ["run", "cls"])
//   cls        → run(2, ["run", "cls"])    (implicit prefix)
//   run        → run(1, ["run"])           (prints missing-name error)
//
// Adding/removing commands no longer touches this file.

#include "shell_util.h"
#include "os_bridge.h"
#include "commands/commands.h"
#include "../utils/stdio.h"

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

void onKey(void) {
    char character = ttyReadChar();

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
    len = strLength(cmd);

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
