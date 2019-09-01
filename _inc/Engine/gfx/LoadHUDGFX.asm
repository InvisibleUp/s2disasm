; ---------------------------------------------------------------------------
; Subroutine to initialize ring counter on the HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4105A:
; Hud_LoadZero:
Hud_InitRings:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Rings),VRAM,WRITE),(VDP_control_port).l
	lea	Hud_TilesRings(pc),a2
	move.w	#(Hud_TilesBase_End-Hud_TilesRings)-1,d2
	bra.s	loc_41090

; ---------------------------------------------------------------------------
; Subroutine to load uncompressed HUD patterns ("E", "0", colon)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_4106E:
Hud_Base:
	lea	(VDP_data_port).l,a6
	bsr.w	Hud_Lives
	tst.w	(Two_player_mode).w
	bne.s	loc_410BC
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Score_E),VRAM,WRITE),(VDP_control_port).l
	lea	Hud_TilesBase(pc),a2
	move.w	#(Hud_TilesBase_End-Hud_TilesBase)-1,d2

loc_41090:
	lea	Art_Hud(pc),a1

loc_41094:
	move.w	#8*hud_letter_num_tiles-1,d1
	move.b	(a2)+,d0
	bmi.s	loc_410B0
	ext.w	d0
	lsl.w	#5,d0
	lea	(a1,d0.w),a3

loc_410A4:
	move.l	(a3)+,(a6)
	dbf	d1,loc_410A4

loc_410AA:
	dbf	d2,loc_41094
	rts
; ===========================================================================

loc_410B0:
	move.l	#0,(a6)
	dbf	d1,loc_410B0
	bra.s	loc_410AA
; End of function Hud_Base

; ===========================================================================

loc_410BC:
	bsr.w	Hud_Lives2
	move.l	#Art_Hud,d1 ; source addreses
	move.w	#tiles_to_bytes(ArtTile_Art_HUD_Numbers_2P),d2 ; destination VRAM address
	move.w	#tiles_to_bytes(22)/2,d3 ; DMA transfer length (in words)
	jmp	(QueueDMATransfer).l
; ===========================================================================

	charset	' ',$FF
	charset	'0',0
	charset	'1',2
	charset	'2',4
	charset	'3',6
	charset	'4',8
	charset	'5',$A
	charset	'6',$C
	charset	'7',$E
	charset	'8',$10
	charset	'9',$12
	charset	':',$14
	charset	'E',$16

; byte_410D4:
Hud_TilesBase:
	dc.b "E      0"
	dc.b "0:00"
; byte_410E0:
; Hud_TilesZero:
Hud_TilesRings:
	dc.b "  0"
Hud_TilesBase_End

	charset
	even

; ---------------------------------------------------------------------------
; Subroutine to load debug mode numbers patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_410E4:
HudDb_XY:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Score_E),VRAM,WRITE),(VDP_control_port).l
	move.w	(Camera_X_pos).w,d1
	swap	d1
	move.w	(MainCharacter+x_pos).w,d1
	bsr.s	HudDb_XY2
	move.w	(Camera_Y_pos).w,d1
	swap	d1
	move.w	(MainCharacter+y_pos).w,d1
; loc_41104:
HudDb_XY2:
	moveq	#7,d6
	lea	(Art_Text).l,a1
; loc_4110C:
HudDb_XYLoop:
	rol.w	#4,d1
	move.w	d1,d2
	andi.w	#$F,d2
	cmpi.w	#$A,d2
	blo.s	loc_4111E
	addi_.w	#7,d2

loc_4111E:
	lsl.w	#5,d2
	lea	(a1,d2.w),a3
    rept 8
	move.l	(a3)+,(a6)
    endm
	swap	d1
	dbf	d6,HudDb_XYLoop
	rts
; End of function HudDb_XY

; ---------------------------------------------------------------------------
; Subroutine to load rings numbers patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4113C:
Hud_Rings:
	lea	(Hud_100).l,a2
	moveq	#2,d6
	bra.s	Hud_LoadArt
; End of function Hud_Rings

; ---------------------------------------------------------------------------
; Subroutine to load score numbers patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41146:
Hud_Score:
	lea	(Hud_100000).l,a2
	moveq	#5,d6
; loc_4114E:
Hud_LoadArt:
	moveq	#0,d4
	lea	Art_Hud(pc),a1
; loc_41154:
Hud_ScoreLoop:
	moveq	#0,d2
	move.l	(a2)+,d3

loc_41158:
	sub.l	d3,d1
	bcs.s	loc_41160
	addq.w	#1,d2
	bra.s	loc_41158
; ===========================================================================

loc_41160:
	add.l	d3,d1
	tst.w	d2
	beq.s	loc_4116A
	move.w	#1,d4

loc_4116A:
	tst.w	d4
	beq.s	loc_41198
	lsl.w	#6,d2
	move.l	d0,4(a6)
	lea	(a1,d2.w),a3
    rept 8*hud_letter_num_tiles
	move.l	(a3)+,(a6)
    endm

loc_41198:
	addi.l	#hud_letter_vdp_delta,d0
	dbf	d6,Hud_ScoreLoop
	rts
; End of function Hud_Score

; ---------------------------------------------------------------------------
; Subroutine to load countdown numbers on the continue screen
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_411A4:
ContScrCounter:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ContinueCountdown),VRAM,WRITE),(VDP_control_port).l
	lea	(VDP_data_port).l,a6
	lea	(Hud_10).l,a2
	moveq	#1,d6
	moveq	#0,d4
	lea	Art_Hud(pc),a1
; loc_411C2:
ContScr_Loop:
	moveq	#0,d2
	move.l	(a2)+,d3

loc_411C6:
	sub.l	d3,d1
	bcs.s	loc_411CE
	addq.w	#1,d2
	bra.s	loc_411C6
; ===========================================================================

loc_411CE:
	add.l	d3,d1
	lsl.w	#6,d2
	lea	(a1,d2.w),a3
    rept 16
	move.l	(a3)+,(a6)
    endm
	dbf	d6,ContScr_Loop	; repeat 1 more time
	rts
; End of function ContScrCounter

; ===========================================================================
; ---------------------------------------------------------------------------
; for HUD counter
; ---------------------------------------------------------------------------
				; byte_411FC:
Hud_100000:	dc.l 100000	; byte_41200: ; Hud_10000:
		dc.l 10000	; byte_41204:
Hud_1000:	dc.l 1000	; byte_41208:
Hud_100:	dc.l 100	; byte_4120C:
Hud_10:		dc.l 10		; byte_41210:
Hud_1:		dc.l 1

; ---------------------------------------------------------------------------
; Subroutine to load time numbers patterns
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41214:
Hud_Mins:
	lea_	Hud_1,a2
	moveq	#0,d6
	bra.s	loc_41222
; ===========================================================================
; loc_4121C:
Hud_Secs:
	lea_	Hud_10,a2
	moveq	#1,d6

loc_41222:
	moveq	#0,d4
	lea	Art_Hud(pc),a1
; loc_41228:
Hud_TimeLoop:
	moveq	#0,d2
	move.l	(a2)+,d3

loc_4122C:
	sub.l	d3,d1
	bcs.s	loc_41234
	addq.w	#1,d2
	bra.s	loc_4122C
; ===========================================================================

loc_41234:
	add.l	d3,d1
	tst.w	d2
	beq.s	loc_4123E
	move.w	#1,d4

loc_4123E:
	lsl.w	#6,d2
	move.l	d0,4(a6)
	lea	(a1,d2.w),a3
    rept 8*hud_letter_num_tiles
	move.l	(a3)+,(a6)
    endm
	addi.l	#hud_letter_vdp_delta,d0
	dbf	d6,Hud_TimeLoop
	rts
; End of function Hud_Mins

; ---------------------------------------------------------------------------
; Subroutine to load time/ring bonus numbers patterns
; ---------------------------------------------------------------------------

; ===========================================================================
; loc_41274:
Hud_TimeRingBonus:
	lea_	Hud_1000,a2
	moveq	#3,d6
	moveq	#0,d4
	lea	Art_Hud(pc),a1
; loc_41280:
Hud_BonusLoop:
	moveq	#0,d2
	move.l	(a2)+,d3

loc_41284:
	sub.l	d3,d1
	bcs.s	loc_4128C
	addq.w	#1,d2
	bra.s	loc_41284
; ===========================================================================

loc_4128C:
	add.l	d3,d1
	tst.w	d2
	beq.s	loc_41296
	move.w	#1,d4

loc_41296:
	tst.w	d4
	beq.s	Hud_ClrBonus
	lsl.w	#6,d2
	lea	(a1,d2.w),a3
    rept 8*hud_letter_num_tiles
	move.l	(a3)+,(a6)
    endm

loc_412C0:
	dbf	d6,Hud_BonusLoop ; repeat 3 more times
	rts
; ===========================================================================
; loc_412C6:
Hud_ClrBonus:
	moveq	#8*hud_letter_num_tiles-1,d5
; loc_412C8:
Hud_ClrBonusLoop:
	move.l	#0,(a6)
	dbf	d5,Hud_ClrBonusLoop
	bra.s	loc_412C0

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; ---------------------------------------------------------------------------
; Subroutine to load uncompressed lives counter patterns (Sonic)
; ---------------------------------------------------------------------------

; sub_412D4:
Hud_Lives2:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtUnc_2p_life_counter_lives),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Life_count_2P).w,d1
	bra.s	loc_412EE
; End of function Hud_Lives2

; ---------------------------------------------------------------------------
; Subroutine to load uncompressed lives counter patterns (Tails)
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_412E2:
Hud_Lives:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_ArtNem_life_counter_lives),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Life_count).w,d1

loc_412EE:
	lea_	Hud_10,a2
	moveq	#1,d6
	moveq	#0,d4
	lea	Art_LivesNums(pc),a1
; loc_412FA:
Hud_LivesLoop:
	move.l	d0,4(a6)
	moveq	#0,d2
	move.l	(a2)+,d3
-	sub.l	d3,d1
	bcs.s	loc_4130A
	addq.w	#1,d2
	bra.s	-
; ===========================================================================

loc_4130A:
	add.l	d3,d1
	tst.w	d2
	beq.s	loc_41314
	move.w	#1,d4

loc_41314:
	tst.w	d4
	beq.s	Hud_ClrLives

loc_41318:
	lsl.w	#5,d2
	lea	(a1,d2.w),a3
    rept 8
	move.l	(a3)+,(a6)
    endm

loc_4132E:
	addi.l	#hud_letter_vdp_delta,d0
	dbf	d6,Hud_LivesLoop ; repeat 1 more time
	rts
; ===========================================================================
; loc_4133A:
Hud_ClrLives:
	tst.w	d6
	beq.s	loc_41318
	moveq	#7,d5
; loc_41340:
Hud_ClrLivesLoop:
	move.l	#0,(a6)
	dbf	d5,Hud_ClrLivesLoop
	bra.s	loc_4132E
; End of function Hud_Lives

; ===========================================================================
; ArtUnc_4134C:
Art_Hud:	BINCLUDE	"art/uncompressed/Big and small numbers used on counters - 1.bin"
; ArtUnc_4164C:
Art_LivesNums:	BINCLUDE	"art/uncompressed/Big and small numbers used on counters - 2.bin"
; ArtUnc_4178C:
Art_Text:	BINCLUDE	"art/uncompressed/Big and small numbers used on counters - 3.bin"

    if ~~removeJmpTos
JmpTo_DrawSprite_2P_Loop 
	jmp	(DrawSprite_2P_Loop).l
JmpTo_DrawSprite_Loop 
	jmp	(DrawSprite_Loop).l

	align 4
    endif
