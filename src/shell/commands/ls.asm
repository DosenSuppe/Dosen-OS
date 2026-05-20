; ============================================================
; cc.py output for ls.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function ls(int argc, int** argv) ---
; frame: 5 local word(s)
ls:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    CALL fs_file_count
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x0                   ; count
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_ls_cmp_2
    LDI REA, #1                         ; true
L_ls_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_ls_endif_1
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_0                 ; "No files."
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 5 local word(s))
    POP REX                             ; restore FP
    RTS
L_ls_endif_1:
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_1                 ; "All files:"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    STR_LOC REA, #0x1                   ; *local = REA
L_ls_loop_3:
    LDR_LOC REA, #0x0                   ; count
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x1                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_ls_cmp_5
    JP_EQ L_ls_cmp_5
    LDI REA, #1                         ; true
L_ls_cmp_5:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_ls_endloop_4
    LDR_LOC REA, #0x1                   ; i
    PUSH REA                            ; arg 0
    CALL fs_entry_by_idx
    POP REC                             ; discard arg
    STR_LOC REA, #0x2                   ; *local = REA
    LDI REA, #0x1
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x2                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x3                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x1                   ; i
    PUSH REA                            ; arg 0
    CALL printi
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_2                 ; " : "
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    STR_LOC REA, #0x4                   ; *local = REA
L_ls_loop_7:
    LDR_LOC REA, #0x3                   ; nameLen
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x4                   ; j
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_ls_cmp_9
    JP_EQ L_ls_cmp_9
    LDI REA, #1                         ; true
L_ls_cmp_9:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_ls_endloop_8
    LDR_LOC REA, #0x4                   ; j
    PUSH REA                            ; save RHS of +
    LDI REA, #0x2
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x2                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    MOV REA, REX
    LDI REZ, #0x4
    SUB REA, REZ                        ; &j (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_ls_loop_7
L_ls_endloop_8:
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_3                 ; " ("
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, #0x10
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x2                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; arg 0
    CALL printi
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_4                 ; " blocks)"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    MOV REA, REX
    LDI REZ, #0x1
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_ls_loop_3
L_ls_endloop_4:
    SET_SP_R REX                        ; SP = FP (release 5 local word(s))
    POP REX                             ; restore FP
    RTS

.CData

__cc_str_0:
    DW #0x4E, #0x6F, #0x20, #0x66, #0x69, #0x6C, #0x65, #0x73, #0x2E, #0; "No files." + NUL
__cc_str_1:
    DW #0x41, #0x6C, #0x6C, #0x20, #0x66, #0x69, #0x6C, #0x65, #0x73, #0x3A, #0; "All files:" + NUL
__cc_str_2:
    DW #0x20, #0x3A, #0x20, #0          ; " : " + NUL
__cc_str_3:
    DW #0x20, #0x28, #0                 ; " (" + NUL
__cc_str_4:
    DW #0x20, #0x62, #0x6C, #0x6F, #0x63, #0x6B, #0x73, #0x29, #0; " blocks)" + NUL
