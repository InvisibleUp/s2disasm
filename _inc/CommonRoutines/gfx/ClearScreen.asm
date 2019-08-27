; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_1208:
ClearScreen:
	stopZ80

	dmaFillVRAM 0,$0000,$40		; Fill first $40 bytes of VRAM with 0
	dmaFillVRAM 0,VRAM_Plane_A_Name_Table,VRAM_Plane_Table_Size	; Clear Plane A pattern name table
	dmaFillVRAM 0,VRAM_Plane_B_Name_Table,VRAM_Plane_Table_Size	; Clear Plane B pattern name table

	tst.w	(Two_player_mode).w
	beq.s	+

	dmaFillVRAM 0,VRAM_Plane_A_Name_Table_2P,VRAM_Plane_Table_Size
+
	clr.l	(Vscroll_Factor).w
	clr.l	(unk_F61A).w

	; Bug: These '+4's shouldn't be here; clearRAM accidentally clears an additional 4 bytes
	clearRAM Sprite_Table,Sprite_Table_End+4
	clearRAM Horiz_Scroll_Buf,Horiz_Scroll_Buf_End+4

	startZ80
	rts
; End of function ClearScreen