; ---------------------------------------------------------------------------
; Align Child XY
; Moves a referenced object to the position of the current object with
; variable x and y offset.
;
; input variables:
;  d0 = x offset
;  d1 = y offset
;
;  a0 = parent object
;  a1 = child object
;
; writes:
;  d2 = new x position
;  d3 = new y position
; ---------------------------------------------------------------------------
;loc_36760:
Obj_AlignChildXY:
	move.w	x_pos(a0),d2
	add.w	d0,d2
	move.w	d2,x_pos(a1)
	move.w	y_pos(a0),d3
	add.w	d1,d3
	move.w	d3,y_pos(a1)
	rts
; ===========================================================================

loc_36776:
	move.w	(Tornado_Velocity_X).w,d0
	add.w	d0,x_pos(a0)
	move.w	(Tornado_Velocity_Y).w,d0
	add.w	d0,y_pos(a0)
	rts
; ===========================================================================