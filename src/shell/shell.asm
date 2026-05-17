; ============================================================
; cc.py output for shell.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function cmd_buffer() ---
; frame: 0 local word(s)
cmd_buffer:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
; inline asm
LDI REA, $CommandCharacterBuffer.Start
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

; --- function int_to_decimal_string(int num, char* buffer) ---
; frame: 14 local word(s)
int_to_decimal_string:
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
    MOV REY, REX
    LDI REZ, #0xA
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    LDI REA, #0x0
    MOV REY, REX
    LDI REZ, #0xB
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    LDI REA, #0x0
    MOV REY, REX
    LDI REZ, #0xC
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    LDI REA, #0xA
    PUSH REA                            ; save RHS of %
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &num (arg)
    LDI REA, [REY]                      ; num
    POP REB                             ; REB = RHS
    PUSH REA                            ; save a
    PUSH REB                            ; save b
    DIV REA, REB                        ; REA = a / b
    POP REB                             ; REB = b
    MUL REA, REB                        ; REA = (a/b) * b
    POP REB                             ; REB = a
    SUB REB, REA, REA                   ; REA = a - (a/b)*b
    MOV REY, REX
    LDI REZ, #0xD
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &num (arg)
    LDI REA, [REY]                      ; num
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_int_to_decimal_string_cmp_2
    LDI REA, #1                         ; true
L_int_to_decimal_string_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_int_to_decimal_string_endif_1
    LDI REA, #0x30
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x1
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_int_to_decimal_string_endif_1:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of <
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &num (arg)
    LDI REA, [REY]                      ; num
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_int_to_decimal_string_cmp_5
    JP_EQ L_int_to_decimal_string_cmp_5
    LDI REA, #1                         ; true
L_int_to_decimal_string_cmp_5:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_int_to_decimal_string_endif_4
    LDI REA, #0x1
    MOV REY, REX
    LDI REZ, #0xC
    SUB REY, REZ                        ; &is_negative (local)
    STR REY, REA                        ; *target = value
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &num (arg)
    LDI REA, [REY]                      ; num
    LDI REB, #0
    SUB REB, REA, REA                   ; REA = 0 - REA
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &num (arg)
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save RHS of <
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &num (arg)
    LDI REA, [REY]                      ; num
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_int_to_decimal_string_cmp_9
    JP_EQ L_int_to_decimal_string_cmp_9
    LDI REA, #1                         ; true
L_int_to_decimal_string_cmp_9:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_int_to_decimal_string_endif_8
    LDI REA, #0x2D
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x38
    PUSH REA                            ; save value
    LDI REA, #0x1
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x33
    PUSH REA                            ; save value
    LDI REA, #0x2
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x38
    PUSH REA                            ; save value
    LDI REA, #0x3
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x38
    PUSH REA                            ; save value
    LDI REA, #0x4
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x36
    PUSH REA                            ; save value
    LDI REA, #0x5
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x30
    PUSH REA                            ; save value
    LDI REA, #0x6
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x38
    PUSH REA                            ; save value
    LDI REA, #0x7
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x8
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_int_to_decimal_string_endif_8:
L_int_to_decimal_string_endif_4:
L_int_to_decimal_string_loop_11:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of >
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &num (arg)
    LDI REA, [REY]                      ; num
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_LT L_int_to_decimal_string_cmp_13
    JP_EQ L_int_to_decimal_string_cmp_13
    LDI REA, #1                         ; true
L_int_to_decimal_string_cmp_13:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_int_to_decimal_string_endloop_12
    LDI REA, #0xA
    PUSH REA                            ; save RHS of %
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &num (arg)
    LDI REA, [REY]                      ; num
    POP REB                             ; REB = RHS
    PUSH REA                            ; save a
    PUSH REB                            ; save b
    DIV REA, REB                        ; REA = a / b
    POP REB                             ; REB = b
    MUL REA, REB                        ; REA = (a/b) * b
    POP REB                             ; REB = a
    SUB REB, REA, REA                   ; REA = a - (a/b)*b
    MOV REY, REX
    LDI REZ, #0xD
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    MOV REY, REX
    LDI REZ, #0xD
    SUB REY, REZ                        ; &digit (local)
    LDI REA, [REY]                      ; digit
    PUSH REA                            ; save RHS of +
    LDI REA, #0x30
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save value
    MOV REY, REX
    LDI REZ, #0xA
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    PUSH REA                            ; save index
    MOV REA, REX
    LDI REZ, #0x9
    SUB REA, REZ                        ; &temp (local)
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0xA
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    POP REB                             ; REB = RHS
    ADD REA, REB
    MOV REY, REX
    LDI REZ, #0xA
    SUB REY, REZ                        ; &i (local)
    STR REY, REA                        ; *target = value
    LDI REA, #0xA
    PUSH REA                            ; save RHS of /
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &num (arg)
    LDI REA, [REY]                      ; num
    POP REB                             ; REB = RHS
    DIV REA, REB
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &num (arg)
    STR REY, REA                        ; *target = value
    JP L_int_to_decimal_string_loop_11
L_int_to_decimal_string_endloop_12:
    MOV REY, REX
    LDI REZ, #0xC
    SUB REY, REZ                        ; &is_negative (local)
    LDI REA, [REY]                      ; is_negative
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_int_to_decimal_string_endif_15
    LDI REA, #0x2D
    PUSH REA                            ; save value
    MOV REY, REX
    LDI REZ, #0xB
    SUB REY, REZ                        ; &j (local)
    LDI REA, [REY]                      ; j
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0xB
    SUB REY, REZ                        ; &j (local)
    LDI REA, [REY]                      ; j
    POP REB                             ; REB = RHS
    ADD REA, REB
    MOV REY, REX
    LDI REZ, #0xB
    SUB REY, REZ                        ; &j (local)
    STR REY, REA                        ; *target = value
L_int_to_decimal_string_endif_15:
L_int_to_decimal_string_loop_16:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of >
    MOV REY, REX
    LDI REZ, #0xA
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_LT L_int_to_decimal_string_cmp_18
    JP_EQ L_int_to_decimal_string_cmp_18
    LDI REA, #1                         ; true
L_int_to_decimal_string_cmp_18:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_int_to_decimal_string_endloop_17
    LDI REA, #0x1
    PUSH REA                            ; save RHS of -
    MOV REY, REX
    LDI REZ, #0xA
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    POP REB                             ; REB = RHS
    SUB REA, REB
    MOV REY, REX
    LDI REZ, #0xA
    SUB REY, REZ                        ; &i (local)
    STR REY, REA                        ; *target = value
    MOV REY, REX
    LDI REZ, #0xA
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    PUSH REA                            ; save index
    MOV REA, REX
    LDI REZ, #0x9
    SUB REA, REZ                        ; &temp (local)
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; save value
    MOV REY, REX
    LDI REZ, #0xB
    SUB REY, REZ                        ; &j (local)
    LDI REA, [REY]                      ; j
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0xB
    SUB REY, REZ                        ; &j (local)
    LDI REA, [REY]                      ; j
    POP REB                             ; REB = RHS
    ADD REA, REB
    MOV REY, REX
    LDI REZ, #0xB
    SUB REY, REZ                        ; &j (local)
    STR REY, REA                        ; *target = value
    JP L_int_to_decimal_string_loop_16
L_int_to_decimal_string_endloop_17:
    LDI REA, #0x0
    PUSH REA                            ; save value
    MOV REY, REX
    LDI REZ, #0xB
    SUB REY, REZ                        ; &j (local)
    LDI REA, [REY]                      ; j
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &buffer (arg)
    LDI REA, [REY]                      ; buffer
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS

; --- function print_str(int* str, int newLine) ---
; frame: 1 local word(s)
print_str:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    LDI REA, #0x0
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &i (local)
    STR REY, REA                        ; *target = value
L_print_str_loop_19:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of !=
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &str (arg)
    LDI REA, [REY]                      ; str
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_print_str_cmp_21
    LDI REA, #1                         ; true
L_print_str_cmp_21:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_print_str_endloop_20
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &str (arg)
    LDI REA, [REY]                      ; str
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    POP REB                             ; REB = RHS
    ADD REA, REB
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &i (local)
    STR REY, REA                        ; *target = value
    JP L_print_str_loop_19
L_print_str_endloop_20:
    LDI REA, #0x1
    PUSH REA                            ; save RHS of ==
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &newLine (arg)
    LDI REA, [REY]                      ; newLine
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_print_str_cmp_24
    LDI REA, #1                         ; true
L_print_str_cmp_24:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_print_str_endif_23
    LDI REA, #0xA
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
L_print_str_endif_23:
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS

; --- function print_int(int val, int newLine) ---
; frame: 10 local word(s)
print_int:
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
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &val (arg)
    LDI REA, [REY]                      ; val
    PUSH REA                            ; arg 0
    CALL int_to_decimal_string
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    MOV REA, REX
    LDI REZ, #0x9
    SUB REA, REZ                        ; &result (local)
    PUSH REA                            ; arg 0
    CALL print_str
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x1
    PUSH REA                            ; save RHS of ==
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &newLine (arg)
    LDI REA, [REY]                      ; newLine
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_print_int_cmp_27
    LDI REA, #1                         ; true
L_print_int_cmp_27:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_print_int_endif_26
    LDI REA, #0xA
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
L_print_int_endif_26:
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS

; --- function print_not_impl(int* name) ---
; frame: 0 local word(s)
print_not_impl:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &name (arg)
    LDI REA, [REY]                      ; name
    PUSH REA                            ; arg 0
    CALL print_str
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_0                 ; ": TODO"
    PUSH REA                            ; arg 0
    CALL print_str
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
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &i (local)
    STR REY, REA                        ; *target = value
L_matches_loop_28:
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &len (arg)
    LDI REA, [REY]                      ; len
    PUSH REA                            ; save RHS of <
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_matches_cmp_30
    JP_EQ L_matches_cmp_30
    LDI REA, #1                         ; true
L_matches_cmp_30:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_matches_endloop_29
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x5
    ADD REY, REZ                        ; &str (arg)
    LDI REA, [REY]                      ; str
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; save RHS of !=
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x3
    ADD REY, REZ                        ; &buf (arg)
    LDI REA, [REY]                      ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_matches_cmp_34
    LDI REA, #1                         ; true
L_matches_cmp_34:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_matches_endif_33
    LDI REA, #0x0
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_matches_endif_33:
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    POP REB                             ; REB = RHS
    ADD REA, REB
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &i (local)
    STR REY, REA                        ; *target = value
    JP L_matches_loop_28
L_matches_endloop_29:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of !=
    MOV REY, REX
    LDI REZ, #0x4
    ADD REY, REZ                        ; &len (arg)
    LDI REA, [REY]                      ; len
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0x5
    ADD REY, REZ                        ; &str (arg)
    LDI REA, [REY]                      ; str
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_matches_cmp_37
    LDI REA, #1                         ; true
L_matches_cmp_37:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_matches_endif_36
    LDI REA, #0x0
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_matches_endif_36:
    LDI REA, #0x1
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS

; --- function cmd_cls() ---
; frame: 0 local word(s)
cmd_cls:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    CALL tty_clear_screen
    POP REX                             ; restore FP
    RTS

; --- function cmd_halt() ---
; frame: 0 local word(s)
cmd_halt:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    CALL cpu_halt
    POP REX                             ; restore FP
    RTS

; --- function cmd_ls() ---
; frame: 16 local word(s)
cmd_ls:
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
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0x2
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &files (local)
    LDI REA, [REY]                      ; files
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    MOV REY, REX
    LDI REZ, #0xD
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0xD
    SUB REY, REZ                        ; &file (local)
    LDI REA, [REY]                      ; file
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    MOV REY, REX
    LDI REZ, #0xE
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    LDI REA, #0x0
    MOV REY, REX
    LDI REZ, #0xF
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_1                 ; "All files:"
    PUSH REA                            ; arg 0
    CALL print_str
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    CALL files_buffer
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &files (local)
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &files (local)
    LDI REA, [REY]                      ; files
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &fileCount (local)
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    MOV REY, REX
    LDI REZ, #0x2
    SUB REY, REZ                        ; &i (local)
    STR REY, REA                        ; *target = value
L_cmd_ls_loop_38:
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &fileCount (local)
    LDI REA, [REY]                      ; fileCount
    PUSH REA                            ; save RHS of <
    MOV REY, REX
    LDI REZ, #0x2
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_cmd_ls_cmp_40
    JP_EQ L_cmd_ls_cmp_40
    LDI REA, #1                         ; true
L_cmd_ls_cmp_40:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_cmd_ls_endloop_39
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0x2
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &files (local)
    LDI REA, [REY]                      ; files
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    MOV REY, REX
    LDI REZ, #0xD
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0xD
    SUB REY, REZ                        ; &file (local)
    LDI REA, [REY]                      ; file
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    MOV REY, REX
    LDI REZ, #0xE
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    LDI REA, #0x0
    MOV REY, REX
    LDI REZ, #0xF
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    MOV REA, REX
    LDI REZ, #0xC
    SUB REA, REZ                        ; &indexString (local)
    PUSH REA                            ; arg 1
    MOV REY, REX
    LDI REZ, #0x2
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    PUSH REA                            ; arg 0
    CALL int_to_decimal_string
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    MOV REA, REX
    LDI REZ, #0xC
    SUB REA, REZ                        ; &indexString (local)
    PUSH REA                            ; arg 0
    CALL print_str
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_2                 ; " : "
    PUSH REA                            ; arg 0
    CALL print_str
    POP REC                             ; discard arg
    POP REC                             ; discard arg
L_cmd_ls_loop_42:
    MOV REY, REX
    LDI REZ, #0xE
    SUB REY, REZ                        ; &filenameSize (local)
    LDI REA, [REY]                      ; filenameSize
    PUSH REA                            ; save RHS of <
    MOV REY, REX
    LDI REZ, #0xF
    SUB REY, REZ                        ; &j (local)
    LDI REA, [REY]                      ; j
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_cmd_ls_cmp_44
    JP_EQ L_cmd_ls_cmp_44
    LDI REA, #1                         ; true
L_cmd_ls_cmp_44:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_cmd_ls_endloop_43
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0xF
    SUB REY, REZ                        ; &j (local)
    LDI REA, [REY]                      ; j
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0xD
    SUB REY, REZ                        ; &file (local)
    LDI REA, [REY]                      ; file
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0xF
    SUB REY, REZ                        ; &j (local)
    LDI REA, [REY]                      ; j
    POP REB                             ; REB = RHS
    ADD REA, REB
    MOV REY, REX
    LDI REZ, #0xF
    SUB REY, REZ                        ; &j (local)
    STR REY, REA                        ; *target = value
    JP L_cmd_ls_loop_42
L_cmd_ls_endloop_43:
    LDI REA, #0xA
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0x2
    SUB REY, REZ                        ; &i (local)
    LDI REA, [REY]                      ; i
    POP REB                             ; REB = RHS
    ADD REA, REB
    MOV REY, REX
    LDI REZ, #0x2
    SUB REY, REZ                        ; &i (local)
    STR REY, REA                        ; *target = value
    JP L_cmd_ls_loop_38
L_cmd_ls_endloop_39:
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS

; --- function cmd_run() ---
; frame: 0 local word(s)
cmd_run:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    LDI REA, __cc_str_3                 ; "run"
    PUSH REA                            ; arg 0
    CALL print_not_impl
    POP REC                             ; discard arg
    POP REX                             ; restore FP
    RTS

; --- function cmd_del() ---
; frame: 0 local word(s)
cmd_del:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    LDI REA, __cc_str_4                 ; "del"
    PUSH REA                            ; arg 0
    CALL print_not_impl
    POP REC                             ; discard arg
    POP REX                             ; restore FP
    RTS

; --- function cmd_touch() ---
; frame: 0 local word(s)
cmd_touch:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    LDI REA, __cc_str_5                 ; "touch"
    PUSH REA                            ; arg 0
    CALL print_not_impl
    POP REC                             ; discard arg
    POP REX                             ; restore FP
    RTS

; --- function cmd_dofile() ---
; frame: 0 local word(s)
cmd_dofile:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    LDI REA, __cc_str_6                 ; "dofile"
    PUSH REA                            ; arg 0
    CALL print_not_impl
    POP REC                             ; discard arg
    POP REX                             ; restore FP
    RTS

; --- function shell_initialize() ---
; frame: 1 local word(s)
shell_initialize:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    CALL cmd_buffer
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, __cc_str_7                 ; "You >"
    PUSH REA                            ; arg 0
    CALL print_str
    POP REC                             ; discard arg
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS

; --- function shell_execute() ---
; frame: 5 local word(s)
shell_execute:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDI REA, #0x1
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    MOV REY, REX
    LDI REZ, #0x2
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    LDI REA, #0x0
    MOV REY, REX
    LDI REZ, #0x3
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    LDI REA, #0x1
    MOV REY, REX
    LDI REZ, #0x4
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
    CALL cmd_buffer
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &len (local)
    STR REY, REA                        ; *target = value
L_shell_execute_loop_46:
    LDI REA, #0x20
    PUSH REA                            ; save RHS of ==
    MOV REY, REX
    LDI REZ, #0x2
    SUB REY, REZ                        ; &firstChar (local)
    LDI REA, [REY]                      ; firstChar
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_49
    LDI REA, #1                         ; true
L_shell_execute_cmp_49:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_and_end_48
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &len (local)
    LDI REA, [REY]                      ; len
    PUSH REA                            ; save RHS of <
    MOV REY, REX
    LDI REZ, #0x3
    SUB REY, REZ                        ; &counter (local)
    LDI REA, [REY]                      ; counter
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_shell_execute_cmp_50
    JP_EQ L_shell_execute_cmp_50
    LDI REA, #1                         ; true
L_shell_execute_cmp_50:
    LDI REB, #0
    CMP REA, REB
    LDI REA, #0
    JP_EQ L_shell_execute_norm_52
    LDI REA, #1
L_shell_execute_norm_52:
L_shell_execute_and_end_48:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endloop_47
    LDI REA, #0x1
    MOV REY, REX
    LDI REZ, #0x4
    SUB REY, REZ                        ; &local
    STR REY, REA                        ; *local = REA
L_shell_execute_loop_53:
    LDI REA, #0x1
    PUSH REA                            ; save RHS of -
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &len (local)
    LDI REA, [REY]                      ; len
    POP REB                             ; REB = RHS
    SUB REA, REB
    PUSH REA                            ; save RHS of <
    MOV REY, REX
    LDI REZ, #0x4
    SUB REY, REZ                        ; &idx (local)
    LDI REA, [REY]                      ; idx
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_shell_execute_cmp_55
    JP_EQ L_shell_execute_cmp_55
    LDI REA, #1                         ; true
L_shell_execute_cmp_55:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endloop_54
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0x4
    SUB REY, REZ                        ; &idx (local)
    LDI REA, [REY]                      ; idx
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; save value
    MOV REY, REX
    LDI REZ, #0x4
    SUB REY, REZ                        ; &idx (local)
    LDI REA, [REY]                      ; idx
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0x4
    SUB REY, REZ                        ; &idx (local)
    LDI REA, [REY]                      ; idx
    POP REB                             ; REB = RHS
    ADD REA, REB
    MOV REY, REX
    LDI REZ, #0x4
    SUB REY, REZ                        ; &idx (local)
    STR REY, REA                        ; *target = value
    JP L_shell_execute_loop_53
L_shell_execute_endloop_54:
    LDI REA, #0x1
    PUSH REA                            ; save RHS of -
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &len (local)
    LDI REA, [REY]                      ; len
    POP REB                             ; REB = RHS
    SUB REA, REB
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save index
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &len (local)
    STR REY, REA                        ; *target = value
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    MOV REY, REX
    LDI REZ, #0x3
    SUB REY, REZ                        ; &counter (local)
    LDI REA, [REY]                      ; counter
    POP REB                             ; REB = RHS
    ADD REA, REB
    MOV REY, REX
    LDI REZ, #0x3
    SUB REY, REZ                        ; &counter (local)
    STR REY, REA                        ; *target = value
    JP L_shell_execute_loop_46
L_shell_execute_endloop_47:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &len (local)
    LDI REA, [REY]                      ; len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_59
    LDI REA, #1                         ; true
L_shell_execute_cmp_59:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_58
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_58:
    LDI REA, #0x2
    PUSH REA                            ; save RHS of ==
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &len (local)
    LDI REA, [REY]                      ; len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_62
    LDI REA, #1                         ; true
L_shell_execute_cmp_62:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_61
    LDI REA, __cc_str_8                 ; "ls"
    PUSH REA                            ; arg 2
    LDI REA, #0x2
    PUSH REA                            ; arg 1
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_64
    CALL cmd_ls
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_64:
L_shell_execute_endif_61:
    LDI REA, #0x3
    PUSH REA                            ; save RHS of ==
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &len (local)
    LDI REA, [REY]                      ; len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_67
    LDI REA, #1                         ; true
L_shell_execute_cmp_67:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_66
    LDI REA, __cc_str_9                 ; "cls"
    PUSH REA                            ; arg 2
    LDI REA, #0x3
    PUSH REA                            ; arg 1
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_69
    CALL cmd_cls
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_69:
    LDI REA, __cc_str_10                ; "del"
    PUSH REA                            ; arg 2
    LDI REA, #0x3
    PUSH REA                            ; arg 1
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_71
    CALL cmd_del
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_71:
    LDI REA, __cc_str_11                ; "run"
    PUSH REA                            ; arg 2
    LDI REA, #0x3
    PUSH REA                            ; arg 1
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_73
    CALL cmd_run
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_73:
L_shell_execute_endif_66:
    LDI REA, #0x4
    PUSH REA                            ; save RHS of ==
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &len (local)
    LDI REA, [REY]                      ; len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_76
    LDI REA, #1                         ; true
L_shell_execute_cmp_76:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_75
    LDI REA, __cc_str_12                ; "halt"
    PUSH REA                            ; arg 2
    LDI REA, #0x4
    PUSH REA                            ; arg 1
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_78
    CALL cmd_halt
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_78:
L_shell_execute_endif_75:
    LDI REA, #0x5
    PUSH REA                            ; save RHS of ==
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &len (local)
    LDI REA, [REY]                      ; len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_81
    LDI REA, #1                         ; true
L_shell_execute_cmp_81:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_80
    LDI REA, __cc_str_13                ; "touch"
    PUSH REA                            ; arg 2
    LDI REA, #0x5
    PUSH REA                            ; arg 1
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_83
    CALL cmd_touch
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_83:
L_shell_execute_endif_80:
    LDI REA, #0x6
    PUSH REA                            ; save RHS of ==
    MOV REY, REX
    LDI REZ, #0x1
    SUB REY, REZ                        ; &len (local)
    LDI REA, [REY]                      ; len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_86
    LDI REA, #1                         ; true
L_shell_execute_cmp_86:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_85
    LDI REA, __cc_str_14                ; "dofile"
    PUSH REA                            ; arg 2
    LDI REA, #0x6
    PUSH REA                            ; arg 1
    MOV REY, REX
    LDI REZ, #0
    SUB REY, REZ                        ; &buf (local)
    LDI REA, [REY]                      ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_88
    CALL cmd_dofile
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_88:
L_shell_execute_endif_85:
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_15                ; "Command not found!"
    PUSH REA                            ; arg 0
    CALL print_str
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS

.CData

__cc_str_0:
    DW #0x3A, #0x20, #0x54, #0x4F, #0x44, #0x4F, #0; ": TODO" + NUL
__cc_str_1:
    DW #0x41, #0x6C, #0x6C, #0x20, #0x66, #0x69, #0x6C, #0x65, #0x73, #0x3A, #0; "All files:" + NUL
__cc_str_2:
    DW #0x20, #0x3A, #0x20, #0          ; " : " + NUL
__cc_str_3:
    DW #0x72, #0x75, #0x6E, #0          ; "run" + NUL
__cc_str_4:
    DW #0x64, #0x65, #0x6C, #0          ; "del" + NUL
__cc_str_5:
    DW #0x74, #0x6F, #0x75, #0x63, #0x68, #0; "touch" + NUL
__cc_str_6:
    DW #0x64, #0x6F, #0x66, #0x69, #0x6C, #0x65, #0; "dofile" + NUL
__cc_str_7:
    DW #0x59, #0x6F, #0x75, #0x20, #0x3E, #0; "You >" + NUL
__cc_str_8:
    DW #0x6C, #0x73, #0                 ; "ls" + NUL
__cc_str_9:
    DW #0x63, #0x6C, #0x73, #0          ; "cls" + NUL
__cc_str_10:
    DW #0x64, #0x65, #0x6C, #0          ; "del" + NUL
__cc_str_11:
    DW #0x72, #0x75, #0x6E, #0          ; "run" + NUL
__cc_str_12:
    DW #0x68, #0x61, #0x6C, #0x74, #0   ; "halt" + NUL
__cc_str_13:
    DW #0x74, #0x6F, #0x75, #0x63, #0x68, #0; "touch" + NUL
__cc_str_14:
    DW #0x64, #0x6F, #0x66, #0x69, #0x6C, #0x65, #0; "dofile" + NUL
__cc_str_15:
    DW #0x43, #0x6F, #0x6D, #0x6D, #0x61, #0x6E, #0x64, #0x20, #0x6E, #0x6F, #0x74, #0x20, #0x66, #0x6F, #0x75, #0x6E, #0x64, #0x21, #0; "Command not found!" + NUL
