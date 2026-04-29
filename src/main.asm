!DECLARE KeyboardDevice = 0x01
!DECLARE JoystickDevice = 0x02

!IMPORT "Drivers/KeyboardDriver.asm" AS KeyboardDriver
!IMPORT "Drivers/TTYDriver.asm" AS TTYDriver
!IMPORT "Mappings/Characters.asm" AS Characters

.Kernel

; Initialize stack pointer
SET_SP $Stack.Start

; Initialize interrupt vector
SET_IVR $InterruptVector.Start

Prog:
    LDI REA, Characters.Char_Equal
    CALL TTYDriver.WriteCharacter
    JP Prog

.InterruptVector
PUSH REA
PUSH REB

CALL TTYDriver.ClearScreen

GET_INT_ID REA

; Check if the interrupt is from the keyboard
LDI REB, KeyboardDevice
CMP REA, REB
JP_NEQ CheckJoystickInterrupt ; check for the joystick if it wasn't the keyboard
JP_EQ HandleKeyboardInterrupt ; go to the keyboard driver

HandleKeyboardInterrupt:
    LDI REA, #0x01        ; Read and draw mode
    CALL KeyboardDriver.Handle
    JP InterruptDone

CheckJoystickInterrupt: ; Check if the interrupt is from the joystick
    LDI REB, JoystickDevice
    CMP REA, REB
    JP_NEQ InterruptDone            ; interrupt could not be handled, so just return
    JP_EQ HandleJoystickInterrupt   ; go to the joystick driver

HandleJoystickInterrupt:
    NOP ; TODO

InterruptDone:
    POP REB
    POP REA
    RTI

