!IMPORT "Drivers/KeyboardDriver.asm" AS KeyboardDriver
!IMPORT "Drivers/TTYDriver.asm" AS TTYDriver
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

LDI REA, Shell.onKeyPressed
CALL SetTTYOwner

CALL Shell.shellInitialize
CALL ScreenDriver.DrawCenterRedLine

Prog:
    NOP
    JP Prog

@REA pointer for next TTY-Owner
SetTTYOwner:
    PUSH REB

    LDI REB, $TTYOwner.Start
    STR REB, REA

    POP REB
    RTS

.InterruptVector
PUSH REA
PUSH REB
PUSH REC

GET_INT_ID REA

; Check if the interrupt is from the keyboard
LDI REB, KeyboardDevice
CMP REA, REB
JP_EQ HandleKeyboardInterrupt
JP InterruptDone

HandleKeyboardInterrupt:
    CALL Shell.onKeyPressed ; TODO: CALL[$TTYOwner.Start] -> CALL value of address is not working.
    JP InterruptDone

InterruptDone:
    POP REC
    POP REB
    POP REA
    RTI

