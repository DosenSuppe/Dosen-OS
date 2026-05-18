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
#include "editor.h"
#include "commands/commands.h"

void shell_initialize(void) {
    int *buf;
    buf = commands_buffer();
    buf[0] = 0;

    if (editor_is_active()) {
        prints("..>", 0);
    } else {
        prints("You >", 0);
    }
}

void shell_execute(void) {
    // Must be >= max command-buffer size (.CommandCharacterBuffer is 31
    // words, so up to 30 chars of input). 32 leaves headroom and matches
    // the buffer in one frame slot.
    int local_args[32];
    int *buf;
    int len;
    int idx;
    int sp;
    int cmd_len;
    int arg_len;
    int i;

    buf = commands_buffer();
    len = buf[0];

    // In edit mode every line — including empty ones and leading-space
    // ones — feeds the draft buffer instead of the command parser.
    if (editor_is_active()) {
        editor_handle_line();
        return;
    }

    if (len == 0) { return; }

    // Strip leading spaces by shifting the buffer left.
    while (len > 0 && buf[1] == 0x20) {
        idx = 1;
        while (idx < len) {
            buf[idx] = buf[idx + 1];
            idx = idx + 1;
        }
        buf[0] = len - 1;
        len = buf[0];
    }

    if (len == 0) { return; }

    // Locate the first space (= end of the command word). If no space,
    // sp = len + 1 and there are no args.
    sp = 1;
    while (sp <= len && buf[sp] != 0x20) {
        sp = sp + 1;
    }
    cmd_len = sp - 1;

    // Copy arg chars (after the space) into local_args so we never have
    // to take the address of a buffer element (avoids &buf[x] notation,
    // which the cc.py compiler hasn't been verified to support).
    arg_len = 0;
    if (sp < len) {
        arg_len = len - sp;
        i = 0;
        while (i < arg_len) {
            local_args[i] = buf[sp + 1 + i];
            i = i + 1;
        }
    }

    if (cmd_len == 2) {
        if (matches(buf, 2, "ls")) { ls(0, 0); return; }
    }
    if (cmd_len == 3) {
        if (matches(buf, 3, "cls")) { tty_clear_screen(); return; }
        if (matches(buf, 3, "del")) { cmd_del(local_args, arg_len); return; }
        if (matches(buf, 3, "cat")) { cmd_cat(local_args, arg_len); return; }
        if (matches(buf, 3, "run")) { print_not_impl("run"); return; }
    }
    if (cmd_len == 4) {
        if (matches(buf, 4, "halt")) { cpu_halt(); return; }
        if (matches(buf, 4, "edit")) { cmd_edit(local_args, arg_len); return; }
    }
    if (cmd_len == 5) {
        if (matches(buf, 5, "touch")) { cmd_touch(local_args, arg_len); return; }
        if (matches(buf, 5, "write")) { cmd_write(local_args, arg_len); return; }
    }
    if (cmd_len == 6) {
        if (matches(buf, 6, "dofile")) { dofile(local_args, arg_len); return; }
        if (matches(buf, 6, "blocks")) { cmd_blocks(0, 0); return; }
    }


    prints("Command not found!", 1);
}
