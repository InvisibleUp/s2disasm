; -------------------------------------------------------------------------------
; This runs the code of all the objects that are in Object_RAM
; -------------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_15F9C: ObjectsLoad:
RunObjects:
	tst.b	(Teleport_flag).w
	bne.s	RunObjects_End	; rts
	lea	(Object_RAM).w,a0 ; a0=object

	moveq	#(Dynamic_Object_RAM_End-Object_RAM)/object_size-1,d7 ; run the first $80 objects out of levels
	moveq	#0,d0
	cmpi.b	#GameModeID_Demo,(Game_Mode).w	; demo mode?
	beq.s	+	; if in a level in a demo, branch
	cmpi.b	#GameModeID_Level,(Game_Mode).w	; regular level mode?
	bne.s	RunObject ; if not in a level, branch to RunObject
+
	move.w	#(Object_RAM_End-Object_RAM)/object_size-1,d7	; run the first $90 objects in levels
	tst.w	(Two_player_mode).w
	bne.s	RunObject ; if in 2 player competition mode, branch to RunObject
	
	cmpi.b	#6,(MainCharacter+routine).w
	bhs.s	RunObjectsWhenPlayerIsDead ; if dead, branch
	; continue straight to RunObject
; ---------------------------------------------------------------------------

; -------------------------------------------------------------------------------
; This is THE place where each individual object's code gets called from
; -------------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_15FCC:
RunObject:
	move.b	id(a0),d0	; get the object's ID
	beq.s	RunNextObject ; if it's obj00, skip it

	add.w	d0,d0
	add.w	d0,d0	; d0 = object ID * 4
	movea.l	Obj_Index-4(pc,d0.w),a1	; load the address of the object's code
	jsr	(a1)	; dynamic call! to one of the the entries in Obj_Index
	moveq	#0,d0

; loc_15FDC:
RunNextObject:
	lea	next_object(a0),a0 ; load 0bj address
	dbf	d7,RunObject
; return_15FE4:
RunObjects_End:
	rts

; ---------------------------------------------------------------------------
; this skips certain objects to make enemies and things pause when Sonic dies
; loc_15FE6:
RunObjectsWhenPlayerIsDead:
	moveq	#(Reserved_Object_RAM_End-Reserved_Object_RAM)/object_size-1,d7
	bsr.s	RunObject	; run the first $10 objects normally
	moveq	#(Dynamic_Object_RAM_End-Dynamic_Object_RAM)/object_size-1,d7
	bsr.s	RunObjectDisplayOnly ; all objects in this range are paused
	moveq	#(LevelOnly_Object_RAM_End-LevelOnly_Object_RAM)/object_size-1,d7
	bra.s	RunObject	; run the last $10 objects normally

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_15FF2:
RunObjectDisplayOnly:
	moveq	#0,d0
	move.b	id(a0),d0	; get the object's ID
	beq.s	+	; if it's obj00, skip it
	tst.b	render_flags(a0)	; should we render it?
	bpl.s	+			; if not, skip it
	bsr.w	DisplaySprite
+
	lea	next_object(a0),a0 ; load 0bj address
	dbf	d7,RunObjectDisplayOnly
	rts
; End of function RunObjectDisplayOnly
