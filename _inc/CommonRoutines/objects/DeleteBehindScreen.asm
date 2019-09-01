; ---------------------------------------------------------------------------
; Delete If Behind Screen
; deletes an object if it scrolls off the left side of the screen
;
; input variables:
;  a0 = object
;
; writes:
;  d0
; ---------------------------------------------------------------------------
;loc_36788:
Obj_DeleteBehindScreen:
	tst.w	(Two_player_mode).w
	beq.s	+
	jmp	(DisplaySprite).l
+
	; when not in two player mode
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	bmi.w	JmpTo64_DeleteObject
	jmp	(DisplaySprite).l
; ===========================================================================
