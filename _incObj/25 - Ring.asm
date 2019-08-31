; ----------------------------------------------------------------------------
; Object 25 - A ring (usually only placed through placement mode)
; ----------------------------------------------------------------------------
; Obj_Ring:
Obj25:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj25_Index(pc,d0.w),d1
	jmp	Obj25_Index(pc,d1.w)
; ===========================================================================
; Obj_25_subtbl:
Obj25_Index:	offsetTable
		offsetTableEntry.w Obj25_Init		; 0
		offsetTableEntry.w Obj25_Animate	; 2
		offsetTableEntry.w Obj25_Collect	; 4
		offsetTableEntry.w Obj25_Sparkle	; 6
		offsetTableEntry.w Obj25_Delete		; 8
; ===========================================================================
; Obj_25_sub_0:
Obj25_Init:
	addq.b	#2,routine(a0)
	move.w	x_pos(a0),objoff_32(a0)
	move.l	#Obj25_MapUnc_12382,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Ring,1,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	move.b	#4,render_flags(a0)
	move.b	#2,priority(a0)
	move.b	#$47,collision_flags(a0)
	move.b	#8,width_pixels(a0)
; Obj_25_sub_2:
Obj25_Animate:
	move.b	(Rings_anim_frame).w,mapping_frame(a0)
	move.w	objoff_32(a0),d0
	bra.w	MarkObjGone2
; ===========================================================================
; Obj_25_sub_4:
Obj25_Collect:
	addq.b	#2,routine(a0)
	move.b	#0,collision_flags(a0)
	move.b	#1,priority(a0)
	bsr.s	CollectRing
; Obj_25_sub_6:
Obj25_Sparkle:
	lea	(Ani_Ring).l,a1
	bsr.w	AnimateSprite
	bra.w	DisplaySprite
; ===========================================================================
; BranchTo4_DeleteObject 
Obj25_Delete:
	bra.w	DeleteObject

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_11FC2:
CollectRing:
	tst.b	parent+1(a0)		; did Tails collect the ring?
	bne.s	CollectRing_Tails	; if yes, branch

CollectRing_Sonic:
	cmpi.w	#999,(Rings_Collected).w ; did Sonic collect 999 or more rings?
	bhs.s	CollectRing_1P		; if yes, branch
	addq.w	#1,(Rings_Collected).w	; add 1 to the number of collected rings

CollectRing_1P:

    if gameRevision=0
	cmpi.w	#999,(Ring_count).w	; does the player 1 have 999 or more rings?
	bhs.s	+			; if yes, skip the increment
	addq.w	#1,(Ring_count).w	; add 1 to the ring count
+
	ori.b	#1,(Update_HUD_rings).w	; set flag to update the ring counter in the HUD
	move.w	#SndID_Ring,d0		; prepare to play the ring sound
    else
	move.w	#SndID_Ring,d0		; prepare to play the ring sound
	cmpi.w	#999,(Ring_count).w	; does the player 1 have 999 or more rings?
	bhs.s	JmpTo_PlaySoundStereo	; if yes, play the ring sound
	addq.w	#1,(Ring_count).w	; add 1 to the ring count
	ori.b	#1,(Update_HUD_rings).w	; set flag to update the ring counter in the HUD
    endif

	cmpi.w	#100,(Ring_count).w	; does the player 1 have less than 100 rings?
	blo.s	JmpTo_PlaySoundStereo	; if yes, play the ring sound
	bset	#1,(Extra_life_flags).w	; test and set the flag for the first extra life
	beq.s	+			; if it was clear before, branch
	cmpi.w	#200,(Ring_count).w	; does the player 1 have less than 200 rings?
	blo.s	JmpTo_PlaySoundStereo	; if yes, play the ring sound
	bset	#2,(Extra_life_flags).w	; test and set the flag for the second extra life
	bne.s	JmpTo_PlaySoundStereo	; if it was set before, play the ring sound
+
	addq.b	#1,(Life_count).w	; add 1 to the life count
	addq.b	#1,(Update_HUD_lives).w	; add 1 to the displayed life count
	move.w	#MusID_ExtraLife,d0	; prepare to play the extra life jingle

JmpTo_PlaySoundStereo 
	jmp	(PlaySoundStereo).l
; ===========================================================================
	rts
; ===========================================================================

CollectRing_Tails:
	cmpi.w	#999,(Rings_Collected_2P).w	; did Tails collect 999 or more rings?
	bhs.s	+				; if yes, branch
	addq.w	#1,(Rings_Collected_2P).w	; add 1 to the number of collected rings
+                                          
	cmpi.w	#999,(Ring_count_2P).w		; does Tails have 999 or more rings?
	bhs.s	+				; if yes, branch
	addq.w	#1,(Ring_count_2P).w		; add 1 to the ring count
+
	tst.w	(Two_player_mode).w		; are we in a 2P game?
	beq.s	CollectRing_1P			; if not, branch

; CollectRing_2P:
	ori.b	#1,(Update_HUD_rings_2P).w	; set flag to update the ring counter in the second player's HUD
	move.w	#SndID_Ring,d0			; prepare to play the ring sound
	cmpi.w	#100,(Ring_count_2P).w		; does the player 2 have less than 100 rings?
	blo.s	JmpTo2_PlaySoundStereo		; if yes, play the ring sound
	bset	#1,(Extra_life_flags_2P).w	; test and set the flag for the first extra life
	beq.s	+				; if it was clear before, branch
	cmpi.w	#200,(Ring_count_2P).w		; does the player 2 have less than 200 rings?
	blo.s	JmpTo2_PlaySoundStereo		; if yes, play the ring sound
	bset	#2,(Extra_life_flags_2P).w	; test and set the flag for the second extra life
	bne.s	JmpTo2_PlaySoundStereo		; if it was set before, play the ring sound
+
	addq.b	#1,(Life_count_2P).w		; add 1 to the life count
	addq.b	#1,(Update_HUD_lives_2P).w	; add 1 to the displayed life count
	move.w	#MusID_ExtraLife,d0		; prepare to play the extra life jingle

JmpTo2_PlaySoundStereo 
	jmp	(PlaySoundStereo).l
; End of function CollectRing