Dynamic_HTZ:
	tst.w	(Two_player_mode).w
	bne.w	Dynamic_Normal
	lea	(Anim_Counters).w,a3
	moveq	#0,d0
	move.w	(Camera_X_pos).w,d1
	neg.w	d1
	asr.w	#3,d1
	move.w	(Camera_X_pos).w,d0
	lsr.w	#4,d0
	add.w	d1,d0
	subi.w	#$10,d0
	divu.w	#$30,d0
	swap	d0
	cmp.b	1(a3),d0
	beq.s	BranchTo_loc_3FE5C
	move.b	d0,1(a3)
	move.w	d0,d2
	andi.w	#7,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	andi.w	#$38,d2
	lsr.w	#2,d2
	add.w	d2,d0
	lea	word_3FD9C(pc,d0.w),a4
	moveq	#5,d5
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_HTZMountains),d4

loc_3FD7C:
	moveq	#-1,d1
	move.w	(a4)+,d1
	andi.l	#$FFFFFF,d1
	move.w	d4,d2
	moveq	#tiles_to_bytes(4)/2,d3	; DMA transfer length (in words)
	jsr	(QueueDMATransfer).l
	addi.w	#$80,d4
	dbf	d5,loc_3FD7C

BranchTo_loc_3FE5C 
	bra.w	loc_3FE5C
; ===========================================================================
; HTZ mountain art main RAM addresses?
word_3FD9C:
	dc.w   $80, $180, $280, $580, $600, $700	; 6
	dc.w   $80, $180, $280, $580, $600, $700	; 12
	dc.w  $980, $A80, $B80, $C80, $D00, $D80	; 18
	dc.w  $980, $A80, $B80, $C80, $D00, $D80	; 24
	dc.w  $E80,$1180,$1200,$1280,$1300,$1380	; 30
	dc.w  $E80,$1180,$1200,$1280,$1300,$1380	; 36
	dc.w $1400,$1480,$1500,$1580,$1600,$1900	; 42
	dc.w $1400,$1480,$1500,$1580,$1600,$1900	; 48
	dc.w $1D00,$1D80,$1E00,$1F80,$2400,$2580	; 54
	dc.w $1D00,$1D80,$1E00,$1F80,$2400,$2580	; 60
	dc.w $2600,$2680,$2780,$2B00,$2F00,$3280	; 66
	dc.w $2600,$2680,$2780,$2B00,$2F00,$3280	; 72
	dc.w $3600,$3680,$3780,$3C80,$3D00,$3F00	; 78
	dc.w $3600,$3680,$3780,$3C80,$3D00,$3F00	; 84
	dc.w $3F80,$4080,$4480,$4580,$4880,$4900	; 90
	dc.w $3F80,$4080,$4480,$4580,$4880,$4900	; 96
; ===========================================================================

loc_3FE5C:
	lea	(TempArray_LayerDef).w,a1
	move.w	(Camera_X_pos).w,d2
	neg.w	d2
	asr.w	#3,d2
	move.l	a2,-(sp)
	lea	(ArtUnc_HTZClouds).l,a0
	lea	(Chunk_Table+$7C00).l,a2
	moveq	#$F,d1

loc_3FE78:
	move.w	(a1)+,d0
	neg.w	d0
	add.w	d2,d0
	andi.w	#$1F,d0
	lsr.w	#1,d0
	bcc.s	loc_3FE8A
	addi.w	#$200,d0

loc_3FE8A:
	lea	(a0,d0.w),a4
	lsr.w	#1,d0
	bcs.s	loc_3FEB4
	move.l	(a4)+,(a2)+
	adda.w	#$3C,a2
	move.l	(a4)+,(a2)+
	adda.w	#$3C,a2
	move.l	(a4)+,(a2)+
	adda.w	#$3C,a2
	move.l	(a4)+,(a2)+
	suba.w	#$C0,a2
	adda.w	#$20,a0
	dbf	d1,loc_3FE78
	bra.s	loc_3FEEC
; ===========================================================================

loc_3FEB4:
    rept 3
      rept 4
	move.b	(a4)+,(a2)+
      endm
	adda.w	#$3C,a2
    endm
    rept 4
	move.b	(a4)+,(a2)+
    endm
	suba.w	#$C0,a2
	adda.w	#$20,a0
	dbf	d1,loc_3FE78

loc_3FEEC:
	move.l	#(Chunk_Table+$7C00) & $FFFFFF,d1
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_HTZClouds),d2
	move.w	#tiles_to_bytes(8)/2,d3	; DMA transfer length (in words)
	jsr	(QueueDMATransfer).l
	movea.l	(sp)+,a2
	addq.w	#2,a3
	bra.w	loc_3FF30
; ===========================================================================
