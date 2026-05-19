!IMPORT "Drivers/KeyboardDriver.asm" AS KeyboardDriver
!IMPORT "Drivers/TTYDriver.asm" AS TTYDriver
!IMPORT "Mappings/Characters.asm" AS Characters
!IMPORT "Shell/shell.asm" AS Shell
!IMPORT "Shell/shell_util.asm" AS ShellUtil
!IMPORT "Shell/fs.asm" AS Fs
!IMPORT "Shell/commands/ls.asm" AS LsCmd
!IMPORT "Shell/commands/touch.asm" AS TouchCmd
!IMPORT "Shell/commands/del.asm" AS DelCmd
!IMPORT "Shell/commands/cat.asm" AS CatCmd
!IMPORT "Shell/commands/write.asm" AS WriteCmd
!IMPORT "Shell/commands/dofile.asm" AS DofileCmd
!IMPORT "Shell/commands/blocks.asm" AS BlocksCmd
!IMPORT "Shell/os_bridge.asm" AS OsBridge
!IMPORT "Drivers/ScreenDriver.asm" AS ScreenDriver
!IMPORT "Utils/stdio.asm"
!IMPORT "Utils/malloc.asm"

!DECLARE KeyboardDevice = 0x01

.Kernel

; Initialize stack pointer
SET_SP $Stack.Start

; Initialize interrupt vector
SET_IVR $InterruptVector.Start

CALL fs_init
CALL Shell.shellInitialize
CALL ScreenDriver.DrawCenterRedLine

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
    CALL Shell.onKeyPressed
    JP InterruptDone

EchoToTTY:
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
    CALL Shell.shellExecute
    CALL Shell.shellInitialize
    
    InterruptDone:

    POP REC
    POP REB
    POP REA
    RTI

