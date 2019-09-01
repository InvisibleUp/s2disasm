; ---------------------------------------------------------------------------
; Subroutine to update the HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_40D8A:
HudUpdate:
	nop
	lea	(VDP_data_port).l,a6
	tst.w	(Two_player_mode).w
	bne.w	loc_40F50
	tst.w	(Debug_mode_flag).w	; is debug mode on?
	bne.w	loc_40E9A	; if yes, branch
	tst.b	(Update_HUD_score).w	; does the score need updating?
	beq.s	Hud_ChkRings	; if not, branch
	clr.b	(Update_HUD_score).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Score),VRAM,WRITE),d0	; set VRAM address
	move.l	(Score).w,d1	; load score
	bsr.w	Hud_Score
; loc_40DBA:
Hud_ChkRings:
	tst.b	(Update_HUD_rings).w	; does the ring counter need updating?
	beq.s	Hud_ChkTime	; if not, branch
	bpl.s	loc_40DC6
	bsr.w	Hud_InitRings

loc_40DC6:
	clr.b	(Update_HUD_rings).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Rings),VRAM,WRITE),d0
	moveq	#0,d1
	move.w	(Ring_count).w,d1
	bsr.w	Hud_Rings
; loc_40DDA:
Hud_ChkTime:
	tst.b	(Update_HUD_timer).w	; does the time need updating?
	beq.s	Hud_ChkLives	; if not, branch
	tst.w	(Game_paused).w	; is the game paused?
	bne.s	Hud_ChkLives	; if yes, branch
	lea	(Timer).w,a1
	cmpi.l	#$93B3B,(a1)+	; is the time 9.59?
	beq.w	loc_40E84	; if yes, branch
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	blo.s	Hud_ChkLives
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	blo.s	+
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	blo.s	+
	move.b	#9,(a1)
+
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Minutes),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Timer_minute).w,d1
	bsr.w	Hud_Mins
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Seconds),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Timer_second).w,d1
	bsr.w	Hud_Secs
; loc_40E38:
Hud_ChkLives:
	tst.b	(Update_HUD_lives).w	; does the lives counter need updating?
	beq.s	Hud_ChkBonus	; if not, branch
	clr.b	(Update_HUD_lives).w
	bsr.w	Hud_Lives
; loc_40E46:
Hud_ChkBonus:
	tst.b	(Update_Bonus_score).w	; do time/ring bonus counters need updating?
	beq.s	Hud_End	; if not, branch
	clr.b	(Update_Bonus_score).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Bonus_Score),VRAM,WRITE),(VDP_control_port).l
	moveq	#0,d1
	move.w	(Total_Bonus_Countdown).w,d1
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_1).w,d1	 ; load time bonus
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_2).w,d1	 ; load ring bonus
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_3).w,d1	 ; load perfect bonus
	bsr.w	Hud_TimeRingBonus
; return_40E82:
Hud_End:
	rts
; ===========================================================================

loc_40E84:
	clr.b	(Update_HUD_timer).w
	lea	(MainCharacter).w,a0 ; a0=character
	movea.l	a0,a2
	bsr.w	KillCharacter
	move.b	#1,(Time_Over_flag).w
	rts
; ===========================================================================

loc_40E9A:
	bsr.w	HudDb_XY
	tst.b	(Update_HUD_rings).w
	beq.s	loc_40EBE
	bpl.s	loc_40EAA
	bsr.w	Hud_InitRings

loc_40EAA:
	clr.b	(Update_HUD_rings).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Rings),VRAM,WRITE),d0

	moveq	#0,d1
	move.w	(Ring_count).w,d1
	bsr.w	Hud_Rings

loc_40EBE:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Seconds),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Sprite_count).w,d1
	bsr.w	Hud_Secs
	tst.b	(Update_HUD_lives).w
	beq.s	loc_40EDC
	clr.b	(Update_HUD_lives).w
	bsr.w	Hud_Lives

loc_40EDC:
	tst.b	(Update_Bonus_score).w
	beq.s	loc_40F18
	clr.b	(Update_Bonus_score).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Bonus_Score),VRAM,WRITE),(VDP_control_port).l
	moveq	#0,d1
	move.w	(Total_Bonus_Countdown).w,d1
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_1).w,d1
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_2).w,d1
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_3).w,d1
	bsr.w	Hud_TimeRingBonus

loc_40F18:
	tst.w	(Game_paused).w
	bne.s	return_40F4E
	lea	(Timer).w,a1
	cmpi.l	#$93B3B,(a1)+
	nop			; You can't get a Time Over in Debug Mode, so this branch is dummied-out
	addq.b	#1,-(a1)
	cmpi.b	#$3C,(a1)
	blo.s	return_40F4E
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#$3C,(a1)
	blo.s	return_40F4E
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	blo.s	return_40F4E
	move.b	#9,(a1)

return_40F4E:
	rts
; ===========================================================================

loc_40F50:
	tst.w	(Game_paused).w
	bne.w	return_4101A
	tst.b	(Update_HUD_timer).w
	beq.s	loc_40F90
	lea	(Timer).w,a1
	cmpi.l	#$93B3B,(a1)+
	beq.w	TimeOver
	addq.b	#1,-(a1)
	cmpi.b	#$3C,(a1)
	blo.s	loc_40F90
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#$3C,(a1)
	blo.s	loc_40F90
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	blo.s	loc_40F90
	move.b	#9,(a1)

loc_40F90:
	tst.b	(Update_HUD_timer_2P).w
	beq.s	loc_40FC8
	lea	(Timer_2P).w,a1
	cmpi.l	#$93B3B,(a1)+
	beq.w	TimeOver2
	addq.b	#1,-(a1)
	cmpi.b	#$3C,(a1)
	blo.s	loc_40FC8
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#$3C,(a1)
	blo.s	loc_40FC8
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	blo.s	loc_40FC8
	move.b	#9,(a1)

loc_40FC8:
	tst.b	(Update_HUD_lives).w
	beq.s	loc_40FD6
	clr.b	(Update_HUD_lives).w
	bsr.w	Hud_Lives

loc_40FD6:
	tst.b	(Update_HUD_lives_2P).w
	beq.s	loc_40FE4
	clr.b	(Update_HUD_lives_2P).w
	bsr.w	Hud_Lives2

loc_40FE4:
	move.b	(Update_HUD_timer).w,d0
	or.b	(Update_HUD_timer_2P).w,d0
	beq.s	return_4101A
	lea	(Loser_Time_Left).w,a1
	tst.w	(a1)+
	beq.s	return_4101A
	subq.b	#1,-(a1)
	bhi.s	return_4101A
	move.b	#$3C,(a1)
	cmpi.b	#$C,-1(a1)
	bne.s	loc_41010
	move.w	#MusID_Countdown,d0
	jsr	(PlayMusic).l

loc_41010:
	subq.b	#1,-(a1)
	bcc.s	return_4101A
	move.w	#0,(a1)
	bsr.s	TimeOver0

return_4101A:

	rts
; End of function HudUpdate
