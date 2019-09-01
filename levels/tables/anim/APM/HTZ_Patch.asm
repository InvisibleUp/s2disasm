; ===========================================================================
; loc_407C0:
PatchHTZTiles:
	lea	(ArtNem_HTZCliffs).l,a0
	lea	(Object_RAM+$800).w,a4
	jsrto	(NemDecToRAM).l, JmpTo2_NemDecToRAM
	lea	(Object_RAM+$800).w,a1
	lea_	word_3FD9C,a4
	moveq	#0,d2
	moveq	#7,d4

loc_407DA:
	moveq	#5,d3

loc_407DC:
	moveq	#-1,d0
	move.w	(a4)+,d0
	movea.l	d0,a2
	moveq	#$1F,d1

loc_407E4:
	move.l	(a1),(a2)+
	move.l	d2,(a1)+
	dbf	d1,loc_407E4
	dbf	d3,loc_407DC
	adda.w	#$C,a4
	dbf	d4,loc_407DA
	rts
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo2_NemDecToRAM 
	jmp	(NemDecToRAM).l

	align 4
    endif
