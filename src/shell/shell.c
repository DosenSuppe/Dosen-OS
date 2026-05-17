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

// ----------------------------- OS bridge ------------------------------------
// These are defined in os_bridge.asm and adapt the existing register-based
// driver routines to the C calling convention.

#include "shell_util.h"
#include "os_bridge.h"
#include "commands/commands.h"

// ----------------------------- Shell core -----------------------------------

void shell_initialize(void) {
    int *buf;
    buf = commands_buffer();
    buf[0] = 0;                  // reset buffer length

    prints("You >", 0);
}

void shell_execute(void) {
    int *buf;
    int len;
    buf = commands_buffer();
    len = buf[0];

    char firstChar = buf[1];
    int counter = 0;

    while (firstChar == 0x20 && counter < len) {

        int idx = 1;

        // shifting entire buffer to the left by one char
        while (idx < len - 1) {
            buf[idx] = buf[idx + 1];
            idx = idx + 1;
        }
        buf[0] = len - 1;
        len = buf[0];
        
        counter = counter + 1;
    }

    if (len == 0) { return; }

    if (len == 2) {
        if (matches(buf, 2, "ls")) { ls(0, 0); return; }
    }
    if (len == 3) {
        if (matches(buf, 3, "cls")) { tty_clear_screen(); return; }
        if (matches(buf, 3, "del")) { print_not_impl("del");    return; }
        if (matches(buf, 3, "run")) { print_not_impl("run");    return; }
    }
    if (len == 4) {
        if (matches(buf, 4, "halt"))   { cpu_halt(); return; }
    }
    if (len == 5) {
        if (matches(buf, 5, "touch"))  { print_not_impl("touch");  return; }
    }
    if (len == 6) {
        if (matches(buf, 6, "dofile")) { print_not_impl("dofile"); return; }
    }

    prints("Command not found!", 1);
    // unknown command — silently ignore
}
