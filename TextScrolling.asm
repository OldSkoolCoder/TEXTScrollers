; 10 SYS (2064)

*=$0801

    BYTE    $0E, $08, $0A, $00, $9E, $20, $28,  $32 
    BYTE    $30, $36, $34, $29, $00, $00, $00

*=$0810
    jmp StartScrolling

TEXTToScroll
    TEXT 'this was a film from oldskoolcoder (c) jun 2019. '
    TEXT 'github : https://github.com/oldskoolcoder/ '
    TEXT 'twitter : @oldskoolcoder email : oldskoolcoder@outlook.com '
    TEXT 'please support me on patreon @ https://www.patreon.com/'
    TEXT 'oldskoolcoder thank you ;-)'
    BYTE 255

StartScrolling
    ldy #<TEXTToScroll
    sty TextLoader + 1
    ldy #>TEXTToScroll
    sty TextLoader + 2
    ldy #0

    lda #147
    jsr $ffd2

TextLooper
    ldx #0

TextMover
    lda 1025,x
    sta 1024,x
    inx
    cpx #39
    bne TextMover

TextLoader
    lda TEXTToScroll
    cmp #255
    beq EndOfText
    sta 1063
    clc
    lda TextLoader + 1
    adc #1
    sta TextLoader + 1
    lda TextLoader + 2
    adc #0
    sta TextLoader + 2

    ldy #0
YLoop
    ldx #192
XLoop
    inx
    bne XLoop 
    iny
    bne YLoop

    jmp TextLooper

EndOfText

    ;jmp StartScrolling

    rts