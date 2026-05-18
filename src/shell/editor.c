#include "shell_util.h"
#include "os_bridge.h"
#include "fs.h"

// Inlined constants (cc.py #define support is unverified):
//   NAME_OFF       = 2
//   CLEN_OFF       = 14
//   CONTENT_OFF    = 15
//   CONTENT_MAX    = 512    (= 8 blocks * 64 words, matches FS file cap)
//   BLOCK_SIZE     = 64

int *editor_state(void) {
    asm("LDI REA, $EditorState.Start");
}

void editor_init(void) {
    int *est = editor_state();
    est[0] = 0;
    est[14] = 0;
}

int editor_is_active(void) {
    int *est = editor_state();
    return est[0];
}

void editor_start(int *name, int name_len) {
    int *est = editor_state();
    int i;

    est[1] = name_len;
    i = 0;

    while (i < name_len) {
        est[2 + i] = name[i];
        i++;
    }

    // Preload existing file contents into the draft so `edit` on an existing
    // file behaves like reopen-and-append rather than start-from-scratch.
    int clen = 0;
    int *e = fs_find(name, name_len);

    if (e != 0) {
        int bc = e[16];
        int b  = 0;
        int done = 0;
    
        while (b < bc) {
            if (done == 0) {
                int *blk = fs_block_data(e[17 + b]);
                int k = 0;
    
                while (k < 64) {
                    if (done == 0) {
                        int ch = blk[k];
    
                        if (ch == 0) {
                            done = 1;
                        } else {
                            if (clen < 512) {
                                est[15 + clen] = ch;
                                clen++;
                            } else {
                                done = 1;
                            }
                        }
                    }
                    k++;
                }
            }
            b++;
        }
    }

    est[14] = clen;
    est[0] = 1;
}

void editor_save(void) {
    int *est = editor_state();
    int name_len = est[1];
    int clen = est[14];
    int i;

    // Pass &est[2] directly. A local int name[12] declared mid-function
    // gets a wrong stack offset under cc.py — array locals must be at the
    // very top of the frame (see shell.c's int local_args[32]).
    int *e = fs_find(&est[2], name_len);
    if (e == 0) {
        prints("edit: file vanished", 1);
        est[0] = 0;
        return;
    }

    fs_free_blocks(e);

    int written = 0;
    while (written < clen) {
        int bid = fs_alloc_block(e);

        if (bid < 0) {
            prints("edit: out of blocks", 1);
            est[0] = 0;
            return;
        }
        
        int *blk = fs_block_data(bid);

        // zero the block so cat's NUL-terminator stop works on the tail
        i = 0;
        while (i < 64) {
            blk[i] = 0;
            i++;
        }

        i = 0;
        while (i < 64) {
            if (written < clen) {
                blk[i] = est[15 + written];
                written++;
            }

            i++;
        }
    }

    est[0] = 0;

    prints("(saved ", 0);
    printi(clen, 0);
    prints(" chars)", 1);
}

void editor_print_draft(void) {
    int *est = editor_state();
    int clen = est[14];
    int i;

    if (clen == 0) { return; }

    i = 0;
    while (i < clen) {
        tty_write_char(est[15 + i]);
        i++;
    }

    // Make sure the next prompt lands on its own line.
    if (est[15 + clen - 1] != 0xA) {
        tty_write_char(0xA);
    }
}

void editor_handle_line(void) {
    int *est = editor_state();
    int *buf = commands_buffer();
    int len = buf[0];

    // Sentinels — exact-match (not prefix).
    if (len == 1) {
        if (buf[1] == '.') { editor_save(); return; }
    }

    if (len == 2) {
        if (buf[1] == '!') {
            if (buf[2] == 'q') {
                est[0] = 0;
                prints("(cancelled)", 1);
                return;
            }
            if (buf[2] == 'c') {
                est[14] = 0;
                prints("(cleared)", 1);
                return;
            }
        }
    }

    int clen = est[14];
    if (clen + len + 1 > 512) {
        prints("(buffer full — '.' to save or '!q' to cancel)", 1);
        return;
    }

    int i = 0;
    while (i < len) {
        est[15 + clen + i] = buf[1 + i];
        i++;
    }

    est[15 + clen + len] = 0xA;
    est[14] = clen + len + 1;
}
