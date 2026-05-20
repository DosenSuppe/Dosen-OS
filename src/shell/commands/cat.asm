; ============================================================
; cc.py output for cat.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function cat(int argc, int** argv) ---
; frame: 8 local word(s)
cat:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDI REA, #0x2
    PUSH REA                            ; save RHS of <
    LDR_ARG REA, #0x3                   ; argc
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_cat_cmp_2
    JP_EQ L_cat_cmp_2
    LDI REA, #1                         ; true
L_cat_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_cat_endif_1
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_0                 ; "Invalid arguments. E"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 8 local word(s))
    POP REX                             ; restore FP
    RTS
L_cat_endif_1:
    LDI REA, #0x1
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; argv
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x0                   ; *local = REA
    LDR_LOC REA, #0x0                   ; name
    PUSH REA                            ; arg 0
    CALL strLength
    POP REC                             ; discard arg
    STR_LOC REA, #0x1                   ; *local = REA
    LDR_LOC REA, #0x1                   ; nameLen
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; name
    PUSH REA                            ; arg 0
    CALL fs_find
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    STR_LOC REA, #0x2                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x2                   ; e
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_cat_cmp_6
    LDI REA, #1                         ; true
L_cat_cmp_6:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_cat_endif_5
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_1                 ; "File not found!"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 8 local word(s))
    POP REX                             ; restore FP
    RTS
L_cat_endif_5:
    LDI REA, #0x10
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x2                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x3                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x3                   ; bc
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_cat_cmp_9
    LDI REA, #1                         ; true
L_cat_cmp_9:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_cat_endif_8
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_2                 ; "(file is empty)"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 8 local word(s))
    POP REX                             ; restore FP
    RTS
L_cat_endif_8:
    LDI REA, #0x0
    STR_LOC REA, #0x4                   ; *local = REA
L_cat_loop_10:
    LDR_LOC REA, #0x3                   ; bc
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x4                   ; b
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_cat_cmp_12
    JP_EQ L_cat_cmp_12
    LDI REA, #1                         ; true
L_cat_cmp_12:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_cat_endloop_11
    LDR_LOC REA, #0x4                   ; b
    PUSH REA                            ; save RHS of +
    LDI REA, #0x11
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x2                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; arg 0
    CALL fs_block_data
    POP REC                             ; discard arg
    STR_LOC REA, #0x5                   ; *local = REA
    LDI REA, #0x0
    STR_LOC REA, #0x6                   ; *local = REA
L_cat_loop_14:
    LDI REA, #0x40
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x6                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_cat_cmp_16
    JP_EQ L_cat_cmp_16
    LDI REA, #1                         ; true
L_cat_cmp_16:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_cat_endloop_15
    LDR_LOC REA, #0x6                   ; i
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x5                   ; blk
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x7                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x7                   ; ch
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_cat_cmp_20
    LDI REA, #1                         ; true
L_cat_cmp_20:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_cat_endif_19
    LDI REY, CHAR_ENTER                 ; &CHAR_ENTER
    LDI REA, [REY]                      ; CHAR_ENTER
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 8 local word(s))
    POP REX                             ; restore FP
    RTS
L_cat_endif_19:
    LDR_LOC REA, #0x7                   ; ch
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    MOV REA, REX
    LDI REZ, #0x6
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_cat_loop_14
L_cat_endloop_15:
    MOV REA, REX
    LDI REZ, #0x4
    SUB REA, REZ                        ; &b (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_cat_loop_10
L_cat_endloop_11:
    LDI REY, CHAR_ENTER                 ; &CHAR_ENTER
    LDI REA, [REY]                      ; CHAR_ENTER
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 8 local word(s))
    POP REX                             ; restore FP
    RTS

.CData

CHAR_ENTER:
    DW #0xA                             ; const int
__cc_str_0:
    DW #0x49, #0x6E, #0x76, #0x61, #0x6C, #0x69, #0x64, #0x20, #0x61, #0x72, #0x67, #0x75, #0x6D, #0x65, #0x6E, #0x74, #0x73, #0x2E, #0x20, #0x45, #0x78, #0x70, #0x65, #0x63, #0x74, #0x65, #0x64, #0x20, #0x61, #0x74, #0x20, #0x6C, #0x65, #0x61, #0x73, #0x74, #0x20, #0x31, #0x21, #0x20, #0x63, #0x61, #0x74, #0x20, #0x3C, #0x66, #0x69, #0x6C, #0x65, #0x6E, #0x61, #0x6D, #0x65, #0x3E, #0x20, #0; "Invalid arguments. Expected at least 1! cat <filename> " + NUL
__cc_str_1:
    DW #0x46, #0x69, #0x6C, #0x65, #0x20, #0x6E, #0x6F, #0x74, #0x20, #0x66, #0x6F, #0x75, #0x6E, #0x64, #0x21, #0; "File not found!" + NUL
__cc_str_2:
    DW #0x28, #0x66, #0x69, #0x6C, #0x65, #0x20, #0x69, #0x73, #0x20, #0x65, #0x6D, #0x70, #0x74, #0x79, #0x29, #0; "(file is empty)" + NUL
