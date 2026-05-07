!IMPORT "../drivers/TTYDriver.asm" AS TTYDriver
.StringLib

@REA RAM-Address of string
PrintString:
    PUSH REB
    PUSH REC
    PUSH REN

    LDI REB, [REA]      ; get length of the string
    LDI REC, #0x1
    LDI REN, #0x1

    _printStringLoop:
        PUSH REA 
        ADD REA, REC
        LDI REA, [REA]
        CALL TTYDriver.WriteCharacter
        POP REA 
        ADD REC, REN

        CMP REC, REB
        JP_GT _printStringDone
        JP _printStringLoop

    _printStringDone:
    
    POP REN 
    POP REC 
    POP REB
    RTS

@REA Address of where to copy the buffer to
CopyStringBufferToAddress:
    PUSH REB
    PUSH REC
    PUSH REN
    PUSH REZ

    LDI REZ, CommandCharacterBuffer.Start
    LDI REB, [REZ]      ; get length of the string
    STR REA, REB        ; store the length of the string

    LDI REC, #0x1
    LDI REN, #0x1

    _copyLoop:
        PUSH REZ 
        ADD REZ, REC
        LDI REZ, [REZ]
        STR REA, REZ
        POP REZ 
        ADD REC, REN

        CMP REC, REB
        JP_GT _copyLoopDone
        JP _copyLoop

    _copyLoopDone:
    
    POP REZ
    POP REN 
    POP REC 
    POP REB
    RTS