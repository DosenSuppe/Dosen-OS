// Shell — C port of the original shell.asm and commands.asm.
//
// The keyboard interrupt handler (still in main.asm) fills the command.
// When the user presses Enter, the handler calls shell_execute(), then
// calls shell_initialize() to redraw the prompt.
//
// Buffer layout (matches the original assembly contract):
//   buf[0]      = current input length, in words
//   buf[1..len] = characters typed since last command (one char per word)

#include "shell_util.h"
#include "os_bridge.h"
#include "commands/commands.h"
#include "../utils/stdio.h"

const int CHAR_BACKSPACE = 0x8;   // TODO: implement #define 
const int CHAR_ENTER = 0xA;
const int CHAR_SPACE = 0x20;

const int MAX_BUFFER_SIZE = 64;  // TODO: add const to parser when using as bounds

int cmdStringBufferSize = 0;
char cmdStringBuffer[64]; // TODO: Update with MAX_BUFFER_SIZE once parser is updated

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

void main(void) {
    prints("Hello", 1);
}

void onKey(void) {
    char character = ttyReadChar();

    if (character == CHAR_ENTER) {
        tty_write_char(CHAR_ENTER);

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

    // stop when the buffer is full, and the last character typed was not a backspace
    if (cmdStringBufferSize + 1 >= MAX_BUFFER_SIZE && character != CHAR_BACKSPACE ) {
        tty_write_char(CHAR_ENTER);
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
    if (cmdStringBufferSize == 0) { return; }

    int argc = 0;
    int *argv[4];

    tokenize(cmdStringBuffer, &argc, argv);

    if (argc == 0) { return; }
    
    const char cmd = argv[0];
    const int cmdLength = strLength(cmd);

    // Command matching blocks (No changes needed here!)
    if (cmdLength == 2) {
        if (matches(cmd, 2, "ls")) { ls(argc, argv); return; }
    }
    if (cmdLength == 3) {
        if (matches(cmd, 3, "cls")) { tty_clear_screen(); return; }
        if (matches(cmd, 3, "del")) { del(argc, argv); return; }
        if (matches(cmd, 3, "cat")) { cat(argc, argv); return; }
        if (matches(cmd, 3, "run")) { print_not_impl("run"); return; }
    }
    if (cmdLength == 4) {
        if (matches(cmd, 4, "halt")) { cpu_halt(); return; }
    }
    if (cmdLength == 5) {
        if (matches(cmd, 5, "touch")) { touch(argc, argv); return; }
        if (matches(cmd, 5, "write")) { write(argc, argv); return; }
    }
    if (cmdLength == 6) {
        if (matches(cmd, 6, "dofile")) { dofile(argc, argv); return; }
        if (matches(cmd, 6, "blocks")) { blocks(argc, argv); return; }
    }

    prints("Command not found!", 1);
}
