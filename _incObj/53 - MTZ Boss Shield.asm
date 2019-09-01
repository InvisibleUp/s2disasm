; ----------------------------------------------------------------------------
; Object 53 - Shield orbs that surround MTZ boss
; ----------------------------------------------------------------------------
; Sprite_32940:
Obj53:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj53_Index(pc,d0.w),d1
	jmp	Obj53_Index(pc,d1.w)
; ===========================================================================
; off_3294E:
Obj53_Index:	offsetTable
		offsetTableEntry.w Obj53_Init	; 0
		offsetTableEntry.w Obj53_Main	; 2
		offsetTableEntry.w Obj53_BreakAway	; 4
		offsetTableEntry.w Obj53_BounceAround	; 6
		offsetTableEntry.w Obj53_Burst	; 8
; ===========================================================================
; loc_32958:
Obj53_Init:
	movea.l	a0,a1
	moveq	#6,d3
	moveq	#0,d2
	bra.s	+
; ===========================================================================
-	jsrto	(SingleObjLoad).l, JmpTo17_SingleObjLoad
	bne.s	++
+
	move.b	#$20,width_pixels(a1)
	move.l	objoff_34(a0),objoff_34(a1)
	move.b	#ObjID_MTZBossOrb,id(a1) ; load obj53
	move.l	#Obj54_MapUnc_32DC6,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_MTZBoss,0,0),art_tile(a1)
	ori.b	#4,render_flags(a1)
	move.b	#3,priority(a1)
	addq.b	#2,routine(a1)		; => Obj53_Main
	move.b	#5,mapping_frame(a1)
	move.b	byte_329CC(pc,d2.w),objoff_28(a1)
	move.b	byte_329CC(pc,d2.w),objoff_3B(a1)
	move.b	byte_329D3(pc,d2.w),objoff_3A(a1)
	move.b	#$40,objoff_29(a1)
	move.b	#$87,collision_flags(a1)
	move.b	#2,collision_property(a1)
	move.b	#0,objoff_3C(a1)
	addq.w	#1,d2
	dbf	d3,-
+
	rts
; ===========================================================================
byte_329CC:
	dc.b $24
	dc.b $6C	; 1
	dc.b $B4	; 2
	dc.b $FC	; 3
	dc.b $48	; 4
	dc.b $90	; 5
	dc.b $D8	; 6
	rev02even
byte_329D3:
	dc.b   0
	dc.b   1	; 1
	dc.b   1	; 2
	dc.b   0	; 3
	dc.b   1	; 4
	dc.b   1	; 5
	dc.b   0	; 6
	even
; ===========================================================================
;loc_329DA
Obj53_Main:
	movea.l	objoff_34(a0),a1 ; a1=object
	move.w	y_pos(a1),objoff_2A(a0)
	subi_.w	#4,objoff_2A(a0)
	move.w	x_pos(a1),objoff_38(a0)
	tst.b	objoff_38(a1)
	beq.s	Obj53_ClearBossCollision
	move.b	#0,objoff_38(a1)
	addi_.b	#1,objoff_2C(a1)
	addq.b	#2,routine(a0)		; => Obj53_BreakAway
	move.b	#$3C,objoff_32(a0)
	move.b	#2,anim(a0)
	move.w	#-$400,y_vel(a0)
	move.w	#-$80,d1
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	bpl.s	+
	neg.w	d1
+
	cmpi.w	#$2AF0,x_pos(a0)
	bhs.s	+
	move.w	#$80,d1
+
	cmpi.w	#$2BB0,x_pos(a0)
	blo.s	+
	move.w	#-$80,d1
+
	bclr	#0,render_flags(a0)
	tst.w	d1
	bmi.s	+
	bset	#0,render_flags(a0)
+
	move.w	d1,x_vel(a0)
	bra.s	+
; ===========================================================================
;loc_32A56
Obj53_ClearBossCollision:
	cmpi.b	#2,collision_property(a0)
	beq.s	+
	move.b	#0,collision_flags(a1)
+
	bsr.w	Obj53_OrbitBoss
	bsr.w	Obj53_SetAnimPriority
	jmpto	(DisplaySprite).l, JmpTo40_DisplaySprite
; ===========================================================================
;loc_32A70
Obj53_OrbitBoss:
	move.b	objoff_29(a0),d0
	jsr	(CalcSine).l
	move.w	d0,d3
	moveq	#0,d1
	move.b	objoff_33(a1),d1
	muls.w	d1,d0
	move.w	d0,d5
	move.w	d0,d4
	move.b	objoff_39(a1),d2
	tst.b	objoff_3A(a1)
	beq.s	+
	move.w	#$10,d2
+
	muls.w	d3,d2
	move.w	objoff_38(a0),d6
	move.b	objoff_28(a0),d0
	jsr	(CalcSine).l
	muls.w	d0,d5
	swap	d5
	add.w	d6,d5
	move.w	d5,x_pos(a0)
	muls.w	d1,d4
	swap	d4
	move.w	d4,objoff_30(a0)
	move.w	objoff_2A(a0),d6
	move.b	objoff_3B(a0),d0
	tst.b	objoff_3A(a1)
	beq.s	+
	move.b	objoff_3C(a0),d0
+
	jsr	(CalcSine).l
	muls.w	d0,d2
	swap	d2
	add.w	d6,d2
	move.w	d2,y_pos(a0)
	addq.b	#4,objoff_28(a0)
	tst.b	objoff_3A(a1)
	bne.s	+
	addq.b	#8,objoff_3B(a0)
	rts
; ===========================================================================
+
	cmpi.b	#-1,objoff_3A(a1)
	beq.s	++
	cmpi.b	#$80,objoff_3A(a1)
	bne.s	+
	subq.b	#2,objoff_3C(a0)
	bpl.s	return_32B18
	clr.b	objoff_3C(a0)
+
	move.b	#0,objoff_3A(a1)
	rts
; ===========================================================================
+
	cmpi.b	#$40,objoff_3C(a0)
	bhs.s	return_32B18
	addq.b	#2,objoff_3C(a0)

return_32B18:
	rts
; ===========================================================================
;loc_32B1A
Obj53_SetAnimPriority:
	move.w	objoff_30(a0),d0
	bmi.s	++
	cmpi.w	#$C,d0
	blt.s	+
	move.b	#3,mapping_frame(a0)
	move.b	#1,priority(a0)
	rts
; ===========================================================================
+
	move.b	#4,mapping_frame(a0)
	move.b	#2,priority(a0)
	rts
; ===========================================================================
+
	cmpi.w	#-$C,d0
	blt.s	+
	move.b	#4,mapping_frame(a0)
	move.b	#6,priority(a0)
	rts
; ===========================================================================
+
	move.b	#5,mapping_frame(a0)
	move.b	#7,priority(a0)
	rts
; ===========================================================================
;loc_32B64
Obj53_BreakAway:
	tst.b	objoff_32(a0)
	bmi.s	+
	subq.b	#1,objoff_32(a0)
	bpl.s	+
	move.b	#$DA,collision_flags(a0)
+
	jsrto	(ObjectMoveAndFall).l, JmpTo6_ObjectMoveAndFall
	subi.w	#$20,y_vel(a0)
	cmpi.w	#$180,y_vel(a0)
	blt.s	+
	move.w	#$180,y_vel(a0)
+
	cmpi.w	#$4AC,y_pos(a0)
	blo.s	Obj53_Animate
	move.w	#$4AC,y_pos(a0)
	move.w	#$4AC,objoff_2E(a0)
	move.b	#1,objoff_2C(a0)
	addq.b	#2,routine(a0)
	bsr.w	Obj53_FaceLeader
;loc_32BB0
Obj53_Animate:
	bsr.w	+
	lea	(Ani_obj53).l,a1
	jsrto	(AnimateSprite).l, JmpTo21_AnimateSprite
	jmpto	(DisplaySprite).l, JmpTo40_DisplaySprite
; ===========================================================================
+
	cmpi.b	#-2,collision_property(a0)
	bgt.s	+		; rts
	move.b	#$14,mapping_frame(a0)
	move.b	#6,anim(a0)
	addq.b	#2,routine(a0)
+
	rts
; ===========================================================================
;loc_32BDC
Obj53_BounceAround:
	tst.b	objoff_32(a0)
	bmi.s	+
	subq.b	#1,objoff_32(a0)
	bpl.s	+
	move.b	#$DA,collision_flags(a0)
+
	bsr.w	Obj53_CheckPlayerHit
	cmpi.b	#$B,mapping_frame(a0)
	bne.s	Obj53_Animate
	move.b	objoff_2C(a0),d0
	jsr	(CalcSine).l
	neg.w	d0
	asr.w	#2,d0
	add.w	objoff_2E(a0),d0
	cmpi.w	#$4AC,d0
	bhs.s	++
	move.w	d0,y_pos(a0)
	addq.b	#1,objoff_2C(a0)
	btst	#0,objoff_2C(a0)
	beq.w	JmpTo40_DisplaySprite
	moveq	#-1,d0
	btst	#0,render_flags(a0)
	beq.s	+
	neg.w	d0
+
	add.w	d0,x_pos(a0)
	jmpto	(DisplaySprite).l, JmpTo40_DisplaySprite
; ===========================================================================
+
	move.w	#$4AC,y_pos(a0)
	bsr.w	Obj53_FaceLeader
	move.b	#1,objoff_2C(a0)
	jmpto	(DisplaySprite).l, JmpTo40_DisplaySprite
; ===========================================================================
;loc_32C4C
Obj53_FaceLeader:
	move.w	(MainCharacter+x_pos).w,d0
	sub.w	x_pos(a0),d0
	bpl.s	+
	bclr	#0,render_flags(a0)
	rts
; ===========================================================================
+
	bset	#0,render_flags(a0)
	rts
; ===========================================================================
;loc_32C66
Obj53_CheckPlayerHit:
	cmpi.b	#4,(MainCharacter+routine).w
	beq.s	+
	cmpi.b	#4,(Sidekick+routine).w
	bne.s	++
+
	move.b	#$14,mapping_frame(a0)
	move.b	#6,anim(a0)
+
	cmpi.b	#-2,collision_property(a0)
	bgt.s	+
	move.b	#$14,mapping_frame(a0)
	move.b	#6,anim(a0)
+
	rts
; ===========================================================================
;loc_32C98
Obj53_Burst:
	move.b	#SndID_BossExplosion,d0
	jsrto	(PlaySound).l, JmpTo10_PlaySound
	movea.l	objoff_34(a0),a1 ; a1=object
	subi_.b	#1,objoff_2C(a1)

    if removeJmpTos
JmpTo61_DeleteObject 
    endif

	jmpto	(DeleteObject).l, JmpTo61_DeleteObject
; ===========================================================================
;loc_32CAE
Obj54_Laser:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	off_32CBC(pc,d0.w),d0
	jmp	off_32CBC(pc,d0.w)
; ===========================================================================
off_32CBC:	offsetTable
		offsetTableEntry.w Obj54_Laser_Init	; 0
		offsetTableEntry.w Obj54_Laser_Main	; 2
; ===========================================================================
;loc_32CC0
Obj54_Laser_Init:
	move.l	#Obj54_MapUnc_32DC6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_MTZBoss,0,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#5,priority(a0)
	move.b	#$12,mapping_frame(a0)
	addq.b	#2,routine_secondary(a0)	; => Obj54_Laser_Main
	movea.l	objoff_34(a0),a1 ; a1=object
	move.b	#$50,width_pixels(a0)
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	addi_.w	#7,y_pos(a0)
	subi_.w	#4,x_pos(a0)
	move.w	#-$400,d0
	btst	#0,render_flags(a1)
	beq.s	+
	neg.w	d0
	addi_.w	#8,x_pos(a0)
+
	move.w	d0,x_vel(a0)
	move.b	#$99,collision_flags(a0)
	move.b	#SndID_LaserBurst,d0
	jsrto	(PlaySound).l, JmpTo10_PlaySound
;loc_32D2C
Obj54_Laser_Main:
	jsrto	(ObjectMove).l, JmpTo24_ObjectMove
	cmpi.w	#$2AB0,x_pos(a0)
	blo.w	JmpTo61_DeleteObject
	cmpi.w	#$2BF0,x_pos(a0)
	bhs.w	JmpTo61_DeleteObject
	jmpto	(DisplaySprite).l, JmpTo40_DisplaySprite
; ===========================================================================
;loc_32D48
Obj54_LaserShooter:
	movea.l	objoff_34(a0),a1 ; a1=object
	cmpi.b	#ObjID_MTZBoss,id(a1)
	bne.w	JmpTo61_DeleteObject
	move.w	x_pos(a1),x_pos(a0)
	move.w	y_pos(a1),y_pos(a0)
	bclr	#0,render_flags(a0)
	btst	#0,render_flags(a1)
	beq.w	JmpTo40_DisplaySprite
	bset	#0,render_flags(a0)

    if removeJmpTos
JmpTo40_DisplaySprite 
    endif

	jmpto	(DisplaySprite).l, JmpTo40_DisplaySprite
; ===========================================================================
; animation script
; off_32D7A:
Ani_obj53:	offsetTable
		offsetTableEntry.w byte_32D8A	; 0
		offsetTableEntry.w byte_32D8D	; 1
		offsetTableEntry.w byte_32D91	; 2
		offsetTableEntry.w byte_32DA6	; 3
		offsetTableEntry.w byte_32DAA	; 4
		offsetTableEntry.w byte_32DB5	; 5
		offsetTableEntry.w byte_32DC0	; 6
		offsetTableEntry.w byte_32DC3	; 7
byte_32D8A:	dc.b  $F,  2,$FF
	rev02even
byte_32D8D:	dc.b   1,  0,  1,$FF
	rev02even
byte_32D91:	dc.b   3,  5,  5,  5,  5,  5,  5,  5,  5,  6,  7,  6,  7,  6,  7,  8
		dc.b   9, $A, $B,$FE,  1; 16
	rev02even
byte_32DA6:	dc.b   7, $C, $D,$FF
	rev02even
byte_32DAA:	dc.b   7, $E, $F, $E, $F, $E, $F, $E, $F,$FD,  3
	rev02even
byte_32DB5:	dc.b   7,$10,$10,$10,$10,$10,$10,$10,$10,$FD,  3
	rev02even
byte_32DC0:	dc.b   1,$14,$FC
	rev02even
byte_32DC3:	dc.b   7,$11,$FF
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj54_MapUnc_32DC6:	BINCLUDE "mappings/sprite/obj54.bin"

    if ~~removeJmpTos
	align 4
    endif
; ===========================================================================

    if ~~removeJmpTos
JmpTo40_DisplaySprite 
	jmp	(DisplaySprite).l
JmpTo61_DeleteObject 
	jmp	(DeleteObject).l
JmpTo17_SingleObjLoad 
	jmp	(SingleObjLoad).l
JmpTo10_PlaySound 
	jmp	(PlaySound).l
JmpTo21_AnimateSprite 
	jmp	(AnimateSprite).l
JmpTo11_LoadPLC 
	jmp	(LoadPLC).l
JmpTo8_AddPoints 
	jmp	(AddPoints).l
JmpTo7_PlayLevelMusic 
	jmp	(PlayLevelMusic).l
JmpTo7_LoadPLC_AnimalExplosion 
	jmp	(LoadPLC_AnimalExplosion).l
JmpTo6_ObjectMoveAndFall 
	jmp	(ObjectMoveAndFall).l
; loc_32F88:
JmpTo24_ObjectMove 
	jmp	(ObjectMove).l

	align 4
    endif
