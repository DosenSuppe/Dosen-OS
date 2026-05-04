!IMPORT "../mappings/Characters.asm" AS Characters
!IMPORT "../drivers/TTYDriver.asm" AS TTYDriver
!IMPORT "./commands.asm" AS commands

.Shell

Initialize:
    PUSH REA
    PUSH REB
    PUSH REC

    ; Clear character buffer by resetting the current buffer size
    LDI REB, $CommandCharacterBuffer.Start
    LDI REC, #0
    STR REB, REC

    LDI REA, Characters.GreaterThan
    CALL TTYDriver.WriteCharacter

    LDI REA, Characters.Space
    CALL TTYDriver.WriteCharacter

    POP REC
    POP REB
    POP REA 
    RTS

Execute:
    PUSH REA
    PUSH REB

    CALL PackChars

    LDI REB, #0x636C73
    CMP REA, REB
    CALL_EQ commands.CMD_CLS
    JP_EQ ExecuteDone

    ExecuteDone:
    POP REB
    POP REA  
    RTS

; packs up to 3 characters into one register
; value returned in REA
PackChars:
    PUSH REB
    PUSH RES
    PUSH REC
    PUSH REN
    PUSH REP
    PUSH REZ
    PUSH REU

    LDI REB, $CommandCharacterBuffer.Start   ; base
    LDI REC, #3
    LDI REU, [REB]

    CMP REU, REC
    JP_NEQ packingDone ; check that the command has the correct length

    LDI REA, #0
    LDI RES, #8
    LDI REN, #0
    LDI REP, #1

    pack:
        ADD REN, REP       ; advance offset (starts at 1, skipping length byte)

        MOV REZ, REB       ; REZ = base
        ADD REZ, REN       ; REZ = base + offset (fresh each iteration)
        LDI REZ, [REZ]     ; load buf[offset]

        SHL REA, RES
        ADD REA, REZ

        CMP REN, REC
        JP_LT pack

    packingDone:
    POP REU
    POP REZ
    POP REP
    POP REN
    POP REC
    POP RES
    POP REB
    RTS

