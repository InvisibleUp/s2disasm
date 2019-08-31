; ----------------------------------------------------------------------------
; Object 0F - Title screen menu
; ----------------------------------------------------------------------------
; Sprite_13600:
Obj0F:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj0F_Index(pc,d0.w),d1
	jsr	Obj0F_Index(pc,d1.w)
	bra.w	DisplaySprite
; ===========================================================================
; off_13612: Obj0F_States:
Obj0F_Index:	offsetTable
		offsetTableEntry.w Obj0F_Init	; 0
		offsetTableEntry.w Obj0F_Main	; 2
; ===========================================================================
; loc_13616:
Obj0F_Init:
	addq.b	#2,routine(a0) ; => Obj0F_Main
	move.w	#$128,x_pixel(a0)
	move.w	#$14C,y_pixel(a0)
	move.l	#Obj0F_MapUnc_13B70,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtKos_LevelArt,0,0),art_tile(a0)
	bsr.w	Adjust2PArtPointer
	andi.b	#1,(Title_screen_option).w
	move.b	(Title_screen_option).w,mapping_frame(a0)

; loc_13644:
Obj0F_Main:
	moveq	#0,d2
	move.b	(Title_screen_option).w,d2
	move.b	(Ctrl_1_Press).w,d0
	or.b	(Ctrl_2_Press).w,d0
	btst	#button_up,d0
	beq.s	+
	subq.b	#1,d2
	bcc.s	+
	move.b	#2,d2
+
	btst	#button_down,d0
	beq.s	+
	addq.b	#1,d2
	cmpi.b	#3,d2
	blo.s	+
	moveq	#0,d2
+
	move.b	d2,mapping_frame(a0)
	move.b	d2,(Title_screen_option).w
	andi.b	#button_up_mask|button_down_mask,d0
	beq.s	+	; rts
	moveq	#SndID_Blip,d0 ; selection blip sound
	jsrto	(PlaySound).l, JmpTo4_PlaySound
+
	rts
; ===========================================================================
; animation script
; off_13686:
Ani_obj0E:	offsetTable
		offsetTableEntry.w byte_1368E	; 0
		offsetTableEntry.w byte_13694	; 1
		offsetTableEntry.w byte_1369C	; 2
		offsetTableEntry.w byte_136A4	; 3
byte_1368E:
	dc.b   1
	dc.b   5	; 1
	dc.b   6	; 2
	dc.b   7	; 3
	dc.b   8	; 4
	dc.b $FA	; 5
	even
byte_13694:
	dc.b   1
	dc.b   0	; 1
	dc.b   1	; 2
	dc.b   2	; 3
	dc.b   3	; 4
	dc.b   4	; 5
	dc.b $FA	; 6
	even
byte_1369C:
	dc.b   1
	dc.b  $C	; 1
	dc.b  $D	; 2
	dc.b  $E	; 3
	dc.b  $D	; 4
	dc.b  $C	; 5
	dc.b $FA	; 6
	even
byte_136A4:
	dc.b   3
	dc.b  $C	; 1
	dc.b  $F	; 2
	dc.b $FF	; 3
	even
; -----------------------------------------------------------------------------
; Sprite Mappings - Flashing stars from intro (Obj0E)
; -----------------------------------------------------------------------------
Obj0E_MapUnc_136A8:	BINCLUDE "mappings/sprite/obj0E.bin"
; -----------------------------------------------------------------------------
; sprite mappings
; -----------------------------------------------------------------------------
Obj0F_MapUnc_13B70:	BINCLUDE "mappings/sprite/obj0F.bin"

    if ~~removeJmpTos
JmpTo4_PlaySound 
	jmp	(PlaySound).l
JmpTo4_PlayMusic 
	jmp	(PlayMusic).l

	align 4
    endif