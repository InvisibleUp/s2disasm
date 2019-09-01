	; sub_EBEA:
LevEvents_HTZ2:
	bsr.w	LevEvents_HTZ2_Prepare
	moveq	#0,d0
	move.b	(Dynamic_Resize_Routine).w,d0
	move.w	LevEvents_HTZ2_Index(pc,d0.w),d0
	jmp	LevEvents_HTZ2_Index(pc,d0.w)
; ===========================================================================
; off_EBFC:
LevEvents_HTZ2_Index: offsetTable
	offsetTableEntry.w LevEvents_HTZ2_Routine1	;   0 earthquake left
	offsetTableEntry.w LevEvents_HTZ2_Routine2	;   2 earthquake (top)
	offsetTableEntry.w LevEvents_HTZ2_Routine3	;   4 earthquake right (top)
	offsetTableEntry.w LevEvents_HTZ2_Routine4	;   6 earthquake (bottom)
	offsetTableEntry.w LevEvents_HTZ2_Routine5	;   8 earthquake right (bottom)
	offsetTableEntry.w LevEvents_HTZ2_Routine6	;  $A boss area cutoff
	offsetTableEntry.w LevEvents_HTZ2_Routine7	;  $C boss area camera shift
	offsetTableEntry.w LevEvents_HTZ2_Routine8	;  $E boss begin
	offsetTableEntry.w LevEvents_HTZ2_Routine9	; $10 boss end / extend camera
; ===========================================================================
; loc_EC0E:
LevEvents_HTZ2_Routine1:
	cmpi.w	#$14C0,(Camera_X_pos).w
	blo.s	LevEvents_HTZ2_Routine1_Part2
	move.b	#1,(Screen_Shaking_Flag_HTZ).w
	move.l	(Camera_X_pos).w,(Camera_BG_X_pos).w
	move.l	(Camera_Y_pos).w,(Camera_BG_Y_pos).w
	moveq	#0,d0
	move.w	d0,(Camera_BG_X_pos_diff).w
	move.w	d0,(Camera_BG_Y_pos_diff).w
	move.w	d0,(Camera_BG_X_offset).w
	move.w	#$2C0,(Camera_BG_Y_offset).w
	subi.w	#$100,(Camera_BG_Y_pos).w
	move.w	#0,(HTZ_Terrain_Delay).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine2
	cmpi.w	#$380,(Camera_Y_pos).w
	blo.s	+	; rts
	move.w	#-$680,(Camera_BG_X_offset).w
	addi.w	#$480,(Camera_BG_X_pos).w
	move.w	#$300,(Camera_BG_Y_offset).w
	addq.b	#6,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine5
/
	rts
; ---------------------------------------------------------------------------

LevEvents_HTZ2_Routine1_Part2:
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
; loc_EC90:
LevEvents_HTZ2_Routine2:
	cmpi.w	#$1678,(Camera_X_pos).w
	blo.w	LevEvents_HTZ2_Routine2_Continue
	cmpi.w	#$1A00,(Camera_X_pos).w
	blo.s	.keep_shaking
	move.b	#0,(Screen_Shaking_Flag).w
	bra.s	LevEvents_HTZ2_Routine2_Continue
; ---------------------------------------------------------------------------
.keep_shaking:
	tst.b	(HTZ_Terrain_Direction).w
	bne.s	.sinking
	cmpi.w	#$2C0,(Camera_BG_Y_offset).w
	beq.s	.flip_delay
	move.w	(Timer_frames).w,d0
	move.w	d0,d1
	andi.w	#3,d0
	bne.s	LevEvents_HTZ2_Routine2_Continue
	addq.w	#1,(Camera_BG_Y_offset).w
	andi.w	#$3F,d1
	bne.s	LevEvents_HTZ2_Routine2_Continue
	move.w	#SndID_Rumbling2,d0
	jsr	(PlaySound).l
	bra.s	LevEvents_HTZ2_Routine2_Continue
; ---------------------------------------------------------------------------
.sinking:
	cmpi.w	#0,(Camera_BG_Y_offset).w
	beq.s	.flip_delay
	move.w	(Timer_frames).w,d0
	move.w	d0,d1
	andi.w	#3,d0
	bne.s	LevEvents_HTZ2_Routine2_Continue
	subq.w	#1,(Camera_BG_Y_offset).w
	andi.w	#$3F,d1
	bne.s	LevEvents_HTZ2_Routine2_Continue
	move.w	#SndID_Rumbling2,d0
	jsr	(PlaySound).l
	bra.s	LevEvents_HTZ2_Routine2_Continue
; ---------------------------------------------------------------------------
.flip_delay:
	move.b	#0,(Screen_Shaking_Flag).w
	subq.w	#1,(HTZ_Terrain_Delay).w
	bpl.s	LevEvents_HTZ2_Routine2_Continue
	move.w	#$78,(HTZ_Terrain_Delay).w
	eori.b	#1,(HTZ_Terrain_Direction).w
	move.b	#1,(Screen_Shaking_Flag).w

; loc_ED22:
LevEvents_HTZ2_Routine2_Continue:
	cmpi.w	#$14C0,(Camera_X_pos).w
	blo.s	.exit_left
	cmpi.w	#$1B00,(Camera_X_pos).w
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
	subq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine1
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
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine3
	move.w	#MusID_StopSFX,d0
	jsr	(PlaySound).l
	rts
; ===========================================================================
; loc_ED96:
LevEvents_HTZ2_Routine3:
	cmpi.w	#$1B00,(Camera_X_pos).w
	bhs.s	LevEvents_HTZ2_Routine3_Part2
	move.b	#1,(Screen_Shaking_Flag_HTZ).w
	move.l	(Camera_X_pos).w,(Camera_BG_X_pos).w
	move.l	(Camera_Y_pos).w,(Camera_BG_Y_pos).w
	moveq	#0,d0
	move.w	d0,(Camera_BG_X_pos_diff).w
	move.w	d0,(Camera_BG_Y_pos_diff).w
	move.w	d0,(Camera_BG_X_offset).w
	move.w	#$2C0,(Camera_BG_Y_offset).w
	subi.w	#$100,(Camera_BG_Y_pos).w
	move.w	#0,(HTZ_Terrain_Delay).w
	subq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine2
-
	rts
; ===========================================================================

LevEvents_HTZ2_Routine3_Part2:
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
; loc_EDFA:
LevEvents_HTZ2_Routine4:
	cmpi.w	#$15F0,(Camera_X_pos).w
	blo.w	LevEvents_HTZ2_Routine4_Continue
	cmpi.w	#$1AC0,(Camera_X_pos).w
	bhs.s	LevEvents_HTZ2_Routine4_Continue
	tst.b	(HTZ_Terrain_Direction).w
	bne.s	.sinking
	cmpi.w	#$300,(Camera_BG_Y_offset).w
	beq.s	.flip_delay
	move.w	(Timer_frames).w,d0
	move.w	d0,d1
	andi.w	#3,d0
	bne.s	LevEvents_HTZ2_Routine4_Continue
	addq.w	#1,(Camera_BG_Y_offset).w
	andi.w	#$3F,d1
	bne.s	LevEvents_HTZ2_Routine4_Continue
	move.w	#SndID_Rumbling2,d0
	jsr	(PlaySound).l
	bra.s	LevEvents_HTZ2_Routine4_Continue
; ===========================================================================
.sinking:
	cmpi.w	#0,(Camera_BG_Y_offset).w
	beq.s	.flip_delay
	move.w	(Timer_frames).w,d0
	move.w	d0,d1
	andi.w	#3,d0
	bne.s	LevEvents_HTZ2_Routine4_Continue
	subq.w	#1,(Camera_BG_Y_offset).w
	andi.w	#$3F,d1
	bne.s	LevEvents_HTZ2_Routine4_Continue
	move.w	#SndID_Rumbling2,d0
	jsr	(PlaySound).l
	bra.s	LevEvents_HTZ2_Routine4_Continue
; ===========================================================================
.flip_delay:
	move.b	#0,(Screen_Shaking_Flag).w
	subq.w	#1,(HTZ_Terrain_Delay).w
	bpl.s	LevEvents_HTZ2_Routine4_Continue
	move.w	#$78,(HTZ_Terrain_Delay).w
	eori.b	#1,(HTZ_Terrain_Direction).w
	move.b	#1,(Screen_Shaking_Flag).w

LevEvents_HTZ2_Routine4_Continue:
	cmpi.w	#$14C0,(Camera_X_pos).w
	blo.s	.exit_left
	cmpi.w	#$1B00,(Camera_X_pos).w
	bhs.s	.exit_right
	move.w	(Camera_X_pos_diff).w,(Camera_BG_X_pos_diff).w
	move.w	(Camera_Y_pos_diff).w,(Camera_BG_Y_pos_diff).w
	move.w	(Camera_X_pos).w,d0
	move.w	(Camera_Y_pos).w,d1
	bra.w	ScrollBG
; ===========================================================================
.exit_left:
	move.l	#$4000000,(Camera_BG_X_pos).w
	moveq	#0,d0
	move.l	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Camera_BG_X_offset).w
	move.b	d0,(HTZ_Terrain_Direction).w
	subq.b	#6,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine1
	move.w	#MusID_StopSFX,d0
	jsr	(PlaySound).l
	rts
; ===========================================================================
.exit_right:
	move.l	#$4000000,(Camera_BG_X_pos).w
	moveq	#0,d0
	move.l	d0,(Camera_BG_Y_pos).w
	move.l	d0,(Camera_BG_X_offset).w
	move.b	d0,(HTZ_Terrain_Direction).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine5
	move.w	#MusID_StopSFX,d0
	jsr	(PlaySound).l
	rts
; ===========================================================================
; loc_EEF8:
LevEvents_HTZ2_Routine5:
	cmpi.w	#$1B00,(Camera_X_pos).w
	bhs.s	LevEvents_HTZ2_Routine5_Part2
	move.b	#1,(Screen_Shaking_Flag_HTZ).w
	move.l	(Camera_X_pos).w,(Camera_BG_X_pos).w
	move.l	(Camera_Y_pos).w,(Camera_BG_Y_pos).w
	moveq	#0,d0
	move.w	d0,(Camera_BG_X_pos_diff).w
	move.w	d0,(Camera_BG_Y_pos_diff).w
	move.w	#-$680,(Camera_BG_X_offset).w
	addi.w	#$480,(Camera_BG_X_pos).w
	move.w	#$300,(Camera_BG_Y_offset).w
	subi.w	#$100,(Camera_BG_Y_pos).w
	move.w	#0,(HTZ_Terrain_Delay).w
	subq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine4
-
	rts
; ===========================================================================

LevEvents_HTZ2_Routine5_Part2:
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
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_EF66:
LevEvents_HTZ2_Prepare:
	cmpi.w	#$2B00,(Camera_X_pos).w
	blo.s	+	; rts
	cmpi.b	#$A,(Dynamic_Resize_Routine).w
	bge.s	+	; rts
	move.b	#$A,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine6
	move.b	#0,(Screen_Shaking_Flag_HTZ).w
+
	rts
; End of function LevEvents_HTZ2_Prepare

; ===========================================================================
; loc_EF84:
LevEvents_HTZ2_Routine6:
	cmpi.w	#$2C50,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	move.w	#$480,(Camera_Max_Y_pos).w
	move.w	#$480,(Tails_Max_Y_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine7
+
	rts
; ===========================================================================
; loc_EFAA:
LevEvents_HTZ2_Routine7:
	cmpi.w	#$2EDF,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	#$2EE0,(Camera_Min_X_pos).w
	move.w	#$2F5E,(Camera_Max_X_pos).w
	move.w	#$2EE0,(Tails_Min_X_pos).w
	move.w	#$2F5E,(Tails_Max_X_pos).w
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine8
	move.w	#MusID_FadeOut,d0
	jsrto	(PlayMusic).l, JmpTo3_PlayMusic
	clr.b	(ScreenShift).w
	move.b	#3,(Current_Boss_ID).w
	moveq	#PLCID_HtzBoss,d0
	jmpto	(LoadPLC).l, JmpTo2_LoadPLC
; ===========================================================================
+
	rts
; ===========================================================================
; loc_EFE8:
LevEvents_HTZ2_Routine8:
	cmpi.w	#$478,(Camera_Y_pos).w
	blo.s	+
	move.w	#$478,(Camera_Min_Y_pos).w
	move.w	#$478,(Tails_Min_Y_pos).w
+
	addq.b	#1,(ScreenShift).w
	cmpi.b	#$5A,(ScreenShift).w
	blo.s	++	; rts
	jsrto	(SingleObjLoad).l, JmpTo_SingleObjLoad
	bne.s	+
	move.b	#ObjID_HTZBoss,id(a1) ; load obj52 (HTZ boss)
+
	addq.b	#2,(Dynamic_Resize_Routine).w ; => LevEvents_HTZ2_Routine9
	move.w	#MusID_Boss,d0
	jsrto	(PlayMusic).l, JmpTo3_PlayMusic
+
	rts
; ===========================================================================
; loc_F020:
LevEvents_HTZ2_Routine9:
	tst.b	(Boss_defeated_flag).w
	beq.s	++	; rts
	move.w	(Camera_X_pos).w,(Camera_Min_X_pos).w
	move.w	(Camera_Max_X_pos).w,(Tails_Max_X_pos).w
	move.w	(Camera_X_pos).w,(Tails_Min_X_pos).w
	cmpi.w	#$30E0,(Camera_X_pos).w
	blo.s	++	; rts
	cmpi.w	#$428,(Camera_Min_Y_pos).w
	blo.s	+
	subq.w	#2,(Camera_Min_Y_pos).w
+
	cmpi.w	#$430,(Camera_Max_Y_pos).w
	blo.s	+
	subq.w	#2,(Camera_Max_Y_pos).w
+
	rts
