; ============================================================
; cc.py output for dofile.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function dofile(int argc, int** argv) ---
; frame: 6 local word(s)
dofile:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
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
    JP_GT L_dofile_cmp_2
    JP_EQ L_dofile_cmp_2
    LDI REA, #1                         ; true
L_dofile_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_dofile_endif_1
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_0                 ; "Invalid arguments. E"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 6 local word(s))
    POP REX                             ; restore FP
    RTS
L_dofile_endif_1:
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
    JP_NEQ L_dofile_cmp_6
    LDI REA, #1                         ; true
L_dofile_cmp_6:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_dofile_endif_5
    LDR_LOC REA, #0x1                   ; nameLen
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; name
    PUSH REA                            ; arg 0
    CALL fs_create
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    STR_LOC REA, #0x2                   ; e = value
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x2                   ; e
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_dofile_cmp_9
    LDI REA, #1                         ; true
L_dofile_cmp_9:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_dofile_endif_8
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_1                 ; "dofile: cannot creat"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 6 local word(s))
    POP REX                             ; restore FP
    RTS
L_dofile_endif_8:
L_dofile_endif_5:
    LDR_LOC REA, #0x2                   ; e
    PUSH REA                            ; arg 0
    CALL fs_alloc_block
    POP REC                             ; discard arg
    STR_LOC REA, #0x3                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x3                   ; bid
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_dofile_cmp_12
    JP_EQ L_dofile_cmp_12
    LDI REA, #1                         ; true
L_dofile_cmp_12:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_dofile_endif_11
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_2                 ; "dofile: no free bloc"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 6 local word(s))
    POP REX                             ; restore FP
    RTS
L_dofile_endif_11:
    LDR_LOC REA, #0x3                   ; bid
    PUSH REA                            ; arg 0
    CALL fs_block_data
    POP REC                             ; discard arg
    STR_LOC REA, #0x4                   ; *local = REA
    LDI REA, #0x48
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x4                   ; blk
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x69
    PUSH REA                            ; save value
    LDI REA, #0x1
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x4                   ; blk
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x21
    PUSH REA                            ; save value
    LDI REA, #0x2
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x4                   ; blk
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x3
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x4                   ; blk
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_3                 ; "Wrote block "
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x3                   ; bid
    PUSH REA                            ; arg 0
    CALL printi
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_4                 ; " to "
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    STR_LOC REA, #0x5                   ; *local = REA
L_dofile_loop_14:
    LDR_LOC REA, #0x1                   ; nameLen
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x5                   ; j
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_dofile_cmp_16
    JP_EQ L_dofile_cmp_16
    LDI REA, #1                         ; true
L_dofile_cmp_16:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_dofile_endloop_15
    LDR_LOC REA, #0x5                   ; j
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; name
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    MOV REA, REX
    LDI REZ, #0x5
    SUB REA, REZ                        ; &j (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_dofile_loop_14
L_dofile_endloop_15:
    LDI REA, #0xA
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 6 local word(s))
    POP REX                             ; restore FP
    RTS

.CData

__cc_str_0:
    DW #0x49, #0x6E, #0x76, #0x61, #0x6C, #0x69, #0x64, #0x20, #0x61, #0x72, #0x67, #0x75, #0x6D, #0x65, #0x6E, #0x74, #0x73, #0x2E, #0x20, #0x45, #0x78, #0x70, #0x65, #0x63, #0x74, #0x65, #0x64, #0x20, #0x61, #0x74, #0x20, #0x6C, #0x65, #0x61, #0x73, #0x74, #0x20, #0x31, #0x21, #0x20, #0x64, #0x6F, #0x66, #0x69, #0x6C, #0x65, #0x20, #0x3C, #0x66, #0x69, #0x6C, #0x65, #0x6E, #0x61, #0x6D, #0x65, #0x3E, #0x20, #0; "Invalid arguments. Expected at least 1! dofile <filename> " + NUL
__cc_str_1:
    DW #0x64, #0x6F, #0x66, #0x69, #0x6C, #0x65, #0x3A, #0x20, #0x63, #0x61, #0x6E, #0x6E, #0x6F, #0x74, #0x20, #0x63, #0x72, #0x65, #0x61, #0x74, #0x65, #0; "dofile: cannot create" + NUL
__cc_str_2:
    DW #0x64, #0x6F, #0x66, #0x69, #0x6C, #0x65, #0x3A, #0x20, #0x6E, #0x6F, #0x20, #0x66, #0x72, #0x65, #0x65, #0x20, #0x62, #0x6C, #0x6F, #0x63, #0x6B, #0x73, #0; "dofile: no free blocks" + NUL
__cc_str_3:
    DW #0x57, #0x72, #0x6F, #0x74, #0x65, #0x20, #0x62, #0x6C, #0x6F, #0x63, #0x6B, #0x20, #0; "Wrote block " + NUL
__cc_str_4:
    DW #0x20, #0x74, #0x6F, #0x20, #0   ; " to " + NUL
