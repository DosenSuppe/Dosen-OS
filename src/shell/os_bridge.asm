; C-callable wrappers for DASM driver routines.
;
; The C compiler uses a stack-based calling convention: 
;   args at [FP+2..]
;   return value in REA
;
; The existing OS drivers use register-based calling: 
;   arg in REA
; 
; These wrappers translate.

!IMPORT "../Drivers/TTYDriver.asm" AS TTYDriver

.CBridge

; void ttyWriteChar(int ch);
;   Byte-addressed stack: after `PUSH REX; GET_SP REX`, arg0 lives at [FP+12]
;   (frame slot 3 × 4 bytes/word).
ttyWriteChar:
    PUSH REX
    GET_SP REX
    MOV REY, REX
    LDI REZ, #12
    ADD REY, REZ
    LDI REA, [REY]
    CALL TTYDriver.WriteCharacter
    POP REX
    RTS

; void ttyClearScreen(void);
ttyClearScreen:
    PUSH REX
    GET_SP REX
    CALL TTYDriver.ClearScreen
    POP REX
    RTS

ttyReadChar:
    PUSH REX
    GET_SP REX
    CALL KeyboardDriver.Read
    MOV REA, REB
    POP REX
    RTS

; void cpuHalt(void);
;   never returns
cpuHalt:
    HALT

; void MMIOCopy(int *dst, int *src, int count);
;   Plain word-copy of `count` words. Byte-addressed: each word is 4 bytes, so
;   dst/src advance by 4 per word while count decrements by 1. Args at byte
;   offsets [FP+12], [FP+16], [FP+20] (frame slots 3/4/5 × 4).
MMIOCopy:
    PUSH REX
    GET_SP REX

    ; REA = dst   (arg 0, [FP+12])
    MOV REY, REX
    LDI REZ, #12
    ADD REY, REZ
    LDI REA, [REY]

    ; REB = src   (arg 1, [FP+16])
    MOV REY, REX
    LDI REZ, #16
    ADD REY, REZ
    LDI REB, [REY]

    ; REC = count (arg 2, [FP+20])
    MOV REY, REX
    LDI REZ, #20
    ADD REY, REZ
    LDI REC, [REY]

MMIOCopy_loop:
    LDI REZ, #0
    CMP REC, REZ
    JP_EQ MMIOCopy_done

    LDI REY, [REB]     ; REY = *src
    STR REA, REY       ; *dst = REY

    LDI REZ, #4
    ADD REA, REZ       ; dst += 4 (next word)
    ADD REB, REZ       ; src += 4

    LDI REZ, #1
    SUB REC, REZ       ; count--

    JP MMIOCopy_loop

MMIOCopy_done:
    POP REX
    RTS

; void launchUserCode(void);
;   Hands control to whatever has just been loaded at $UserCode.Start.
;   The program returns via RTS the same way any function would.
launchUserCode:
    PUSH REX
    GET_SP REX
    CALL $UserCode.Start
    POP REX
    RTS

; int *userCodeBase(void);
;   Returns the address of the .UserCode window so C callers can hand it
;   to MMIOCopy as the destination.
userCodeBase:
    PUSH REX
    GET_SP REX
    LDI REA, $UserCode.Start
    POP REX
    RTS

; void launchProgram(int *target, int argc, int **argv)
;   target at [FP+12], argc at [FP+16], argv at [FP+20]  (byte offsets)
;   Pushes argv then argc (reverse order) so the callee sees argc at its [FP+12].
launchProgram:
    PUSH REX
    GET_SP REX

    ; push argv FIRST (it's arg 1 from the callee's POV)
    MOV REY, REX
    ADD REY, #20
    LDI REB, [REY]
    PUSH REB

    ; push argc SECOND (arg 0 / lands at callee's [FP+12])
    MOV REY, REX
    ADD REY, #16
    LDI REB, [REY]
    PUSH REB

    ; load target into REA
    MOV REY, REX
    ADD REY, #12
    LDI REA, [REY]

    CALL REA

    POP REB              ; discard argc
    POP REB              ; discard argv
    POP REX
    RTS

; void pushProc(int *mainFn, int *onKeyFn);
;   PushProc (in main.asm) takes REA = main routine, REB = on-key ISR.
pushProc:
    PUSH REX
    GET_SP REX

    MOV REY, REX
    ADD REY, #12
    LDI REA, [REY]       ; REA = mainFn   (arg 0, [FP+12])

    MOV REY, REX
    ADD REY, #16
    LDI REB, [REY]       ; REB = onKeyFn  (arg 1, [FP+16])

    CALL PushProc

    POP REX
    RTS

; void popProc(void);
;   Pops the top process off the proc stack, restoring the one beneath.
popProc:
    PUSH REX
    GET_SP REX
    CALL PopProc
    POP REX
    RTS
