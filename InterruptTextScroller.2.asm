; 10 SYS (2064)
*=$0801

    BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $30, $36, $34, $29, $00, $00, $00

*=$0810

incasm "VIC II Constants.asm"

SCREENROW   = 1824 ; (20 rows down)

    ;lda #$00
    ;sta VICII_EXTCOL
    ;sta VICII_BGCOL0
    lda #147
    jsr $ffd2
    sei
    lda #VICII_SCROLY_FineScroll_RasterNoCompareMask
    sta $DC0D
    and VICII_SCROLY
    sta VICII_SCROLY
    lda #$3A
    sta VICII_RASTER
    lda #<INTERRUPT
    sta $0314
    lda #>INTERRUPT
    sta $0315
    lda #VICII_IRQMASK_ENABLE_RASTER_COMPARE
    sta VICII_IRQMASK
    lda VICII_EXTCOL
    sta EXTCOL_BKUP
    lda VICII_BGCOL0
    sta BGCOL_BKUP
    lda VICII_SCROLX
    sta SCROLX_BKUP
    lda #<TEXTToScroll
    sta TextLoader + 1
    lda #>TEXTToScroll
    sta TextLoader + 2
    lda #0
    sta TEXT_FRAME_COUNTER
    cli
    rts

EXTCOL_BKUP
    brk

BGCOL_BKUP
    brk

SCROLX_BKUP
    brk

TEXT_FRAME_COUNTER
    brk

TEXT_LOCATION_CHAR
    WORD 0


TEXTToScroll
    TEXT 'this was a film from oldskoolcoder (c) jun 2019. '
    TEXT 'github : https://github.com/oldskoolcoder/ '
    TEXT 'twitter : @oldskoolcoder email : oldskoolcoder@outlook.com '
    TEXT 'please support me on patreon @ https://www.patreon.com/'
    TEXT 'oldskoolcoder thank you ;-)'
    BYTE 255

INTERRUPT
    lda VICII_EXTCOL
    sta EXTCOL_BKUP
    ;lda #$CE
    ;sta VICII_RASTER
    
    lda #$d2
@Loop
    cmp VICII_RASTER
    bne @Loop

    lda $0400
    sta VICII_EXTCOL
    lda #$04
    sta VICII_SCROLX

    lda #$DB
@Loop1
    cmp VICII_RASTER
    bne @Loop1

    lda EXTCOL_BKUP
    sta VICII_EXTCOL
    lda #$c8
    sta VICII_SCROLX
    asl VICII_VICIRQ

    inc TEXT_FRAME_COUNTER
    lda TEXT_FRAME_COUNTER
    and #7
    sta TEXT_FRAME_COUNTER
    bne @BYPASSSCROLLER
    jsr TextLooper

@BYPASSSCROLLER
    jmp $ea31



TextLooper
    ldx #0

TextMover
    lda SCREENROW+1,x
    sta SCREENROW,x
    inx
    cpx #39
    bne TextMover

TextLoader
    lda TEXTToScroll
    cmp #255
    beq EndOfText
    sta SCREENROW+39
    clc
    lda TextLoader + 1
    adc #1
    sta TextLoader + 1
    lda TextLoader + 2
    adc #0
    sta TextLoader + 2
    rts

EndOfText
    lda #<TEXTToScroll
    sta TextLoader + 1
    lda #>TEXTToScroll
    sta TextLoader + 2
    rts