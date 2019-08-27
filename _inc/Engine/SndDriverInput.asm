; ---------------------------------------------------------------------------
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Input our music/sound selection to the sound driver.

sndDriverInput:
	lea	(Music_to_play&$00FFFFFF).l,a0
	lea	(Z80_RAM+zAbsVar).l,a1 ; $A01B80
	cmpi.b	#$80,zAbsVar.QueueToPlay-zAbsVar(a1)	; If this (zReadyFlag) isn't $80, the driver is processing a previous sound request.
	bne.s	loc_10C4	; So we'll wait until at least the next frame before putting anything in there.
	_move.b	0(a0),d0
	beq.s	loc_10A4
	_clr.b	0(a0)
	bra.s	loc_10AE
; ---------------------------------------------------------------------------

loc_10A4:
	move.b	4(a0),d0	; If there was something in Music_to_play_2, check what that was. Else, just go to the loop.
	beq.s	loc_10C4
	clr.b	4(a0)

loc_10AE:		; Check that the sound is not FE or FF
	move.b	d0,d1	; If it is, we need to put it in $A01B83 as $7F or $80 respectively
	subi.b	#MusID_Pause,d1
	bcs.s	loc_10C0
	addi.b	#$7F,d1
	move.b	d1,zAbsVar.StopMusic-zAbsVar(a1)
	bra.s	loc_10C4
; ---------------------------------------------------------------------------

loc_10C0:
	move.b	d0,zAbsVar.QueueToPlay-zAbsVar(a1)

loc_10C4:
	moveq	#4-1,d1
				; FFE4 (Music_to_play_2) goes to 1B8C (zMusicToPlay),
-	move.b	1(a0,d1.w),d0	; FFE3 (unk_FFE3) goes to 1B8B, (unknown)
	beq.s	+		; FFE2 (SFX_to_play_2) goes to 1B8A (zSFXToPlay2),
	tst.b	zAbsVar.SFXToPlay-zAbsVar(a1,d1.w)	; FFE1 (SFX_to_play) goes to 1B89 (zSFXToPlay).
	bne.s	+
	clr.b	1(a0,d1.w)
	move.b	d0,zAbsVar.SFXToPlay-zAbsVar(a1,d1.w)
+
	dbf	d1,-
	rts
; End of function sndDriverInput

    if ~~removeJmpTos
; sub_10E0:
JmpTo_LoadTilesAsYouMove 
	jmp	(LoadTilesAsYouMove).l
JmpTo_SegaScr_VInt 
	jmp	(SegaScr_VInt).l

	align 4
    endif