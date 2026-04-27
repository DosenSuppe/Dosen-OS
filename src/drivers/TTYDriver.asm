!DECLARE ClearScreenMode = 0x100001
!DECLARE WriteCharacterMode = 0x100002

.TTYDriver

@REA Character to write to terminal
WriteCharacter:
    PUSH REZ

    LDI REZ, #0x100002  ; load memory addresses into registers first. STR [#0x100002], <VALUE> does not currently work for some reason.
    STR REZ, REA        ; send "Write Character" signal to TTY-Terminal
    
    POP REZ
    RTS
