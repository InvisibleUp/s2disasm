; sub_19DC:
; S1: PalleteCycle:
PalCycle_Load:
	bsr.w	PalCycle_SuperSonic
	moveq	#0,d2
	moveq	#0,d0
	move.b	(Current_Zone).w,d0	; use level number as index into palette cycles
	add.w	d0,d0			; (multiply by element size = 2 bytes)
	move.w	PalCycle(pc,d0.w),d0	; load animated palettes offset index into d0
	jmp	PalCycle(pc,d0.w)	; jump to PalCycle + offset index
; ---------------------------------------------------------------------------
	rts
; End of function PalCycle_Load