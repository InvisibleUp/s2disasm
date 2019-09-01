; ----------------------------------------------------------------------------
; Object 54 - MTZ boss
; ----------------------------------------------------------------------------
; Sprite_32288:
Obj54:
	moveq	#0,d0
	move.b	boss_subtype(a0),d0
	move.w	Obj54_Index(pc,d0.w),d1
	jmp	Obj54_Index(pc,d1.w)
; ===========================================================================
; off_32296:
Obj54_Index:	offsetTable
		offsetTableEntry.w Obj54_Init			; 0
		offsetTableEntry.w Obj54_Main		 	; 2
		offsetTableEntry.w Obj54_Laser			; 4
		offsetTableEntry.w Obj54_LaserShooter	; 6
; ===========================================================================
; loc_3229E:
Obj54_Init:
	move.l	#Obj54_MapUnc_32DC6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MTZBoss,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#3,priority(a0)
	move.w	#$2B50,x_pos(a0)
	move.w	#$380,y_pos(a0)
	move.b	#2,mainspr_mapframe(a0)
	addq.b	#2,boss_subtype(a0)		; => Obj54_Main
	bset	#6,render_flags(a0)
	move.b	#2,mainspr_childsprites(a0)
	move.b	#$F,collision_flags(a0)
	move.b	#8,boss_hitcount2(a0)
	move.b	#7,objoff_3E(a0)
	move.w	x_pos(a0),(Boss_X_pos).w
	move.w	y_pos(a0),(Boss_Y_pos).w
	move.w	#0,(Boss_X_vel).w
	move.w	#$100,(Boss_Y_vel).w
	move.b	#$20,mainspr_width(a0)
	clr.b	objoff_2B(a0)
	clr.b	objoff_2C(a0)
	move.b	#$40,mapping_frame(a0)
	move.b	#$27,objoff_33(a0)
	move.b	#$27,objoff_39(a0)
	move.w	x_pos(a0),sub2_x_pos(a0)
	move.w	y_pos(a0),sub2_y_pos(a0)
	move.b	#$C,sub2_mapframe(a0)
	move.w	x_pos(a0),sub3_x_pos(a0)
	move.w	y_pos(a0),sub3_y_pos(a0)
	move.b	#0,sub3_mapframe(a0)
	jsrto	(SingleObjLoad).l, JmpTo17_SingleObjLoad
	bne.s	+
	move.b	#ObjID_MTZBoss,id(a1) ; load obj54
	move.b	#6,boss_subtype(a1)		; => Obj54_LaserShooter
	move.b	#$13,mapping_frame(a1)
	move.l	#Obj54_MapUnc_32DC6,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_MTZBoss,0,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#6,priority(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	a0,objoff_34(a1)
	move.b	#$20,width_pixels(a1)
	jsrto	(SingleObjLoad).l, JmpTo17_SingleObjLoad
	bne.s	+
	move.b	#ObjID_MTZBossOrb,id(a1) ; load obj53
	move.l	a0,objoff_34(a1)
+
	lea	(Boss_AnimationArray).w,a2
	move.b	#$10,(a2)+
	move.b	#0,(a2)+
	move.b	#3,(a2)+
	move.b	#0,(a2)+
	move.b	#1,(a2)+
	move.b	#0,(a2)+
	rts
; ===========================================================================
;loc_323BA
Obj54_Main:
	moveq	#0,d0
	move.b	angle(a0),d0
	move.w	Obj54_MainSubStates(pc,d0.w),d1
	jmp	Obj54_MainSubStates(pc,d1.w)
; ===========================================================================
Obj54_MainSubStates:	offsetTable
		offsetTableEntry.w Obj54_MainSub0	;   0
		offsetTableEntry.w Obj54_MainSub2	;   2
		offsetTableEntry.w Obj54_MainSub4	;   4
		offsetTableEntry.w Obj54_MainSub6	;   6
		offsetTableEntry.w Obj54_MainSub8	;   8
		offsetTableEntry.w Obj54_MainSubA	;  $A
		offsetTableEntry.w Obj54_MainSubC	;  $C
		offsetTableEntry.w Obj54_MainSubE	;  $E
		offsetTableEntry.w Obj54_MainSub10	; $10
		offsetTableEntry.w Obj54_MainSub12	; $12
; ===========================================================================
;loc_323DC
Obj54_MainSub0:
	bsr.w	Boss_MoveObject
	move.w	(Boss_Y_pos).w,y_pos(a0)
	cmpi.w	#$4A0,(Boss_Y_pos).w
	blo.s	+
	addq.b	#2,angle(a0)		; => Obj54_MainSub2
	move.w	#0,(Boss_Y_vel).w
	move.w	#-$100,(Boss_X_vel).w
	bclr	#7,objoff_2B(a0)
	bclr	#0,render_flags(a0)
	move.w	(MainCharacter+x_pos).w,d0
	cmp.w	(Boss_X_pos).w,d0
	blo.s	+
	move.w	#$100,(Boss_X_vel).w
	bset	#7,objoff_2B(a0)
	bset	#0,render_flags(a0)
+
	bsr.w	Obj54_AnimateFace
	lea	(Ani_obj53).l,a1
	bsr.w	AnimateBoss
	bsr.w	Obj54_AlignSprites
	jmpto	(DisplaySprite).l, JmpTo40_DisplaySprite
; ===========================================================================
;loc_3243C
Obj54_Float:
	move.b	mapping_frame(a0),d0
	jsr	(CalcSine).l
	asr.w	#6,d0
	add.w	(Boss_Y_pos).w,d0
	move.w	d0,y_pos(a0)
	addq.b	#4,mapping_frame(a0)
	rts
; ===========================================================================
;loc_32456
Obj54_MainSub2:
	bsr.w	Boss_MoveObject
	btst	#7,objoff_2B(a0)
	bne.s	+
	cmpi.w	#$2AD0,(Boss_X_pos).w
	bhs.s	Obj54_MoveAndShow
	bchg	#7,objoff_2B(a0)
	move.w	#$100,(Boss_X_vel).w
	bset	#0,render_flags(a0)
	bset	#6,objoff_2B(a0)
	beq.s	Obj54_MoveAndShow
	addq.b	#2,angle(a0)		; => Obj54_MainSub4
	move.w	#-$100,(Boss_Y_vel).w
	bra.s	Obj54_MoveAndShow
; ===========================================================================
+
	cmpi.w	#$2BD0,(Boss_X_pos).w
	blo.s	Obj54_MoveAndShow
	bchg	#7,objoff_2B(a0)
	move.w	#-$100,(Boss_X_vel).w
	bclr	#0,render_flags(a0)
	bset	#6,objoff_2B(a0)
	beq.s	Obj54_MoveAndShow
	addq.b	#2,angle(a0)		; => Obj54_MainSub4
	move.w	#-$100,(Boss_Y_vel).w
;loc_324BC
Obj54_MoveAndShow:
	move.w	(Boss_X_pos).w,x_pos(a0)
	bsr.w	Obj54_Float
;loc_324C6
Obj54_Display:
	bsr.w	Obj54_AnimateFace
	lea	(Ani_obj53).l,a1
	bsr.w	AnimateBoss
	bsr.w	Obj54_AlignSprites
	jmpto	(DisplaySprite).l, JmpTo40_DisplaySprite
; ===========================================================================
;loc_324DC
Obj54_MainSub4:
	bsr.w	Boss_MoveObject
	cmpi.w	#$470,(Boss_Y_pos).w
	bhs.s	+
	move.w	#0,(Boss_Y_vel).w
+
	btst	#7,objoff_2B(a0)
	bne.s	+
	cmpi.w	#$2B50,(Boss_X_pos).w
	bhs.s	++
	move.w	#0,(Boss_X_vel).w
	bra.s	++
; ===========================================================================
+
	cmpi.w	#$2B50,(Boss_X_pos).w
	blo.s	+
	move.w	#0,(Boss_X_vel).w
+
	move.w	(Boss_X_vel).w,d0
	or.w	(Boss_Y_vel).w,d0
	bne.s	BranchTo_Obj54_MoveAndShow
	addq.b	#2,angle(a0)		; => Obj54_MainSub6

BranchTo_Obj54_MoveAndShow 
	bra.s	Obj54_MoveAndShow
; ===========================================================================
;loc_32524
Obj54_MainSub6:
	cmpi.b	#$68,objoff_33(a0)
	bhs.s	+
	addq.b	#1,objoff_33(a0)
	addq.b	#1,objoff_39(a0)
	bra.s	BranchTo2_Obj54_MoveAndShow
; ===========================================================================
+
	subq.b	#1,objoff_39(a0)
	bne.s	BranchTo2_Obj54_MoveAndShow
	addq.b	#2,angle(a0)		; => Obj54_MainSub8

BranchTo2_Obj54_MoveAndShow 
	bra.w	Obj54_MoveAndShow
; ===========================================================================
;loc_32544
Obj54_MainSub8:
	cmpi.b	#$27,objoff_33(a0)
	blo.s	+
	subq.b	#1,objoff_33(a0)
	bra.s	BranchTo3_Obj54_MoveAndShow
; ===========================================================================
+
	addq.b	#1,objoff_39(a0)
	cmpi.b	#$27,objoff_39(a0)
	blo.s	BranchTo3_Obj54_MoveAndShow
	move.w	#$100,(Boss_Y_vel).w
	move.b	#0,angle(a0)		; => Obj54_MainSub0
	bclr	#6,objoff_2B(a0)

BranchTo3_Obj54_MoveAndShow 
	bra.w	Obj54_MoveAndShow
; ===========================================================================
;loc_32574
Obj54_MainSubA:
	tst.b	objoff_39(a0)
	beq.s	+
	subq.b	#1,objoff_39(a0)
	bra.s	++
; ===========================================================================
+
	move.b	#-1,objoff_3A(a0)
+
	cmpi.b	#$27,objoff_33(a0)
	blo.s	+
	subq.b	#1,objoff_33(a0)
+
	bsr.w	Boss_MoveObject
	cmpi.w	#$420,(Boss_Y_pos).w
	bhs.s	+
	move.w	#0,(Boss_Y_vel).w
+
	tst.b	objoff_2C(a0)
	bne.s	BranchTo4_Obj54_MoveAndShow
	tst.b	objoff_3A(a0)
	beq.s	+
	move.b	#$80,objoff_3A(a0)
+
	addq.b	#2,angle(a0)		; => Obj54_MainSubC

BranchTo4_Obj54_MoveAndShow 
	bra.w	Obj54_MoveAndShow
; ===========================================================================
;loc_325BE
Obj54_MainSubC:
	tst.b	objoff_3E(a0)
	beq.s	++
	tst.b	objoff_3A(a0)
	bne.s	BranchTo5_Obj54_MoveAndShow
	cmpi.b	#$27,objoff_39(a0)
	bhs.s	+
	addq.b	#1,objoff_39(a0)
	bra.s	BranchTo5_Obj54_MoveAndShow
; ===========================================================================
+
	move.w	#$100,(Boss_Y_vel).w
	move.b	#0,angle(a0)		; => Obj54_MainSub0
	bclr	#6,objoff_2B(a0)
	bra.s	BranchTo5_Obj54_MoveAndShow
; ===========================================================================
+
	move.w	#-$180,(Boss_Y_vel).w
	move.w	#-$100,(Boss_X_vel).w
	bclr	#0,render_flags(a0)
	btst	#7,objoff_2B(a0)
	beq.s	+
	move.w	#$100,(Boss_X_vel).w
	bset	#0,render_flags(a0)
+
	move.b	#$E,angle(a0)		; => Obj54_MainSubE
	move.b	#0,objoff_2E(a0)
	bclr	#6,objoff_2B(a0)
	move.b	#0,objoff_2F(a0)

BranchTo5_Obj54_MoveAndShow 
	bra.w	Obj54_MoveAndShow
; ===========================================================================
;loc_3262E
Obj54_MainSubE:
	tst.b	objoff_2F(a0)
	beq.s	+
	subq.b	#1,objoff_2F(a0)
	bra.w	Obj54_Display
; ===========================================================================
+
	moveq	#0,d0
	move.b	objoff_2E(a0),d0
	move.w	off_3264A(pc,d0.w),d1
	jmp	off_3264A(pc,d1.w)
; ===========================================================================
off_3264A:	offsetTable
		offsetTableEntry.w loc_32650	; 0
		offsetTableEntry.w loc_326B8	; 2
		offsetTableEntry.w loc_32704	; 4
; ===========================================================================

loc_32650:
	bsr.w	Boss_MoveObject
	cmpi.w	#$420,(Boss_Y_pos).w
	bhs.s	+
	move.w	#0,(Boss_Y_vel).w
+
	btst	#7,objoff_2B(a0)
	bne.s	+
	cmpi.w	#$2AF0,(Boss_X_pos).w
	bhs.s	BranchTo6_Obj54_MoveAndShow
	addq.b	#2,objoff_2E(a0)
	move.w	#$180,(Boss_Y_vel).w
	move.b	#3,objoff_2D(a0)
	move.w	#$1E,(Boss_Countdown).w
	bset	#0,render_flags(a0)
	bra.s	BranchTo6_Obj54_MoveAndShow
; ===========================================================================
+
	cmpi.w	#$2BB0,(Boss_X_pos).w
	blo.s	BranchTo6_Obj54_MoveAndShow
	addq.b	#2,objoff_2E(a0)
	move.w	#$180,(Boss_Y_vel).w
	move.b	#3,objoff_2D(a0)
	move.w	#$1E,(Boss_Countdown).w
	bclr	#0,render_flags(a0)

BranchTo6_Obj54_MoveAndShow 
	bra.w	Obj54_MoveAndShow
; ===========================================================================

loc_326B8:
	bsr.w	Boss_MoveObject
	cmpi.w	#$4A0,(Boss_Y_pos).w
	blo.s	+
	move.w	#-$180,(Boss_Y_vel).w
	addq.b	#2,objoff_2E(a0)
	bchg	#7,objoff_2B(a0)
	bra.s	+++
; ===========================================================================
+
	btst	#7,objoff_2B(a0)
	bne.s	+
	cmpi.w	#$2AD0,(Boss_X_pos).w
	bhs.s	++
	move.w	#0,(Boss_X_vel).w
	bra.s	++
; ===========================================================================
+
	cmpi.w	#$2BD0,(Boss_X_pos).w
	blo.s	+
	move.w	#0,(Boss_X_vel).w
+
	bsr.w	Obj54_FireLaser
	bra.w	Obj54_MoveAndShow
; ===========================================================================

loc_32704:
	bsr.w	Boss_MoveObject
	cmpi.w	#$470,(Boss_Y_pos).w
	bhs.s	+
	move.w	#$100,(Boss_X_vel).w
	btst	#7,objoff_2B(a0)
	bne.s	+
	move.w	#-$100,(Boss_X_vel).w
+
	cmpi.w	#$420,(Boss_Y_pos).w
	bhs.s	+
	move.w	#0,(Boss_Y_vel).w
	move.b	#0,objoff_2E(a0)
+
	bsr.w	Obj54_FireLaser
	bra.w	Obj54_MoveAndShow
; ===========================================================================
;loc_32740
Obj54_FireLaser:
	subi_.w	#1,(Boss_Countdown).w
	bne.s	+		; rts
	tst.b	objoff_2D(a0)
	beq.s	+		; rts
	subq.b	#1,objoff_2D(a0)
	jsrto	(SingleObjLoad).l, JmpTo17_SingleObjLoad
	bne.s	+		; rts
	move.b	#ObjID_MTZBoss,id(a1) ; load obj54
	move.b	#4,boss_subtype(a1)		; => Obj54_Laser
	move.l	a0,objoff_34(a1)
	move.w	#$1E,(Boss_Countdown).w
	move.b	#$10,objoff_2F(a0)
+
	rts
; ===========================================================================
;loc_32774
Obj54_AlignSprites:
	move.w	x_pos(a0),d0
	move.w	y_pos(a0),d1
	move.w	d0,sub2_x_pos(a0)
	move.w	d1,sub2_y_pos(a0)
	move.w	d0,sub3_x_pos(a0)
	move.w	d1,sub3_y_pos(a0)
	rts
; ===========================================================================
;loc_3278E
Obj54_AnimateFace:
	bsr.w	Obj54_CheckHit
	cmpi.b	#$3F,boss_invulnerable_time(a0)
	bne.s	++
	st.b	objoff_38(a0)
	lea	(Boss_AnimationArray).w,a1
	andi.b	#$F0,2(a1)
	ori.b	#5,2(a1)
	tst.b	objoff_3E(a0)
	beq.s	+
	move.b	#$A,angle(a0)		; => Obj54_MainSubA
	move.w	#-$180,(Boss_Y_vel).w
	subq.b	#1,objoff_3E(a0)
	move.w	#0,(Boss_X_vel).w
+
	move.w	#0,(Boss_X_vel).w
	rts
; ===========================================================================
+
	cmpi.b	#4,(MainCharacter+routine).w
	beq.s	+
	cmpi.b	#4,(Sidekick+routine).w
	bne.s	++		; rts
+
	lea	(Boss_AnimationArray).w,a1
	move.b	2(a1),d0
	andi.b	#$F,d0
	cmpi.b	#4,d0
	beq.s	+		; rts
	andi.b	#$F0,2(a1)
	ori.b	#4,2(a1)
+
	rts
; ===========================================================================
;loc_32802
Obj54_MainSub10:
	subq.w	#1,(Boss_Countdown).w
	cmpi.w	#$3C,(Boss_Countdown).w
	blo.s	++
	bmi.s	+
	bsr.w	Boss_LoadExplosion
	lea	(Boss_AnimationArray).w,a1
	move.b	#7,2(a1)
	bra.s	++
; ===========================================================================
+
	bset	#0,render_flags(a0)
	clr.w	(Boss_X_vel).w
	clr.w	(Boss_Y_vel).w
	addq.b	#2,angle(a0)		; => Obj54_MainSub12
	move.w	#-$12,(Boss_Countdown).w
	lea	(Boss_AnimationArray).w,a1
	move.b	#3,2(a1)
	jsrto	(PlayLevelMusic).l, JmpTo7_PlayLevelMusic
+
	move.w	(Boss_Y_pos).w,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	lea	(Ani_obj53).l,a1
	bsr.w	AnimateBoss
	bsr.w	Obj54_AlignSprites
	jmpto	(DisplaySprite).l, JmpTo40_DisplaySprite
; ===========================================================================
;loc_32864
Obj54_MainSub12:
	move.w	#$400,(Boss_X_vel).w
	move.w	#-$40,(Boss_Y_vel).w
	cmpi.w	#$2BF0,(Camera_Max_X_pos).w
	bhs.s	+
	addq.w	#2,(Camera_Max_X_pos).w
	bra.s	++
; ===========================================================================
+
	tst.b	render_flags(a0)
	bpl.s	JmpTo60_DeleteObject
+
	tst.b	(Boss_defeated_flag).w
	bne.s	+
	move.b	#1,(Boss_defeated_flag).w
	jsrto	(LoadPLC_AnimalExplosion).l, JmpTo7_LoadPLC_AnimalExplosion
+
	bsr.w	Boss_MoveObject
	bsr.w	loc_328C0
	move.w	(Boss_Y_pos).w,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	lea	(Ani_obj53).l,a1
	bsr.w	AnimateBoss
	bsr.w	Obj54_AlignSprites
	jmpto	(DisplaySprite).l, JmpTo40_DisplaySprite
; ===========================================================================

JmpTo60_DeleteObject 
	jmp	(DeleteObject).l
; ===========================================================================

loc_328C0:
	move.b	mapping_frame(a0),d0
	jsr	(CalcSine).l
	asr.w	#6,d0
	add.w	(Boss_Y_pos).w,d0
	move.w	d0,y_pos(a0)
	move.w	(Boss_X_pos).w,x_pos(a0)
	addq.b	#2,mapping_frame(a0)
;loc_328DE
Obj54_CheckHit:
	cmpi.b	#$10,angle(a0)
	bhs.s	return_32924
	tst.b	boss_hitcount2(a0)
	beq.s	Obj54_Defeated
	tst.b	collision_flags(a0)
	bne.s	return_32924
	tst.b	boss_invulnerable_time(a0)
	bne.s	+
	move.b	#$40,boss_invulnerable_time(a0)
	move.w	#SndID_BossHit,d0
	jsr	(PlaySound).l
+
	lea	(Normal_palette_line2+2).w,a1
	moveq	#0,d0
	tst.w	(a1)
	bne.s	+
	move.w	#$EEE,d0
+
	move.w	d0,(a1)
	subq.b	#1,boss_invulnerable_time(a0)
	bne.s	return_32924
	move.b	#$F,collision_flags(a0)

return_32924:
	rts
; ===========================================================================
;loc_32926
Obj54_Defeated:
	moveq	#100,d0
	jsrto	(AddPoints).l, JmpTo8_AddPoints
	move.w	#$EF,(Boss_Countdown).w
	move.b	#$10,angle(a0)		; => Obj54_MainSub10
	moveq	#PLCID_Capsule,d0
	jsrto	(LoadPLC).l, JmpTo11_LoadPLC
	rts