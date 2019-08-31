; ---------------------------------------------------------------------------
; The subroutine appears to convert the collision array from an unknown
; 'raw' format to its current format, and write it to ROM, overwritting
; the original. This doesn't work on standard read-only cartridges, and
; would instead require a special dev cartridge.
; This subroutine exists in Sonic 1 as well, but was oddly changed in
; the S2 Nick Arcade prototype to just handle loading GHZ's collision
; instead (though it too is dummied out, hence collision being broken).
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; return_1EAF0: FloorLog_Unk:
ConvertCollisionArray:
	rts
; ---------------------------------------------------------------------------
	lea	(ColArray).l,a1	; Source location of 'raw' collision array
	lea	(ColArray).l,a2	; Destinatation of converted collision array (overwrites the original)

	move.w	#$100-1,d3	; Number of blocks in collision array
.blockLoop:
	moveq	#16,d5		; Start on the 16th bit (the leftmost pixel)

	move.w	#16-1,d2	; Width of a block in pixels
.columnLoop:
	moveq	#0,d4

	; It seems the 'raw' format stored the collision of each pixel in rows.
	; This block of code changes it from rows to columns, so each word contains
	; a bit for each pixel in a column.
	move.w	#16-1,d1	; Height of a block in pixels
.rowLoop:
	move.w	(a1)+,d0	; Get row of collision bits
	lsr.l	d5,d0		; Push the selected bit of this row into the 'eXtend' flag
	addx.w	d4,d4		; Shift d4 to the left, and insert the selected bit into bit 0
	dbf	d1,.rowLoop	; Loop for each row of pixels in a block

	move.w	d4,(a2)+	; Store column of collision bits
	suba.w	#2*16,a1	; Back to the start of the block
	subq.w	#1,d5		; Get next bit in the row
	dbf	d2,.columnLoop	; Loop for each column of pixels in a block

	adda.w	#2*16,a1	; Next block
	dbf	d3,.blockLoop	; Loop for each block in the collision array

	lea	(ColArray).l,a1
	lea	(ColArray2).l,a2	; Write converted collision array to location of rotated collison array
	bsr.s	.convertArrayToStandardFormat
	lea	(ColArray).l,a1
	lea	(ColArray).l,a2		; Write converted collision array to location of normal collison array

; loc_1EB46: FloorLog_Unk2:
.convertArrayToStandardFormat:
	move.w	#$1000-1,d3	; Size of the collision array

.processCollisionArrayLoop:
	moveq	#0,d2
	move.w	#$F,d1
	move.w	(a1)+,d0	; Get current column of collision pixels
	beq.s	.noCollision	; Branch if there's no collision in this column
	bmi.s	.topPixelSolid	; Branch if top pixel of collision is solid

	; Here we count, starting from the bottom, how many pixels tall
	; the collision in this column is.
.processColumnLoop1:
	lsr.w	#1,d0
	bcc.s	.pixelNotSolid1
	addq.b	#1,d2
.pixelNotSolid1:
	dbf	d1,.processColumnLoop1

	bra.s	.columnProcessed
; ===========================================================================
.topPixelSolid:
	cmpi.w	#$FFFF,d0		; Is entire column solid?
	beq.s	.entireColumnSolid	; Branch if so

	; Here we count, starting from the top, how many pixels tall
	; the collision in this column is (the resulting number is negative).
.processColumnLoop2:
	lsl.w	#1,d0
	bcc.s	.pixelNotSolid2
	subq.b	#1,d2
.pixelNotSolid2:
	dbf	d1,.processColumnLoop2

	bra.s	.columnProcessed
; ===========================================================================
.entireColumnSolid:
	move.w	#16,d0

; loc_1EB78:
.noCollision:
	move.w	d0,d2

; loc_1EB7A:
.columnProcessed:
	move.b	d2,(a2)+	; Store column collision height to ROM
	dbf	d3,.processCollisionArrayLoop

	rts

; End of function ConvertCollisionArray

    if gameRevision<2
	nop
    endif
