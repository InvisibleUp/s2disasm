; ----------------------------------------------------------------------------
; Object 37 - Scattering rings (generated when Sonic is hurt and has rings)
; ----------------------------------------------------------------------------
; Sprite_12078:
Obj37:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj37_Index(pc,d0.w),d1
	jmp	Obj37_Index(pc,d1.w)
; ===========================================================================
; Obj_37_subtbl:
Obj37_Index:	offsetTable
		offsetTableEntry.w Obj37_Init		; 0
		offsetTableEntry.w Obj37_Main		; 2
		offsetTableEntry.w Obj37_Collect	; 4
		offsetTableEntry.w Obj37_Sparkle	; 6
		offsetTableEntry.w Obj37_Delete		; 8
; ===========================================================================
; Obj_37_sub_0:
Obj37_Init:
	movea.l	a0,a1
	moveq	#0,d5
	move.w	(Ring_count).w,d5
	tst.b	parent+1(a0)
	beq.s	+
	move.w	(Ring_count_2P).w,d5
+
	moveq	#$20,d0
	cmp.w	d0,d5
	blo.s	+
	move.w	d0,d5
+
	subq.w	#1,d5
	move.w	#$288,d4
	bra.s	+
; ===========================================================================

-	bsr.w	SingleObjLoad
	bne.w	+++
+
	_move.b	#ObjID_LostRings,id(a1) ; load obj37
	addq.b	#2,routine(a1)
	move.b	#8,y_radius(a1)
	move.b	#8,x_radius(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	#Obj25_MapUnc_12382,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a1)
	bsr.w	Adjust2PArtPointer2
	move.b	#$84,render_flags(a1)
	move.b	#3,priority(a1)
	move.b	#$47,collision_flags(a1)
	move.b	#8,width_pixels(a1)
	move.b	#-1,(Ring_spill_anim_counter).w
	tst.w	d4
	bmi.s	+
	move.w	d4,d0
	jsrto	(CalcSine).l, JmpTo4_CalcSine
	move.w	d4,d2
	lsr.w	#8,d2
	asl.w	d2,d0
	asl.w	d2,d1
	move.w	d0,d2
	move.w	d1,d3
	addi.b	#$10,d4
	bcc.s	+
	subi.w	#$80,d4
	bcc.s	+
	move.w	#$288,d4
+
	move.w	d2,x_vel(a1)
	move.w	d3,y_vel(a1)
	neg.w	d2
	neg.w	d4
	dbf	d5,-
+
	move.w	#SndID_RingSpill,d0
	jsr	(PlaySoundStereo).l
	tst.b	parent+1(a0)
	bne.s	+
	move.w	#0,(Ring_count).w
	move.b	#$80,(Update_HUD_rings).w
	move.b	#0,(Extra_life_flags).w
	bra.s	Obj37_Main
; ===========================================================================
+
	move.w	#0,(Ring_count_2P).w
	move.b	#$80,(Update_HUD_rings_2P).w
	move.b	#0,(Extra_life_flags_2P).w
; Obj_37_sub_2:
Obj37_Main:
	move.b	(Ring_spill_anim_frame).w,mapping_frame(a0)
	bsr.w	ObjectMove
	addi.w	#$18,y_vel(a0)
	bmi.s	loc_121B8
	move.b	(Vint_runcount+3).w,d0
	add.b	d7,d0
	andi.b	#7,d0
	bne.s	loc_121B8
	tst.b	render_flags(a0)
	bpl.s	loc_121D0
	jsr	(RingCheckFloorDist).l
	tst.w	d1
	bpl.s	loc_121B8
	add.w	d1,y_pos(a0)
	move.w	y_vel(a0),d0
	asr.w	#2,d0
	sub.w	d0,y_vel(a0)
	neg.w	y_vel(a0)

loc_121B8:

	tst.b	(Ring_spill_anim_counter).w
	beq.s	Obj37_Delete
	move.w	(Camera_Max_Y_pos_now).w,d0
	addi.w	#$E0,d0
	cmp.w	y_pos(a0),d0
	blo.s	Obj37_Delete
	bra.w	DisplaySprite
; ===========================================================================

loc_121D0:
	tst.w	(Two_player_mode).w
	bne.w	Obj37_Delete
	bra.s	loc_121B8
; ===========================================================================
; Obj_37_sub_4:
Obj37_Collect:
	addq.b	#2,routine(a0)
	move.b	#0,collision_flags(a0)
	move.b	#1,priority(a0)
	bsr.w	CollectRing
; Obj_37_sub_6:
Obj37_Sparkle:
	lea	(Ani_Ring).l,a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite
; ===========================================================================
; BranchTo5_DeleteObject 
Obj37_Delete:
	bra.w	DeleteObject
