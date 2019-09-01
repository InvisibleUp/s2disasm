; ---------------------------------------------------------------------------
; Subroutine to animate a sprite using an animation script
; Works like AnimateSprite, except for:
; * this function does not change render flags to match orientation given by
;   the status byte;
; * the function returns 0 on d0 if it changed the mapping frame, or 1 if an
;   end-of-animation flag was found ($FC to $FF);
; * it is only used by Mecha Sonic;
; * some of the end-of-animation flags work differently.
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_36870:
AnimateSprite_Checked:
	moveq	#0,d0
	move.b	anim(a0),d0		; move animation number to d0
	cmp.b	next_anim(a0),d0	; is animation set to change?
	beq.s	AnimChk_Run		; if not, branch
	move.b	d0,next_anim(a0)	; set next anim to current current
	move.b	#0,anim_frame(a0)	; reset animation
	move.b	#0,anim_frame_duration(a0)	; reset frame duration

AnimChk_Run:
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
	bpl.s	AnimChk_Wait	; if time remains, branch
	add.w	d0,d0
	adda.w	(a1,d0.w),a1	; calculate address of appropriate animation script
	move.b	(a1),anim_frame_duration(a0)	; load frame duration
	moveq	#0,d1
	move.b	anim_frame(a0),d1	; load current frame number
	move.b	1(a1,d1.w),d0		; read sprite number from script
	bmi.s	AnimChk_End_FF		; if animation is complete, branch
;loc_368A8
AnimChk_Next:
	move.b	d0,mapping_frame(a0)	; load sprite number
	addq.b	#1,anim_frame(a0)	; next frame number
;loc_368B0
AnimChk_Wait:
	moveq	#0,d0	; Return 0
	rts
; ---------------------------------------------------------------------------
;loc_368B4
AnimChk_End_FF:
	addq.b	#1,d0		; is the end flag = $FF ?
	bne.s	AnimChk_End_FE	; if not, branch
	move.b	#0,anim_frame(a0)	; restart the animation
	move.b	1(a1),d0	; read sprite number
	bsr.s	AnimChk_Next
	moveq	#1,d0	; Return 1
	rts
; ---------------------------------------------------------------------------
;loc_368C8
AnimChk_End_FE:
	addq.b	#1,d0		; is the end flag = $FE ?
	bne.s	AnimChk_End_FD	; if not, branch
	addq.b	#2,routine(a0)	; jump to next routine
	move.b	#0,anim_frame_duration(a0)
	addq.b	#1,anim_frame(a0)
	moveq	#1,d0	; Return 1
	rts
; ---------------------------------------------------------------------------
;loc_368DE
AnimChk_End_FD:
	addq.b	#1,d0		; is the end flag = $FD ?
	bne.s	AnimChk_End_FC	; if not, branch
	addq.b	#2,routine_secondary(a0)	; jump to next routine
	moveq	#1,d0	; Return 1
	rts
; ---------------------------------------------------------------------------
;loc_368EA
AnimChk_End_FC:
	addq.b	#1,d0		; is the end flag = $FC ?
	bne.s	AnimChk_End	; if not, branch
	move.b	#1,anim_frame_duration(a0)	; Force frame duration to 1
	moveq	#1,d0	; Return 1

AnimChk_End:
	rts
; ===========================================================================