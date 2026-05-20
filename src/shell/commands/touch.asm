; ============================================================
; cc.py output for touch.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function touch(int argc, int** argv) ---
; frame: 3 local word(s)
touch:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDI REA, #0x2
    PUSH REA                            ; save RHS of <
    LDR_ARG REA, #0x3                   ; argc
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_touch_cmp_2
    JP_EQ L_touch_cmp_2
    LDI REA, #1                         ; true
L_touch_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_touch_endif_1
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_0                 ; "touch: missing filen"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 3 local word(s))
    POP REX                             ; restore FP
    RTS
L_touch_endif_1:
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
    LDI REA, #0xC
    PUSH REA                            ; save RHS of >
    LDR_LOC REA, #0x1                   ; nameLen
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_LT L_touch_cmp_6
    JP_EQ L_touch_cmp_6
    LDI REA, #1                         ; true
L_touch_cmp_6:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_touch_endif_5
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_1                 ; "touch: filename too "
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 3 local word(s))
    POP REX                             ; restore FP
    RTS
L_touch_endif_5:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of !=
    LDR_LOC REA, #0x1                   ; nameLen
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; name
    PUSH REA                            ; arg 0
    CALL fs_find
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_touch_cmp_9
    LDI REA, #1                         ; true
L_touch_cmp_9:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_touch_endif_8
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_2                 ; "touch: already exist"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 3 local word(s))
    POP REX                             ; restore FP
    RTS
L_touch_endif_8:
    LDR_LOC REA, #0x1                   ; nameLen
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; name
    PUSH REA                            ; arg 0
    CALL fs_create
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    STR_LOC REA, #0x2                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x2                   ; e
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_touch_cmp_12
    LDI REA, #1                         ; true
L_touch_cmp_12:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_touch_endif_11
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_3                 ; "touch: no free slots"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 3 local word(s))
    POP REX                             ; restore FP
    RTS
L_touch_endif_11:
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_4                 ; "Created."
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 3 local word(s))
    POP REX                             ; restore FP
    RTS

.CData

__cc_str_0:
    DW #0x74, #0x6F, #0x75, #0x63, #0x68, #0x3A, #0x20, #0x6D, #0x69, #0x73, #0x73, #0x69, #0x6E, #0x67, #0x20, #0x66, #0x69, #0x6C, #0x65, #0x6E, #0x61, #0x6D, #0x65, #0; "touch: missing filename" + NUL
__cc_str_1:
    DW #0x74, #0x6F, #0x75, #0x63, #0x68, #0x3A, #0x20, #0x66, #0x69, #0x6C, #0x65, #0x6E, #0x61, #0x6D, #0x65, #0x20, #0x74, #0x6F, #0x6F, #0x20, #0x6C, #0x6F, #0x6E, #0x67, #0x20, #0x28, #0x6D, #0x61, #0x78, #0x20, #0x31, #0x32, #0x29, #0; "touch: filename too long (max 12)" + NUL
__cc_str_2:
    DW #0x74, #0x6F, #0x75, #0x63, #0x68, #0x3A, #0x20, #0x61, #0x6C, #0x72, #0x65, #0x61, #0x64, #0x79, #0x20, #0x65, #0x78, #0x69, #0x73, #0x74, #0x73, #0; "touch: already exists" + NUL
__cc_str_3:
    DW #0x74, #0x6F, #0x75, #0x63, #0x68, #0x3A, #0x20, #0x6E, #0x6F, #0x20, #0x66, #0x72, #0x65, #0x65, #0x20, #0x73, #0x6C, #0x6F, #0x74, #0x73, #0; "touch: no free slots" + NUL
__cc_str_4:
    DW #0x43, #0x72, #0x65, #0x61, #0x74, #0x65, #0x64, #0x2E, #0; "Created." + NUL
