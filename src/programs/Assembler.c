// Runtime DASM assembler for Dosen-OS.
//
// `asm <file>` reads a DASM source file from the file system and assembles it
// directly into the .UserCode window, then runs it. Because the code is
// assembled at its final address ($UserCode.Start), labels resolve to real
// runtime addresses with no relocation and no byte-packing — unlike disk
// programs (see docs/Writing-Programs.md), which are byte-packed because the
// storage device is byte-wide. Here the words are generated straight into RAM.
//
// Supported (v1 subset):
//   - one statement per line; `;` starts a comment
//   - labels on their own line:  name:
//   - mnemonics: NOP HALT RTS RTI INT, MOV, the ALU ops (ADD SUB MUL DIV SHL
//     SHR NAND AND OR XOR NOR) in reg/imm 2- and 3-operand forms, NOT, CMP,
//     SCMP, PUSH POP, LDI STR, the JP/CALL family, GET_SP SET_SP GET_PC
//     SET_IVR GET_INT_ID SET_SP_R, LDR_ARG STR_ARG LDR_LOC STR_LOC, and DW
//   - operands: registers (REA..REZ), #immediates (decimal or 0x..), [reg],
//     [addr], bare labels, and [label]
//   - syscalls: SYS_prints, SYS_ttyWriteChar, ... are predefined labels, so a
//     program can `LDI REA, [SYS_prints]` then `CALL REA`.
//   - entry point: label `_start` if present, else the first word.

#include "../shell/fs.h"
#include "../shell/os_bridge.h"
#include "../utils/stdio.h"
#include "../utils/string.h"

// --- operand kinds ----------------------------------------------------------
#define T_NONE   0
#define T_REG    1   // REA
#define T_IMM    2   // #123 / #0x1F
#define T_REGIND 3   // [REA]
#define T_DADDR  4   // [0x900002]
#define T_SYM    5   // label
#define T_DSYM   6   // [label]

// --- small char helpers -----------------------------------------------------
int up(int c) {
    if (c >= 'a' && c <= 'z') { return c - 32; }
    return c;
}

int isDigit(int c) { return c >= '0' && c <= '9'; }

int isSpace(int c) { return c == ' ' || c == 9 || c == 13; }   // space, tab, CR

int hexVal(int c) {
    if (c >= '0' && c <= '9') { return c - '0'; }
    c = up(c);
    if (c >= 'A' && c <= 'F') { return c - 'A' + 10; }
    return 0;
}

// Compare source slice [s,e) to a null-terminated literal, case-insensitively.
int seqi(int *b, int s, int e, int *lit) {
    int n = e - s;
    int i = 0;
    while (i < n) {
        if (lit[i] == 0) { return 0; }
        if (up(b[s + i]) != up(lit[i])) { return 0; }
        i++;
    }
    return lit[i] == 0;
}

// Register name -> 0..15, or -1. REA=0 REB=1 REC=2, then REN..REZ = 3..15.
int regNum(int *b, int s, int e) {
    if (e - s != 3) { return -1; }
    if (up(b[s]) != 'R' || up(b[s + 1]) != 'E') { return -1; }
    int c = up(b[s + 2]);
    if (c == 'A') { return 0; }
    if (c == 'B') { return 1; }
    if (c == 'C') { return 2; }
    if (c >= 'N' && c <= 'Z') { return c - 'N' + 3; }
    return -1;
}

// Parse an integer from [s,e): optional '-', 0x hex or decimal.
int parseNum(int *b, int s, int e) {
    int neg = 0;
    if (s < e && b[s] == '-') { neg = 1; s++; }

    int v = 0;
    int i;
    if (s + 1 < e && b[s] == '0' && up(b[s + 1]) == 'X') {
        i = s + 2;
        while (i < e) { v = v * 16 + hexVal(b[i]); i++; }
    } else {
        i = s;
        while (i < e) {
            if (!isDigit(b[i])) { break; }
            v = v * 10 + (b[i] - '0');
            i++;
        }
    }
    if (neg) { v = -v; }
    return v;
}

// --- instruction field encoders (must match the host InstructionSet) --------
int sr(int r) { return (r & 0x1F) << 8; }    // source register
int dr(int r) { return (r & 0x1F) << 12; }   // destination register
int aa(int r) { return (r & 0xF) << 16; }    // ALU A input
int ab(int r) { return (r & 0xF) << 20; }    // ALU B input

// --- label table ------------------------------------------------------------
#define MAX_LABELS 96
#define NAME_W 24

int g_labName[2304];   // MAX_LABELS * NAME_W (cc.py needs a literal array size)
int g_labAddr[96];
int g_labCount;
int g_err;          // set when assembly hits an error

int labEq(int idx, int *b, int s, int e) {
    int base = idx * NAME_W;
    int n = e - s;
    int i = 0;
    while (i < n) {
        if (g_labName[base + i] == 0) { return 0; }
        if (g_labName[base + i] != b[s + i]) { return 0; }
        i++;
    }
    return g_labName[base + i] == 0;
}

int labEqLit(int idx, int *lit) {
    int base = idx * NAME_W;
    int i = 0;
    while (lit[i] != 0) {
        if (g_labName[base + i] != lit[i]) { return 0; }
        i++;
    }
    return g_labName[base + i] == 0;
}

// Returns label index or -1 (no error reported).
int labLookup(int *b, int s, int e) {
    int i = 0;
    while (i < g_labCount) {
        if (labEq(i, b, s, e)) { return i; }
        i++;
    }
    return -1;
}

int labLookupLit(int *lit) {
    int i = 0;
    while (i < g_labCount) {
        if (labEqLit(i, lit)) { return i; }
        i++;
    }
    return -1;
}

// Resolve a label to an address. In pass 2 an unknown label is an error.
int labResolve(int *b, int s, int e, int pass) {
    int idx = labLookup(b, s, e);
    if (idx >= 0) { return g_labAddr[idx]; }
    if (pass == 2) {
        prints("asm: undefined label: ", 0);
        int i = s;
        while (i < e) { printc(b[i]); i++; }
        printc(0xA);
        g_err = 1;
    }
    return 0;
}

void labAdd(int *b, int s, int e, int addr) {
    if (g_labCount >= MAX_LABELS) { return; }
    int base = g_labCount * NAME_W;
    int n = e - s;
    if (n > NAME_W - 1) { n = NAME_W - 1; }
    int i = 0;
    while (i < n) { g_labName[base + i] = b[s + i]; i++; }
    g_labName[base + i] = 0;
    g_labAddr[g_labCount] = addr;
    g_labCount++;
}

void labAddLit(int *lit, int addr) {
    if (g_labCount >= MAX_LABELS) { return; }
    int base = g_labCount * NAME_W;
    int i = 0;
    while (lit[i] != 0 && i < NAME_W - 1) { g_labName[base + i] = lit[i]; i++; }
    g_labName[base + i] = 0;
    g_labAddr[g_labCount] = addr;
    g_labCount++;
}

// Seed the syscall table symbols (addresses from src/syscall_table.asm).
void labSeed(void) {
    g_labCount = 0;
    labAddLit("SYS_prints",         0x00010000);
    labAddLit("SYS_ttyWriteChar",   0x00010004);
    labAddLit("SYS_ttyClearScreen", 0x00010008);
    labAddLit("SYS_cpuHalt",        0x0001000C);
    labAddLit("SYS_printi",         0x00010010);
    labAddLit("SYS_printc",         0x00010014);
    labAddLit("SYS_ttyReadChar",    0x00010018);
    labAddLit("SYS_fs_find",        0x0001001C);
    labAddLit("SYS_fs_data_ptr",    0x00010020);
    labAddLit("SYS_fs_create",      0x00010024);
    labAddLit("SYS_fs_delete",      0x00010028);
    labAddLit("SYS_fs_file_count",  0x0001002C);
    labAddLit("SYS_fs_mark_dirty",  0x00010030);
}

// --- operand parsing --------------------------------------------------------
// Operand results live in globals to avoid local arrays (cc.py-friendly).
int g_ot0;
int g_ot1;
int g_ot2;
int g_ov0;
int g_ov1;
int g_ov2;
int g_nops;

void parseOperand(int *b, int s, int e, int pass, int *type, int *val) {
    // trim
    while (s < e && isSpace(b[s])) { s++; }
    while (e > s && isSpace(b[e - 1])) { e--; }

    if (s >= e) { *type = T_NONE; *val = 0; return; }

    int c = b[s];
    int r;

    if (c == '#') {
        *type = T_IMM;
        *val = parseNum(b, s + 1, e);
        return;
    }

    if (c == '[' && b[e - 1] == ']') {
        int s2 = s + 1;
        int e2 = e - 1;
        while (s2 < e2 && isSpace(b[s2])) { s2++; }
        while (e2 > s2 && isSpace(b[e2 - 1])) { e2--; }

        r = regNum(b, s2, e2);
        if (r >= 0) { *type = T_REGIND; *val = r; return; }

        if (s2 < e2 && b[s2] == '#') { s2++; }
        if (s2 < e2 && (isDigit(b[s2]) || b[s2] == '-')) {
            *type = T_DADDR; *val = parseNum(b, s2, e2); return;
        }

        *type = T_DSYM; *val = labResolve(b, s2, e2, pass); return;
    }

    r = regNum(b, s, e);
    if (r >= 0) { *type = T_REG; *val = r; return; }

    if (isDigit(c) || c == '-') { *type = T_IMM; *val = parseNum(b, s, e); return; }

    *type = T_SYM; *val = labResolve(b, s, e, pass);
}

// Split the operand region [s,e) on commas; fill g_ot*/g_ov*/g_nops (max 3).
void parseOps(int *b, int s, int e, int pass) {
    g_nops = 0;
    g_ot0 = 0; g_ot1 = 0; g_ot2 = 0;
    g_ov0 = 0; g_ov1 = 0; g_ov2 = 0;

    int cs = s;
    int i = s;
    while (i <= e) {
        if (i == e || b[i] == ',') {
            int t;
            int v;
            parseOperand(b, cs, i, pass, &t, &v);
            if (t != T_NONE && g_nops < 3) {
                if (g_nops == 0)      { g_ot0 = t; g_ov0 = v; }
                else if (g_nops == 1) { g_ot1 = t; g_ov1 = v; }
                else                  { g_ot2 = t; g_ov2 = v; }
                g_nops++;
            }
            cs = i + 1;
        }
        i++;
    }
}

// --- mnemonic group lookups -------------------------------------------------
int g_op0;
int g_op1;
int g_op2;
int g_op3;

// ALU binary op -> g_op0 (register form), g_op1 (immediate form). Returns 1/0.
int aluOps(int *b, int s, int e) {
    if (seqi(b, s, e, "ADD"))  { g_op0 = 0x08; g_op1 = 0x49; return 1; }
    if (seqi(b, s, e, "SUB"))  { g_op0 = 0x09; g_op1 = 0x4A; return 1; }
    if (seqi(b, s, e, "MUL"))  { g_op0 = 0x0A; g_op1 = 0x4B; return 1; }
    if (seqi(b, s, e, "DIV"))  { g_op0 = 0x0B; g_op1 = 0x4C; return 1; }
    if (seqi(b, s, e, "SHL"))  { g_op0 = 0x0C; g_op1 = 0x4D; return 1; }
    if (seqi(b, s, e, "SHR"))  { g_op0 = 0x0D; g_op1 = 0x4E; return 1; }
    if (seqi(b, s, e, "NAND")) { g_op0 = 0x0E; g_op1 = 0x4F; return 1; }
    if (seqi(b, s, e, "AND"))  { g_op0 = 0x0F; g_op1 = 0x50; return 1; }
    if (seqi(b, s, e, "OR"))   { g_op0 = 0x10; g_op1 = 0x51; return 1; }
    if (seqi(b, s, e, "XOR"))  { g_op0 = 0x11; g_op1 = 0x52; return 1; }
    if (seqi(b, s, e, "NOR"))  { g_op0 = 0x12; g_op1 = 0x53; return 1; }
    return 0;
}

// JP/CALL family -> g_op0..g_op3 (imm/sym, reg, [addr], [reg]). Returns 1/0.
int ctrlOps(int *b, int s, int e) {
    if (seqi(b, s, e, "JP"))       { g_op0 = 0x14; g_op1 = 0x15; g_op2 = 0x3D; g_op3 = 0x54; return 1; }
    if (seqi(b, s, e, "JPZ"))      { g_op0 = 0x16; g_op1 = 0x17; g_op2 = 0x3E; g_op3 = 0x55; return 1; }
    if (seqi(b, s, e, "JPC"))      { g_op0 = 0x18; g_op1 = 0x19; g_op2 = 0x3F; g_op3 = 0x56; return 1; }
    if (seqi(b, s, e, "JP_EQ"))    { g_op0 = 0x2B; g_op1 = 0x2C; g_op2 = 0x45; g_op3 = 0x5C; return 1; }
    if (seqi(b, s, e, "JP_LT"))    { g_op0 = 0x2D; g_op1 = 0x2E; g_op2 = 0x46; g_op3 = 0x5D; return 1; }
    if (seqi(b, s, e, "JP_GT"))    { g_op0 = 0x2F; g_op1 = 0x30; g_op2 = 0x47; g_op3 = 0x5E; return 1; }
    if (seqi(b, s, e, "JP_NEQ"))   { g_op0 = 0x32; g_op1 = 0x33; g_op2 = 0x48; g_op3 = 0x5F; return 1; }
    if (seqi(b, s, e, "CALL"))     { g_op0 = 0x1A; g_op1 = 0x1B; g_op2 = 0x40; g_op3 = 0x57; return 1; }
    if (seqi(b, s, e, "CALL_EQ"))  { g_op0 = 0x25; g_op1 = 0x26; g_op2 = 0x41; g_op3 = 0x58; return 1; }
    if (seqi(b, s, e, "CALL_LT"))  { g_op0 = 0x27; g_op1 = 0x28; g_op2 = 0x42; g_op3 = 0x59; return 1; }
    if (seqi(b, s, e, "CALL_GT"))  { g_op0 = 0x29; g_op1 = 0x2A; g_op2 = 0x43; g_op3 = 0x5A; return 1; }
    if (seqi(b, s, e, "CALL_NEQ")) { g_op0 = 0x34; g_op1 = 0x35; g_op2 = 0x44; g_op3 = 0x5B; return 1; }
    return 0;
}

// --- DW data emission -------------------------------------------------------
int emitDW(int *b, int s, int e, int pass, int pc, int *dst) {
    int n = 0;
    int cs = s;
    int i = s;
    while (i <= e) {
        if (i == e || b[i] == ',') {
            int t;
            int v;
            parseOperand(b, cs, i, pass, &t, &v);
            if (t != T_NONE) {
                if (pass == 2) { dst[pc + n] = v; }
                n++;
            }
            cs = i + 1;
        }
        i++;
    }
    return n;
}

// --- one statement: returns word count, writes into dst[pc..] in pass 2 -----
int emitLine(int *b, int a, int e, int pass, int pc, int *dst) {
    int ms = a;
    int me = a;
    while (me < e && !isSpace(b[me])) { me++; }

    if (seqi(b, ms, me, "DW")) {
        return emitDW(b, me, e, pass, pc, dst);
    }

    parseOps(b, me, e, pass);

    int w0 = 0;
    int ex = 0;
    int he = 0;     // has extra word
    int ok = 1;

    if (seqi(b, ms, me, "NOP"))       { w0 = 0x00; }
    else if (seqi(b, ms, me, "HALT")) { w0 = 0x01; }
    else if (seqi(b, ms, me, "RTS"))  { w0 = 0x1C; }
    else if (seqi(b, ms, me, "RTI"))  { w0 = 0xFE; }
    else if (seqi(b, ms, me, "INT"))  { w0 = 0xFF; }
    else if (seqi(b, ms, me, "MOV"))  { w0 = 0x02 | sr(g_ov1) | dr(g_ov0); }
    else if (seqi(b, ms, me, "CMP"))  { w0 = 0x31 | aa(g_ov0) | ab(g_ov1); }
    else if (seqi(b, ms, me, "SCMP")) { w0 = 0x6A | aa(g_ov0) | ab(g_ov1); }
    else if (seqi(b, ms, me, "NOT")) {
        if (g_nops == 1) { w0 = 0x13 | aa(g_ov0) | dr(g_ov0); }
        else             { w0 = 0x13 | aa(g_ov0) | dr(g_ov1); }
    }
    else if (seqi(b, ms, me, "POP"))     { w0 = 0x1F | dr(g_ov0); }
    else if (seqi(b, ms, me, "GET_SP"))  { w0 = 0x21 | dr(g_ov0); }
    else if (seqi(b, ms, me, "GET_PC"))  { w0 = 0x22 | dr(g_ov0); }
    else if (seqi(b, ms, me, "GET_INT_ID")) { w0 = 0x24 | dr(g_ov0); }
    else if (seqi(b, ms, me, "SET_SP_R")) { w0 = 0x3C | sr(g_ov0); }
    else if (seqi(b, ms, me, "PUSH")) {
        if (g_ot0 == T_REG) { w0 = 0x1D | sr(g_ov0); }
        else                { w0 = 0x1E; ex = g_ov0; he = 1; }   // imm / symbol
    }
    else if (seqi(b, ms, me, "SET_SP"))  { w0 = 0x20; ex = g_ov0; he = 1; }
    else if (seqi(b, ms, me, "SET_IVR")) { w0 = 0x23; ex = g_ov0; he = 1; }
    else if (seqi(b, ms, me, "LDR_ARG")) { w0 = 0x38 | dr(g_ov0); ex = g_ov1; he = 1; }
    else if (seqi(b, ms, me, "LDR_LOC")) { w0 = 0x36 | dr(g_ov0); ex = g_ov1; he = 1; }
    else if (seqi(b, ms, me, "STR_ARG")) { w0 = 0x39 | sr(g_ov0); ex = g_ov1; he = 1; }
    else if (seqi(b, ms, me, "STR_LOC")) { w0 = 0x37 | sr(g_ov0); ex = g_ov1; he = 1; }
    else if (seqi(b, ms, me, "LDI")) {
        int df = dr(g_ov0);
        if (g_ot1 == T_IMM)        { w0 = 0x03 | df; ex = g_ov1; he = 1; }
        else if (g_ot1 == T_SYM)   { w0 = 0x03 | df; ex = g_ov1; he = 1; }
        else if (g_ot1 == T_DADDR) { w0 = 0x04 | df; ex = g_ov1; he = 1; }
        else if (g_ot1 == T_DSYM)  { w0 = 0x04 | df; ex = g_ov1; he = 1; }
        else                       { w0 = 0x05 | sr(g_ov1) | df; }  // reg / [reg]
    }
    else if (seqi(b, ms, me, "STR")) {
        int sf = sr(g_ov1);    // STR dest, src — src is a register
        if (g_ot0 == T_DADDR)     { w0 = 0x06 | sf; ex = g_ov0; he = 1; }
        else if (g_ot0 == T_SYM)  { w0 = 0x06 | sf; ex = g_ov0; he = 1; }
        else if (g_ot0 == T_DSYM) { w0 = 0x06 | sf; ex = g_ov0; he = 1; }
        else                      { w0 = 0x07 | sf | dr(g_ov0); }   // reg / [reg]
    }
    else if (aluOps(b, ms, me)) {
        if (g_nops == 3) {
            if (g_ot1 == T_IMM) { w0 = g_op1 | aa(g_ov0) | dr(g_ov2); ex = g_ov1; he = 1; }
            else                { w0 = g_op0 | aa(g_ov0) | ab(g_ov1) | dr(g_ov2); }
        } else {
            if (g_ot1 == T_IMM) { w0 = g_op1 | aa(g_ov0) | dr(g_ov0); ex = g_ov1; he = 1; }
            else                { w0 = g_op0 | aa(g_ov0) | ab(g_ov1) | dr(g_ov0); }
        }
    }
    else if (ctrlOps(b, ms, me)) {
        if (g_ot0 == T_REG)         { w0 = g_op1 | sr(g_ov0); }
        else if (g_ot0 == T_REGIND) { w0 = g_op3 | sr(g_ov0); }
        else if (g_ot0 == T_DADDR)  { w0 = g_op2; ex = g_ov0; he = 1; }
        else if (g_ot0 == T_DSYM)   { w0 = g_op2; ex = g_ov0; he = 1; }
        else                        { w0 = g_op0; ex = g_ov0; he = 1; }  // sym / imm
    }
    else {
        ok = 0;
        if (pass == 2) {
            prints("asm: unknown mnemonic: ", 0);
            int i = ms;
            while (i < me) { printc(b[i]); i++; }
            printc(0xA);
            g_err = 1;
        }
    }

    if (pass == 2 && ok) {
        dst[pc] = w0;
        if (he) { dst[pc + 1] = ex; }
    }

    if (he) { return 2; }
    return 1;
}

// --- line framing -----------------------------------------------------------
// Trim leading/trailing space and strip a trailing comment from a line.
void trimLine(int *b, int ls, int le, int *outA, int *outB) {
    int a = ls;
    int e = le;
    int i = ls;
    while (i < le) { if (b[i] == ';') { e = i; break; } i++; }
    while (a < e && isSpace(b[a])) { a++; }
    while (e > a && isSpace(b[e - 1])) { e--; }
    *outA = a;
    *outB = e;
}

// A label-definition line is a single token ending in ':'.
int isLabelDef(int *b, int a, int e) {
    if (e <= a) { return 0; }
    if (b[e - 1] != ':') { return 0; }
    int i = a;
    while (i < e - 1) { if (isSpace(b[i])) { return 0; } i++; }
    return 1;
}

// Two-pass assemble of [0,size) into dst (= .UserCode base). Returns the entry
// offset in words, or -1 on error.
int assemble(int *buf, int size, int *dst, int base) {
    g_err = 0;
    labSeed();

    int pc;
    int i;
    int le;
    int a;
    int e;

    // Pass 1: assign addresses, collect labels.
    pc = 0;
    i = 0;
    while (i < size) {
        le = i;
        while (le < size && buf[le] != 0xA) { le++; }

        trimLine(buf, i, le, &a, &e);
        if (e > a) {
            if (isLabelDef(buf, a, e)) {
                // pc is a word index; a label points at a byte address, and
                // words are 4 bytes apart (byte-addressed machine).
                labAdd(buf, a, e - 1, base + pc * 4);
            } else {
                pc = pc + emitLine(buf, a, e, 1, pc, dst);
            }
        }
        i = le + 1;
    }

    // Pass 2: emit code with resolved labels.
    pc = 0;
    i = 0;
    while (i < size) {
        le = i;
        while (le < size && buf[le] != 0xA) { le++; }

        trimLine(buf, i, le, &a, &e);
        if (e > a && !isLabelDef(buf, a, e)) {
            pc = pc + emitLine(buf, a, e, 2, pc, dst);
        }
        i = le + 1;
    }

    if (g_err) { return -1; }

    // Entry offset is a WORD index: launchProgram does `dst + entryOff` with an
    // int* dst, which already scales by 4. Labels are byte addresses, so convert.
    int idx = labLookupLit("_start");
    if (idx >= 0) { return (g_labAddr[idx] - base) >> 2; }
    return 0;
}

// --- command entry ----------------------------------------------------------
void assemblerRun(int argc, int **argv) {
    if (argc < 2) {
        prints("asm: usage: asm <file>", 1);
        return;
    }

    int *name = argv[1];
    int *entry = fs_find(name, stringLen(name));
    if (entry == 0) {
        prints("asm: file not found", 1);
        return;
    }

    int size = entry[1];
    int *src = fs_data_ptr(entry);
    int *dst = userCodeBase();

    int entryOff = assemble(src, size, dst, dst);
    if (entryOff < 0) {
        prints("asm: assembly failed", 1);
        return;
    }

    // Run it: forward args after the filename, program sees its name at argv[0].
    launchProgram(dst + entryOff, argc - 1, &argv[1]);
}
