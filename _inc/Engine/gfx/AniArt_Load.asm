; ===========================================================================
;loc_3FCC4:
AniArt_Load:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	PLC_DYNANM+2(pc,d0.w),d1
	lea	PLC_DYNANM(pc,d1.w),a2
	move.w	PLC_DYNANM(pc,d0.w),d0
	jmp	PLC_DYNANM(pc,d0.w)
; ===========================================================================
	rts
; ===========================================================================