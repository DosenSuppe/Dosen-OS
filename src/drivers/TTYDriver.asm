; TTY is MMIO slot 1 at 0xC8000000 (byte-addressed). Command ports:
;   clear  -> local byte 4  (0xC8000004)
;   write  -> local byte 8  (0xC8000008), low 8 bits = character
!DECLARE ClearScreenMode = 0xC8000004
!DECLARE WriteCharacterMode = 0xC8000008

.TTYDriver

@REA Character to write to terminal
WriteCharacter:
    STR [WriteCharacterMode], REA        ; send "Write Character" signal to TTY-Terminal
    RTS

ClearScreen:
    STR [ClearScreenMode], REA   ; value is ignored; any write to +4 clears
    RTS
