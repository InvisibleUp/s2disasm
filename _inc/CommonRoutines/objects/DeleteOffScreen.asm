; ---------------------------------------------------------------------------
; Delete If Off-Screen
; deletes an object if it is too far away from the screen
;
; input variables:
;  a0 = object
;
; writes:
;  d0
; ---------------------------------------------------------------------------
;loc_368F8:
Obj_DeleteOffScreen:
	tst.w	(Two_player_mode).w
	beq.s	+
	jmp	(DisplaySprite).l
+
	; when not in two player mode
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	JmpTo64_DeleteObject
	jmp	(DisplaySprite).l
; ===========================================================================

    if removeJmpTos
JmpTo65_DeleteObject 
    endif

JmpTo64_DeleteObject 
	jmp	(DeleteObject).l
