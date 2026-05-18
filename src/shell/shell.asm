; ============================================================
; cc.py output for shell.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function shell_initialize() ---
; frame: 1 local word(s)
shell_initialize:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    CALL commands_buffer
    STR_LOC REA, #0x0                   ; buf = value
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save index
    LDR_LOC REA, #0x0                   ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    CALL editor_is_active
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_initialize_else_0
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_0                 ; "..>"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    JP L_shell_initialize_endif_1
L_shell_initialize_else_0:
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_1                 ; "You >"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
L_shell_initialize_endif_1:
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS

; --- function shell_execute() ---
; frame: 39 local word(s)
shell_execute:
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
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    CALL commands_buffer
    STR_LOC REA, #0x20                  ; buf = value
    LDI REA, #0x0
    PUSH REA                            ; save index
    LDR_LOC REA, #0x20                  ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x21                  ; len = value
    CALL editor_is_active
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_3
    CALL editor_handle_line
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_3:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x21                  ; len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_6
    LDI REA, #1                         ; true
L_shell_execute_cmp_6:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_5
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_5:
L_shell_execute_loop_7:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of >
    LDR_LOC REA, #0x21                  ; len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_LT L_shell_execute_cmp_10
    JP_EQ L_shell_execute_cmp_10
    LDI REA, #1                         ; true
L_shell_execute_cmp_10:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_and_end_9
    LDI REA, #0x20
    PUSH REA                            ; save RHS of ==
    LDI REA, #0x1
    PUSH REA                            ; save index
    LDR_LOC REA, #0x20                  ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_11
    LDI REA, #1                         ; true
L_shell_execute_cmp_11:
    LDI REB, #0
    CMP REA, REB
    LDI REA, #0
    JP_EQ L_shell_execute_norm_12
    LDI REA, #1
L_shell_execute_norm_12:
L_shell_execute_and_end_9:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endloop_8
    LDI REA, #0x1
    STR_LOC REA, #0x22                  ; idx = value
L_shell_execute_loop_13:
    LDR_LOC REA, #0x21                  ; len
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x22                  ; idx
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_shell_execute_cmp_15
    JP_EQ L_shell_execute_cmp_15
    LDI REA, #1                         ; true
L_shell_execute_cmp_15:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endloop_14
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    LDR_LOC REA, #0x22                  ; idx
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save index
    LDR_LOC REA, #0x20                  ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; save value
    LDR_LOC REA, #0x22                  ; idx
    PUSH REA                            ; save index
    LDR_LOC REA, #0x20                  ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    LDR_LOC REA, #0x22                  ; idx
    POP REB                             ; REB = RHS
    ADD REA, REB
    STR_LOC REA, #0x22                  ; idx = value
    JP L_shell_execute_loop_13
L_shell_execute_endloop_14:
    LDI REA, #0x1
    PUSH REA                            ; save RHS of -
    LDR_LOC REA, #0x21                  ; len
    POP REB                             ; REB = RHS
    SUB REA, REB
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save index
    LDR_LOC REA, #0x20                  ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save index
    LDR_LOC REA, #0x20                  ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x21                  ; len = value
    JP L_shell_execute_loop_7
L_shell_execute_endloop_8:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x21                  ; len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_19
    LDI REA, #1                         ; true
L_shell_execute_cmp_19:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_18
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_18:
    LDI REA, #0x1
    STR_LOC REA, #0x23                  ; sp = value
L_shell_execute_loop_20:
    LDR_LOC REA, #0x21                  ; len
    PUSH REA                            ; save RHS of <=
    LDR_LOC REA, #0x23                  ; sp
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_shell_execute_cmp_23
    LDI REA, #1                         ; true
L_shell_execute_cmp_23:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_and_end_22
    LDI REA, #0x20
    PUSH REA                            ; save RHS of !=
    LDR_LOC REA, #0x23                  ; sp
    PUSH REA                            ; save index
    LDR_LOC REA, #0x20                  ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_shell_execute_cmp_24
    LDI REA, #1                         ; true
L_shell_execute_cmp_24:
    LDI REB, #0
    CMP REA, REB
    LDI REA, #0
    JP_EQ L_shell_execute_norm_25
    LDI REA, #1
L_shell_execute_norm_25:
L_shell_execute_and_end_22:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endloop_21
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    LDR_LOC REA, #0x23                  ; sp
    POP REB                             ; REB = RHS
    ADD REA, REB
    STR_LOC REA, #0x23                  ; sp = value
    JP L_shell_execute_loop_20
L_shell_execute_endloop_21:
    LDI REA, #0x1
    PUSH REA                            ; save RHS of -
    LDR_LOC REA, #0x23                  ; sp
    POP REB                             ; REB = RHS
    SUB REA, REB
    STR_LOC REA, #0x24                  ; cmd_len = value
    LDI REA, #0x0
    STR_LOC REA, #0x25                  ; arg_len = value
    LDR_LOC REA, #0x21                  ; len
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x23                  ; sp
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_shell_execute_cmp_28
    JP_EQ L_shell_execute_cmp_28
    LDI REA, #1                         ; true
L_shell_execute_cmp_28:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_27
    LDR_LOC REA, #0x23                  ; sp
    PUSH REA                            ; save RHS of -
    LDR_LOC REA, #0x21                  ; len
    POP REB                             ; REB = RHS
    SUB REA, REB
    STR_LOC REA, #0x25                  ; arg_len = value
    LDI REA, #0x0
    STR_LOC REA, #0x26                  ; i = value
L_shell_execute_loop_30:
    LDR_LOC REA, #0x25                  ; arg_len
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x26                  ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_shell_execute_cmp_32
    JP_EQ L_shell_execute_cmp_32
    LDI REA, #1                         ; true
L_shell_execute_cmp_32:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endloop_31
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    LDR_LOC REA, #0x26                  ; i
    PUSH REA                            ; save RHS of +
    LDR_LOC REA, #0x23                  ; sp
    POP REB                             ; REB = RHS
    ADD REA, REB
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save index
    LDR_LOC REA, #0x20                  ; buf
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; save value
    LDR_LOC REA, #0x26                  ; i
    PUSH REA                            ; save index
    MOV REA, REX
    LDI REZ, #0x1F
    SUB REA, REZ                        ; &local_args (local)
    POP REB                             ; REB = index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    MOV REA, REX
    LDI REZ, #0x26
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_shell_execute_loop_30
L_shell_execute_endloop_31:
L_shell_execute_endif_27:
    LDI REA, #0x2
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x24                  ; cmd_len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_36
    LDI REA, #1                         ; true
L_shell_execute_cmp_36:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_35
    LDI REA, __cc_str_2                 ; "ls"
    PUSH REA                            ; arg 2
    LDI REA, #0x2
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x20                  ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_38
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, #0x0
    PUSH REA                            ; arg 0
    CALL ls
    POP REC                             ; discard arg
    POP REC                             ; discard arg
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_38:
L_shell_execute_endif_35:
    LDI REA, #0x3
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x24                  ; cmd_len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_41
    LDI REA, #1                         ; true
L_shell_execute_cmp_41:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_40
    LDI REA, __cc_str_3                 ; "cls"
    PUSH REA                            ; arg 2
    LDI REA, #0x3
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x20                  ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_43
    CALL tty_clear_screen
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_43:
    LDI REA, __cc_str_4                 ; "del"
    PUSH REA                            ; arg 2
    LDI REA, #0x3
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x20                  ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_45
    LDR_LOC REA, #0x25                  ; arg_len
    PUSH REA                            ; arg 1
    MOV REA, REX
    LDI REZ, #0x1F
    SUB REA, REZ                        ; &local_args (local)
    PUSH REA                            ; arg 0
    CALL del
    POP REC                             ; discard arg
    POP REC                             ; discard arg
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_45:
    LDI REA, __cc_str_5                 ; "cat"
    PUSH REA                            ; arg 2
    LDI REA, #0x3
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x20                  ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_47
    LDR_LOC REA, #0x25                  ; arg_len
    PUSH REA                            ; arg 1
    MOV REA, REX
    LDI REZ, #0x1F
    SUB REA, REZ                        ; &local_args (local)
    PUSH REA                            ; arg 0
    CALL cat
    POP REC                             ; discard arg
    POP REC                             ; discard arg
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_47:
    LDI REA, __cc_str_6                 ; "run"
    PUSH REA                            ; arg 2
    LDI REA, #0x3
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x20                  ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_49
    LDI REA, __cc_str_7                 ; "run"
    PUSH REA                            ; arg 0
    CALL print_not_impl
    POP REC                             ; discard arg
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_49:
L_shell_execute_endif_40:
    LDI REA, #0x4
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x24                  ; cmd_len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_52
    LDI REA, #1                         ; true
L_shell_execute_cmp_52:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_51
    LDI REA, __cc_str_8                 ; "halt"
    PUSH REA                            ; arg 2
    LDI REA, #0x4
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x20                  ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_54
    CALL cpu_halt
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_54:
    LDI REA, __cc_str_9                 ; "edit"
    PUSH REA                            ; arg 2
    LDI REA, #0x4
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x20                  ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_56
    LDR_LOC REA, #0x25                  ; arg_len
    PUSH REA                            ; arg 1
    MOV REA, REX
    LDI REZ, #0x1F
    SUB REA, REZ                        ; &local_args (local)
    PUSH REA                            ; arg 0
    CALL edit
    POP REC                             ; discard arg
    POP REC                             ; discard arg
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_56:
L_shell_execute_endif_51:
    LDI REA, #0x5
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x24                  ; cmd_len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_59
    LDI REA, #1                         ; true
L_shell_execute_cmp_59:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_58
    LDI REA, __cc_str_10                ; "touch"
    PUSH REA                            ; arg 2
    LDI REA, #0x5
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x20                  ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_61
    LDR_LOC REA, #0x25                  ; arg_len
    PUSH REA                            ; arg 1
    MOV REA, REX
    LDI REZ, #0x1F
    SUB REA, REZ                        ; &local_args (local)
    PUSH REA                            ; arg 0
    CALL touch
    POP REC                             ; discard arg
    POP REC                             ; discard arg
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_61:
    LDI REA, __cc_str_11                ; "write"
    PUSH REA                            ; arg 2
    LDI REA, #0x5
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x20                  ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_63
    LDR_LOC REA, #0x25                  ; arg_len
    PUSH REA                            ; arg 1
    MOV REA, REX
    LDI REZ, #0x1F
    SUB REA, REZ                        ; &local_args (local)
    PUSH REA                            ; arg 0
    CALL write
    POP REC                             ; discard arg
    POP REC                             ; discard arg
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_63:
L_shell_execute_endif_58:
    LDI REA, #0x6
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x24                  ; cmd_len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_shell_execute_cmp_66
    LDI REA, #1                         ; true
L_shell_execute_cmp_66:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_65
    LDI REA, __cc_str_12                ; "dofile"
    PUSH REA                            ; arg 2
    LDI REA, #0x6
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x20                  ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_68
    LDR_LOC REA, #0x25                  ; arg_len
    PUSH REA                            ; arg 1
    MOV REA, REX
    LDI REZ, #0x1F
    SUB REA, REZ                        ; &local_args (local)
    PUSH REA                            ; arg 0
    CALL dofile
    POP REC                             ; discard arg
    POP REC                             ; discard arg
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_68:
    LDI REA, __cc_str_13                ; "blocks"
    PUSH REA                            ; arg 2
    LDI REA, #0x6
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x20                  ; buf
    PUSH REA                            ; arg 0
    CALL matches
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_shell_execute_endif_70
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, #0x0
    PUSH REA                            ; arg 0
    CALL blocks
    POP REC                             ; discard arg
    POP REC                             ; discard arg
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS
L_shell_execute_endif_70:
L_shell_execute_endif_65:
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_14                ; "Command not found!"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
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
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REC                             ; release local
    POP REX                             ; restore FP
    RTS

.CData

__cc_str_0:
    DW #0x2E, #0x2E, #0x3E, #0          ; "..>" + NUL
__cc_str_1:
    DW #0x59, #0x6F, #0x75, #0x20, #0x3E, #0; "You >" + NUL
__cc_str_2:
    DW #0x6C, #0x73, #0                 ; "ls" + NUL
__cc_str_3:
    DW #0x63, #0x6C, #0x73, #0          ; "cls" + NUL
__cc_str_4:
    DW #0x64, #0x65, #0x6C, #0          ; "del" + NUL
__cc_str_5:
    DW #0x63, #0x61, #0x74, #0          ; "cat" + NUL
__cc_str_6:
    DW #0x72, #0x75, #0x6E, #0          ; "run" + NUL
__cc_str_7:
    DW #0x72, #0x75, #0x6E, #0          ; "run" + NUL
__cc_str_8:
    DW #0x68, #0x61, #0x6C, #0x74, #0   ; "halt" + NUL
__cc_str_9:
    DW #0x65, #0x64, #0x69, #0x74, #0   ; "edit" + NUL
__cc_str_10:
    DW #0x74, #0x6F, #0x75, #0x63, #0x68, #0; "touch" + NUL
__cc_str_11:
    DW #0x77, #0x72, #0x69, #0x74, #0x65, #0; "write" + NUL
__cc_str_12:
    DW #0x64, #0x6F, #0x66, #0x69, #0x6C, #0x65, #0; "dofile" + NUL
__cc_str_13:
    DW #0x62, #0x6C, #0x6F, #0x63, #0x6B, #0x73, #0; "blocks" + NUL
__cc_str_14:
    DW #0x43, #0x6F, #0x6D, #0x6D, #0x61, #0x6E, #0x64, #0x20, #0x6E, #0x6F, #0x74, #0x20, #0x66, #0x6F, #0x75, #0x6E, #0x64, #0x21, #0; "Command not found!" + NUL
