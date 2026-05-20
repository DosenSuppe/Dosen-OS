; ============================================================
; cc.py output for shell.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function main() ---
; frame: 0 local word(s)
main:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_0                 ; "Hello"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REX                             ; restore FP
    RTS

; --- function shellInitialize() ---
; frame: 0 local word(s)
shellInitialize:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    CALL clearBuffer
    LDI REA, #0x0
    PUSH REA                            ; arg 0
    CALL newShellLine
    POP REC                             ; discard arg
    POP REX                             ; restore FP
    RTS

; --- function clearBuffer() ---
; frame: 0 local word(s)
clearBuffer:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    LDI REA, #0x0
    LDI REY, cmdStringBufferSize        ; &cmdStringBufferSize (global)
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDI REA, cmdStringBuffer            ; &cmdStringBuffer (global)
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    POP REX                             ; restore FP
    RTS

; --- function newShellLine(int* str) ---
; frame: 0 local word(s)
newShellLine:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_1                 ; "You >"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; save RHS of !=
    LDR_ARG REA, #0x3                   ; str
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_newShellLine_cmp_2
    LDI REA, #1                         ; true
L_newShellLine_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_newShellLine_endif_1
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDR_ARG REA, #0x3                   ; str
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
L_newShellLine_endif_1:
    POP REX                             ; restore FP
    RTS

; --- function onKey() ---
; frame: 1 local word(s)
onKey:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    CALL ttyReadChar
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REY, CHAR_ENTER                 ; &CHAR_ENTER
    LDI REA, [REY]                      ; CHAR_ENTER
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x0                   ; character
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_onKey_cmp_5
    LDI REA, #1                         ; true
L_onKey_cmp_5:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_onKey_endif_4
    LDI REY, CHAR_ENTER                 ; &CHAR_ENTER
    LDI REA, [REY]                      ; CHAR_ENTER
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    CALL shellExecute
    CALL shellInitialize
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS
L_onKey_endif_4:
    LDI REY, CHAR_BACKSPACE             ; &CHAR_BACKSPACE
    LDI REA, [REY]                      ; CHAR_BACKSPACE
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x0                   ; character
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_onKey_cmp_8
    LDI REA, #1                         ; true
L_onKey_cmp_8:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_onKey_endif_7
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDI REY, cmdStringBufferSize        ; &cmdStringBufferSize
    LDI REA, [REY]                      ; cmdStringBufferSize
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_onKey_cmp_11
    LDI REA, #1                         ; true
L_onKey_cmp_11:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_onKey_endif_10
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS
L_onKey_endif_10:
    LDI REA, cmdStringBufferSize        ; &cmdStringBufferSize (global)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    SUB REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REY, cmdStringBufferSize        ; &cmdStringBufferSize
    LDI REA, [REY]                      ; cmdStringBufferSize
    PUSH REA                            ; save scaled index
    LDI REA, cmdStringBuffer            ; &cmdStringBuffer (global)
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
L_onKey_endif_7:
    LDI REY, MAX_BUFFER_SIZE            ; &MAX_BUFFER_SIZE
    LDI REA, [REY]                      ; MAX_BUFFER_SIZE
    PUSH REA                            ; save RHS of >=
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    LDI REY, cmdStringBufferSize        ; &cmdStringBufferSize
    LDI REA, [REY]                      ; cmdStringBufferSize
    POP REB                             ; REB = RHS
    ADD REA, REB
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_LT L_onKey_cmp_15
    LDI REA, #1                         ; true
L_onKey_cmp_15:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_onKey_and_end_14
    LDI REY, CHAR_BACKSPACE             ; &CHAR_BACKSPACE
    LDI REA, [REY]                      ; CHAR_BACKSPACE
    PUSH REA                            ; save RHS of !=
    LDR_LOC REA, #0x0                   ; character
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_onKey_cmp_16
    LDI REA, #1                         ; true
L_onKey_cmp_16:
    LDI REB, #0
    CMP REA, REB
    LDI REA, #0
    JP_EQ L_onKey_norm_17
    LDI REA, #1
L_onKey_norm_17:
L_onKey_and_end_14:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_onKey_endif_13
    LDI REY, CHAR_ENTER                 ; &CHAR_ENTER
    LDI REA, [REY]                      ; CHAR_ENTER
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_2                 ; "Command too long! Ma"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REY, MAX_BUFFER_SIZE            ; &MAX_BUFFER_SIZE
    LDI REA, [REY]                      ; MAX_BUFFER_SIZE
    PUSH REA                            ; arg 0
    CALL printi
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_3                 ; " characters."
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, cmdStringBuffer            ; &cmdStringBuffer
    PUSH REA                            ; arg 0
    CALL newShellLine
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS
L_onKey_endif_13:
    LDI REY, CHAR_BACKSPACE             ; &CHAR_BACKSPACE
    LDI REA, [REY]                      ; CHAR_BACKSPACE
    PUSH REA                            ; save RHS of !=
    LDR_LOC REA, #0x0                   ; character
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_onKey_cmp_20
    LDI REA, #1                         ; true
L_onKey_cmp_20:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_onKey_endif_19
    LDR_LOC REA, #0x0                   ; character
    PUSH REA                            ; save value
    LDI REY, cmdStringBufferSize        ; &cmdStringBufferSize
    LDI REA, [REY]                      ; cmdStringBufferSize
    PUSH REA                            ; save scaled index
    LDI REA, cmdStringBuffer            ; &cmdStringBuffer (global)
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, cmdStringBufferSize        ; &cmdStringBufferSize (global)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REY, cmdStringBufferSize        ; &cmdStringBufferSize
    LDI REA, [REY]                      ; cmdStringBufferSize
    PUSH REA                            ; save scaled index
    LDI REA, cmdStringBuffer            ; &cmdStringBuffer (global)
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
L_onKey_endif_19:
    LDR_LOC REA, #0x0                   ; character
    PUSH REA                            ; arg 0
    CALL printc
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function shellExecute() ---
; frame: 7 local word(s)
shellExecute:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDI REY, cmdStringBufferSize        ; &cmdStringBufferSize
    LDI REA, [REY]                      ; cmdStringBufferSize
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shellExecute_cmp_23
    LDI REA, #1                         ; true
L_shellExecute_cmp_23:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_22
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS
L_shellExecute_endif_22:
    LDI REA, #0x0
    STR_LOC REA, #0x0                   ; *local = REA
    MOV REA, REX
    LDI REZ, #0x4
    SUB REA, REZ                        ; &argv (local)
    PUSH REA                            ; arg 2
    MOV REA, REX
    LDI REZ, #0
    SUB REA, REZ                        ; &argc (local)
    PUSH REA                            ; arg 1
    LDI REA, cmdStringBuffer            ; &cmdStringBuffer
    PUSH REA                            ; arg 0
    CALL tokenize
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x0                   ; argc
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shellExecute_cmp_26
    LDI REA, #1                         ; true
L_shellExecute_cmp_26:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_25
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS
L_shellExecute_endif_25:
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    MOV REA, REX
    LDI REZ, #0x4
    SUB REA, REZ                        ; &argv (local)
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x5                   ; *local = REA
    LDR_LOC REA, #0x5                   ; cmd
    PUSH REA                            ; arg 0
    CALL strLength
    POP REC                             ; discard arg
    STR_LOC REA, #0x6                   ; *local = REA
    LDI REA, #0x2
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x6                   ; cmdLength
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shellExecute_cmp_29
    LDI REA, #1                         ; true
L_shellExecute_cmp_29:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_28
    LDI REA, __cc_str_4                 ; "ls"
    PUSH REA                            ; arg 2
    LDI REA, #0x2
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x5                   ; cmd
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_31
    MOV REA, REX
    LDI REZ, #0x4
    SUB REA, REZ                        ; &argv (local)
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; argc
    PUSH REA                            ; arg 0
    CALL ls
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS
L_shellExecute_endif_31:
L_shellExecute_endif_28:
    LDI REA, #0x3
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x6                   ; cmdLength
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shellExecute_cmp_34
    LDI REA, #1                         ; true
L_shellExecute_cmp_34:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_33
    LDI REA, __cc_str_5                 ; "cls"
    PUSH REA                            ; arg 2
    LDI REA, #0x3
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x5                   ; cmd
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_36
    CALL tty_clear_screen
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS
L_shellExecute_endif_36:
    LDI REA, __cc_str_6                 ; "del"
    PUSH REA                            ; arg 2
    LDI REA, #0x3
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x5                   ; cmd
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_38
    MOV REA, REX
    LDI REZ, #0x4
    SUB REA, REZ                        ; &argv (local)
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; argc
    PUSH REA                            ; arg 0
    CALL del
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS
L_shellExecute_endif_38:
    LDI REA, __cc_str_7                 ; "cat"
    PUSH REA                            ; arg 2
    LDI REA, #0x3
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x5                   ; cmd
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_40
    MOV REA, REX
    LDI REZ, #0x4
    SUB REA, REZ                        ; &argv (local)
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; argc
    PUSH REA                            ; arg 0
    CALL cat
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS
L_shellExecute_endif_40:
    LDI REA, __cc_str_8                 ; "run"
    PUSH REA                            ; arg 2
    LDI REA, #0x3
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x5                   ; cmd
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_42
    LDI REA, __cc_str_9                 ; "run"
    PUSH REA                            ; arg 0
    CALL print_not_impl
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS
L_shellExecute_endif_42:
L_shellExecute_endif_33:
    LDI REA, #0x4
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x6                   ; cmdLength
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shellExecute_cmp_45
    LDI REA, #1                         ; true
L_shellExecute_cmp_45:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_44
    LDI REA, __cc_str_10                ; "halt"
    PUSH REA                            ; arg 2
    LDI REA, #0x4
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x5                   ; cmd
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_47
    CALL cpu_halt
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS
L_shellExecute_endif_47:
L_shellExecute_endif_44:
    LDI REA, #0x5
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x6                   ; cmdLength
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shellExecute_cmp_50
    LDI REA, #1                         ; true
L_shellExecute_cmp_50:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_49
    LDI REA, __cc_str_11                ; "touch"
    PUSH REA                            ; arg 2
    LDI REA, #0x5
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x5                   ; cmd
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_52
    MOV REA, REX
    LDI REZ, #0x4
    SUB REA, REZ                        ; &argv (local)
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; argc
    PUSH REA                            ; arg 0
    CALL touch
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS
L_shellExecute_endif_52:
    LDI REA, __cc_str_12                ; "write"
    PUSH REA                            ; arg 2
    LDI REA, #0x5
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x5                   ; cmd
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_54
    MOV REA, REX
    LDI REZ, #0x4
    SUB REA, REZ                        ; &argv (local)
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; argc
    PUSH REA                            ; arg 0
    CALL write
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS
L_shellExecute_endif_54:
L_shellExecute_endif_49:
    LDI REA, #0x6
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x6                   ; cmdLength
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shellExecute_cmp_57
    LDI REA, #1                         ; true
L_shellExecute_cmp_57:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_56
    LDI REA, __cc_str_13                ; "dofile"
    PUSH REA                            ; arg 2
    LDI REA, #0x6
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x5                   ; cmd
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_59
    MOV REA, REX
    LDI REZ, #0x4
    SUB REA, REZ                        ; &argv (local)
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; argc
    PUSH REA                            ; arg 0
    CALL dofile
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS
L_shellExecute_endif_59:
    LDI REA, __cc_str_14                ; "blocks"
    PUSH REA                            ; arg 2
    LDI REA, #0x6
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x5                   ; cmd
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shellExecute_endif_61
    MOV REA, REX
    LDI REZ, #0x4
    SUB REA, REZ                        ; &argv (local)
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x0                   ; argc
    PUSH REA                            ; arg 0
    CALL blocks
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS
L_shellExecute_endif_61:
L_shellExecute_endif_56:
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_15                ; "Command not found!"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    SET_SP_R REX                        ; SP = FP (release 7 local word(s))
    POP REX                             ; restore FP
    RTS

.CData

CHAR_BACKSPACE:
    DW #0x8                             ; const int
CHAR_ENTER:
    DW #0xA                             ; const int
CHAR_SPACE:
    DW #0x20                            ; const int
MAX_BUFFER_SIZE:
    DW #0x40                            ; const int
cmdStringBufferSize:
    DW #0x0                             ; int
cmdStringBuffer:
    DW #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0; char[64]
__cc_str_0:
    DW #0x48, #0x65, #0x6C, #0x6C, #0x6F, #0; "Hello" + NUL
__cc_str_1:
    DW #0x59, #0x6F, #0x75, #0x20, #0x3E, #0; "You >" + NUL
__cc_str_2:
    DW #0x43, #0x6F, #0x6D, #0x6D, #0x61, #0x6E, #0x64, #0x20, #0x74, #0x6F, #0x6F, #0x20, #0x6C, #0x6F, #0x6E, #0x67, #0x21, #0x20, #0x4D, #0x61, #0x78, #0x3A, #0x20, #0; "Command too long! Max: " + NUL
__cc_str_3:
    DW #0x20, #0x63, #0x68, #0x61, #0x72, #0x61, #0x63, #0x74, #0x65, #0x72, #0x73, #0x2E, #0; " characters." + NUL
__cc_str_4:
    DW #0x6C, #0x73, #0                 ; "ls" + NUL
__cc_str_5:
    DW #0x63, #0x6C, #0x73, #0          ; "cls" + NUL
__cc_str_6:
    DW #0x64, #0x65, #0x6C, #0          ; "del" + NUL
__cc_str_7:
    DW #0x63, #0x61, #0x74, #0          ; "cat" + NUL
__cc_str_8:
    DW #0x72, #0x75, #0x6E, #0          ; "run" + NUL
__cc_str_9:
    DW #0x72, #0x75, #0x6E, #0          ; "run" + NUL
__cc_str_10:
    DW #0x68, #0x61, #0x6C, #0x74, #0   ; "halt" + NUL
__cc_str_11:
    DW #0x74, #0x6F, #0x75, #0x63, #0x68, #0; "touch" + NUL
__cc_str_12:
    DW #0x77, #0x72, #0x69, #0x74, #0x65, #0; "write" + NUL
__cc_str_13:
    DW #0x64, #0x6F, #0x66, #0x69, #0x6C, #0x65, #0; "dofile" + NUL
__cc_str_14:
    DW #0x62, #0x6C, #0x6F, #0x63, #0x6B, #0x73, #0; "blocks" + NUL
__cc_str_15:
    DW #0x43, #0x6F, #0x6D, #0x6D, #0x61, #0x6E, #0x64, #0x20, #0x6E, #0x6F, #0x74, #0x20, #0x66, #0x6F, #0x75, #0x6E, #0x64, #0x21, #0; "Command not found!" + NUL
