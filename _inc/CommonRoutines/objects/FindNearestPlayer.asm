; ---------------------------------------------------------------------------
; Get Orientation To Player
; Returns the horizontal and vertical distances of the closest player object.
;
; input variables:
;  a0 = object
;
; returns:
;  a1 = address of closest player character
;  d0 = 0 if player is left from object, 2 if right
;  d1 = 0 if player is above object, 2 if below
;  d2 = closest character's horizontal distance to object
;  d3 = closest character's vertical distance to object
;
; writes:
;  d0, d1, d2, d3, d4, d5
;  a1
;  a2 = sidekick
; ---------------------------------------------------------------------------
;loc_366D6:
Obj_GetOrientationToPlayer:
	moveq	#0,d0
	moveq	#0,d1
	lea	(MainCharacter).w,a1 ; a1=character
	move.w	x_pos(a0),d2
	sub.w	x_pos(a1),d2
	mvabs.w	d2,d4	; absolute horizontal distance to main character
	lea	(Sidekick).w,a2 ; a2=character
	move.w	x_pos(a0),d3
	sub.w	x_pos(a2),d3
	mvabs.w	d3,d5	; absolute horizontal distance to sidekick
	cmp.w	d5,d4	; get shorter distance
	bls.s	+	; branch, if main character is closer
	; if sidekick is closer
	movea.l	a2,a1
	move.w	d3,d2
+
	tst.w	d2	; is player to enemy's left?
	bpl.s	+	; if not, branch
	addq.w	#2,d0
+
	move.w	y_pos(a0),d3
	sub.w	y_pos(a1),d3	; vertical distance to closest character
	bhs.s	+	; branch, if enemy is under
	addq.w	#2,d1
+
	rts