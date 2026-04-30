!IMPORT "../mappings/Characters.asm" AS Characters
!IMPORT "../drivers/TTYDriver.asm" AS TTYDriver

.Shell

Initialize:
    PUSH REA

    LDI REA, Characters.GreaterThan
    CALL TTYDriver.WriteCharacter

    LDI REA, Characters.Space
    CALL TTYDriver.WriteCharacter

    POP REA 
    RTS

Execute:
    RTS