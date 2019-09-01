; ----------------------------------------------------------------------------
; Object 9B - Turtloid rider from Sky Chase Zone
; ----------------------------------------------------------------------------
; Sprite_37A06:
Obj9B:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj9B_Index(pc,d0.w),d1
	jmp	Obj9B_Index(pc,d1.w)
; ===========================================================================
; off_37A14:
Obj9B_Index:	offsetTable
		offsetTableEntry.w Obj9B_Init	; 0
		offsetTableEntry.w Obj9B_Main	; 2
; ===========================================================================
; BranchTo_LoadSubObject 
Obj9B_Init:
	bra.w	LoadSubObject
; ===========================================================================
; loc_37A1C:
Obj9B_Main:
	movea.w	objoff_2C(a0),a1 ; a1=object
	lea	word_37A2C(pc),a2
	bsr.w	loc_37A30
	bra.w	Obj_DeleteBehindScreen
; ===========================================================================
word_37A2C:
	dc.w	 4	; 0
	dc.w  -$18	; 1
; ===========================================================================

loc_37A30:
	move.l	x_pos(a1),x_pos(a0)
	move.l	y_pos(a1),y_pos(a0)
	move.w	(a2)+,d0
	add.w	d0,x_pos(a0)
	move.w	(a2)+,d0
	add.w	d0,y_pos(a0)

return_37A48:
	rts
; ===========================================================================

loc_37A4A:
	jsrto	(SingleObjLoad2).l, JmpTo25_SingleObjLoad2
	bne.s	return_37A80
	_move.b	#ObjID_TurtloidRider,id(a1) ; load obj9B
	move.b	#2,mapping_frame(a1)
	move.b	#$18,subtype(a1) ; <== Obj9B_SubObjData
	move.w	a0,objoff_2C(a1)
	move.w	a1,objoff_2C(a0)
	move.w	x_pos(a0),x_pos(a1)
	addq.w	#4,x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	subi.w	#$18,y_pos(a1)

return_37A80:
	rts
; ===========================================================================