; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4101C:
TimeOver0:
	tst.b	(Update_HUD_timer).w
	bne.s	TimeOver
	tst.b	(Update_HUD_timer_2P).w
	bne.s	TimeOver2
	rts
; ===========================================================================
; loc_4102A:
TimeOver:
	clr.b	(Update_HUD_timer).w
	lea	(MainCharacter).w,a0 ; a0=character
	movea.l	a0,a2
	bsr.w	KillCharacter
	move.b	#1,(Time_Over_flag).w
	tst.b	(Update_HUD_timer_2P).w
	beq.s	+	; rts
; loc_41044:
TimeOver2:
	clr.b	(Update_HUD_timer_2P).w
	lea	(Sidekick).w,a0 ; a0=character
	movea.l	a0,a2
	bsr.w	KillCharacter
	move.b	#1,(Time_Over_flag_2P).w
+
	rts
; End of function TimeOver0
