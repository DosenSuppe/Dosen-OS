// Shell — C port of the original shell.asm and commands.asm.
//
// The keyboard interrupt handler (still in main.asm) fills the command
// character buffer at $CommandCharacterBuffer.Start (= 0x004000). When the
// user presses Enter, the handler calls shell_execute(), then calls
// shell_initialize() to redraw the prompt.
//
// Buffer layout (matches the original assembly contract):
//   buf[0]      = current input length, in words
//   buf[1..len] = characters typed since last command (one char per word)

#include "shell_util.h"
#include "os_bridge.h"
#include "commands/commands.h"
#include "../utils/stdio.h"

int CHAR_BACKSPACE = 0x8;   // TODO: implement #define 
int CHAR_ENTER = 0xA;

int cmdStringBufferSize = 0;
char cmdStringBuffer[64];

void shellInitialize(void) {
    prints("Initializing Shell!", 1);

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

void onKeyPressed(void) {
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
        cmdStringBuffer[cmdStringBufferSize] = 0;
        cmdStringBufferSize--;
    }

    // stop when the buffer is full, and the last character typed was not a backspace
    if (cmdStringBufferSize + 1 >= sizeof(cmdStringBuffer) && character != CHAR_BACKSPACE ) {
        prints("", 1);
        prints("Command too long! Max: ", 0);
        printi(sizeof(cmdStringBuffer), 0);
        prints(" characters. ADDR: ", 0);
        printi((int) cmdStringBuffer, 1);

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
    int local_args[32];
    int len;
    int idx;
    int sp;
    int cmd_len;
    int arg_len;
    int i;

    // FIX 1: The length is stored in our global counter, not index 0!
    len = cmdStringBufferSize;

    if (len == 0) { return; }

    // Strip leading spaces by shifting the buffer left.
    // FIX 2: First character is now at index 0, not index 1.
    while (len > 0 && cmdStringBuffer[0] == 0x20) {
        idx = 0;

        while (idx < len - 1) {
            cmdStringBuffer[idx] = cmdStringBuffer[idx + 1];
            idx = idx + 1;
        }
        
        // Update both local and global length counters
        len = len - 1;
        cmdStringBufferSize = len;
        cmdStringBuffer[len] = '\0'; // Keep it null-terminated
    }

    if (len == 0) { return; }

    // Locate the first space (= end of the command word).
    // FIX 3: Start looking at index 0
    sp = 0;

    while (sp < len && cmdStringBuffer[sp] != 0x20) {
        sp = sp + 1;
    }
    
    cmd_len = sp; // The length of the command is exactly the index of the space

    // Copy arg chars (after the space) into local_args
    arg_len = 0;
    
    // FIX 4: If space index is less than total string length, we have arguments
    if (sp < len) {
        arg_len = len - (sp + 1); // Skip the space itself
        i = 0;

        while (i < arg_len) {
            // Grab characters starting right after the space
            local_args[i] = cmdStringBuffer[sp + 1 + i];
            i++;
        }
    }

    // Command matching blocks (No changes needed here!)
    if (cmd_len == 2) {
        if (matches(cmdStringBuffer, 2, "ls")) { ls(0, 0); return; }
    }
    if (cmd_len == 3) {
        if (matches(cmdStringBuffer, 3, "cls")) { tty_clear_screen(); return; }
        if (matches(cmdStringBuffer, 3, "del")) { del(local_args, arg_len); return; }
        if (matches(cmdStringBuffer, 3, "cat")) { cat(local_args, arg_len); return; }
        if (matches(cmdStringBuffer, 3, "run")) { print_not_impl("run"); return; }
    }
    if (cmd_len == 4) {
        if (matches(cmdStringBuffer, 4, "halt")) { cpu_halt(); return; }
    }
    if (cmd_len == 5) {
        if (matches(cmdStringBuffer, 5, "touch")) { touch(local_args, arg_len); return; }
        if (matches(cmdStringBuffer, 5, "write")) { write(local_args, arg_len); return; }
    }
    if (cmd_len == 6) {
        if (matches(cmdStringBuffer, 6, "dofile")) { dofile(local_args, arg_len); return; }
        if (matches(cmdStringBuffer, 6, "blocks")) { blocks(0, 0); return; }
    }

    prints("Command not found!", 1);
}
