; ============================================================
; cc.py output for malloc.c
; Auto-generated. Do not edit by hand.
; ============================================================

.CCode


; --- function _heap_start() ---
; frame: 0 local word(s)
_heap_start:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
; inline asm
LDI REA, $Heap.Start
    POP REX                             ; restore FP
    RTS

; --- function malloc(int nWords) ---
; frame: 1 local word(s)
malloc:
    PUSH REX                            ; save old FP
    GET_SP REX                          ; FP = SP
    PUSH #0                             ; reserve local
    LDI REA, #0x0
    PUSH REA                            ; save RHS of ==
    LDI REY, heapInitialized            ; &heapInitialized
    LDI REA, [REY]                      ; heapInitialized
    POP REB                             ; REB = RHS
    CMP REA, REB
    LDI REA, #0                         ; default false
    JP_NEQ L_malloc_cmp_2
    LDI REA, #1                         ; true
L_malloc_cmp_2:
    LDI REB, #0
    CMP REA, REB
    JP_EQ L_malloc_endif_1
    CALL _heap_start
    LDI REY, heapTop                    ; &heapTop (global)
    STR REY, REA                        ; *target = value
    LDI REA, #0x1
    LDI REY, heapInitialized            ; &heapInitialized (global)
    STR REY, REA                        ; *target = value
L_malloc_endif_1:
    LDI REY, heapTop                    ; &heapTop
    LDI REA, [REY]                      ; heapTop
    STR_LOC REA, #0x0                   ; result = value
    LDR_ARG REA, #0x3                   ; nWords
    PUSH REA                            ; RHS of +=
    LDI REY, heapTop                    ; &heapTop
    LDI REA, [REY]                      ; heapTop
    POP REB
    ADD REA, REB
    LDI REY, heapTop                    ; &heapTop (global)
    STR REY, REA                        ; *target = value
    LDR_LOC REA, #0x0                   ; result
    SET_SP_R REX                        ; SP = FP (release 1 local word(s))
    POP REX                             ; restore FP
    RTS

.CData

heapTop:
    DW #0                               ; int*
heapInitialized:
    DW #0                               ; int
