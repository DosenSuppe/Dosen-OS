; ============================================================
; cc.py output for del.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function del(int argc, int** argv) ---
; frame: 2 local word(s)
del:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDI REA, #0x2
    PUSH REA                            ; save RHS of <
    LDR_ARG REA, #0x3                   ; argc
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_del_cmp_2
    JP_EQ L_del_cmp_2
    LDI REA, #1                         ; true
L_del_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_del_endif_1
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_0                 ; "Invalid arguments. E"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 2 local word(s))
    POP REX                             ; restore FP
    RTS
L_del_endif_1:
    LDI REA, #0x1
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; argv
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x0                   ; name
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_del_cmp_6
    LDI REA, #1                         ; true
L_del_cmp_6:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_del_endif_5
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_1                 ; "del: missing filenam"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 2 local word(s))
    POP REX                             ; restore FP
    RTS
L_del_endif_5:
    LDR_LOC REA, #0x0                   ; name
    PUSH REA                            ; arg 0
    CALL strLength
    POP REC                             ; discard arg
    STR_LOC REA, #0x1                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x1                   ; nameLen
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; name
    PUSH REA                            ; arg 0
    CALL fs_delete
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_del_cmp_9
    LDI REA, #1                         ; true
L_del_cmp_9:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_del_endif_8
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_2                 ; "File "
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; name
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_3                 ; " not found! File not"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 2 local word(s))
    POP REX                             ; restore FP
    RTS
L_del_endif_8:
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_4                 ; "File deleted."
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 2 local word(s))
    POP REX                             ; restore FP
    RTS

.CData

__cc_str_0:
    DW #0x49, #0x6E, #0x76, #0x61, #0x6C, #0x69, #0x64, #0x20, #0x61, #0x72, #0x67, #0x75, #0x6D, #0x65, #0x6E, #0x74, #0x73, #0x2E, #0x20, #0x45, #0x78, #0x70, #0x65, #0x63, #0x74, #0x65, #0x64, #0x20, #0x61, #0x74, #0x20, #0x6C, #0x65, #0x61, #0x73, #0x74, #0x20, #0x31, #0x21, #0x20, #0x64, #0x65, #0x6C, #0x20, #0x3C, #0x66, #0x69, #0x6C, #0x65, #0x6E, #0x61, #0x6D, #0x65, #0x3E, #0x20, #0; "Invalid arguments. Expected at least 1! del <filename> " + NUL
__cc_str_1:
    DW #0x64, #0x65, #0x6C, #0x3A, #0x20, #0x6D, #0x69, #0x73, #0x73, #0x69, #0x6E, #0x67, #0x20, #0x66, #0x69, #0x6C, #0x65, #0x6E, #0x61, #0x6D, #0x65, #0; "del: missing filename" + NUL
__cc_str_2:
    DW #0x46, #0x69, #0x6C, #0x65, #0x20, #0; "File " + NUL
__cc_str_3:
    DW #0x20, #0x6E, #0x6F, #0x74, #0x20, #0x66, #0x6F, #0x75, #0x6E, #0x64, #0x21, #0x20, #0x46, #0x69, #0x6C, #0x65, #0x20, #0x6E, #0x6F, #0x74, #0x20, #0x64, #0x65, #0x6C, #0x65, #0x74, #0x65, #0x64, #0x21, #0; " not found! File not deleted!" + NUL
__cc_str_4:
    DW #0x46, #0x69, #0x6C, #0x65, #0x20, #0x64, #0x65, #0x6C, #0x65, #0x74, #0x65, #0x64, #0x2E, #0; "File deleted." + NUL
