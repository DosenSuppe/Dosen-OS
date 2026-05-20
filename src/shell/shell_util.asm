; ============================================================
; cc.py output for shell_util.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function print_not_impl(int* str) ---
; frame: 0 local word(s)
print_not_impl:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDR_ARG REA, #0x3                   ; str
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_0                 ; ": TODO"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REX                             ; restore FP
    RTS

; --- function matches(int* buf, int len, int* str) ---
; frame: 1 local word(s)
matches:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    LDI REA, #0x0
    STR_LOC REA, #0x0                   ; *local = REA
L_matches_loop_0:
    LDR_ARG REA, #0x4                   ; len
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x0                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_matches_cmp_2
    JP_EQ L_matches_cmp_2
    LDI REA, #1                         ; true
L_matches_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_matches_endloop_1
    LDR_LOC REA, #0x0                   ; i
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x5                   ; str
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; save RHS of !=
    LDR_LOC REA, #0x0                   ; i
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_matches_cmp_6
    LDI REA, #1                         ; true
L_matches_cmp_6:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_matches_endif_5
    LDI REA, #0x0
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS
L_matches_endif_5:
    MOV REA, REX
    LDI REZ, #0
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_matches_loop_0
L_matches_endloop_1:
    LDR_ARG REA, #0x4                   ; len
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x5                   ; str
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_matches_endif_8
    LDI REA, #0x0
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS
L_matches_endif_8:
    LDI REA, #0x1
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function files_buffer() ---
; frame: 0 local word(s)
files_buffer:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
; inline asm
LDI REA, $FilenameStorage.Start
    POP REX                             ; restore FP
    RTS

; --- function tokenize(char* str, int* argc, int** argv) ---
; frame: 2 local word(s)
tokenize:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDI REA, #0x0
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REA, #0x0
    STR_LOC REA, #0x1                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDR_ARG REA, #0x4                   ; argc
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
L_tokenize_loop_9:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of !=
    LDR_LOC REA, #0x0                   ; i
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; str
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_tokenize_cmp_11
    LDI REA, #1                         ; true
L_tokenize_cmp_11:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_tokenize_endloop_10
    LDI REY, CHAR_SPACE                 ; &CHAR_SPACE
    LDI REA, [REY]                      ; CHAR_SPACE
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x0                   ; i
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; str
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_tokenize_cmp_14
    LDI REA, #1                         ; true
L_tokenize_cmp_14:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_tokenize_else_12
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDR_LOC REA, #0x0                   ; i
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; str
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    STR_LOC REA, #0x1                   ; inToken = value
    JP L_tokenize_endif_13
L_tokenize_else_12:
    LDR_LOC REA, #0x1                   ; inToken
    LDI REB, #0
    CMP REA, REB
    LDI REA, #0
    JP_NEQ L_tokenize_not_17
    LDI REA, #1
L_tokenize_not_17:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_tokenize_endif_16
    LDR_LOC REA, #0x0                   ; i
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; str
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    PUSH REA                            ; save value
    LDR_ARG REA, #0x4                   ; argc
    MOV REY, REA
    LDI REA, [REY]                      ; *p
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x5                   ; argv
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDR_ARG REA, #0x4                   ; argc
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    LDI REA, #0x1
    STR_LOC REA, #0x1                   ; inToken = value
L_tokenize_endif_16:
L_tokenize_endif_13:
    MOV REA, REX
    LDI REZ, #0
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_tokenize_loop_9
L_tokenize_endloop_10:
    SET_SP_R REX                        ; SP = FP (release 2 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function strLength(int* str) ---
; frame: 1 local word(s)
strLength:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    LDI REA, #0x0
    STR_LOC REA, #0x0                   ; i = value
L_strLength_for_18:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of !=
    LDR_LOC REA, #0x0                   ; i
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; str
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_strLength_cmp_21
    LDI REA, #1                         ; true
L_strLength_cmp_21:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_strLength_endfor_20
L_strLength_forcont_19:
    MOV REA, REX
    LDI REZ, #0
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_strLength_for_18
L_strLength_endfor_20:
    LDR_LOC REA, #0x0                   ; i
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS

.CData

CHAR_SPACE:
    DW #0x20                            ; const int
__cc_str_0:
    DW #0x3A, #0x20, #0x54, #0x4F, #0x44, #0x4F, #0; ": TODO" + NUL
