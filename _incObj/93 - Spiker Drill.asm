; ----------------------------------------------------------------------------
; Object 93 - Drill thrown by Spiker from HTZ
; ----------------------------------------------------------------------------
; Sprite_36FE6:
Obj93:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj93_Index(pc,d0.w),d1
	jmp	Obj93_Index(pc,d1.w)
; ===========================================================================
; off_36FF4:
Obj93_Index:	offsetTable
		offsetTableEntry.w Obj93_Init	; 0
		offsetTableEntry.w loc_37028	; 2
; ===========================================================================
; loc_36FF8:
Obj93_Init:
	bsr.w	LoadSubObject
	ori.b	#$80,render_flags(a0)
	ori.b	#$80,collision_flags(a0)
	movea.w	objoff_2C(a0),a1 ; a1=object
	move.b	render_flags(a1),d0
	andi.b	#3,d0
	or.b	d0,render_flags(a0)
	moveq	#2,d1
	btst	#1,d0
	bne.s	+
	neg.w	d1
+
	move.b	d1,y_vel(a0)
	rts
; ===========================================================================

loc_37028:
	tst.b	render_flags(a0)
	bpl.w	JmpTo65_DeleteObject
	bchg	#0,render_flags(a0)
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_3703E:
	tst.b	objoff_2B(a0)
	bne.s	loc_37062
	tst.b	render_flags(a0)
	bpl.s	loc_37062
	bsr.w	Obj_GetOrientationToPlayer
	addi.w	#$20,d2
	cmpi.w	#$40,d2
	bhs.s	loc_37062
	addi.w	#$80,d3
	cmpi.w	#$100,d3
	blo.s	loc_37066

loc_37062:
	moveq	#0,d0
	rts
; ===========================================================================

loc_37066:
	move.b	routine(a0),objoff_2F(a0)
	move.b	#6,routine(a0)
	move.b	#$10,objoff_2E(a0)
	moveq	#1,d0
	rts
; ===========================================================================
; off_3707C:
Obj92_SubObjData:
	subObjData Obj92_Obj93_MapUnc_37092,make_art_tile(ArtTile_ArtKos_LevelArt,0,0),4,4,$10,$12
; animation script
; off_37086:
Ani_obj92:	offsetTable
		offsetTableEntry.w byte_3708A	; 0
		offsetTableEntry.w byte_3708E	; 2
byte_3708A:	dc.b   9,  0,  1,$FF
byte_3708E:	dc.b   9,  2,  3,$FF
		even
; ---------------------------------------------------------------------------
; sprite mappings
; ---------------------------------------------------------------------------
Obj92_Obj93_MapUnc_37092:	BINCLUDE "mappings/sprite/obj93.bin"
; ===========================================================================