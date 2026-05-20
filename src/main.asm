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

; ensure pointer is initialized as 0
LDI REA, #0
LDI REB, $ProcStackTop.Start
STR [REB], REA

; default foreground process (shell)
LDI REA, #0 ; shell has no main routine
LDI REB, Shell.onKey
CALL PushProc

CALL Shell.shellInitialize
CALL ScreenDriver.DrawCenterRedLine

KernelDispatch:
    PUSH RET
    LDI RET, $ProcStackTop.Start
    LDI REA, [RET]
    POP RET

    LDI REB, $ProcStack.Start
    ADD REA, REB ; absolute addr of mainLoop slot

    ; if mainLoop is null, the process is event-driven — just spin and let the ISR drive it
    LDI REC, [REA]
    LDI REB, #0
    CMP REC, REB
    JP_EQ KernelDispatch

    CALL [REA]
    JP KernelDispatch

@REA main routine
@REB on-key ISR
PushProc:
    PUSH RET
    PUSH REX
    PUSH REY
    PUSH REZ

    LDI RET, #1
    LDI REX, $ProcStack.Start
    LDI REY, $ProcStackTop.Start
    LDI REZ, [REY] ; get value of current proc-stack pointer

    ADD REZ, REX ; apply pointer onto the stack to get current address

    ; saving on-key routine to stack
    ADD REZ, RET
    STR [REZ], REB
    
    ; saving main routine to stack
    ADD REZ, RET
    STR [REZ], REA

    SUB REZ, REX    ; remove the offset to get pure SP value again
    STR [REY], REZ  ; save new SP value

    POP REZ
    POP REY
    POP REX
    POP RET
    RTS

PopProc:
    PUSH REY
    PUSH REZ
    PUSH RET

    LDI RET, #2

    LDI REY, $ProcStackTop.Start
    LDI REZ, [REY]  ; get value of current proc-stack pointer
    SUB REZ, RET     ; remove top two entries
    STR [REY], REZ  ; save new SP value

    POP RET
    POP REZ
    POP REY
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
    PUSH REB
    PUSH RET
    PUSH REZ

    LDI REZ, $ProcStackTop.Start
    LDI RET, #1
    LDI REA, [REZ]
    LDI REB, $ProcStack.Start
    
    ADD REA, REB ; add address offset
    SUB REA, RET ; remove index offset for on-key routine
    
    POP REZ
    POP RET
    POP REB

    CALL [REA] ; top most process has the keyboard handle
    JP InterruptDone

InterruptDone:
    POP REC
    POP REB
    POP REA
    RTI

