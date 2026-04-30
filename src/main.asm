!IMPORT "Drivers/KeyboardDriver.asm" AS KeyboardDriver
!IMPORT "Drivers/TTYDriver.asm" AS TTYDriver
!IMPORT "Mappings/Characters.asm" AS Characters
!IMPORT "Shell/Shell.asm" AS Shell

!DECLARE KeyboardDevice = 0x01

.Kernel

; Initialize stack pointer
SET_SP $Stack.Start

; Initialize interrupt vector
SET_IVR $InterruptVector.Start

CALL Shell.Initialize
Prog:
    NOP
    JP Prog

.InterruptVector
PUSH REA
PUSH REB

CALL TTYDriver.ClearScreen

GET_INT_ID REA

; Check if the interrupt is from the keyboard
LDI REB, KeyboardDevice
CMP REA, REB
JP_EQ HandleKeyboardInterrupt ; go to the keyboard driver
JP InterruptDone

HandleKeyboardInterrupt:
    ; read character to screen
    CALL KeyboardDriver.Read

    ; check for new-line (execute command)
    LDI REC, Characters.NewLine
    CMP REC, REA 
    CALL_EQ TriggerExecute

    ; write character to TTY
    CALL TTYDriver.WriteCharacter

    JP InterruptDone

TriggerExecute:
    CALL Shell.Execute
    CALL Shell.Initialize
    RTS

InterruptDone:
    POP REB
    POP REA
    RTI

