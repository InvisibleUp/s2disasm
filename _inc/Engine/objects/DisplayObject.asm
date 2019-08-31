; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_164F4:
DisplaySprite:
	lea	(Sprite_Table_Input).w,a1
	move.w	priority(a0),d0
	lsr.w	#1,d0
	andi.w	#$380,d0
	adda.w	d0,a1
	cmpi.w	#$7E,(a1)
	bhs.s	return_16510
	addq.w	#2,(a1)
	adda.w	(a1),a1
	move.w	a0,(a1)

return_16510:
	rts
; End of function DisplaySprite

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a1 is the object RAM
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16512:
DisplaySprite2:
	lea	(Sprite_Table_Input).w,a2
	move.w	priority(a1),d0
	lsr.w	#1,d0
	andi.w	#$380,d0
	adda.w	d0,a2
	cmpi.w	#$7E,(a2)
	bhs.s	return_1652E
	addq.w	#2,(a2)
	adda.w	(a2),a2
	move.w	a1,(a2)

return_1652E:
	rts
; End of function DisplaySprite2

; ---------------------------------------------------------------------------
; Subroutine to display a sprite/object, when a0 is the object RAM
; and d0 is already (priority/2)&$380
; ---------------------------------------------------------------------------

; loc_16530:
DisplaySprite3:
	lea	(Sprite_Table_Input).w,a1
	adda.w	d0,a1
	cmpi.w	#$7E,(a1)
	bhs.s	return_16542
	addq.w	#2,(a1)
	adda.w	(a1),a1
	move.w	a0,(a1)

return_16542:
	rts

; ---------------------------------------------------------------------------
; Subroutine to animate a sprite using an animation script
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16544:
AnimateSprite:
	moveq	#0,d0
	move.b	anim(a0),d0		; move animation number to d0
	cmp.b	next_anim(a0),d0	; is animation set to change?
	beq.s	Anim_Run		; if not, branch
	move.b	d0,next_anim(a0)	; set next anim to current current
	move.b	#0,anim_frame(a0)	; reset animation
	move.b	#0,anim_frame_duration(a0)	; reset frame duration
; loc_16560:
Anim_Run:
	subq.b	#1,anim_frame_duration(a0)	; subtract 1 from frame duration
	bpl.s	Anim_Wait	; if time remains, branch
	add.w	d0,d0
	adda.w	(a1,d0.w),a1	; calculate address of appropriate animation script
	move.b	(a1),anim_frame_duration(a0)	; load frame duration
	moveq	#0,d1
	move.b	anim_frame(a0),d1	; load current frame number
	move.b	1(a1,d1.w),d0		; read sprite number from script
	bmi.s	Anim_End_FF		; if animation is complete, branch
; loc_1657C:
Anim_Next:
	andi.b	#$7F,d0			; clear sign bit
	move.b	d0,mapping_frame(a0)	; load sprite number
	move.b	status(a0),d1		;* match the orientaion dictated by the object
	andi.b	#3,d1			;* with the orientation used by the object engine
	andi.b	#$FC,render_flags(a0)	;*
	or.b	d1,render_flags(a0)	;*
	addq.b	#1,anim_frame(a0)	; next frame number
; return_1659A:
Anim_Wait:
	rts
; ===========================================================================
; loc_1659C:
Anim_End_FF:
	addq.b	#1,d0		; is the end flag = $FF ?
	bne.s	Anim_End_FE	; if not, branch
	move.b	#0,anim_frame(a0)	; restart the animation
	move.b	1(a1),d0	; read sprite number
	bra.s	Anim_Next
; ===========================================================================
; loc_165AC:
Anim_End_FE:
	addq.b	#1,d0	; is the end flag = $FE ?
	bne.s	Anim_End_FD	; if not, branch
	move.b	2(a1,d1.w),d0	; read the next byte in the script
	sub.b	d0,anim_frame(a0)	; jump back d0 bytes in the script
	sub.b	d0,d1
	move.b	1(a1,d1.w),d0	; read sprite number
	bra.s	Anim_Next
; ===========================================================================
; loc_165C0:
Anim_End_FD:
	addq.b	#1,d0		; is the end flag = $FD ?
	bne.s	Anim_End_FC	; if not, branch
	move.b	2(a1,d1.w),anim(a0)	; read next byte, run that animation
	rts
; ===========================================================================
; loc_165CC:
Anim_End_FC:
	addq.b	#1,d0	; is the end flag = $FC ?
	bne.s	Anim_End_FB	; if not, branch
	addq.b	#2,routine(a0)	; jump to next routine
	move.b	#0,anim_frame_duration(a0)
	addq.b	#1,anim_frame(a0)
	rts
; ===========================================================================
; loc_165E0:
Anim_End_FB:
	addq.b	#1,d0	; is the end flag = $FB ?
	bne.s	Anim_End_FA	; if not, branch
	move.b	#0,anim_frame(a0)	; reset animation
	clr.b	routine_secondary(a0)	; reset 2nd routine counter
	rts
; ===========================================================================
; loc_165F0:
Anim_End_FA:
	addq.b	#1,d0	; is the end flag = $FA ?
	bne.s	Anim_End_F9	; if not, branch
	addq.b	#2,routine_secondary(a0)	; jump to next routine
	rts
; ===========================================================================
; loc_165FA:
Anim_End_F9:
	addq.b	#1,d0	; is the end flag = $F9 ?
	bne.s	Anim_End	; if not, branch
	addq.b	#2,objoff_2A(a0)
; return_16602:
Anim_End:
	rts
; End of function AnimateSprite


; ---------------------------------------------------------------------------
; Subroutine to convert mappings (etc) to proper Megadrive sprites
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16604:
BuildSprites:
	tst.w	(Two_player_mode).w
	bne.w	BuildSprites_2P
	lea	(Sprite_Table).w,a2
	moveq	#0,d5
	moveq	#0,d4
	tst.b	(Level_started_flag).w
	beq.s	+
	jsrto	(BuildHUD).l, JmpTo_BuildHUD
	bsr.w	BuildRings
+
	lea	(Sprite_Table_Input).w,a4
	moveq	#7,d7	; 8 priority levels
; loc_16628:
BuildSprites_LevelLoop:
	tst.w	(a4)	; does this level have any objects?
	beq.w	BuildSprites_NextLevel	; if not, check the next one
	moveq	#2,d6
; loc_16630:
BuildSprites_ObjLoop:
	movea.w	(a4,d6.w),a0 ; a0=object

    if gameRevision=0
	; the additional check prevents a crash triggered by placing an object in debug mode while dead
	; unfortunately, the code it branches *to* causes a crash of its own
	tst.b	id(a0)			; is this object slot occupied?
	beq.w	BuildSprites_Unknown	; if not, branch
	tst.l	mappings(a0)		; does this object have any mappings?
	beq.w	BuildSprites_Unknown	; if not, branch
    else
	; REV01 uses a better branch, but removed the useful check
	tst.b	id(a0)			; is this object slot occupied?
	beq.w	BuildSprites_NextObj	; if not, check next one
    endif

	andi.b	#$7F,render_flags(a0)	; clear on-screen flag
	move.b	render_flags(a0),d0
	move.b	d0,d4
	btst	#6,d0	; is the multi-draw flag set?
	bne.w	BuildSprites_MultiDraw	; if it is, branch
	andi.w	#$C,d0	; is this to be positioned by screen coordinates?
	beq.s	BuildSprites_ScreenSpaceObj	; if it is, branch
	lea	(Camera_X_pos_copy).w,a1
	moveq	#0,d0
	move.b	width_pixels(a0),d0
	move.w	x_pos(a0),d3
	sub.w	(a1),d3
	move.w	d3,d1
	add.w	d0,d1	; is the object right edge to the left of the screen?
	bmi.w	BuildSprites_NextObj	; if it is, branch
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1	; is the object left edge to the right of the screen?
	bge.w	BuildSprites_NextObj	; if it is, branch
	addi.w	#128,d3
	btst	#4,d4		; is the accurate Y check flag set?
	beq.s	BuildSprites_ApproxYCheck	; if not, branch
	moveq	#0,d0
	move.b	y_radius(a0),d0
	move.w	y_pos(a0),d2
	sub.w	4(a1),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.s	BuildSprites_NextObj	; if the object is above the screen
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.s	BuildSprites_NextObj	; if the object is below the screen
	addi.w	#128,d2
	bra.s	BuildSprites_DrawSprite
; ===========================================================================
; loc_166A6:
BuildSprites_ScreenSpaceObj:
	move.w	y_pixel(a0),d2
	move.w	x_pixel(a0),d3
	bra.s	BuildSprites_DrawSprite
; ===========================================================================
; loc_166B0:
BuildSprites_ApproxYCheck:
	move.w	y_pos(a0),d2
	sub.w	4(a1),d2
	addi.w	#128,d2
	andi.w	#$7FF,d2
	cmpi.w	#-32+128,d2	; assume Y radius to be 32 pixels
	blo.s	BuildSprites_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_NextObj
; loc_166CC:
BuildSprites_DrawSprite:
	movea.l	mappings(a0),a1
	moveq	#0,d1
	btst	#5,d4	; is the static mappings flag set?
	bne.s	+	; if it is, branch
	move.b	mapping_frame(a0),d1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1	; get number of pieces
	bmi.s	++	; if there are 0 pieces, branch
+
	bsr.w	DrawSprite	; draw the sprite
+
	ori.b	#$80,render_flags(a0)	; set on-screen flag
; loc_166F2:
BuildSprites_NextObj:
	addq.w	#2,d6	; load next object
	subq.w	#2,(a4)	; decrement object count
	bne.w	BuildSprites_ObjLoop	; if there are objects left, repeat
; loc_166FA:
BuildSprites_NextLevel:
	lea	$80(a4),a4	; load next priority level
	dbf	d7,BuildSprites_LevelLoop	; loop
	move.b	d5,(Sprite_count).w
	cmpi.b	#80,d5	; was the sprite limit reached?
	beq.s	+	; if it was, branch
	move.l	#0,(a2)	; set link field to 0
	rts
+
	move.b	#0,-5(a2)	; set link field to 0
	rts
; ===========================================================================
    if gameRevision=0
BuildSprites_Unknown:
	; In the Simon Wai beta, this was a simple BranchTo, but later builds have this mystery line.
	; This may have possibly been a debugging function, for helping the devs detect when an object
	; tried to display with a blank ID or mappings pointer.
	; The latter was actually an issue that plagued Sonic 1, but is (almost) completely absent in this game.
	move.w	(1).w,d0	; causes a crash on hardware because of the word operation at an odd address
	bra.s	BuildSprites_NextObj
    endif
; loc_1671C:
BuildSprites_MultiDraw:
	move.l	a4,-(sp)
	lea	(Camera_X_pos).w,a4
	movea.w	art_tile(a0),a3
	movea.l	mappings(a0),a5
	moveq	#0,d0
	
	; check if object is within X bounds
	move.b	mainspr_width(a0),d0	; load pixel width
	move.w	x_pos(a0),d3
	sub.w	(a4),d3
	move.w	d3,d1
	add.w	d0,d1
	bmi.w	BuildSprites_MultiDraw_NextObj
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1
	bge.w	BuildSprites_MultiDraw_NextObj
	addi.w	#128,d3
	
	; check if object is within Y bounds
	btst	#4,d4
	beq.s	+
	moveq	#0,d0
	move.b	mainspr_height(a0),d0	; load pixel height
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.w	BuildSprites_MultiDraw_NextObj
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.w	BuildSprites_MultiDraw_NextObj
	addi.w	#128,d2
	bra.s	++
+
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	addi.w	#128,d2
	andi.w	#$7FF,d2
	cmpi.w	#-32+128,d2
	blo.s	BuildSprites_MultiDraw_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_MultiDraw_NextObj
+
	moveq	#0,d1
	move.b	mainspr_mapframe(a0),d1	; get current frame
	beq.s	+
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite	; draw the sprite
	move.w	(sp)+,d4
+
	ori.b	#$80,render_flags(a0)	; set onscreen flag
	lea	sub2_x_pos(a0),a6
	moveq	#0,d0
	move.b	mainspr_childsprites(a0),d0	; get child sprite count
	subq.w	#1,d0		; if there are 0, go to next object
	bcs.s	BuildSprites_MultiDraw_NextObj

-	swap	d0
	move.w	(a6)+,d3	; get X pos
	sub.w	(a4),d3
	addi.w	#128,d3
	move.w	(a6)+,d2	; get Y pos
	sub.w	4(a4),d2
	addi.w	#128,d2
	andi.w	#$7FF,d2
	addq.w	#1,a6
	moveq	#0,d1
	move.b	(a6)+,d1	; get mapping frame
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite
	move.w	(sp)+,d4
+
	swap	d0
	dbf	d0,-	; repeat for number of child sprites
; loc_16804:
BuildSprites_MultiDraw_NextObj:
	movea.l	(sp)+,a4
	bra.w	BuildSprites_NextObj
; End of function BuildSprites


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1680A:
ChkDrawSprite:
	cmpi.b	#80,d5		; has the sprite limit been reached?
	blo.s	DrawSprite_Cont	; if it hasn't, branch
	rts	; otherwise, return
; End of function ChkDrawSprite


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16812:
DrawSprite:
	movea.w	art_tile(a0),a3
	cmpi.b	#80,d5
	bhs.s	DrawSprite_Done
; loc_1681C:
DrawSprite_Cont:
	btst	#0,d4	; is the sprite to be X-flipped?
	bne.s	DrawSprite_FlipX	; if it is, branch
	btst	#1,d4	; is the sprite to be Y-flipped?
	bne.w	DrawSprite_FlipY	; if it is, branch
; loc__1682A:
DrawSprite_Loop:
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+	; set Y pos
	move.b	(a1)+,(a2)+	; set sprite size
	addq.b	#1,d5
	move.b	d5,(a2)+	; set link field
	move.w	(a1)+,d0
	add.w	a3,d0
	move.w	d0,(a2)+	; set art tile and flags
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0	; avoid activating sprite masking
+
	move.w	d0,(a2)+	; set X pos
	dbf	d1,DrawSprite_Loop	; repeat for next sprite
; return_16852:
DrawSprite_Done:
	rts
; ===========================================================================
; loc_16854:
DrawSprite_FlipX:
	btst	#1,d4	; is it to be Y-flipped as well?
	bne.w	DrawSprite_FlipXY	; if it is, branch

-	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4	; store size for later use
	move.b	d4,(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$800,d0	; toggle X flip flag
	move.w	d0,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	neg.w	d0	; negate X offset
	move.b	CellOffsets_XFlip(pc,d4.w),d4
	sub.w	d4,d0	; subtract sprite size
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,-

	rts
; ===========================================================================
; offsets for horizontally mirrored sprite pieces
CellOffsets_XFlip:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16
; offsets for vertically mirrored sprite pieces
CellOffsets_YFlip:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================
; loc_168B4:
DrawSprite_FlipY:
	move.b	(a1)+,d0
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	move.b	CellOffsets_YFlip(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d2,d0
	move.w	d0,(a2)+	; set Y pos
	move.b	(a1)+,(a2)+	; set size
	addq.b	#1,d5
	move.b	d5,(a2)+	; set link field
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$1000,d0	; toggle Y flip flag
	move.w	d0,(a2)+	; set art tile and flags
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+	; set X pos
	dbf	d1,DrawSprite_FlipY
	rts
; ===========================================================================
; offsets for vertically mirrored sprite pieces
CellOffsets_YFlip2:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================
; loc_168FC:
DrawSprite_FlipXY:
	move.b	(a1)+,d0
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	move.b	CellOffsets_YFlip2(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4
	move.b	d4,(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$1800,d0	; toggle X and Y flip flags
	move.w	d0,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	neg.w	d0
	move.b	CellOffsets_XFlip2(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,DrawSprite_FlipXY
	rts
; End of function DrawSprite

; ===========================================================================
; offsets for horizontally mirrored sprite pieces
CellOffsets_XFlip2:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16
; ===========================================================================

; ---------------------------------------------------------------------------
; Subroutine to convert mappings (etc) to proper Megadrive sprites
; for 2-player (split screen) mode
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; loc_1694E:
BuildSprites_2P:
	lea	(Sprite_Table).w,a2
	moveq	#2,d5
	moveq	#0,d4
	move.l	#$1D80F01,(a2)+	; mask all sprites
	move.l	#1,(a2)+
	move.l	#$1D80F02,(a2)+	; from 216px to 248px
	move.l	#0,(a2)+
	tst.b	(Level_started_flag).w
	beq.s	+
	jsrto	(BuildHUD_P1).l, JmpTo_BuildHUD_P1
	bsr.w	BuildRings_P1
+
	lea	(Sprite_Table_Input).w,a4
	moveq	#7,d7
; loc_16982:
BuildSprites_P1_LevelLoop:
	move.w	(a4),d0	; does this priority level have any objects?
	beq.w	BuildSprites_P1_NextLevel	; if not, check next one
	move.w	d0,-(sp)
	moveq	#2,d6
; loc_1698C:
BuildSprites_P1_ObjLoop:
	movea.w	(a4,d6.w),a0 ; a0=object
	tst.b	id(a0)
	beq.w	BuildSprites_P1_NextObj
	andi.b	#$7F,render_flags(a0)
	move.b	render_flags(a0),d0
	move.b	d0,d4
	btst	#6,d0
	bne.w	BuildSprites_P1_MultiDraw
	andi.w	#$C,d0
	beq.s	BuildSprites_P1_ScreenSpaceObj
	lea	(Camera_X_pos).w,a1
	moveq	#0,d0
	move.b	width_pixels(a0),d0
	move.w	x_pos(a0),d3
	sub.w	(a1),d3
	move.w	d3,d1
	add.w	d0,d1
	bmi.w	BuildSprites_P1_NextObj
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1
	bge.s	BuildSprites_P1_NextObj
	addi.w	#128,d3
	btst	#4,d4
	beq.s	BuildSprites_P1_ApproxYCheck
	moveq	#0,d0
	move.b	y_radius(a0),d0
	move.w	y_pos(a0),d2
	sub.w	4(a1),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.s	BuildSprites_P1_NextObj
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.s	BuildSprites_P1_NextObj
	addi.w	#256,d2
	bra.s	BuildSprites_P1_DrawSprite
; ===========================================================================
; loc_16A00:
BuildSprites_P1_ScreenSpaceObj:
	move.w	y_pixel(a0),d2
	move.w	x_pixel(a0),d3
	addi.w	#128,d2
	bra.s	BuildSprites_P1_DrawSprite
; ===========================================================================
; loc_16A0E:
BuildSprites_P1_ApproxYCheck:
	move.w	y_pos(a0),d2
	sub.w	4(a1),d2
	addi.w	#128,d2
	cmpi.w	#-32+128,d2
	blo.s	BuildSprites_P1_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_P1_NextObj
	addi.w	#128,d2
; loc_16A2A:
BuildSprites_P1_DrawSprite:
	movea.l	mappings(a0),a1
	moveq	#0,d1
	btst	#5,d4
	bne.s	+
	move.b	mapping_frame(a0),d1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	++
+
	bsr.w	DrawSprite_2P
+
	ori.b	#$80,render_flags(a0)
; loc_16A50:
BuildSprites_P1_NextObj:
	addq.w	#2,d6
	subq.w	#2,(sp)
	bne.w	BuildSprites_P1_ObjLoop
	addq.w	#2,sp
; loc_16A5A:
BuildSprites_P1_NextLevel:
	lea	$80(a4),a4
	dbf	d7,BuildSprites_P1_LevelLoop
	move.b	d5,(Sprite_count).w
	cmpi.b	#80,d5
	bhs.s	+
	move.l	#0,(a2)
	bra.s	BuildSprites_P2
+
	move.b	#0,-5(a2)

; build sprites for player 2

; loc_16A7A:
BuildSprites_P2:
	tst.w	(Hint_flag).w	; has H-int occured yet?
	bne.s	BuildSprites_P2	; if not, wait
	lea	(Sprite_Table_2).w,a2
	moveq	#0,d5
	moveq	#0,d4
	tst.b	(Level_started_flag).w
	beq.s	+
	jsrto	(BuildHUD_P2).l, JmpTo_BuildHUD_P2
	bsr.w	BuildRings_P2
+
	lea	(Sprite_Table_Input).w,a4
	moveq	#7,d7
; loc_16A9C:
BuildSprites_P2_LevelLoop:
	move.w	(a4),d0
	beq.w	BuildSprites_P2_NextLevel
	move.w	d0,-(sp)
	moveq	#2,d6
; loc_16AA6:
BuildSprites_P2_ObjLoop:
	movea.w	(a4,d6.w),a0 ; a0=object
	tst.b	id(a0)
	beq.w	BuildSprites_P2_NextObj
	move.b	render_flags(a0),d0
	move.b	d0,d4
	btst	#6,d0
	bne.w	BuildSprites_P2_MultiDraw
	andi.w	#$C,d0
	beq.s	BuildSprites_P2_ScreenSpaceObj
	lea	(Camera_X_pos_P2).w,a1
	moveq	#0,d0
	move.b	width_pixels(a0),d0
	move.w	x_pos(a0),d3
	sub.w	(a1),d3
	move.w	d3,d1
	add.w	d0,d1
	bmi.w	BuildSprites_P2_NextObj
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1
	bge.s	BuildSprites_P2_NextObj
	addi.w	#128,d3
	btst	#4,d4
	beq.s	BuildSprites_P2_ApproxYCheck
	moveq	#0,d0
	move.b	y_radius(a0),d0
	move.w	y_pos(a0),d2
	sub.w	4(a1),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.s	BuildSprites_P2_NextObj
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.s	BuildSprites_P2_NextObj
	addi.w	#256+224,d2
	bra.s	BuildSprites_P2_DrawSprite
; ===========================================================================
; loc_16B14:
BuildSprites_P2_ScreenSpaceObj:
	move.w	y_pixel(a0),d2
	move.w	x_pixel(a0),d3
	addi.w	#$160,d2
	bra.s	BuildSprites_P2_DrawSprite
; ===========================================================================
; loc_16B22:
BuildSprites_P2_ApproxYCheck:
	move.w	y_pos(a0),d2
	sub.w	4(a1),d2
	addi.w	#128,d2
	cmpi.w	#-32+128,d2
	blo.s	BuildSprites_P2_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_P2_NextObj
	addi.w	#128+224,d2
; loc_16B3E:
BuildSprites_P2_DrawSprite:
	movea.l	mappings(a0),a1
	moveq	#0,d1
	btst	#5,d4
	bne.s	+
	move.b	mapping_frame(a0),d1
	add.w	d1,d1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	++
+
	bsr.w	DrawSprite_2P
+
	ori.b	#$80,render_flags(a0)
; loc_16B64:
BuildSprites_P2_NextObj:
	addq.w	#2,d6
	subq.w	#2,(sp)
	bne.w	BuildSprites_P2_ObjLoop
	addq.w	#2,sp
	tst.b	(Teleport_flag).w
	bne.s	BuildSprites_P2_NextLevel
	move.w	#0,(a4)
; loc_16B78:
BuildSprites_P2_NextLevel:
	lea	$80(a4),a4
	dbf	d7,BuildSprites_P2_LevelLoop
	move.b	d5,(Sprite_count).w
	cmpi.b	#80,d5
	beq.s	+
	move.l	#0,(a2)
	rts
+
	move.b	#0,-5(a2)
	rts
; ===========================================================================
; loc_16B9A:
BuildSprites_P1_MultiDraw:
	move.l	a4,-(sp)
	lea	(Camera_X_pos).w,a4
	movea.w	art_tile(a0),a3
	movea.l	mappings(a0),a5
	moveq	#0,d0
	move.b	mainspr_width(a0),d0
	move.w	x_pos(a0),d3
	sub.w	(a4),d3
	move.w	d3,d1
	add.w	d0,d1
	bmi.w	BuildSprites_P1_MultiDraw_NextObj
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1
	bge.w	BuildSprites_P1_MultiDraw_NextObj
	addi.w	#128,d3
	btst	#4,d4
	beq.s	+
	moveq	#0,d0
	move.b	mainspr_height(a0),d0
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.w	BuildSprites_P1_MultiDraw_NextObj
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.w	BuildSprites_P1_MultiDraw_NextObj
	addi.w	#256,d2
	bra.s	++
+
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	addi.w	#128,d2
	cmpi.w	#-32+128,d2
	blo.s	BuildSprites_P1_MultiDraw_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_P1_MultiDraw_NextObj
	addi.w	#128,d2
+
	moveq	#0,d1
	move.b	mainspr_mapframe(a0),d1
	beq.s	+
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite_2P
	move.w	(sp)+,d4
+
	ori.b	#$80,render_flags(a0)
	lea	sub2_x_pos(a0),a6
	moveq	#0,d0
	move.b	mainspr_childsprites(a0),d0
	subq.w	#1,d0
	bcs.s	BuildSprites_P1_MultiDraw_NextObj

-	swap	d0
	move.w	(a6)+,d3
	sub.w	(a4),d3
	addi.w	#128,d3
	move.w	(a6)+,d2
	sub.w	4(a4),d2
	addi.w	#256,d2
	addq.w	#1,a6
	moveq	#0,d1
	move.b	(a6)+,d1
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite_2P
	move.w	(sp)+,d4
+
	swap	d0
	dbf	d0,-
; loc_16C7E:
BuildSprites_P1_MultiDraw_NextObj:
	movea.l	(sp)+,a4
	bra.w	BuildSprites_P1_NextObj
; ===========================================================================
; loc_16C84:
BuildSprites_P2_MultiDraw:
	move.l	a4,-(sp)
	lea	(Camera_X_pos_P2).w,a4
	movea.w	art_tile(a0),a3
	movea.l	mappings(a0),a5
	moveq	#0,d0
	move.b	mainspr_width(a0),d0
	move.w	x_pos(a0),d3
	sub.w	(a4),d3
	move.w	d3,d1
	add.w	d0,d1
	bmi.w	BuildSprites_P2_MultiDraw_NextObj
	move.w	d3,d1
	sub.w	d0,d1
	cmpi.w	#320,d1
	bge.w	BuildSprites_P2_MultiDraw_NextObj
	addi.w	#128,d3
	btst	#4,d4
	beq.s	+
	moveq	#0,d0
	move.b	mainspr_height(a0),d0
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	move.w	d2,d1
	add.w	d0,d1
	bmi.w	BuildSprites_P2_MultiDraw_NextObj
	move.w	d2,d1
	sub.w	d0,d1
	cmpi.w	#224,d1
	bge.w	BuildSprites_P2_MultiDraw_NextObj
	addi.w	#256+224,d2
	bra.s	++
+
	move.w	y_pos(a0),d2
	sub.w	4(a4),d2
	addi.w	#128,d2
	cmpi.w	#-32+128,d2
	blo.s	BuildSprites_P2_MultiDraw_NextObj
	cmpi.w	#32+128+224,d2
	bhs.s	BuildSprites_P2_MultiDraw_NextObj
	addi.w	#128+224,d2
+
	moveq	#0,d1
	move.b	mainspr_mapframe(a0),d1
	beq.s	+
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite_2P
	move.w	(sp)+,d4
+
	ori.b	#$80,render_flags(a0)
	lea	sub2_x_pos(a0),a6
	moveq	#0,d0
	move.b	mainspr_childsprites(a0),d0
	subq.w	#1,d0
	bcs.s	BuildSprites_P2_MultiDraw_NextObj

-	swap	d0
	move.w	(a6)+,d3
	sub.w	(a4),d3
	addi.w	#128,d3
	move.w	(a6)+,d2
	sub.w	4(a4),d2
	addi.w	#256+224,d2
	addq.w	#1,a6
	moveq	#0,d1
	move.b	(a6)+,d1
	add.w	d1,d1
	movea.l	a5,a1
	adda.w	(a1,d1.w),a1
	move.w	(a1)+,d1
	subq.w	#1,d1
	bmi.s	+
	move.w	d4,-(sp)
	bsr.w	ChkDrawSprite_2P
	move.w	(sp)+,d4
+
	swap	d0
	dbf	d0,-
; loc_16D68:
BuildSprites_P2_MultiDraw_NextObj:
	movea.l	(sp)+,a4
	bra.w	BuildSprites_P2_NextObj

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; adjust art pointer of object at a0 for 2-player mode
; sub_16D6E:
Adjust2PArtPointer:
	tst.w	(Two_player_mode).w
	beq.s	+ ; rts
	move.w	art_tile(a0),d0
	andi.w	#tile_mask,d0
	lsr.w	#1,d0
	andi.w	#nontile_mask,art_tile(a0)
	add.w	d0,art_tile(a0)
+
	rts
; End of function Adjust2PArtPointer


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; adjust art pointer of object at a1 for 2-player mode
; sub_16D8A:
Adjust2PArtPointer2:
	tst.w	(Two_player_mode).w
	beq.s	+ ; rts
	move.w	art_tile(a1),d0
	andi.w	#tile_mask,d0
	lsr.w	#1,d0
	andi.w	#nontile_mask,art_tile(a1)
	add.w	d0,art_tile(a1)
+
	rts
; End of function Adjust2PArtPointer2


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_16DA6:
ChkDrawSprite_2P:
	cmpi.b	#80,d5
	blo.s	DrawSprite_2P_Loop
	rts
; End of function ChkDrawSprite_2P


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; copy sprite art to VRAM, in 2-player mode

; sub_16DAE:
DrawSprite_2P:
	movea.w	art_tile(a0),a3
	cmpi.b	#80,d5
	bhs.s	DrawSprite_2P_Done
	btst	#0,d4
	bne.s	DrawSprite_2P_FlipX
	btst	#1,d4
	bne.w	DrawSprite_2P_FlipY
; loc_16DC6:
DrawSprite_2P_Loop:
	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4
	move.b	SpriteSizes_2P(pc,d4.w),(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	a3,d0
	move.w	d0,(a2)+
	move.w	(a1)+,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,DrawSprite_2P_Loop
; return_16DF2:
DrawSprite_2P_Done:
	rts
; ===========================================================================
; cells are double the height in 2P mode, so halve the number of rows

;byte_16DF4:
SpriteSizes_2P:
	dc.b   0,0
	dc.b   1,1
	dc.b   4,4
	dc.b   5,5
	dc.b   8,8
	dc.b   9,9
	dc.b  $C,$C
	dc.b  $D,$D
; ===========================================================================
; loc_16E04:
DrawSprite_2P_FlipX:
	btst	#1,d4
	bne.w	DrawSprite_2P_FlipXY

-	move.b	(a1)+,d0
	ext.w	d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4
	move.b	SpriteSizes_2P(pc,d4.w),(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$800,d0
	move.w	d0,(a2)+
	move.w	(a1)+,d0
	neg.w	d0
	move.b	byte_16E46(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,-

	rts
; ===========================================================================
; offsets for horizontally mirrored sprite pieces (2P)
byte_16E46:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16
; offsets for vertically mirrored sprite pieces (2P)
byte_16E56:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================
; loc_16E66:
DrawSprite_2P_FlipY:
	move.b	(a1)+,d0
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	move.b	byte_16E56(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4
	move.b	SpriteSizes_2P_2(pc,d4.w),(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$1000,d0
	move.w	d0,(a2)+
	move.w	(a1)+,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,DrawSprite_2P_FlipY
	rts
; ===========================================================================
; cells are double the height in 2P mode, so halve the number of rows

; byte_16EA2:
SpriteSizes_2P_2:
	dc.b   0,0
	dc.b   1,1	; 2
	dc.b   4,4	; 4
	dc.b   5,5	; 6
	dc.b   8,8	; 8
	dc.b   9,9	; 10
	dc.b  $C,$C	; 12
	dc.b  $D,$D	; 14
; offsets for vertically mirrored sprite pieces (2P)
byte_16EB2:
	dc.b   8,$10,$18,$20	; 4
	dc.b   8,$10,$18,$20	; 8
	dc.b   8,$10,$18,$20	; 12
	dc.b   8,$10,$18,$20	; 16
; ===========================================================================
; loc_16EC2:
DrawSprite_2P_FlipXY:
	move.b	(a1)+,d0
	move.b	(a1),d4
	ext.w	d0
	neg.w	d0
	move.b	byte_16EB2(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d2,d0
	move.w	d0,(a2)+
	move.b	(a1)+,d4
	move.b	SpriteSizes_2P_2(pc,d4.w),(a2)+
	addq.b	#1,d5
	move.b	d5,(a2)+
	addq.w	#2,a1
	move.w	(a1)+,d0
	add.w	a3,d0
	eori.w	#$1800,d0
	move.w	d0,(a2)+
	move.w	(a1)+,d0
	neg.w	d0
	move.b	byte_16F06(pc,d4.w),d4
	sub.w	d4,d0
	add.w	d3,d0
	andi.w	#$1FF,d0
	bne.s	+
	addq.w	#1,d0
+
	move.w	d0,(a2)+
	dbf	d1,DrawSprite_2P_FlipXY
	rts
; End of function DrawSprite_2P

; ===========================================================================
; offsets for horizontally mirrored sprite pieces (2P)
byte_16F06:
	dc.b   8,  8,  8,  8	; 4
	dc.b $10,$10,$10,$10	; 8
	dc.b $18,$18,$18,$18	; 12
	dc.b $20,$20,$20,$20	; 16

; ===========================================================================
; loc_16F16: ; unused/dead code? ; a0=object
	move.w	x_pos(a0),d0
	sub.w	(Camera_X_pos).w,d0
	bmi.s	+
	cmpi.w	#320,d0
	bge.s	+
	move.w	y_pos(a0),d1
	sub.w	(Camera_Y_pos).w,d1
	bmi.s	+
	cmpi.w	#$E0,d1
	bge.s	+
	moveq	#0,d0
	rts
+	moveq	#1,d0
	rts
; ===========================================================================
; loc_16F3E: ; unused/dead code? ; a0=object
	moveq	#0,d1
	move.b	width_pixels(a0),d1
	move.w	x_pos(a0),d0
	sub.w	(Camera_X_pos).w,d0
	add.w	d1,d0
	bmi.s	+
	add.w	d1,d1
	sub.w	d1,d0
	cmpi.w	#320,d0
	bge.s	+
	move.w	y_pos(a0),d1
	sub.w	(Camera_Y_pos).w,d1
	bmi.s	+
	cmpi.w	#$E0,d1
	bge.s	+
	moveq	#0,d0
	rts
+	moveq	#1,d0
	rts
; ===========================================================================

    if gameRevision=1
	nop
    endif

    if ~~removeJmpTos
JmpTo_BuildHUD 
	jmp	(BuildHUD).l
JmpTo_BuildHUD_P1 
	jmp	(BuildHUD_P1).l
JmpTo_BuildHUD_P2 
	jmp	(BuildHUD_P2).l

	align 4
    endif
