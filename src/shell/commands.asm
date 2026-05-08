!IMPORT "../drivers/TTYDriver.asm" AS TTYDriver
!IMPORT "../mappings/Characters.asm" AS Characters
!IMPORT "../utils/String.asm" AS String

.Commands

CMD_CLS:
    CALL TTYDriver.ClearScreen
    RTS

CMD_HALT:
    HALT

CMD_DOFILE: ; Create File
    ; TODO: check for avail. space for new file
    ; TODO: catch filename from second parameter
    ; TODO: save to filename-page for later index-ability
    ; TODO: return status:
    ;       File Created
    ;       Missing File-Space. File not Created!
    RTS

CMD_TOUCH: ; Edit File
    ; TODO: catch filename from second parameter
    ; TODO: check if filename is on filename-page
    ; TODO: open the file, read only mode at first
    ; TODO: options:
    ;       :e  -> goes to editmode
    ;       :q  -> exit, don't safe
    ;       :qw -> exit, safe
    ; TODO: return status:
    ;       File Opened
    ;       File Not Found
    RTS

CMD_DEL: ; Delete(/ or directory once they are supported) File
    ; TODO: catch filename from second parameter
    ; TODO: check if filename is on filename-page
    ; TODO: delete filesize at fileaddress
    ; TODO: delete filename from filename-page
    ; TODO: return status:
    ;       File Deleted
    ;       File Not Found
    RTS

CMD_LS: ; List all files(/ directories once implemented)
    PUSH REA 
    PUSH REB
    PUSH REC
    PUSH REN 
    PUSH REP

    CALL CMD_LS_PrintHeader

    LDI REC, #0x004601  ; max filename address
    LDI REA, #0x004300  ; starting index
    LDI REN, #0x000100  ; increments
    LDI REB, #0x0       ; for empty check

    LDI REX, Characters._1
    LDI REY, #0x1
    
    CMD_LS_Loop:
    LDI REP, [REA]      ; load size for filename string
    CMP REP, REB        ; check if size is 0
    CALL_NEQ CMD_LS_PrintPos

    ADD REX, REY        ; increment index
    ADD REA, REN        ; increment to next address
    CMP REA, REC        ; compare for max address
    JP_LT CMD_LS_Loop  ; loop when not equal

    LDI REA, Characters.NewLine
    CALL TTYDriver.WriteCharacter

    POP REP
    POP REN
    POP REC
    POP REB
    POP REA 
    RTS

    CMD_LS_PrintHeader:
        PUSH REA
        LDI REA, Characters.F
        CALL TTYDriver.WriteCharacter

        LDI REA, Characters.i
        CALL TTYDriver.WriteCharacter

        LDI REA, Characters.l
        CALL TTYDriver.WriteCharacter

        LDI REA, Characters.e
        CALL TTYDriver.WriteCharacter

        LDI REA, Characters.s
        CALL TTYDriver.WriteCharacter

        LDI REA, Characters.Colon
        CALL TTYDriver.WriteCharacter

        LDI REA, Characters.NewLine
        CALL TTYDriver.WriteCharacter

        POP REA
        RTS

    CMD_LS_PrintPos:
        PUSH REA
        
        MOV REA, REX
        CALL TTYDriver.WriteCharacter

        LDI REA, Characters.Colon 
        CALL TTYDriver.WriteCharacter

        LDI REA, Characters.Space 
        CALL TTYDriver.WriteCharacter

        POP REA

        CALL String.PrintString

        PUSH REA

        LDI REA, Characters.NewLine
        CALL TTYDriver.WriteCharacter

        POP REA
        
        RTS

