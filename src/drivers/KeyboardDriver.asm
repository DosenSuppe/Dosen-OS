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
    PUSH REZ
    PUSH REA

    LDI REB, [$MemDevice0.Start]    ; read value from device 1
    MOV REA, REB 

    CALL TTYDriver.WriteCharacter
    
    POP REA
    POP REZ
    RTS 

@REB returns the value that was read from the keyboard buffer
Read:
    LDI REB, [$MemDevice0.Start]    ; read value from device 1
    RTS
