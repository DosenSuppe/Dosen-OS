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

; void tty_write_char(int ch);
;   Grow-down post-decrement stack: after `PUSH REX; GET_SP REX`, arg0 lives at [FP+3].
tty_write_char:
    PUSH REX
    GET_SP REX
    MOV REY, REX
    LDI REZ, #3
    ADD REY, REZ
    LDI REA, [REY]
    CALL TTYDriver.WriteCharacter
    POP REX
    RTS

; void tty_clear_screen(void);
tty_clear_screen:
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

; void cpu_halt(void);
;   never returns
cpu_halt:
    HALT

    