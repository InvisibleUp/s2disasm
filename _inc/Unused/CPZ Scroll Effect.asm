; ---------------------------------------------------------------------------
; Unused mystery function
; In CPZ, within a certain range of camera X coordinates spanning
; exactly 2 screens (a boss fight or cutscene?),
; once every 8 frames, make the entire screen refresh and do... SOMETHING...
; (in 2 separate 512-byte blocks of memory, move around a bunch of bytes)
; Maybe some abandoned scrolling effect?
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_40200:
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	beq.s	+
-	rts
; ===========================================================================
; this shifts all blocks of the chunks $EA-$ED and $FA-$FD one block to the
; left and the last block in each row (chunk $ED/$FD) to the beginning
; i.e. rotates the blocks to the left by one
+
	move.w	(Camera_X_pos).w,d0
	cmpi.w	#$1940,d0
	blo.s	-	; rts
	cmpi.w	#$1F80,d0
	bhs.s	-	; rts
	subq.b	#1,(CPZ_UnkScroll_Timer).w
	bpl.s	-	; rts	; do it every 8th frame
	move.b	#7,(CPZ_UnkScroll_Timer).w
	move.b	#1,(Screen_redraw_flag).w
	lea	(Chunk_Table+$7500).l,a1 ; chunks $EA-$ED, $FFFF7500 - $FFFF7700
	bsr.s	+
	lea	(Chunk_Table+$7D00).l,a1 ; chunks $FA-$FD, $FFFF7D00 - $FFFF7F00
+
	move.w	#7,d1

-	move.w	(a1),d0
    rept 3			; do this for 3 chunks
      rept 7
	move.w	2(a1),(a1)+	; shift 1st line of chunk by 1 block to the left (+3*14 bytes)
      endm
	move.w	$72(a1),(a1)+	; first block of next chunk to the left into previous chunk (+3*2 bytes)
	adda.w	#$70,a1		; go to next chunk (+336 bytes)
    endm
      rept 7			; now do it for the 4th chunk
	move.w	2(a1),(a1)+	; shift 1st line of chunk by 1 block to the left (+14 bytes)
      endm
	move.w	d0,(a1)+ 	; move 1st block of 1st chunk to last block of last chunk (+2 bytes, subsubtotal = 400 bytes)
	suba.w	#$180,a1 	; go to the next row in the first chunk (-384 bytes, subtotal = -16 bytes)
	dbf	d1,- 		; now do this again for rows 2-8 in these chunks
				; 400 + 7 * (-16) = 512 byte range was affected
	rts
; ===========================================================================

loc_402D4:
	cmpi.b	#hill_top_zone,(Current_Zone).w
	bne.s	+
	bsr.w	PatchHTZTiles
	move.b	#-1,(Anim_Counters+1).w
	move.w	#-1,(TempArray_LayerDef+$20).w
+
	cmpi.b	#chemical_plant_zone,(Current_Zone).w
	bne.s	+
	move.b	#-1,(Anim_Counters+1).w
+
	moveq	#0,d0
	move.b	(Current_Zone).w,d0
	add.w	d0,d0
	move.w	AnimPatMaps(pc,d0.w),d0
	lea	AnimPatMaps(pc,d0.w),a0
	tst.w	(Two_player_mode).w
	beq.s	+
	cmpi.b	#casino_night_zone,(Current_Zone).w
	bne.s	+
	lea	(APM_CNZ2P).l,a0
+
	tst.w	(a0)
	beq.s	+	; rts
	lea	(Block_Table).w,a1
	adda.w	(a0)+,a1
	move.w	(a0)+,d1
	tst.w	(Two_player_mode).w
	bne.s	LoadLevelBlocks_2P

; loc_40330:
LoadLevelBlocks:
	move.w	(a0)+,(a1)+	; copy blocks to RAM
	dbf	d1,LoadLevelBlocks	; loop using d1
+
	rts
; ===========================================================================
; loc_40338:
LoadLevelBlocks_2P:
	; There's a bug in here, where d1, the loop counter,
	; is overwritten with VRAM data
	move.w	(a0)+,d0
	move.w	d0,d1
	andi.w	#nontile_mask,d0	; d0 holds the preserved non-tile data
	andi.w	#tile_mask,d1		; d1 holds the tile index (overwrites loop counter!)
	lsr.w	#1,d1			; half tile index
	or.w	d1,d0			; put them back together
	move.w	d0,(a1)+
	dbf	d1,LoadLevelBlocks_2P	; loop using d1, which we just overwrote
	rts
; ===========================================================================
