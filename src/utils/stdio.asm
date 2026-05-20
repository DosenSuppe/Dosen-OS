; ============================================================
; cc.py output for stdio.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function printc(char character) ---
; frame: 0 local word(s)
printc:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    LDR_ARG REA, #0x3                   ; character
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    POP REX                             ; restore FP
    RTS

; --- function prints(int* str, int newLine) ---
; frame: 1 local word(s)
prints:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    LDI REA, #0x0
    STR_LOC REA, #0x0                   ; *local = REA
L_prints_loop_0:
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
    JP_EQ L_prints_cmp_2
    LDI REA, #1                         ; true
L_prints_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_prints_endloop_1
    LDR_LOC REA, #0x0                   ; i
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; str
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
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
    JP L_prints_loop_0
L_prints_endloop_1:
    LDR_ARG REA, #0x4                   ; newLine
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_prints_endif_4
    LDI REA, #0xA
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
L_prints_endif_4:
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function printi(int val, int newLine) ---
; frame: 10 local word(s)
printi:
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
    PUSH #0                             ; reserve local
    MOV REA, REX
    LDI REZ, #0x9
    SUB REA, REZ                        ; &result (local)
    PUSH REA                            ; arg 1
    LDR_ARG REA, #0x3                   ; val
    PUSH REA                            ; arg 0
    CALL praseIntToString
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    MOV REA, REX
    LDI REZ, #0x9
    SUB REA, REZ                        ; &result (local)
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x1
    PUSH REA                            ; save RHS of ==
    LDR_ARG REA, #0x4                   ; newLine
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_printi_cmp_7
    LDI REA, #1                         ; true
L_printi_cmp_7:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_printi_endif_6
    LDI REA, #0xA
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
L_printi_endif_6:
    SET_SP_R REX                        ; SP = FP (release 10 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function praseIntToString(int num, char* buffer) ---
; frame: 14 local word(s)
praseIntToString:
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
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDI REA, #0x0
    STR_LOC REA, #0xA                   ; *local = REA
    LDI REA, #0x0
    STR_LOC REA, #0xB                   ; *local = REA
    LDI REA, #0x0
    STR_LOC REA, #0xC                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_ARG REA, #0x3                   ; num
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_praseIntToString_cmp_10
    LDI REA, #1                         ; true
L_praseIntToString_cmp_10:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_praseIntToString_endif_9
    LDI REA, #0x30
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x1
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    SET_SP_R REX                        ; SP = FP (release 14 local word(s))
    POP REX                             ; restore FP
    RTS
L_praseIntToString_endif_9:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of <
    LDR_ARG REA, #0x3                   ; num
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_praseIntToString_cmp_13
    JP_EQ L_praseIntToString_cmp_13
    LDI REA, #1                         ; true
L_praseIntToString_cmp_13:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_praseIntToString_endif_12
    LDI REA, #0x1
    STR_LOC REA, #0xC                   ; is_negative = value
    LDR_ARG REA, #0x3                   ; num
    PUSH REA                            ; RHS of -=
    LDR_ARG REA, #0x3                   ; num
    POP REB
    SUB REA, REB
    STR_ARG REA, #0x3                   ; num = value
    LDI REA, #0x0
    PUSH REA                            ; save RHS of <
    LDR_ARG REA, #0x3                   ; num
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_praseIntToString_cmp_17
    JP_EQ L_praseIntToString_cmp_17
    LDI REA, #1                         ; true
L_praseIntToString_cmp_17:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_praseIntToString_endif_16
    LDI REA, #0x2D
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x38
    PUSH REA                            ; save value
    LDI REA, #0x1
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x33
    PUSH REA                            ; save value
    LDI REA, #0x2
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x38
    PUSH REA                            ; save value
    LDI REA, #0x3
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x38
    PUSH REA                            ; save value
    LDI REA, #0x4
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x36
    PUSH REA                            ; save value
    LDI REA, #0x5
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x30
    PUSH REA                            ; save value
    LDI REA, #0x6
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x38
    PUSH REA                            ; save value
    LDI REA, #0x7
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x8
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    SET_SP_R REX                        ; SP = FP (release 14 local word(s))
    POP REX                             ; restore FP
    RTS
L_praseIntToString_endif_16:
L_praseIntToString_endif_12:
L_praseIntToString_loop_19:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of >
    LDR_ARG REA, #0x3                   ; num
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_LT L_praseIntToString_cmp_21
    JP_EQ L_praseIntToString_cmp_21
    LDI REA, #1                         ; true
L_praseIntToString_cmp_21:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_praseIntToString_endloop_20
    LDI REA, #0xA
    PUSH REA                            ; save RHS of %
    LDR_ARG REA, #0x3                   ; num
    POP REB                             ; REB = RHS
    PUSH REA                            ; save a
    PUSH REB                            ; save b
    DIV REA, REB                        ; REA = a / b
    POP REB                             ; REB = b
    MUL REA, REB                        ; REA = (a/b) * b
    POP REB                             ; REB = a
    SUB REB, REA, REA                   ; REA = a - (a/b)*b
    STR_LOC REA, #0xD                   ; *local = REA
    LDR_LOC REA, #0xD                   ; digit
    PUSH REA                            ; save RHS of +
    LDI REA, #0x30
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save value
    LDR_LOC REA, #0xA                   ; i
    PUSH REA                            ; save scaled index
    MOV REA, REX
    LDI REZ, #0x9
    SUB REA, REZ                        ; &temp (local)
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    MOV REA, REX
    LDI REZ, #0xA
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    LDI REA, #0xA
    PUSH REA                            ; RHS of /=
    LDR_ARG REA, #0x3                   ; num
    POP REB
    DIV REA, REB
    STR_ARG REA, #0x3                   ; num = value
    JP L_praseIntToString_loop_19
L_praseIntToString_endloop_20:
    LDR_LOC REA, #0xC                   ; is_negative
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_praseIntToString_endif_23
    LDI REA, #0x2D
    PUSH REA                            ; save value
    LDR_LOC REA, #0xB                   ; j
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    MOV REA, REX
    LDI REZ, #0xB
    SUB REA, REZ                        ; &j (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
L_praseIntToString_endif_23:
L_praseIntToString_loop_24:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of >
    LDR_LOC REA, #0xA                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_LT L_praseIntToString_cmp_26
    JP_EQ L_praseIntToString_cmp_26
    LDI REA, #1                         ; true
L_praseIntToString_cmp_26:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_praseIntToString_endloop_25
    MOV REA, REX
    LDI REZ, #0xA
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    SUB REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    LDR_LOC REA, #0xA                   ; i
    PUSH REA                            ; save scaled index
    MOV REA, REX
    LDI REZ, #0x9
    SUB REA, REZ                        ; &temp (local)
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; save value
    LDR_LOC REA, #0xB                   ; j
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    MOV REA, REX
    LDI REZ, #0xB
    SUB REA, REZ                        ; &j (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_praseIntToString_loop_24
L_praseIntToString_endloop_25:
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDR_LOC REA, #0xB                   ; j
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; buffer
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    SET_SP_R REX                        ; SP = FP (release 14 local word(s))
    POP REX                             ; restore FP
    RTS
