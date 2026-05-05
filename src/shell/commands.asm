!IMPORT "../drivers/TTYDriver.asm" AS TTYDriver
.Commands

CMD_CLS:
    CALL TTYDriver.ClearScreen
    RTS

CMD_HALT:
    HALT

CMD_CRF: ; Create File
    ; TODO: check for avail. space for new file
    ; TODO: catch filename from second parameter
    ; TODO: save to filename-page for later index-ability
    ; TODO: return status:
    ;       File Created
    ;       Missing File-Space. File not Created!
    RTS

CMD_EDF: ; Edit File
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

CMD_LSF: ; List all file-names
    ; TODO: load all names from filename-page
    ; TODO: display filename-page entries
    RTS

