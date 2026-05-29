; C-callable wrappers for DASM driver routines.
;
; The C compiler (cc.py) uses a stack-based calling convention: args at
; [FP+2..], return value in REA. The existing OS drivers use register-based
; calling: arg in REA. These wrappers translate.

!IMPORT "../Drivers/TTYDriver.asm" AS TTYDriver

; Dedicated segment so we don't collide with shell.asm (the C output), which
; also uses .CCode. The linker places each object's segment starting at
; segment_base + 0, so two objects in the same segment overwrite each other.
.CBridge

; void ttyWriteChar(int ch);
;   Grow-down post-decrement stack: after `PUSH REX; GET_SP REX`, arg0 lives at [FP+3].
ttyWriteChar:
    PUSH REX
    GET_SP REX
    MOV REY, REX
    LDI REZ, #3
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
;   Plain word-copy. Works for RAM↔RAM, RAM↔MMIO, and MMIO↔MMIO since every
;   address on this CPU is a 24-bit word and LDI/STR pass through the bus.
;   Used to move a loaded program into the .UserCode window.
MMIOCopy:
    PUSH REX
    GET_SP REX

    ; REA = dst   (arg 0, [FP+3])
    MOV REY, REX
    LDI REZ, #3
    ADD REY, REZ
    LDI REA, [REY]

    ; REB = src   (arg 1, [FP+4])
    MOV REY, REX
    LDI REZ, #4
    ADD REY, REZ
    LDI REB, [REY]

    ; REC = count (arg 2, [FP+5])
    MOV REY, REX
    LDI REZ, #5
    ADD REY, REZ
    LDI REC, [REY]

MMIOCopy_loop:
    LDI REZ, #0
    CMP REC, REZ
    JP_EQ MMIOCopy_done

    LDI REY, [REB]     ; REY = *src
    STR REA, REY       ; *dst = REY

    LDI REZ, #1
    ADD REA, REZ       ; dst++
    ADD REB, REZ       ; src++
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
;   target at [FP+3], argc at [FP+4], argv at [FP+5]
;   Pushes argv then argc (reverse order) so the callee sees argc at its [FP+3].
launchProgram:
    PUSH REX
    GET_SP REX

    ; push argv FIRST (it's arg 1 from the callee's POV)
    MOV REY, REX
    ADD REY, #5
    LDI REB, [REY]
    PUSH REB

    ; push argc SECOND (arg 0 / lands at callee's [FP+3])
    MOV REY, REX
    ADD REY, #4
    LDI REB, [REY]
    PUSH REB

    ; load target into REA
    MOV REY, REX
    ADD REY, #3
    LDI REA, [REY]

    CALL REA

    POP REB              ; discard argc
    POP REB              ; discard argv
    POP REX
    RTS
