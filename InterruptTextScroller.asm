; 10 SYS (2064)
*=$0801

    BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $30, $36, $34, $29, $00, $00, $00

*=$0810

incasm "VIC II Constants.asm"

; Initialisation Code $2000 - $206B
    lda #$00
    sta VICII_EXTCOL
    sta VICII_BGCOL0
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
    sta $1F00
    lda VICII_BGCOL0
    sta $1F01
    lda VICII_SCROLX
    sta $1F02
    lda #$07
    sta $20f0
    lda #$00
    sta $1f03
    sta $20f2
    lda #$1a
    sta $1f04
    sta $20f3

    ldx #$00
@ScreenLoad
    lda VideoRamColour,x
    sta $0400,x
    inx
    cpx #$40
    bne @ScreenLoad
    lda #0
    sta IRQCounter
    ldx #$00
@ColourLoad
    lda #$A0
    sta $0720,x
    lda $1f01
    sta $db20,x
    inx
    cpx #$78
    bne @ColourLoad
    ldx #$00
    lda #$A0
@BlankLine
    sta $0748,x
    inx
    cpx #$28
    bne @BlankLine
    cli
    rts

