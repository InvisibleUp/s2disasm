; ---------------------------------------------------------------------------
; Add points subroutine
; subroutine to add to Player 1's score
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_40D06:
AddPoints:
	move.b	#1,(Update_HUD_score).w
	lea	(Score).w,a3
	add.l	d0,(a3)	; add d0*10 to the score
	move.l	#999999,d1
	cmp.l	(a3),d1	; is #999999 higher than the score?
	bhi.s	+	; if yes, branch
	move.l	d1,(a3)	; set score to #999999
+
	move.l	(a3),d0
	cmp.l	(Next_Extra_life_score).w,d0
	blo.s	+	; rts
	addi.l	#5000,(Next_Extra_life_score).w
	addq.b	#1,(Life_count).w
	addq.b	#1,(Update_HUD_lives).w
	move.w	#MusID_ExtraLife,d0
	jmp	(PlayMusic).l
; ===========================================================================
+	rts
; End of function AddPoints


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; ---------------------------------------------------------------------------
; Add points subroutine
; subroutine to add to Player 2's score
; (goes to AddPoints to add to Player 1's score instead if this is not Player 2)
; ---------------------------------------------------------------------------

; sub_40D42:
AddPoints2:
	tst.w	(Two_player_mode).w
	beq.s	AddPoints
	cmpa.w	#MainCharacter,a3
	beq.s	AddPoints
	move.b	#1,(Update_HUD_score_2P).w
	lea	(Score_2P).w,a3
	add.l	d0,(a3)	; add d0*10 to the score
	move.l	#999999,d1
	cmp.l	(a3),d1	; is #999999 higher than the score?
	bhi.s	+	; if yes, branch
	move.l	d1,(a3)	; set score to #999999
+
	move.l	(a3),d0
	cmp.l	(Next_Extra_life_score_2P).w,d0
	blo.s	+	; rts
	addi.l	#5000,(Next_Extra_life_score_2P).w
	addq.b	#1,(Life_count_2P).w
	addq.b	#1,(Update_HUD_lives_2P).w
	move.w	#MusID_ExtraLife,d0
	jmp	(PlayMusic).l
; ===========================================================================
+	rts
; End of function AddPoints2
