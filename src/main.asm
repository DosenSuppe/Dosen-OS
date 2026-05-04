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
PUSH REC

GET_INT_ID REA

; Check if the interrupt is from the keyboard
LDI REB, KeyboardDevice
CMP REA, REB
JP_EQ HandleKeyboardInterrupt ; go to the keyboard driver
JP InterruptDone

HandleKeyboardInterrupt:
    ; read character to screen
    CALL KeyboardDriver.Read

    ; write character to TTY
    MOV REA, REB
    CALL TTYDriver.WriteCharacter

    ; check for new-line (execute command)
    LDI REC, Characters.NewLine
    CMP REC, REB
    JP_EQ TriggerExecute

    ; store character to RAM-Buffer
    PUSH REZ
    PUSH REY
    PUSH REX
    PUSH REW

    ; get current size of stored characters
    LDI REZ, $CommandCharacterBuffer.Start
    LDI REY, [REZ]

    ; increase size of stored characters
    LDI REX, #1

    LDI REW, Characters.Backspace
    CMP REA, REW
    JP_EQ DecreaseBufferSize

    ADD REY, REX
    STR REZ, REY        ; store new size of buffered characters
    JP StoreChar

    DecreaseBufferSize:
    SUB REY, REX
    STR REZ, REY        ; store new size of buffered characters
    JP UpdateCommandBufferDone

    StoreChar:
    ADD REY, REZ, REW   ; get index to store new character to (store in REW)
    STR REW, REA        ; store character to new index

    UpdateCommandBufferDone:

    POP REW
    POP REX
    POP REY
    POP REZ

    JP InterruptDone

TriggerExecute:
    CALL Shell.Execute
    CALL Shell.Initialize
    JP InterruptDone

InterruptDone:
    POP REC
    POP REB
    POP REA
    RTI

