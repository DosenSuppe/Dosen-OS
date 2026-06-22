; Syscall table — fixed-address jump pointers loaded user programs use to
; invoke kernel services. A program calls a syscall as:
;
;   LDI REA, [SYS_ttyWriteChar]   ; load function address from the table
;   CALL REA                      ; jump to it
;
; The .SyscallTable segment (see mem.cfg) sits at 0x00010000. Each DW below is
; one 32-bit slot; the linker fills the word with the absolute byte address of
; the named kernel symbol. The machine is byte-addressed, so consecutive slots
; are 4 bytes apart — the SYS_* constants step by 4.
;
; ORDER MATTERS: the SYS_* constants are slot addresses, so adding a new entry
; means appending both a !DECLARE and a DW. Don't reorder mid-list. Anything
; already compiled against the old offsets would break.

!DECLARE SYS_prints           = 0x00010000
!DECLARE SYS_ttyWriteChar     = 0x00010004
!DECLARE SYS_ttyClearScreen   = 0x00010008
!DECLARE SYS_cpuHalt          = 0x0001000C
!DECLARE SYS_printi           = 0x00010010
!DECLARE SYS_printc           = 0x00010014
!DECLARE SYS_ttyReadChar      = 0x00010018
!DECLARE SYS_fs_find          = 0x0001001C
!DECLARE SYS_fs_data_ptr      = 0x00010020
!DECLARE SYS_fs_create        = 0x00010024
!DECLARE SYS_fs_delete        = 0x00010028
!DECLARE SYS_fs_file_count    = 0x0001002C
!DECLARE SYS_fs_mark_dirty    = 0x00010030

.SyscallTable

DW prints
DW ttyWriteChar
DW ttyClearScreen
DW cpuHalt
DW printi
DW printc
DW ttyReadChar
DW fs_find
DW fs_data_ptr
DW fs_create
DW fs_delete
DW fs_file_count
DW fs_mark_dirty
