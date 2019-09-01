Dynamic_CNZ:
	tst.b	(Current_Boss_ID).w
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	lea	(Animated_CNZ).l,a2
	tst.w	(Two_player_mode).w
	beq.s	Dynamic_Normal
	lea	(Animated_CNZ_2P).l,a2
	bra.s	Dynamic_Normal
; ===========================================================================
