!IMPORT "../mappings/Characters.asm" AS Characters
!IMPORT "../drivers/TTYDriver.asm" AS TTYDriver

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

    ; TODO: check for valid instructions (command responsbile for adding new line when needed)

    POP REA  
    RTS




