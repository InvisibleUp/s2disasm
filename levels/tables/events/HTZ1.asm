; loc_E986:
LevEvents_HTZ:
	tst.b	(Current_Act).w
	bne.w	LevEvents_HTZ2
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_HTZ_Index(pc,d0.w),d0
	jmp	LevEvents_HTZ_Index(pc,d0.w)
; ===========================================================================
; off_E99C:
LevEvents_HTZ_Index: offsetTable
	offsetTableEntry.w LevEvents_HTZ_Routine1	; 0 left of earthquake
	offsetTableEntry.w LevEvents_HTZ_Routine2	; 2 earthquake
	offsetTableEntry.w LevEvents_HTZ_Routine3	; 4 right of earthquake
; ===========================================================================
; loc_E9A2:
LevEvents_HTZ_Routine1:
	cmpi.w	#$400,(Camera_Y_pos).w
	blo.s	LevEvents_HTZ_Routine1_Part2
	cmpi.w	#$1800,(Camera_X_pos).w
	blo.s	LevEvents_HTZ_Routine1_Part2
	move.b	#1,(Screen_Shaking_Flag_HTZ).w
	move.l	(Camera_X_pos).w,(Camera_BG_X_pos).w
	move.l	(Camera_Y_pos).w,(Camera_BG_Y_pos).w
	moveq	#0,d0
	move.w	d0,(Camera_BG_X_pos_diff).w
	move.w	d0,(Camera_BG_Y_pos_diff).w
	move.w	d0,(Camera_BG_X_offset).w
	move.w	#320,(Camera_BG_Y_offset).w
	subi.w	#$100,(Camera_BG_Y_pos).w
	move.w	#0,(HTZ_Terrain_Delay).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ_Routine2
-
	rts
; ===========================================================================

LevEvents_HTZ_Routine1_Part2:
	tst.b	(Screen_Shaking_Flag_HTZ).w
	beq.s	-	; rts
	move.w	#$200,d0
	moveq	#0,d1
	move.w	d1,(Camera_BG_X_pos_diff).w
	move.w	d1,(Camera_BG_Y_pos_diff).w
	bsr.w	ScrollBG
	or.w	d0,d1
	bne.s	-	; rts
	move.b	#0,(Screen_Shaking_Flag_HTZ).w
	rts
; ===========================================================================
; loc_EA0E:
LevEvents_HTZ_Routine2:
	cmpi.w	#$1978,(Camera_X_pos).w
	blo.w	LevEvents_HTZ_Routine2_Continue
	cmpi.w	#$1E00,(Camera_X_pos).w
	blo.s	.keep_shaking
	move.b	#0,(Screen_Shaking_Flag).w
	bra.s	LevEvents_HTZ_Routine2_Continue
; ---------------------------------------------------------------------------
.keep_shaking:
	tst.b	(HTZ_Terrain_Direction).w
	bne.s	.sinking
	cmpi.w	#320,(Camera_BG_Y_offset).w
	beq.s	.flip_delay
	move.w	(Timer_frames).w,d0
	move.w	d0,d1
	andi.w	#3,d0
	bne.s	LevEvents_HTZ_Routine2_Continue
	addq.w	#1,(Camera_BG_Y_offset).w
	andi.w	#$3F,d1
	bne.s	LevEvents_HTZ_Routine2_Continue
	move.w	#SndID_Rumbling2,d0 ; rumbling sound
	jsr	(PlaySound).l
	bra.s	LevEvents_HTZ_Routine2_Continue
; ---------------------------------------------------------------------------
.sinking:
	cmpi.w	#224,(Camera_BG_Y_offset).w
	beq.s	.flip_delay
	move.w	(Timer_frames).w,d0
	move.w	d0,d1
	andi.w	#3,d0
	bne.s	LevEvents_HTZ_Routine2_Continue
	subq.w	#1,(Camera_BG_Y_offset).w
	andi.w	#$3F,d1
	bne.s	LevEvents_HTZ_Routine2_Continue
	move.w	#SndID_Rumbling2,d0
	jsr	(PlaySound).l
	bra.s	LevEvents_HTZ_Routine2_Continue
; ---------------------------------------------------------------------------
.flip_delay:
	move.b	#0,(Screen_Shaking_Flag).w
	subq.w	#1,(HTZ_Terrain_Delay).w
	bpl.s	LevEvents_HTZ_Routine2_Continue
	move.w	#$78,(HTZ_Terrain_Delay).w
	eori.b	#1,(HTZ_Terrain_Direction).w
	move.b	#1,(Screen_Shaking_Flag).w

; loc_EAA0:
LevEvents_HTZ_Routine2_Continue:
	cmpi.w	#$1800,(Camera_X_pos).w
	blo.s	.exit_left
	cmpi.w	#$1F00,(Camera_X_pos).w
	bhs.s	.exit_right
	move.w	(Camera_X_pos_diff).w,(Camera_BG_X_pos_diff).w
	move.w	(Camera_Y_pos_diff).w,(Camera_BG_Y_pos_diff).w
	move.w	(Camera_X_pos).w,d0
	move.w	(Camera_Y_pos).w,d1
	bra.w	ScrollBG
; ---------------------------------------------------------------------------
.exit_left:
	move.l	#$4000000,(Camera_BG_X_pos).w
	moveq	#0,d0
	move.l	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Camera_BG_X_offset).w
	move.b	d0,(HTZ_Terrain_Direction).w
	subq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ_Routine1
	move.w	#MusID_StopSFX,d0
	jsr	(PlaySound).l
	rts
; ---------------------------------------------------------------------------
.exit_right:
	move.l	#$4000000,(Camera_BG_X_pos).w
	moveq	#0,d0
	move.l	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Camera_BG_X_offset).w
	move.b	d0,(HTZ_Terrain_Direction).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ_Routine3
	move.w	#MusID_StopSFX,d0
	jsr	(PlaySound).l
	rts

; ===========================================================================
; loc_EB14:
LevEvents_HTZ_Routine3:
	cmpi.w	#$1F00,(Camera_X_pos).w
	bhs.s	LevEvents_HTZ_Routine3_Part2
	move.b	#1,(Screen_Shaking_Flag_HTZ).w
	move.l	(Camera_X_pos).w,(Camera_BG_X_pos).w
	move.l	(Camera_Y_pos).w,(Camera_BG_Y_pos).w
	moveq	#0,d0
	move.w	d0,(Camera_BG_X_pos_diff).w
	move.w	d0,(Camera_BG_Y_pos_diff).w
	move.w	d0,(Camera_BG_X_offset).w
	move.w	#320,(Camera_BG_Y_offset).w
	subi.w	#$100,(Camera_BG_Y_pos).w
	move.w	#0,(HTZ_Terrain_Delay).w
	subq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ_Routine2
-
	rts
; ---------------------------------------------------------------------------
; loc_EB54:
LevEvents_HTZ_Routine3_Part2:
	tst.b	(Screen_Shaking_Flag_HTZ).w
	beq.s	-	; rts
	move.w	#$200,d0
	moveq	#0,d1
	move.w	d1,(Camera_BG_X_pos_diff).w
	move.w	d1,(Camera_BG_Y_pos_diff).w
	bsr.w	ScrollBG
	or.w	d0,d1
	bne.s	-	; rts
	move.b	#0,(Screen_Shaking_Flag_HTZ).w
	rts
