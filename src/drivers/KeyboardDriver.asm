!IMPORT "TTYDriver.asm" AS TTYDriver

.KeyboardDriver

@REA Driver-Action mode
@REB set to key-value when using read mode
Handle:
    PUSH REB
    PUSH REZ

    ; Check for Read-Write mode
    LDI REB, #0x01
    SUB REB, REA, REZ
    JPZ HandleReadAndDraw
    JP HandleRead

    ; Perform Read-Write mode
    HandleReadAndDraw:
        CALL ReadAndDraw
        JP HandleDone

    ; Check for Read mode
    HandleRead:
    ADD REB, REB
    SUB REB, REA, REZ
    JPZ HandleRead
    JP HandleDone

    ; Perform Read mode
    HandleRead:
        CALL Read
        
    ; finish/ mode not found
    HandleDone:

    POP REZ
    POP REB
    RTS

ReadAndDraw:
    PUSH REX
    PUSH REA
    PUSH REZ

    LDI REX, $MemDevice1.Start  ; load address of device 1
    LDI REA, [REX]              ; read value from device 1

    CALL TTYDriver.WriteCharacter
    
    POP REZ
    POP REA
    POP REX
    RTS 

@REB returns the value that was read from the keyboard buffer
Read:
    PUSH REX

    LDI REX, $MemDevice1.Start  ; load address of device 1
    LDI REB, [REX]              ; read value from device 1

    POP REX
    RTS
