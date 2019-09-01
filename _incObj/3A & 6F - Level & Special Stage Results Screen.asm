; ----------------------------------------------------------------------------
; Object 3A - End of level results screen
; ----------------------------------------------------------------------------
; Sprite_14086:
Obj3A: ; (screen-space obj)
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj3A_Index(pc,d0.w),d1
	jmp	Obj3A_Index(pc,d1.w)
; ===========================================================================
; off_14094:
Obj3A_Index:	offsetTable
		offsetTableEntry.w loc_140AC					;   0
		offsetTableEntry.w loc_14102					;   2
		offsetTableEntry.w BranchTo_Obj34_MoveTowardsTargetPosition	;   4
		offsetTableEntry.w loc_14146					;   6
		offsetTableEntry.w loc_14168					;   8
		offsetTableEntry.w loc_1419C					;  $A
		offsetTableEntry.w loc_141AA					;  $C
		offsetTableEntry.w loc_1419C					;  $E
		offsetTableEntry.w loc_14270					; $10
		offsetTableEntry.w loc_142B0					; $12
		offsetTableEntry.w loc_142CC					; $14
		offsetTableEntry.w loc_1413A					; $16
; ===========================================================================

loc_140AC:
	tst.l	(Plc_Buffer).w
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	movea.l	a0,a1
	lea	byte_14380(pc),a2
	moveq	#7,d1

loc_140BC:
	_move.b	id(a1),d0
	beq.s	loc_140CE
	cmpi.b	#ObjID_Results,d0
	beq.s	loc_140CE
	lea	next_object(a1),a1 ; a1=object
	bra.s	loc_140BC
; ===========================================================================

loc_140CE:
	_move.b	#ObjID_Results,id(a1) ; load obj3A
	move.w	(a2)+,x_pixel(a1)
	move.w	(a2)+,objoff_30(a1)
	move.w	(a2)+,y_pixel(a1)
	move.b	(a2)+,routine(a1)
	move.b	(a2)+,mapping_frame(a1)
	move.l	#Obj3A_MapUnc_14CBC,mappings(a1)
	bsr.w	Adjust2PArtPointer2
	move.b	#0,render_flags(a1)
	lea	next_object(a1),a1 ; a1=object
	dbf	d1,loc_140BC

loc_14102:
	moveq	#0,d0
	cmpi.w	#2,(Player_mode).w
	bne.s	loc_14118
	addq.w	#1,d0
	btst	#7,(Graphics_Flags).w
	beq.s	loc_14118
	addq.w	#1,d0

loc_14118:

	move.b	d0,mapping_frame(a0)
	bsr.w	Obj34_MoveTowardsTargetPosition
	move.w	x_pixel(a0),d0
	cmp.w	objoff_30(a0),d0
	bne.w	return_14138
	move.b	#$A,routine(a0)
	move.w	#$B4,anim_frame_duration(a0)

return_14138:
	rts
; ===========================================================================

loc_1413A:
	tst.w	(Perfect_rings_left).w
	bne.w	DeleteObject

BranchTo_Obj34_MoveTowardsTargetPosition 
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================

loc_14146:
	move.b	(Current_Zone).w,d0
	cmpi.b	#sky_chase_zone,d0
	beq.s	loc_1415E
	cmpi.b	#wing_fortress_zone,d0
	beq.s	loc_1415E
	cmpi.b	#death_egg_zone,d0
	bne.w	Obj34_MoveTowardsTargetPosition

loc_1415E:

	move.b	#5,mapping_frame(a0)
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================

loc_14168:
	move.b	(Current_Zone).w,d0
	cmpi.b	#sky_chase_zone,d0
	beq.w	BranchTo9_DeleteObject
	cmpi.b	#wing_fortress_zone,d0
	beq.w	BranchTo9_DeleteObject
	cmpi.b	#death_egg_zone,d0
	beq.w	BranchTo9_DeleteObject
	cmpi.b	#metropolis_zone_2,d0
	bne.s	loc_1418E
	moveq	#8,d0
	bra.s	loc_14194
; ===========================================================================

loc_1418E:
	move.b	(Current_Act).w,d0
	addq.b	#6,d0

loc_14194:
	move.b	d0,mapping_frame(a0)
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================

loc_1419C:
	subq.w	#1,anim_frame_duration(a0)
	bne.s	BranchTo18_DisplaySprite
	addq.b	#2,routine(a0)

BranchTo18_DisplaySprite 
	bra.w	DisplaySprite
; ===========================================================================

loc_141AA:
	bsr.w	DisplaySprite
	move.b	#1,(Update_Bonus_score).w
	moveq	#0,d0
	tst.w	(Bonus_Countdown_1).w
	beq.s	loc_141C6
	addi.w	#10,d0
	subi.w	#10,(Bonus_Countdown_1).w

loc_141C6:
	tst.w	(Bonus_Countdown_2).w
	beq.s	loc_141D6
	addi.w	#10,d0
	subi.w	#10,(Bonus_Countdown_2).w

loc_141D6:
	tst.w	(Bonus_Countdown_3).w
	beq.s	loc_141E6
	addi.w	#10,d0
	subi.w	#10,(Bonus_Countdown_3).w

loc_141E6:
	add.w	d0,(Total_Bonus_Countdown).w
	tst.w	d0
	bne.s	loc_14256
	move.w	#SndID_TallyEnd,d0
	jsr	(PlaySound).l
	addq.b	#2,routine(a0)
	move.w	#$B4,anim_frame_duration(a0)
	cmpi.w	#1000,(Total_Bonus_Countdown).w
	blo.s	return_14254
	move.w	#$12C,anim_frame_duration(a0)
	lea	next_object(a0),a1 ; a1=object

loc_14214:
	_tst.b	id(a1)
	beq.s	loc_14220
	lea	next_object(a1),a1 ; a1=object
	bra.s	loc_14214
; ===========================================================================

loc_14220:
	_move.b	#ObjID_Results,id(a1) ; load obj3A (uses screen-space)
	move.b	#$12,routine(a1)
	move.w	#$188,x_pixel(a1)
	move.w	#$118,y_pixel(a1)
	move.l	#Obj3A_MapUnc_14CBC,mappings(a1)
	bsr.w	Adjust2PArtPointer2
	move.b	#0,render_flags(a1)
	move.w	#$3C,anim_frame_duration(a1)
	addq.b	#1,(Continue_count).w

return_14254:

	rts
; ===========================================================================

loc_14256:
	jsr	(AddPoints).l
	move.b	(Vint_runcount+3).w,d0
	andi.b	#3,d0
	bne.s	return_14254
	move.w	#SndID_Blip,d0
	jmp	(PlaySound).l
; ===========================================================================

loc_14270:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	add.b	(Current_Act).w,d0
	add.w	d0,d0
	lea	LevelOrder(pc),a1
	tst.w	(Two_player_mode).w
	beq.s	loc_1428C
	lea	LevelOrder_2P(pc),a1

loc_1428C:
	move.w	(a1,d0.w),d0
	tst.w	d0
	bpl.s	loc_1429C
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; => SegaScreen
	rts
; ===========================================================================

loc_1429C:
	move.w	d0,(Current_ZoneAndAct).w
	clr.b	(Last_star_pole_hit).w
	clr.b	(Last_star_pole_hit_2P).w
	move.w	#1,(Level_Inactive_flag).w
	rts
; ===========================================================================

loc_142B0:
	tst.w	anim_frame_duration(a0)
	beq.s	loc_142BC
	subq.w	#1,anim_frame_duration(a0)
	rts
; ===========================================================================

loc_142BC:
	addi_.b	#2,routine(a0)
	move.w	#SndID_ContinueJingle,d0
	jsr	(PlaySound).l

loc_142CC:
	subq.w	#1,anim_frame_duration(a0)
	bpl.s	loc_142E2
	move.w	#$13,anim_frame_duration(a0)
	addq.b	#1,anim_frame(a0)
	andi.b	#1,anim_frame(a0)

loc_142E2:
	moveq	#$C,d0
	add.b	anim_frame(a0),d0
	move.b	d0,mapping_frame(a0)
	btst	#4,(Timer_frames+1).w
	bne.w	DisplaySprite
	rts

; Level order
	include "levels/tables/LevelOrder.asm"

;word_142F8:
byte_14380:
results_screen_object macro startx, targetx, y, routine, frame
	dc.w	startx, targetx, y
	dc.b	routine, frame
    endm
	results_screen_object   $20, $120,  $B8,   2,  0
	results_screen_object  $200, $100,  $CA,   4,  3
	results_screen_object  $240, $140,  $CA,   6,  4
	results_screen_object  $278, $178,  $BE,   8,  6
	results_screen_object  $350, $120, $120,   4,  9
	results_screen_object  $320, $120,  $F0,   4, $A
	results_screen_object  $330, $120, $100,   4, $B
	results_screen_object  $340, $120, $110, $16, $E

; ----------------------------------------------------------------------------
; Object 6F - End of special stage results screen
; ----------------------------------------------------------------------------
; Sprite_143C0:
Obj6F: ; (note: screen-space obj)
	moveq	#0,d0
	moveq	#0,d6
	move.b	routine(a0),d0
	move.w	Obj6F_Index(pc,d0.w),d1
	jmp	Obj6F_Index(pc,d1.w)
; ===========================================================================
; off_143D0:
Obj6F_Index:	offsetTable
		offsetTableEntry.w Obj6F_Init	;   0
		offsetTableEntry.w Obj6F_InitEmeraldText	;   2
		offsetTableEntry.w Obj6F_InitResultTitle	;   4
		offsetTableEntry.w Obj6F_Emerald0	;   6
		offsetTableEntry.w Obj6F_Emerald1	;   8
		offsetTableEntry.w Obj6F_Emerald2	;  $A
		offsetTableEntry.w Obj6F_Emerald3	;  $C
		offsetTableEntry.w Obj6F_Emerald4	;  $E
		offsetTableEntry.w Obj6F_Emerald5	; $10
		offsetTableEntry.w Obj6F_Emerald6	; $12
		offsetTableEntry.w BranchTo3_Obj34_MoveTowardsTargetPosition	; $14
		offsetTableEntry.w Obj6F_P1Rings	; $16
		offsetTableEntry.w Obj6F_P2Rings	; $18
		offsetTableEntry.w Obj6F_DeleteIfNotEmerald	; $1A
		offsetTableEntry.w Obj6F_TimedDisplay	; $1C
		offsetTableEntry.w Obj6F_TallyScore	; $1E
		offsetTableEntry.w Obj6F_TimedDisplay	; $20
		offsetTableEntry.w Obj6F_DisplayOnly	; $22
		offsetTableEntry.w Obj6F_TimedDisplay	; $24
		offsetTableEntry.w Obj6F_TimedDisplay	; $26
		offsetTableEntry.w Obj6F_TallyPerfect	; $28
		offsetTableEntry.w Obj6F_PerfectBonus	; $2A
		offsetTableEntry.w Obj6F_TimedDisplay	; $2C
		offsetTableEntry.w Obj6F_DisplayOnly	; $2E
		offsetTableEntry.w Obj6F_InitAndMoveSuperMsg	; $30
		offsetTableEntry.w Obj6F_MoveToTargetPos	; $32
		offsetTableEntry.w Obj6F_MoveAndDisplay	; $34
; ===========================================================================
;loc_14406
Obj6F_Init:
	tst.l	(Plc_Buffer).w
	beq.s	+
	rts
; ===========================================================================
+
	movea.l	a0,a1
	lea	byte_14752(pc),a2
	moveq	#$C,d1

-	_move.b	id(a0),id(a1) ; load obj6F
	move.w	(a2),x_pixel(a1)
	move.w	(a2)+,objoff_32(a1)
	move.w	(a2)+,objoff_30(a1)
	move.w	(a2)+,y_pixel(a1)
	move.b	(a2)+,routine(a1)
	move.b	(a2)+,mapping_frame(a1)
	move.l	#Obj6F_MapUnc_14ED0,mappings(a1)
	move.b	#$78,width_pixels(a1)
	move.b	#0,render_flags(a1)
	lea	next_object(a1),a1 ; go to next object ; a1=object
	dbf	d1,- ; loop

;loc_14450
Obj6F_InitEmeraldText:
	tst.b	(Got_Emerald).w
	beq.s	+
	move.b	#4,mapping_frame(a0)		; "Chaos Emerald"
+
	cmpi.b	#7,(Emerald_count).w
	bne.s	+
	move.b	#$19,mapping_frame(a0)		; "Chaos Emeralds"
+
	move.w	objoff_30(a0),d0
	cmp.w	x_pixel(a0),d0
	bne.s	BranchTo2_Obj34_MoveTowardsTargetPosition
	move.b	#$1C,routine(a0)	; => Obj6F_TimedDisplay
	move.w	#$B4,anim_frame_duration(a0)

BranchTo2_Obj34_MoveTowardsTargetPosition 
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================
;loc_14484
Obj6F_InitResultTitle:
	cmpi.b	#7,(Emerald_count).w
	bne.s	+
	moveq	#$16,d0		; "Sonic has all the"
	bra.s	++
; ===========================================================================
+
	tst.b	(Got_Emerald).w
	beq.w	DeleteObject
	moveq	#1,d0		; "Sonic got a"
+
	cmpi.w	#2,(Player_mode).w
	bne.s	+
	addq.w	#1,d0		; "Miles got a" or "Miles has all the"
	btst	#7,(Graphics_Flags).w
	beq.s	+
	addq.w	#1,d0		; "Tails got a" or "Tails has all the"
+
	move.b	d0,mapping_frame(a0)
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================
;loc_144B6
Obj6F_Emerald6:
	addq.w	#1,d6
;loc_144B8
Obj6F_Emerald5:
	addq.w	#1,d6
;loc_144BA
Obj6F_Emerald4:
	addq.w	#1,d6
;loc_144BC
Obj6F_Emerald3:
	addq.w	#1,d6
;loc_144BE
Obj6F_Emerald2:
	addq.w	#1,d6
;loc_144C0
Obj6F_Emerald1:
	addq.w	#1,d6
;loc_144C2
Obj6F_Emerald0:
	lea	(Got_Emeralds_array).w,a1
	tst.b	(a1,d6.w)
	beq.w	DeleteObject
	btst	#0,(Vint_runcount+3).w
	beq.s	+
	bsr.w	DisplaySprite
+
	rts
; ===========================================================================
;loc_144DC
Obj6F_P2Rings:
	tst.w	(Player_mode).w
	bne.w	DeleteObject
	cmpi.b	#$26,(SpecialStageResults+routine).w	; Do we need space for perfect countdown?
	beq.w	DeleteObject							; Branch if yes
	moveq	#$E,d0		; "Miles rings"
	btst	#7,(Graphics_Flags).w
	beq.s	+
	addq.w	#1,d0		; "Tails rings"
+
	lea	(Bonus_Countdown_2).w,a1
	bra.s	loc_1455A
; ===========================================================================
;loc_14500
Obj6F_P1Rings:
	cmpi.b	#$26,(SpecialStageResults+routine).w	; Do we need space for perfect countdown?
	bne.s	+										; Branch if not
	move.w	#5000,(Bonus_Countdown_1).w				; Perfect bonus
	move.b	#$2A,routine(a0)	; => Obj6F_PerfectBonus
	move.w	#$120,y_pixel(a0)
	st.b	(Update_Bonus_score).w	; set to -1 (update)
	move.w	#SndID_Signpost,d0
	jsr	(PlaySound).l
	move.w	#$5A,(SpecialStageResults+anim_frame_duration).w
	bra.w	Obj6F_PerfectBonus
; ===========================================================================
+
	move.w	(Player_mode).w,d0
	beq.s	++
	move.w	#$120,y_pixel(a0)
	subq.w	#1,d0
	beq.s	++
	moveq	#$E,d0		; "Miles rings"
	btst	#7,(Graphics_Flags).w
	beq.s	+
	addq.w	#1,d0		; "Tails rings"
+
	lea	(Bonus_Countdown_2).w,a1
	bra.s	loc_1455A
; ===========================================================================
+
	moveq	#$D,d0		; "Sonic rings"
	lea	(Bonus_Countdown_1).w,a1

loc_1455A:
	tst.w	(a1)
	bne.s	+
	addq.w	#5,d0		; Rings text with zero points
+
	move.b	d0,mapping_frame(a0)

BranchTo3_Obj34_MoveTowardsTargetPosition 
	bra.w	Obj34_MoveTowardsTargetPosition
; ===========================================================================
;loc_14568
Obj6F_DeleteIfNotEmerald:
	tst.b	(Got_Emerald).w
	beq.w	DeleteObject
	bra.s	BranchTo3_Obj34_MoveTowardsTargetPosition
; ===========================================================================
;loc_14572
Obj6F_TimedDisplay:
	subq.w	#1,anim_frame_duration(a0)
	bne.s	BranchTo19_DisplaySprite
	addq.b	#2,routine(a0)

BranchTo19_DisplaySprite 
	bra.w	DisplaySprite
; ===========================================================================
;loc_14580
Obj6F_TallyScore:
	bsr.w	DisplaySprite
	move.b	#1,(Update_Bonus_score).w
	moveq	#0,d0
	tst.w	(Bonus_Countdown_1).w
	beq.s	+
	addi.w	#10,d0
	subq.w	#1,(Bonus_Countdown_1).w
+
	tst.w	(Bonus_Countdown_2).w
	beq.s	+
	addi.w	#10,d0
	subq.w	#1,(Bonus_Countdown_2).w
+
	tst.w	(Total_Bonus_Countdown).w
	beq.s	+
	addi.w	#10,d0
	subi.w	#10,(Total_Bonus_Countdown).w
+
	tst.w	d0
	bne.s	+++
	move.w	#SndID_TallyEnd,d0
	jsr	(PlaySound).l
	addq.b	#2,routine(a0)		; => Obj6F_TimedDisplay
	move.w	#$78,anim_frame_duration(a0)
	tst.w	(Perfect_rings_flag).w
	bne.s	+
	cmpi.w	#2,(Player_mode).w
	beq.s	++		; rts
	tst.b	(Got_Emerald).w
	beq.s	++		; rts
	cmpi.b	#7,(Emerald_count).w
	bne.s	++		; rts
	move.b	#$30,routine(a0)	; => Obj6F_InitAndMoveSuperMsg
	rts
; ===========================================================================
+
	move.b	#$24,routine(a0)	; => Obj6F_TimedDisplay
	move.w	#$5A,anim_frame_duration(a0)
/
	rts
; ===========================================================================
+
	jsr	(AddPoints).l
	move.b	(Vint_runcount+3).w,d0
	andi.b	#3,d0
	bne.s	-		; rts
	move.w	#SndID_Blip,d0
	jmp	(PlaySound).l
; ===========================================================================
;loc_1461C
Obj6F_DisplayOnly:
	move.w	#1,(Level_Inactive_flag).w
	bra.w	DisplaySprite
; ===========================================================================
;loc_14626
Obj6F_TallyPerfect:
	bsr.w	DisplaySprite
	move.b	#1,(Update_Bonus_score).w
	moveq	#0,d0
	tst.w	(Bonus_Countdown_1).w
	beq.s	+
	addi.w	#20,d0
	subi.w	#20,(Bonus_Countdown_1).w
+
	tst.w	d0
	beq.s	+
	jsr	(AddPoints).l
	move.b	(Vint_runcount+3).w,d0
	andi.b	#3,d0
	bne.s	++		; rts
	move.w	#SndID_Blip,d0
	jmp	(PlaySound).l
; ===========================================================================
+
	move.w	#SndID_TallyEnd,d0
	jsr	(PlaySound).l
	addq.b	#4,routine(a0)
	move.w	#$78,anim_frame_duration(a0)
	cmpi.w	#2,(Player_mode).w
	beq.s	+		; rts
	tst.b	(Got_Emerald).w
	beq.s	+		; rts
	cmpi.b	#7,(Emerald_count).w
	bne.s	+		; rts
	move.b	#$30,routine(a0)	; => Obj6F_InitAndMoveSuperMsg
+
	rts
; ===========================================================================
;loc_14692
Obj6F_PerfectBonus:
	moveq	#$11,d0		; "Perfect bonus"
	btst	#3,(Vint_runcount+3).w
	beq.s	+
	moveq	#$15,d0		; null text
+
	move.b	d0,mapping_frame(a0)
	bra.w	DisplaySprite
; ===========================================================================
;loc_146A6
Obj6F_InitAndMoveSuperMsg:
	move.b	#$32,next_object+routine(a0)			; => Obj6F_MoveToTargetPos
	move.w	x_pos(a0),d0
	cmp.w	objoff_32(a0),d0
	bne.s	Obj6F_MoveToTargetPos
	move.b	#$14,next_object+routine(a0)			; => BranchTo3_Obj34_MoveTowardsTargetPosition
	subq.w	#8,next_object+y_pixel(a0)
	move.b	#$1A,next_object+mapping_frame(a0)		; "Now Sonic can"
	move.b	#$34,routine(a0)						; => Obj6F_MoveAndDisplay
	subq.w	#8,y_pixel(a0)
	move.b	#$1B,mapping_frame(a0)					; "Change into"
	lea	(SpecialStageResults2).w,a1
	_move.b	id(a0),id(a1) ; load obj6F; (uses screen-space)
	clr.w	x_pixel(a1)
	move.w	#$120,objoff_30(a1)
	move.w	#$B4,y_pixel(a1)
	move.b	#$14,routine(a1)						; => BranchTo3_Obj34_MoveTowardsTargetPosition
	move.b	#$1C,mapping_frame(a1)					; "Super Sonic"
	move.l	#Obj6F_MapUnc_14ED0,mappings(a1)
	move.b	#$78,width_pixels(a1)
	move.b	#0,render_flags(a1)
	bra.w	DisplaySprite
; ===========================================================================
;loc_14714
Obj6F_MoveToTargetPos:
	moveq	#$20,d0
	move.w	x_pos(a0),d1
	cmp.w	objoff_32(a0),d1
	beq.s	BranchTo20_DisplaySprite
	bhi.s	+
	neg.w	d0
+
	sub.w	d0,x_pos(a0)
	cmpi.w	#$200,x_pos(a0)
	bhi.s	+

BranchTo20_DisplaySprite 
	bra.w	DisplaySprite
; ===========================================================================
+
	rts
; ===========================================================================
;loc_14736
Obj6F_MoveAndDisplay:
	move.w	x_pos(a0),d0
	cmp.w	objoff_30(a0),d0
	bne.w	Obj34_MoveTowardsTargetPosition
	move.w	#$B4,anim_frame_duration(a0)
	move.b	#$20,routine(a0)	; => Obj6F_TimedDisplay
	bra.w	DisplaySprite
; ===========================================================================
byte_14752:
	;      startx  targx   starty  routine   map frame
	results_screen_object  $240, $120,  $AA,   2,   0		; "Special Stage"
	results_screen_object     0, $120,  $98,   4,   1		; "Sonic got a"
	results_screen_object  $118,    0,  $C4,   6,   5		; Emerald 0
	results_screen_object  $130,    0,  $D0,   8,   6		; Emerald 1
	results_screen_object  $130,    0,  $E8,  $A,   7		; Emerald 2
	results_screen_object  $118,    0,  $F4,  $C,   8		; Emerald 3
	results_screen_object  $100,    0,  $E8,  $E,   9		; Emerald 4
	results_screen_object  $100,    0,  $D0, $10,  $A		; Emerald 5
	results_screen_object  $118,    0,  $DC, $12,  $B		; Emerald 6
	results_screen_object  $330, $120, $108, $14,  $C		; Score
	results_screen_object  $340, $120, $118, $16,  $D		; Sonic Rings
	results_screen_object  $350, $120, $128, $18,  $E		; Miles Rings
	results_screen_object  $360, $120, $138, $1A, $10		; Gems Bonus
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj34_MapUnc_147BA:	offsetTable
	offsetTableEntry.w word_147E8
	offsetTableEntry.w word_147E8
	offsetTableEntry.w word_147E8
	offsetTableEntry.w word_147E8
	offsetTableEntry.w word_14842
	offsetTableEntry.w word_14842
	offsetTableEntry.w word_14B24
	offsetTableEntry.w word_14894
	offsetTableEntry.w word_148CE
	offsetTableEntry.w word_147E8
	offsetTableEntry.w word_14930
	offsetTableEntry.w word_14972
	offsetTableEntry.w word_149C4
	offsetTableEntry.w word_14A1E
	offsetTableEntry.w word_14B86
	offsetTableEntry.w word_14A88
	offsetTableEntry.w word_14AE2
	offsetTableEntry.w word_14BC8
	offsetTableEntry.w word_14BEA
	offsetTableEntry.w word_14BF4
	offsetTableEntry.w word_14BFE
	offsetTableEntry.w word_14C08
	offsetTableEntry.w word_14C32
word_147E8:	dc.w $B
	dc.w 5,	$8580, $82C0, $FFC3
	dc.w 9,	$85DE, $82EF, $FFD0
	dc.w 5,	$8580, $82C0, $FFE8
	dc.w 5,	$85E4, $82F2, $FFF8
	dc.w 5,	$85E8, $82F4, 8
	dc.w 5,	$85EC, $82F6, $18
	dc.w 5,	$85F0, $82F8, $28
	dc.w 5,	$85F4, $82FA, $48
	dc.w 1,	$85F8, $82FC, $58
	dc.w 5,	$85EC, $82F6, $60
	dc.w 5,	$85EC, $82F6, $70
word_14842:	dc.w $A
	dc.w 9,	$85DE, $82EF, $FFE0
	dc.w 5,	$8580, $82C0, $FFF8
	dc.w 5,	$85E4, $82F2, 8
	dc.w 5,	$85E8, $82F4, $18
	dc.w 5,	$8588, $82C4, $28
	dc.w 5,	$85EC, $82F6, $38
	dc.w 5,	$8588, $82C4, $48
	dc.w 5,	$85F0, $82F8, $58
	dc.w 1,	$85F4, $82FA, $68
	dc.w 5,	$85F6, $82FB, $70
word_14894:	dc.w 7
	dc.w 5,	$85DE, $82EF, 8
	dc.w 1,	$85E2, $82F1, $18
	dc.w 5,	$85E4, $82F2, $20
	dc.w 5,	$85E4, $82F2, $30
	dc.w 5,	$85E8, $82F4, $51
	dc.w 5,	$8588, $82C4, $60
	dc.w 5,	$85EC, $82F6, $70
word_148CE:	dc.w $C
	dc.w 5,	$85DE, $82EF, $FFB8
	dc.w 1,	$85E2, $82F1, $FFC8
	dc.w 5,	$85E4, $82F2, $FFD0
	dc.w 5,	$85E4, $82F2, $FFE0
	dc.w 5,	$8580, $82C0, $FFF0
	dc.w 5,	$8584, $82C2, 0
	dc.w 5,	$85E8, $82F4, $20
	dc.w 5,	$85EC, $82F6, $30
	dc.w 5,	$85F0, $82F8, $40
	dc.w 5,	$85EC, $82F6, $50
	dc.w 5,	$85F4, $82FA, $60
	dc.w 5,	$8580, $82C0, $70
word_14930:	dc.w 8
	dc.w 5,	$8588, $82C4, $FFFB
	dc.w 1,	$85DE, $82EF, $B
	dc.w 5,	$85E0, $82F0, $13
	dc.w 5,	$8588, $82C4, $33
	dc.w 5,	$85E4, $82F2, $43
	dc.w 5,	$8580, $82C0, $53
	dc.w 5,	$85E8, $82F4, $60
	dc.w 5,	$8584, $82C2, $70
word_14972:	dc.w $A
	dc.w 9,	$85DE, $82EF, $FFD0
	dc.w 5,	$85E4, $82F2, $FFE8
	dc.w 5,	$85E8, $82F4, $FFF8
	dc.w 5,	$85EC, $82F6, 8
	dc.w 1,	$85F0, $82F8, $18
	dc.w 5,	$85F2, $82F9, $20
	dc.w 5,	$85F2, $82F9, $41
	dc.w 5,	$85F6, $82FB, $50
	dc.w 5,	$85FA, $82FD, $60
	dc.w 5,	$8580, $82C0, $70
word_149C4:	dc.w $B
	dc.w 5,	$85DE, $82EF, $FFD1
	dc.w 5,	$85E2, $82F1, $FFE0
	dc.w 5,	$85E6, $82F3, $FFF0
	dc.w 1,	$85EA, $82F5, 0
	dc.w 5,	$8584, $82C2, 8
	dc.w 5,	$8588, $82C4, $18
	dc.w 5,	$8584, $82C2, $38
	dc.w 1,	$85EA, $82F5, $48
	dc.w 5,	$85EC, $82F6, $50
	dc.w 5,	$85F0, $82F8, $60
	dc.w 5,	$85F4, $82FA, $70
word_14A1E:	dc.w $D
	dc.w 5,	$85DE, $82EF, $FFA4
	dc.w 5,	$85E2, $82F1, $FFB4
	dc.w 5,	$8580, $82C0, $FFC4
	dc.w 9,	$85E6, $82F3, $FFD1
	dc.w 1,	$85EC, $82F6, $FFE9
	dc.w 5,	$85DE, $82EF, $FFF1
	dc.w 5,	$85EE, $82F7, 0
	dc.w 5,	$85F2, $82F9, $10
	dc.w 5,	$85F6, $82FB, $31
	dc.w 5,	$85F2, $82F9, $41
	dc.w 5,	$85EE, $82F7, $50
	dc.w 5,	$8584, $82C2, $60
	dc.w 5,	$85FA, $82FD, $70
word_14A88:	dc.w $B
	dc.w 5,	$85DE, $82EF, $FFD2
	dc.w 5,	$85E2, $82F1, $FFE2
	dc.w 5,	$85E6, $82F3, $FFF2
	dc.w 5,	$85DE, $82EF, 0
	dc.w 5,	$85EA, $82F5, $10
	dc.w 1,	$85EE, $82F7, $20
	dc.w 5,	$85F0, $82F8, $28
	dc.w 5,	$85F4, $82FA, $48
	dc.w 5,	$85E6, $82F3, $58
	dc.w 1,	$85EE, $82F7, $68
	dc.w 5,	$8584, $82C2, $70
word_14AE2:	dc.w 8
	dc.w 5,	$85DE, $82EF, $FFF0
	dc.w 5,	$85E2, $82F1, 0
	dc.w 5,	$85E6, $82F3, $10
	dc.w 5,	$85EA, $82F5, $30
	dc.w 5,	$85EE, $82F7, $40
	dc.w 5,	$85F2, $82F9, $50
	dc.w 5,	$85DE, $82EF, $60
	dc.w 5,	$8580, $82C0, $70
word_14B24:	dc.w $C
	dc.w 9,	$85DE, $82EF, $FFB1
	dc.w 1,	$85E4, $82F2, $FFC8
	dc.w 5,	$8584, $82C2, $FFD0
	dc.w 5,	$85E6, $82F3, $FFE0
	dc.w 5,	$85EA, $82F5, 1
	dc.w 5,	$8588, $82C4, $10
	dc.w 5,	$85EE, $82F7, $20
	dc.w 5,	$85F2, $82F9, $30
	dc.w 5,	$85EE, $82F7, $40
	dc.w 5,	$8580, $82C0, $50
	dc.w 5,	$85F6, $82FB, $5F
	dc.w 5,	$85F6, $82FB, $6F
word_14B86:	dc.w 8
	dc.w 5,	$85DE, $82EF, $FFF2
	dc.w 5,	$8580, $82C0, 2
	dc.w 5,	$85E2, $82F1, $10
	dc.w 5,	$85E6, $82F3, $20
	dc.w 5,	$85EA, $82F5, $30
	dc.w 5,	$8580, $82C0, $51
	dc.w 5,	$85EE, $82F7, $60
	dc.w 5,	$85EE, $82F7, $70
word_14BC8:	dc.w 4
	dc.w 5,	$858C, $82C6, 1
	dc.w 5,	$8588, $82C4, $10
	dc.w 5,	$8584, $82C2, $20
	dc.w 5,	$8580, $82C0, $30
word_14BEA:	dc.w 1
	dc.w 7,	$A590, $A2C8, 0
word_14BF4:	dc.w 1
	dc.w $B, $A598,	$A2CC, 0
word_14BFE:	dc.w 1
	dc.w $B, $A5A4,	$A2D2, 0
word_14C08:	dc.w 5
	dc.w $D, $85B0,	$82D8, $FFB8
	dc.w $D, $85B8,	$82DC, $FFD8
	dc.w $D, $85C0,	$82E0, $FFF8
	dc.w $D, $85C8,	$82E4, $18
	dc.w 5,	$85D0, $82E8, $38
word_14C32:	dc.w 7
	dc.w $9003, $85D4, $82EA, 0
	dc.w $B003, $85D4, $82EA, 0
	dc.w $D003, $85D4, $82EA, 0
	dc.w $F003, $85D4, $82EA, 0
	dc.w $1003, $85D4, $82EA, 0
	dc.w $3003, $85D4, $82EA, 0
	dc.w $5003, $85D4, $82EA, 0
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj39_MapUnc_14C6C:	BINCLUDE "mappings/sprite/obj39.bin"
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj3A_MapUnc_14CBC:	offsetTable
	offsetTableEntry.w word_14CDA
	offsetTableEntry.w word_14D1C
	offsetTableEntry.w word_14D5E
	offsetTableEntry.w word_14DA0
	offsetTableEntry.w word_14DDA
	offsetTableEntry.w word_14BC8
	offsetTableEntry.w word_14BEA
	offsetTableEntry.w word_14BF4
	offsetTableEntry.w word_14BFE
	offsetTableEntry.w word_14DF4
	offsetTableEntry.w word_14E1E
	offsetTableEntry.w word_14E50
	offsetTableEntry.w word_14E82
	offsetTableEntry.w word_14E8C
	offsetTableEntry.w word_14E96
word_14CDA:	dc.w 8
	dc.w 5,	$85D0, $82E8, $FFC0
	dc.w 5,	$8588, $82C4, $FFD0
	dc.w 5,	$8584, $82C2, $FFE0
	dc.w 1,	$85C0, $82E0, $FFF0
	dc.w 5,	$85B4, $82DA, $FFF8
	dc.w 5,	$85B8, $82DC, $10
	dc.w 5,	$8588, $82C4, $20
	dc.w 5,	$85D4, $82EA, $2F
word_14D1C:	dc.w 8
	dc.w 9,	$85C6, $82E3, $FFBC
	dc.w 1,	$85C0, $82E0, $FFD4
	dc.w 5,	$85C2, $82E1, $FFDC
	dc.w 5,	$8580, $82C0, $FFEC
	dc.w 5,	$85D0, $82E8, $FFFC
	dc.w 5,	$85B8, $82DC, $14
	dc.w 5,	$8588, $82C4, $24
	dc.w 5,	$85D4, $82EA, $33
word_14D5E:	dc.w 8
	dc.w 5,	$85D4, $82EA, $FFC3
	dc.w 5,	$85B0, $82D8, $FFD0
	dc.w 1,	$85C0, $82E0, $FFE0
	dc.w 5,	$85C2, $82E1, $FFE8
	dc.w 5,	$85D0, $82E8, $FFF8
	dc.w 5,	$85B8, $82DC, $10
	dc.w 5,	$8588, $82C4, $20
	dc.w 5,	$85D4, $82EA, $2F
word_14DA0:	dc.w 7
	dc.w 5,	$85D4, $82EA, $FFC8
	dc.w 5,	$85BC, $82DE, $FFD8
	dc.w 5,	$85CC, $82E6, $FFE8
	dc.w 5,	$8588, $82C4, $FFF8
	dc.w 5,	$85D8, $82EC, 8
	dc.w 5,	$85B8, $82DC, $18
	dc.w 5,	$85BC, $82DE, $28
word_14DDA:	dc.w 3
	dc.w 5,	$85B0, $82D8, 0
	dc.w 5,	$85B4, $82DA, $10
	dc.w 5,	$85D4, $82EA, $1F
word_14DF4:	dc.w 5
	dc.w 9,	$A5E6, $A2F3, $FFB8
	dc.w 5,	$A5EC, $A2F6, $FFD0
	dc.w 5,	$85F0, $82F8, $FFD4
	dc.w $D, $8520,	$8290, $38
	dc.w 1,	$86F0, $8378, $58
word_14E1E:	dc.w 6
	dc.w $D, $A6DA,	$A36D, $FFA4
	dc.w $D, $A5DE,	$A2EF, $FFCC
	dc.w 1,	$A6CA, $A365, $FFEC
	dc.w 5,	$85F0, $82F8, $FFE8
	dc.w $D, $8528,	$8294, $38
	dc.w 1,	$86F0, $8378, $58
word_14E50:	dc.w 6
	dc.w $D, $A6D2,	$A369, $FFA4
	dc.w $D, $A5DE,	$A2EF, $FFCC
	dc.w 1,	$A6CA, $A365, $FFEC
	dc.w 5,	$85F0, $82F8, $FFE8
	dc.w $D, $8530,	$8298, $38
	dc.w 1,	$86F0, $8378, $58
word_14E82:	dc.w 1
	dc.w 6,	$85F4, $82FA, 0
word_14E8C:	dc.w 1
	dc.w 6,	$85FA, $82FD, 0
word_14E96:	dc.w 7
	dc.w $D, $A540,	$A2A0, $FF98
	dc.w 9,	$A548, $A2A4, $FFB8
	dc.w $D, $A5DE,	$A2EF, $FFD8
	dc.w 1,	$A6CA, $A365, $FFF8
	dc.w 5,	$85F0, $82F8, $FFF4
	dc.w $D, $8538,	$829C, $38
	dc.w 1,	$86F0, $8378, $58
; -------------------------------------------------------------------------------
; sprite mappings
; -------------------------------------------------------------------------------
Obj6F_MapUnc_14ED0:	BINCLUDE "mappings/sprite/obj6F.bin"
; ===========================================================================
