; ============================================================
; cc.py output for write.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function write(int argc, int** argv) ---
; frame: 9 local word(s)
write:
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
    PUSH #0                             ; reserve local
    LDI REA, #0x3
    PUSH REA                            ; save RHS of <
    LDR_ARG REA, #0x3                   ; argc
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_write_cmp_2
    JP_EQ L_write_cmp_2
    LDI REA, #1                         ; true
L_write_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_write_endif_1
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_0                 ; "write: usage: write "
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 9 local word(s))
    POP REX                             ; restore FP
    RTS
L_write_endif_1:
    LDI REA, #0x1
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; argv
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REA, #0x2
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; argv
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x1                   ; *local = REA
    LDR_LOC REA, #0x0                   ; name
    PUSH REA                            ; arg 0
    CALL strLength
    POP REC                             ; discard arg
    STR_LOC REA, #0x2                   ; *local = REA
    LDR_LOC REA, #0x1                   ; text
    PUSH REA                            ; arg 0
    CALL strLength
    POP REC                             ; discard arg
    STR_LOC REA, #0x3                   ; *local = REA
    LDR_LOC REA, #0x2                   ; nameLen
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; name
    PUSH REA                            ; arg 0
    CALL fs_find
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    STR_LOC REA, #0x4                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x4                   ; e
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_write_cmp_6
    LDI REA, #1                         ; true
L_write_cmp_6:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_write_endif_5
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_1                 ; "write: not found (to"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 9 local word(s))
    POP REX                             ; restore FP
    RTS
L_write_endif_5:
    LDR_LOC REA, #0x4                   ; e
    PUSH REA                            ; arg 0
    CALL fs_free_blocks
    POP REC                             ; discard arg
    LDI REA, #0x0
    STR_LOC REA, #0x5                   ; *local = REA
    LDI REA, #0x0
    STR_LOC REA, #0x6                   ; *local = REA
L_write_loop_7:
    LDR_LOC REA, #0x3                   ; textLen
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x5                   ; written
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_write_cmp_9
    JP_EQ L_write_cmp_9
    LDI REA, #1                         ; true
L_write_cmp_9:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_write_endloop_8
    LDR_LOC REA, #0x4                   ; e
    PUSH REA                            ; arg 0
    CALL fs_alloc_block
    POP REC                             ; discard arg
    STR_LOC REA, #0x7                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x7                   ; bid
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_write_cmp_13
    JP_EQ L_write_cmp_13
    LDI REA, #1                         ; true
L_write_cmp_13:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_write_endif_12
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_2                 ; "write: out of blocks"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 9 local word(s))
    POP REX                             ; restore FP
    RTS
L_write_endif_12:
    LDR_LOC REA, #0x7                   ; bid
    PUSH REA                            ; arg 0
    CALL fs_block_data
    POP REC                             ; discard arg
    STR_LOC REA, #0x8                   ; *local = REA
    LDI REA, #0x0
    STR_LOC REA, #0x6                   ; i = value
L_write_loop_15:
    LDI REA, #0x40
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x6                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_write_cmp_17
    JP_EQ L_write_cmp_17
    LDI REA, #1                         ; true
L_write_cmp_17:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_write_endloop_16
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDR_LOC REA, #0x6                   ; i
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x8                   ; blk
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
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
    JP L_write_loop_15
L_write_endloop_16:
    LDI REA, #0x0
    STR_LOC REA, #0x6                   ; i = value
L_write_loop_19:
    LDI REA, #0x40
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x6                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_write_cmp_22
    JP_EQ L_write_cmp_22
    LDI REA, #1                         ; true
L_write_cmp_22:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_write_and_end_21
    LDR_LOC REA, #0x3                   ; textLen
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x5                   ; written
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_write_cmp_24
    JP_EQ L_write_cmp_24
    LDI REA, #1                         ; true
L_write_cmp_24:
    LDI REB, #0
    CMP REA, REB
    LDI REA, #0
    JP_EQ L_write_norm_26
    LDI REA, #1
L_write_norm_26:
L_write_and_end_21:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_write_endloop_20
    LDR_LOC REA, #0x5                   ; written
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; text
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; save value
    LDR_LOC REA, #0x6                   ; i
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x8                   ; blk
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    LDR_LOC REA, #0x5                   ; written
    POP REB                             ; REB = RHS
    ADD REA, REB
    STR_LOC REA, #0x5                   ; written = value
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
    JP L_write_loop_19
L_write_endloop_20:
    JP L_write_loop_7
L_write_endloop_8:
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_3                 ; "Wrote "
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x3                   ; textLen
    PUSH REA                            ; arg 0
    CALL printi
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_4                 ; " chars."
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 9 local word(s))
    POP REX                             ; restore FP
    RTS

.CData

__cc_str_0:
    DW #0x77, #0x72, #0x69, #0x74, #0x65, #0x3A, #0x20, #0x75, #0x73, #0x61, #0x67, #0x65, #0x3A, #0x20, #0x77, #0x72, #0x69, #0x74, #0x65, #0x20, #0x3C, #0x6E, #0x61, #0x6D, #0x65, #0x3E, #0x20, #0x3C, #0x74, #0x65, #0x78, #0x74, #0x3E, #0; "write: usage: write <name> <text>" + NUL
__cc_str_1:
    DW #0x77, #0x72, #0x69, #0x74, #0x65, #0x3A, #0x20, #0x6E, #0x6F, #0x74, #0x20, #0x66, #0x6F, #0x75, #0x6E, #0x64, #0x20, #0x28, #0x74, #0x6F, #0x75, #0x63, #0x68, #0x20, #0x69, #0x74, #0x20, #0x66, #0x69, #0x72, #0x73, #0x74, #0x29, #0; "write: not found (touch it first)" + NUL
__cc_str_2:
    DW #0x77, #0x72, #0x69, #0x74, #0x65, #0x3A, #0x20, #0x6F, #0x75, #0x74, #0x20, #0x6F, #0x66, #0x20, #0x62, #0x6C, #0x6F, #0x63, #0x6B, #0x73, #0; "write: out of blocks" + NUL
__cc_str_3:
    DW #0x57, #0x72, #0x6F, #0x74, #0x65, #0x20, #0; "Wrote " + NUL
__cc_str_4:
    DW #0x20, #0x63, #0x68, #0x61, #0x72, #0x73, #0x2E, #0; " chars." + NUL
