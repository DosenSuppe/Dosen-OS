; ============================================================
; cc.py output for blocks.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function blocks(int argc, int** argv) ---
; frame: 47 local word(s)
blocks:
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
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    CALL files_buffer
    STR_LOC REA, #0x0                   ; buf = value
    LDI REA, #0x0
    STR_LOC REA, #0x22                  ; i = value
L_blocks_loop_0:
    LDI REA, #0x20
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x22                  ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_2
    JP_EQ L_blocks_cmp_2
    LDI REA, #1                         ; true
L_blocks_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endloop_1
    LDI REA, #0x1
    PUSH REA                            ; save RHS of -
    LDI REA, #0x0
    POP REB                             ; REB = RHS
    SUB REA, REB
    PUSH REA                            ; save value
    LDR_LOC REA, #0x22                  ; i
    PUSH REA                            ; save scaled index
    MOV REA, REX
    LDI REZ, #0x21
    SUB REA, REZ                        ; &owner (local)
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    MOV REA, REX
    LDI REZ, #0x22
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_blocks_loop_0
L_blocks_endloop_1:
    LDI REA, #0x0
    STR_LOC REA, #0x25                  ; slot = value
L_blocks_loop_4:
    LDI REA, #0x8
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x25                  ; slot
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_6
    JP_EQ L_blocks_cmp_6
    LDI REA, #1                         ; true
L_blocks_cmp_6:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endloop_5
    LDI REA, #0x19
    PUSH REA                            ; save RHS of *
    LDR_LOC REA, #0x25                  ; slot
    POP REB                             ; REB = RHS
    MUL REA, REB
    PUSH REA                            ; save RHS of +
    LDI REA, #0x21
    POP REB                             ; REB = RHS
    ADD REA, REB
    STR_LOC REA, #0x26                  ; off = value
    LDR_LOC REA, #0x26                  ; off
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    STR_LOC REA, #0x1                   ; e = value
    LDI REA, #0x1
    PUSH REA                            ; save RHS of ==
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_blocks_cmp_10
    LDI REA, #1                         ; true
L_blocks_cmp_10:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endif_9
    LDI REA, #0x10
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x27                  ; bc = value
    LDI REA, #0x0
    STR_LOC REA, #0x24                  ; k = value
L_blocks_loop_11:
    LDR_LOC REA, #0x27                  ; bc
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x24                  ; k
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_13
    JP_EQ L_blocks_cmp_13
    LDI REA, #1                         ; true
L_blocks_cmp_13:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endloop_12
    LDR_LOC REA, #0x24                  ; k
    PUSH REA                            ; save RHS of +
    LDI REA, #0x11
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x28                  ; bid = value
    LDI REA, #0x0
    PUSH REA                            ; save RHS of >=
    LDR_LOC REA, #0x28                  ; bid
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_LT L_blocks_cmp_17
    LDI REA, #1                         ; true
L_blocks_cmp_17:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endif_16
    LDI REA, #0x20
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x28                  ; bid
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_20
    JP_EQ L_blocks_cmp_20
    LDI REA, #1                         ; true
L_blocks_cmp_20:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endif_19
    LDR_LOC REA, #0x25                  ; slot
    PUSH REA                            ; save value
    LDR_LOC REA, #0x28                  ; bid
    PUSH REA                            ; save scaled index
    MOV REA, REX
    LDI REZ, #0x21
    SUB REA, REZ                        ; &owner (local)
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
L_blocks_endif_19:
L_blocks_endif_16:
    MOV REA, REX
    LDI REZ, #0x24
    SUB REA, REZ                        ; &k (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_blocks_loop_11
L_blocks_endloop_12:
L_blocks_endif_9:
    MOV REA, REX
    LDI REZ, #0x25
    SUB REA, REZ                        ; &slot (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_blocks_loop_4
L_blocks_endloop_5:
    LDI REA, #0x0
    STR_LOC REA, #0x29                  ; used = value
    LDI REA, #0x0
    STR_LOC REA, #0x22                  ; i = value
L_blocks_loop_22:
    LDI REA, #0x20
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x22                  ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_24
    JP_EQ L_blocks_cmp_24
    LDI REA, #1                         ; true
L_blocks_cmp_24:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endloop_23
    LDI REA, #0x0
    PUSH REA                            ; save RHS of !=
    LDR_LOC REA, #0x22                  ; i
    PUSH REA                            ; save RHS of +
    LDI REA, #0x1
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_blocks_cmp_28
    LDI REA, #1                         ; true
L_blocks_cmp_28:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endif_27
    MOV REA, REX
    LDI REZ, #0x29
    SUB REA, REZ                        ; &used (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
L_blocks_endif_27:
    MOV REA, REX
    LDI REZ, #0x22
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_blocks_loop_22
L_blocks_endloop_23:
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_0                 ; "Block map (32 blocks"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    STR_LOC REA, #0x2A                  ; row = value
L_blocks_loop_29:
    LDI REA, #0x4
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x2A                  ; row
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_31
    JP_EQ L_blocks_cmp_31
    LDI REA, #1                         ; true
L_blocks_cmp_31:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endloop_30
    LDI REA, #0x0
    STR_LOC REA, #0x2B                  ; col = value
L_blocks_loop_33:
    LDI REA, #0x8
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x2B                  ; col
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_35
    JP_EQ L_blocks_cmp_35
    LDI REA, #1                         ; true
L_blocks_cmp_35:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endloop_34
    LDR_LOC REA, #0x2B                  ; col
    PUSH REA                            ; save RHS of +
    LDI REA, #0x8
    PUSH REA                            ; save RHS of *
    LDR_LOC REA, #0x2A                  ; row
    POP REB                             ; REB = RHS
    MUL REA, REB
    POP REB                             ; REB = RHS
    ADD REA, REB
    STR_LOC REA, #0x28                  ; bid = value
    LDI REA, #0xA
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x28                  ; bid
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_39
    JP_EQ L_blocks_cmp_39
    LDI REA, #1                         ; true
L_blocks_cmp_39:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endif_38
    LDI REA, #0x20
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
L_blocks_endif_38:
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x28                  ; bid
    PUSH REA                            ; arg 0
    CALL printi
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x3A
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    LDR_LOC REA, #0x28                  ; bid
    PUSH REA                            ; save scaled index
    MOV REA, REX
    LDI REZ, #0x21
    SUB REA, REZ                        ; &owner (local)
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x2C                  ; o = value
    LDI REA, #0x0
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x2C                  ; o
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_43
    JP_EQ L_blocks_cmp_43
    LDI REA, #1                         ; true
L_blocks_cmp_43:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_else_41
    LDI REA, #0x0
    PUSH REA                            ; save RHS of !=
    LDR_LOC REA, #0x28                  ; bid
    PUSH REA                            ; save RHS of +
    LDI REA, #0x1
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_blocks_cmp_47
    LDI REA, #1                         ; true
L_blocks_cmp_47:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_else_45
    LDI REA, #0x3F
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    JP L_blocks_endif_46
L_blocks_else_45:
    LDI REA, #0x2E
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
L_blocks_endif_46:
    JP L_blocks_endif_42
L_blocks_else_41:
    LDR_LOC REA, #0x2C                  ; o
    PUSH REA                            ; save RHS of +
    LDI REA, #0x30
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
L_blocks_endif_42:
    LDI REA, #0x20
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    MOV REA, REX
    LDI REZ, #0x2B
    SUB REA, REZ                        ; &col (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_blocks_loop_33
L_blocks_endloop_34:
    LDI REA, #0xA
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    MOV REA, REX
    LDI REZ, #0x2A
    SUB REA, REZ                        ; &row (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_blocks_loop_29
L_blocks_endloop_30:
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_1                 ; "Used: "
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x29                  ; used
    PUSH REA                            ; arg 0
    CALL printi
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_2                 ; "/32  Free: "
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x29                  ; used
    PUSH REA                            ; save RHS of -
    LDI REA, #0x20
    POP REB                             ; REB = RHS
    SUB REA, REB
    PUSH REA                            ; arg 0
    CALL printi
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0xA
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    LDI REA, #0x0
    STR_LOC REA, #0x2D                  ; any = value
    LDI REA, #0x0
    STR_LOC REA, #0x25                  ; slot = value
L_blocks_loop_48:
    LDI REA, #0x8
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x25                  ; slot
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_50
    JP_EQ L_blocks_cmp_50
    LDI REA, #1                         ; true
L_blocks_cmp_50:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endloop_49
    LDI REA, #0x19
    PUSH REA                            ; save RHS of *
    LDR_LOC REA, #0x25                  ; slot
    POP REB                             ; REB = RHS
    MUL REA, REB
    PUSH REA                            ; save RHS of +
    LDI REA, #0x21
    POP REB                             ; REB = RHS
    ADD REA, REB
    STR_LOC REA, #0x26                  ; off = value
    LDR_LOC REA, #0x26                  ; off
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    STR_LOC REA, #0x1                   ; e = value
    LDI REA, #0x1
    PUSH REA                            ; save RHS of ==
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_blocks_cmp_54
    LDI REA, #1                         ; true
L_blocks_cmp_54:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endif_53
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x2D                  ; any
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_blocks_cmp_57
    LDI REA, #1                         ; true
L_blocks_cmp_57:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endif_56
    LDI REA, #0x1
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_3                 ; "Files:"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x1
    STR_LOC REA, #0x2D                  ; any = value
L_blocks_endif_56:
    LDI REA, #0x20
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    LDR_LOC REA, #0x25                  ; slot
    PUSH REA                            ; save RHS of +
    LDI REA, #0x30
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_4                 ; ": "
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x1
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x2E                  ; nl = value
    LDI REA, #0x0
    STR_LOC REA, #0x23                  ; j = value
L_blocks_loop_58:
    LDR_LOC REA, #0x2E                  ; nl
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x23                  ; j
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_60
    JP_EQ L_blocks_cmp_60
    LDI REA, #1                         ; true
L_blocks_cmp_60:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endloop_59
    LDR_LOC REA, #0x23                  ; j
    PUSH REA                            ; save RHS of +
    LDI REA, #0x2
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    MOV REA, REX
    LDI REZ, #0x23
    SUB REA, REZ                        ; &j (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_blocks_loop_58
L_blocks_endloop_59:
L_blocks_loop_62:
    LDI REA, #0xC
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x23                  ; j
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_64
    JP_EQ L_blocks_cmp_64
    LDI REA, #1                         ; true
L_blocks_cmp_64:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endloop_63
    LDI REA, #0x20
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
    MOV REA, REX
    LDI REZ, #0x23
    SUB REA, REZ                        ; &j (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_blocks_loop_62
L_blocks_endloop_63:
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_5                 ; "  blocks: "
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    LDI REA, #0x10
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x27                  ; bc = value
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x27                  ; bc
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_blocks_cmp_68
    LDI REA, #1                         ; true
L_blocks_cmp_68:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_else_66
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_6                 ; "(none)"
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    JP L_blocks_endif_67
L_blocks_else_66:
    LDI REA, #0x0
    STR_LOC REA, #0x24                  ; k = value
L_blocks_loop_69:
    LDR_LOC REA, #0x27                  ; bc
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x24                  ; k
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_blocks_cmp_71
    JP_EQ L_blocks_cmp_71
    LDI REA, #1                         ; true
L_blocks_cmp_71:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endloop_70
    LDI REA, #0x0
    PUSH REA                            ; save RHS of >
    LDR_LOC REA, #0x24                  ; k
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_LT L_blocks_cmp_75
    JP_EQ L_blocks_cmp_75
    LDI REA, #1                         ; true
L_blocks_cmp_75:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_blocks_endif_74
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDI REA, __cc_str_7                 ; ", "
    PUSH REA                            ; arg 0
    CALL prints
    POP REC                             ; discard arg
    POP REC                             ; discard arg
L_blocks_endif_74:
    LDI REA, #0x0
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x24                  ; k
    PUSH REA                            ; save RHS of +
    LDI REA, #0x11
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; arg 0
    CALL printi
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    MOV REA, REX
    LDI REZ, #0x24
    SUB REA, REZ                        ; &k (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_blocks_loop_69
L_blocks_endloop_70:
L_blocks_endif_67:
    LDI REA, #0xA
    PUSH REA                            ; arg 0
    CALL tty_write_char
    POP REC                             ; discard arg
L_blocks_endif_53:
    MOV REA, REX
    LDI REZ, #0x25
    SUB REA, REZ                        ; &slot (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_blocks_loop_48
L_blocks_endloop_49:
    SET_SP_R REX                        ; SP = FP (release 47 local word(s))
    POP REX                             ; restore FP
    RTS

.CData

__cc_str_0:
    DW #0x42, #0x6C, #0x6F, #0x63, #0x6B, #0x20, #0x6D, #0x61, #0x70, #0x20, #0x28, #0x33, #0x32, #0x20, #0x62, #0x6C, #0x6F, #0x63, #0x6B, #0x73, #0x20, #0x78, #0x20, #0x36, #0x34, #0x20, #0x77, #0x6F, #0x72, #0x64, #0x73, #0x29, #0x3A, #0; "Block map (32 blocks x 64 words):" + NUL
__cc_str_1:
    DW #0x55, #0x73, #0x65, #0x64, #0x3A, #0x20, #0; "Used: " + NUL
__cc_str_2:
    DW #0x2F, #0x33, #0x32, #0x20, #0x20, #0x46, #0x72, #0x65, #0x65, #0x3A, #0x20, #0; "/32  Free: " + NUL
__cc_str_3:
    DW #0x46, #0x69, #0x6C, #0x65, #0x73, #0x3A, #0; "Files:" + NUL
__cc_str_4:
    DW #0x3A, #0x20, #0                 ; ": " + NUL
__cc_str_5:
    DW #0x20, #0x20, #0x62, #0x6C, #0x6F, #0x63, #0x6B, #0x73, #0x3A, #0x20, #0; "  blocks: " + NUL
__cc_str_6:
    DW #0x28, #0x6E, #0x6F, #0x6E, #0x65, #0x29, #0; "(none)" + NUL
__cc_str_7:
    DW #0x2C, #0x20, #0                 ; ", " + NUL
