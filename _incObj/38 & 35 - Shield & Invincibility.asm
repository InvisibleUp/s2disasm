; ----------------------------------------------------------------------------
; Object 38 - Shield
; ----------------------------------------------------------------------------
; Sprite_1D8F2:
Obj38:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj38_Index(pc,d0.w),d1
	jmp	Obj38_Index(pc,d1.w)
; ===========================================================================
; off_1D900:
Obj38_Index:	offsetTable
		offsetTableEntry.w Obj38_Main	; 0
		offsetTableEntry.w Obj38_Shield	; 2
; ===========================================================================
; loc_1D904:
Obj38_Main:
	addq.b	#2,routine(a0)
	move.l	#Obj38_MapUnc_1DBE4,mappings(a0)
	move.b	#4,render_flags(a0)
	move.b	#1,priority(a0)
	move.b	#$18,width_pixels(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Shield,0,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
; loc_1D92C:
Obj38_Shield:
	movea.w	parent(a0),a2 ; a2=character
	btst	#status_sec_isInvincible,status_secondary(a2)
	bne.s	return_1D976
	btst	#status_sec_hasShield,status_secondary(a2)
	beq.s	JmpTo7_DeleteObject
	move.w	x_pos(a2),x_pos(a0)
	move.w	y_pos(a2),y_pos(a0)
	move.b	status(a2),status(a0)
	andi.w	#drawing_mask,art_tile(a0)
	tst.w	art_tile(a2)
	bpl.s	Obj38_Display
	ori.w	#high_priority,art_tile(a0)
; loc_1D964:
Obj38_Display:
	lea	(Ani_obj38).l,a1
	jsr	(AnimateSprite).l
	jmp	(DisplaySprite).l
; ===========================================================================

return_1D976:
	rts
; ===========================================================================

JmpTo7_DeleteObject 
	jmp	(DeleteObject).l

; ----------------------------------------------------------------------------
; Object 35 - Invincibility Stars
; ----------------------------------------------------------------------------
; Sprite_1D97E:
Obj35:
	moveq	#0,d0
	move.b	objoff_A(a0),d0
	move.w	Obj35_Index(pc,d0.w),d1
	jmp	Obj35_Index(pc,d1.w)
; ===========================================================================
; off_1D98C:
Obj35_Index:	offsetTable
		offsetTableEntry.w loc_1D9A4	; 0
		offsetTableEntry.w loc_1DA0C	; 2
		offsetTableEntry.w loc_1DA80	; 4

off_1D992:
	dc.l byte_1DB8F
	dc.w $B
	dc.l byte_1DBA4
	dc.w $160D
	dc.l byte_1DBBD
	dc.w $2C0D
; ===========================================================================

loc_1D9A4:
	moveq	#0,d2
	lea	off_1D992-6(pc),a2
	lea	(a0),a1

	moveq	#3,d1
-	_move.b	id(a0),id(a1) ; load obj35
	move.b	#4,objoff_A(a1)		; => loc_1DA80
	move.l	#Obj35_MapUnc_1DCBC,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Invincible_stars,0,0),art_tile(a1)
	bsr.w	Adjust2PArtPointer2
	move.b	#4,render_flags(a1)
	bset	#6,render_flags(a1)
	move.b	#$10,mainspr_width(a1)
	move.b	#2,mainspr_childsprites(a1)
	move.w	parent(a0),parent(a1)
	move.b	d2,objoff_36(a1)
	addq.w	#1,d2
	move.l	(a2)+,objoff_30(a1)
	move.w	(a2)+,objoff_34(a1)
	lea	next_object(a1),a1 ; a1=object
	dbf	d1,-

	move.b	#2,objoff_A(a0)		; => loc_1DA0C
	move.b	#4,objoff_34(a0)

loc_1DA0C:
	movea.w	parent(a0),a1 ; a1=character
	btst	#status_sec_isInvincible,status_secondary(a1)
	beq.w	DeleteObject
	move.w	x_pos(a1),d0
	move.w	d0,x_pos(a0)
	move.w	y_pos(a1),d1
	move.w	d1,y_pos(a0)
	lea	sub2_x_pos(a0),a2
	lea	byte_1DB82(pc),a3
	moveq	#0,d5

loc_1DA34:
	move.w	objoff_38(a0),d2
	move.b	(a3,d2.w),d5
	bpl.s	loc_1DA44
	clr.w	objoff_38(a0)
	bra.s	loc_1DA34
; ===========================================================================

loc_1DA44:
	addq.w	#1,objoff_38(a0)
	lea	byte_1DB42(pc),a6
	move.b	objoff_34(a0),d6
	jsr	loc_1DB2C(pc)
	move.w	d2,(a2)+	; sub2_x_pos
	move.w	d3,(a2)+	; sub2_y_pos
	move.w	d5,(a2)+	; sub2_mapframe
	addi.w	#$20,d6
	jsr	loc_1DB2C(pc)
	move.w	d2,(a2)+	; sub3_x_pos
	move.w	d3,(a2)+	; sub3_y_pos
	move.w	d5,(a2)+	; sub3_mapframe
	moveq	#$12,d0
	btst	#0,status(a1)
	beq.s	loc_1DA74
	neg.w	d0

loc_1DA74:
	add.b	d0,objoff_34(a0)
	move.w	#$80,d0
	bra.w	DisplaySprite3
; ===========================================================================

loc_1DA80:
	movea.w	parent(a0),a1 ; a1=character
	btst	#status_sec_isInvincible,status_secondary(a1)
	beq.w	DeleteObject
	cmpi.w	#2,(Player_mode).w
	beq.s	loc_1DAA4
	lea	(Sonic_Pos_Record_Index).w,a5
	lea	(Sonic_Pos_Record_Buf).w,a6
	tst.b	parent+1(a0)
	beq.s	loc_1DAAC

loc_1DAA4:
	lea	(Tails_Pos_Record_Index).w,a5
	lea	(Tails_Pos_Record_Buf).w,a6

loc_1DAAC:
	move.b	objoff_36(a0),d1
	lsl.b	#2,d1
	move.w	d1,d2
	add.w	d1,d1
	add.w	d2,d1
	move.w	(a5),d0
	sub.b	d1,d0
	lea	(a6,d0.w),a2
	move.w	(a2)+,d0
	move.w	(a2)+,d1
	move.w	d0,x_pos(a0)
	move.w	d1,y_pos(a0)
	lea	sub2_x_pos(a0),a2
	movea.l	objoff_30(a0),a3

loc_1DAD4:
	move.w	objoff_38(a0),d2
	move.b	(a3,d2.w),d5
	bpl.s	loc_1DAE4
	clr.w	objoff_38(a0)
	bra.s	loc_1DAD4
; ===========================================================================

loc_1DAE4:
	swap	d5
	add.b	objoff_35(a0),d2
	move.b	(a3,d2.w),d5
	addq.w	#1,objoff_38(a0)
	lea	byte_1DB42(pc),a6
	move.b	objoff_34(a0),d6
	jsr	loc_1DB2C(pc)
	move.w	d2,(a2)+	; sub2_x_pos
	move.w	d3,(a2)+	; sub2_y_pos
	move.w	d5,(a2)+	; sub2_mapframe
	addi.w	#$20,d6
	swap	d5
	jsr	loc_1DB2C(pc)
	move.w	d2,(a2)+	; sub3_x_pos
	move.w	d3,(a2)+	; sub3_y_pos
	move.w	d5,(a2)+	; sub3_mapframe
	moveq	#2,d0
	btst	#0,status(a1)
	beq.s	loc_1DB20
	neg.w	d0

loc_1DB20:
	add.b	d0,objoff_34(a0)
	move.w	#$80,d0
	bra.w	DisplaySprite3
; ===========================================================================

loc_1DB2C:
	andi.w	#$3E,d6
	move.b	(a6,d6.w),d2
	move.b	1(a6,d6.w),d3
	ext.w	d2
	ext.w	d3
	add.w	d0,d2
	add.w	d1,d3
	rts
; ===========================================================================
; unknown
byte_1DB42:	dc.w   $F00,  $F03,  $E06,  $D08,  $B0B,  $80D,  $60E,  $30F
		dc.w    $10, -$3F1, -$6F2, -$8F3, -$BF5, -$DF8, -$EFA, -$FFD
		dc.w  $F000, -$F04, -$E07, -$D09, -$B0C, -$80E, -$60F, -$310
		dc.w   -$10,  $3F0,  $6F1,  $8F2,  $BF4,  $DF7,  $EF9,  $FFC

byte_1DB82:	dc.b   8,  5,  7,  6,  6,  7,  5,  8,  6,  7,  7,  6,$FF
	rev02even
byte_1DB8F:	dc.b   8,  7,  6,  5,  4,  3,  4,  5,  6,  7,$FF
		dc.b   3,  4,  5,  6,  7,  8,  7,  6,  5,  4
	rev02even
byte_1DBA4:	dc.b   8,  7,  6,  5,  4,  3,  2,  3,  4,  5,  6,  7,$FF
		dc.b   2,  3,  4,  5,  6,  7,  8,  7,  6,  5,  4,  3
	rev02even
byte_1DBBD:	dc.b   7,  6,  5,  4,  3,  2,  1,  2,  3,  4,  5,  6,$FF
		dc.b   1,  2,  3,  4,  5,  6,  7,  6,  5,  4,  3,  2
	even

; animation script
; byte_1DBD6
Ani_obj38:	offsetTable
		offsetTableEntry.w +	; 0
+		dc.b   0,  5,  0,  5,  1,  5,  2,  5,  3,  5,  4,$FF

; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj38_MapUnc_1DBE4:	BINCLUDE "mappings/sprite/obj38.bin"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj35_MapUnc_1DCBC:	BINCLUDE "mappings/sprite/obj35.bin"
