ifdef TGT_C64
; 10 SYS (2064)
*=$0801

    BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32, $30, $36, $34, $29, $00, $00, $00

*=$0810
Endif

ifdef TGT_VIC20
; 10 SYS (4112)

*=$1001

    BYTE    $0E, $10, $0A, $00, $9E, $20, $28,  $34, $31, $31, $32, $29, $00, $00, $00

*=$1010
endif
    jmp StartScroller

ifdef TGT_C64
ChrArea     = $3200     ; User Definded Character Area
ChrRom      = $D000     ; ChrSet Rom Area
ScreenStart = $0400     ; Screen
LineSize    = 40
endif

ifdef TGT_VIC20
ChrArea     = $1A00     ; User Definded Character Area
ChrRom      = $8000     ; ChrSet Rom Area
ScreenStart = $1E00     ; Screen
LineSize    = 22
endif

; 40 character mapping table
ChrAreaLo
    BYTE $00,$08,$10,$18,$20,$28,$30,$38,$40,$48
    BYTE $50,$58,$60,$68,$70,$78,$80,$88,$90,$98
    BYTE $A0,$A8,$B0,$B8,$C0,$C8,$D0,$D8,$E0,$E8,$F0,$F8
    BYTE $00,$08,$10,$18,$20,$28,$30,$38,$40,$48

ChrAreaHi
    BYTE >ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea
    BYTE >ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea
    BYTE >ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea,>ChrArea, >ChrArea,>ChrArea
    BYTE >ChrArea+1,>ChrArea+1,>ChrArea+1,>ChrArea+1,>ChrArea+1,>ChrArea+1,>ChrArea+1,>ChrArea+1,>ChrArea+1,>ChrArea+1

; Text to Scroll
TEXTToScroll
    TEXT 'this was a film from oldskoolcoder (c) jun 2019. '
    TEXT 'github : https://github.com/oldskoolcoder/ '
    TEXT 'twitter : @oldskoolcoder email : oldskoolcoder@outlook.com '
    TEXT 'please support me on patreon @ https://www.patreon.com/'
    TEXT 'oldskoolcoder thank you ;-)'
    BYTE 255

; Main Routine
StartScroller
    jsr InitCharacterArea
    jsr InitScreen
    jsr TextScroller
    rts

; Initialise the User Defined Character Area
InitCharacterArea
    ldy #0
    lda #0
@Inner
    sta ChrArea,y       ; Set First Bank
    sta ChrArea+$100,y  ; Set Second Bank
    iny
    cpy #0
    bne @Inner
    rts

; Initialise the Screen
InitScreen
    lda #$93    ; Clear Screen
    jsr $FFD2   ; Output Character

    ldy #0
@Looper
    tya
    ora #64     ; Add 64 to Character
    sta ScreenStart,y
    iny
    cpy #LineSize     ; xx Characters in 1 Line
    bne @looper
 
ifdef TGT_C64
    lda #28     ; Set VIC Chip To Right Charater Mapping Memory    
    sta $d018   ;
endif
ifdef TGT_VIC20
    lda #$FE
    sta $9005   ; Set VIC Chip
    lda #0
    sta $900F   ; Set Background to black
endif
    rts

; Initialise The Text Scroller Pointers
InitTextScroller
    ldy #<TEXTToScroll
    sty TextLoader + 1
    ldy #>TEXTToScroll
    sty TextLoader + 2
    rts

; Grab the Character Definition From CHR Rom
GrabCharacter
    ; Register Y has Character Code to Copy
    lda #0
    sta CharacterLoc + 1
    sta CharacterLoc + 2
    tya
    asl                     ; x2
    rol CharacterLoc + 2
    asl                     ; x4
    rol CharacterLoc + 2
    asl                     ; x8
    rol CharacterLoc + 2
    sta CharacterLoc + 1
    clc
    lda #>ChrRom
    adc CharacterLoc + 2
    sta CharacterLoc + 2

ifdef TGT_C64
    sei                     ; disable interrupts while we copy
    lda #$33                ; make the CPU see the Character Generator ROM...
    sta $01                 ; ...at $D000 by storing %00110011 into location $01
endif

    ldy #$00                
GCLoop
CharacterLoc
    lda ChrRom,y
ifdef TGT_C64             
    sta ChrArea + $0140,y             ; write to the RAM Charcter 40
endif

ifdef TGT_VIC20
    sta ChrArea + $B0,y
endif
    iny
    cpy #8
    bne GCLoop              ; ..for low byte $00 to $FF
    lda #$37                ; switch in I/O mapped registers again...
ifdef TGT_C64
    sta $01                 ; ... with %00110111 so CPU can see them
    cli                     ; turn off interrupt disable flag
endif
    rts

; Get the Next Charater in the Message
GetCharacterInMessage
TextLoader
    lda TEXTToScroll
    pha
    cmp #255
    beq @EndOfText
    clc
    lda TextLoader + 1
    adc #1
    sta TextLoader + 1
    lda TextLoader + 2
    adc #0
    sta TextLoader + 2
@EndOfText
    pla
    rts

; The Main Text Smooth Scrolling Routine
TextScroller
    jsr GetCharacterInMessage
    cmp #255
    bne @StillGoing
    rts

@StillGoing
    tay
    jsr GrabCharacter
    lda #0

@DoNextPixel
    pha
    jsr ScrollOverOnePixel
@loop
ifdef TGT_C64
    lda #200                 ; Scanline -> A
    cmp $D012              ; Compare A to current raster line
    bne @loop               ; Loop if raster line not reached 255
endif

ifdef TGT_VIC20
    lda #100                 ; Scanline/2 -> A
    cmp $9004              ; Compare A to current raster line
    bne @loop               ; Loop if raster line not reached 255

endif
    pla
    clc
    adc #1
    cmp #8
    bne @DoNextPixel
    jmp TextScroller

ScrollOverOnePixel
    ldy #LineSize
    lda ChrAreaLo,y
    sta ChrByteLoc + 1
    lda ChrAreaHi,y
    sta ChrByteLoc + 2
    lda #0
    clc
RotateTheNextCharacter
    ldx #0

Rotatethe8Bytes
    pha
    rol
ChrByteLoc
    rol ChrByteLoc,x
    pla
    rol
    inx
    cpx #8
    bne Rotatethe8Bytes

    ; Accumultor now contains the vertical pixel pattern
    ; now to apply to previous 8 bytes
    pha
    sec
    lda ChrByteLoc + 1
    sbc #8
    sta ChrByteLoc + 1
    lda ChrByteLoc + 2
    sbc #0
    sta ChrByteLoc + 2
    pla
    dey
    cpy #255
    bne RotateTheNextCharacter
    rts

