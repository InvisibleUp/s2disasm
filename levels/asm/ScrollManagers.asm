; ---------------------------------------------------------------------------
; JUMP TABLE FOR SOFTWARE SCROLL MANAGERS
;
; "Software scrolling" is my term for what Nemesis (and by extension, the rest
; of the world) calls "rasterized layer deformation".* Software scroll managers
; are needed to achieve certain special camera effects - namely, locking the
; screen for a boss fight and defining the limits of said screen lock, or in
; the case of Sky Chase Zone ($10), moving the camera at a fixed rate through
; a predefined course.
; They are also used for things like controlling the parallax scrolling and
; water ripple effects in EHZ, and moving the clouds in HTZ and the stars in DEZ.
; ---------------------------------------------------------------------------
SwScrl_Index: zoneOrderedOffsetTable 2,1	; JmpTbl_SwScrlMgr
	zoneOffsetTableEntry.w SwScrl_EHZ	; $00
	zoneOffsetTableEntry.w SwScrl_Minimal	; $01
	zoneOffsetTableEntry.w SwScrl_Lev2	; $02
	zoneOffsetTableEntry.w SwScrl_Minimal	; $03
	zoneOffsetTableEntry.w SwScrl_MTZ	; $04
	zoneOffsetTableEntry.w SwScrl_MTZ	; $05
	zoneOffsetTableEntry.w SwScrl_WFZ	; $06
	zoneOffsetTableEntry.w SwScrl_HTZ	; $07
	zoneOffsetTableEntry.w SwScrl_HPZ	; $08
	zoneOffsetTableEntry.w SwScrl_Minimal	; $09
	zoneOffsetTableEntry.w SwScrl_OOZ	; $0A
	zoneOffsetTableEntry.w SwScrl_MCZ	; $0B
	zoneOffsetTableEntry.w SwScrl_CNZ	; $0C
	zoneOffsetTableEntry.w SwScrl_CPZ	; $0D
	zoneOffsetTableEntry.w SwScrl_DEZ	; $0E
	zoneOffsetTableEntry.w SwScrl_ARZ	; $0F
	zoneOffsetTableEntry.w SwScrl_SCZ	; $10
    zoneTableEnd
; ===========================================================================
; loc_C51E:
SwScrl_Title:
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	addq.w	#1,(Camera_X_pos).w
	move.w	(Camera_X_pos).w,d2
	neg.w	d2
	asr.w	#2,d2
	lea	(Horiz_Scroll_Buf).w,a1
	moveq	#0,d0

	move.w	#bytesToLcnt($280),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0

	move.w	#bytesToLcnt($80),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d0,d3
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea	SwScrl_RippleData(pc),a2
	lea	(a2,d1.w),a2

	move.w	#bytesToLcnt($40),d1
-	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	rts
; ===========================================================================
; loc_C57E:
SwScrl_EHZ:
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_EHZ_2P
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	move.w	d0,d2
	swap	d0
	move.w	#0,d0

	move.w	#bytesToLcnt($58),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#6,d0

	move.w	#bytesToLcnt($E8),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d0,d3
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea	(SwScrl_RippleData).l,a2
	lea	(a2,d1.w),a2

	move.w	#bytesToLcnt($54),d1
-	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	move.w	#0,d0

	move.w	#bytesToLcnt($2C),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#4,d0

	move.w	#bytesToLcnt($40),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#4,d0
	move.w	d0,d1
	asr.w	#1,d1
	add.w	d1,d0

	move.w	#bytesToLcnt($40),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.l	d0,d4
	swap	d4
	move.w	d2,d0
	asr.w	#1,d0
	move.w	d2,d1
	asr.w	#3,d1
	sub.w	d1,d0
	ext.l	d0
	asl.l	#8,d0
	divs.w	#$30,d0
	ext.l	d0
	asl.l	#8,d0
	moveq	#0,d3
	move.w	d2,d3
	asr.w	#3,d3

	move.w	#bytesToLcnt($3C),d1 ; $3C bytes
-	move.w	d4,(a1)+
	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	move.w	#($48)/8-1,d1 ; $48 bytes
-	move.w	d4,(a1)+
	move.w	d3,(a1)+
	move.w	d4,(a1)+
	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	move.w	#($B4)/12-1,d1 ; $B4 bytes
-	move.w	d4,(a1)+
	move.w	d3,(a1)+
	move.w	d4,(a1)+
	move.w	d3,(a1)+
	move.w	d4,(a1)+
	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	; note there is a bug here. the bottom 8 pixels haven't had their hscroll values set. only the EHZ scrolling code has this bug.

	rts
; ===========================================================================
; horizontal offsets for the water rippling effect
; byte_C682:
SwScrl_RippleData:
	dc.b   1,  2,  1,  3,  1,  2,  2,  1,  2,  3,  1,  2,  1,  2,  0,  0; 16
	dc.b   2,  0,  3,  2,  2,  3,  2,  2,  1,  3,  0,  0,  1,  0,  1,  3; 32
	dc.b   1,  2,  1,  3,  1,  2,  2,  1,  2,  3,  1,  2,  1,  2,  0,  0; 48
	dc.b   2,  0,  3,  2,  2,  3,  2,  2,  1,  3,  0,  0,  1,  0,  1,  3; 64
	dc.b   1,  2	; 66
; ===========================================================================
; loc_C6C4:
SwScrl_EHZ_2P:
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_X_pos).w,d0
	move.w	#bytesToLcnt($2C),d1
	bsr.s	sub_C71A
	moveq	#0,d0
	move.w	d0,(Vscroll_Factor_P2_BG).w
	subi.w	#$E0,(Vscroll_Factor_P2_BG).w
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#$E0,(Vscroll_Factor_P2_FG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w
	lea	(Horiz_Scroll_Buf+$1B0).w,a1
	move.w	(Camera_X_pos_P2).w,d0
	move.w	#bytesToLcnt($3C),d1

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_C71A:
	neg.w	d0
	move.w	d0,d2
	swap	d0
	move.w	#0,d0

-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#6,d0

	move.w	#bytesToLcnt($74),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d0,d3
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea_	SwScrl_RippleData,a2
	lea	(a2,d1.w),a2

	move.w	#bytesToLcnt($2C),d1
-	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	move.w	#0,d0

	move.w	#bytesToLcnt($14),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#4,d0

	move.w	#bytesToLcnt($20),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#4,d0
	move.w	d0,d1
	asr.w	#1,d1
	add.w	d1,d0

	move.w	#bytesToLcnt($20),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#1,d0
	move.w	d2,d1
	asr.w	#3,d1
	sub.w	d1,d0
	ext.l	d0
	asl.l	#8,d0
	divs.w	#$30,d0
	ext.l	d0
	asl.l	#8,d0
	moveq	#0,d3
	move.w	d2,d3
	asr.w	#3,d3

	move.w	#bytesToLcnt($A0),d1
-	move.w	d2,(a1)+
	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	rts
; End of function sub_C71A

; ===========================================================================
; unused...
; loc_C7BA:
SwScrl_Lev2:
    if gameRevision<2
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#bytesToLcnt($380),d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-
    endif

	rts
; ===========================================================================
; loc_C7F2:
SwScrl_MTZ:
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#bytesToLcnt($380),d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	rts
; ===========================================================================
; loc_C82A:
SwScrl_WFZ:
	move.w	(Camera_BG_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#8,d4
	moveq	#2,d6
	bsr.w	SetHorizScrollFlagsBG
	move.w	(Camera_BG_Y_pos_diff).w,d5
	ext.l	d5
	lsl.l	#8,d5
	moveq	#6,d6
	bsr.w	SetVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	move.l	(Camera_BG_X_pos).w,d0
	; This can be removed if the getaway ship's entry uses d0 instead.
	move.l	d0,d1
	lea	(TempArray_LayerDef).w,a2
	move.l	d0,(a2)+				; Static parts of BG (generally no clouds in them)
	move.l	d1,(a2)+				; Eggman's getaway ship
	; Note: this is bugged: this tallies only the cloud speeds. It works fine
	; if you are standing still, but makes the clouds move faster when going
	; right and slower when going left. This is exactly the opposite of what
	; should happen.
	addi.l	#$8000,(a2)+			; Larger clouds
	addi.l	#$4000,(a2)+			; Medium clouds
	addi.l	#$2000,(a2)+			; Small clouds
	lea	(SwScrl_WFZ_Transition_Array).l,a3
	cmpi.w	#$2700,(Camera_X_pos).w
	bhs.s	.got_array
	lea	(SwScrl_WFZ_Normal_Array).l,a3

.got_array:
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	andi.w	#$7FF,d1
	moveq	#0,d0
	moveq	#0,d3

	; Find the first visible scrolling section
.seg_loop:
	move.b	(a3)+,d0				; Number of lines in this segment
	addq.w	#1,a3					; Skip index
	sub.w	d0,d1					; Does this segment have any visible lines?
	bcc.s	.seg_loop				; Branch if not

	neg.w	d1						; d1 = number of lines to draw in this segment
	move.w	#bytesToLcnt($380),d2	; Number of rows in hscroll buffer
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.b	-1(a3),d3				; Fetch TempArray_LayerDef index
	move.w	(a2,d3.w),d0			; Fetch scroll value for this row...
	neg.w	d0						; ... and flip sign for VDP

.row_loop:
	move.l	d0,(a1)+
	subq.w	#1,d1					; Has the current segment finished?
	bne.s	.next_row				; Branch if not
	move.b	(a3)+,d1				; Fetch a new line count
	move.b	(a3)+,d3				; Fetch TempArray_LayerDef index
	move.w	(a2,d3.w),d0			; Fetch scroll value for this row...
	neg.w	d0						; ... and flip sign for VDP

.next_row:
	dbf	d2,.row_loop

	rts
; ===========================================================================
; WFZ BG scrolling data
; Each pair of bytes corresponds to one scrolling segment of the BG, and
; the bytes have the following meaning:
; 	number of lines, index into TempArray_LayerDef
; byte_C8CA
SwScrl_WFZ_Transition_Array:
	dc.b $C0,  0,$C0,  0,$80,  0,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C
	dc.b $30,$10,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C,$30,$10,$20,  8; 16
	dc.b $30, $C,$30,$10,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C,$30,$10; 32
	dc.b $80,  4,$80,  4,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C,$30,$10; 48
	dc.b $20,  8,$30, $C,$30,$10,$C0,  0,$C0,  0,$80,  0; 64
;byte_C916
SwScrl_WFZ_Normal_Array:
	dc.b $C0,  0,$C0,  0,$80,  0,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C
	dc.b $30,$10,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C,$30,$10,$20,  8; 16
	dc.b $30, $C,$30,$10,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C,$30,$10; 32
	dc.b $20,  8,$30, $C,$30,$10,$20,  8,$30, $C,$30,$10,$20,  8,$30, $C; 48
	dc.b $30,$10,$20,  8,$30, $C,$30,$10,$C0,  0,$C0,  0,$80,  0; 64
; Note: this array is missing $80 lines compared to the transition array.
; This causes the lower clouds to read data from the start of SwScrl_HTZ.
; These are the missing entries:
    if 1==0
	dc.b $20,  8,$30, $C,$30,$10
    endif
; ===========================================================================
; loc_C964:
SwScrl_HTZ:
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_HTZ_2P	; never used in normal gameplay
	tst.b	(Screen_Shaking_Flag_HTZ).w
	bne.w	HTZ_Screen_Shake
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	move.w	d0,d2
	swap	d0
	move.w	d2,d0
	asr.w	#3,d0

	move.w	#bytesToLcnt($200),d1
-	move.l	d0,(a1)+
	dbf	d1,-

	move.l	d0,d4
	move.w	(TempArray_LayerDef+$22).w,d0
	addq.w	#4,(TempArray_LayerDef+$22).w
	sub.w	d0,d2
	move.w	d2,d0
	move.w	d0,d1
	asr.w	#1,d0
	asr.w	#4,d1
	sub.w	d1,d0
	ext.l	d0
	asl.l	#8,d0
	divs.w	#$70,d0
	ext.l	d0
	asl.l	#8,d0
	lea	(TempArray_LayerDef).w,a2
	moveq	#0,d3
	move.w	d1,d3
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a2)+
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a2)+
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a2)+
	move.w	d3,(a2)+
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3

	moveq	#3,d1
-	move.w	d3,(a2)+
	move.w	d3,(a2)+
	move.w	d3,(a2)+
	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	add.l	d0,d0
	add.l	d0,d0
	move.w	d3,d4
	move.l	d4,(a1)+
	move.l	d4,(a1)+
	move.l	d4,(a1)+
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4
	move.l	d4,(a1)+
	move.l	d4,(a1)+
	move.l	d4,(a1)+
	move.l	d4,(a1)+
	move.l	d4,(a1)+
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4

	move.w	#6,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4

	move.w	#7,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4

	move.w	#9,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	move.w	d3,d4

	move.w	#$E,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3

	move.w	#2,d2
-	move.w	d3,d4

	move.w	#$F,d1
-	move.l	d4,(a1)+
	dbf	d1,-

	swap	d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	add.l	d0,d3
	swap	d3
	dbf	d2,--

	rts
; ===========================================================================

;loc_CA92:
HTZ_Screen_Shake:
	move.w	(Camera_BG_X_pos_diff).w,d4
	ext.l	d4
	lsl.l	#8,d4
	moveq	#2,d6
	bsr.w	SetHorizScrollFlagsBG
	move.w	(Camera_BG_Y_pos_diff).w,d5
	ext.l	d5
	lsl.l	#8,d5
	moveq	#0,d6
	bsr.w	SetVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	move.w	(Camera_Y_pos).w,(Vscroll_Factor_FG).w
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	moveq	#0,d2
	tst.b	(Screen_Shaking_Flag).w
	beq.s	+

	move.w	(Timer_frames).w,d0
	andi.w	#$3F,d0
	lea_	SwScrl_RippleData,a1
	lea	(a1,d0.w),a1
	moveq	#0,d0
	move.b	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
	add.w	d0,(Vscroll_Factor_BG).w
	add.w	d0,(Camera_Y_pos_copy).w
	move.b	(a1)+,d2
	add.w	d2,(Camera_X_pos_copy).w
+
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#bytesToLcnt($380),d1
	move.w	(Camera_X_pos).w,d0
	add.w	d2,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	add.w	d2,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	rts
; ===========================================================================
; loc_CB10:
SwScrl_HTZ_2P:
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#6,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#2,d5
	moveq	#0,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.b	#0,(Scroll_flags_BG).w
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#bytesToLcnt($1C0),d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	move.w	(Camera_X_pos_diff_P2).w,d4
	ext.l	d4
	asl.l	#6,d4
	add.l	d4,(Camera_BG_X_pos_P2).w
	moveq	#0,d0
	move.w	d0,(Vscroll_Factor_P2_BG).w
	subi.w	#$E0,(Vscroll_Factor_P2_BG).w
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#$E0,(Vscroll_Factor_P2_FG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w
	lea	(Horiz_Scroll_Buf+$1B0).w,a1
	move.w	#bytesToLcnt($1D0),d1
	move.w	(Camera_X_pos_P2).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos_P2).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	rts
; ===========================================================================
; unused...
; loc_CBA0:
SwScrl_HPZ:
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#6,d4
	moveq	#2,d6
	bsr.w	SetHorizScrollFlagsBG
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#7,d5
	moveq	#6,d6
	bsr.w	SetVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(TempArray_LayerDef).w,a1
	move.w	(Camera_X_pos).w,d2
	neg.w	d2
	move.w	d2,d0
	asr.w	#1,d0

	move.w	#7,d1
-	move.w	d0,(a1)+
	dbf	d1,-

	move.w	d2,d0
	asr.w	#3,d0
	sub.w	d2,d0
	ext.l	d0
	asl.l	#3,d0
	divs.w	#8,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	moveq	#0,d3
	move.w	d2,d3
	asr.w	#1,d3
	lea	(TempArray_LayerDef+$60).w,a2
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a1)+
	move.w	d3,(a1)+
	move.w	d3,(a1)+
	move.w	d3,-(a2)
	move.w	d3,-(a2)
	move.w	d3,-(a2)
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a1)+
	move.w	d3,(a1)+
	move.w	d3,-(a2)
	move.w	d3,-(a2)
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a1)+
	move.w	d3,-(a2)
	swap	d3
	add.l	d0,d3
	swap	d3
	move.w	d3,(a1)+
	move.w	d3,-(a2)
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

	move.w	#$19,d1
-	move.w	d0,(a1)+
	dbf	d1,-

	adda.w	#$E,a1
	move.w	d2,d0
	asr.w	#1,d0

	move.w	#$17,d1
-	move.w	d0,(a1)+
	dbf	d1,-

	lea	(TempArray_LayerDef).w,a2
	move.w	(Camera_BG_Y_pos).w,d0
	move.w	d0,d2
	andi.w	#$3F0,d0
	lsr.w	#3,d0
	lea	(a2,d0.w),a2
	bra.w	SwScrl_HPZ_Continued
; ===========================================================================
; loc_CC66:
SwScrl_OOZ:
	move.w	(Camera_X_pos_diff).w,d0
	ext.l	d0
	asl.l	#5,d0
	add.l	d0,(Camera_BG_X_pos).w
	move.w	(Camera_Y_pos_diff).w,d0
	ext.l	d0
	asl.l	#5,d0
	move.l	(Camera_BG_Y_pos).w,d3
	add.l	d3,d0
	moveq	#4,d6
	bsr.w	SetVertiScrollFlagsBG2
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf+$380).w,a1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d7
	neg.w	d7
	move.w	(Camera_BG_Y_pos).w,d1
	subi.w	#$50,d1
	bcc.s	+
	moveq	#0,d1
+
	subi.w	#$B0,d1
	bcs.s	+
	moveq	#0,d1
+
	move.w	#$DF,d6
	add.w	d6,d1
	move.w	d7,d0
	bsr.s	OOZ_BGScroll_Lines
	bsr.s	OOZ_BGScroll_MediumClouds
	bsr.s	OOZ_BGScroll_SlowClouds
	bsr.s	OOZ_BGScroll_FastClouds
	move.w	d7,d0
	asr.w	#4,d0
	moveq	#6,d1
	bsr.s	OOZ_BGScroll_Lines
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	move.w	(TempArray_LayerDef).w,d1
	andi.w	#$1F,d1
	lea	SwScrl_RippleData(pc),a2
	lea	(a2,d1.w),a2

	moveq	#$20,d1
-	move.b	(a2)+,d0
	ext.w	d0
	move.l	d0,-(a1)
	subq.w	#1,d6
	bmi.s	+	; rts
	dbf	d1,-

	bsr.s	OOZ_BGScroll_MediumClouds
	bsr.s	OOZ_BGScroll_SlowClouds
	bsr.s	OOZ_BGScroll_FastClouds
	bsr.s	OOZ_BGScroll_SlowClouds
	bsr.s	OOZ_BGScroll_MediumClouds
	move.w	d7,d0
	moveq	#$47,d1
	bsr.s	OOZ_BGScroll_Lines
+	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_CD0A
OOZ_BGScroll_FastClouds:
	move.w	d7,d0
	asr.w	#2,d0
	bra.s	+
; End of function OOZ_BGScroll_FastClouds


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_CD10
OOZ_BGScroll_MediumClouds:
	move.w	d7,d0
	asr.w	#3,d0
	bra.s	+
; End of function OOZ_BGScroll_MediumClouds


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_CD16
OOZ_BGScroll_SlowClouds:
	move.w	d7,d0
	asr.w	#4,d0

+
	moveq	#7,d1
; End of function OOZ_BGScroll_SlowClouds


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Scrolls min(d6,d1+1) lines by an (constant) amount specified in d0

;sub_CD1C
OOZ_BGScroll_Lines:
	move.l	d0,-(a1)
	subq.w	#1,d6
	bmi.s	+
	dbf	d1,OOZ_BGScroll_Lines

	rts
; ===========================================================================
+
	addq.l	#4,sp
	rts
; End of function OOZ_BGScroll_Lines

; ===========================================================================
; loc_CD2C:
SwScrl_MCZ:
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_MCZ_2P
	move.w	(Camera_Y_pos).w,d0
	move.l	(Camera_BG_Y_pos).w,d3
	tst.b	(Current_Act).w
	bne.s	+
	divu.w	#3,d0
	subi.w	#$140,d0
	bra.s	++
; ===========================================================================
+
	divu.w	#6,d0
	subi.w	#$10,d0
+
	swap	d0
	moveq	#6,d6
	bsr.w	SetVertiScrollFlagsBG2
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	moveq	#0,d2
	tst.b	(Screen_Shaking_Flag).w
	beq.s	+

	move.w	(Timer_frames).w,d0
	andi.w	#$3F,d0
	lea_	SwScrl_RippleData,a1
	lea	(a1,d0.w),a1
	moveq	#0,d0
	move.b	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
	add.w	d0,(Vscroll_Factor_BG).w
	add.w	d0,(Camera_Y_pos_copy).w
	move.b	(a1)+,d2
	add.w	d2,(Camera_X_pos_copy).w
+
	lea	(TempArray_LayerDef).w,a2
	lea	$1E(a2),a3
	move.w	(Camera_X_pos).w,d0
	ext.l	d0
	asl.l	#4,d0
	divs.w	#$A,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	move.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$E(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$C(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$A(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,8(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,6(a2)
	move.w	d1,$10(a2)
	move.w	d1,$1C(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,4(a2)
	move.w	d1,$12(a2)
	move.w	d1,$1A(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,2(a2)
	move.w	d1,$14(a2)
	move.w	d1,$18(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,(a2)
	move.w	d1,$16(a2)
	lea	(SwScrl_MCZ_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	moveq	#0,d0

-	move.b	(a3)+,d0
	addq.w	#2,a2
	sub.w	d0,d1
	bcc.s	-

	neg.w	d1
	subq.w	#2,a2
	move.w	#bytesToLcnt($380),d2
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0
	neg.w	d0

-	move.l	d0,(a1)+
	subq.w	#1,d1
	bne.s	+
	move.b	(a3)+,d1
	move.w	(a2)+,d0
	neg.w	d0
+	dbf	d2,-

	rts
; ===========================================================================
; byte_CE6C:
SwScrl_MCZ_RowHeights:
	dc.b $25
	dc.b $17	; 1
	dc.b $12	; 2
	dc.b   7	; 3
	dc.b   7	; 4
	dc.b   2	; 5
	dc.b   2	; 6
	dc.b $30	; 7
	dc.b  $D	; 8
	dc.b $13	; 9
	dc.b $20	; 10
	dc.b $40	; 11
	dc.b $20	; 12
	dc.b $13	; 13
	dc.b  $D	; 14
	dc.b $30	; 15
	dc.b   2	; 16
	dc.b   2	; 17
	dc.b   7	; 18
	dc.b   7	; 19
	dc.b $20	; 20
	dc.b $12	; 21
	dc.b $17	; 22
	dc.b $25	; 23
	even
; ===========================================================================
; loc_CE84:
SwScrl_MCZ_2P:
	moveq	#0,d0
	move.w	(Camera_Y_pos).w,d0
	tst.b	(Current_Act).w
	bne.s	+
	divu.w	#3,d0
	subi.w	#$140,d0
	bra.s	++
; ===========================================================================
+
	divu.w	#6,d0
	subi.w	#$10,d0
+
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	d0,(Vscroll_Factor_BG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor).w
	lea	(TempArray_LayerDef).w,a2
	lea	$1E(a2),a3
	move.w	(Camera_X_pos).w,d0
	ext.l	d0
	asl.l	#4,d0
	divs.w	#$A,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	move.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$E(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$C(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$A(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,8(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,6(a2)
	move.w	d1,$10(a2)
	move.w	d1,$1C(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,4(a2)
	move.w	d1,$12(a2)
	move.w	d1,$1A(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,2(a2)
	move.w	d1,$14(a2)
	move.w	d1,$18(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,(a2)
	move.w	d1,$16(a2)
	lea	(SwScrl_MCZ2P_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	lsr.w	#1,d1
	moveq	#0,d0

-	move.b	(a3)+,d0
	addq.w	#2,a2
	sub.w	d0,d1
	bcc.s	-

	neg.w	d1
	subq.w	#2,a2
	move.w	#bytesToLcnt($1C0),d2
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0
	neg.w	d0

-	move.l	d0,(a1)+
	subq.w	#1,d1
	bne.s	+
	move.b	(a3)+,d1
	move.w	(a2)+,d0
	neg.w	d0
+	dbf	d2,-

	bra.s	+
; ===========================================================================
; byte_CF90:
SwScrl_MCZ2P_RowHeights:
	dc.b $13
	dc.b  $B
	dc.b   9	; 1
	dc.b   4	; 2
	dc.b   3	; 3
	dc.b   1	; 4
	dc.b   1	; 5
	dc.b $18	; 6
	dc.b   6	; 7
	dc.b  $A	; 8
	dc.b $10	; 9
	dc.b $20	; 10
	dc.b $10	; 11
	dc.b  $A	; 12
	dc.b   6	; 13
	dc.b $18	; 14
	dc.b   1	; 15
	dc.b   1	; 16
	dc.b   3	; 17
	dc.b   4	; 18
	dc.b $10	; 19
	dc.b   9	; 20
	dc.b  $B	; 21
	dc.b $13	; 22
	even
; ===========================================================================
+
	moveq	#0,d0
	move.w	(Camera_Y_pos_P2).w,d0
	tst.b	(Current_Act).w
	bne.s	+
	divu.w	#3,d0
	subi.w	#$140,d0
	bra.s	++
; ===========================================================================
+
	divu.w	#6,d0
	subi.w	#$10,d0
+
	move.w	d0,(Camera_BG_Y_pos_P2).w
	move.w	d0,(Vscroll_Factor_P2_BG).w
	subi.w	#$E0,(Vscroll_Factor_P2_BG).w
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#$E0,(Vscroll_Factor_P2_FG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w
	lea	(TempArray_LayerDef).w,a2
	lea	$1E(a2),a3
	move.w	(Camera_X_pos_P2).w,d0
	ext.l	d0
	asl.l	#4,d0
	divs.w	#$A,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	move.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$E(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$C(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,$A(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,8(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,6(a2)
	move.w	d1,$10(a2)
	move.w	d1,$1C(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,4(a2)
	move.w	d1,$12(a2)
	move.w	d1,$1A(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,2(a2)
	move.w	d1,$14(a2)
	move.w	d1,$18(a2)
	swap	d1
	add.l	d0,d1
	swap	d1
	move.w	d1,(a3)+
	move.w	d1,(a2)
	move.w	d1,$16(a2)
	lea_	SwScrl_MCZ2P_RowHeights+1,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf+$1B0).w,a1
	move.w	(Camera_BG_Y_pos_P2).w,d1
	lsr.w	#1,d1
	moveq	#$17,d0
	bra.s	+
; ===========================================================================
-
	move.b	(a3)+,d0
+
	addq.w	#2,a2
	sub.w	d0,d1
	bcc.s	-

	neg.w	d1
	subq.w	#2,a2
	move.w	#bytesToLcnt($1D0),d2
	move.w	(Camera_X_pos_P2).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0
	neg.w	d0

-	move.l	d0,(a1)+
	subq.w	#1,d1
	bne.s	+
	move.b	(a3)+,d1
	move.w	(a2)+,d0
	neg.w	d0
+	dbf	d2,-

	rts
; ===========================================================================
; loc_D0C6:
SwScrl_CNZ:
	tst.w	(Two_player_mode).w
	bne.w	SwScrl_CNZ_2P
	move.w	(Camera_Y_pos).w,d0
	lsr.w	#6,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	move.w	(Camera_X_pos).w,d2
	bsr.w	sub_D160
	lea	(SwScrl_CNZ_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	moveq	#0,d0

-	move.b	(a3)+,d0
	addq.w	#2,a2
	sub.w	d0,d1
	bcc.s	-

	neg.w	d1
	subq.w	#2,a2
	move.w	#bytesToLcnt($380),d2
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0
	neg.w	d0

-	move.l	d0,(a1)+
	subq.w	#1,d1
	bne.s	+

-	move.w	(a2)+,d0
	neg.w	d0
	move.b	(a3)+,d1
	beq.s	++
+	dbf	d2,--

	rts
; ===========================================================================
+
	move.w	#bytesToLcnt($40),d1
	move.w	d0,d3
	move.b	(Vint_runcount+3).w,d0
	lsr.w	#3,d0
	neg.w	d0
	andi.w	#$1F,d0
	lea_	SwScrl_RippleData,a4
	lea	(a4,d0.w),a4

-	move.b	(a4)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	subi.w	#$10,d2
	bra.s	--
; ===========================================================================
; byte_D156:
SwScrl_CNZ_RowHeights:
	dc.b  $10
	dc.b  $10	; 1
	dc.b  $10	; 2
	dc.b  $10	; 3
	dc.b  $10	; 4
	dc.b  $10	; 5
	dc.b  $10	; 6
	dc.b  $10	; 7
	dc.b    0	; 8
	dc.b -$10	; 9
	even

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_D160:
	lea	(TempArray_LayerDef).w,a1
	move.w	d2,d0
	asr.w	#3,d0
	sub.w	d2,d0
	ext.l	d0
	asl.l	#5,d0
	asl.l	#8,d0
	moveq	#0,d3
	move.w	d2,d3

	move.w	#6,d1
-	move.w	d3,(a1)+
	swap	d3
	add.l	d0,d3
	swap	d3
	dbf	d1,-

	move.w	d2,d0
	asr.w	#3,d0
	move.w	d0,4(a1)
	asr.w	#1,d0
	move.w	d0,(a1)+
	move.w	d0,(a1)+
	rts
; End of function sub_D160

; ===========================================================================
; loc_D194:
SwScrl_CNZ_2P:
	move.w	(Camera_Y_pos).w,d0
	lsr.w	#6,d0
	move.w	d0,(Camera_BG_Y_pos).w
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor).w
	move.w	(Camera_X_pos).w,d2
	bsr.w	sub_D160
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	moveq	#0,d0
	move.w	(Camera_X_pos).w,d0
	move.w	#$6F,d2
	lea	(SwScrl_CNZ2P_RowHeights+2).l,a3
	bsr.s	sub_D216
	move.w	(Camera_Y_pos_P2).w,d0
	lsr.w	#6,d0
	move.w	d0,(Camera_BG_Y_pos_P2).w
	move.w	d0,(Vscroll_Factor_P2_BG).w
	subi.w	#$E0,(Vscroll_Factor_P2_BG).w
	move.w	(Camera_Y_pos_P2).w,(Vscroll_Factor_P2_FG).w
	subi.w	#$E0,(Vscroll_Factor_P2_FG).w
	andi.l	#$FFFEFFFE,(Vscroll_Factor_P2).w
	move.w	(Camera_X_pos_P2).w,d2
	bsr.w	sub_D160
	lea	(Horiz_Scroll_Buf+$1B0).w,a1
	move.w	(Camera_BG_Y_pos_P2).w,d1
	moveq	#0,d0
	move.w	(Camera_X_pos_P2).w,d0
	move.w	#bytesToLcnt($1D0),d2
	lea	(SwScrl_CNZ2P_RowHeights+1).l,a3

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_D216:
	lsr.w	#1,d1
	lea	(TempArray_LayerDef).w,a2
	moveq	#0,d3

-	move.b	(a3)+,d3
	addq.w	#2,a2
	sub.w	d3,d1
	bcc.s	-

	neg.w	d1
	subq.w	#2,a2
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0
	neg.w	d0

-	move.l	d0,(a1)+
	subq.w	#1,d1
	bne.s	+

-	move.w	(a2)+,d0
	neg.w	d0
	move.b	(a3)+,d1
	beq.s	++
+
	dbf	d2,--

	rts
; ===========================================================================
+
	move.w	#bytesToLcnt($20),d1
	move.w	d0,d3
	move.b	(Vint_runcount+3).w,d0
	lsr.w	#3,d0
	neg.w	d0
	andi.w	#$1F,d0
	lea_	SwScrl_RippleData,a4
	lea	(a4,d0.w),a4

-	move.b	(a4)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d1,-

	subq.w	#8,d2
	bra.s	--
; End of function sub_D216

; ===========================================================================
; byte_D270:
SwScrl_CNZ2P_RowHeights:
	dc.b   4
	dc.b   4	; 1
	dc.b   8	; 2
	dc.b   8	; 3
	dc.b   8	; 4
	dc.b   8	; 5
	dc.b   8	; 6
	dc.b   8	; 7
	dc.b   8	; 8
	dc.b   8	; 9
	dc.b   0	; 10
	dc.b $78	; 11
	even
; ===========================================================================
; loc_D27C:
SwScrl_CPZ:
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#7,d4
	moveq	#4,d6
	bsr.w	SetHorizScrollFlagsBG2
	move.w	(Camera_BG_Y_pos).w,d0
	move.w	d0,(Camera_BG2_Y_pos).w
	move.w	d0,(Vscroll_Factor_BG).w
	move.b	(Scroll_flags_BG).w,d0
	or.b	(Scroll_flags_BG2).w,d0
	move.b	d0,(Scroll_flags_BG3).w
	clr.b	(Scroll_flags_BG).w
	clr.b	(Scroll_flags_BG2).w
	move.b	(Vint_runcount+3).w,d1
	andi.w	#7,d1
	bne.s	+
	subq.w	#1,(TempArray_LayerDef).w
+
	lea	(CPZ_CameraSections+1).l,a0
	move.w	(Camera_BG_Y_pos).w,d0
	move.w	d0,d2
	andi.w	#$3F0,d0
	lsr.w	#4,d0
	lea	(a0,d0.w),a0
	move.w	d0,d4
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#$E,d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	andi.w	#$F,d2
	move.w	(Camera_BG_X_pos).w,d0
	cmpi.b	#$12,d4
	beq.s	loc_D34A
	blo.s	+
	move.w	(Camera_BG2_X_pos).w,d0
+
	neg.w	d0
	add.w	d2,d2
	jmp	++(pc,d2.w)
; ===========================================================================

-	move.w	(Camera_BG_X_pos).w,d0
	cmpi.b	#$12,d4
	beq.s	+++
	blo.s	+
	move.w	(Camera_BG2_X_pos).w,d0
+
	neg.w	d0

+   rept 16
	move.l	d0,(a1)+
    endm
	addq.b	#1,d4
	dbf	d1,-
	rts
; ===========================================================================

loc_D34A:
	move.w	#bytesToLcnt($40),d0
	sub.w	d2,d0
	move.w	d0,d2
	bra.s	++
; ===========================================================================
+
	move.w	#$F,d2
+
	move.w	(Camera_BG_X_pos).w,d3
	neg.w	d3
	move.w	(TempArray_LayerDef).w,d0
	andi.w	#$1F,d0
	lea_	SwScrl_RippleData,a2
	lea	(a2,d0.w),a2

-	move.b	(a2)+,d0
	ext.w	d0
	add.w	d3,d0
	move.l	d0,(a1)+
	dbf	d2,-

	addq.b	#1,d4
	dbf	d1,--
	rts
; ===========================================================================
; loc_D382:
SwScrl_DEZ:
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#8,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#8,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	move.w	(Camera_X_pos).w,d4
	lea	(TempArray_LayerDef).w,a2
	move.w	d4,(a2)+

	addq.w	#3,(a2)+ ; these random-seeming numbers control how fast each row of stars scrolls by
	addq.w	#2,(a2)+
	addq.w	#4,(a2)+
	addq.w	#1,(a2)+
	addq.w	#2,(a2)+
	addq.w	#4,(a2)+
	addq.w	#3,(a2)+
	addq.w	#4,(a2)+
	addq.w	#2,(a2)+
	addq.w	#6,(a2)+
	addq.w	#3,(a2)+
	addq.w	#4,(a2)+
	addq.w	#1,(a2)+
	addq.w	#2,(a2)+
	addq.w	#4,(a2)+
	addq.w	#3,(a2)+
	addq.w	#2,(a2)+
	addq.w	#3,(a2)+
	addq.w	#4,(a2)+
	addq.w	#1,(a2)+
	addq.w	#3,(a2)+
	addq.w	#4,(a2)+
	addq.w	#2,(a2)+
	addq.w	#1,(a2)

	move.w	(a2)+,d0 ; this is to make one row go at half speed (1 pixel every other frame)
	moveq	#0,d1
	move.w	d0,d1
	lsr.w	#1,d0
	move.w	d0,(a2)+

	addq.w	#3,(a2)+ ; more star speeds...
	addq.w	#2,(a2)+
	addq.w	#4,(a2)+

	swap	d1
	move.l	d1,d0
	lsr.l	#3,d1
	sub.l	d1,d0
	swap	d0
	move.w	d0,4(a2)
	swap	d0
	sub.l	d1,d0
	swap	d0
	move.w	d0,2(a2)
	swap	d0
	sub.l	d1,d0
	swap	d0
	move.w	d0,(a2)+
	addq.w	#4,a2
	addq.w	#1,(a2)+
	move.w	d4,(a2)+
	move.w	d4,(a2)+
	move.w	d4,(a2)+
	lea	(SwScrl_DEZ_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	moveq	#0,d0

-	move.b	(a3)+,d0
	addq.w	#2,a2
	sub.w	d0,d1
	bcc.s	-

	neg.w	d1
	subq.w	#2,a2
	move.w	#bytesToLcnt($380),d2
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(a2)+,d0
	neg.w	d0

-	move.l	d0,(a1)+
	subq.w	#1,d1
	bne.s	+
	move.b	(a3)+,d1
	move.w	(a2)+,d0
	neg.w	d0
+	dbf	d2,-

	moveq	#0,d2
	tst.b	(Screen_Shaking_Flag).w
	beq.s	++	; rts
	subq.w	#1,(DEZ_Shake_Timer).w
	bpl.s	+
	clr.b	(Screen_Shaking_Flag).w
+
	move.w	(Timer_frames).w,d0
	andi.w	#$3F,d0
	lea_	SwScrl_RippleData,a1
	lea	(a1,d0.w),a1
	moveq	#0,d0
	move.b	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
	add.w	d0,(Vscroll_Factor_BG).w
	add.w	d0,(Camera_Y_pos_copy).w
	move.b	(a1)+,d2
	add.w	d2,(Camera_X_pos_copy).w
+
	rts
; ===========================================================================
; byte_D48A:
SwScrl_DEZ_RowHeights:
	dc.b $80
	dc.b   8	; 1
	dc.b   8	; 2
	dc.b   8	; 3
	dc.b   8	; 4
	dc.b   8	; 5
	dc.b   8	; 6
	dc.b   8	; 7
	dc.b   8	; 8
	dc.b   8	; 9
	dc.b   8	; 10
	dc.b   8	; 11
	dc.b   8	; 12
	dc.b   8	; 13
	dc.b   8	; 14
	dc.b   8	; 15
	dc.b   8	; 16
	dc.b   8	; 17
	dc.b   8	; 18
	dc.b   8	; 19
	dc.b   8	; 20
	dc.b   8	; 21
	dc.b   8	; 22
	dc.b   8	; 23
	dc.b   8	; 24
	dc.b   8	; 25
	dc.b   8	; 26
	dc.b   8	; 27
	dc.b   8	; 28
	dc.b   3	; 29
	dc.b   5	; 30
	dc.b   8	; 31
	dc.b $10	; 32
	dc.b $80	; 33
	dc.b $80	; 34
	dc.b $80	; 35
	even
; ===========================================================================
; loc_D4AE:
SwScrl_ARZ:
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	muls.w	#$119,d4
	moveq	#2,d6
	bsr.w	SetHorizScrollFlagsBG_ARZ
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#7,d5
	tst.b	(Current_Act).w
	bne.s	+
	asl.l	#1,d5
+
	moveq	#6,d6
	bsr.w	SetVertiScrollFlagsBG

	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w

	moveq	#0,d2
	tst.b	(Screen_Shaking_Flag).w
	beq.s	.screenNotShaking

	move.w	(Timer_frames).w,d0
	andi.w	#$3F,d0
	lea_	SwScrl_RippleData,a1
	lea	(a1,d0.w),a1
	moveq	#0,d0
	; Shake camera Y-pos (note that BG scrolling is not affected by this, causing it to distort)
	move.b	(a1)+,d0
	add.w	d0,(Vscroll_Factor_FG).w
	add.w	d0,(Vscroll_Factor_BG).w
	add.w	d0,(Camera_Y_pos_copy).w
	; Shake camera X-pos
	move.b	(a1)+,d2
	add.w	d2,(Camera_X_pos_copy).w

.screenNotShaking:
	lea	(TempArray_LayerDef).w,a2	; Starts at BG scroll row 1
	lea	6(a2),a3			; Starts at BG scroll row 4

	; Set up the speed of each row (there are 16 rows in total)
	move.w	(Camera_X_pos).w,d0
	ext.l	d0
	asl.l	#4,d0
	divs.w	#$A,d0
	ext.l	d0
	asl.l	#4,d0
	asl.l	#8,d0
	move.l	d0,d1

	; Set row 4's speed
	swap	d1
	move.w	d1,(a3)+	; Top row of background moves 10 ($A) times slower than foreground
	swap	d1
	add.l	d1,d1
	add.l	d0,d1
	; Set rows 5-10's speed
    rept 6
	swap	d1
	move.w	d1,(a3)+	; Next row moves 3 times faster than top row, then next row is 4 times faster, then 5, etc.
	swap	d1
	add.l	d0,d1
    endm
	; Set row 11's speed
	swap	d1
	move.w	d1,(a3)+

	; These instructions reveal that ARZ had slightly different scrolling,
	; at one point:
	; Above the background's mountains is a row of leaves, which is actually
	; composed of three separately-scrolling rows. According to this code,
	; the first and third rows were meant to scroll at a different speed to the
	; second. Possibly due to how bad it looks, the speed values are overwritten
	; a few instructions later, so all three move at the same speed.
	; This code seems to pre-date the Simon Wai build, which uses the final's
	; scrolling.
	move.w	d1,(a2)		; Set row 1's speed
	move.w	d1,4(a2)	; Set row 3's speed

	move.w	(Camera_BG_X_pos).w,d0
	move.w	d0,2(a2)	; Set row 2's speed
	move.w	d0,$16(a2)	; Set row 12's speed
	_move.w	d0,0(a2)	; Overwrite row 1's speed (now same as row 2's)
	move.w	d0,4(a2)	; Overwrite row 3's speed (now same as row 2's)
	move.w	d0,$18(a2)	; Set row 13's speed
	move.w	d0,$1A(a2)	; Set row 14's speed
	move.w	d0,$1C(a2)	; Set row 15's speed
	move.w	d0,$1E(a2)	; Set row 16's speed

	lea	(SwScrl_ARZ_RowHeights).l,a3
	lea	(TempArray_LayerDef).w,a2
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	(Camera_BG_Y_pos).w,d1
	moveq	#0,d0

	; Find which row of background is visible at the top of the screen
.findTopRowLoop:
	move.b	(a3)+,d0	; Get row height
	addq.w	#2,a2		; Next row speed (note: is off by 2. This is fixed below)
	sub.w	d0,d1
	bcc.s	.findTopRowLoop		; If current row is above the screen, loop and do next row

	neg.w	d1	; d1 now contains how many pixels of the row is currently on-screen
	subq.w	#2,a2	; Get correct row speed

	move.w	#bytesToLcnt($380),d2	; Actual size of Horiz_Scroll_Buf
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0		; Store FG X-pos in upper 16-bits...
	move.w	(a2)+,d0	; ...and BG X-pos in lower 16 bits, as Horiz_Scroll_Buf expects it
	neg.w	d0

-	move.l	d0,(a1)+	; Write 1 FG Horizontal Scroll value, and 1 BG Horizontal Scroll value
	subq.w	#1,d1		; Loop until row at top of screen is done
	bne.s	+
	move.b	(a3)+,d1	; Once that row is done, go to next row...
	move.w	(a2)+,d0	; ...and use next speed
	neg.w	d0
+	dbf	d2,-		; Loop until Horiz_Scroll_Buf is full

	rts
; ===========================================================================
; byte_D5CE:
SwScrl_ARZ_RowHeights:
	dc.b $B0
	dc.b $70	; 1
	dc.b $30	; 2
	dc.b $60	; 3
	dc.b $15	; 4
	dc.b  $C	; 5
	dc.b  $E	; 6
	dc.b   6	; 7
	dc.b  $C	; 8
	dc.b $1F	; 9
	dc.b $30	; 10
	dc.b $C0	; 11
	dc.b $F0	; 12
	dc.b $F0	; 13
	dc.b $F0	; 14
	dc.b $F0	; 15
	even
; ===========================================================================
; loc_D5DE:
SwScrl_SCZ:
	tst.w	(Debug_placement_mode).w
	bne.w	SwScrl_Minimal
	lea	(Camera_X_pos).w,a1
	lea	(Scroll_flags).w,a3
	lea	(Camera_X_pos_diff).w,a4
	move.w	(Tornado_Velocity_X).w,d0
	move.w	(a1),d4
	add.w	(a1),d0
	move.w	d0,d1
	sub.w	(a1),d1
	asl.w	#8,d1
	move.w	d0,(a1)
	move.w	d1,(a4)
	lea	(Horiz_block_crossed_flag).w,a2
	bsr.w	SetHorizScrollFlags
	lea	(Camera_Y_pos).w,a1
	lea	(Camera_Y_pos_diff).w,a4
	move.w	(Tornado_Velocity_Y).w,d0
	move.w	(a1),d4
	add.w	(a1),d0
	move.w	d0,d1
	sub.w	(a1),d1
	asl.w	#8,d1
	move.w	d0,(a1)
	move.w	d1,(a4)
	lea	(Verti_block_crossed_flag).w,a2
	bsr.w	SetVertiScrollFlags
	move.w	(Camera_X_pos_diff).w,d4
	beq.s	+
	move.w	#$100,d4
+
	ext.l	d4
	asl.l	#7,d4
	moveq	#0,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#bytesToLcnt($380),d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	rts
; ===========================================================================
; loc_D666:
SwScrl_Minimal:
	move.w	(Camera_X_pos_diff).w,d4
	ext.l	d4
	asl.l	#5,d4
	move.w	(Camera_Y_pos_diff).w,d5
	ext.l	d5
	asl.l	#6,d5
	bsr.w	SetHorizVertiScrollFlagsBG
	move.w	(Camera_BG_Y_pos).w,(Vscroll_Factor_BG).w
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#bytesToLcnt($380),d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	move.w	(Camera_BG_X_pos).w,d0
	neg.w	d0

-	move.l	d0,(a1)+
	dbf	d1,-

	rts
; ===========================================================================
; unused...
; loc_D69E:
SwScrl_HPZ_Continued:
	lea	(Horiz_Scroll_Buf).w,a1
	move.w	#$E,d1
	move.w	(Camera_X_pos).w,d0
	neg.w	d0
	swap	d0
	andi.w	#$F,d2
	add.w	d2,d2
	move.w	(a2)+,d0
	jmp	+(pc,d2.w)
; ===========================================================================

-	move.w	(a2)+,d0

+   rept 16
	move.l	d0,(a1)+
    endm
	dbf	d1,-

	rts