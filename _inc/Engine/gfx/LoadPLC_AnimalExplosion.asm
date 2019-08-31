; loc_F62E:
LoadPLC_AnimalExplosion:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	lea	(Animal_PLCTable).l,a2
	move.b	(a2,d0.w),d0
	jsrto	(LoadPLC).l, JmpTo2_LoadPLC
	moveq	#PLCID_Explosion,d0
	jsrto	(LoadPLC).l, JmpTo2_LoadPLC
	rts
; ===========================================================================