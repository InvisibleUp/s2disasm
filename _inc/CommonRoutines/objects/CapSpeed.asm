; ---------------------------------------------------------------------------
; Cap Object Speed
; Prevents an object from going over a specified speed value.
;
; input variables:
;  d0 = max x velocity
;  d1 = max y velocity
;
;  a0 = object
;
; writes:
;  d0, d1, d2, d3
; ---------------------------------------------------------------------------
; loc_3671A:
Obj_CapSpeed:
	move.w	x_vel(a0),d2
	bpl.s	+	; branch, if object is moving right
	; going left
	neg.w	d0	; set opposite direction
	cmp.w	d0,d2	; is object's current x velocity lower than max?
	bhs.s	++	; if yes, branch
	move.w	d0,d2	; else, cap speed
	bra.w	++
; ===========================================================================
+	; going right
	cmp.w	d0,d2	; is object's current x velocity lower than max?
	bls.s	+	; if yes, branch
	move.w	d0,d2	; else, cap speed
+
	move.w	y_vel(a0),d3
	bpl.s	+	; branch, if object is moving down
	; going up
	neg.w	d1	; set opposite direction
	cmp.w	d1,d3	; is object's current y velocity lower than max?
	bhs.s	++	; if yes, branch
	move.w	d1,d3	; else, cap speed
	bra.w	++
; ===========================================================================
+	; going down
	cmp.w	d1,d3	; is object's current y velocity lower than max?
	bls.s	+	; if yes, branch
	move.w	d1,d3	; else, cap speed
+	; update speed
	move.w	d2,x_vel(a0)
	move.w	d3,y_vel(a0)
	rts
; ===========================================================================