; ----------------------------------------------------------------------------
; Object 0E - Flashing stars from intro
; ----------------------------------------------------------------------------
; Sprite_12E18:
Obj0E:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj0E_Index(pc,d0.w),d1
	jmp	Obj0E_Index(pc,d1.w)
; ===========================================================================
; off_12E26: Obj0E_States:
Obj0E_Index:	offsetTable
		offsetTableEntry.w Obj0E_Init	;   0
		offsetTableEntry.w Obj0E_Sonic	;   2
		offsetTableEntry.w Obj0E_Tails	;   4
		offsetTableEntry.w Obj0E_LogoTop	;   6
		offsetTableEntry.w Obj0E_LargeStar	;   8
		offsetTableEntry.w Obj0E_SonicHand	;  $A
		offsetTableEntry.w Obj0E_SmallStar	;  $C
		offsetTableEntry.w Obj0E_SkyPiece	;  $E
		offsetTableEntry.w Obj0E_TailsHand	; $10
; ===========================================================================
; loc_12E38:
Obj0E_Init:
	addq.b	#2,routine(a0)	; useless, because it's overwritten with the subtype below
	move.l	#Obj0E_MapUnc_136A8,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_TitleSprites,0,0),art_tile(a0)
	move.b	#4,priority(a0)
	move.b	subtype(a0),routine(a0)
	bra.s	Obj0E
; ===========================================================================

Obj0E_Sonic:
	addq.w	#1,objoff_34(a0)
	cmpi.w	#$120,objoff_34(a0)
	bhs.s	+
	bsr.w	TitleScreen_SetFinalState
+
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_12E76(pc,d0.w),d1
	jmp	off_12E76(pc,d1.w)
; ===========================================================================
off_12E76:	offsetTable
		offsetTableEntry.w Obj0E_Sonic_Init	;   0
		offsetTableEntry.w loc_12EC2	;   2
		offsetTableEntry.w loc_12EE8	;   4
		offsetTableEntry.w loc_12F18	;   6
		offsetTableEntry.w loc_12F52	;   8
		offsetTableEntry.w Obj0E_Sonic_LastFrame	;  $A
		offsetTableEntry.w loc_12F7C	;  $C
		offsetTableEntry.w loc_12F9A	;  $E
		offsetTableEntry.w loc_12FD6	; $10
		offsetTableEntry.w loc_13014	; $12
; ===========================================================================
; spawn more stars
Obj0E_Sonic_Init:
	addq.b	#2,routine_secondary(a0)
	move.b	#5,mapping_frame(a0)
	move.w	#$110,x_pixel(a0)
	move.w	#$E0,y_pixel(a0)
	lea	(IntroLargeStar).w,a1
	move.b	#ObjID_IntroStars,id(a1) ; load obj0E (flashing intro stars) at $FFFFB0C0
	move.b	#8,subtype(a1)				; large star
	lea	(IntroEmblemTop).w,a1
	move.b	#ObjID_IntroStars,id(a1) ; load obj0E (flashing intro stars) at $FFFFD140
	move.b	#6,subtype(a1)				; logo top
	moveq	#SndID_Sparkle,d0
	jmpto	(PlaySound).l, JmpTo4_PlaySound
; ===========================================================================

loc_12EC2:
	cmpi.w	#$38,objoff_34(a0)
	bhs.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	lea	(TitleScreenPaletteChanger3).w,a1
	move.b	#ObjID_TtlScrPalChanger,id(a1) ; load objC9 (palette change)
	move.b	#0,subtype(a1)
	st.b	objoff_30(a0)
	moveq	#MusID_Title,d0 ; title music
	jmpto	(PlayMusic).l, JmpTo4_PlayMusic
; ===========================================================================

loc_12EE8:
	cmpi.w	#$80,objoff_34(a0)
	bhs.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	lea	(Pal_133EC).l,a1
	lea	(Normal_palette).w,a2

	moveq	#$F,d6
-	move.w	(a1)+,(a2)+
	dbf	d6,-

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_12F08:
	lea	(IntroSmallStar1).w,a1
	move.b	#ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB180
	move.b	#$E,subtype(a1)				; piece of sky
	rts
; End of function sub_12F08

; ===========================================================================

loc_12F18:
	moveq	#word_13046_end-word_13046+4,d2
	lea	(word_13046).l,a1

loc_12F20:
	move.w	objoff_2A(a0),d0
	addq.w	#1,d0
	move.w	d0,objoff_2A(a0)
	andi.w	#3,d0
	bne.s	+
	move.w	objoff_2C(a0),d1
	addq.w	#4,d1
	cmp.w	d2,d1
	bhs.w	loc_1310A
	move.w	d1,objoff_2C(a0)
	move.l	-4(a1,d1.w),d0
	move.w	d0,y_pixel(a0)
	swap	d0
	move.w	d0,x_pixel(a0)
+
	bra.w	DisplaySprite
; ===========================================================================

loc_12F52:
	lea	(Ani_obj0E).l,a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite
; ===========================================================================

Obj0E_Sonic_LastFrame:
	addq.b	#2,routine_secondary(a0)
	move.b	#$12,mapping_frame(a0)
	lea	(IntroSonicHand).w,a1
	move.b	#ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB1C0
	move.b	#$A,subtype(a1)				; Sonic's hand
	bra.w	DisplaySprite
; ===========================================================================

loc_12F7C:
	cmpi.w	#$C0,objoff_34(a0)
	blo.s	+
	addq.b	#2,routine_secondary(a0)
	lea	(IntroTails).w,a1
	move.b	#ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB080
	move.b	#4,subtype(a1)				; Tails
+
	bra.w	DisplaySprite
; ===========================================================================

loc_12F9A:
	cmpi.w	#$120,objoff_34(a0)
	blo.s	+
	addq.b	#2,routine_secondary(a0)
	clr.w	objoff_2C(a0)
	st	objoff_2F(a0)
	lea	(Normal_palette_line3).w,a1
	move.w	#$EEE,d0

	moveq	#$F,d6
-	move.w	d0,(a1)+
	dbf	d6,-

	lea	(TitleScreenPaletteChanger2).w,a1
	move.b	#ObjID_TtlScrPalChanger,id(a1) ; load objC9 (palette change handler) at $FFFFB240
	move.b	#2,subtype(a1)
	move.b	#ObjID_TitleMenu,(TitleScreenMenu+id).w ; load Obj0F (title screen menu) at $FFFFB400
+
	bra.w	DisplaySprite
; ===========================================================================

loc_12FD6:
	btst	#6,(Graphics_Flags).w
	beq.s	+
	cmpi.w	#$190,objoff_34(a0)
	beq.s	++
	bra.w	DisplaySprite
; ===========================================================================
+
	cmpi.w	#$1D0,objoff_34(a0)
	beq.s	+
	bra.w	DisplaySprite
; ===========================================================================
+
	lea	(IntroSmallStar2).w,a1
	move.b	#ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB440
	move.b	#$C,subtype(a1)				; small star
	addq.b	#2,routine_secondary(a0)
	lea	(IntroSmallStar1).w,a1
	bsr.w	DeleteObject2 ; delete object at $FFFFB180
	bra.w	DisplaySprite
; ===========================================================================

loc_13014:
	move.b	(Vint_runcount+3).w,d0
	andi.b	#7,d0
	bne.s	++
	move.w	objoff_2C(a0),d0
	addq.w	#2,d0
	cmpi.w	#CyclingPal_TitleStar_End-CyclingPal_TitleStar,d0
	blo.s	+
	moveq	#0,d0
+
	move.w	d0,objoff_2C(a0)
	move.w	CyclingPal_TitleStar(pc,d0.w),(Normal_palette_line3+$A).w
+
	bra.w	DisplaySprite
; ===========================================================================
; word_1303A:
CyclingPal_TitleStar:
	binclude "art/palettes/Title Star Cycle.bin"
CyclingPal_TitleStar_End

word_13046:
	dc.w  $108, $D0
	dc.w  $100, $C0	; 2
	dc.w   $F8, $B0	; 4
	dc.w   $F6, $A6	; 6
	dc.w   $FA, $9E	; 8
	dc.w  $100, $9A	; $A
	dc.w  $104, $99	; $C
	dc.w  $108, $98	; $E
word_13046_end
; ===========================================================================

Obj0E_Tails:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_13074(pc,d0.w),d1
	jmp	off_13074(pc,d1.w)
; ===========================================================================
off_13074:	offsetTable
		offsetTableEntry.w Obj0E_Tails_Init			; 0
		offsetTableEntry.w loc_13096			; 2
		offsetTableEntry.w loc_12F52			; 4
		offsetTableEntry.w loc_130A2			; 6
		offsetTableEntry.w BranchTo10_DisplaySprite	; 8
; ===========================================================================

Obj0E_Tails_Init:
	addq.b	#2,routine_secondary(a0)
	move.w	#$D8,x_pixel(a0)
	move.w	#$D8,y_pixel(a0)
	move.b	#1,anim(a0)
	rts
; ===========================================================================

loc_13096:
	moveq	#word_130B8_end-word_130B8+4,d2
	lea	(word_130B8).l,a1
	bra.w	loc_12F20
; ===========================================================================

loc_130A2:
	addq.b	#2,routine_secondary(a0)
	lea	(IntroTailsHand).w,a1
	move.b	#ObjID_IntroStars,id(a1) ; load obj0E (flashing intro star) at $FFFFB200
	move.b	#$10,subtype(a1)			; Tails' hand

BranchTo10_DisplaySprite 
	bra.w	DisplaySprite
; ===========================================================================
word_130B8:
	dc.w   $D7,$C8
	dc.w   $D3,$B8	; 2
	dc.w   $CE,$AC	; 4
	dc.w   $CC,$A6	; 6
	dc.w   $CA,$A2	; 8
	dc.w   $C9,$A1	; $A
	dc.w   $C8,$A0	; $C
word_130B8_end
; ===========================================================================

Obj0E_LogoTop:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_130E2(pc,d0.w),d1
	jmp	off_130E2(pc,d1.w)
; ===========================================================================
off_130E2:	offsetTable
		offsetTableEntry.w Obj0E_LogoTop_Init			; 0
		offsetTableEntry.w BranchTo11_DisplaySprite	; 2
; ===========================================================================

Obj0E_LogoTop_Init:
	move.b	#$B,mapping_frame(a0)
	tst.b	(Graphics_Flags).w
	bmi.s	+
	move.b	#$A,mapping_frame(a0)
+
	move.b	#2,priority(a0)
	move.w	#$120,x_pixel(a0)
	move.w	#$E8,y_pixel(a0)

loc_1310A:
	addq.b	#2,routine_secondary(a0)

BranchTo11_DisplaySprite 
	bra.w	DisplaySprite
; ===========================================================================

Obj0E_SkyPiece:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_13120(pc,d0.w),d1
	jmp	off_13120(pc,d1.w)
; ===========================================================================
off_13120:	offsetTable
		offsetTableEntry.w Obj0E_SkyPiece_Init			; 0
		offsetTableEntry.w BranchTo12_DisplaySprite	; 2
; ===========================================================================

Obj0E_SkyPiece_Init:
	addq.b	#2,routine_secondary(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	move.b	#$11,mapping_frame(a0)
	move.b	#2,priority(a0)
	move.w	#$100,x_pixel(a0)
	move.w	#$F0,y_pixel(a0)

BranchTo12_DisplaySprite 
	bra.w	DisplaySprite
; ===========================================================================

Obj0E_LargeStar:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_13158(pc,d0.w),d1
	jmp	off_13158(pc,d1.w)
; ===========================================================================
off_13158:	offsetTable
		offsetTableEntry.w Obj0E_LargeStar_Init	; 0
		offsetTableEntry.w loc_12F52	; 2
		offsetTableEntry.w loc_13190	; 4
		offsetTableEntry.w loc_1319E	; 6
; ===========================================================================

Obj0E_LargeStar_Init:
	addq.b	#2,routine_secondary(a0)
	move.b	#$C,mapping_frame(a0)
	ori.w	#high_priority,art_tile(a0)
	move.b	#2,anim(a0)
	move.b	#1,priority(a0)
	move.w	#$100,x_pixel(a0)
	move.w	#$A8,y_pixel(a0)
	move.w	#4,objoff_2A(a0)
	rts
; ===========================================================================

loc_13190:
	subq.w	#1,objoff_2A(a0)
	bmi.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	rts
; ===========================================================================

loc_1319E:
	move.b	#2,routine_secondary(a0)
	move.b	#0,anim_frame(a0)
	move.b	#0,anim_frame_duration(a0)
	move.w	#6,objoff_2A(a0)
	move.w	objoff_2C(a0),d0
	addq.w	#4,d0
	cmpi.w	#word_131DC_end-word_131DC+4,d0
	bhs.w	DeleteObject
	move.w	d0,objoff_2C(a0)
	move.l	word_131DC-4(pc,d0.w),d0
	move.w	d0,y_pixel(a0)
	swap	d0
	move.w	d0,x_pixel(a0)
	moveq	#SndID_Sparkle,d0 ; play intro sparkle sound
	jmpto	(PlaySound).l, JmpTo4_PlaySound
; ===========================================================================
; unknown
word_131DC:
	dc.w   $DA, $F2
	dc.w  $170, $F8	; 2
	dc.w  $132,$131	; 4
	dc.w  $19E, $A2	; 6
	dc.w   $C0, $E3	; 8
	dc.w  $180, $E0	; $A
	dc.w  $10D,$13B	; $C
	dc.w   $C0, $AB	; $E
	dc.w  $165, $107	; $10
word_131DC_end
; ===========================================================================

Obj0E_SonicHand:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_1320E(pc,d0.w),d1
	jmp	off_1320E(pc,d1.w)
; ===========================================================================
off_1320E:	offsetTable
		offsetTableEntry.w Obj0E_SonicHand_Init			; 0
		offsetTableEntry.w loc_13234			; 2
		offsetTableEntry.w BranchTo13_DisplaySprite	; 4
; ===========================================================================

Obj0E_SonicHand_Init:
	addq.b	#2,routine_secondary(a0)
	move.b	#9,mapping_frame(a0)
	move.b	#3,priority(a0)
	move.w	#$145,x_pixel(a0)
	move.w	#$BF,y_pixel(a0)

BranchTo13_DisplaySprite 
	bra.w	DisplaySprite
; ===========================================================================

loc_13234:
	moveq	#word_13240_end-word_13240+4,d2
	lea	(word_13240).l,a1
	bra.w	loc_12F20
; ===========================================================================
word_13240:
	dc.w  $143, $C1
	dc.w  $140, $C2	; 2
	dc.w  $141, $C1	; 4
word_13240_end
; ===========================================================================

Obj0E_TailsHand:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_1325A(pc,d0.w),d1
	jmp	off_1325A(pc,d1.w)
; ===========================================================================
off_1325A:	offsetTable
		offsetTableEntry.w Obj0E_TailsHand_Init			; 0
		offsetTableEntry.w loc_13280			; 2
		offsetTableEntry.w BranchTo14_DisplaySprite	; 4
; ===========================================================================

Obj0E_TailsHand_Init:
	addq.b	#2,routine_secondary(a0)
	move.b	#$13,mapping_frame(a0)
	move.b	#3,priority(a0)
	move.w	#$10F,x_pixel(a0)
	move.w	#$D5,y_pixel(a0)

BranchTo14_DisplaySprite 
	bra.w	DisplaySprite
; ===========================================================================

loc_13280:
	moveq	#word_1328C_end-word_1328C+4,d2
	lea	(word_1328C).l,a1
	bra.w	loc_12F20
; ===========================================================================
word_1328C:
	dc.w  $10C, $D0
	dc.w  $10D, $D1	; 2
word_1328C_end
; ===========================================================================

Obj0E_SmallStar:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_132A2(pc,d0.w),d1
	jmp	off_132A2(pc,d1.w)
; ===========================================================================
off_132A2:	offsetTable
		offsetTableEntry.w Obj0E_SmallStar_Init	; 0
		offsetTableEntry.w loc_132D2	; 2
; ===========================================================================

Obj0E_SmallStar_Init:
	addq.b	#2,routine_secondary(a0)
	move.b	#$C,mapping_frame(a0)
	move.b	#5,priority(a0)
	move.w	#$170,x_pixel(a0)
	move.w	#$80,y_pixel(a0)
	move.b	#3,anim(a0)
	move.w	#$8C,objoff_2A(a0)
	bra.w	DisplaySprite
; ===========================================================================

loc_132D2:
	subq.w	#1,objoff_2A(a0)
	bmi.w	DeleteObject
	subq.w	#2,x_pixel(a0)
	addq.w	#1,y_pixel(a0)
	lea	(Ani_obj0E).l,a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite

; Mappings are with object 0F