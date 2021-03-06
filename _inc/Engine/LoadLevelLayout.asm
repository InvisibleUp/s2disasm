; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


loadLevelLayout:
	moveq	#0,d0
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#6,d0
	lea	(Off_Level).l,a0
	move.w	(a0,d0.w),d0
	lea	(a0,d0.l),a0
	lea	(Level_Layout).w,a1
	jmpto	(KosDec).l, JmpTo_KosDec
; End of function loadLevelLayout

; ===========================================================================
	lea	(Level_Layout).w,a3
	move.w	#bytesToLcnt(Level_Layout_End-Level_Layout),d1
	moveq	#0,d0

-	move.l	d0,(a3)+
	dbf	d1,-

	lea	(Level_Layout).w,a3
	moveq	#0,d1
	bsr.w	sub_E4A2
	lea	(Level_Layout+$80).w,a3
	moveq	#2,d1

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_E4A2:
	moveq	#0,d0
	move.w	(Current_ZoneAndAct).w,d0
	ror.b	#1,d0
	lsr.w	#5,d0
	add.w	d1,d0
	lea	(Off_Level).l,a1
	move.w	(a1,d0.w),d0
	lea	(a1,d0.l),a1
	moveq	#0,d1
	move.w	d1,d2
	move.b	(a1)+,d1
	move.b	(a1)+,d2
	move.l	d1,d5
	addq.l	#1,d5
	moveq	#0,d3
	move.w	#$80,d3
	divu.w	d5,d3
	subq.w	#1,d3

-	movea.l	a3,a0

	move.w	d3,d4
-	move.l	a1,-(sp)

	move.w	d1,d0
-	move.b	(a1)+,(a0)+
	dbf	d0,-

	movea.l	(sp)+,a1
	dbf	d4,--

	lea	(a1,d5.w),a1
	lea	$100(a3),a3
	dbf	d2,---

	rts
; End of function sub_E4A2

; ===========================================================================
	lea	($FE0000).l,a1
	lea	($FE0080).l,a2
	lea	(Chunk_Table).l,a3

	move.w	#$3F,d1
-	bsr.w	sub_E59C
	bsr.w	sub_E59C
	dbf	d1,-

	lea	($FE0000).l,a1
	lea	($FF0000).l,a2

	move.w	#$3F,d1
-	move.w	#0,(a2)+
	dbf	d1,-

	move.w	#$3FBF,d1
-	move.w	(a1)+,(a2)+
	dbf	d1,-

	rts
; ===========================================================================
	lea	($FE0000).l,a1
	lea	(Chunk_Table).l,a3

	moveq	#$1F,d0
-	move.l	(a1)+,(a3)+
	dbf	d0,-

	moveq	#0,d7
	lea	($FE0000).l,a1
	move.w	#$FF,d5

loc_E55A:
	lea	(Chunk_Table).l,a3
	move.w	d7,d6

-	movem.l	a1-a3,-(sp)
	move.w	#$3F,d0

-	cmpm.w	(a1)+,(a3)+
	bne.s	+
	dbf	d0,-
	movem.l	(sp)+,a1-a3
	adda.w	#$80,a1
	dbf	d5,loc_E55A

	bra.s	++
; ===========================================================================
+	movem.l	(sp)+,a1-a3
	adda.w	#$80,a3
	dbf	d6,--

	moveq	#$1F,d0
-	move.l	(a1)+,(a3)+
	dbf	d0,-

	addq.l	#1,d7
	dbf	d5,loc_E55A
/
	bra.s	-	; infinite loop

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_E59C:
	moveq	#7,d0
-	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a1)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	move.l	(a3)+,(a2)+
	dbf	d0,-

	adda.w	#$80,a1
	adda.w	#$80,a2
	rts
; End of function sub_E59C

 ; ===========================================================================

    if gameRevision=0
	nop
    endif

    if ~~removeJmpTos
; JmpTo_PalLoad2 
JmpTo_PalLoad_Now 
	jmp	(PalLoad_Now).l
JmpTo_LoadPLC 
	jmp	(LoadPLC).l
JmpTo_KosDec 
	jmp	(KosDec).l

	align 4
    endif