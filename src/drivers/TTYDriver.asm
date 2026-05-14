!DECLARE ClearScreenMode = 0x900001
!DECLARE WriteCharacterMode = 0x900002

.TTYDriver

@REA Character to write to terminal
WriteCharacter:
    PUSH REZ

    LDI REZ, WriteCharacterMode  ; load memory addresses into registers first. STR [#0x100002], <VALUE> does not currently work for some reason.
    STR REZ, REA        ; send "Write Character" signal to TTY-Terminal

    POP REZ
    RTS

ClearScreen:
    PUSH REZ

    LDI REZ, ClearScreenMode
    STR REZ, REZ

    POP REZ
    RTS
