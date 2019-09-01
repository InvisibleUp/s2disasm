; ---------------------------------------------------------------------------
; LoadSubObject
; loads information from a sub-object into this object a0
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_365F4:
LoadSubObject:
	moveq	#0,d0
	move.b	subtype(a0),d0
; loc_365FA:
LoadSubObject_Part2:
	move.w	SubObjData_Index(pc,d0.w),d0
	lea	SubObjData_Index(pc,d0.w),a1
; loc_36602:
LoadSubObject_Part3:
	move.l	(a1)+,mappings(a0)
	move.w	(a1)+,art_tile(a0)
	jsr	(Adjust2PArtPointer).l
	move.b	(a1)+,d0
	or.b	d0,render_flags(a0)
	move.b	(a1)+,priority(a0)
	move.b	(a1)+,width_pixels(a0)
	move.b	(a1),collision_flags(a0)
	addq.b	#2,routine(a0)
	rts
