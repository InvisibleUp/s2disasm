;loc_15584: ; level title card drawing function called from Vint
DrawLevelTitleCard:
	lea	(VDP_data_port).l,a6
	tst.w	(TitleCard_ZoneName+titlecard_leaveflag).w
	bne.w	loc_15670
	moveq	#$3F,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6
	tst.w	(Two_player_mode).w
	beq.s	loc_155A8
	moveq	#$1F,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6

loc_155A8:
	lea	(TitleCard_Background+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)

loc_155AE:
	move.w	(a0)+,d0
	beq.s	loc_155C6
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d5,d4

loc_155C0:
	move.l	d6,(a6)
	dbf	d4,loc_155C0

loc_155C6:
	dbf	d7,loc_155AE
	moveq	#$26,d1
	sub.w	(TitleCard_Bottom+titlecard_split_point).w,d1
	lsr.w	#1,d1
	subq.w	#1,d1
	moveq	#7,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6
	tst.w	(Two_player_mode).w
	beq.s	loc_155EA
	moveq	#3,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6

loc_155EA:
	lea	(TitleCard_Bottom+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)

loc_155F0:
	move.w	(a0)+,d0
	beq.s	loc_15614
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	move.w	d5,d4

loc_155FE:
	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d1,d3

loc_15604:
	move.l	d6,(a6)
	dbf	d3,loc_15604
	addi.l	#vdpCommDelta($0080),d0
	dbf	d4,loc_155FE

loc_15614:
	dbf	d7,loc_155F0
	move.w	(TitleCard_Left+titlecard_split_point).w,d1 ; horizontal draw from left until this position
	subq.w	#1,d1
	moveq	#$D,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$58,0,0,0,1),d6 ; VRAM location of graphic to fill on left side
	tst.w	(Two_player_mode).w
	beq.s	loc_15634
	moveq	#6,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$58,0,0,0,1),d6 ; VRAM location of graphic to fill on left side (2p)

loc_15634:
	lea	(TitleCard_Left+titlecard_vram_dest).w,a0 ; obj34 red title card left side part
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)
	move.w	#$8F80,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0080

loc_15640:
	move.w	(a0)+,d0
	beq.s	loc_15664
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	move.w	d1,d4

loc_1564E:
	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.w	d5,d3

loc_15654:
	move.l	d6,(a6)
	dbf	d3,loc_15654
	addi.l	#vdpCommDelta($0002),d0
	dbf	d4,loc_1564E

loc_15664:
	dbf	d7,loc_15640
	move.w	#$8F02,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0002
	rts
; ===========================================================================

loc_15670:
	moveq	#9,d3
	moveq	#3,d4
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6
	tst.w	(Two_player_mode).w
	beq.s	+
	moveq	#4,d3
	moveq	#1,d4
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5C,0,0,1,1),d6
+
	lea	(TitleCard_Left+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)
	move.w	#$8F80,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0080

loc_156A2:
	move.w	(a0)+,d0
	beq.s	loc_156CE
	clr.w	-2(a0)
	jsr	sub_15792(pc)
	moveq	#3,d2

loc_156B0:
	move.l	d0,VDP_control_port-VDP_data_port(a6)

	move.w	d3,d1
-	move.l	d5,(a6)
	dbf	d1,-

	move.w	d4,d1
-	move.l	d6,(a6)
	dbf	d1,-

	addi.l	#vdpCommDelta($0002),d0
	dbf	d2,loc_156B0

loc_156CE:
	dbf	d7,loc_156A2
	move.w	#$8F02,VDP_control_port-VDP_data_port(a6)	; VRAM pointer increment: $0002
	moveq	#7,d5
	move.l	#make_block_tile_pair(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6
	tst.w	(Two_player_mode).w
	beq.s	+
	moveq	#3,d5
	move.l	#make_block_tile_pair_2p(ArtTile_ArtNem_TitleCard+$5A,0,0,0,1),d6
+
	lea	(TitleCard_Bottom+titlecard_vram_dest).w,a0
	moveq	#1,d7	; Once for P1, once for P2 (if in 2p mode)

loc_156F4:
	move.w	(a0)+,d0
	beq.s	loc_15714
	clr.w	-2(a0)
	jsr	sub_15792(pc)

	move.w	d5,d4
-	move.l	d0,VDP_control_port-VDP_data_port(a6)
	move.l	d6,(a6)
	move.l	d6,(a6)
	addi.l	#vdpCommDelta($0080),d0
	dbf	d4,-

loc_15714:
	dbf	d7,loc_156F4
	move.w	(TitleCard_Background+titlecard_vram_dest).w,d4
	beq.s	loc_1578C
	lea	VDP_control_port-VDP_data_port(a6),a5
	tst.w	(Two_player_mode).w
	beq.s	loc_15758
	lea	(Camera_X_pos_P2).w,a3
	lea	(Level_Layout).w,a4
	move.w	#vdpComm(VRAM_Plane_A_Name_Table_2P,VRAM,WRITE)>>16,d2

	moveq	#1,d6
-	movem.l	d4-d6,-(sp)
	moveq	#-$10,d5
	move.w	d4,d1
	bsr.w	CalcBlockVRAMPosB
	move.w	d1,d4
	moveq	#-$10,d5
	moveq	#$1F,d6
	bsr.w	DrawBlockRow
	movem.l	(sp)+,d4-d6
	addi.w	#$10,d4
	dbf	d6,-

loc_15758:
	lea	(Camera_X_pos).w,a3
	lea	(Level_Layout).w,a4
	move.w	#vdpComm(VRAM_Plane_A_Name_Table,VRAM,WRITE)>>16,d2
	move.w	(TitleCard_Background+titlecard_vram_dest).w,d4

	moveq	#1,d6
-	movem.l	d4-d6,-(sp)
	moveq	#-$10,d5
	move.w	d4,d1
	bsr.w	CalcBlockVRAMPos
	move.w	d1,d4
	moveq	#-$10,d5
	moveq	#$1F,d6
	bsr.w	DrawBlockRow
	movem.l	(sp)+,d4-d6
	addi.w	#$10,d4
	dbf	d6,-

loc_1578C:
	clr.w	(TitleCard_Background+titlecard_vram_dest).w
	rts
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to convert a VRAM address into a 32-bit VRAM write command word
; Input:
;	d0	VRAM address (word)
; Output:
;	d0	32-bit VDP command word for a VRAM write to specified address.
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_15792:
	andi.l	#$FFFF,d0
	lsl.l	#2,d0
	lsr.w	#2,d0
	ori.w	#vdpComm($0000,VRAM,WRITE)>>16,d0
	swap	d0
	rts
; End of function sub_15792

; ===========================================================================

;loc_157A4
LoadTitleCardSS:
	movem.l	d0/a0,-(sp)
	bsr.s	LoadTitleCard0
	movem.l	(sp)+,d0/a0
	bra.s	loc_157EC

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_157B0:
LoadTitleCard0:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_TitleCard),VRAM,WRITE),(VDP_control_port).l
	lea	(ArtNem_TitleCard).l,a0
	jsrto	(NemDec).l, JmpTo2_NemDec
	lea	(Level_Layout).w,a4
	lea	(ArtNem_TitleCard2).l,a0
	jmpto	(NemDecToRAM).l, JmpTo_NemDecToRAM
; ===========================================================================
; loc_157D2:
LoadTitleCard:
	bsr.s	LoadTitleCard0
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	move.b	Off_TitleCardLetters(pc,d0.w),d0
	lea	TitleCardLetters(pc),a0
	lea	(a0,d0.w),a0
	move.l	#vdpComm(tiles_to_bytes(ArtTile_LevelName),VRAM,WRITE),d0

loc_157EC:
	move	#$2700,sr
	lea	(Level_Layout).w,a1
	lea	(VDP_data_port).l,a6
	move.l	d0,4(a6)

loc_157FE:
	moveq	#0,d0
	move.b	(a0)+,d0
	bmi.s	loc_1581A
	lsl.w	#5,d0
	lea	(a1,d0.w),a2
	moveq	#0,d1
	move.b	(a0)+,d1
	lsl.w	#3,d1
	subq.w	#1,d1

loc_15812:
	move.l	(a2)+,(a6)
	dbf	d1,loc_15812
	bra.s	loc_157FE
; ===========================================================================

loc_1581A:
	move	#$2300,sr
	rts
; ===========================================================================
	include "levels/asm/TitleCards.asm"
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo2_NemDec 
	jmp	(NemDec).l
JmpTo_NemDecToRAM 
	jmp	(NemDecToRAM).l
JmpTo3_LoadPLC 
	jmp	(LoadPLC).l
JmpTo_sub_8476 
	jmp	(sub_8476).l

	align 4
    endif


