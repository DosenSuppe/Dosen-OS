; demo.asm — a program assembled AT RUNTIME by the on-device assembler.
;
; Put this file in the FS (it ships in PermStorage), then in the OS:
;   asm demo.asm
; The assembler turns this text into machine code in .UserCode and runs it.
;
; Entry is the label `_start` (else the first word). Kernel services are reached
; through predefined SYS_ symbols (the syscall table).

_start:
    PUSH REX
    GET_SP REX

    ; prints(msg, 1)
    LDI REA, #1
    PUSH REA                ; arg1: newLine
    LDI REA, msg
    PUSH REA                ; arg0: msg
    LDI REA, [SYS_prints]
    CALL REA
    POP REC
    POP REC

    POP REX
    LDI REA, #0
    RTS

; "asm works!" + null terminator
msg:
    DW #0x61, #0x73, #0x6D, #0x20
    DW #0x77, #0x6F, #0x72, #0x6B, #0x73, #0x21
    DW #0x00
