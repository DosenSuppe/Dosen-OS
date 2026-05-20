; ============================================================
; cc.py output for fs.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function fs_storage() ---
; frame: 0 local word(s)
fs_storage:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
; inline asm
LDI REA, $FileStorage.Start
    POP REX                             ; restore FP
    RTS

; --- function fs_entry_ptr(int slot) ---
; frame: 2 local word(s)
fs_entry_ptr:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    CALL files_buffer
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REA, #0x19
    PUSH REA                            ; save RHS of *
    LDR_ARG REA, #0x3                   ; slot
    POP REB                             ; REB = RHS
    MUL REA, REB
    PUSH REA                            ; save RHS of +
    LDI REA, #0x21
    POP REB                             ; REB = RHS
    ADD REA, REB
    STR_LOC REA, #0x1                   ; *local = REA
    LDR_LOC REA, #0x1                   ; off
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    SET_SP_R REX                        ; SP = FP (release 2 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function fs_init() ---
; frame: 3 local word(s)
fs_init:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    CALL files_buffer
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REA, #0x0
    STR_LOC REA, #0x1                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
L_fs_init_loop_0:
    LDI REA, #0x20
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x1                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_fs_init_cmp_2
    JP_EQ L_fs_init_cmp_2
    LDI REA, #1                         ; true
L_fs_init_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_init_endloop_1
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDR_LOC REA, #0x1                   ; i
    PUSH REA                            ; save RHS of +
    LDI REA, #0x1
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    LDR_LOC REA, #0x1                   ; i
    POP REB                             ; REB = RHS
    ADD REA, REB
    STR_LOC REA, #0x1                   ; i = value
    JP L_fs_init_loop_0
L_fs_init_endloop_1:
    LDI REA, #0x0
    STR_LOC REA, #0x1                   ; i = value
L_fs_init_loop_4:
    LDI REA, #0x8
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x1                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_fs_init_cmp_6
    JP_EQ L_fs_init_cmp_6
    LDI REA, #1                         ; true
L_fs_init_cmp_6:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_init_endloop_5
    LDR_LOC REA, #0x1                   ; i
    PUSH REA                            ; arg 0
    CALL fs_entry_ptr
    POP REC                             ; discard arg
    STR_LOC REA, #0x2                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x2                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    MOV REA, REX
    LDI REZ, #0x1
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_fs_init_loop_4
L_fs_init_endloop_5:
    SET_SP_R REX                        ; SP = FP (release 3 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function fs_file_count() ---
; frame: 1 local word(s)
fs_file_count:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    CALL files_buffer
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function fs_entry_by_idx(int idx) ---
; frame: 3 local word(s)
fs_entry_by_idx:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDI REA, #0x0
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REA, #0x0
    STR_LOC REA, #0x1                   ; *local = REA
L_fs_entry_by_idx_loop_8:
    LDI REA, #0x8
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x1                   ; slot
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_fs_entry_by_idx_cmp_10
    JP_EQ L_fs_entry_by_idx_cmp_10
    LDI REA, #1                         ; true
L_fs_entry_by_idx_cmp_10:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_entry_by_idx_endloop_9
    LDR_LOC REA, #0x1                   ; slot
    PUSH REA                            ; arg 0
    CALL fs_entry_ptr
    POP REC                             ; discard arg
    STR_LOC REA, #0x2                   ; *local = REA
    LDI REA, #0x1
    PUSH REA                            ; save RHS of ==
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x2                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_fs_entry_by_idx_cmp_14
    LDI REA, #1                         ; true
L_fs_entry_by_idx_cmp_14:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_entry_by_idx_endif_13
    LDR_ARG REA, #0x3                   ; idx
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x0                   ; active
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_fs_entry_by_idx_cmp_17
    LDI REA, #1                         ; true
L_fs_entry_by_idx_cmp_17:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_entry_by_idx_endif_16
    LDR_LOC REA, #0x2                   ; e
    SET_SP_R REX                        ; SP = FP (release 3 local word(s))
    POP REX                             ; restore FP
    RTS
L_fs_entry_by_idx_endif_16:
    MOV REA, REX
    LDI REZ, #0
    SUB REA, REZ                        ; &active (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
L_fs_entry_by_idx_endif_13:
    MOV REA, REX
    LDI REZ, #0x1
    SUB REA, REZ                        ; &slot (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_fs_entry_by_idx_loop_8
L_fs_entry_by_idx_endloop_9:
    LDI REA, #0x0
    SET_SP_R REX                        ; SP = FP (release 3 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function fs_name_equals(int* entry, int* name, int name_len) ---
; frame: 1 local word(s)
fs_name_equals:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    LDR_ARG REA, #0x5                   ; name_len
    PUSH REA                            ; save RHS of !=
    LDI REA, #0x1
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_fs_name_equals_cmp_20
    LDI REA, #1                         ; true
L_fs_name_equals_cmp_20:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_name_equals_endif_19
    LDI REA, #0x0
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS
L_fs_name_equals_endif_19:
    LDI REA, #0x0
    STR_LOC REA, #0x0                   ; *local = REA
L_fs_name_equals_loop_21:
    LDR_ARG REA, #0x5                   ; name_len
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x0                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_fs_name_equals_cmp_23
    JP_EQ L_fs_name_equals_cmp_23
    LDI REA, #1                         ; true
L_fs_name_equals_cmp_23:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_name_equals_endloop_22
    LDR_LOC REA, #0x0                   ; i
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x4                   ; name
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; save RHS of !=
    LDR_LOC REA, #0x0                   ; i
    PUSH REA                            ; save RHS of +
    LDI REA, #0x2
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_fs_name_equals_cmp_27
    LDI REA, #1                         ; true
L_fs_name_equals_cmp_27:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_name_equals_endif_26
    LDI REA, #0x0
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS
L_fs_name_equals_endif_26:
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
    JP L_fs_name_equals_loop_21
L_fs_name_equals_endloop_22:
    LDI REA, #0x1
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function fs_find(int* name, int name_len) ---
; frame: 2 local word(s)
fs_find:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDI REA, #0x0
    STR_LOC REA, #0x0                   ; *local = REA
L_fs_find_loop_28:
    LDI REA, #0x8
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x0                   ; slot
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_fs_find_cmp_30
    JP_EQ L_fs_find_cmp_30
    LDI REA, #1                         ; true
L_fs_find_cmp_30:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_find_endloop_29
    LDR_LOC REA, #0x0                   ; slot
    PUSH REA                            ; arg 0
    CALL fs_entry_ptr
    POP REC                             ; discard arg
    STR_LOC REA, #0x1                   ; *local = REA
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
    JP_NEQ L_fs_find_cmp_34
    LDI REA, #1                         ; true
L_fs_find_cmp_34:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_find_endif_33
    LDI REA, #0x1
    PUSH REA                            ; save RHS of ==
    LDR_ARG REA, #0x4                   ; name_len
    PUSH REA                            ; arg 2
    LDR_ARG REA, #0x3                   ; name
    PUSH REA                            ; arg 1
    LDR_LOC REA, #0x1                   ; e
    PUSH REA                            ; arg 0
    CALL fs_name_equals
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_fs_find_cmp_37
    LDI REA, #1                         ; true
L_fs_find_cmp_37:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_find_endif_36
    LDR_LOC REA, #0x1                   ; e
    SET_SP_R REX                        ; SP = FP (release 2 local word(s))
    POP REX                             ; restore FP
    RTS
L_fs_find_endif_36:
L_fs_find_endif_33:
    MOV REA, REX
    LDI REZ, #0
    SUB REA, REZ                        ; &slot (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_fs_find_loop_28
L_fs_find_endloop_29:
    LDI REA, #0x0
    SET_SP_R REX                        ; SP = FP (release 2 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function fs_create(int* name, int name_len) ---
; frame: 4 local word(s)
fs_create:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDI REA, #0x0
    PUSH REA                            ; save RHS of <=
    LDR_ARG REA, #0x4                   ; name_len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_fs_create_cmp_40
    LDI REA, #1                         ; true
L_fs_create_cmp_40:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_create_endif_39
    LDI REA, #0x0
    SET_SP_R REX                        ; SP = FP (release 4 local word(s))
    POP REX                             ; restore FP
    RTS
L_fs_create_endif_39:
    LDI REA, #0xC
    PUSH REA                            ; save RHS of >
    LDR_ARG REA, #0x4                   ; name_len
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_LT L_fs_create_cmp_43
    JP_EQ L_fs_create_cmp_43
    LDI REA, #1                         ; true
L_fs_create_cmp_43:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_create_endif_42
    LDI REA, #0x0
    SET_SP_R REX                        ; SP = FP (release 4 local word(s))
    POP REX                             ; restore FP
    RTS
L_fs_create_endif_42:
    LDI REA, #0x0
    PUSH REA                            ; save RHS of !=
    LDR_ARG REA, #0x4                   ; name_len
    PUSH REA                            ; arg 1
    LDR_ARG REA, #0x3                   ; name
    PUSH REA                            ; arg 0
    CALL fs_find
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_EQ L_fs_create_cmp_46
    LDI REA, #1                         ; true
L_fs_create_cmp_46:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_create_endif_45
    LDI REA, #0x0
    SET_SP_R REX                        ; SP = FP (release 4 local word(s))
    POP REX                             ; restore FP
    RTS
L_fs_create_endif_45:
    LDI REA, #0x0
    STR_LOC REA, #0x0                   ; *local = REA
L_fs_create_loop_47:
    LDI REA, #0x8
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x0                   ; slot
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_fs_create_cmp_49
    JP_EQ L_fs_create_cmp_49
    LDI REA, #1                         ; true
L_fs_create_cmp_49:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_create_endloop_48
    LDR_LOC REA, #0x0                   ; slot
    PUSH REA                            ; arg 0
    CALL fs_entry_ptr
    POP REC                             ; discard arg
    STR_LOC REA, #0x1                   ; *local = REA
    LDI REA, #0x0
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
    JP_NEQ L_fs_create_cmp_53
    LDI REA, #1                         ; true
L_fs_create_cmp_53:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_create_endif_52
    LDI REA, #0x1
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDR_ARG REA, #0x4                   ; name_len
    PUSH REA                            ; save value
    LDI REA, #0x1
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    STR_LOC REA, #0x2                   ; *local = REA
L_fs_create_loop_54:
    LDR_ARG REA, #0x4                   ; name_len
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x2                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_fs_create_cmp_56
    JP_EQ L_fs_create_cmp_56
    LDI REA, #1                         ; true
L_fs_create_cmp_56:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_create_endloop_55
    LDR_LOC REA, #0x2                   ; i
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; name
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; save value
    LDR_LOC REA, #0x2                   ; i
    PUSH REA                            ; save RHS of +
    LDI REA, #0x2
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    MOV REA, REX
    LDI REZ, #0x2
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_fs_create_loop_54
L_fs_create_endloop_55:
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0xE
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0xF
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x10
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    CALL files_buffer
    STR_LOC REA, #0x3                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x3                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    LDR_LOC REA, #0x1                   ; e
    SET_SP_R REX                        ; SP = FP (release 4 local word(s))
    POP REX                             ; restore FP
    RTS
L_fs_create_endif_52:
    MOV REA, REX
    LDI REZ, #0
    SUB REA, REZ                        ; &slot (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_fs_create_loop_47
L_fs_create_endloop_48:
    LDI REA, #0x0
    SET_SP_R REX                        ; SP = FP (release 4 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function fs_delete(int* name, int name_len) ---
; frame: 5 local word(s)
fs_delete:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDR_ARG REA, #0x4                   ; name_len
    PUSH REA                            ; arg 1
    LDR_ARG REA, #0x3                   ; name
    PUSH REA                            ; arg 0
    CALL fs_find
    POP REC                             ; discard arg
    POP REC                             ; discard arg
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x0                   ; e
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_fs_delete_cmp_60
    LDI REA, #1                         ; true
L_fs_delete_cmp_60:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_delete_endif_59
    LDI REA, #0x0
    SET_SP_R REX                        ; SP = FP (release 5 local word(s))
    POP REX                             ; restore FP
    RTS
L_fs_delete_endif_59:
    CALL files_buffer
    STR_LOC REA, #0x1                   ; *local = REA
    LDI REA, #0x10
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x2                   ; *local = REA
    LDI REA, #0x0
    STR_LOC REA, #0x3                   ; *local = REA
L_fs_delete_loop_61:
    LDR_LOC REA, #0x2                   ; bc
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x3                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_fs_delete_cmp_63
    JP_EQ L_fs_delete_cmp_63
    LDI REA, #1                         ; true
L_fs_delete_cmp_63:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_delete_endloop_62
    LDR_LOC REA, #0x3                   ; i
    PUSH REA                            ; save RHS of +
    LDI REA, #0x11
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x4                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDR_LOC REA, #0x4                   ; bid
    PUSH REA                            ; save RHS of +
    LDI REA, #0x1
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    MOV REA, REX
    LDI REZ, #0x3
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_fs_delete_loop_61
L_fs_delete_endloop_62:
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; e
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x1
    PUSH REA                            ; save RHS of -
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    SUB REA, REB
    PUSH REA                            ; save value
    LDI REA, #0x0
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x1                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x1
    SET_SP_R REX                        ; SP = FP (release 5 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function fs_free_blocks(int* entry) ---
; frame: 4 local word(s)
fs_free_blocks:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    CALL files_buffer
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REA, #0x10
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x1                   ; *local = REA
    LDI REA, #0x0
    STR_LOC REA, #0x2                   ; *local = REA
L_fs_free_blocks_loop_65:
    LDR_LOC REA, #0x1                   ; bc
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x2                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_fs_free_blocks_cmp_67
    JP_EQ L_fs_free_blocks_cmp_67
    LDI REA, #1                         ; true
L_fs_free_blocks_cmp_67:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_free_blocks_endloop_66
    LDR_LOC REA, #0x2                   ; i
    PUSH REA                            ; save RHS of +
    LDI REA, #0x11
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    STR_LOC REA, #0x3                   ; *local = REA
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDR_LOC REA, #0x3                   ; bid
    PUSH REA                            ; save RHS of +
    LDI REA, #0x1
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    MOV REA, REX
    LDI REZ, #0x2
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_fs_free_blocks_loop_65
L_fs_free_blocks_endloop_66:
    LDI REA, #0x0
    PUSH REA                            ; save value
    LDI REA, #0x10
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    SET_SP_R REX                        ; SP = FP (release 4 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function fs_alloc_block(int* entry) ---
; frame: 2 local word(s)
fs_alloc_block:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    PUSH #0                             ; reserve local
    LDI REA, #0x8
    PUSH REA                            ; save RHS of >=
    LDI REA, #0x10
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_LT L_fs_alloc_block_cmp_71
    LDI REA, #1                         ; true
L_fs_alloc_block_cmp_71:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_alloc_block_endif_70
    LDI REA, #0x1
    PUSH REA                            ; save RHS of -
    LDI REA, #0x0
    POP REB                             ; REB = RHS
    SUB REA, REB
    SET_SP_R REX                        ; SP = FP (release 2 local word(s))
    POP REX                             ; restore FP
    RTS
L_fs_alloc_block_endif_70:
    CALL files_buffer
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REA, #0x0
    STR_LOC REA, #0x1                   ; *local = REA
L_fs_alloc_block_loop_72:
    LDI REA, #0x20
    PUSH REA                            ; save RHS of <
    LDR_LOC REA, #0x1                   ; i
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_GT L_fs_alloc_block_cmp_74
    JP_EQ L_fs_alloc_block_cmp_74
    LDI REA, #1                         ; true
L_fs_alloc_block_cmp_74:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_alloc_block_endloop_73
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDR_LOC REA, #0x1                   ; i
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
    JP_NEQ L_fs_alloc_block_cmp_78
    LDI REA, #1                         ; true
L_fs_alloc_block_cmp_78:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_fs_alloc_block_endif_77
    LDI REA, #0x1
    PUSH REA                            ; save value
    LDR_LOC REA, #0x1                   ; i
    PUSH REA                            ; save RHS of +
    LDI REA, #0x1
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; buf
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDR_LOC REA, #0x1                   ; i
    PUSH REA                            ; save value
    LDI REA, #0x10
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    PUSH REA                            ; save RHS of +
    LDI REA, #0x11
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDI REA, #0x1
    PUSH REA                            ; save RHS of +
    LDI REA, #0x10
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA
    LDI REA, [REY]                      ; deref a[i]
    POP REB                             ; REB = RHS
    ADD REA, REB
    PUSH REA                            ; save value
    LDI REA, #0x10
    PUSH REA                            ; save scaled index
    LDR_ARG REA, #0x3                   ; entry
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    MOV REY, REA                        ; REY = &target
    POP REA                             ; restore value
    STR REY, REA                        ; *target = value
    LDR_LOC REA, #0x1                   ; i
    SET_SP_R REX                        ; SP = FP (release 2 local word(s))
    POP REX                             ; restore FP
    RTS
L_fs_alloc_block_endif_77:
    MOV REA, REX
    LDI REZ, #0x1
    SUB REA, REZ                        ; &i (local)
    MOV REY, REA                        ; addr of target
    LDI REA, [REY]                      ; load target
    PUSH REA                            ; save old (postfix result)
    LDI REB, #1
    ADD REA, REB
    STR REY, REA                        ; commit new value
    POP REA                             ; REA = old value
    JP L_fs_alloc_block_loop_72
L_fs_alloc_block_endloop_73:
    LDI REA, #0x1
    PUSH REA                            ; save RHS of -
    LDI REA, #0x0
    POP REB                             ; REB = RHS
    SUB REA, REB
    SET_SP_R REX                        ; SP = FP (release 2 local word(s))
    POP REX                             ; restore FP
    RTS

; --- function fs_block_data(int block_id) ---
; frame: 1 local word(s)
fs_block_data:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    CALL fs_storage
    STR_LOC REA, #0x0                   ; *local = REA
    LDI REA, #0x40
    PUSH REA                            ; save RHS of *
    LDR_ARG REA, #0x3                   ; block_id
    POP REB                             ; REB = RHS
    MUL REA, REB
    PUSH REA                            ; save scaled index
    LDR_LOC REA, #0x0                   ; base
    POP REB                             ; REB = scaled index
    ADD REA, REB                        ; &base[index]
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS
