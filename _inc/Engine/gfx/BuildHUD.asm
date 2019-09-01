; ---------------------------------------------------------------------------
; Subroutine to draw the HUD
; ---------------------------------------------------------------------------

hud_letter_num_tiles = 2
hud_letter_vdp_delta = vdpCommDelta(tiles_to_bytes(hud_letter_num_tiles))

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_40804:
BuildHUD:
	tst.w	(Ring_count).w
	beq.s	++	; blink ring count if it's 0
	moveq	#0,d1
	btst	#3,(Timer_frames+1).w
	bne.s	+	; only blink on certain frames
	cmpi.b	#9,(Timer_minute).w	; should the minutes counter blink?
	bne.s	+	; if not, branch
	addq.w	#2,d1	; set mapping frame time counter blink
+
	bra.s	++
+
	moveq	#0,d1
	btst	#3,(Timer_frames+1).w
	bne.s	+	; only blink on certain frames
	addq.w	#1,d1	; set mapping frame for ring count blink
	cmpi.b	#9,(Timer_minute).w
	bne.s	+
	addq.w	#2,d1	; set mapping frame for double blink
+
	move.w	#128+16,d3	; set X pos
	move.w	#128+136,d2	; set Y pos
	lea	(HUD_MapUnc_40A9A).l,a1
	movea.w	#make_art_tile(ArtTile_ArtNem_HUD,0,1),a3	; set art tile and flags
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	jsrto	(DrawSprite_Loop).l, JmpTo_DrawSprite_Loop	; draw frame
+
	rts
; End of function BuildHUD

; ===========================================================================

BuildHUD_P1:
	tst.w	(Ring_count).w
	beq.s	BuildHUD_P1_NoRings
	moveq	#0,d1
	btst	#3,(Timer_frames+1).w
	bne.s	+
	cmpi.b	#9,(Timer_minute).w
	bne.s	+
	addq.w	#2,d1	; make TIME flash
+
	bra.s	BuildHUD_P1_Continued
; ===========================================================================
; loc_40876:
BuildHUD_P1_NoRings:
	moveq	#0,d1
	btst	#3,(Timer_frames+1).w
	bne.s	BuildHUD_P1_Continued
	addq.w	#1,d1	; make RINGS flash
	cmpi.b	#9,(Timer_minute).w
	bne.s	BuildHUD_P1_Continued
	addq.w	#2,d1	; make TIME flash
; loc_4088C:
BuildHUD_P1_Continued:
	move.w	#$90,d3
	move.w	#$188,d2
	lea	(HUD_MapUnc_40BEA).l,a1
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Text_2P,0,1),a3
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	(DrawSprite_2P_Loop).l, JmpTo_DrawSprite_2P_Loop
	move.w	#$B8,d3
	move.w	#$108,d2
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Numbers_2P,0,1),a3
	moveq	#0,d7
	move.b	(Timer_minute).w,d7
	bsr.w	sub_4092E
	bsr.w	sub_4096A
	moveq	#0,d7
	move.b	(Timer_second).w,d7
	bsr.w	loc_40938
	move.w	#$C0,d3
	move.w	#$118,d2
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Numbers_2P,0,1),a3
	moveq	#0,d7
	move.w	(Ring_count).w,d7
	bsr.w	sub_40984
	tst.b	(Update_HUD_timer_2P).w
	bne.s	+
	tst.b	(Update_HUD_timer).w
	beq.s	+
	move.w	#$110,d3
	move.w	#$1B8,d2
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Numbers_2P,0,1),a3
	moveq	#0,d7
	move.b	(Loser_Time_Left).w,d7
	bsr.w	loc_40938
+
	moveq	#4,d1
	move.w	#$90,d3
	move.w	#$188,d2
	lea	(HUD_MapUnc_40BEA).l,a1
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Text_2P,0,1),a3
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	(DrawSprite_2P_Loop).l, JmpTo_DrawSprite_2P_Loop
	moveq	#0,d4
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_4092E:

	lea	(Hud_1).l,a4
	moveq	#0,d6
	bra.s	loc_40940
; ===========================================================================

loc_40938:

	lea	(Hud_10).l,a4
	moveq	#1,d6

loc_40940:

	moveq	#0,d1
	move.l	(a4)+,d4

loc_40944:
	sub.l	d4,d7
	bcs.s	loc_4094C
	addq.w	#1,d1
	bra.s	loc_40944
; ===========================================================================

loc_4094C:
	add.l	d4,d7
	lea	(HUD_MapUnc_40C82).l,a1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	(DrawSprite_2P_Loop).l, JmpTo_DrawSprite_2P_Loop
	addq.w	#8,d3
	dbf	d6,loc_40940
	rts
; End of function sub_4092E


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_4096A:

	moveq	#$A,d1
	lea	(HUD_MapUnc_40C82).l,a1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	(DrawSprite_2P_Loop).l, JmpTo_DrawSprite_2P_Loop
	addq.w	#8,d3
	rts
; End of function sub_4096A


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||


sub_40984:

	lea	(Hud_100).l,a4
	moveq	#2,d6

loc_4098C:
	moveq	#0,d1
	move.l	(a4)+,d4

loc_40990:
	sub.l	d4,d7
	bcs.s	loc_40998
	addq.w	#1,d1
	bra.s	loc_40990
; ===========================================================================

loc_40998:
	add.l	d4,d7
	tst.w	d6
	beq.s	loc_409AA
	tst.w	d1
	beq.s	loc_409A6
	bset	#$1F,d6

loc_409A6:
	tst.l	d6
	bpl.s	loc_409BE

loc_409AA:
	lea	(HUD_MapUnc_40C82).l,a1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	(DrawSprite_2P_Loop).l, JmpTo_DrawSprite_2P_Loop

loc_409BE:
	addq.w	#8,d3
	dbf	d6,loc_4098C
	rts
; End of function sub_40984

; ===========================================================================

BuildHUD_P2:
	tst.w	(Ring_count_2P).w
	beq.s	BuildHUD_P2_NoRings
	moveq	#0,d1
	btst	#3,(Timer_frames+1).w
	bne.s	+
	cmpi.b	#9,(Timer_minute_2P).w
	bne.s	+
	addq.w	#2,d1
+
	bra.s	BuildHUD_P2_Continued
; ===========================================================================
; loc_409E2:
BuildHUD_P2_NoRings:
	moveq	#0,d1
	btst	#3,(Timer_frames+1).w
	bne.s	BuildHUD_P2_Continued
	addq.w	#1,d1
	cmpi.b	#9,(Timer_minute_2P).w
	bne.s	BuildHUD_P2_Continued
	addq.w	#2,d1
; loc_409F8:
BuildHUD_P2_Continued:
	move.w	#$90,d3
	move.w	#$268,d2
	lea	(HUD_MapUnc_40BEA).l,a1
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Text_2P,0,1),a3
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	(DrawSprite_2P_Loop).l, JmpTo_DrawSprite_2P_Loop
	move.w	#$B8,d3
	move.w	#$1E8,d2
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Numbers_2P,0,1),a3
	moveq	#0,d7
	move.b	(Timer_minute_2P).w,d7
	bsr.w	sub_4092E
	bsr.w	sub_4096A
	moveq	#0,d7
	move.b	(Timer_second_2P).w,d7
	bsr.w	loc_40938
	move.w	#$C0,d3
	move.w	#$1F8,d2
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Numbers_2P,0,1),a3
	moveq	#0,d7
	move.w	(Ring_count_2P).w,d7
	bsr.w	sub_40984
	tst.b	(Update_HUD_timer).w
	bne.s	+
	tst.b	(Update_HUD_timer_2P).w
	beq.s	+
	move.w	#$110,d3
	move.w	#$298,d2
	movea.w	#make_art_tile_2p(ArtTile_Art_HUD_Numbers_2P,0,1),a3
	moveq	#0,d7
	move.b	(Loser_Time_Left).w,d7
	bsr.w	loc_40938
+
	moveq	#5,d1
	move.w	#$90,d3
	move.w	#$268,d2
	lea	(HUD_MapUnc_40BEA).l,a1
	movea.w	#make_art_tile_2p(ArtTile_ArtNem_Powerups,0,1),a3
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	jsrto	(DrawSprite_2P_Loop).l, JmpTo_DrawSprite_2P_Loop
	moveq	#0,d4
	rts
; ===========================================================================

; sprite mappings for the HUD
; uses the art in VRAM from $D940 - $FC00
HUD_MapUnc_40A9A:	BINCLUDE "mappings/sprite/hud_a.bin"


HUD_MapUnc_40BEA:	BINCLUDE "mappings/sprite/hud_b.bin"


HUD_MapUnc_40C82:	BINCLUDE "mappings/sprite/hud_c.bin"
