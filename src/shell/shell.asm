!IMPORT "../mappings/Characters.asm" AS Characters
!IMPORT "../drivers/TTYDriver.asm" AS TTYDriver
!IMPORT "./commands.asm" AS commands

.Shell

Initialize:
    PUSH REA
    PUSH REB
    PUSH REC

    ; Clear character buffer by resetting the current buffer size
    LDI REB, $CommandCharacterBuffer.Start
    LDI REC, #0
    STR REB, REC

    LDI REA, Characters.GreaterThan
    CALL TTYDriver.WriteCharacter

    LDI REA, Characters.Space
    CALL TTYDriver.WriteCharacter

    POP REC
    POP REB
    POP REA
    RTS

; Dispatch the command currently in CommandCharacterBuffer.
; Buffer layout: word[0] = length, word[1..length] = chars (one per word).
;
; Strategy: length-bucketed linear search.
;   1. Branch on input length to a group containing only same-length commands.
;   2. Within a group, compare chars left-to-right; first mismatch jumps to
;      the next candidate so most rejections cost ~4 instructions.
; Register usage inside Execute:
;   REN = input length     REO = pointer to first input char (buffer + 1)
;   REP = constant 1 (offset increment)
;   REC = walking pointer into the input
;   REA = expected char    REB = actual char loaded from buffer
Execute:
    PUSH REA
    PUSH REB
    PUSH REC
    PUSH REN
    PUSH REO
    PUSH REP

    LDI REP, #1

    LDI REA, $CommandCharacterBuffer.Start
    LDI REN, [REA]                      ; REN = input length

    LDI REB, #0
    CMP REN, REB
    JP_EQ Execute_Done                  ; empty line, nothing to do

    MOV REO, REA
    ADD REO, REP                        ; REO = first char of input

    ; --- length bucket dispatch ---
    LDI REA, #2
    CMP REN, REA
    JP_EQ Group2
    LDI REA, #3
    CMP REN, REA
    JP_EQ Group3
    LDI REA, #4
    CMP REN, REA
    JP_EQ Group4
    LDI REA, #5
    CMP REN, REA
    JP_EQ Group5
    LDI REA, #6
    CMP REN, REA
    JP_EQ Group6                        
    JP Execute_Done                     ; no bucket matched -> command not found

Group2:
    ; "ls"
    MOV REC, REO
    LDI REB, [REC]
    LDI REA, Characters.l
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.s
    CMP REA, REB
    JP_NEQ Execute_Done
    CALL commands.CMD_LS
    JP Execute_Done

; -------- length 3 commands --------
Group3:
    ; "cls"
    MOV REC, REO
    LDI REB, [REC]
    LDI REA, Characters.c
    CMP REA, REB
    JP_NEQ Try_del
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.l
    CMP REA, REB
    JP_NEQ Try_del
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.s
    CMP REA, REB
    JP_NEQ Try_del
    CALL commands.CMD_CLS
    JP Execute_Done

Try_del:
    ; "del" -- delete fil(/ directory once directories are supported)
    MOV REC, REO
    LDI REB, [REC]
    LDI REA, Characters.d
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.e
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.l
    CMP REA, REB
    JP_NEQ Execute_Done
    CALL commands.CMD_DEL
    JP Execute_Done

; -------- length 4 commands --------
Group4:
    ; "halt" -- halt the CPU
    MOV REC, REO
    LDI REB, [REC]
    LDI REA, Characters.h
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.a
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.l
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.t
    CMP REA, REB
    JP_NEQ Execute_Done
    CALL commands.CMD_HALT
    JP Execute_Done

; -------- length 5 commands --------
Group5:
    ; touch (open a file)
    MOV REC, REO
    LDI REB, [REC]
    LDI REA, Characters.t
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.o
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.u
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.c
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.h
    CMP REA, REB
    JP_NEQ Execute_Done
    CALL commands.CMD_TOUCH
    JP Execute_Done

; -------- length 6 commands --------
Group6:
    MOV REC, REO
    LDI REB, [REC]
    LDI REA, Characters.d
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.o
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.f
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.i
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.l
    CMP REA, REB
    JP_NEQ Execute_Done
    ADD REC, REP
    LDI REB, [REC]
    LDI REA, Characters.e
    CMP REA, REB
    JP_NEQ Execute_Done
    CALL commands.CMD_DOFILE
    JP Execute_Done

Execute_Done:
    POP REP
    POP REO
    POP REN
    POP REC
    POP REB
    POP REA
    RTS

