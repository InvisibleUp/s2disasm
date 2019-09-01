; loc_367AA:
InheritParentXYFlip:
	move.b	render_flags(a0),d0
	andi.b	#$FC,d0
	move.b	status(a0),d2
	andi.b	#$FC,d2
	move.b	render_flags(a1),d1
	andi.b	#3,d1
	or.b	d1,d0
	or.b	d1,d2
	move.b	d0,render_flags(a0)
	move.b	d2,status(a0)
	rts
; ===========================================================================

;loc_367D0:
LoadChildObject:
	jsr	(SingleObjLoad2).l
	bne.s	+	; rts
	move.w	(a2)+,d0
	move.w	a1,(a0,d0.w) ; store pointer to child in parent's SST
	_move.b	(a2)+,id(a1) ; load obj
	move.b	(a2)+,subtype(a1)
	move.w	a0,objoff_2C(a1) ; store pointer to parent in child's SST
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
+
	rts
; ===========================================================================
	; unused/dead code ; a0=object
	bsr.w	Obj_GetOrientationToPlayer
	bclr	#0,render_flags(a0)
	bclr	#0,status(a0)
	tst.w	d0
	beq.s	return_36818
	bset	#0,render_flags(a0)
	bset	#0,status(a0)

return_36818:
	rts
; ===========================================================================
; ---------------------------------------------------------------------------
; Create Projectiles
; Creates a specified number of generic moving projectiles.
; 
; input variables:
;  d2 = subtype, used for object initialization (refer to LoadSubObject)
;  d6 = number of projectiles to create -1
;
;  a2 = projectile stat list
;   format:
;   dc.b x_offset, y_offset, x_vel, y_vel, mapping_frame, render_flags
;
; writes:
;  d0
;  d1 = index in list
;  d6 = num objects
;
;  a1 = addres of new projectile
;  a3 = movement type (ObjectMove)
; ---------------------------------------------------------------------------
;loc_3681A:
Obj_CreateProjectiles:
	moveq	#0,d1
	; loop creates d6+1 projectiles
-
	jsr	(SingleObjLoad2).l
	bne.s	return_3686E
	_move.b	#ObjID_Projectile,id(a1) ; load obj98
	move.b	d2,subtype(a1)	; used for object initialization
	move.w	x_pos(a0),x_pos(a1)	; align objects
	move.w	y_pos(a0),y_pos(a1)
	lea	(ObjectMove).l,a3	; set movement type
	move.l	a3,objoff_2A(a1)
	lea	(a2,d1.w),a3	; get address in list
	move.b	(a3)+,d0	; get x offset
	ext.w	d0
	add.w	d0,x_pos(a1)
	move.b	(a3)+,d0	; get y offset
	ext.w	d0
	add.w	d0,y_pos(a1)
	move.b	(a3)+,x_vel(a1)	; set movement values
	move.b	(a3)+,y_vel(a1)
	move.b	(a3)+,mapping_frame(a1)	; set map frame
	move.b	(a3)+,render_flags(a1)	; set render flags
	addq.w	#6,d1
	dbf	d6,-

return_3686E:
	rts
; ===========================================================================