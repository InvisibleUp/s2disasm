; Sonic the Hedgehog 2 disassembled binary

; Nemesis,   2004: Created original disassembly for SNASM68K
; Aurochs,   2005: Translated to AS and annotated
; Xenowhirl, 2007: More annotation, overall cleanup, Z80 disassembly
; ---------------------------------------------------------------------------
; NOTES:
;
; Set your editor's tab width to 8 characters wide for viewing this file.
;
; It is highly suggested that you read the AS User's Manual before diving too
; far into this disassembly. At least read the section on nameless temporary
; symbols. Your brain may melt if you don't know how those work.
;
; See s2.notes.txt for more comments about this disassembly and other useful info.

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ASSEMBLY OPTIONS:
;
    ifndef gameRevision
gameRevision = 1
    endif
;	| If 0, a REV00 ROM is built
;	| If 1, a REV01 ROM is built, which contains some fixes
;	| If 2, a (probable) REV02 ROM is built, which contains even more fixes
padToPowerOfTwo = 1
;	| If 1, pads the end of the ROM to the next power of two bytes (for real hardware)
;
allOptimizations = 0
;	| If 1, enables all optimizations
;
skipChecksumCheck = 0|allOptimizations
;	| If 1, disables the unnecessary (and slow) bootup checksum calculation
;
zeroOffsetOptimization = 0|allOptimizations
;	| If 1, makes a handful of zero-offset instructions smaller
;
removeJmpTos = 0|gameRevision=2|allOptimizations
;	| If 1, many unnecessary JmpTos are removed, improving performance
;
addsubOptimize = 0|gameRevision=2|allOptimizations
;	| If 1, some add/sub instructions are optimized to addq/subq
;
relativeLea = 0|gameRevision<>2|allOptimizations
;	| If 1, makes some instructions use pc-relative addressing, instead of absolute long
;
useFullWaterTables = 0
;	| If 1, zone offset tables for water levels cover all level slots instead of only slots 8-$F
;	| Set to 1 if you've shifted level IDs around or you want water in levels with a level slot below 8

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; AS-specific macros and assembler settings
	CPU 68000
	include "s2.macrosetup.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equates section - Names for variables.
	include "s2.constants.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Simplifying macros and functions
	include "s2.macros.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; start of ROM

StartOfRom:
    if * <> 0
	fatal "StartOfRom was $\{*} but it should be 0"
    endif
Vectors:
	dc.l System_Stack	; Initial stack pointer value
	dc.l EntryPoint		; Start of program
	dc.l ErrorTrap		; Bus error
	dc.l ErrorTrap		; Address error (4)
	dc.l ErrorTrap		; Illegal instruction
	dc.l ErrorTrap		; Division by zero
	dc.l ErrorTrap		; CHK exception
	dc.l ErrorTrap		; TRAPV exception (8)
	dc.l ErrorTrap		; Privilege violation
	dc.l ErrorTrap		; TRACE exception
	dc.l ErrorTrap		; Line-A emulator
	dc.l ErrorTrap		; Line-F emulator (12)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (16)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (20)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (24)
	dc.l ErrorTrap		; Spurious exception
	dc.l ErrorTrap		; IRQ level 1
	dc.l ErrorTrap		; IRQ level 2
	dc.l ErrorTrap		; IRQ level 3 (28)
	dc.l H_Int			; IRQ level 4 (horizontal retrace interrupt)
	dc.l ErrorTrap		; IRQ level 5
	dc.l V_Int			; IRQ level 6 (vertical retrace interrupt)
	dc.l ErrorTrap		; IRQ level 7 (32)
	dc.l ErrorTrap		; TRAP #00 exception
	dc.l ErrorTrap		; TRAP #01 exception
	dc.l ErrorTrap		; TRAP #02 exception
	dc.l ErrorTrap		; TRAP #03 exception (36)
	dc.l ErrorTrap		; TRAP #04 exception
	dc.l ErrorTrap		; TRAP #05 exception
	dc.l ErrorTrap		; TRAP #06 exception
	dc.l ErrorTrap		; TRAP #07 exception (40)
	dc.l ErrorTrap		; TRAP #08 exception
	dc.l ErrorTrap		; TRAP #09 exception
	dc.l ErrorTrap		; TRAP #10 exception
	dc.l ErrorTrap		; TRAP #11 exception (44)
	dc.l ErrorTrap		; TRAP #12 exception
	dc.l ErrorTrap		; TRAP #13 exception
	dc.l ErrorTrap		; TRAP #14 exception
	dc.l ErrorTrap		; TRAP #15 exception (48)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (52)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (56)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (60)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved)
	dc.l ErrorTrap		; Unused (reserved) (64)
; byte_100:
Header:
	dc.b "SEGA GENESIS    " ; Console name
	dc.b "(C)SEGA 1992.SEP" ; Copyright holder and release date (generally year)
	dc.b "SONIC THE             HEDGEHOG 2                " ; Domestic name
	dc.b "SONIC THE             HEDGEHOG 2                " ; International name
    if gameRevision=0
	dc.b "GM 00001051-00"   ; Version (REV00)
    elseif gameRevision=1
	dc.b "GM 00001051-01"   ; Version (REV01)
    elseif gameRevision=2
	dc.b "GM 00001051-02"   ; Version (REV02)
    endif
; word_18E
Checksum:
	dc.w $D951		; Checksum (patched later if incorrect)
	dc.b "J               " ; I/O Support
	dc.l StartOfRom		; Start address of ROM
; dword_1A4
ROMEndLoc:
	dc.l EndOfRom-1		; End address of ROM
	dc.l RAM_Start&$FFFFFF		; Start address of RAM
	dc.l (RAM_End-1)&$FFFFFF		; End address of RAM
	dc.b "    "		; Backup RAM ID
	dc.l $20202020		; Backup RAM start address
	dc.l $20202020		; Backup RAM end address
	dc.b "            "	; Modem support
	dc.b "                                        "	; Notes (unused, anything can be put in this space, but it has to be 52 bytes.)
	dc.b "JUE             " ; Country code (region)
EndOfHeader:

; ===========================================================================
; Crash/Freeze the 68000. Note that the Z80 continues to run, so the music keeps playing.
; loc_200:
ErrorTrap:
	nop	; delay
	nop	; delay
	bra.s	ErrorTrap	; Loop indefinitely.

; ===========================================================================
; loc_206:
EntryPoint:
	tst.l	(HW_Port_1_Control-1).l	; test ports A and B control
	bne.s	PortA_Ok	; If so, branch.
	tst.w	(HW_Expansion_Control-1).l	; test port C control
; loc_214:
PortA_Ok:
	bne.s	PortC_OK ; Skip the VDP and Z80 setup code if port A, B or C is ok...?
	lea	SetupValues(pc),a5	; Load setup values array address.
	movem.w	(a5)+,d5-d7
	movem.l	(a5)+,a0-a4
	move.b	HW_Version-Z80_Bus_Request(a1),d0	; Get hardware version
	andi.b	#$F,d0	; Compare
	beq.s	SkipSecurity	; If the console has no TMSS, skip the security stuff.
	move.l	#'SEGA',Security_Addr-Z80_Bus_Request(a1) ; Satisfy the TMSS
; loc_234:
SkipSecurity:
	move.w	(a4),d0	; check if VDP works
	moveq	#0,d0	; clear d0
	movea.l	d0,a6	; clear a6
	move.l	a6,usp	; set usp to $0
	
	moveq	#VDPInitValues_End-VDPInitValues-1,d1 ; run the following loop $18 times
; loc_23E:
VDPInitLoop:
	move.b	(a5)+,d5	; add $8000 to value
	move.w	d5,(a4)	; move value to VDP register
	add.w	d7,d5	; next register
	dbf	d1,VDPInitLoop

	move.l	(a5)+,(a4)	; set VRAM write mode
	move.w	d0,(a3)	; clear the screen
	move.w	d7,(a1)	; stop the Z80
	move.w	d7,(a2)	; reset the Z80
; loc_250:
WaitForZ80:
	btst	d0,(a1)	; has the Z80 stopped?
	bne.s	WaitForZ80	; if not, branch
	
	moveq	#Z80StartupCodeEnd-Z80StartupCodeBegin-1,d2
; loc_256:
Z80InitLoop:
	move.b	(a5)+,(a0)+
	dbf	d2,Z80InitLoop

	move.w	d0,(a2)
	move.w	d0,(a1)	; start the Z80
	move.w	d7,(a2)	; reset the Z80
	
; loc_262:
ClrRAMLoop:
	move.l	d0,-(a6)	; clear 4 bytes of RAM
	dbf	d6,ClrRAMLoop	; repeat until the entire RAM is clear
	move.l	(a5)+,(a4)	; set VDP display mode and increment mode
	move.l	(a5)+,(a4)	; set VDP to CRAM write
	
	moveq	#bytesToLcnt($80),d3	; set repeat times
; loc_26E:
ClrCRAMLoop:
	move.l	d0,(a3)	; clear 2 palettes
	dbf	d3,ClrCRAMLoop	; repeat until the entire CRAM is clear
	move.l	(a5)+,(a4)	; set VDP to VSRAM write
	
	moveq	#bytesToLcnt($50),d4	; set repeat times
; loc_278: ClrVDPStuff:
ClrVSRAMLoop:
	move.l	d0,(a3)	; clear 4 bytes of VSRAM.
	dbf	d4,ClrVSRAMLoop	; repeat until the entire VSRAM is clear
	moveq	#PSGInitValues_End-PSGInitValues-1,d5	; set repeat times.
; loc_280:
PSGInitLoop:
	move.b	(a5)+,PSG_input-VDP_data_port(a3) ; reset the PSG
	dbf	d5,PSGInitLoop	; repeat for other channels
	move.w	d0,(a2)
	movem.l	(a6),d0-a6	; clear all registers
	move	#$2700,sr	; set the sr
 ; loc_292:
PortC_OK: ;;
	bra.s	GameProgram	; Branch to game program.
; ===========================================================================
; byte_294:
SetupValues:
	dc.w	$8000,bytesToLcnt($10000),$100

	dc.l	Z80_RAM
	dc.l	Z80_Bus_Request
	dc.l	Z80_Reset
	dc.l	VDP_data_port, VDP_control_port

VDPInitValues:	; values for VDP registers
	dc.b 4			; Command $8004 - HInt off, Enable HV counter read
	dc.b $14		; Command $8114 - Display off, VInt off, DMA on, PAL off
	dc.b $30		; Command $8230 - Scroll A Address $C000
	dc.b $3C		; Command $833C - Window Address $F000
	dc.b 7			; Command $8407 - Scroll B Address $E000
	dc.b $6C		; Command $856C - Sprite Table Address $D800
	dc.b 0			; Command $8600 - Null
	dc.b 0			; Command $8700 - Background color Pal 0 Color 0
	dc.b 0			; Command $8800 - Null
	dc.b 0			; Command $8900 - Null
	dc.b $FF		; Command $8AFF - Hint timing $FF scanlines
	dc.b 0			; Command $8B00 - Ext Int off, VScroll full, HScroll full
	dc.b $81		; Command $8C81 - 40 cell mode, shadow/highlight off, no interlace
	dc.b $37		; Command $8D37 - HScroll Table Address $DC00
	dc.b 0			; Command $8E00 - Null
	dc.b 1			; Command $8F01 - VDP auto increment 1 byte
	dc.b 1			; Command $9001 - 64x32 cell scroll size
	dc.b 0			; Command $9100 - Window H left side, Base Point 0
	dc.b 0			; Command $9200 - Window V upside, Base Point 0
	dc.b $FF		; Command $93FF - DMA Length Counter $FFFF
	dc.b $FF		; Command $94FF - See above
	dc.b 0			; Command $9500 - DMA Source Address $0
	dc.b 0			; Command $9600 - See above
	dc.b $80		; Command $9780	- See above + VRAM fill mode
VDPInitValues_End:

	dc.l	vdpComm($0000,VRAM,DMA) ; value for VRAM write mode

	; Z80 instructions (not the sound driver; that gets loaded later)
Z80StartupCodeBegin: ; loc_2CA:
    if (*)+$26 < $10000
    save
    CPU Z80 ; start assembling Z80 code
    phase 0 ; pretend we're at address 0
	xor	a	; clear a to 0
	ld	bc,((Z80_RAM_End-Z80_RAM)-zStartupCodeEndLoc)-1 ; prepare to loop this many times
	ld	de,zStartupCodeEndLoc+1	; initial destination address
	ld	hl,zStartupCodeEndLoc	; initial source address
	ld	sp,hl	; set the address the stack starts at
	ld	(hl),a	; set first byte of the stack to 0
	ldir		; loop to fill the stack (entire remaining available Z80 RAM) with 0
	pop	ix	; clear ix
	pop	iy	; clear iy
	ld	i,a	; clear i
	ld	r,a	; clear r
	pop	de	; clear de
	pop	hl	; clear hl
	pop	af	; clear af
	ex	af,af'	; swap af with af'
	exx		; swap bc/de/hl with their shadow registers too
	pop	bc	; clear bc
	pop	de	; clear de
	pop	hl	; clear hl
	pop	af	; clear af
	ld	sp,hl	; clear sp
	di		; clear iff1 (for interrupt handler)
	im	1	; interrupt handling mode = 1
	ld	(hl),0E9h ; replace the first instruction with a jump to itself
	jp	(hl)	  ; jump to the first instruction (to stay there forever)
zStartupCodeEndLoc:
    dephase ; stop pretending
	restore
    padding off ; unfortunately our flags got reset so we have to set them again...
    else ; due to an address range limitation I could work around but don't think is worth doing so:
	message "Warning: using pre-assembled Z80 startup code."
	dc.w $AF01,$D91F,$1127,$0021,$2600,$F977,$EDB0,$DDE1,$FDE1,$ED47,$ED4F,$D1E1,$F108,$D9C1,$D1E1,$F1F9,$F3ED,$5636,$E9E9
    endif
Z80StartupCodeEnd:

	dc.w	$8104	; value for VDP display mode
	dc.w	$8F02	; value for VDP increment
	dc.l	vdpComm($0000,CRAM,WRITE)	; value for CRAM write mode
	dc.l	vdpComm($0000,VSRAM,WRITE)	; value for VSRAM write mode

PSGInitValues:
	dc.b	$9F,$BF,$DF,$FF	; values for PSG channel volumes
PSGInitValues_End:
; ===========================================================================

	even
; loc_300:
GameProgram:
	tst.w	(VDP_control_port).l
; loc_306:
CheckSumCheck:
    if gameRevision>0
	move.w	(VDP_control_port).l,d1
	btst	#1,d1
	bne.s	CheckSumCheck	; wait until DMA is completed
    endif
	btst	#6,(HW_Expansion_Control).l
	beq.s	ChecksumTest
	cmpi.l	#'init',(Checksum_fourcc).w ; has checksum routine already run?
	beq.w	GameInit

; loc_328:
ChecksumTest:
    if skipChecksumCheck=0	; checksum code
	movea.l	#EndOfHeader,a0	; start checking bytes after the header ($200)
	movea.l	#ROMEndLoc,a1	; stop at end of ROM
	move.l	(a1),d0
	moveq	#0,d1
; loc_338:
ChecksumLoop:
	add.w	(a0)+,d1
	cmp.l	a0,d0
	bhs.s	ChecksumLoop
	movea.l	#Checksum,a1	; read the checksum
	cmp.w	(a1),d1	; compare correct checksum to the one in ROM
	bne.w	ChecksumError	; if they don't match, branch
    endif
;checksum_good:
	lea	(System_Stack).w,a6
	moveq	#0,d7

	move.w	#bytesToLcnt($200),d6
-	move.l	d7,(a6)+
	dbf	d6,-

	move.b	(HW_Version).l,d0
	andi.b	#$C0,d0
	move.b	d0,(Graphics_Flags).w
	move.l	#'init',(Checksum_fourcc).w ; set flag so checksum won't be run again
; loc_370:
GameInit:
	lea	(RAM_Start&$FFFFFF).l,a6
	moveq	#0,d7
	move.w	#bytesToLcnt(System_Stack&$FFFF),d6
; loc_37C:
GameClrRAM:
	move.l	d7,(a6)+
	dbf	d6,GameClrRAM	; clear RAM ($0000-$FDFF)

	bsr.w	VDPSetupGame
	bsr.w	JmpTo_SoundDriverLoad
	bsr.w	JoypadInit
	move.b	#GameModeID_SegaScreen,(Game_Mode).w ; set Game Mode to Sega Screen
; loc_394:
MainGameLoop:
	move.b	(Game_Mode).w,d0 ; load Game Mode
	andi.w	#$3C,d0	; limit Game Mode value to $3C max (change to a maximum of 7C to add more game modes)
	jsr	GameModesArray(pc,d0.w)	; jump to apt location in ROM
	bra.s	MainGameLoop	; loop indefinitely
; ===========================================================================

	include "_inc/Game Modes/_GameModesArray.asm"

; ===========================================================================
    if skipChecksumCheck=0	; checksum error code
; loc_3CE:
ChecksumError:
	move.l	d1,-(sp)
	bsr.w	VDPSetupGame
	move.l	(sp)+,d1
	move.l	#vdpComm($0000,CRAM,WRITE),(VDP_control_port).l ; set VDP to CRAM write
	moveq	#$3F,d7
; loc_3E2:
Checksum_Red:
	move.w	#$E,(VDP_data_port).l ; fill palette with red
	dbf	d7,Checksum_Red	; repeat $3F more times
; loc_3EE:
ChecksumFailed_Loop:
	bra.s	ChecksumFailed_Loop
    endif
; ===========================================================================
; loc_3F0:
LevelSelectMenu2P: ;;
	jmp	(MenuScreen).l
; ===========================================================================
; loc_3F6:
JmpTo_EndingSequence 
	jmp	(EndingSequence).l
; ===========================================================================
; loc_3FC:
OptionsMenu: ;;
	jmp	(MenuScreen).l
; ===========================================================================
; loc_402:
LevelSelectMenu: ;;
	jmp	(MenuScreen).l
; ===========================================================================

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; vertical and horizontal interrupt handlers
; VERTICAL INTERRUPT HANDLER:
V_Int:
	movem.l	d0-a6,-(sp)
	tst.b	(Vint_routine).w
	beq.w	Vint_Lag

-	move.w	(VDP_control_port).l,d0
	andi.w	#8,d0
	beq.s	-

	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor).w,(VDP_data_port).l ; send screen y-axis pos. to VSRAM
	btst	#6,(Graphics_Flags).w ; is Megadrive PAL?
	beq.s	+		; if not, branch

	move.w	#$700,d0
-	dbf	d0,- ; wait here in a loop doing nothing for a while...
+
	move.b	(Vint_routine).w,d0
	move.b	#VintID_Lag,(Vint_routine).w
	move.w	#1,(Hint_flag).w
	andi.w	#$3E,d0
	move.w	Vint_SwitchTbl(pc,d0.w),d0
	jsr	Vint_SwitchTbl(pc,d0.w)

VintRet:
	addq.l	#1,(Vint_runcount).w
	movem.l	(sp)+,d0-a6
	rte
; ===========================================================================
Vint_SwitchTbl: offsetTable
Vint_Lag_ptr		offsetTableEntry.w Vint_Lag			;   0
Vint_SEGA_ptr:		offsetTableEntry.w Vint_SEGA		;   2
Vint_Title_ptr:		offsetTableEntry.w Vint_Title		;   4
Vint_Unused6_ptr:	offsetTableEntry.w Vint_Unused6		;   6
Vint_Level_ptr:		offsetTableEntry.w Vint_Level		;   8
Vint_S2SS_ptr:		offsetTableEntry.w Vint_S2SS		;  $A
Vint_TitleCard_ptr:	offsetTableEntry.w Vint_TitleCard	;  $C
Vint_UnusedE_ptr:	offsetTableEntry.w Vint_UnusedE		;  $E
Vint_Pause_ptr:		offsetTableEntry.w Vint_Pause		; $10
Vint_Fade_ptr:		offsetTableEntry.w Vint_Fade		; $12
Vint_PCM_ptr:		offsetTableEntry.w Vint_PCM			; $14
Vint_Menu_ptr:		offsetTableEntry.w Vint_Menu		; $16
Vint_Ending_ptr:	offsetTableEntry.w Vint_Ending		; $18
Vint_CtrlDMA_ptr:	offsetTableEntry.w Vint_CtrlDMA		; $1A
; ===========================================================================
;VintSub0
Vint_Lag:
	cmpi.b	#GameModeID_TitleCard|GameModeID_Demo,(Game_Mode).w	; pre-level Demo Mode?
	beq.s	loc_4C4
	cmpi.b	#GameModeID_TitleCard|GameModeID_Level,(Game_Mode).w	; pre-level Zone play mode?
	beq.s	loc_4C4
	cmpi.b	#GameModeID_Demo,(Game_Mode).w	; Demo Mode?
	beq.s	loc_4C4
	cmpi.b	#GameModeID_Level,(Game_Mode).w	; Zone play mode?
	beq.s	loc_4C4

	stopZ80			; stop the Z80
	bsr.w	sndDriverInput	; give input to the sound driver
	startZ80		; start the Z80

	bra.s	VintRet
; ---------------------------------------------------------------------------

loc_4C4:
	tst.b	(Water_flag).w
	beq.w	Vint0_noWater
	move.w	(VDP_control_port).l,d0
	btst	#6,(Graphics_Flags).w
	beq.s	+

	move.w	#$700,d0
-	dbf	d0,- ; do nothing for a while...
+
	move.w	#1,(Hint_flag).w

	stopZ80

	tst.b	(Water_fullscreen_flag).w
	bne.s	loc_526

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM

	bra.s	loc_54A
; ---------------------------------------------------------------------------

loc_526:
	dma68kToVDP Underwater_palette,$0000,palette_line_size*4,CRAM

loc_54A:
	move.w	(Hint_counter_reserve).w,(a5)
	move.w	#$8200|(VRAM_Plane_A_Name_Table/$400),(VDP_control_port).l	; Set scroll A PNT base to $C000
	bsr.w	sndDriverInput

	startZ80

	bra.w	VintRet
; ---------------------------------------------------------------------------

Vint0_noWater:
	move.w	(VDP_control_port).l,d0
	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor).w,(VDP_data_port).l
	btst	#6,(Graphics_Flags).w
	beq.s	+

	move.w	#$700,d0
-	dbf	d0,- ; do nothing for a while...
+
	move.w	#1,(Hint_flag).w
	move.w	(Hint_counter_reserve).w,(VDP_control_port).l
	move.w	#$8200|(VRAM_Plane_A_Name_Table/$400),(VDP_control_port).l	; Set scroll A PNT base to $C000
	move.l	(Vscroll_Factor_P2).w,(Vscroll_Factor_P2_HInt).w

	stopZ80
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	bsr.w	sndDriverInput
	startZ80

	bra.w	VintRet
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

; This subroutine copies the H scroll table buffer (in main RAM) to the H scroll
; table (in VRAM).
;VintSub2
Vint_SEGA:
	bsr.w	Do_ControllerPal

	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM
	jsrto	(SegaScr_VInt).l, JmpTo_SegaScr_VInt
	tst.w	(Demo_Time_left).w	; is there time left on the demo?
	beq.w	+	; if not, return
	subq.w	#1,(Demo_Time_left).w	; subtract 1 from time left in demo
+
	rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;VintSub14
Vint_PCM:
	move.b	(Vint_runcount+3).w,d0
	andi.w	#$F,d0
	bne.s	+

	stopZ80
	bsr.w	ReadJoypads
	startZ80
+
	tst.w	(Demo_Time_left).w	; is there time left on the demo?
	beq.w	+	; if not, return
	subq.w	#1,(Demo_Time_left).w	; subtract 1 from time left in demo
+
	rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;VintSub4
Vint_Title:
	bsr.w	Do_ControllerPal
	bsr.w	ProcessDPLC
	tst.w	(Demo_Time_left).w	; is there time left on the demo?
	beq.w	+	; if not, return
	subq.w	#1,(Demo_Time_left).w	; subtract 1 from time left in demo
+
	rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;VintSub6
Vint_Unused6:
	bsr.w	Do_ControllerPal
	rts
; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;VintSub10
Vint_Pause:
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; Special Stage?
	beq.w	Vint_Pause_specialStage
;VintSub8
Vint_Level:
	stopZ80

	bsr.w	ReadJoypads
	tst.b	(Teleport_timer).w
	beq.s	loc_6F8
	lea	(VDP_control_port).l,a5
	tst.w	(Game_paused).w	; is the game paused ?
	bne.w	loc_748	; if yes, branch
	subq.b	#1,(Teleport_timer).w
	bne.s	+
	move.b	#0,(Teleport_flag).w
+
	cmpi.b	#$10,(Teleport_timer).w
	blo.s	loc_6F8
	lea	(VDP_data_port).l,a6
	move.l	#vdpComm($0000,CRAM,WRITE),(VDP_control_port).l
	move.w	#$EEE,d0

	move.w	#$1F,d1
-	move.w	d0,(a6)
	dbf	d1,-

	move.l	#vdpComm($0042,CRAM,WRITE),(VDP_control_port).l

	move.w	#$1F,d1
-	move.w	d0,(a6)
	dbf	d1,-

	bra.s	loc_748
; ---------------------------------------------------------------------------

loc_6F8:
	tst.b	(Water_fullscreen_flag).w
	bne.s	loc_724
	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	bra.s	loc_748
; ---------------------------------------------------------------------------

loc_724:

	dma68kToVDP Underwater_palette,$0000,palette_line_size*4,CRAM

loc_748:
	move.w	(Hint_counter_reserve).w,(a5)
	move.w	#$8200|(VRAM_Plane_A_Name_Table/$400),(VDP_control_port).l	; Set scroll A PNT base to $C000

	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM

	bsr.w	ProcessDMAQueue
	bsr.w	sndDriverInput

	startZ80

	movem.l	(Camera_RAM).w,d0-d7
	movem.l	d0-d7,(Camera_RAM_copy).w
	movem.l	(Camera_X_pos_P2).w,d0-d7
	movem.l	d0-d7,(Camera_P2_copy).w
	movem.l	(Scroll_flags).w,d0-d3
	movem.l	d0-d3,(Scroll_flags_copy).w
	move.l	(Vscroll_Factor_P2).w,(Vscroll_Factor_P2_HInt).w
	cmpi.b	#$5C,(Hint_counter_reserve+1).w
	bhs.s	Do_Updates
	move.b	#1,(Do_Updates_in_H_int).w
	rts

; ---------------------------------------------------------------------------
; Subroutine to run a demo for an amount of time
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_7E6: Demo_Time:
Do_Updates:
	jsrto	(LoadTilesAsYouMove).l, JmpTo_LoadTilesAsYouMove
	jsr	(HudUpdate).l
	bsr.w	ProcessDPLC2
	tst.w	(Demo_Time_left).w	; is there time left on the demo?
	beq.w	+		; if not, branch
	subq.w	#1,(Demo_Time_left).w	; subtract 1 from time left in demo
+
	rts
; End of function Do_Updates

; ---------------------------------------------------------------------------
;Vint10_specialStage
Vint_Pause_specialStage:
	stopZ80

	bsr.w	ReadJoypads
	jsr	(sndDriverInput).l
	tst.b	(SS_Last_Alternate_HorizScroll_Buf).w
	beq.s	loc_84A

	dma68kToVDP SS_Horiz_Scroll_Buf_2,VRAM_SS_Horiz_Scroll_Table,VRAM_SS_Horiz_Scroll_Table_Size,VRAM
	bra.s	loc_86E
; ---------------------------------------------------------------------------
loc_84A:
	dma68kToVDP SS_Horiz_Scroll_Buf_1,VRAM_SS_Horiz_Scroll_Table,VRAM_SS_Horiz_Scroll_Table_Size,VRAM

loc_86E:
	startZ80
	rts
; ========================================================================>>>
;VintSubA
Vint_S2SS:
	stopZ80

	bsr.w	ReadJoypads
	bsr.w	SSSet_VScroll

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	dma68kToVDP SS_Sprite_Table,VRAM_SS_Sprite_Attribute_Table,VRAM_SS_Sprite_Attribute_Table_Size,VRAM

	tst.b	(SS_Alternate_HorizScroll_Buf).w
	beq.s	loc_906

	dma68kToVDP SS_Horiz_Scroll_Buf_2,VRAM_SS_Horiz_Scroll_Table,VRAM_SS_Horiz_Scroll_Table_Size,VRAM
	bra.s	loc_92A
; ---------------------------------------------------------------------------

loc_906:
	dma68kToVDP SS_Horiz_Scroll_Buf_1,VRAM_SS_Horiz_Scroll_Table,VRAM_SS_Horiz_Scroll_Table_Size,VRAM

loc_92A:
	tst.b	(SSTrack_Orientation).w			; Is the current track frame flipped?
	beq.s	++								; Branch if not
	moveq	#0,d0
	move.b	(SSTrack_drawing_index).w,d0	; Get drawing position
	cmpi.b	#4,d0							; Have we finished drawing and streaming track frame?
	bge.s	++								; Branch if yes (nothing to draw)
	add.b	d0,d0							; Convert to index
	tst.b	(SS_Alternate_PNT).w			; [(SSTrack_drawing_index) * 2] = subroutine
	beq.s	+								; Branch if not using the alternate Plane A name table
	addi_.w	#8,d0							; ([(SSTrack_drawing_index) * 2] + 8) = subroutine
+
	move.w	SS_PNTA_Transfer_Table(pc,d0.w),d0
	jsr	SS_PNTA_Transfer_Table(pc,d0.w)
+
	bsr.w	SSRun_Animation_Timers
	addi_.b	#1,(SSTrack_drawing_index).w	; Run track timer
	move.b	(SSTrack_drawing_index).w,d0	; Get new timer value
	cmp.b	d1,d0							; Is it less than the player animation timer?
	blt.s	+++								; Branch if so
	move.b	#0,(SSTrack_drawing_index).w	; Start drawing new frame
	lea	(VDP_control_port).l,a6
	tst.b	(SS_Alternate_PNT).w			; Are we using the alternate address for plane A?
	beq.s	+								; Branch if not
	move.w	#$8200|(VRAM_SS_Plane_A_Name_Table1/$400),(a6)	; Set PNT A base to $C000
	bra.s	++
; ===========================================================================
;off_97A
SS_PNTA_Transfer_Table:	offsetTable
		offsetTableEntry.w loc_A50	; 0
		offsetTableEntry.w loc_A76	; 1
		offsetTableEntry.w loc_A9C	; 2
		offsetTableEntry.w loc_AC2	; 3
		offsetTableEntry.w loc_9B8	; 4
		offsetTableEntry.w loc_9DE	; 5
		offsetTableEntry.w loc_A04	; 6
		offsetTableEntry.w loc_A2A	; 7
; ===========================================================================
+
	move.w	#$8200|(VRAM_SS_Plane_A_Name_Table2/$400),(a6)	; Set PNT A base to $8000
+
	eori.b	#1,(SS_Alternate_PNT).w			; Toggle flag
+
	bsr.w	ProcessDMAQueue
	jsr	(sndDriverInput).l

	startZ80

	bsr.w	ProcessDPLC2
	tst.w	(Demo_Time_left).w
	beq.w	+	; rts
	subq.w	#1,(Demo_Time_left).w
+
	rts
; ---------------------------------------------------------------------------
; (!)
; Each of these functions copies one fourth of pattern name table A into VRAM
; from a buffer in main RAM. $700 bytes are copied each frame, with the target
; are in VRAM depending on the current drawing position.
loc_9B8:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table1 + 0 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_9DE:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table1 + 1 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A04:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table1 + 2 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A2A:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table1 + 3 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A50:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table2 + 0 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A76:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table2 + 1 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_A9C:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table2 + 2 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ---------------------------------------------------------------------------
loc_AC2:
	dma68kToVDP PNT_Buffer,VRAM_SS_Plane_A_Name_Table2 + 3 * (PNT_Buffer_End-PNT_Buffer),PNT_Buffer_End-PNT_Buffer,VRAM
	rts
; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_AE8
SSSet_VScroll:
	move.w	(VDP_control_port).l,d0
	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor).w,(VDP_data_port).l
	rts
; End of function SSSet_VScroll


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_B02
SSRun_Animation_Timers:
	move.w	(SS_Cur_Speed_Factor).w,d0		; Get current speed factor
	cmp.w	(SS_New_Speed_Factor).w,d0		; Has the speed factor changed?
	beq.s	+								; Branch if yes
	move.l	(SS_New_Speed_Factor).w,(SS_Cur_Speed_Factor).w	; Save new speed factor
	move.b	#0,(SSTrack_duration_timer).w	; Reset timer
+
	subi_.b	#1,(SSTrack_duration_timer).w	; Run track timer
	bgt.s	+								; Branch if not expired yet
	lea	(SSAnim_Base_Duration).l,a0
	move.w	(SS_Cur_Speed_Factor).w,d0		; The current speed factor is an index
	lsr.w	#1,d0
	move.b	(a0,d0.w),d1
	move.b	d1,(SS_player_anim_frame_timer).w	; New player animation length (later halved)
	move.b	d1,(SSTrack_duration_timer).w		; New track timer
	subq.b	#1,(SS_player_anim_frame_timer).w	; Subtract one
	rts
; ---------------------------------------------------------------------------
+
	move.b	(SS_player_anim_frame_timer).w,d1	; Get current player animatino length
	addq.b	#1,d1		; Increase it
	rts
; End of function SSRun_Animation_Timers

; ===========================================================================
;byte_B46
SSAnim_Base_Duration:
	dc.b 60
	dc.b 30	; 1
	dc.b 15	; 2
	dc.b 10	; 3
	dc.b  8	; 4
	dc.b  6	; 5
	dc.b  5	; 6
	dc.b  0	; 7
; ===========================================================================
;VintSub1A
Vint_CtrlDMA:
	stopZ80
	jsr	(ProcessDMAQueue).l
	startZ80
	rts
; ===========================================================================
;VintSubC
Vint_TitleCard:
	stopZ80

	bsr.w	ReadJoypads
	tst.b	(Water_fullscreen_flag).w
	bne.s	loc_BB2

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	bra.s	loc_BD6
; ---------------------------------------------------------------------------

loc_BB2:
	dma68kToVDP Underwater_palette,$0000,palette_line_size*4,CRAM

loc_BD6:
	move.w	(Hint_counter_reserve).w,(a5)

	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM

	bsr.w	ProcessDMAQueue
	jsr	(DrawLevelTitleCard).l
	jsr	(sndDriverInput).l

	startZ80

	movem.l	(Camera_RAM).w,d0-d7
	movem.l	d0-d7,(Camera_RAM_copy).w
	movem.l	(Scroll_flags).w,d0-d1
	movem.l	d0-d1,(Scroll_flags_copy).w
	move.l	(Vscroll_Factor_P2).w,(Vscroll_Factor_P2_HInt).w
	bsr.w	ProcessDPLC
	rts
; ===========================================================================
;VintSubE
Vint_UnusedE:
	bsr.w	Do_ControllerPal
	addq.b	#1,(VIntSubE_RunCount).w
	move.b	#VintID_UnusedE,(Vint_routine).w
	rts
; ===========================================================================
;VintSub12
Vint_Fade:
	bsr.w	Do_ControllerPal
	move.w	(Hint_counter_reserve).w,(a5)
	bra.w	ProcessDPLC
; ===========================================================================
;VintSub18
Vint_Ending:
	stopZ80

	bsr.w	ReadJoypads

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

	bsr.w	ProcessDMAQueue
	bsr.w	sndDriverInput
	movem.l	(Camera_RAM).w,d0-d7
	movem.l	d0-d7,(Camera_RAM_copy).w
	movem.l	(Scroll_flags).w,d0-d3
	movem.l	d0-d3,(Scroll_flags_copy).w
	jsrto	(LoadTilesAsYouMove).l, JmpTo_LoadTilesAsYouMove

	startZ80

	move.w	(Ending_VInt_Subrout).w,d0
	beq.s	+	; rts
	clr.w	(Ending_VInt_Subrout).w
	move.w	off_D3C-2(pc,d0.w),d0
	jsr	off_D3C(pc,d0.w)
+
	rts
; ===========================================================================
off_D3C:	offsetTable
		offsetTableEntry.w (+)	; 1
		offsetTableEntry.w (++)	; 2
; ===========================================================================
+
	dmaFillVRAM 0,VRAM_EndSeq_Plane_A_Name_Table,VRAM_EndSeq_Plane_Table_Size	; VRAM Fill $C000 with $2000 zeros
	rts
; ---------------------------------------------------------------------------
+
	dmaFillVRAM 0,VRAM_EndSeq_Plane_B_Name_Table2,VRAM_EndSeq_Plane_Table_Size
	dmaFillVRAM 0,VRAM_EndSeq_Plane_A_Name_Table,VRAM_EndSeq_Plane_Table_Size

	lea	(VDP_control_port).l,a6
	move.w	#$8B00,(a6)		; EXT-INT off, V scroll by screen, H scroll by screen
	move.w	#$8400|(VRAM_EndSeq_Plane_B_Name_Table2/$2000),(a6)	; PNT B base: $4000
	move.w	#$9011,(a6)		; Scroll table size: 64x64
	lea	(Chunk_Table).l,a1
	move.l	#vdpComm(VRAM_EndSeq_Plane_A_Name_Table + planeLocH40($16,$21),VRAM,WRITE),d0	;$50AC0003
	moveq	#$16,d1
	moveq	#$E,d2
	jsrto	(PlaneMapToVRAM_H40).l, PlaneMapToVRAM_H40
	rts
; ===========================================================================
;VintSub16
Vint_Menu:
	stopZ80

	bsr.w	ReadJoypads

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

	bsr.w	ProcessDMAQueue
	bsr.w	sndDriverInput

	startZ80

	bsr.w	ProcessDPLC
	tst.w	(Demo_Time_left).w
	beq.w	+	; rts
	subq.w	#1,(Demo_Time_left).w
+
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

;sub_E98
Do_ControllerPal:
	stopZ80

	bsr.w	ReadJoypads
	tst.b	(Water_fullscreen_flag).w
	bne.s	loc_EDA

	dma68kToVDP Normal_palette,$0000,palette_line_size*4,CRAM
	bra.s	loc_EFE
; ---------------------------------------------------------------------------

loc_EDA:
	dma68kToVDP Underwater_palette,$0000,palette_line_size*4,CRAM

loc_EFE:
	dma68kToVDP Sprite_Table,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	dma68kToVDP Horiz_Scroll_Buf,VRAM_Horiz_Scroll_Table,VRAM_Horiz_Scroll_Table_Size,VRAM

	bsr.w	sndDriverInput

	startZ80

	rts
; End of function sub_E98
; ||||||||||||||| E N D   O F   V - I N T |||||||||||||||||||||||||||||||||||

; ===========================================================================
; Start of H-INT code
H_Int:
	tst.w	(Hint_flag).w
	beq.w	+
	tst.w	(Two_player_mode).w
	beq.w	PalToCRAM
	move.w	#0,(Hint_flag).w
	move.l	a5,-(sp)
	move.l	d0,-(sp)

-	move.w	(VDP_control_port).l,d0	; loop start: Make sure V_BLANK is over
	andi.w	#4,d0
	beq.s	-	; loop end

	move.w	(VDP_Reg1_val).w,d0
	andi.b	#$BF,d0
	move.w	d0,(VDP_control_port).l		; Display disable
	move.w	#$8200|(VRAM_Plane_A_Name_Table_2P/$400),(VDP_control_port).l	; PNT A base: $A000
	move.l	#vdpComm($0000,VSRAM,WRITE),(VDP_control_port).l
	move.l	(Vscroll_Factor_P2_HInt).w,(VDP_data_port).l

	stopZ80
	dma68kToVDP Sprite_Table_2,VRAM_Sprite_Attribute_Table,VRAM_Sprite_Attribute_Table_Size,VRAM
	startZ80

-	move.w	(VDP_control_port).l,d0
	andi.w	#4,d0
	beq.s	-

	move.w	(VDP_Reg1_val).w,d0
	ori.b	#$40,d0
	move.w	d0,(VDP_control_port).l		; Display enable
	move.l	(sp)+,d0
	movea.l	(sp)+,a5
+
	rte


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; game code

;	I/O init and core routines
	include "_inc/Engine/gfx/PalToCRAM.asm"
	include "_inc/Engine/SndDriverInput.asm"
	include "_inc/Engine/Joypads.asm"
	include "_inc/Engine/gfx/VDPSetup.asm"
	include "_inc/CommonRoutines/gfx/ClearScreen.asm"
	include "_inc/Jumps/SoundDriverLoad.asm"
	include "_inc/Unused/SoundDriverLoadS1.asm"
	include "_inc/CommonRoutines/PlaySound.asm"
	include "_inc/Engine/PauseGame.asm"

;	Graphics transfer, including decompression routines
	include "_inc/CommonRoutines/gfx/PlaneMapToVRAM.asm"
	include "_inc/CommonRoutines/QueueDMATransfer.asm"
	include "_inc/Engine/ProcessDMAQueue.asm"
	include "_inc/Decompression/Nemesis.asm"
	include "_inc/Engine/gfx/PLC Queue.asm"
	include "_inc/Decompression/Enigma.asm"
	include "_inc/Decompression/Kosinski.asm"

;	Palette
	include "_inc/Engine/gfx/PalCycle Load.asm"
	include "levels/tables/PalCycle.asm"
	include "_inc/Objects/SuperSonic PalCycle.asm"
	include "_inc/CommonRoutines/gfx/Palette Fade.asm"
	include "art/palettes/PalPointers.asm"

;	Core gfx/math routines
	include "_inc/Engine/gfx/WaitForVint.asm"
	include "_inc/CommonRoutines/math/RandomNumber.asm"
	include "_inc/CommonRoutines/math/CalcSine.asm"
	include "_inc/CommonRoutines/math/CalcAngle.asm"

;	Game modes
	include "_inc/Game Modes/SegaScreen.asm"
	include "_inc/Game Modes/TitleScreen.asm"
	include "levels/tables/Music 1P.asm"
	include "levels/tables/Music 2P.asm"
	include "_inc/Game Modes/Level.asm"

;	Water routines and data
	include "_inc/Engine/WaterEffects.asm"
	include "levels/tables/WaterHeight.asm"
	include "_inc/Engine/DynamicWater.asm"
	include "levels/tables/DynamicWater.asm"

;	Misc. level gimmicks
	include "_inc/Objects/WindTunnel.asm"
	include "_inc/Objects/OilSlides.asm"

;	Demos
	include "_inc/Engine/DemoMove.asm"
	include "levels/tables/DemoPointers.asm"

;	Collision indices
	include "_inc/Engine/LoadCollisionIndexes.asm"
	include "levels/tables/CollisionIndex.asm"

;	More misc. object code
	include "_inc/Engine/OscNum.asm"
	include "_inc/Objects/ChangeRingFrame.asm"
	include "levels/tables/LevelEndType.asm"
	include "_inc/Objects/SignpostBoundsCheck.asm"

;	Demos
	include "_inc/Demos/DemoMacro.asm"
	include "_inc/Demos/EHZ.asm"
	include "_inc/Demos/CNZ.asm"
	include "_inc/Demos/CPZ.asm"
	include "_inc/Demos/ARZ.asm"

;	Game Modes, with assoc. objects
	include "_inc/Engine/gfx/LoadZoneTiles.asm"
	include "_inc/Game Modes/SpecialStage.asm"
	include "_inc/Game Modes/ContinueScreen.asm"
	include "_inc/Game Modes/TwoPlayerResults.asm"
	include "_inc/Game Modes/MenuScreen.asm"
	include "_inc/Game Modes/Ending.asm"

;	Camera data and routines
	include "_inc/Engine/LevelSize.asm"
	include "levels/tables/StartLocArray.asm"
	include "_inc/Engine/InitCameraValues.asm"
	include "levels/tables/InitCameraPos.asm"
	include "_inc/Engine/gfx/DeformBG.asm"
	include "levels/tables/ScrollManagers.asm"
	include "_inc/Engine/gfx/HorizScrollFlags.asm"
	include "_inc/CommonRoutines/ScrollCamera.asm"
	include "_inc/Engine/gfx/VertiScrollFlags.asm"
	include "_inc/Engine/gfx/BGScrollFlags.asm"

;	Level display and layout routines
	include "_inc/Engine/gfx/DrawLevel.asm"
	include "_inc/Engine/LoadLevelLayout.asm"
	include "_inc/Engine/DynamicLevelEffects.asm"

;	Dynamic level events
	include "levels/tables/events/_DynamicLevelEventIndex.asm"
	include "levels/tables/events/EHZ.asm"
	include "levels/tables/events/LEV1.asm"
	include "levels/tables/events/LEV2.asm"
	include "levels/tables/events/LEV3.asm"
	include "levels/tables/events/MTZ.asm"
	include "levels/tables/events/WFZ.asm"
	include "levels/tables/events/HTZ1.asm"
	include "_inc/CommonRoutines/gfx/ScrollBG.asm"
	include "levels/tables/events/HTZ2.asm"
	include "levels/tables/events/HPZ.asm"
	include "levels/tables/events/LEV9.asm"
	include "levels/tables/events/OOZ.asm"
	include "levels/tables/events/MCZ.asm"
	include "levels/tables/events/CNZ.asm"
	include "levels/tables/events/DEZ.asm"
	include "levels/tables/events/ARZ.asm"
	include "levels/tables/events/SCZ.asm"

;	Misc. stuff
	include "_inc/Jumps/PlayLevelMusic.asm"
	include "_inc/Engine/gfx/LoadPLC_AnimalExplosion.asm"
	include "_inc/Jumps/Misc01.asm"

;	Objects - Platforms 1
	include "_incObj/11 - EHZ & HPZ Bridge.asm"
	include "_incObj/15 - ARZ Swinging Platform.asm"
	include "_incObj/unused/17 - GHZ Log Spikes.asm"
	include "_incObj/18 - ARZ & EHZ & HTZ Floating Platform.asm"
	include "_incObj/1A & 1F - Collapsing Platform.asm"
	include "_incObj/1C - EHZ & HTZ Bridge Stake & OOZ Falling Oil.asm"
	include "_incObj/71 - HPZ Bridge Stake & Orb.asm"
	include "_incObj/2A - MCZ Stomper.asm"
	include "_incObj/2D - CPZ & DEZ One Way Barrier.asm"

;	Objects - Rings, Monitors, & Points
	include "_incObj/28 & 29 - Badnik Points & Animal.asm"
	include "_incObj/25 - Ring.asm"
	include "_incObj/37 - Scattering Rings.asm"
	include "_incObj/unused/Big Ring.asm"
	include "_inc/Objects/Ring Mappings.asm"
	include "_incObj/DC - CNZ Ring Prize.asm"
	include "_incObj/26 & 2E - Monitor.asm"

;	Objects - Title Screen
	include "_incObj/0E - Intro Stars.asm"
	include "_incObj/C9 - Title Palette Handler.asm"
	include "_incObj/0F - Title Menu.asm"

;	Objects - Level Messages
	include "_incObj/34 - Level Title Card.asm"
	include "_incObj/39 - Game & Time Over Text.asm"
	include "_incObj/3A & 6F - Level & Special Stage Results Screen.asm"
	include "_inc/Engine/gfx/Title Cards.asm"

;	Objects - Assorted 1
	include "_incObj/36 - Spikes.asm"
	include "_incObj/unused/3B - Purple Rock.asm"
	include "_incObj/unused/3C - Breakable Wall.asm"

;	Object engine
	include "_inc/Engine/objects/RunObjects.asm"
	include "_incObj/_ObjectArray.asm"
	include "_incObj/_ObjNull.asm"
	include "_inc/Engine/objects/MoveFall.asm"
	include "_inc/Engine/objects/DeleteObject.asm"
	include "_inc/Engine/objects/DisplayObject.asm"
	include "_inc/Engine/objects/RingsManager.asm"
	include "_inc/Objects/CNZBumpers.asm"
	include "_inc/Engine/objects/ObjsManager.asm"
	include "_inc/Objects/CNZ 2P Layout.asm"

;	Objects - Basic, Characters, and Effects
	include "_incObj/41 - Spring.asm"
	include "_incObj/0D - Signpost.asm"
	include "_inc/Engine/objects/SolidObject.asm"
	include "_incObj/01 - Sonic.asm"
	include "_incObj/02 & 05 - Tails.asm"
	include "_incObj/0A - Sonic Bubbles.asm"
	include "_incObj/38 & 35 - Shield & Invincibility.asm"
	include "_incObj/08 - Splash & Dust.asm"
	include "_incObj/7E - Super Sonic Stars.asm"

;	Helper functions for objects
	include "_inc/Engine/objects/AnglePos.asm"
	include "_inc/CommonRoutines/FindTileFloorWall.asm"
	include "_inc/Unused/ConvertCollisionArray.asm"
	include "_inc/CommonRoutines/CalcRoom.asm"

;	Objects - Assorted 2
	include "_incObj/79 - Checkpoint.asm"
	include "_incObj/unused/7D - End Points.asm"
	include "_incObj/44 - CNZ Bumper.asm"
	include "_incObj/24 - ARZ Bubbles.asm"
	include "_incObj/03 - Plane Switcher.asm"
	include "_incObj/0B - CPZ Pipe.asm"
	include "_incObj/unused/0C - CPZ NA Platform.asm"
	include "_incObj/unused/12 - HPZ Emerald.asm"

;	Objects - Water and Lava
	include "_incObj/unused/13 - HPZ Waterfall.asm"
	include "_incObj/04 - Water Surface.asm"
	include "_incObj/49 - EHZ Waterfall.asm"
	include "_incObj/31 - Lava Collision Marker.asm"

;	Objects - Assorted 3
	include "_incObj/74 - Invisible Solid Block.asm"
	include "_incObj/7C - CPZ Pylon.asm"
	include "_incObj/27 - Badnik Explosion.asm"
	include "_incObj/84 - Pinball Mode Switcher.asm"
	include "_incObj/8B - WFZ Palette Handler.asm"

;	Objects - Platforms 2
	include "_incObj/06 - MTZ Rotating Tube & EHZ Spiral Path.asm"
	include "_incObj/14 - HTZ Seesaw.asm"
	include "_incObj/16 - HTZ Diagonal Lift.asm"
	include "_incObj/19 - CPZ & OOZ & WFZ Platform.asm"

;	Objects - Chemical Plant Zone (1)
	include "_incObj/18 - CPZ Speed Booster.asm"
	include "_incObj/1D - CPZ Blue Balls.asm"
	include "_incObj/1E - CPZ Spin Tube.asm"
	
;	Objects - Hill Top Zone
	include "_incObj/20 - HTZ Boss Lava.asm"
	include "_incObj/2F - HTZ Smashable Ground.asm"
	include "_incObj/32 - CPZ & HTZ Breakable Block.asm"
	include "_incObj/30 - HTZ Rising Lava.asm"

;	Objects - Oil Ocean Zone (1)
	include "_incObj/33 - OOZ Green Platform.asm"
	include "_incObj/43 - OOZ Sliding Spike.asm"
	include "_incObj/07 - OOZ Oil Ocean.asm"
	include "_incObj/45 - OOZ Pressure Spring.asm"
	include "_incObj/unused/46 - OOZ Ball.asm"
	include "_incObj/47 - Button.asm"
	include "_incObj/3D - OOZ Launcher Block.asm"
	include "_incObj/48 - OOZ Launcher Ball.asm"

;	Objects - Aquatic Ruin Zone (1)
	include "_incObj/22 - ARZ Arrow Shooter.asm"
	include "_incObj/23 - ARZ Collapsing Pillar.asm"
	include "_incObj/2B - ARZ Rising Pillar.asm"
	include "_incObj/2C - ARZ Leaf Spawner.asm"
	include "_incObj/40 - Diving Board Spring.asm"

;	Objects - Metropolis Zone
	include "_incObj/42 - MTZ Steam Spring.asm"
	include "_incObj/64 - MTZ Twin Stampers.asm"
	include "_incObj/65 - MTZ Long Moving Platform.asm"
	include "_incObj/66 - MTZ Spring Wall.asm"
	include "_incObj/67 - MTZ Spin Tube.asm"
	include "_incObj/68 - MTZ Spike Block.asm"
	include "_incObj/6D - MTZ Floor Spike.asm"
	include "_incObj/69 - MTZ Nut.asm"
	include "_incObj/6A - MTZ Pressure Sensitive Moving Platform.asm"
	include "_incObj/6B - MTZ Immobile Platform.asm"
	include "_incObj/6C - MTZ Pulley Platform.asm"
	include "_incObj/6E - MTZ Platform with Circular Path.asm"
	include "_incObj/70 - MTZ Giant Cog.asm"

;	Objects  - Casino Night Zone (1)
	include "_incObj/72 - CNZ Conveyor Belt.asm"

;	Objects - Mystic Cave Zone (1)
	include "_incObj/unused/73 - MCZ Rotating Ring.asm"
	include "_incObj/75 - MCZ Brick.asm"
	include "_incObj/76 - MCZ Spike Block.asm"
	include "_incObj/77 - MCZ Bridge.asm"

;	Objects - Chemical Plant Zone (2)
	include "_incObj/78 - CPZ Moving Stairs.asm"
	include "_incObj/7A - CPZ Water Platform.asm"
	include "_incObj/7B - CPZ Pipe Exit Spring.asm"

;	Objects - Mystic Cave Zone (2)
	include "_incObj/7F - MCZ Vine Switch.asm"
	include "_incObj/80 - MCZ Moving Vine.asm"
	include "_incObj/81 - MCZ Drawbridge.asm"

;	Objects - Aquatic Ruin Zone (2)
	include "_incObj/82 - ARZ Swinging Platform.asm"
	include "_incObj/83 - ARZ 3 Rotating Platforms.asm"

;	Objects - Oil Ocean Zone (2)
	include "_incObj/3F - OOZ Fan.asm"

;	Objects - Casino Night Zone (2)
	include "_incObj/85 - CNZ Plunger.asm"
	include "_incObj/86 - CNZ Flipper.asm"
	include "_incObj/D2 - CNZ Light Blocks.asm"
	include "_incObj/D3 - CNZ Bomb Prize.asm"
	include "_incObj/D4 - CNZ Big Block.asm"
	include "_incObj/D5 - CNZ Elevator.asm"
	include "_incObj/D6 - CNZ Points Pokey.asm"
	include "_inc/Objects/SlotMachine.asm"
	include "_incObj/D7 - CNZ Bumper.asm"
	include "_incObj/D8 - CNZ Bonus Block.asm"
	include "_incObj/D9 - Grabbable.asm"

;	Objects - Badniks (1)
	include "_incObj/4A - Octus.asm"
	include "_incObj/50 - Aquis.asm"
	include "_incObj/4B - Buzzer.asm"
	include "_incObj/5C - Masher.asm"

;	Objects - Bosses
	include "_incObj/58 - Boss Explosion.asm"
	include "_incObj/5D - CPZ Boss.asm"
	include "_incObj/56 - EHZ Boss.asm"
	include "_incObj/52 - HTZ Boss.asm"
	include "_incObj/89 - ARZ Boss.asm"
	include "_incObj/57 - MCZ Boss.asm"
	include "_incObj/51 - CNZ Boss.asm"
	include "_incObj/54 - MTZ Boss.asm"
	include "_incObj/53 - MTZ Boss Shield.asm"
	include "_incObj/55 - OOZ Boss.asm"

;	Objects - Special Stage
;	some are included from _inc/Game Modes/SpecialStage.asm
	include "_incObj/09 - Special Stage Sonic.asm"
	include "_incObj/63 - Special Stage Shadow.asm"
	include "_incObj/10 & 88 - Special Stage Tails.asm"
	include "_incObj/61 - Special Stage Bombs.asm"
	include "_incObj/60 - Special Stage Rings.asm"
	include "_incObj/5B - Special Stage Ring Spill.asm"
	include "_incObj/5A - Special Stage Checkpoint.asm"
	include "_incObj/59 - Special Stage Emerald.asm"

;	More object engine stuff
	include "_inc/Engine/objects/LoadSubObject.asm"
	include "_incObj/_SubObjArray.asm"
	include "_inc/CommonRoutines/objects/FindNearestPlayer.asm"
	include "_inc/CommonRoutines/objects/CapSpeed.asm"
	include "_inc/CommonRoutines/objects/MoveStop.asm"
	include "_inc/CommonRoutines/objects/AlignChildXY.asm"
	include "_inc/CommonRoutines/objects/DeleteBehindScreen.asm"
	include "_inc/CommonRoutines/objects/CreateProjectiles.asm"
	include "_inc/CommonRoutines/objects/AnimateSprite_Checked.asm"
	include "_inc/CommonRoutines/objects/DeleteOffScreen.asm"

;	Objects - Badniks (2)
	include "_incObj/8C - Whisp.asm"
	include "_incObj/8D & 8F & 90 - Grounder.asm"
	include "_incObj/91 - Chop Chop.asm"
	include "_incObj/92 - Spiker.asm"
	include "_incObj/93 - Spiker Drill.asm"
	include "_incObj/95 - Sol.asm"
	include "_incObj/94 & 96 & 97 - Rexon.asm"
	include "_incObj/98 - Projectile.asm"
	include "_incObj/99 - Nebula.asm"
	include "_incObj/9A - Turtloid.asm"
	include "_incObj/9B - Turtloid Rider.asm"
	include "_incObj/9C - Balkiry Jet.asm" ; has some 9A code/data
	include "_incObj/9D - Coconuts.asm"
	include "_incObj/9E - Crawlton.asm"
	include "_incObj/9F & A0 - Shellcracker.asm"
	include "_incObj/A1 & A2 - Slicer.asm"
	include "_incObj/A3 - Flasher.asm"
	include "_incObj/A4 - Asteron.asm"
	include "_incObj/A5 & A6 - Spiny.asm"
	include "_incObj/A7-AB - Grabber.asm"
	include "_incObj/AC - Balkiry.asm"
	include "_incObj/AD & AE - Clucker.asm"
	include "_incObj/AF - Mecha Sonic.asm"

;	Objects - SEGA Screen
	include "_incObj/B0 & B1 - Sega Screen Objects.asm"

;	Objects - Sky Chase Zone
	include "_incObj/B2 - Tornado.asm"
	include "_incObj/B3 - SCZ Clouds.asm"

;	Objects - Wing Fortress Zone
	include "_incObj/B4 - WFZ Vertical Propeller.asm"
	include "_incObj/B5 - WFZ Horizontal Propeller.asm"
	include "_incObj/B6 - WFZ Tilting Platform.asm"
	include "_incObj/unused/B7 - WFZ Big Laser.asm"
	include "_incObj/B8 - WFZ Wall Turret.asm"
	include "_incObj/B9 - WFZ Intro Laser.asm"
	include "_incObj/BA - WFZ Wheel.asm"
	include "_incObj/unused/BB - WFZ Unknown.asm"
	include "_incObj/BC - WFZ Spaceship Fire.asm"
	include "_incObj/BD - WFZ Metal Platforms.asm"
	include "_incObj/BE - WFZ Lateral Cannon.asm"
	include "_incObj/BF - WFZ Stick Badnik.asm"
	include "_incObj/C0 - WFZ Speed Launcher.asm"
	include "_incObj/C1 - WFZ Breakable Plating.asm"
	include "_incObj/C2 - WFZ Entrance Rivet.asm"
	include "_incObj/C3 & C4 - WFZ Plane Smoke.asm"
	include "_incObj/C5 - WFZ Boss.asm"

;	Objects - Assorted 4 & engine stuff
	include "_incObj/C6 - Eggman.asm"
	include "_incObj/C8 - Crawl.asm"
	include "_incObj/C7 - Death Egg Robot.asm"
	include "_inc/CommonRoutines/gfx/Scale2x.asm"
	include "_incObj/unused/8A - S1 Credits.asm"
	include "_incObj/3E - Egg Prison.asm"
	include "_inc/CommonRoutines/objects/Touch&Hurt.asm"

;	Zone animations
	include "_inc/Engine/gfx/AniArt_Load.asm"
	include "levels/tables/anim/_ZoneAnimTable.asm"
	include "levels/tables/anim/dynamic/_null.asm"
	include "levels/tables/anim/dynamic/HTZ.asm"
	include "levels/tables/anim/dynamic/CNZ.asm"
	include "levels/tables/anim/dynamic/ARZ.asm"
	include "levels/tables/anim/dynamic/_normal.asm"
	include "levels/tables/anim/EHZ.asm"
	include "levels/tables/anim/MTZ.asm"
	include "levels/tables/anim/HTZ.asm"
	include "levels/tables/anim/HPZ.asm"
	include "levels/tables/anim/OOZ.asm"
	include "levels/tables/anim/CNZ.asm"
	include "levels/tables/anim/CNZ_2P.asm"
	include "levels/tables/anim/CPZ.asm"
	include "levels/tables/anim/DEZ.asm"
	include "levels/tables/anim/ARZ.asm"
	include "levels/tables/anim/_null.asm"
	include "_inc/Unused/CPZ Scroll Effect.asm"
	include "levels/tables/anim/APM/_AnimPatMaps.asm"
	include "levels/tables/anim/APM/EHZ.asm"
	include "levels/tables/anim/APM/MTZ.asm"
	include "levels/tables/anim/APM/OOZ.asm"
	include "levels/tables/anim/APM/CNZ.asm"
	include "levels/tables/anim/APM/CNZ_2P.asm"
	include "levels/tables/anim/APM/CPZ.asm"
	include "levels/tables/anim/APM/DEZ.asm"
	include "levels/tables/anim/APM/ARZ.asm"
	include "levels/tables/anim/APM/_null.asm"
	include "levels/tables/anim/APM/HTZ_Patch.asm"

;	HUD stuffs
	include "_inc/Engine/gfx/BuildHUD.asm"
	include "_inc/CommonRoutines/AddPoints.asm"
	include "_inc/Engine/gfx/UpdateHUD.asm"
	include "_inc/Engine/TimeOver.asm"
	include "_inc/Engine/gfx/LoadHUDGFX.asm"

;	Debug Mode
	include "_inc/Engine/DebugMode.asm"
	include "levels/tables/debug/_DbgObjLists.asm"
	include "levels/tables/debug/_default.asm"
	include "levels/tables/debug/EHZ.asm"
	include "levels/tables/debug/MTZ.asm"
	include "levels/tables/debug/WFZ.asm"
	include "levels/tables/debug/HTZ.asm"
	include "levels/tables/debug/HPZ.asm"
	include "levels/tables/debug/OOZ.asm"
	include "levels/tables/debug/MCZ.asm"
	include "levels/tables/debug/CNZ.asm"
	include "levels/tables/debug/CPZ.asm"
	include "levels/tables/debug/ARZ.asm"
	include "levels/tables/debug/SCZ.asm"
	include "_inc/Jumps/Adjust2PArtMode.asm"

;	Pattern Load Cues
	include "levels/tables/ArtPointers.asm"
	include "art/PLCs/_ArtLoadCues.asm"
	include "art/PLCs/Standard1.asm"
	include "art/PLCs/Standard2.asm"
	include "art/PLCs/StandardWater.asm"
	include "art/PLCs/GameOver.asm"
	include "art/PLCs/EHZ1.asm"
	include "art/PLCs/EHZ2.asm"
	include "art/PLCs/Miles1UP.asm"
	include "art/PLCs/MilesLifeCounter.asm"
	include "art/PLCs/Tails1UP.asm"
	include "art/PLCs/TailsLifeCounter.asm"
	include "art/PLCs/MTZ1.asm"
	include "art/PLCs/MTZ2.asm"
	include "art/PLCs/WFZ1.asm"
	include "art/PLCs/WFZ2.asm"
	include "art/PLCs/HTZ1.asm"
	include "art/PLCs/HTZ2.asm"
	include "art/PLCs/HPZ1.asm"
	include "art/PLCs/HPZ2.asm"
	include "art/PLCs/OOZ1.asm"
	include "art/PLCs/OOZ2.asm"
	include "art/PLCs/MCZ1.asm"
	include "art/PLCs/MCZ2.asm"
	include "art/PLCs/CNZ1.asm"
	include "art/PLCs/CNZ2.asm"
	include "art/PLCs/CPZ1.asm"
	include "art/PLCs/CPZ2.asm"
	include "art/PLCs/DEZ1.asm"
	include "art/PLCs/DEZ2.asm"
	include "art/PLCs/ARZ1.asm"
	include "art/PLCs/ARZ2.asm"
	include "art/PLCs/SCZ1.asm"
	include "art/PLCs/SCZ2.asm"
	include "art/PLCs/Results.asm"
	include "art/PLCs/Signpost.asm"
	include "art/PLCs/CPZBoss.asm"
	include "art/PLCs/EHZBoss.asm"
	include "art/PLCs/HTZBoss.asm"
	include "art/PLCs/ARZBoss.asm"
	include "art/PLCs/MCZBoss.asm"
	include "art/PLCs/CNZBoss.asm"
	include "art/PLCs/MTZBoss.asm"
	include "art/PLCs/OOZBoss.asm"
	include "art/PLCs/FireyExplosion.asm"
	include "art/PLCs/DEZBoss.asm"
	include "art/PLCs/EHZAnimals.asm"
	include "art/PLCs/MCZAnimals.asm"
	include "art/PLCs/HTZMTZWFZAnimals.asm"
	include "art/PLCs/DEZAnimals.asm"
	include "art/PLCs/HPZAnimals.asm"
	include "art/PLCs/OOZAnimals.asm"
	include "art/PLCs/SCZAnimals.asm"
	include "art/PLCs/CNZAnimals.asm"
	include "art/PLCs/CPZAnimals.asm"
	include "art/PLCs/ARZAnimals.asm"
	include "art/PLCs/SpecialStage.asm"
	include "art/PLCs/SpecialStageBombs.asm"
	include "art/PLCs/WFZBoss.asm"
	include "art/PLCs/Tornado.asm"
	include "art/PLCs/EggPrison.asm"
	include "art/PLCs/Explosion.asm"
	include "art/PLCs/TailsResults.asm"
	include "_inc/Unused/Duplicate PLCs.asm"

;	Data
	include "_inc/BinIncludes/collision.asm"
	include "_inc/BinIncludes/layout.asm"
	include "_inc/BinIncludes/uncompressed.asm"
	include "_inc/BinIncludes/sprites1.asm"
	include "_inc/BinIncludes/levelart.asm"
	include "_inc/BinIncludes/specialstage.asm"
	include "_inc/BinIncludes/levelrings.asm"
	include "_inc/BinIncludes/levelobjects.asm"
	include "_inc/Engine/SoundDriverLoad.asm"
	include "_inc/BinIncludes/dacsamples.asm"
	include "_inc/BinIncludes/music1.asm"
	finishBank
	include "_inc/BinIncludes/sprites2.asm"
	include "_inc/BinIncludes/segasnd.asm"
	include "_inc/BinIncludes/music2.asm"
	include "_inc/BinIncludes/sfx.asm"
	finishBank

; end of 'ROM'
	if padToPowerOfTwo && (*)&(*-1)
		cnop	-1,2<<lastbit(*-1)
		dc.b	0
paddingSoFar	:= paddingSoFar+1
	else
		even
	endif
	if MOMPASS=2
		; "About" because it will be off by the same amount that Size_of_Snd_driver_guess is incorrect (if you changed it), and because I may have missed a small amount of internal padding somewhere
		message "ROM size is $\{*} bytes (\{*/1024.0} kb). About $\{paddingSoFar} bytes are padding. "
	endif
	; share these symbols externally (WARNING: don't rename, move or remove these labels!)
	shared word_728C_user,Obj5F_MapUnc_7240,off_3A294,MapRUnc_Sonic,movewZ80CompSize
EndOfRom:
	END
