; ----------------------------------------------------------------------------
; Object 92 - Spiker (drill badnik) from HTZ
; ----------------------------------------------------------------------------
; Sprite_36F0E:
Obj92:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj92_Index(pc,d0.w),d1
	jmp	Obj92_Index(pc,d1.w)
; ===========================================================================
; off_36F1C:
Obj92_Index:	offsetTable
		offsetTableEntry.w Obj92_Init	; 0
		offsetTableEntry.w loc_36F3C	; 2
		offsetTableEntry.w loc_36F68	; 4
		offsetTableEntry.w loc_36F90	; 6
; ===========================================================================
; loc_36F24:
Obj92_Init:
	bsr.w	LoadSubObject
	move.b	#$40,objoff_2A(a0)
	move.w	#$80,x_vel(a0)
	bchg	#0,status(a0)
	rts
; ===========================================================================

loc_36F3C:
	bsr.w	loc_3703E
	bne.s	loc_36F48
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_36F5A

loc_36F48:
	jsrto	(ObjectMove).l, JmpTo26_ObjectMove
	lea	(Ani_obj92).l,a1
	jsrto	(AnimateSprite).l, JmpTo25_AnimateSprite
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36F5A:
	addq.b	#2,routine(a0)
	move.b	#$10,objoff_2A(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36F68:
	bsr.w	loc_3703E
	bne.s	+
	subq.b	#1,objoff_2A(a0)
	bmi.s	loc_36F78
+
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36F78:
	subq.b	#2,routine(a0)
	move.b	#$40,objoff_2A(a0)
	neg.w	x_vel(a0)
	bchg	#0,status(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36F90:
	move.b	objoff_2E(a0),d0
	cmpi.b	#8,d0
	beq.s	loc_36FA4
	subq.b	#1,d0
	move.b	d0,objoff_2E(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================

loc_36FA4:
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	loc_36FDC
	st	objoff_2B(a0)
	_move.b	#ObjID_SpikerDrill,id(a1) ; load obj93
	move.b	subtype(a0),subtype(a1)
	move.w	a0,objoff_2C(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.b	#4,mapping_frame(a1)
	move.b	#2,mapping_frame(a0)
	move.b	#1,anim(a0)

loc_36FDC:
	move.b	objoff_2F(a0),routine(a0)
	jmpto	(MarkObjGone).l, JmpTo39_MarkObjGone
; ===========================================================================