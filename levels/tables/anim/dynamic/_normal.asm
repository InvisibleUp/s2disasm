Dynamic_Normal:
	lea	(Anim_Counters).w,a3

loc_3FF30:
	move.w	(a2)+,d6	; Get number of scripts in list
	; S&K checks for empty lists, here
;	bpl.s	.listnotempty	; If there are any, continue
;	rts
;.listnotempty:

; loc_3FF32:
.loop:
	subq.b	#1,(a3)		; Tick down frame duration
	bcc.s	.nextscript	; If frame isn't over, move on to next script

;.nextframe:
	moveq	#0,d0
	move.b	1(a3),d0	; Get current frame
	cmp.b	6(a2),d0	; Have we processed the last frame in the script?
	blo.s	.notlastframe
	moveq	#0,d0		; If so, reset to first frame
	move.b	d0,1(a3)	; ''
; loc_3FF48:
.notlastframe:
	addq.b	#1,1(a3)	; Consider this frame processed; set counter to next frame
	move.b	(a2),(a3)	; Set frame duration to global duration value
	bpl.s	.globalduration
	; If script uses per-frame durations, use those instead
	add.w	d0,d0
	move.b	9(a2,d0.w),(a3)	; Set frame duration to current frame's duration value
; loc_3FF56:
.globalduration:
; Prepare for DMA transfer
	; Get relative address of frame's art
	move.b	8(a2,d0.w),d0	; Get tile ID
	lsl.w	#5,d0		; Turn it into an offset
	; Get VRAM destination address
	move.w	4(a2),d2
	; Get ROM source address
	move.l	(a2),d1		; Get start address of animated tile art
	andi.l	#$FFFFFF,d1
	add.l	d0,d1		; Offset into art, to get the address of new frame
	; Get size of art to be transferred 
	moveq	#0,d3
	move.b	7(a2),d3
	lsl.w	#4,d3		; Turn it into actual size (in words)
	; Use d1, d2 and d3 to queue art for transfer
	jsr	(QueueDMATransfer).l
; loc_3FF78:
.nextscript:
	move.b	6(a2),d0	; Get total size of frame data
	tst.b	(a2)		; Is per-frame duration data present?
	bpl.s	.globalduration2; If not, keep the current size; it's correct
	add.b	d0,d0		; Double size to account for the additional frame duration data
; loc_3FF82:
.globalduration2:
	addq.b	#1,d0
	andi.w	#$FE,d0		; Round to next even address, if it isn't already
	lea	8(a2,d0.w),a2	; Advance to next script in list
	addq.w	#2,a3		; Advance to next script's slot in a3 (usually Anim_Counters)
	dbf	d6,.loop
	rts