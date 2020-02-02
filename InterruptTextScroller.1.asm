; 10 SYS (2064)
*=$0801

    BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $30, $36, $34, $29, $00, $00, $00

*=$0810

incasm "VIC II Constants.asm"

; Initialisation Code $2000 - $206B
    ;lda #$00
    ;sta VICII_EXTCOL
    ;sta VICII_BGCOL0
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
    cli
    rts

EXTCOL_BKUP
    brk

BGCOL_BKUP
    brk

SCROLX_BKUP
    brk

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
    jmp $ea31