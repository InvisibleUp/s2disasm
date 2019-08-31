; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; ===========================================================================
; unused mostly-leftover subroutine to load the sound driver
; SoundDriverLoadS1:
	move.w	#$100,(Z80_Bus_Request).l ; stop the Z80
	move.w	#$100,(Z80_Reset).l ; reset the Z80
	lea	(Z80_RAM).l,a1
	move.b	#$F3,(a1)+	; di
	move.b	#$F3,(a1)+	; di
	move.b	#$C3,(a1)+	; jp
	move.b	#0,(a1)+	; jp address low byte
	move.b	#0,(a1)+	; jp address high byte
	move.w	#0,(Z80_Reset).l
	nop
	nop
	nop
	nop
	move.w	#$100,(Z80_Reset).l ; reset the Z80
	move.w	#0,(Z80_Bus_Request).l ; start the Z80
	rts