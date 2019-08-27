; screen resizing, earthquakage, etc

; sub_E5D0:
RunDynamicLevelEvents:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	move.w	DynamicLevelEventIndex(pc,d0.w),d0
	jsr	DynamicLevelEventIndex(pc,d0.w)
	moveq	#2,d1
	move.w	(Camera_Max_Y_pos).w,d0
	sub.w	(Camera_Max_Y_pos_now).w,d0
	beq.s	++	; rts
	bcc.s	+++
	neg.w	d1
	move.w	(Camera_Y_pos).w,d0
	cmp.w	(Camera_Max_Y_pos).w,d0
	bls.s	+
	move.w	d0,(Camera_Max_Y_pos_now).w
	andi.w	#$FFFE,(Camera_Max_Y_pos_now).w
+
	add.w	d1,(Camera_Max_Y_pos_now).w
	move.b	#1,(Camera_Max_Y_Pos_Changing).w
+
	rts
; ===========================================================================
+
	move.w	(Camera_Y_pos).w,d0
	addi_.w	#8,d0
	cmp.w	(Camera_Max_Y_pos_now).w,d0
	blo.s	+
	btst	#1,(MainCharacter+status).w
	beq.s	+
	add.w	d1,d1
	add.w	d1,d1
+
	add.w	d1,(Camera_Max_Y_pos_now).w
	move.b	#1,(Camera_Max_Y_Pos_Changing).w
	rts
; End of function RunDynamicLevelEvents