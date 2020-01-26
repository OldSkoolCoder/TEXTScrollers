VICII   = $D000 ; Start Address Of The VIC II Chip
VICII_SP0X    = $D000 ; Sprite 0 Horizontal Position
VICII_SP0Y    = $D001 ; Sprite 0 Vertical Position
VICII_SP1X    = $D002 ; Sprite 1 Horizontal Position
VICII_SP1Y    = $D003 ; Sprite 1 Vertical Position
VICII_SP2X    = $D004 ; Sprite 2 Horizontal Position
VICII_SP2Y    = $D005 ; Sprite 2 Vertical Position
VICII_SP3X    = $D006 ; Sprite 3 Horizontal Position
VICII_SP3Y    = $D007 ; Sprite 3 Vertical Position
VICII_SP4X    = $D008 ; Sprite 4 Horizontal Position
VICII_SP4Y    = $D009 ; Sprite 4 Vertical Position
VICII_SP5X    = $D00A ; Sprite 5 Horizontal Position
VICII_SP5Y    = $D00B ; Sprite 5 Vertical Position
VICII_SP6X    = $D00C ; Sprite 6 Horizontal Position
VICII_SP6Y    = $D00D ; Sprite 6 Vertical Position
VICII_SP7X    = $D00E ; Sprite 7 Horizontal Position
VICII_SP7Y    = $D00F ; Sprite 7 Vertical Position
VICII_MSIGX   = $D010   ; Most Significant Bits of Sprites 0-7 Horizontal Position
                        ; Bit 0:  Most significant bit of Sprite 0 horizontal position
                        ; Bit 1:  Most significant bit of Sprite 1 horizontal position
                        ; Bit 2:  Most significant bit of Sprite 2 horizontal position
                        ; Bit 3:  Most significant bit of Sprite 3 horizontal position
                        ; Bit 4:  Most significant bit of Sprite 4 horizontal position
                        ; Bit 5:  Most significant bit of Sprite 5 horizontal position
                        ; Bit 6:  Most significant bit of Sprite 6 horizontal position
                        ; Bit 7:  Most significant bit of Sprite 7 horizontal position
VICII_MSGX_SP0Y_On = %00000001
VICII_MSGX_SP1Y_On = %00000010
VICII_MSGX_SP2Y_On = %00000100
VICII_MSGX_SP3Y_On = %00001000
VICII_MSGX_SP4Y_On = %00010000
VICII_MSGX_SP5Y_On = %00100000
VICII_MSGX_SP6Y_On = %01000000
VICII_MSGX_SP7Y_On = %10000000

; Setting one of these bites to 1 adds 256 to the horizontal position of
; the corresponding sprite.  Resetting one of these bits to 0 restricts
; the horizontal position of the corresponding sprite to a value of 255
; or less

VICII_SCROLY  = $D011   ; Vertical Fine Scrolling and Control Register
                        ; Bits 0-2:  Fine scroll display vertically by X scan lines (0-7)
                        ; Bit 3:  Select a 24-row or 25-row text display (1=25 rows, 0=24 rows)
                        ; Bit 4:  Blank the entire screen to the same color as the background
                        ;   (0=blank)
                        ; Bit 5:  Enable bitmap graphics mode (1=enable)
                        ; Bit 6:  Enable extended color text mode (1=enable)
                        ; Bit 7:  High bit (Bit 8) of raster compare register at 53266 ($D012)

VICII_SCROLY_FineScroll_Mask = %00000111
VICII_SCROLY_FineScroll_25Rw = %00001000
VICII_SCROLY_FineScroll_24Rw = 255 - VICII_SCROLY_FineScroll_25Rw   ; %11110111
VICII_SCROLY_FineScroll_RestoreScreen = %00010000
VICII_SCROLY_FineScroll_BlankScreen = 255 - VICII_SCROLY_FineScroll_RestoreScreen ; %11101111
VICII_SCROLY_FineScroll_GraphicsMode = %00100000
VICII_SCROLY_FineScroll_NormalMode = 255 - VICII_SCROLY_FineScroll_GraphicsMode ; %11011111
VICII_SCROLY_FineScroll_ExtendedColourMode = %01000000
VICII_SCROLY_FineScroll_NormalColourMode = 255 - VICII_SCROLY_FineScroll_ExtendedColourMode ; %10111111
VICII_SCROLY_FineScroll_RasterCompareMask = %10000000
VICII_SCROLY_FineScroll_RasterNoCompareMask = 255 - VICII_SCROLY_FineScroll_RasterCompareMask ; %01111111

; This is one of the two important multifunction control registers on
; the VIC-II chip.  Its default value is 155, which sets the high bit of
; the raster compare to 1, selects a 25-row display, disables the
; blanking feature, and uses a vertical scrolling offset of three scan
; lines.

; Bits 0-2.  These bits control vertical fine scrolling of the screen
; display.  This feature allows you to move the entire text display
; smoothly up and down, enabling the display area to act as a window,
; scrolling over a larger text or character graphics display.

; Since each row of text is eight scan lines high, if you simply move
; each line of text up one row, the characters travel an appreciable
; distance each time they move, which gives the motion a jerky quality.
; This is called coarse scrolling, and you can see an example of it when
; LISTing a program that is too long to fit on the screen all at one
; time.

; By placing a number from 1 to 7 into these three bits, you can move
; the whole screen display down by from 1 to 7 dot spaces.  Stepping
; through the values 1 to 7 allows you to smoothly make the transition
; from having a character appear in one row on the screen to having it
; appear in the next row.  To demonstrate this, type in the following
; sample program, LIST it, and RUN.

; 10 FOR I= 1 TO 50:FOR J=0 TO 7
; 20 POKE 53265, (PEEK(53265)AND248) OR J:NEXTJ,I
; 30 FOR I= 1 TO 50:FOR J=7 TO 0 STEP-1
; 40 POKE 53265, (PEEK(53265)AND248) OR J:NEXTJ,I

; As you can see, after the display has moved seven dot positions up or
; down, it starts over at its original position.  In order to continue
; the scroll, you must do a coarse scroll every time the value of the
; scroll bits goes from 7 to 0, or from 0 to 7.  This is accomplished by
; moving the display data for each line by 40 bytes in either direction,
; overwriting the data for the last line, and introducing a line of data
; at the opposite end of screen memory to replace it.  Obviously, ony a
; machine language program can move all of these lines quickly enough to
; maintain the effect of smooth motion.  The following BASIC program,
; however, will give you an iea of what vertical fine scrolling is like:

; 10 POKE 53281,0:PRINTCHR$(5);CHR$(147)
; 20 FORI=1 TO 27:
; 30 PRINTTAB(15)CHR$(145)"            ":POKE 53265,PEEK(53265)AND248
; 40 WAIT53265,128:PRINTTAB(15)"I'M FALLING"
; 50 FOR J=1 TO 7
; 60 POKE53265,(PEEK(53265)AND248)+J
; 70 FORK=1TO50
; 80 NEXT K,J,I:RUN

; Bit 3.  This bit register allows you to select either the normal
; 25-line text display (by setting the bit to 1), or a shortened 24-row
; display (by resetting that bit to 0).  This shortened display is
; created by extending the border to overlap the top or bottom row.  The
; characters in these rows are still there; they are just covered up.

; The shortened display is designed to aid vertical fine scrolling.  It
; covers up the line into which new screen data is introduced, so that
; the viewer does not see the new data being moved into place.

; However, unlink the register at 53270 ($D016) which shortens the
; screen by one character space on either side to aid horizontal
; scrolling in either direction, this register can blank only one
; vertical line at a time.  In order to compensate, it blanks the top
; line when the three scroll bits in this register are set to 0, and
; shifts the blanking one scan line at a time as the value of thee bits
; increases.  Thus the bottom line is totally blanked when these bits
; are set to 7.

; Bit 4.  Bit 4 of this register controls the screen blanking feature.
; When this bit is set to 0, no data can be displayed on the screen.
; Instead, the whole screen will be filled with the color of the frame
; (which is controlled by th eBorder Color Register at 53280 ($D020)).

; Screen blanking is useful because of the way in which the VIC-II chip
; interacts with the 6510 microprocessor.  Since the VIC-II and the 6510
; both have to address the same memory, they must share the system data
; bus.  Sharing the data bus means that they must take turns whenever
; they want to address memory.

; The VIC-II chip was designed so that it fetches most of the data it
; needs during the part of the cycle in which the 6510 is not using the
; data bus.  But certain operations, such as reading the 40 screen codes
; needed for each line of text from video mmeory, or fetching sprite
; data, require that the VIC-II chip get data at a faster rate than is
; possible just by using the off half of the 6510 cycle.

; Thus, the VIC-II chip must delay the 6510 for a short amount of time
; while it is using the data bus to gather display information for text
; or bitmap graphics, and must delay it a little more if sprites are
; also enabled.  When you set the screen blanking bit to 0, these delays
; are eliminated, and the 6510 processor is allowed to run at its full
; speed.  This speeds up any processing task a little.

; To demonstrate this, run the following short program.  As you will
; see, leaving the screen on makes the processor run about 7 percent
; slower than when you turn it off.  If you perform the same timing test
; on the VIC-20, you will find that it runs at the same speed with its
; screen on as the 64 does with its screen off.  And the same test on a
; PET will run substantially slower.

; 10 PRINT CHR$(147);TAB(13);"TIMING TEST":PRINT:TI$="000000":GOTO 30
; 20 FOR I=1 TO 10000:NEXT I:RETURN
; 30 GOSUB 20:DISPLAY=TI
; 40 POKE 53265,11:TI$="000000"
; 50 GOSUB 20:NOSCREEN=TI:POKE 53265,27
; 60 PRINT "THE LOOP TOOK";DISPLAY;" JIFFIES"
; 70 PRINT "WITH NO SCREEN BLANKING":PRINT
; 80 PRINT "THE LOOP TOOK";NOSCREEN;" JIFFIES"
; 90 PRINT "WITH SCREEN BLANKING":PRINT
; 100 PRINT "SCREEN BLANKING MAKE THE PROCESSOR"
; 110 PRINT "GO";DISPLAY/NOSCREEN*100-100;"PERCENT FASTER"

; The above explanation accounts for the screen being turned off during
; tape read and write operations.  The timing of these operations is
; rather critical, and would be affected by even the relatively small
; delay caused by the video chip.  It also explains why the 64 has
; difficulty loading programs from an unmodified 1540 Disk Drive, since
; the 1540 was set up to transfer data from the VIC-20, which does not
; have to contend with these slight delays.

; If you turn off the 64 display with a POKE 53265,PEEEK(53265) AND 239,
; you will be able to load programs correctly from an old 1540 drive.
; The new 1541 drive transfers data at a slightly slower rate in the
; default setting, and can be set from software to transfer it at the
; higher rate for the VIC-20.

; Bit 5.  Setting Bit 5 of this register to 1 enables the bitmap
; graphics mode.  In this mode, the screen area is broken down into
; 64,000 separate dots of light, 320 dots across by 200 dots high.  Each
; dot corresponds to one bit of display memory.  If the bit is set to 1,
; the dot will be displayed in the foreground color.  If the bit is
; reset to 0, it will be displayed in the background color.  This allows
; the display of high-resolution graphics images for games, charts, and
; graphs, etc.

; Bitmapping is a common technique for implementing high-resolution
; graphics on a microcomputer.  There are some features of the Commodore
; system which are unusual, however.

; Most systems display screen memory sequentially; that is, the first
; byte controls the display of the first eight dots in the upper-left
; corner of the screen, the second byte controls the eight dots to the
; right of that, etc.  In the Commodore system, display memory is laid
; out more along the lines of how character graphics dot-data is
; arranged.

; The first byte controls the row of eight dots in the top-left corner
; of the screen, but the next byte controls the eight dots below that,
; and so on until the ninth byte.  The ninth byte controls the eight
; dots directly to the right of those controlled by the first byte of
; display memory.  It is exactly the same as if the screen were filled
; with 1000 programmable characters, with display memory taking the
; place of the character dot-data.

; The 64's bitmap graphics mode also resembles character graphics in
; that the foreground color of the dots is set by a color map (although
; it does not use the Color RAM for this purpose).  Four bits of each
; byte of this color memory control the foreground color of one of these
; eight-byte groups of display memory (which form an 8 by 8 grid of 64
; dots).  Unlike character graphics, however, the other four bits
; control the background color that will be seen in the eight-byte
; display group where a bit has a value of 0.

; Setting up a bitmap graphics screen is somewhat more complicated than
; just setting this register bit to 1.  You must first choose a location
; for the display memory area, and for the color memory area.  The
; display memory area will be 8192 bytes long (8000 of which are
; actually used for the display) and can occupy only the first or the
; second half of the 16K space which the VIC-II chip can address.

; Each byte of bitmap graphics color memory uses four bits for the
; background color as well as four bits for the foreground color.
; Therefore, the Color RAM nybbles at 55296 ($D800), which are wired for
; four bits only, cannot be used.  Another RAM location must therefore
; be found for color memory.

; This color memory area will take up 1K (1000 bytes of which are
; actually used to control the foreground and background colors of the
; dots), and must be in the opposite half of VIC-II memory as the
; display data.  Since bitmap graphics require so much memory for the
; display, you may want to select a different 16K bank for VIC-II memory
; (see the discussion of things to consider in selecting a VIC-II memory
; bank at location 56576 ($DD00)).

; To keep things simple, however, let's assume that you have selected to
; use the default bank of VIC-II memory, which is the first 16K.  You
; would have to select locations 8192-16383 ($2000-$3FFF) for screen
; memory, because the VIC-II chip sees an image of the character ROM in
; the first half of the 16K block (at locations 4096-8192
; ($1000-$1FFF)).  Color memory could be placed at the default location
; of text display memory, at 1024-2047 ($400-$7FF).  Placement of bitmap
; display and color memory is controlled by the VIC Memory Control
; Register at 53272 ($D018).

; When in bitmap mode, the lower four bits of this register, which
; normally control the base address of character dot-data, now control
; the location of the 8K bitmap.  Only Bit 3 is significant.  If it is
; set to 1, the graphics display memory will be in the second 8K of
; VIC-II memory (in this case, starting at 8192 ($2000)).  If that bit
; contains a 0, the first 8K will be used for the bitmap.  The upper
; four bits of this register, which normally control the location of the
; Video Display Matrix, are used in bitmap mode to establish the
; location of the color map within the VIC-II address space.  These four
; bits can hold a number from 0 to 15, which indicates on which 1K
; boundary the color map begins.  For example, if color memory began at
; 1024 (1K), the value of these four bits would be 0001.

; Once the bitmap mode has been selected, and the screen and color
; memory areas set up, you must establish a method for turning each
; individual dot on and off.  The conventional method for identifying
; each dot is to assign it to a horizontal (X) position coordinate and a
; vertical (Y) coordinate.

; Horizontal position values will range from 0 to 319, where dot 0 is at
; the extreme left-hand side of the screen, and dot 319 at the extreme
; right.  Vertical positions will range from 0 to 199, where dot 0 is on
; the top line, and dot 199 is on the bottom line.

; Because of the unusual layout of bitmap screen data on the 64, it is
; fairly easy to transfer text characters to a bitmap screen, but it is
; somewhat awkward finding the bit which affects the screen dot having a
; given X-Y coordinate.  First, you must find the byte BY in which the
; bit resides, and then you must POKE a vlue into that byte which turns
; the desired bit on or off.  Given that the horizontal position of the
; dot is stored in the variable X, its vertical position is in the
; variable Y, and the base address of the bitmap area is in the variable
; BASE, you can find the desired byte with the formula:

; BY=BASE+40*(Y AND 256)+(Y AND 7)+(X AND 504)

; To turn on the desired dot,

; POKE BY, PEEK(BY) OR (2^(NOTX AND 7)

; To turn the dot off,

; POKE BY, PEEK(BY) AND (255-2^(NOTX AND 7))

; The exponentation function takes a lot of time.  To speed things up,
; an array can be created, each of whose elements corresponds to a power
; of two.

; FOR I=0 TO 7:BIT(I)=2^1:NEXT

; After this is done, the expression 2^(I) can be replaced by BI(I).

; The following sample program illustrates the bit-graphics concepts
; explained above, and serves as a summary of that information.

; 10 FOR I=0 TO 7:BI(I)=2^I:NEXT: REM SET UP ARRAY OF POWERS OF 2 (BIT VALUE)
; 20 BASE=2*4096:POKE53272,PEEK(53272)OR8:REM PUT BIT MAP AT 8192
; 30 POKE53265,PEEK(53265)OR32:REM ENTER BIT MAP MODE
; 40 A$="":FOR I=1 TO 37:A$=A$+"C":NEXT:PRINT CHR$(19);
; 50 FOR I=1 TO 27:PRINTA$;:NEXT:POKE2023,PEEK(2022): REM SET COLOR MAP
; 60 A$="":FOR I=1 TO 27:A$=A$+"@":NEXT:FOR I=32 TO 63 STEP 2
; 70 POKE648,I:PRINT CHR$(19);A$;A$;A$;A$:NEXT:POKE648,4:REM CLEAR HI-RES SCREEN
; 80 FORY=0TO199STEP.5:REM FROM THE TOP OF THE SCREEN TO THE BOTTOM
; 90 X=INT(160+40*SIN(Y/10)): REM SINE WAVE SHAPE
; 100 BY=BASE+40*(Y AND 248)+(Y AND 7)+(X AND 504): REM FIND HI-RES BYTE
; 110 POKEBY,PEEK(BY)OR(BI(NOT X AND 7)):NEXT Y:REM POKE IN BIT VALUE
; 120 GOTO 120: REM LET IT STAY ON SCREEN

; As you can see, using BASIC to draw in bit-graphics mode is somewhat
; slow and tedious.  Machine language is much more suiable for
; bit-graphics plotting.  For a program that lets you replace some BASIC
; commands with high-res drawing commands, see the article "Hi-Res
; Graphics Made Simple," by Paul F. Schatz, in COMPUTE!'s First Book of
; Commodore 64 Sound and Graphics.

; There is a slightly lower resolution bitmap graphics mode available
; which offers up to four colors per 8 by 8 dot matrix.  To enable this
; mode, you must set the multicolor bit (Bit 4 of 53270 ($D016)) while
; in bitmap graphics mode.  For more information on this mode, see the
; entry for the multicolor enable bit.

; Bit 6.  This bit of this register enables extended background color
; mode.  This mode lets you select the background color of each text
; character, as well as its foreground color.  It is able to increase
; the number of background colors displayed, by reducing the number of
; characters that can be shown on the screen.

; Normally, 256 character shapes can be displayed on the screen.  You
; can use them either by using the PRINT statement or by POKEing a
; display code from 0 to 255 into screen memory.  If the POKEing method
; is used, you must also POKE a color code from 0 to 15 into color
; memory (for example, if you POKE 1024,1, and POKE 55296,1, a white A
; appears in the top-left corner of the screen).

; The background color of the screen is determined by Background Color
; Register 0, and you can change this color by POKEing a new value to
; that register, which is located at 53281 ($D021).  For example, POKE
; 53281,0 creates a black background.

; When extended background color mode is activated, however, only the
; first 64 shapes found in the table of the screen display codes can be
; displayed on the screen.  This group includes the letters of the
; alphabet, numerals, and punctuation marks.  If you try to print on the
; screen a character having a higher display code, the shape displayed
; will be from the first group of 64, but that character's background
; will no longer be determined by the register at 53281 ($D021).
; Instead, it will be determined by one of the other background color
; registers.

; When in extended background color mode, characters having display
; codes 64- 127 will take their background color from register 1, and
; location 53282 ($D022).  These characters include various SHIFTed
; characters.  Those with codes 128-191 will have their background
; colors determined by register 2, at 53283 ($D023).  These include the
; reversed numbers, letters, and punctuation marks.  Finally, characters
; with codes 192-255 will use register 4, at 53284 ($D024).  These are
; the reversed graphics characters.

; Let's try an experiment to see just how this works.  First, we will
; put the codes for four different letters in screen memory:

; FOR I=0 TO 3:POKE 1230+(I*8),I*64+I:POKE 55502+(I*8),1:NEXT

; Four white letters should appear on the screen, an A, a shifted A, a
; reversed A, and a reversed, shifted A, all on a blue background.
; Next, we will put colors in the other background color registers:

; POKE 53282,0:POKE53283,2:POKE53284,5

; This sets the registers to black, red, and green, respectively.
; Finally, we will activate extended color mode by setting Bit 6 of the
; VIC-II register at location 53265 to a 1.  The BASIC statement that
; turns this mode on is:

; POKE 53265,PEEK(53265) OR 64

; Notice that two things happened.  First, all of the letters took on
; the same shape, that of the letter A.  Second, each took on the
; background color of a different color register.  To get things back to
; normal, turn off extended color mode with this statement:

; POKE 53265,PEEK(53265) AND 191

; Extended color mode can be a very useful enhancement for your text
; displays.  It allows the creation of windows.  These windows, because
; of their different background colors, make different bodies of text
; stand out as visually distinct from one another.  For example, a text
; adventure program could have one window to display the player's
; current location, one to show an inventory of possessions, and one to
; accept commands for the next move.

; In this mode the background color of these windows can be changed
; instantly, just by POKEing a new value to the color register.  This
; technique lends itself to some dramatic effects.  A window can be
; flashed to draw attention to a particular message at certain times.
; And varying the foreground color can make either the window or the
; message vanish and reappear later.

; There are, however, a couple of problems involved in using these
; windows.  The character shape that you want to use might not have a
; screen code of less than 64.  In that case, the only solution is to
; define your own character set, with the shape you want in one of the
; first 64 characters.

; Another problem is that characters within a PRINT statement in your
; program listing are not always going to look the same on the screen.
; Having to figure out what letter to print to get the number 4 with a
; certain background color can be very inconvenient.  The easiest
; solution to this problem is to have a subroutine to the translation
; for you.  Since letters will appear normally in window 1, and window 3
; characters are simply window 1 characters reversed, you will only have
; problems with characters in windows 2 and 4.  To conver these
; characters, put your message in A$, and use the following subroutine:

; 500 B$="":FOR I=1 TO LEN(A$):B=ASC(MID$(A$,I,1))
; 510 B=B+32:IF B<96 THEN B=B+96
; 520 B$=B$+CHR$(B):NEXT I:RETURN

; This subroutine converts each letter to its ASCII equivalent, adds the
; proper offset, and converts it back to part of the new string, B$.
; When the conversion is complete, B$ will hold the characters necessary
; to PRINT that message in window 2.  For window 4, PRINT
; CHR$(18);B$;CHR$(146).  This will turn reverse video on before
; printing the string, and turn it off afterwards.

; A practical demonstration of the technique for setting up windows is
; given in the sample program below.  The program sets up three windows,
; and shows them flashing, appearing and disappearing.

; 5 DIM RO$(25):RO$(0)=CHR$(19):FOR I=1 TO 24:RO$(I)=RO$(I-1)+CHR$(17):NEXT
; 10 POKE 53265,PEEK(53265) OR 64
; 20 POKE 53280,0:POKE 53281,0:POKE 53282,1:POKE 53283,2:POKE 53284,13
; 25 OP$=CHR$(160):FOR I=1 TO 4:OP$=OP$:NEXTI:PRINTCHR$(147);RO$(3);
; 30 FOR I=1 TO10:PRINTTAB(1);CHR$(18);"               ";TAB(23);OP$:NEXT
; 40 PRINT CHR$(146):PRINT:PRINT:FOR I=1 TO 4:PRINTOP$;OP$;OP$;OP$;OP$;:NEXTI
; 50 PRINT RO$(5);CHR$(5);CHR$(18);TAB(2);"A RED WINDOW"
; 60 PRINT CHR$(18);TAB(2);"COULD BE USED"
; 70 PRINT CHR$(18);TAB(2);"FOR ERROR"
; 80 PRINT CHR$(18);TAB(2);"MESSAGES"
; 100 A$="A GREEN WINDOW":GOSUB 300:PRINT RO$(5);CHR$(144);CHR$(18);TAB(24);B$
; 110 A$="COULD BE USED":GOSUB 300:PRINTTAB(24);CHR$(18);B$
; 120 A$="TO GIVE":GOSUB 300:PRINTTAB(24);CHR$(18);B$
; 130 A$="INSTRUCTIONS":GOSUB 300:PRINTTAB(24);CHR$(18);B
; 140 PRINT CHR$(31);RO$(19);
; 150 A$="  WHILE THE MAIN WINDOW COULD BE USED":GOSUB 300:PRINT B$
; 160 A$="  FOR ACCEPTING COMMANDS.":GOSUB 300:PRINT B$
; 170 FOR I=1 TO 5000:NEXT I:POKE 53284,0
; 180 FOR I=1 TO 5:FOR J=1 TO 300:NEXT J:POKE 53282,15
; 190 FOR J=1 TO 300:NEXT J:POKE 53282,1
; 200 NEXT I:POKE 53283,-2*(PEEK(53283)=240):POKE 53284,-13*(PEEK(53284)=240)
; 210 GOTO 180
; 300 B$="":FOR I=1TOLEN(A$):B=ASC(MID$(A$,I,1))
; 310 B=B+32:IFB<96THENB=B+96
; 320 B$=B$+CHR$(B):NEXTI:RETURN

; Bit 7.  Bit 7 of this register is the high-order bit (Bit 8) of the
; Raster Compare register at 53266 ($D012).  Even though it is located
; here, it functions as part of that register (see the description below
; for more information on the Raster Compare register).

; Machine language programmers should note that its position here at Bit
; 7 allows testing this bit with the Negative flag.  Since scan lines
; above number 256 are all off the screen, this provides an easy way to
; delay changing the graphics display until the scan is in the vertical
; blanking interval and the display is no longer being drawn:

; LOOP  LDA $D011
;       BPL LOOP

; Sprites should always be moved when the raster is scanning off-screen,
; because if they are moved while they are being scanned, their shapes
; will waver slightly.

; The BASIC equivalent of the program fragment above is the statement
; WAIT 53265,128, but BASIC is usually not fast enough to execute the
; next statement while still in the blanking interval.

VICII_RASTER  = $D012
; Read Current Raster Scan Line/Write Line to Compare for Raster IRQ

; The Raster Compare register has two different functions, depending on
; whether you are reading from it or writing to it.  When this register
; is read, it tells which screen line the electron beam is currently
; scanning.

; There are 262 horizontal lines which make up the American (NTSC)
; standard display screen (312 lines in the European or PAL standard
; screen).  Every one of these lines is scanned and updated 60 times per
; second.  Only 200 of these lines (numbers 50-249) are part of the
; visible display.

; It is sometimes helpful to know just what line is being scanned,
; because changing screen graphics on a particular line while that line
; is being scanned may cause a slight disruption on the screen.  By
; reading this register, it is possible for a machine language program
; to wait until the scan is off the bottom of the screen before changing
; the graphics display.

; It is even possible for a machine language program to read this
; register, and change the screen display when a certain scan line is
; reached.  The program below uses this technique to change the
; background color in midscreen, in order to show all 256 combinations
; of foreground and background text colors at once.

; 40 FOR I=49152 TO 49188:READ A:POKE I,A:NEXT:POKE 53280,11
; 50 PRINT CHR$(147):FOR I=1024 TO I+1000:POKE I,160:POKE I+54272,11:NEXT I
; 60 FOR I=0 TO 15:FOR J=0 TO 15
; 70 P=1196+(48*I)+J:POKE P,J+I:POKE P+54272,J:NEXT J,I
; 80 PRINT TAB(15)CHR$(5)"COLOR CHART":FOR I=1 TO 19:PRINT:NEXT
; 85 PRINT "THIS CHART SHOWS ALL COMBINATIONS OF   "
; 86 PRINT "FOREGROUND AND BACKGROUND COLORS.      "
; 87 PRINT "FOREGROUND INCREASES FROM LEFT TO RIGHT"
; 88 PRINT "BACKGROUND INCREASES FROM TOP TO BOTTOM"
; 90 SYS 12*4096
; 100 DATA 169,90,133,251,169,0,141,33,208,162,15,120,173,17,208,48
; 105 DATA 251,173,18,208
; 110 DATA 197,251,208,249,238,33,208,24,105,8,133,251,202,16,233,48,219

; Writing to this register designates the comparison value for the
; Raster Compare Interrupt.  When that interrupt is enabled, a maskable
; interrupt request will be issued every time the electron beam scan
; reaches the scan line whose number was written here.  This is a much
; more flexible technique for changing the display in midscreen than
; reading this register as the sample program above does.  That
; technique requires that the program continuously watch the Raster
; Register, while the interrupt method will call the program when the
; time is right to act.  For more information on raster interrupts, see
; the entry for the Interrupt Mask Register (53274, $D01A).

; It is very important to remember that this register requires nine
; bits, and that this location only holds eight of those bits (the ninth
; is Bit 7 of 53265 ($D011)).  If you forget to read or write to the
; ninth bit, your results could be in error by a factor of 256.

; For example, some early programs written to demonstrate the raster
; interrupt took for granted that the ninth bit of this register would
; be set to 0 on power-up.  When a later version of the Kernal changed
; this initial value to a 1, their interrupt routines, which were
; supposed to set the raster interrupt to occur at scan line number 150,
; ended up setting it for line number 406 instead.  Since the scan line
; numbers do not go up that high, no interrupt request was ever issued
; and the program did not work.

; Location Range: 53267-53268 ($D013-$D014)
; Light Pen Registers

; A light pen is an input device that can be plugged into joystick
; Control Port #1.  It is shaped like a pen and has a light-sensitive
; device at its tip that causes the trigger switch of the joystick port
; to close at the moment the electron beam that updates the screen
; display strikes it.  The VIC-II chip keeps track of where the beam is
; when that happens, and records the corresponding horizontal and
; vertical screen coordinates in the registers at these locations.

; A program can read the position at which the light pen is held up to
; the screen.  The values in these registers are updated once every
; screen frame (60 times per second).  Once the switch is closed and a
; value written to these registers, the registers are latched, and
; subsequent switch closings during the same screen frame will not be
; recorded.

; A given light pen may not be entirely accurate (and the operator may
; not have a steady hand).  It is probably wise to average the positions
; returned from a number of samplings, particularly when using a machine
; language driver.

VICII_LPENX   = $D013
; Light Pen Horizontal Position

; This location holds the horizontal position of the light pen.  Since
; there are only eight bits available (which give a range of 256 values)
; for 320 possible horizontal screen positions, the value here is
; accurate only to every second dot position.  The number here will
; range from 0 to 160 and must be multiplied by 2 in order to get a
; close approximation of the actual horizontal dot position of the light
; pen.

VICII_LPENY   = $D014
; Light Pen Vertical Position

; This location holds the vertical position of the light pen.  Since
; there are only 200 visible scan lines on the screen, the value in this
; register corresponds exactly to the current raster scan line.

VICII_SPENA   = $D015
; Sprite Enable Register

; Bit 0:  Enable Sprite 0 (1=sprite is on, 0=sprite is off)
; Bit 1:  Enable Sprite 1 (1=sprite is on, 0=sprite is off)
; Bit 2:  Enable Sprite 2 (1=sprite is on, 0=sprite is off)
; Bit 3:  Enable Sprite 3 (1=sprite is on, 0=sprite is off)
; Bit 4:  Enable Sprite 4 (1=sprite is on, 0=sprite is off)
; Bit 5:  Enable Sprite 5 (1=sprite is on, 0=sprite is off)
; Bit 6:  Enable Sprite 6 (1=sprite is on, 0=sprite is off)
; Bit 7:  Enable Sprite 7 (1=sprite is on, 0=sprite is off)

; In order for any sprite to be displayed, the corresponding bit in this
; register must be set to 1 (the default for this location is 0).  Of
; course, just setting this bit along will not guarantee that a sprite
; will be shown on the screen.  The Sprite Data Pointer must indicate a
; data area that holds some values other than 0.  The Sprite Color
; Register must also contain a value other than that of the background
; color.  In addition, the Sprite Horizontal and Vertical Position
; Registers must be set for positions that lie within the visible screen
; range in order for a sprite to appear on screen.

VICII_SCROLX  = $D016

VICII_SCROLX_FineScroll_Mask = %00000111
VICII_SCROLX_FineScroll_40Cl = %00001000
VICII_SCROLX_FineScroll_38Cl = 255 - VICII_SCROLX_FineScroll_40Cl   ; %11110111
VICII_SCROLX_FineScroll_MultiColour = %00010000
VICII_SCROLX_FineScroll_NonMultiColour = 255 - VICII_SCROLX_FineScroll_MultiColour ; %11101111
VICII_SCROLX_FineScroll_VideoOff = %00100000
VICII_SCROLX_FineScroll_VideoOn = 255 - VICII_SCROLX_FineScroll_VideoOff ; %11011111

; Horizontal Fine Scrolling and Control Register

; Bits 0-2:  Fine scroll display horizontally by X dot positions (0-7)
; Bit 3:  Select a 38-column or 40-column text display (1=40 columns,
;   0=38 columns)
; Bit 4:  Enable multicolor text or multicolor bitmap mode (1=multicolor on,
;   0=multicolor off)
; Bit 5:  Video chip reset (0=normal operations, 1=video completely off)
; Bits 6-7:  Unused

; This is one of the two important multifunction control registers on
; the VIC-II chip.  On power-up, it is set to a default value of 8,
; which means that the VIC chip Reset line is set for a normal display,
; Multicolor Mode is disabled, a 40-column text display is selected, and
; no horizontal fine-scroll offset is used.

; Bits 0-2.  The first three bits of this chip control vertical fine
; scrolling of the screen display.  This feature allows you to smoothly
; move the entire text display back and forth, enabling the display area
; to act as a window, scrolling over a larger text or character graphics
; display.

; Since each text character is eight dots wide, moving each character
; over one whole character position (known as coarse scrolling) is a
; relatively big jump, and the motion looks jerky.  By placing a number
; from 1 to 7 into these three bits, you can move the whole screen
; display from one to seven dot spaces to the right.

; Stepping through values 1 to 7 allows you to smoothly make the
; transition from having a character appear at one screen column to
; having it appear at the next one over.  To demonstrate this, type in
; the following program, LIST, and RUN it.

; 10 FOR I=1 TO 50:FOR J=0 TO 7
; 20 POKE 53270,(PEEK(53270)AND248) OR J:NEXT J,I
; 30 FOR I=1 TO 50:FOR J=7 TO 0 STEP-1
; 40 POKE 53270,(PEEK(53270)AND248) OR J:NEXT J,I

; As you can see, after the display has moved over seven dots, it starts
; over at its original position.  In order to continue with the scroll,
; you must do a coarse scroll every time the value of the scroll bits
; goes from 7 to 0, or from 0 to 7.  This is accomplished by moving each
; byte of display data on each line over one position, overwriting the
; last character, and introducing a new byte of data on the opposite end
; of the screen line to replace it.

; Obviously, only a machine language program can move all of these bytes
; quickly enough to maintain the effect of smooth motion.  The following
; BASIC program, however, will give you an idea of what the combination
; of fine and coarse scrolling looks like.

; 10 POKE 53281,0:PRINT CHR$(5);CHR$(147):FOR I=1 TO 5:PRINT CHR$(17):NEXT
; 20 FOR I=1 TO 30
; 30 PRINT TAB(I-1)"{UP}{10 SPACES}{UP}"
; 40 WAIT53265,128:POKE53270,PEEK(53270)AND248:PRINTTAB(I)"AWAY WE GO"
; 50 FOR J=1 TO 7
; 60 POKE 53270,(PEEK(53270)AND248)+J
; 70 FORK=1TO30-I
; 80 NEXT K,J,I:RUN

; Changing the value of the three horizontal scroll bits will affect the
; entire screen display.  If you wish to scroll only a portion of the
; screen, you will have to use raster interrupts (see 53274 ($D01A)
; below) to establish a scroll zone, change the value of these scroll
; bits only when that zone is being displayed, and change it back to 0
; afterward.

; Bit 3.  Bit 3 of this register allows you to cover up the first and
; last columns of the screen display with the border.  Since the viewers
; cannot see the characters there, they will not be able to see you
; insert a new character on the end of the line when you do coarse
; scrolling (see explanation of Bits 0-2 above).

; Setting this bit to 1 enables the normal 40-column display, while
; resetting it to 0 changes the display to 38 columns.  This is a purely
; cosmetic aid, and it is not necessary to change the screen to the
; smaller size to use the scrolling feature.

; Bit 4.  This bit selects multicolor graphics.  The effect of setting
; this bit to 1 depends on whether or not the bitmap graphics mode is
; also enabled.

; If you are not in bitmap mode, and you select multicolor text
; character mode by setting this bit to 1, characters with a color
; nybble whose value is less than 8 are displyed normally.  There will
; be one background color and one foreground color.  But each dot of a
; character with a color nybble whose value is over 7 can have any one
; of four different colors.

; The two colors in the Background Control Registers 1 and 2 (53282-3,
; $D022-3) are available in addition to the colors supplied by the Color
; RAM.  The price of these extra colors is a reduction in horizontal
; resolution.  Instead of each bit controlling one dot, in multicolor
; mode a pair of bits control the color of a larger dot.  A pattern of
; 11 will light it with the color from the lower three bits of color
; RAM.  Patterns of 01 and 10 will select the colors from Background
; Color Registers 1 and 2, respectively, for the double-width dot.

; You can see the effect that setting this bit has by typing in the
; following BASIC command line:

; POKE 53270,PEEK(53280)OR16:PRINT CHR$(149)"THIS IS MULTICOLOR MODE"

; It is obvious from this example that the normal set of text characters
; was not made to be used in multicolor mode.  In order to take
; advantage of this mode, you will need to design custom four-color
; characters.  For more information, see the alternate entry for 53248
; ($D000), the Character Generator ROM.

; If the multicolor and bitmap enable bits are both set to 1, the result
; is a multicolor bitmap mode.  As in multicolor text mode, pairs of
; graphics data bits are used to set each dot in a 4 by 8 matrix to one
; of four colors.  This results in a reduction of the horizontal
; resolution to 160 double-wide dots across.  But while text multicolor
; mode allows only one of the four colors to be set individually for
; each 4 by 8 dot area, bitmap multicolor mode allows up to three
; different colors to be individually selected in each 4 by 8 dot area.
; The source of the dot color for each bit-pair combination is shown
; below:

; 00 Background Color Register 0 (53281, $D021)
; 01 Upper four bits of Video Matrix
; 10 Lower four bits of Video Matrix
; 11 Color RAM nybble (area starts at 55296 ($D800))

; The fact that bit-pairs are used in this mode changes the strategy for
; plotting somewhat.  In order to find the byte BY in which the desired
; bit-pair resides, you must multiply the horizontal position X, which
; has a value of 0- 159, by 2, and then use the same formula as for
; hi-res bitmap mode.

; Given that the horizontal position (0-159) of the dot is stored in the
; variable X, its vertical position is in the variable Y, and the base
; address of the bitmap area ia in the variable BASE, you can find the
; desired byte with the formula:

; BY=BASE+(Y AND 248)*40+(Y AND 7)+(2*X AND 504)

; Setting the desired bit-pair will depend on what color you chose.
; First, you must set up an array of bit masks.

; CA(0)=1:CA(1)=4:CA(2)=16:CA(3)=64

; To turn on the desired dot, select a color CO from 0 to 3
; (representing the color selected by the corresponding bit pattern) and
; execute the following statement:

; BI=(NOT X AND 3):POKE BY,PEEK(BY) AND (NOT 3*CA(BI)) OR (CO*CA(BI))

; The following program will demonstrate this technique:

; 10 CA(0)=1:CA(1)=4:CA(2)=16:CA(3)=64:REM ARRAY FOR BIT PAIRS
; 20 BASE=2*4096:POKE53272,PEEK(53272)OR8:REM PUT BIT MAP AT 8192
; 30 POKE53265,PEEK(53265)OR32:POKE53270,PEEK(53270)OR16:REM MULTI-COLOR BIT MAP
; 40 A$="":FOR I=1 TO 37:A$=A$+"C":NEXT:PRINT CHR$(19);
; 50 FOR I=1 TO 27:PRINT A$;:NEXT:POKE 2023,PEEK(2022): REM SET COLOR MAP
; 60 A$="":FOR I=1 TO 128:A$=A$+"@":NEXT:FOR I=32 TO 63 STEP 2
; 70 POKE648,I:PRINTCHR$(19);A$;A$;A$;A$:NEXT:POKE648,4:REM CLR HI-RES SCREEN
; 80 FOR CO=1TO3:FOR Y=0TO199STEP.5:REM FROM THE TOP OF THE SCREEN TO THE BOTTOM
; 90 X=INT(10*CO+15*SIN(CO*45+Y/10)): REM SINE WAVE SHAPE
; 100 BY=BASE+40*(Y AND 248)+(Y AND 7)+(X*2 AND 504): REM FIND HI-RES BYTE
; 110 BI=(NOT X AND 3):POKE BY,PEEK(BY) AND (NOT 3*CA(BI)) OR(CO*CA(BI))
; 120 NEXT Y,CO
; 130 GOTO 130: REM LET IT STAY ON SCREEN

; Bit 5:  Bit 5 controls the VIC-II chip Reset line.  Setting this bit
; to 1 will completely stop the video chip from operating.  On older
; 64s, the screen will go black.  It should always be set to 0 to insure
; normal operation of the chip.

; Bits 6 and 7.  These bits are not used.

VICII_YXPAND  = $D017
; Sprite Vertical Expansion Register

; Bit 0:  Expand Sprite 0 vertically (1=double height, 0=normal height)
; Bit 1:  Expand Sprite 1 vertically (1=double height, 0=normal height)
; Bit 2:  Expand Sprite 2 vertically (1=double height, 0=normal height)
; Bit 3:  Expand Sprite 3 vertically (1=double height, 0=normal height)
; Bit 4:  Expand Sprite 4 vertically (1=double height, 0=normal height)
; Bit 5:  Expand Sprite 5 vertically (1=double height, 0=normal height)
; Bit 6:  Expand Sprite 6 vertically (1=double height, 0=normal height)
; Bit 7:  Expand Sprite 7 vertically (1=double height, 0=normal height)

; This register can be used to double the height of any sprite.  When
; the bit in this register that corresponds to a particular sprite is
; set to 1, each dot of the 24 by 21 sprite dot matrix will become two
; raster scan lines high instead of one.

VICII_VMCSB   = $D018
; VIC-II Chip Memory Control Register

; Bit 0:  Unused
; Bits 1-3:  Text character dot-data base address within VIC-II address
;   space
; Bits 4-7:  Video matrix base address within VIC-II address space

; This register affects virtually all graphics operations.  It
; determines the vase address of two very important data areas, the
; Video Matrix, and the Character Dot-Data area.

; Bits 1-3.  These bits are used to set the location of the Character
; Dot-Data area.  This area is where the data is stored (for more
; information on character shape data, see the alternate entry for
; location 53248 ($D000), the Character Generator ROM).

; Bits 1-3 can represent any even number from 0 to 14.  That numer
; stands for the even 1K offset of the character data area from the
; beginning of VIC-II memory.  For example, if these bits are all set to
; 0, it means that the character memory occupies the first 2K of VIC-II
; memory.  If they equal 2, the data area starts 2*1K (2*1024) or 2048
; bytes from the beginning of VIC memory.

; The default value of this nybble is 4.  This sets the address of the
; Character Dot-Data area to 4096 ($1000), which is the starting address
; of where the VIC-II chip addresses the Character ROM.  The normal
; character set which contains uppercase and graphics occupies the first
; 2K of that ROM.  The alternate character set which contains both
; upper- and lowercase letters use the second 2K.  Therefore, to shift
; to the alternate character set, you must change the value of this
; nybble to 6, with a POKE 53272,PEEK(53272)OR2.  To change it back,
; POKE 53272,PEEK(53272)AND253.

; In bitmap mode, the lower nybble controls the location of the bitmap
; screen data.  Since this data area can start only at an offset of 0 or
; 8K from the beginning of VIC-II memory, only Bit 3 of the Memory
; Control Register is significant in bitmap mode.  If Bit 3 holds a 0,
; the offset is 0, and if it holds a 1, the offset is 8192 (8K).

; Bits 4-7.  This nybble determines the starting address of the Video
; Matrix area.  This is the 1024-byte area of memory which contains the
; screen codes for the text characters that are displayed on the screen.
; In addition, the last eight bytes of this area are used as pointers
; which designate which 64- byte block of VIC-II memory will be used as
; shape data for each sprite.

; These four bits can represent numbers from 0 to 15.  These numbers
; stand for the offset (in 1K increments) from the beginning of VIC-II
; memory to the Video Matrix.

; For example, the default bit pattern is 0001.  This indicates that the
; Video Matrix is offset by 1K from the beginning of VIC-II memory, the
; normal starting place for screen memory.  Remember, though, the bit
; value of this number will be 16 times what the bit pattern indicates,
; because we are dealing with Bits 4-7.  Therefore, the 0001 in the
; upper nybble has a value of 16.

; Using this register, we can move the start of screen memory to any 1K
; boundary within the 16K VIC-II memory area.  Just changing this
; register, however, is not enough if you want to use the BASIC line
; editor.  The editor looks to location 648 ($288) to determine where to
; print screen characters.

; If you just change the location of the Video Matrix without changing
; the value in 648, BASIC will continue to print characters in the
; memory area starting at 1024, even though that area is no longer being
; displayed.  The result is that you will not be able to see anything
; that you type in on the keyboard.  To fix this, you must POKE 648 with
; the page number of the starting address of screen memory (page
; number=location/256).  Remember, the actual starting address of screen
; memory depends not only on the offset from the beginning of VIC-II
; memory in the register, but also on which bank of 16K is used for
; VIC-II memory.

; For example, if the screen area starts 1024 bytes from the beginning
; of VIC- II memory, and the video chip is using Bank 2 (32768-49151),
; the actual starting address of screen memory is 32768+1024=33792
; ($8400).  For examples of how to change the video memory area, and of
; how to relocate the screen, see the entro for 56576 ($DD00).

VICII_VICIRQ  = $D019
; VIC Interrupt Flag Register

; Bit 0:  Flag:  Is the Raster Compare a possible source of an IRQ?
;         (1=yes)
; Bit 1:  Flag:  Is a collision between a sprite and the normal graphics
;         display a possible source of an IRQ?  (1=yes)
; Bit 2:  Flag:  Is a collision between two sprites a possible source of
;         an IRQ?  (1=yes)
; Bit 3:  Flag:  Is the light pen trigger a possible source of an IRQ?
;         (1=yes)
; Bits 4-6:  Not used
; Bit 7:  Flag:  Is there any VIC-II chip IRQ source which could cause
;         an IRQ?  (1=yes)

; The VIC-II chip is capable of generating a maskable request (IRQ) when
; certain conditions relating to the video display are fulfilled.
; Briefly, the conditions that can cause a VIC-II chip IRQ are:

; 1.  The line number of the current screen line being scanned by the
; raster is the same as the line number value written to the Raster
; Register (53266, $D012).

; 2.  A sprite is positioned at the same location where normal graphics
; data are being displayed.

; 3.  Two sprites are positioned so that they are touching.

; 4.  The light sensor on the light pen has been struck by the raster
; beam, causing the fire button switch on joystick Control Port #1 to
; close (pressing the joystick fire button can have the same effect).

; When one of these conditions is met, the corresponding bit in this
; status register is set to 1 and latched.  That means that as long as
; the corresponding enable bit in the VIC IRQ Mask register is set to 1,
; and IRQ requested will be generated, and any subsequent fulfillment of
; the same condition will be ignored until the latch is cleared.

; This allows you to preserve multiple interrupt requests if more than
; one of the interrupt conditions is met at a time.  In order to keep an
; IRQ source from generating another request after it has been serviced,
; and to enable subsequent interrupt conditions to be detected, the
; interrupt service routine must write a 1 to the corresponding bit.
; This will clear the latch for that bit.  The default value written to
; this register is 15, which clears all interrupts.

; There is only 1 IRQ vector that points to the address of the routine
; that will be executed when an IRQ interrupt occurs.  The same routine
; will therefore be executed regardless of the source of the interrupt.
; This status register provides a method for that routine to check what
; the source of the IRQ was, so that the routine can take appropriate
; action.  First, the routine can check Bit 7.  Anytime that any of the
; other bits in the status register is set to 1, Bit 7 will also be set.
; Therefore, if that bit holds a 1, you know that the VIC-II chip
; requested an IRQ (the two CIA chips which are the other sources of IRQ
; interrupts can be checked in a similar manner).  Once it has been
; determined that the VIC chip is responsible for the IRQ, the
; individual bits can be tested to see which of the IRQ conditions have
; been met.

; For more information, and a sample VIC IRQ program, see the following
; entry.

VICII_IRQMASK = $D01A
; IRQ Mask Register

; Bit 0:  Enable Raster Compare IRQ (1=interrupt enabled)
; Bit 1:  Enable IRQ to occure when sprite collides with display of
;   normal
;         graphics data (1=interrupt enabled)
; Bit 2:  Enable IRQ to occur when two sprites collide (1=interrupt
;   enabled)
; Bit 3:  Enable light pen to trigger an IRQ (1=interrupt enabled)
; Bits 4-7:  Not used

VICII_IRQMASK_ENABLE_RASTER_COMPARE = %00000001
VICII_IRQMASK_ENABLE_IRQ_SPRITE_COLLIDES_BACKGROUND = %00000010
VICII_IRQMASK_ENABLE_IRQ_SPRITE_COLLIDES_SPRITE = %00000100
VICII_IRQMASK_ENABLE_IRA_LIGHT_PEN_TRIGGER = %00001000

; This register is used to enable an IRQ request to occur when one of
; the VIC-II chip interrupt conditions is met.  In order to understand
; what that means, and how these interrupts can extend the range of
; options available to a programmer, you must first understand what an
; interrupt is.

; An interrupt is a signal given to the microprocessor (the brains of
; the computer) that tells it to stop executing its machine language
; program (for example, BASIC), and to work on another program for a
; short time, perhaps only a fraction of a second.  After finishing the
; interrupt program, the computer goes back to executing the main
; program, just as if there had never been a detour.

; Bit 0.  This bit enables the Raster Compare IRQ.  The conditions for
; this IRQ are met when the raster scan reaches the video line indicated
; by the value written to the Raster Register at 53266 ($D012) and Bit 7
; of 53265 ($D011).  Again, an explanation of the terminology is in
; order.

; In the normal TV display, a beam of electrons (raster) scans the
; screen, starting in the top-left corner, and moving in a straight line
; to the right, lighting up appropriate parts of the screen line on the
; way.  When it comes to the right edge, the beam moves down a line, and
; starts again from the left.  There are 262 such line that are scanned
; by the 64 display, 200 of which form the visible screen area.  This
; scan updates the complete screen display 60 times every second.

; The VIC-II chip keeps track of which line is being scanned, and stores
; the scan number in the Raster Register at 53266 and 53265 ($D012 and
; $D011).  The Raster Register has two functions.  When read, it tells
; what line is presently being scanned.  But when written to, it
; designates a particular scan line as the place where a raster
; interrupt will occur.

; At the exact moment that the raster beam line number equals the number
; written to the register, Bit 0 of the status register will be set to
; 1, showing that the conditions for a Raster Compare Interrupt have
; been fulfulled.  If the raster interrupt is enabled then,
; simultaneously, the interrupt program will be executed.  This allows
; the user to reset any of the VIC-II registers at any point in the
; display, and thus change character sets, background color, or graphics
; mode for only a part of the screen display.

; The interrupt routine will first check if the desired condition is the
; source of the interrupt (see above entry) and then make the changes to
; the screen display.  Once you have written this interrupt routine, you
; must take the following steps to install it.

; 1.  Set the interrupt disable flag in the status register with an SEI
; instruction.  This will disable all interrupts and prevent th system
; from crashing while you are changing the interrupt vectors.

; 2.  Enable the raster interrupt.  This is done by setting Bit 0 of the
; VIC- II chip interrupt enable register at location 53274 ($D01A) to 1.

; 3.  Indicate the scan line on which you want the interrupt to occur by
; writing to the raster registers.  Don't forget that this is a nine-bit
; value, and you must set both the low byte (in location 53266 ($D012))
; and the high bit (in the register at 53265 ($D011)) in order to insure
; that the interrupt will start at the scan line you want it to, and not
; 256 lines earlier or later.

; 4.  Let the computer know where the machine language routine that you
; want the interrupt to execute starts.  This is done by placing the
; address in the interrupt vector at locations 788-789 ($314-$315).
; This address is split into two parts, a low byte and a high byte, with
; the low byte stored at 788.

; To calculate the two values for a given address AD, you may use the
; formula HIBYTE=INT(AD/156) and LOWBYTE=AD-(HIBYTE*256).  The value
; LOWBYTE would go into location 788, and the value HIBYTE would go into
; location 789.

; 5.  Reenable interrupts with a CLI instruction, which clears the
; interrupt disable flag on the status register.

; When the computer is first turned on, the interrupt vector is set to
; point to the normal hardware timer interrupt routine, the one that
; advances the jiffy clock and reads the keyboard.  Since this interrupt
; routine uses the same vector as the raster interrupt routine, it is
; best to turn off the hardware timer interrupt by putting a value of
; 127 in location 56333 ($DC0D).

; If you want the keyboard and jiffy clock to function normally while
; your interrupt is enabled, you must preserve the contents of locations
; 788 and 789 before you change them to point to your new routine.  Then
; you must have your interrupt routine jump to the old interrupt routine
; exactly once per screen refresh (every 1/60 second).

; Another thing that you should keep in mind is that at least two raster
; interrupts are required if you want to change only a part of the
; screen.  Not only must the interrupt routine change the display, but
; it must also set up another raster interrput that will change it back.

; The sample program below uses a raster-scan interrupt to divide the
; display into three sections.  The first 80 scan lines are in
; high-resolution bitmap mode, the next 40 are regular text, and the
; last 80 are in multicolor bitmap mode.  The screen will split this way
; as soon as a SYS to the routine that turns on the interrupt occurs.
; The display will stay split even after the program ends.  Only if you
; hit the STOP and RESTORE keys together will the display return to
; normal.

; The interrupt uses a table of values that are POKEd into four key
; locations during each of the three interrupts, as well as values to
; determine at what scan lines the interrupt will occur.  The locations
; affected are Control Register 1 (53265, $D011), Control Register 2
; (53270, $D016), the Memory Control Register (53272, $D018), and
; Background Color 0 (53281, $D021).  The data for the interrupt routine
; is contained in lines 49152-49276.  Each of these line numbers
; corresponds to the locations where the first data byte in the
; statement is POKEd into memory.

; If you look at lines 49264-49276 of the BASIC program, you will see
; REMark statements that explain which VIC-II registers are affected by
; the DATA statements in each line.  The number in these DATA
; startements appear in the reverse order in which they are put into the
; VIC register.  For example, line 49273 holds the data that will go
; into Control Register 2.  The last number, 8, is the one that will be
; placed into Control Register 2 while the top part of the screen is
; displayed.  The first number, 24, is placed into Control Register 2
; during the bottom part of the screen display, and changes that portion
; of the display to multicolor mode.

; The only tricky part in determining which data byte affects which
; interrupt comes in line 49264, which holds the data that determines
; the scan line at which each interrupt will occur.  Each DATA statement
; entry reflects the scan line at which the next interrupt will occur.
; The first item in line 49264 is 49.  Even though this is the entry for
; the third interrupt, the next to be generates is the first interrupt,
; which occurs at the top of the screen.  Likewise, the last data item
; of 129 is used during the first interrupt to start the next interrupt
; at scan line 129.

; Try experimenting with these values to see what results you come up
; with.  For example, if you change the number 170 to 210, you will
; increase the text area by five lines (40 scan lines).

; By changing the values in the data tables, you can alter the effect of
; each interrupt.  Change the 20 in line 49276 to 22, and you will get
; lowercase text in the middle of the screen.  Change the first 8 in
; line 49273 to 24, and you'll get multicolor text in the center window.
; Each of these table items may be used exactly like you would use the
; corresponding register, in order to change background color, to obtain
; text or bitmap graphics, regular or multicolor modes, screen blanking
; or extended background color mode.

; It is even possible to change the table values during a program, by
; POKEing the new value into the memory location where those table
; values are stored.  In that way, you can, for example, change the
; background color of any of the screen parts while the program is
; running.

; 5 FOR I=0 TO 7:BI(I)=2^I:NEXT
; 10 FOR I=49152 TO 49278:READ A:POKE I,A:NEXT:SYS12*4096
; 20 PRINT CHR$(147):FOR I=0 TO 8:PRINT:NEXT
; 30 PRINT"THE TOP AREA IS HIGH-RES BIT MAP MODE"
; 40 PRINT:PRINT"THE MIDDLE AREA IS ORDINARY TEXT "
; 50 PRINT:PRINT"THE BOTTOM AREA IS MULTI-COLOR BIT MAP"
; 60 FORG=1384 TO 1423:POKE G,6:NEXT
; 70 FORG=1024 TO 1383:POKEG,114:POKE G+640,234:NEXT
; 80 A$="":FOR I=1 TO 128:A$=A$+"@":NEXT:FOR I=32 TO 63 STEP 2
; 90 POKE 648,I:PRINT CHR$(19)CHR$(153);A$;A$;A$;A$:NEXT:POKE 648,4
; 100 BASE=2*4096:BK=49267
; 110 H=40:C=0:FORX=0TO319:GOSUB150:NEXT
; 120 H=160:C=0:FORX=0TO319STEP2:GOSUB150:NEXT:C=40
; 125 FORX=1TO319STEP2:GOSUB150:NEXT
; 130 C=80:FOR X=0 TO 319 STEP2:W=0:GOSUB150:W=1:GOSUB150:NEXT
; 140 GOTO 140
; 150 Y=INT(H+20*SIN(X/10+C)):BY=BASE+40*(Y AND 248)+(Y AND 7)+(X AND 504)
; 160 POKE BY,PEEK(BY) OR (BI(ABS(7-(XAND7)-W))):RETURN
; 49152 DATA 120, 169, 127, 141, 13, 220
; 49158 DATA 169, 1, 141, 26, 208, 169
; 49164 DATA 3, 133, 251, 173, 112, 192
; 49170 DATA 141, 18, 208, 169, 24, 141
; 49176 DATA 17, 208, 173, 20, 3, 141
; 49182 DATA 110, 192, 173, 21, 3, 141
; 49188 DATA 111, 192, 169, 50, 141, 20
; 49194 DATA 3, 169, 192, 141, 21, 3
; 49200 DATA 88, 96, 173, 25, 208, 141
; 49206 DATA 25, 208, 41, 1, 240, 43
; 49212 DATA 190, 251, 16, 4, 169, 2
; 49218 DATA 133, 251, 166, 251, 189, 115
; 49224 DATA 192, 141, 33, 208, 189, 118
; 49230 DATA 192, 141, 17, 208, 189, 121
; 49236 DATA 192, 141, 22, 208, 189, 124
; 49242 DATA 192, 141, 24, 208, 189, 112
; 49248 DATA 192, 141, 18, 208, 138, 240
; 49254 DATA 6, 104, 168, 104, 170, 104
; 49260 DATA 64, 76, 49, 234
; 49264 DATA 49, 170, 129 :REM SCAN LINES
; 49267 DATA 0, 6, 0:REM BACKGROUND COLOR
; 49270 DATA 59, 27,59:REM CONTROL REG. 1
; 49273 DATA 24, 8, 8:REM CONTROL REG. 2
; 49276 DATA 24, 20, 24:REM MEMORY CONTROLRUN

; Besides enabling the creation of mixed graphics-modes screens, the
; Raster Compare Interrupt is also useful for creating scrolling zones,
; so that some parts of the screen can be fine-scrolled while the rest
; remains stationary.

; Bit 1 enables the light pen interrupt.  This interrupt can occur when
; the light of the raster beam strikes the light-sensitive device in the
; pen's tip, causing it to close the fire button switch on joystick
; Controller Port #1.

; The light pen interrupt affords a method of signaling to a program
; that the pen is being held to the screen, and that its position can be
; read.  Some light pens provide a push-button switch which grounds one
; of the other lines on the joystick port.  This switch can be pressed
; by the user as an additional signal that the pen is properly
; positioned.  Its location can then be read in the light pen position
; registers (53267-8, $D013-4).

; Bit 2 enables the sprite-foreground collision interrupt.  This
; interrupt can occur if one of the srpte character's dots is touching
; one of the dots from the foreground display of either text character
; or bitmap graphics.

; Bit 3 enables the sprite-sprite collision interrupt, which can occur
; if one of the sprite character's dots is touching one of the dots of
; another sprite character.

; These two interrupts are useful for games, where such collisions often
; require that some action be taken immediately.  Once the interrupt
; signals that a collision has occurred, the interrupt routine can check
; the Sprite- Foreground Collision Register at 53279 ($D01F), or the
; Sprite-Sprite Collision Register at 53278 ($D01E), to see which sprite
; or sprites are involved in the collision.  See the entry for those
; locations for more details on collisions.

VICII_SPBGPR   = $D01B
; Sprite to Foreground Display Priority Register

; Bit 0:  Select display priority of Sprite 0 to foreground (0=sprite
;         appears in front of foreground)
; Bit 1:  Select display priority of Sprite 1 to foreground (0=sprite
;         appears in front of foreground)
; Bit 2:  Select display priority of Sprite 2 to foreground (0=sprite
;         appears in front of foreground)
; Bit 3:  Select display priority of Sprite 3 to foreground (0=sprite
;         appears in front of foreground)
; Bit 4:  Select display priority of Sprite 4 to foreground (0=sprite
;         appears in front of foreground)
; Bit 5:  Select display priority of Sprite 5 to foreground (0=sprite
;         appears in front of foreground)
; Bit 6:  Select display priority of Sprite 6 to foreground (0=sprite
;         appears in front of foreground)
; Bit 7:  Select display priority of Sprite 7 to foreground (0=sprite
;         appears in front of foreground)

; If a sprite is positioned to appear at a spot on the screen that is
; already occupied by text or bitmap graphics, a conflict arises.  The
; contents of this register determines which one will be displayed in
; such a situation.  If the bit that corresponds to a particular sprite
; is set to 0, the sprite will be displayed in front of the foreground
; graphics data.  If that bit is set to 1, the foreground data will be
; displayed in front of the sprite.  The default value that this
; register is set to at power-on is 0, so all sprites start out with
; priority over foreground graphics.

; Note that for the purpose of priority, the 01 bit-pair of multicolor
; graphics modes is considered to display a background color, and
; therefore will be shown behind sprite graphics even if the foreground
; graphics data takes priority.  Also, between the sprites themselves
; there is a fixed priority.  Each sprite has priority over all
; higher-number sprites, so that Sprite 0 is displayed in front of all
; the others.

; The use of priority can aid in creating three-dimensional effects, by
; allowing some objects on the screen to pass in front of or behind
; other objects.

VICII_SPMC    = $D01C
; Sprite Multicolor Registers

; Bit 0:  Select multicolor mode for Sprite 0 (1=multicolor, 0=hi-res)
; Bit 1:  Select multicolor mode for Sprite 1 (1=multicolor, 0=hi-res)
; Bit 2:  Select multicolor mode for Sprite 2 (1=multicolor, 0=hi-res)
; Bit 3:  Select multicolor mode for Sprite 3 (1=multicolor, 0=hi-res)
; Bit 4:  Select multicolor mode for Sprite 4 (1=multicolor, 0=hi-res)
; Bit 5:  Select multicolor mode for Sprite 5 (1=multicolor, 0=hi-res)
; Bit 6:  Select multicolor mode for Sprite 6 (1=multicolor, 0=hi-res)
; Bit 7:  Select multicolor mode for Sprite 7 (1=multicolor, 0=hi-res)

; Sprite multicolor mode is very similar to text and bitmap multicolor
; modes (see Bit 4 of 53270, $D016).  Normally, the color of each dot of
; the sprite is controlled by a single bit of sprite shape data.  When
; this mode is enabled for a sprite, by setting the corresponding bit of
; this register to 1, the bits of sprite shape data are grouped together
; in pairs, with each pair of bits controlling a double-wide dot of the
; sprite display.  By sacrificing some of the horizontal resolution (the
; sprite, although the same size, is now only 12 dots wide), you gain
; the use of two additional colors.  The four possible combinations of
; these bit-pairs display dot colors from the following sources:

; 00 Background Color Register 0 (transparent)
; 01 Sprite Multicolor Register 0 (53285, $D025)
; 10 Sprite Color Registers (53287-94, $D027-E)
; 11 Sprite Multicolor Register 1 (53286, $D026)

; Like multicolor text characters, multicolor sprites all share two
; color registers.  While each sprite can display three foreground
; colors, only one of these colors in unique to that sprite.  The number
; of unique colors may be increated by combining more than one sprite
; into a single character.

VICII_XXPAND  = $D01D
; Sprite Horizontal Expansion Register

; Bit 0:  Expand Sprite 0 horizontally (1=double-width sprite, 0=normal
;         width)
; Bit 1:  Expand Sprite 1 horizontally (1=double-width sprite, 0=normal
;         width)
; Bit 2:  Expand Sprite 2 horizontally (1=double-width sprite, 0=normal
;         width)
; Bit 3:  Expand Sprite 3 horizontally (1=double-width sprite, 0=normal
;         width)
; Bit 4:  Expand Sprite 4 horizontally (1=double-width sprite, 0=normal
;         width)
; Bit 5:  Expand Sprite 5 horizontally (1=double-width sprite, 0=normal
;         width)
; Bit 6:  Expand Sprite 6 horizontally (1=double-width sprite, 0=normal
;         width)
; Bit 7:  Expand Sprite 7 horizontally (1=double-width sprite, 0=normal
;         width)

; This register can be used to double the width of any sprite.  Setting
; any bit of this register to 1 will cause each dot of the corresponding
; sprite shape to be displayed twice as wide as normal, so that without
; changing its horizontal resolution, the sprite takes up twice as much
; space.  The horizontal expansion feature can be used alone, or in
; combination with the vertical expansion register at 53271 ($D017).

; Location Range: 53278-53279 ($D01E-$D01F)
; Sprite Collision Detection Registers

; While Bit 2 of the VIC IRQ Register at 53273 ($D019) is set to 1
; anytime two sprites overlap, and Bit 1 is set to 1, when a sprite
; shape is touching the foreground text or bit-graphics display, these
; registers specify which sprites were involved in the collision.  Every
; bit that is set to 1 indicates that the corresponding sprite was
; involved in the collision.  Reading these registers clears them so
; that they can detect the next collision.  Therefore, if you plan to
; make multiple tests on the values stored here, it may be necessary to
; copy it to a RAM variable for further reference.

; Note that while these registers tell you what sprites were involved in
; a collision, they do not necessarily tell you what objects have
; collided with each other.  It is quite possible to have three sprites
; lined up in a row, where Sprite A is on the left, Sprite B is in the
; middle, touching Sprite A, and Sprite C is on the right, touching
; Sprite B but not touching Sprite A.  The Sprite-Sprite Collision
; register would show that all three are involved.  The only way to make
; absolutely certain which collided with which is to check the position
; of each sprite, and calculate for each sprite display line if a sprite
; of that size would touch either of the others.  As you can imagine,
; this is no easy task.

; There are a few simple rules concerning what does or does not cause a
; collision.  Though the sprite character consists of 504 dots in a 24
; by 21 matrix, does which represent data bits that are equal to 0 (or
; multicolor bit- pairs equal to 00), and therefore always displayed in
; the background color, do not count when it comes to collision.

; A collision can occur only if a dot which represents a sprite shape
; data bit of 1 touches another dot of nonzero graphics data.  Consider
; the case of two invisible sprites.  The first sprite is enabled, its
; color set to contrast the background, and it is positioned on the
; screen, but its shape data bytes are all 0.  This sprite can never be
; involved in a collision, because it displays no nonzero data.  The
; second sprite is enabled, positioned on the screen, and its shape
; pointer set for a data read that is filled with bytes having a value
; of 255.  Even if that sprite's color is set to the same value as the
; background color, making the sprite invisible, it can still be
; involved in collisions.  The only exception to this rule is the 01
; bit-pair of multicolor graphics data.  This bit-pair is considered
; part of the background, and the dot it displays can never be involved
; in a collision.

; The other rule to remember about collisions is that they can occur in
; areas that are covered by the screen border.  Collision between
; sprites can occur when the sprites are offscreen, and collisions
; between sprites and foreground display data can occur when that data
; is in an area that is covered by the border due to the reduction of
; the display to 38 columns or 24 rows.

VICII_SPSPCL  = $D01E
; Sprite to Sprite Collision Register

; Bit 0:  Did Sprite 0 collide with another sprite?  (1=yes)
; Bit 1:  Did Sprite 1 collide with another sprite?  (1=yes)
; Bit 2:  Did Sprite 2 collide with another sprite?  (1=yes)
; Bit 3:  Did Sprite 3 collide with another sprite?  (1=yes)
; Bit 4:  Did Sprite 4 collide with another sprite?  (1=yes)
; Bit 5:  Did Sprite 5 collide with another sprite?  (1=yes)
; Bit 6:  Did Sprite 6 collide with another sprite?  (1=yes)
; Bit 7:  Did Sprite 7 collide with another sprite?  (1=yes)

VICII_SPBGCL   = $D01F
; Sprite to Foreground Collision Register

; Bit 0:  Did Sprite 0 collide with the foreground display?  (1=yes)
; Bit 1:  Did Sprite 1 collide with the foreground display?  (1=yes)
; Bit 2:  Did Sprite 2 collide with the foreground display?  (1=yes)
; Bit 3:  Did Sprite 3 collide with the foreground display?  (1=yes)
; Bit 4:  Did Sprite 4 collide with the foreground display?  (1=yes)
; Bit 5:  Did Sprite 5 collide with the foreground display?  (1=yes)
; Bit 6:  Did Sprite 6 collide with the foreground display?  (1=yes)
; Bit 7:  Did Sprite 7 collide with the foreground display?  (1=yes)

; Location Range: 53280-53294 ($D020-$D02E)
; VIC-II Color Register

; Although these color registers are used for various purposes, all of
; them have one thing in common.  Like the Color RAM Nybbles, only the
; lower four bits are connected.  Therefore, when reading these
; registers, you must mask out the upper four bits (that is,
; BORDERCOLOR=PEEK(53280)AND15) in order to get a true reading.

VICII_EXTCOL  = $D020
; Border Color Register

; The color value here determines the color of the border or frame
; around the central display area.  The entire screen is set to this
; color when the blanking feature of Bit 4 of 53265 ($D011) is enabled.
; The default color value is 14 (light blue).

VICII_BGCOL0  = $D021          
; Background Color 0

; This register sets the background color for all text modes, sprite
; graphics, and multicolor bitmap graphics.  The default color value is
; 6 (blue).

VICII_BGCOL1  = $D022
; Background Color 1

; This register sets the color for the 01 bit-pair of multicolor
; character graphics, and the background color for characters having
; screen codes 64-127 in extended background color text mode.  The
; default color value is 1 (white).

VICII_BGCOL2  = $D023
; Background Color 2

; This register sets the color for the 10 bit-pair of multicolor
; character graphics, and the background color for characters habing
; screen codes 128-191 in extended background color text mode.  The
; default color value is 2 (red).

VICII_BGCOL3  = $D024
; Background Color 3

; This register sets the background color for characters having screen
; codes between 192 and 255 in extended background color text mode.  The
; default color value is 3 (cyan).

VICII_SPMC0   = $D025
; Sprite Multicolor Register 0

; This register sets the color that is displayed by the 01 bit-pair in
; multicolor sprite graphics.  The default color value is 4 (purple).

VICII_SPMC1   = $D026
; Sprite Multicolor Register 1

; This register sets the color that is displayed by the 11 bit-pair in
; multicolor sprite graphics.  The default color value is 0 (black).

; Location Range: 53287-53294 ($D027-$D02E)
; Sprite Color Registers

; These registers are used to set the color to be displayed by bits of
; hi-res sprite data having a value of 1, and by bit-pairs of multicolor
; sprite data having a value of 10.  The color of each sprite is
; determined by its own individual color register.

VICII_SP0COL   = $D027
; Sprite 0 Color Register (the default color value is 1, white)

VICII_SP1COL  = $D028
; Sprite 1 Color Register (the default color value is 2, red)

VICII_SP2COL  = $D029
; Sprite 2 Color Register (the default color value is 3, cyan)

VICII_SP3COL  = $D01A
; Sprite 3 Color Register (the default color value is 4, purple)

VICII_SP4COL  = $D01B
; Sprite 4 Color Register (the default color value is 5, green)

VICII_SP5COL  = $D01C
; Sprite 5 Color Register (the default color value is 6, blue)

VICII_SP6COL  = $D01D
; Sprite 6 Color Register (the default color value is 7, yellow)

VICII_SP7COL  = $D01E
; Sprite 7 Color Register (the default color value is 12, medium gray)

; Location Range: 53295-53311 ($D02F-$D03F)
; Not Connected

; The VIC-II chip has only 47 registers for 64 bytes of possible address
; space.  Therefore, the remaining 17 addresses do not access any
; memory.  When read, they will always give a value of 255 ($FF).  This
; value will not change after writing to them.

; Location Range: 53312-54271 ($D040-$D3FF)
; VIC-II Register Images

; Since the VIC-II requires only enough addressing lines to handle 64
; locations (the minimum possible for its 47 registers), none of the
; higher bits are decoded when addressing this 1K area.  The result is
; that every 64 byte area in this 1K block is a mirror of every other.
; POKE53281+64,1 has the same effect as POKE53281,1 or
; POKE53281+10*64,1; they all turn the screen background to white.  For
; the sake of clarity in your programs it is advisable to use the base
; address of the chip.
