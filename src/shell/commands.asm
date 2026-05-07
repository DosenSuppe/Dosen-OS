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

    LDI REA, Characters._1
    CALL TTYDriver.WriteCharacter

    LDI REA, Characters.Colon
    CALL TTYDriver.WriteCharacter

    LDI REA, #0x004300
    CALL String.PrintString

    LDI REA, Characters.NewLine
    CALL TTYDriver.WriteCharacter

    POP REA 
    ; TODO: load all names from filename-page
    ; TODO: display filename-page entries
    RTS

