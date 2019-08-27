; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_49BC:
LoadCollisionIndexes:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	lsl.w	#2,d0
	move.l	#Primary_Collision,(Collision_addr).w
	move.w	d0,-(sp)
	movea.l	Off_ColP(pc,d0.w),a0
	lea	(Primary_Collision).w,a1
	bsr.w	KosDec
	move.w	(sp)+,d0
	movea.l	Off_ColS(pc,d0.w),a0
	lea	(Secondary_Collision).w,a1
	bra.w	KosDec
; End of function LoadCollisionIndexes