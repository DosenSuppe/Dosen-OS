.ScreenDriver

!DECLARE FB_BASE   = 0x300000
!DECLARE FB_WIDTH  = 320        ; pixels per row
!DECLARE RED       = 0xFF0000

; --- Pre-computed address constants ---
; Line is centered on y=100, height 3 → y in {99, 100, 101}.
; Those three rows are contiguous in linear memory, so we paint
; them all in a single tight loop.
;
;   start = FB_BASE + 99 * FB_WIDTH
;         = 0x300000 + 99 * 320
;         = 0x300000 + 0x7BC0
;         = 0x307BC0
;
;   count = 3 * FB_WIDTH = 960 = 0x3C0
!DECLARE LINE_START = 0x307BC0
!DECLARE LINE_PIXELS = 0x0003C0


; DrawCenterRedLine
;   Paints a 320×3 red bar across the vertical middle of the framebuffer.
;   Clobbers no caller-visible state — all working registers are saved.
;   Inner loop is 4 instructions per pixel (STR / ADD / SUB / JP).
DrawCenterRedLine:
    PUSH REA
    PUSH REB
    PUSH REC
    PUSH REZ

    LDI REA, LINE_START         ; running framebuffer pointer
    LDI REB, LINE_PIXELS        ; pixels remaining
    LDI REC, #1                 ; step / decrement
    LDI REZ, RED                ; color we'll splat

    DrawLine_Loop:
        STR REA, REZ            ; framebuffer[ptr] = RED
        ADD REA, REC            ; ptr++
        SUB REB, REC            ; count--   (sets Z when count hits 0)
        JPZ DrawLine_Done
        JP  DrawLine_Loop

    DrawLine_Done:

    POP REZ
    POP REC
    POP REB
    POP REA
    RTS