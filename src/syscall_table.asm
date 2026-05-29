; Syscall table — fixed-address jump pointers loaded user programs use to
; invoke kernel services. A program calls a syscall as:
;
;   LDI REA, [SYS_ttyWriteChar]   ; load function address from the table
;   CALL REA                      ; jump to it
;
; The .SyscallTable segment (see mem.cfg) sits at 0x000F00. Each DW below is
; one slot; the linker fills the word with the absolute address of the named
; kernel symbol. The SYS_* DECLAREs map names to slot addresses so program
; code references symbols, not magic numbers.
;
; ORDER MATTERS: the SYS_* constants are slot addresses, so adding a new entry
; means appending both a !DECLARE and a DW. Don't reorder mid-list. Anything
; already compiled against the old offsets would break.

!DECLARE SYS_prints           = 0x000F00
!DECLARE SYS_ttyWriteChar     = 0x000F01
!DECLARE SYS_ttyClearScreen   = 0x000F02
!DECLARE SYS_cpuHalt          = 0x000F03
!DECLARE SYS_printi           = 0x000F04
!DECLARE SYS_printc           = 0x000F05
!DECLARE SYS_ttyReadChar      = 0x000F06
!DECLARE SYS_fs_find          = 0x000F07
!DECLARE SYS_fs_data_ptr      = 0x000F08
!DECLARE SYS_fs_create        = 0x000F09
!DECLARE SYS_fs_delete        = 0x000F0A
!DECLARE SYS_fs_file_count    = 0x000F0B
!DECLARE SYS_fs_mark_dirty    = 0x000F0C

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
