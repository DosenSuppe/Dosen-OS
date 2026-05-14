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

extern void tty_write_char(int ch);
extern void tty_clear_screen(void);
extern void cpu_halt(void);

// ----------------------------- Helpers --------------------------------------

// Returns the absolute address of the command character buffer.
// The value comes from mem.cfg (linker resolves $CommandCharacterBuffer.Start).
int *cmd_buffer(void) {
    // REA is preserved through the function epilogue.
    asm("LDI REA, $CommandCharacterBuffer.Start");
}

int *files_buffer(void) {
    asm("LDI REA, $FilenameStorage.Start");
}

void int_to_decimal_string(int num, char* buffer) {
    char temp[10];
    int i = 0;
    int j = 0;
    int is_negative = 0;

    // Handle 0 explicitly
    if (num == 0) {
        buffer[0] = '0';
        buffer[1] = 0;
        return;
    }

    // Handle negative numbers (assuming signed 2's complement semantics)
    if (num < 0) {
        is_negative = 1;
        num = -num; 
        
        // Edge case: Minimum negative value -8388608
        // If your compiler/hardware overflows on `-num`, 
        // you may need to handle -8388608 as a special case.
        if (num < 0) { 
            // Manual fallback for -8388608
            buffer[0] = '-'; buffer[1] = '8'; buffer[2] = '3';
            buffer[3] = '8'; buffer[4] = '8'; buffer[5] = '6';
            buffer[6] = '0'; buffer[7] = '8'; buffer[8] = 0;
            return;
        }
    }

    // Extract digits from right to left into a temporary buffer
    while (num > 0) {
        int digit = num % 10;
        temp[i] = '0' + digit; // '0' is 48
        i = i + 1;
        num = num / 10;
    }

    // Append negative sign if needed
    if (is_negative) {
        buffer[j] = '-';
        j = j + 1;
    }

    // Reverse the temporary buffer into the final buffer
    while (i > 0) {
        i = i - 1;
        buffer[j] = temp[i];
        j = j + 1;
    }

    // Null terminate the string
    buffer[j] = 0;
}

void print_str(int *str, int newLine) {
    int i;
    i = 0;
    while (str[i] != 0) {
        tty_write_char(str[i]);
        i = i + 1;
    }

    if (newLine == 1) {
        tty_write_char(0xA);
    }
}

void print_int(int val, int newLine) {
    char result[10];
    
    int_to_decimal_string(val, result);
    print_str(result, 0);

    if (newLine == 1) {
        tty_write_char(0xA); // new-line character
    }
}

void print_not_impl(int *name) {
    print_str(name, 0);
    print_str(": TODO", 1);
}

// True (1) if the input buffer's chars 1..len match str[0..len-1] and
// str[len] == 0 (i.e., string is exactly `len` chars long).
int matches(int *buf, int len, int *str) {
    int i;
    i = 0;
    while (i < len) {
        if (buf[i + 1] != str[i]) {
            return 0;
        }
        i = i + 1;
    }
    if (str[len] != 0) {
        return 0;
    }
    return 1;
}

// ----------------------------- Commands -------------------------------------

void cmd_cls(void) {
    tty_clear_screen();
}

void cmd_halt(void) {
    cpu_halt();
}

void cmd_ls(void) {
    int *files;
    int fileCount;
    int i;
    char indexString[10];

    print_str("All files:", 1);

    // Layout: files[0] = count, files[1..count] = pointer to each file record.
    // Each record: record[0] = filename length, record[1..len] = filename chars,
    // record[len+1..] = file data.
    files = files_buffer();
    fileCount = files[0];
    i = 0;

    while (i < fileCount) {
        int *file = files[i + 1];
        int filenameSize = file[0];
        int j = 0;

        int_to_decimal_string(i, indexString);
        print_str(indexString, 0);
        print_str(" : ", 0);

        while (j < filenameSize) {
            tty_write_char(file[j + 1]);
            j = j + 1;
        }
        tty_write_char(0xA);

        i = i + 1;
    }
}

void cmd_run(void) {
    print_not_impl("run"); 
}

void cmd_del(void)     { print_not_impl("del"); }
void cmd_touch(void)   { print_not_impl("touch"); }
void cmd_dofile(void)  { print_not_impl("dofile"); }

// ----------------------------- Shell core -----------------------------------

void shell_initialize(void) {
    int *buf;
    buf = cmd_buffer();
    buf[0] = 0;                  // reset buffer length

    print_str("You >", 0);
}

void shell_execute(void) {
    int *buf;
    int len;
    buf = cmd_buffer();
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
        if (matches(buf, 2, "ls")) { cmd_ls(); return; }
    }
    if (len == 3) {
        if (matches(buf, 3, "cls")) { cmd_cls(); return; }
        if (matches(buf, 3, "del")) { cmd_del(); return; }
        if (matches(buf, 3, "run")) { cmd_run(); return; }
    }
    if (len == 4) {
        if (matches(buf, 4, "halt")) { cmd_halt(); return; }
    }
    if (len == 5) {
        if (matches(buf, 5, "touch")) { cmd_touch(); return; }
    }
    if (len == 6) {
        if (matches(buf, 6, "dofile")) { cmd_dofile(); return; }
    }

    print_str("Command not found!", 1);
    // unknown command — silently ignore
}
