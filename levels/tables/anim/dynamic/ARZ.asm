Dynamic_ARZ:
	tst.b	(Current_Boss_ID).w
	beq.s	Dynamic_Normal
	rts
; ===========================================================================