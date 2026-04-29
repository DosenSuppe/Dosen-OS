!IMPORT "TTYDriver.asm" AS TTYDriver

.KeyboardDriver

; Read-Draw mode: REA = 0x01, REB = value read from keyboard buffer
; Read mode: REA = 0x02, REB = value read from keyboard buffer
@REA Driver-Action mode
@REB set to key-value when using read mode
Handle:
    PUSH REZ

    ; Check for Read-Write mode
    LDI REB, #0x01
    CMP REB, REA
    JP_NEQ CheckReadMode
    CALL_EQ ReadAndDraw
    JP HandleDone

    ; Check for Read mode
    CheckReadMode:
        LDI REB, #0x02
        CMP REB, REA
        CALL_EQ Read

    ; finish/ mode not found
    HandleDone:
        POP REZ
        RTS

ReadAndDraw:
    PUSH REX
    PUSH REZ
    PUSH REA

    LDI REX, $MemDevice1.Start  ; load address of device 1
    LDI REB, [REX]              ; read value from device 1
    MOV REA, REB 

    CALL TTYDriver.WriteCharacter
    
    POP REA
    POP REZ
    POP REX
    RTS 

@REB returns the value that was read from the keyboard buffer
Read:
    PUSH REX

    LDI REX, $MemDevice1.Start  ; load address of device 1
    LDI REB, [REX]              ; read value from device 1

    POP REX
    RTS
