; ----------------------------------------------------------------------------
; Object 61 - Bombs from Special Stage
; ----------------------------------------------------------------------------
; Sprite_34EB0:
Obj61:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj61_Index(pc,d0.w),d1
	jmp	Obj61_Index(pc,d1.w)
; ===========================================================================
; off_34EBE:
Obj61_Index:	offsetTable
		offsetTableEntry.w Obj61_Init	; 0
		offsetTableEntry.w loc_34F06	; 2
		offsetTableEntry.w loc_3533A	; 4
		offsetTableEntry.w loc_34F6A	; 6
; ===========================================================================
; loc_34EC6:
Obj61_Init:
	addq.b	#2,routine(a0)
	move.w	#$7F,x_pos(a0)
	move.w	#$58,y_pos(a0)
	move.l	#Obj61_MapUnc_36508,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialBomb,1,0),art_tile(a0)
	move.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	move.b	#2,collision_flags(a0)
	move.b	#-1,(SS_unk_DB4D).w
	tst.b	angle(a0)
	bmi.s	loc_34F06
	bsr.w	loc_3529C

loc_34F06:
	bsr.w	loc_3512A
	bsr.w	loc_351A0
	lea	(Ani_obj61).l,a1
	bsr.w	loc_3539E
	tst.b	render_flags(a0)
	bpl.s	return_34F26
	bsr.w	loc_34F28
	bra.w	JmpTo44_DisplaySprite
; ===========================================================================

return_34F26:
	rts
; ===========================================================================

loc_34F28:
	move.w	#8,d6
	bsr.w	loc_350A0
	bcc.s	return_34F68
	move.b	#1,collision_property(a1)
	move.w	#SndID_SlowSmash,d0
	jsr	(PlaySoundStereo).l
	move.b	#6,routine(a0)
	move.b	#0,anim_frame(a0)
	move.b	#0,anim_frame_duration(a0)
	move.l	objoff_34(a0),d0
	beq.s	return_34F68
	move.l	#0,objoff_34(a0)
	movea.l	d0,a1 ; a1=object
	st	objoff_2A(a1)

return_34F68:
	rts
; ===========================================================================

loc_34F6A:
	move.b	#$A,anim(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_SpecialExplosion,2,0),art_tile(a0)
	bsr.w	loc_34F90
	bsr.w	loc_3512A
	bsr.w	loc_351A0
	lea	(Ani_obj61).l,a1
	jsrto	(AnimateSprite).l, JmpTo24_AnimateSprite
	bra.w	JmpTo44_DisplaySprite
; ===========================================================================

loc_34F90:
	cmpi.w	#4,objoff_30(a0)
	bhs.s	return_34F9E
	move.b	#1,priority(a0)

return_34F9E:
	rts
; ===========================================================================