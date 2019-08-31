; ===========================================================================
; Unused - dead code/data S1 big ring:
; ===========================================================================
; BigRing:
	; a0=object
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	BigRing_States(pc,d0.w),d1
	jmp	BigRing_States(pc,d1.w)
; ===========================================================================
BigRing_States:	offsetTable
		offsetTableEntry.w BigRing_Init		; 0
		offsetTableEntry.w BigRing_Main		; 2
		offsetTableEntry.w BigRing_Enter	; 4
		offsetTableEntry.w BigRing_Delete	; 6
; ===========================================================================
; loc_12216:
BigRing_Init:
	move.l	#Obj37_MapUnc_123E6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BigRing,1,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#$40,width_pixels(a0)
	tst.b	render_flags(a0)
	bpl.s	BigRing_Main
	cmpi.b	#6,(Got_Emerald).w
	beq.w	BigRing_Delete
	cmpi.w	#50,(Ring_count).w
	bhs.s	+
	rts
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.b	#2,priority(a0)
	move.b	#$52,collision_flags(a0)
	move.w	#$C40,(BigRingGraphics).w
; loc_12264:
BigRing_Main:
	move.b	(Rings_anim_frame).w,mapping_frame(a0)
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	DeleteObject
	bra.w	DisplaySprite
; ===========================================================================
; loc_12282:
BigRing_Enter:
	subq.b	#2,routine(a0)
	move.b	#0,collision_flags(a0)
	bsr.w	SingleObjLoad
	bne.w	+
	; Note: the object ID is not set
	; If you want to restore the big ring object, you'll also have to
	; restore the ring flash object (right after this) and assign its ID to
	; the created object here (a1).
	;move.b	#ObjID_BigRingFlash,id(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.l	a0,objoff_3C(a1)
	move.w	(MainCharacter+x_pos).w,d0
	cmp.w	x_pos(a0),d0
	blo.s	+
	bset	#0,render_flags(a1)
+
	move.w	#SndID_EnterGiantRing,d0
	jsr	(PlaySoundStereo).l
	bra.s	BigRing_Main
; ===========================================================================
; BranchTo6_DeleteObject 
BigRing_Delete:
	bra.w	DeleteObject

; Unused - dead code/data S1 ring flash:
; ===========================================================================
; BigRingFlash:
	; a0=object
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	BigRingFlash_States(pc,d0.w),d1
	jmp	BigRingFlash_States(pc,d1.w)
; ===========================================================================
BigRingFlash_States: offsetTable
	offsetTableEntry.w BigRingFlash_Init	; 0
	offsetTableEntry.w BigRingFlash_Main	; 2
	offsetTableEntry.w BigRingFlash_Delete	; 4
; ===========================================================================
; loc_122D8:
BigRingFlash_Init:
	addq.b	#2,routine(a0)
	move.l	#Obj37_MapUnc_124E6,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_BigRing_Flash,1,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	ori.b	#4,render_flags(a0)
	move.b	#0,priority(a0)
	move.b	#$20,width_pixels(a0)
	move.b	#-1,mapping_frame(a0)
; loc_12306:
BigRingFlash_Main:
	bsr.s	BigRingFlash_Animate
	move.w	x_pos(a0),d0
	andi.w	#$FF80,d0
	sub.w	(Camera_X_pos_coarse).w,d0
	cmpi.w	#$280,d0
	bhi.w	DeleteObject
	bra.w	DisplaySprite

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_12320:
BigRingFlash_Animate:
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
	bpl.s	+	; rts
	move.b	#1,anim_frame_duration(a0)	; reset frame duration (2 frames)
	addq.b	#1,mapping_frame(a0)		; use next animation frame
	cmpi.b	#8,mapping_frame(a0)		; have we reached the end of the animation frames?
	bhs.s	++				; if yes, branch
	cmpi.b	#3,mapping_frame(a0)		; have we reached the 4th animation frame?
	bne.s	+	; rts			; if not, return
	movea.l	objoff_3C(a0),a1 ; a1=object	; get the parent big ring object
	move.b	#6,routine(a1)			; set its routine to "delete"
	move.b	#AniIDSonAni_Blank,(MainCharacter+anim).w	; change the character's animation
	move.b	#1,(SpecialStage_flag_2P).w
	lea	(MainCharacter).w,a1 ; a1=character
	bclr	#status_sec_isInvincible,status_secondary(a1)
	bclr	#status_sec_hasShield,status_secondary(a1)
+	rts
; ===========================================================================
+
	addq.b	#2,routine(a0)
	move.w	#0,(MainCharacter).w		; delete the player object
	addq.l	#4,sp
	rts
; End of function BigRingFlash_Animate

; ===========================================================================
; BranchTo7_DeleteObject 
BigRingFlash_Delete:
	bra.w	DeleteObject

; end of dead code/data

; ===========================================================================
