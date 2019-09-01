; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; Computes how much the background layer has been scrolled in X and Y and
; stores result to Camera_BG_X_pos_diff and Camera_BG_Y_pos_diff.
; Caps maximum scroll speed to 16 pixels per frame in either direction.
; This is used to decide how much of the BG needs to be reloaded.
;
; Used for rising lava/terrain in HTZ, and for WFZ->DEZ transition in WFZ.
;
; Input:
;	d0	Target X position of background
;	d1	Target Y position of background
;sub_EB78
ScrollBG:
	sub.w	(Camera_BG_X_pos).w,d0
	sub.w	(Camera_BG_X_offset).w,d0
	bpl.s	.going_right
	cmpi.w	#-16,d0
	bgt.s	.skip_x_cap
	move.w	#-16,d0

.skip_x_cap:
	bra.s	.move_x
; ===========================================================================
.going_right:
	cmpi.w	#16,d0
	blo.s	.move_x
	move.w	#16,d0

.move_x:
	move.b	d0,(Camera_BG_X_pos_diff).w
	sub.w	(Camera_BG_Y_pos).w,d1
	sub.w	(Camera_BG_Y_offset).w,d1
	bpl.s	.going_down
	cmpi.w	#-16,d1
	bgt.s	.skip_y_cap
	move.w	#-16,d1

.skip_y_cap:
	bra.s	.move_y
; ===========================================================================
.going_down:
	cmpi.w	#16,d1
	blo.s	.move_y
	move.w	#16,d1

.move_y:
	move.b	d1,(Camera_BG_Y_pos_diff).w
	rts
; End of function ScrollBG

; ===========================================================================
	; unused/dead code
	; This code is probably meant for testing the background scrolling code
	; used by HTZ and WFZ. It would allows the BG position to be shifted up
	; and down by the second controller.
	btst	#button_up,(Ctrl_2_Held).w
	beq.s	+
	tst.w	(Camera_BG_Y_offset).w
	beq.s	+
	subq.w	#1,(Camera_BG_Y_offset).w
+
	btst	#button_down,(Ctrl_2_Held).w
	beq.s	+
	cmpi.w	#$700,(Camera_BG_Y_offset).w
	beq.s	+
	addq.w	#1,(Camera_BG_Y_offset).w
+
	rts
; ===========================================================================
