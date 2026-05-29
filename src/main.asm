!IMPORT "Drivers/KeyboardDriver.asm" AS KeyboardDriver
!IMPORT "Drivers/TTYDriver.asm" AS TTYDriver
!IMPORT "Shell/shell.asm" AS Shell
!IMPORT "Shell/shell_util.asm" AS ShellUtil
!IMPORT "Shell/fs.asm" AS Fs
!IMPORT "Shell/commands/ls.asm" AS LsCmd
!IMPORT "Shell/commands/touch.asm" AS TouchCmd
!IMPORT "Shell/commands/del.asm" AS DelCmd
!IMPORT "Shell/commands/cat.asm" AS CatCmd
!IMPORT "Shell/commands/write.asm" AS WriteCmd
!IMPORT "Shell/commands/dofile.asm" AS DofileCmd
!IMPORT "Shell/commands/blocks.asm" AS BlocksCmd
!IMPORT "Shell/commands/run.asm" AS RunCmd
!IMPORT "Shell/os_bridge.asm" AS OsBridge
!IMPORT "Drivers/ScreenDriver.asm" AS ScreenDriver
!IMPORT "Drivers/NewScreenDriver.asm" AS NewScreenDriver
!IMPORT "Utils/stdio.asm"
!IMPORT "Utils/malloc.asm"
!IMPORT "syscall_table.asm"

!DECLARE KeyboardDevice = 0x01

.Kernel

; Initialize stack pointer
SET_SP $Stack.Start

; Initialize interrupt vector
SET_IVR $InterruptVector.Start

CALL fs_init

; ensure pointer is initialized as 0
LDI REA, #0
LDI REB, $ProcStackTop.Start
STR [REB], REA

; Bring up the loader: set the bump pointer, then register every built-in
; command as a runtime-generated program. From this point on the registry is
; the single source of truth for command dispatch.
CALL loaderInit
CALL registerBuiltins

; default foreground process (shell)
LDI REA, #0             ; shell has no main routine
LDI REB, Shell.onKey
CALL PushProc

CALL Shell.shellInitialize
CALL ScreenDriver.DrawCenterRedLine

KernelDispatch:
    LDI REA, [$ProcStackTop.Start]
    LDI REB, $ProcStack.Start
    
    ADD REA, REB ; absolute addr of mainLoop slot

    ; if mainLoop is null, the process is event-driven — just spin and let the ISR drive it
    LDI REC, [REA]
    LDI REB, #0
    CMP REC, REB
    JP_EQ KernelDispatch

    CALL REC         ; REC already holds the function pointer from LDI above
    JP KernelDispatch

@REA main routine
@REB on-key ISR
PushProc:
    PUSH RET
    PUSH REX
    PUSH REY
    PUSH REZ

    LDI RET, #1
    LDI REX, $ProcStack.Start
    LDI REY, $ProcStackTop.Start
    LDI REZ, [REY] ; get value of current proc-stack pointer

    ADD REZ, REX ; apply pointer onto the stack to get current address

    ; saving on-key routine to stack
    ADD REZ, RET
    STR [REZ], REB

    ; saving main routine to stack
    ADD REZ, RET
    STR [REZ], REA

    SUB REZ, REX    ; remove the offset to get pure SP value again
    STR [REY], REZ  ; save new SP value

    POP REZ
    POP REY
    POP REX
    POP RET
    RTS

PopProc:
    PUSH RET
    PUSH REY
    PUSH REZ

    LDI RET, #2
    LDI REY, $ProcStackTop.Start
    LDI REZ, [REY]  ; get value of current proc-stack pointer
    SUB REZ, RET    ; remove top two entries
    STR [REY], REZ  ; save new SP value

    POP REZ
    POP REY
    POP RET
    RTS

.InterruptVector
PUSH REA
PUSH REB
PUSH REC

GET_INT_ID REA

; Check if the interrupt is from the keyboard
LDI REB, KeyboardDevice
CMP REA, REB
JP_EQ HandleKeyboardInterrupt
JP InterruptDone

HandleKeyboardInterrupt:
    PUSH REB
    PUSH REZ

    LDI REA, [$ProcStackTop.Start]
    LDI REB, $ProcStack.Start

    ADD REA, REB     ; absolute addr of on-key slot + 1
    SUB REA, #1      ; back off to the on-key slot
    
    POP REZ
    POP REB

    CALL [REA]         ; call the on-key routine
    JP InterruptDone

InterruptDone:
    POP REC
    POP REB
    POP REA
    RTI

; ---------------------------------------------------------------------------
; User-program ABI (v1)
; ---------------------------------------------------------------------------
; Every loadable program begins with a 3-word header:
;   [0] magic     = 0x444FF1   ; sanity check before the loader jumps in
;   [1] version   = 1          ; ABI version (so we can evolve without breakage)
;   [2] entry_off = N          ; offset of the entry function within the body
;
; The loader copies the body (start+3 .. end) into .UserCode, then CALLs
; (body_base + entry_off) with argc/argv on the stack (C calling convention).
;
; On entry to a program: [FP+3] = argc, [FP+4] = argv (after PUSH REX; GET_SP REX).
; On exit: RTS, exit code in REA (0 = success).
;
; Two ways programs end up registered:
;
; 1. Static blob (e.g. `hello`): write Start/End labels in this segment and
;    call `register_program("name", &Start, &End)` at boot.
;
; 2. Runtime-generated wrapper (e.g. `ls`, `cls`, `halt`): just call
;    `register_builtin("name", kernel_fn)` at boot. The loader copies
;    `BuiltinWrapperTemplate` into the arena and patches the kernel function
;    address into it. No per-command asm needed.
; ---------------------------------------------------------------------------
.UserPrograms

; --- Dynamic program registry (32 slots × 3 words, all zero at boot) -------
; `register_program` / `register_builtin` append entries here; `run` walks the
; table at every dispatch. A null name marks the end.
ProgramRegistry:
    DW #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
    DW #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
    DW #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
    DW #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
    DW #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
    DW #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0, #0
ProgramRegistryEnd:

; --- Builtin wrapper template ----------------------------------------------
; Copied by `register_builtin` per command; the immediate word at
; WrapperPatchSlot gets overwritten with the kernel function's address.
;
; The template's role is just "read argc/argv from my stack, push them as
; args, CALL the patched-in kernel function." Since C calling convention
; pushes args right-to-left, we push argv first then argc.
BuiltinWrapperTemplate:
    DW #0x444FF1, #1, #0           ; header (entry_off = 0; body starts here)
    PUSH REX
    GET_SP REX

    MOV REY, REX
    ADD REY, #4
    LDI REB, [REY]                 ; argv at [FP+4]
    PUSH REB

    MOV REY, REX
    ADD REY, #3
    LDI REB, [REY]                 ; argc at [FP+3]
    PUSH REB

    ; Manually-emitted `LDI REA, #imm` so WrapperPatchSlot points at the
    ; immediate (the patch target). 0x000003 = LDI immediate, dest = REA.
    DW #0x000003
WrapperPatchSlot:
    DW #0xDEAD                     ; <-- register_builtin replaces this

    CALL REA
    POP REC                        ; discard argc
    POP REC                        ; discard argv
    POP REX
    RTS
BuiltinWrapperEnd:

; --- Static program blobs --------------------------------------------------
; Programs that don't fit the trampoline shape (e.g. they use syscalls
; directly rather than calling a kernel function) live here verbatim.

; hello: writes "Hi!\n" via SYS_ttyWriteChar. Demonstrates the loader path
; with a real syscall-using program (not a trampoline).
HelloProgramStart:
    DW #0x444FF1, #1, #0           ; magic, version, entry_off
    LDI REA, #0x48                  ; 'H'
    PUSH REA
    LDI REA, [SYS_ttyWriteChar]
    CALL REA
    POP REC

    LDI REA, #0x69                  ; 'i'
    PUSH REA
    LDI REA, [SYS_ttyWriteChar]
    CALL REA
    POP REC

    LDI REA, #0x21                  ; '!'
    PUSH REA
    LDI REA, [SYS_ttyWriteChar]
    CALL REA
    POP REC

    LDI REA, #0xA                   ; '\n'
    PUSH REA
    LDI REA, [SYS_ttyWriteChar]
    CALL REA
    POP REC

    RTS
HelloProgramEnd:

; --- Arena base ------------------------------------------------------------
; `loaderInit` sets the bump pointer to this address. From here onward the
; loader stores wrapper copies + name strings as it registers builtins.
ArenaBase:

