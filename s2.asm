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
	include "levels/asm/PalCycle.asm"
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
	include "levels/asm/Music 1P.asm"
	include "levels/asm/Music 2P.asm"
	include "_inc/Game Modes/Level.asm"

;	Water routines and data
	include "_inc/Engine/WaterEffects.asm"
	include "levels/asm/WaterHeight.asm"
	include "_inc/Engine/DynamicWater.asm"
	include "levels/asm/DynamicWater.asm"

;	Misc. level gimmicks
	include "_inc/Objects/WindTunnel.asm"
	include "_inc/Objects/OilSlides.asm"

;	Demos
	include "_inc/Engine/DemoMove.asm"
	include "levels/asm/DemoPointers.asm"

;	Collision indices
	include "_inc/Engine/LoadCollisionIndexes.asm"
	include "levels/asm/CollisionIndex.asm"

;	More misc. object code
	include "_inc/Engine/OscNum.asm"
	include "_inc/Objects/ChangeRingFrame.asm"
	include "levels/asm/LevelEndType.asm"
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
	include "levels/asm/StartLocArray.asm"
	include "_inc/Engine/InitCameraValues.asm"
	include "levels/asm/InitCameraPos.asm"
	include "_inc/Engine/gfx/DeformBG.asm"
	include "levels/asm/ScrollManagers.asm"
	include "_inc/Engine/gfx/HorizScrollFlags.asm"
	include "_inc/CommonRoutines/ScrollCamera.asm"
	include "_inc/Engine/gfx/VertiScrollFlags.asm"
	include "_inc/Engine/gfx/BGScrollFlags.asm"

;	Level display and layout routines
	include "_inc/Engine/gfx/DrawLevel.asm"
	include "_inc/Engine/LoadLevelLayout.asm"
	include "_inc/Engine/DynamicLevelEffects.asm"
	include "levels/asm/Events.asm"
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
	include "levels/asm/CNZ 2P Layout.asm"

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

; ---------------------------------------------------------------------------
; ZONE ANIMATION PROCEDURES AND SCRIPTS
;
; Each zone gets two entries in this jump table. The first entry points to the
; zone's animation procedure (usually Dynamic_Normal, but some zones have special
; procedures for complicated animations). The second points to the zone's animation
; script.
;
; Note that Animated_Null is not a valid animation script, so don't pair it up
; with anything except Dynamic_Null, or bad things will happen (for example, a bus error exception).
; ---------------------------------------------------------------------------
PLC_DYNANM: zoneOrderedOffsetTable 2,2		; Zone ID
	zoneOffsetTableEntry.w Dynamic_Normal	; $00
	zoneOffsetTableEntry.w Animated_EHZ

	zoneOffsetTableEntry.w Dynamic_Null	; $01
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_Null	; $02
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_Null	; $03
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_Normal	; $04
	zoneOffsetTableEntry.w Animated_MTZ

	zoneOffsetTableEntry.w Dynamic_Normal	; $05
	zoneOffsetTableEntry.w Animated_MTZ

	zoneOffsetTableEntry.w Dynamic_Null	; $06
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_HTZ	; $07
	zoneOffsetTableEntry.w Animated_HTZ

	zoneOffsetTableEntry.w Dynamic_Normal	; $08
	zoneOffsetTableEntry.w Animated_HPZ

	zoneOffsetTableEntry.w Dynamic_Null	; $09
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_Normal	; $0A
	zoneOffsetTableEntry.w Animated_OOZ

	zoneOffsetTableEntry.w Dynamic_Null	; $0B
	zoneOffsetTableEntry.w Animated_Null

	zoneOffsetTableEntry.w Dynamic_CNZ	; $0C
	zoneOffsetTableEntry.w Animated_CNZ

	zoneOffsetTableEntry.w Dynamic_Normal	; $0D
	zoneOffsetTableEntry.w Animated_CPZ

	zoneOffsetTableEntry.w Dynamic_Normal	; $0E
	zoneOffsetTableEntry.w Animated_DEZ

	zoneOffsetTableEntry.w Dynamic_ARZ	; $0F
	zoneOffsetTableEntry.w Animated_ARZ

	zoneOffsetTableEntry.w Dynamic_Null	; $10
	zoneOffsetTableEntry.w Animated_Null
    zoneTableEnd
; ===========================================================================

Dynamic_Null:
	rts
; ===========================================================================

Dynamic_HTZ:
	tst.w	(Two_player_mode).w
	bne.w	Dynamic_Normal
	lea	(Anim_Counters).w,a3
	moveq	#0,d0
	move.w	(Camera_X_pos).w,d1
	neg.w	d1
	asr.w	#3,d1
	move.w	(Camera_X_pos).w,d0
	lsr.w	#4,d0
	add.w	d1,d0
	subi.w	#$10,d0
	divu.w	#$30,d0
	swap	d0
	cmp.b	1(a3),d0
	beq.s	BranchTo_loc_3FE5C
	move.b	d0,1(a3)
	move.w	d0,d2
	andi.w	#7,d0
	add.w	d0,d0
	add.w	d0,d0
	add.w	d0,d0
	move.w	d0,d1
	add.w	d0,d0
	add.w	d1,d0
	andi.w	#$38,d2
	lsr.w	#2,d2
	add.w	d2,d0
	lea	word_3FD9C(pc,d0.w),a4
	moveq	#5,d5
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_HTZMountains),d4

loc_3FD7C:
	moveq	#-1,d1
	move.w	(a4)+,d1
	andi.l	#$FFFFFF,d1
	move.w	d4,d2
	moveq	#tiles_to_bytes(4)/2,d3	; DMA transfer length (in words)
	jsr	(QueueDMATransfer).l
	addi.w	#$80,d4
	dbf	d5,loc_3FD7C

BranchTo_loc_3FE5C 
	bra.w	loc_3FE5C
; ===========================================================================
; HTZ mountain art main RAM addresses?
word_3FD9C:
	dc.w   $80, $180, $280, $580, $600, $700	; 6
	dc.w   $80, $180, $280, $580, $600, $700	; 12
	dc.w  $980, $A80, $B80, $C80, $D00, $D80	; 18
	dc.w  $980, $A80, $B80, $C80, $D00, $D80	; 24
	dc.w  $E80,$1180,$1200,$1280,$1300,$1380	; 30
	dc.w  $E80,$1180,$1200,$1280,$1300,$1380	; 36
	dc.w $1400,$1480,$1500,$1580,$1600,$1900	; 42
	dc.w $1400,$1480,$1500,$1580,$1600,$1900	; 48
	dc.w $1D00,$1D80,$1E00,$1F80,$2400,$2580	; 54
	dc.w $1D00,$1D80,$1E00,$1F80,$2400,$2580	; 60
	dc.w $2600,$2680,$2780,$2B00,$2F00,$3280	; 66
	dc.w $2600,$2680,$2780,$2B00,$2F00,$3280	; 72
	dc.w $3600,$3680,$3780,$3C80,$3D00,$3F00	; 78
	dc.w $3600,$3680,$3780,$3C80,$3D00,$3F00	; 84
	dc.w $3F80,$4080,$4480,$4580,$4880,$4900	; 90
	dc.w $3F80,$4080,$4480,$4580,$4880,$4900	; 96
; ===========================================================================

loc_3FE5C:
	lea	(TempArray_LayerDef).w,a1
	move.w	(Camera_X_pos).w,d2
	neg.w	d2
	asr.w	#3,d2
	move.l	a2,-(sp)
	lea	(ArtUnc_HTZClouds).l,a0
	lea	(Chunk_Table+$7C00).l,a2
	moveq	#$F,d1

loc_3FE78:
	move.w	(a1)+,d0
	neg.w	d0
	add.w	d2,d0
	andi.w	#$1F,d0
	lsr.w	#1,d0
	bcc.s	loc_3FE8A
	addi.w	#$200,d0

loc_3FE8A:
	lea	(a0,d0.w),a4
	lsr.w	#1,d0
	bcs.s	loc_3FEB4
	move.l	(a4)+,(a2)+
	adda.w	#$3C,a2
	move.l	(a4)+,(a2)+
	adda.w	#$3C,a2
	move.l	(a4)+,(a2)+
	adda.w	#$3C,a2
	move.l	(a4)+,(a2)+
	suba.w	#$C0,a2
	adda.w	#$20,a0
	dbf	d1,loc_3FE78
	bra.s	loc_3FEEC
; ===========================================================================

loc_3FEB4:
    rept 3
      rept 4
	move.b	(a4)+,(a2)+
      endm
	adda.w	#$3C,a2
    endm
    rept 4
	move.b	(a4)+,(a2)+
    endm
	suba.w	#$C0,a2
	adda.w	#$20,a0
	dbf	d1,loc_3FE78

loc_3FEEC:
	move.l	#(Chunk_Table+$7C00) & $FFFFFF,d1
	move.w	#tiles_to_bytes(ArtTile_ArtUnc_HTZClouds),d2
	move.w	#tiles_to_bytes(8)/2,d3	; DMA transfer length (in words)
	jsr	(QueueDMATransfer).l
	movea.l	(sp)+,a2
	addq.w	#2,a3
	bra.w	loc_3FF30
; ===========================================================================

Dynamic_CNZ:
	tst.b	(Current_Boss_ID).w
	beq.s	+
	rts
; ---------------------------------------------------------------------------
+
	lea	(Animated_CNZ).l,a2
	tst.w	(Two_player_mode).w
	beq.s	Dynamic_Normal
	lea	(Animated_CNZ_2P).l,a2
	bra.s	Dynamic_Normal
; ===========================================================================

Dynamic_ARZ:
	tst.b	(Current_Boss_ID).w
	beq.s	Dynamic_Normal
	rts
; ===========================================================================

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
; ===========================================================================
; ZONE ANIMATION SCRIPTS
;
; The Dynamic_Normal subroutine uses these scripts to reload certain tiles,
; thus animating them. All the relevant art must be uncompressed, because
; otherwise the subroutine would spend so much time waiting for the art to be
; decompressed that the VBLANK window would close before all the animating was done.

;    zoneanimdecl -1, ArtUnc_Flowers1, ArtTile_ArtUnc_Flowers1, 6, 2
;	-1			Global frame duration. If -1, then each frame will use its own duration, instead
;	ArtUnc_Flowers1		Source address
;	ArtTile_ArtUnc_Flowers1	Destination VRAM address
;	6			Number of frames
;	2			Number of tiles to load into VRAM for each frame

;    dc.b   0,$7F		; Start of the script proper
;	0			Tile ID of first tile in ArtUnc_Flowers1 to transfer
;	$7F			Frame duration. Only here if global duration is -1

; loc_3FF94:
Animated_EHZ:	zoneanimstart
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers1, ArtTile_ArtUnc_Flowers1, 6, 2
	dc.b   0,$7F		; Start of the script proper
	dc.b   2,$13
	dc.b   0,  7
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2,  7
	even
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers2, ArtTile_ArtUnc_Flowers2, 8, 2
	dc.b   2,$7F
	dc.b   0, $B
	dc.b   2, $B
	dc.b   0, $B
	dc.b   2,  5
	dc.b   0,  5
	dc.b   2,  5
	dc.b   0,  5
	even
	; Flowers
	zoneanimdecl 7, ArtUnc_Flowers3, ArtTile_ArtUnc_Flowers3, 2, 2
	dc.b   0
	dc.b   2
	even
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers4, ArtTile_ArtUnc_Flowers4, 8, 2
	dc.b   0,$7F
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2, $B
	dc.b   0, $B
	dc.b   2, $B
	even
	; Pulsing thing against checkered background
	zoneanimdecl -1, ArtUnc_EHZPulseBall, ArtTile_ArtUnc_EHZPulseBall, 6, 2
	dc.b   0,$17
	dc.b   2,  9
	dc.b   4, $B
	dc.b   6,$17
	dc.b   4, $B
	dc.b   2,  9
	even

	zoneanimend

Animated_MTZ:	zoneanimstart
	; Spinning metal cylinder
	zoneanimdecl 0, ArtUnc_MTZCylinder, ArtTile_ArtUnc_MTZCylinder, 8,$10
	dc.b   0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $40
	dc.b $50
	dc.b $60
	dc.b $70
	even
	; lava
	zoneanimdecl $D, ArtUnc_Lava, ArtTile_ArtUnc_Lava, 6,$C
	dc.b   0
	dc.b  $C
	dc.b $18
	dc.b $24
	dc.b $18
	dc.b  $C
	even
	; MTZ background animated section
	zoneanimdecl -1, ArtUnc_MTZAnimBack, ArtTile_ArtUnc_MTZAnimBack_1, 4, 6
	dc.b   0,$13
	dc.b   6,  7
	dc.b  $C,$13
	dc.b   6,  7
	even
	; MTZ background animated section
	zoneanimdecl -1, ArtUnc_MTZAnimBack, ArtTile_ArtUnc_MTZAnimBack_2, 4, 6
	dc.b  $C,$13
	dc.b   6,  7
	dc.b   0,$13
	dc.b   6,  7
	even

	zoneanimend

Animated_HTZ:	zoneanimstart
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers1, ArtTile_ArtUnc_Flowers1, 6, 2
	dc.b   0,$7F
	dc.b   2,$13
	dc.b   0,  7
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2,  7
	even
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers2, ArtTile_ArtUnc_Flowers2, 8, 2
	dc.b   2,$7F
	dc.b   0, $B
	dc.b   2, $B
	dc.b   0, $B
	dc.b   2,  5
	dc.b   0,  5
	dc.b   2,  5
	dc.b   0,  5
	even
	; Flowers
	zoneanimdecl 7, ArtUnc_Flowers3, ArtTile_ArtUnc_Flowers3, 2, 2
	dc.b   0
	dc.b   2
	even
	; Flowers
	zoneanimdecl -1, ArtUnc_Flowers4, ArtTile_ArtUnc_Flowers4, 8, 2
	dc.b   0,$7F
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2,  7
	dc.b   0,  7
	dc.b   2, $B
	dc.b   0, $B
	dc.b   2, $B
	even
	; Pulsing thing against checkered background
	zoneanimdecl -1, ArtUnc_EHZPulseBall, ArtTile_ArtUnc_EHZPulseBall, 6, 2
	dc.b   0,$17
	dc.b   2,  9
	dc.b   4, $B
	dc.b   6,$17
	dc.b   4, $B
	dc.b   2,  9
	even

	zoneanimend

; word_4009C: Animated_OOZ:
Animated_HPZ:	zoneanimstart
	; Supposed to be the pulsing orb from HPZ, but uses OOZ's pulsing ball art
	zoneanimdecl 8, ArtUnc_HPZPulseOrb, ArtTile_ArtUnc_HPZPulseOrb_1, 6, 8
	dc.b   0
	dc.b   0
	dc.b   8
	dc.b $10
	dc.b $10
	dc.b   8
	even
	; Supposed to be the pulsing orb from HPZ, but uses OOZ's pulsing ball art
	zoneanimdecl 8, ArtUnc_HPZPulseOrb, ArtTile_ArtUnc_HPZPulseOrb_2, 6, 8
	dc.b   8
	dc.b $10
	dc.b $10
	dc.b   8
	dc.b   0
	dc.b   0
	even
	; Supposed to be the pulsing orb from HPZ, but uses OOZ's pulsing ball art
	zoneanimdecl 8, ArtUnc_HPZPulseOrb, ArtTile_ArtUnc_HPZPulseOrb_3, 6, 8
	dc.b $10
	dc.b   8
	dc.b   0
	dc.b   0
	dc.b   8
	dc.b $10
	even

	zoneanimend

; word_400C8:  Animated_OOZ2:
Animated_OOZ:	zoneanimstart
	; Pulsing ball from OOZ
	zoneanimdecl -1, ArtUnc_OOZPulseBall, ArtTile_ArtUnc_OOZPulseBall, 4, 4
	dc.b   0, $B
	dc.b   4,  5
	dc.b   8,  9
	dc.b   4,  3
	even
	; Square rotating around ball in OOZ
	zoneanimdecl 6, ArtUnc_OOZSquareBall1, ArtTile_ArtUnc_OOZSquareBall1, 4, 4
	dc.b   0
	dc.b   4
	dc.b   8
	dc.b  $C
	even
	; Square rotating around ball
	zoneanimdecl 6, ArtUnc_OOZSquareBall2, ArtTile_ArtUnc_OOZSquareBall2, 4, 4
	dc.b   0
	dc.b   4
	dc.b   8
	dc.b  $C
	even
	; Oil
	zoneanimdecl $11, ArtUnc_Oil1, ArtTile_ArtUnc_Oil1, 6,$10
	dc.b   0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $20
	dc.b $10
	even
	; Oil
	zoneanimdecl $11, ArtUnc_Oil2, ArtTile_ArtUnc_Oil2, 6,$10
	dc.b   0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $20
	dc.b $10
	even

	zoneanimend

Animated_CNZ:	zoneanimstart
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_2, $10,$10
	dc.b   0,$C7
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,$C7
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	dc.b   0,  5
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,  5
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	even
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_1, $10,$10
	dc.b $70,  5
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,  5
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	dc.b $70,$C7
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,$C7
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	even

	zoneanimend

; word_40160:
Animated_CNZ_2P:	zoneanimstart
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_2_2p, $10,$10
	dc.b   0,$C7
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,$C7
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	dc.b   0,  5
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,  5
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	even
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_1_2p, $10,$10
	dc.b $70,  5
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,  5
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	dc.b $70,$C7
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,$C7
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	even

	zoneanimend

Animated_CPZ:	zoneanimstart
	; Animated background section in CPZ and DEZ
	zoneanimdecl 4, ArtUnc_CPZAnimBack, ArtTile_ArtUnc_CPZAnimBack, 8, 2
	dc.b   0
	dc.b   2
	dc.b   4
	dc.b   6
	dc.b   8
	dc.b  $A
	dc.b  $C
	dc.b  $E
	even

	zoneanimend

Animated_DEZ:	zoneanimstart
	; Animated background section in CPZ and DEZ
	zoneanimdecl 4, ArtUnc_CPZAnimBack, ArtTile_ArtUnc_DEZAnimBack, 8, 2
	dc.b   0
	dc.b   2
	dc.b   4
	dc.b   6
	dc.b   8
	dc.b  $A
	dc.b  $C
	dc.b  $E
	even

	zoneanimend

Animated_ARZ:	zoneanimstart
	; Waterfall patterns
	zoneanimdecl 5, ArtUnc_Waterfall1, ArtTile_ArtUnc_Waterfall1_2, 2, 4
	dc.b   0
	dc.b   4
	even
	; Waterfall patterns
	zoneanimdecl 5, ArtUnc_Waterfall1, ArtTile_ArtUnc_Waterfall1_1, 2, 4
	dc.b   4
	dc.b   0
	even
	; Waterfall patterns
	zoneanimdecl 5, ArtUnc_Waterfall2, ArtTile_ArtUnc_Waterfall2, 2, 4
	dc.b   0
	dc.b   4
	even
	; Waterfall patterns
	zoneanimdecl 5, ArtUnc_Waterfall3, ArtTile_ArtUnc_Waterfall3, 2, 4
	dc.b   0
	dc.b   4
	even

	zoneanimend

Animated_Null:
	; invalid
; ===========================================================================

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

; --------------------------------------------------------------------------------------
; Animated Pattern Mappings (16x16)
; --------------------------------------------------------------------------------------
; off_40350:
AnimPatMaps: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w APM_EHZ		;  0
	zoneOffsetTableEntry.w APM_Null		;  1
	zoneOffsetTableEntry.w APM_Null		;  2
	zoneOffsetTableEntry.w APM_Null		;  3
	zoneOffsetTableEntry.w APM_MTZ		;  4
	zoneOffsetTableEntry.w APM_MTZ		;  5
	zoneOffsetTableEntry.w APM_Null		;  6
	zoneOffsetTableEntry.w APM_EHZ		;  7
	zoneOffsetTableEntry.w APM_HPZ		;  8
	zoneOffsetTableEntry.w APM_Null		;  9
	zoneOffsetTableEntry.w APM_OOZ		; $A
	zoneOffsetTableEntry.w APM_Null		; $B
	zoneOffsetTableEntry.w APM_CNZ		; $C
	zoneOffsetTableEntry.w APM_CPZ		; $D
	zoneOffsetTableEntry.w APM_DEZ		; $E
	zoneOffsetTableEntry.w APM_ARZ		; $F
	zoneOffsetTableEntry.w APM_Null		;$10
    zoneTableEnd

begin_animpat macro {INTLABEL}
__LABEL__ label *
__LABEL___Len := __LABEL___End - __LABEL___Blocks
	dc.w $1800 - __LABEL___Len
	dc.w bytesToWcnt(__LABEL___Len)
__LABEL___Blocks:
    endm

; byte_40372:
APM_EHZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$0 ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$4 ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$1 ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$5 ,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$8 ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$C ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$9 ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$D ,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$10,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$14,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$11,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$15,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$2 ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$6 ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$3 ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$7 ,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$A ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$E ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$B ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$F ,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$12,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$16,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$13,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$17,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$18,0,0,3,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$1A,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$19,0,0,3,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$1B,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$1C,0,0,3,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$1E,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZMountains+$1D,0,0,3,0),make_block_tile(ArtTile_ArtUnc_EHZMountains+$1F,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$0,1,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$1,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$1,1,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtKos_Checkers+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_Checkers+$1,0,0,2,0),make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$1,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$0,1,0,2,0),make_block_tile(ArtTile_ArtKos_Checkers+$0,1,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_EHZPulseBall+$1,1,0,2,0),make_block_tile(ArtTile_ArtKos_Checkers+$1,1,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Flowers1+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_Flowers1+$0,1,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Flowers1+$1,0,0,3,0),make_block_tile(ArtTile_ArtUnc_Flowers1+$1,1,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Flowers2+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_Flowers2+$0,1,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Flowers2+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_Flowers2+$1,1,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Flowers3+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_Flowers3+$0,1,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Flowers3+$1,0,0,3,0),make_block_tile(ArtTile_ArtUnc_Flowers3+$1,1,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Flowers4+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_Flowers4+$0,1,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Flowers4+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_Flowers4+$1,1,0,3,1)
APM_EHZ_End:



; byte_403EE:
APM_MTZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$0,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$0,1,0,1,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$1,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$1,1,0,1,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$2,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$2,1,0,1,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$3,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$3,1,0,1,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$E,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$E,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$F,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$F,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$C,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$C,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$D,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$D,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$A,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$A,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$B,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$B,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$8,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$8,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$9,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$9,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$6,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$6,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$7,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$7,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$4,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$4,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$5,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$5,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$2,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$2,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$3,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$3,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$1,0,0,3,0),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$1,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$4,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$4,1,0,1,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$5,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_1+$5,1,0,1,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$0,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$0,1,0,1,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$1,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$1,1,0,1,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$2,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$2,1,0,1,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$3,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$3,1,0,1,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$4,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$4,1,0,1,0)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$5,0,0,1,0),make_block_tile(ArtTile_ArtUnc_MTZAnimBack_2+$5,1,0,1,0)
	
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,1),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Lava+$0    ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Lava+$1    ,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,1),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Lava+$2    ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Lava+$3    ,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Lava+$4    ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Lava+$5    ,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Lava+$8    ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Lava+$9    ,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Lava+$6    ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Lava+$7    ,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Lava+$A    ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Lava+$B    ,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$E,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$E,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$F,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$F,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$C,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$C,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$D,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$D,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$A,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$A,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$B,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$B,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$8,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$8,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$9,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$9,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$6,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$6,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$7,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$7,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$4,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$4,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$5,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$5,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$2,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$3,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$3,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$0,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_MTZCylinder+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_MTZCylinder+$1,0,0,3,1)
APM_MTZ_End:



; byte_404C2:
APM_HPZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$1,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$2,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$3,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$4,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$5,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$6,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$7,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$1,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$2,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$3,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$4,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$5,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$6,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$7,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$1,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$2,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$3,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$4,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$5,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$6,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$7,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$2,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$3,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$4,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$5,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$6,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$7,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$2,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$3,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$4,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$5,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$6,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$7,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$2,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$3,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$4,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$5,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$6,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$7,0,0,2,0)
	
    if gameRevision<2
	; In REV02, for some reason these blank tiles' palette line was changed to lines 3 and 4.
	; This is consistent with MTZ's blank tiles.
	; Notably, the new palette lines' first entry always happens to match the current VDP background colour.
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$2,0,0,3,0)
    else
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$2,0,0,3,0)
    endif
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$1,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$4,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$3,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$6,0,0,3,0)

    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$5,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$7,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$2,0,0,3,0)
    else
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$5,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$7,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$2,0,0,3,0)
    endif
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$1,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$4,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$3,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$6,0,0,3,0)
	
    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$5,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$7,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$2,0,0,3,0)
    else
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$5,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$7,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$2,0,0,3,0)
    endif
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$1,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$4,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$3,0,0,3,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$6,0,0,3,0)
	
    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$5,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$7,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$2,0,0,2,0)
    else
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$5,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$7,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$2,0,0,2,0)
    endif
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$1,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$4,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$3,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$6,0,0,2,0)
	
    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$5,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$7,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$2,0,0,2,0)
    else
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$5,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_1+$7,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$2,0,0,2,0)
    endif
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$1,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$4,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$3,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$6,0,0,2,0)
	
    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$5,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$7,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$2,0,0,2,0)
    else
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$5,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_2+$7,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$2,0,0,2,0)
    endif
	
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$1,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$4,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$3,0,0,2,0),make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$6,0,0,2,0)
	
    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$5,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$7,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
    else
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$5,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_HPZPulseOrb_3+$7,0,0,2,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
    endif
APM_HPZ_End:



; byte_405B6:
APM_OOZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_OOZPulseBall+$0,0,0,0,1),make_block_tile(ArtTile_ArtUnc_OOZPulseBall+$2,0,0,0,1)
	dc.w make_block_tile(ArtTile_ArtUnc_OOZPulseBall+$1,0,0,0,1),make_block_tile(ArtTile_ArtUnc_OOZPulseBall+$3,0,0,0,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall1+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_OOZSquareBall1+$1,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall1+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_OOZSquareBall1+$3,0,0,3,1)
	
    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$2,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$1,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$3,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
    else
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$2,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$1,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$3,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
    endif
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$0,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$1,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$8,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$9,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$2,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$3,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$A,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$B,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$4,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$5,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$C,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$D,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$6,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$7,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$E,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$F,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$0,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$1,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$8,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$9,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$2,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$3,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$A,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$B,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$4,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$5,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$C,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$D,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$6,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$7,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$E,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$F,0,0,2,1)
APM_OOZ_End:



; byte_4061A:
APM_CNZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$4,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$1,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$5,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$8,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$C,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$9,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$D,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$2,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$6,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$3,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$7,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$A,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$E,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$B,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1+$F,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$4,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$1,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$5,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$8,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$C,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$9,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$D,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$2,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$6,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$3,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$7,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$A,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$E,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$B,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2+$F,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$4,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$1,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$5,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$8,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$C,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$9,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$D,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$2,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$6,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$3,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$7,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$A,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$E,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$B,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3+$F,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$4,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$5,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$8,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$C,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$9,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$D,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$6,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$3,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$7,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$A,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$E,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$B,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2+$F,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$4,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$5,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$8,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$C,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$9,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$D,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$6,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$3,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$7,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$A,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$E,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$B,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1+$F,0,0,3,1)
APM_CNZ_End:



; byte_406BE:
APM_CNZ2P:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$4,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$1,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$5,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$8,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$C,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$9,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$D,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$2,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$6,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$3,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$7,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$A,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$E,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$B,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_1_2p+$F,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$4,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$1,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$5,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$8,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$C,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$9,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$D,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$2,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$6,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$3,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$7,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$A,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$E,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$B,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_2_2p+$F,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$4,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$1,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$5,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$8,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$C,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$9,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$D,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$2,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$6,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$3,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$7,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$A,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$E,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$B,0,0,0,0),make_block_tile(ArtTile_ArtUnc_CNZSlotPics_3_2p+$F,0,0,0,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$4,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$5,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$8,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$C,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$9,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$D,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$6,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$3,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$7,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$A,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$E,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$B,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_2_2p+$F,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$4,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$1,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$5,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$8,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$C,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$9,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$D,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$6,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$3,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$7,0,0,3,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$A,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$E,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$B,0,0,3,1),make_block_tile(ArtTile_ArtUnc_CNZFlipTiles_1_2p+$F,0,0,3,1)
APM_CNZ2P_End:



; byte_40762:
APM_CPZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_CPZAnimBack+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_CPZAnimBack+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_CPZAnimBack+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_CPZAnimBack+$1,0,0,2,0)
APM_CPZ_End:



; byte_4076E:
APM_DEZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_DEZAnimBack+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_DEZAnimBack+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_DEZAnimBack+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_DEZAnimBack+$1,0,0,2,0)
APM_DEZ_End:



; byte_4077A:
APM_ARZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall3+$0  ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall3+$1  ,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall3+$2  ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall3+$3  ,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall2+$0  ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall2+$1  ,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall2+$2  ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall2+$3  ,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$0,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$1,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$2,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$3,0,0,2,1)
	
    if 1==0
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$0,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$1,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$2,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$3,0,0,2,1)
    else
	; These are invalid animation entries for waterfalls (bug in original game):
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$C,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$D,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$E,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$F,0,0,2,1)
    endif
	
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall3+$0  ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall3+$1  ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall3+$2  ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall3+$3  ,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall2+$0  ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall2+$1  ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall2+$2  ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall2+$3  ,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$2,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$3,0,0,2,0)
	
    if 1==0
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$2,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$3,0,0,2,0)
    else
	; These are invalid animation entries for waterfalls (bug in original game):
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$C,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$D,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$E,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$F,0,0,2,0)
    endif
APM_ARZ_End:



; byte_407BE:
APM_Null:	dc.w   0
; ===========================================================================
; loc_407C0:
PatchHTZTiles:
	lea	(ArtNem_HTZCliffs).l,a0
	lea	(Object_RAM+$800).w,a4
	jsrto	(NemDecToRAM).l, JmpTo2_NemDecToRAM
	lea	(Object_RAM+$800).w,a1
	lea_	word_3FD9C,a4
	moveq	#0,d2
	moveq	#7,d4

loc_407DA:
	moveq	#5,d3

loc_407DC:
	moveq	#-1,d0
	move.w	(a4)+,d0
	movea.l	d0,a2
	moveq	#$1F,d1

loc_407E4:
	move.l	(a1),(a2)+
	move.l	d2,(a1)+
	dbf	d1,loc_407E4
	dbf	d3,loc_407DC
	adda.w	#$C,a4
	dbf	d4,loc_407DA
	rts
; ===========================================================================

    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo2_NemDecToRAM 
	jmp	(NemDecToRAM).l

	align 4
    endif




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

; ---------------------------------------------------------------------------
; Add points subroutine
; subroutine to add to Player 1's score
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_40D06:
AddPoints:
	move.b	#1,(Update_HUD_score).w
	lea	(Score).w,a3
	add.l	d0,(a3)	; add d0*10 to the score
	move.l	#999999,d1
	cmp.l	(a3),d1	; is #999999 higher than the score?
	bhi.s	+	; if yes, branch
	move.l	d1,(a3)	; set score to #999999
+
	move.l	(a3),d0
	cmp.l	(Next_Extra_life_score).w,d0
	blo.s	+	; rts
	addi.l	#5000,(Next_Extra_life_score).w
	addq.b	#1,(Life_count).w
	addq.b	#1,(Update_HUD_lives).w
	move.w	#MusID_ExtraLife,d0
	jmp	(PlayMusic).l
; ===========================================================================
+	rts
; End of function AddPoints


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; ---------------------------------------------------------------------------
; Add points subroutine
; subroutine to add to Player 2's score
; (goes to AddPoints to add to Player 1's score instead if this is not Player 2)
; ---------------------------------------------------------------------------

; sub_40D42:
AddPoints2:
	tst.w	(Two_player_mode).w
	beq.s	AddPoints
	cmpa.w	#MainCharacter,a3
	beq.s	AddPoints
	move.b	#1,(Update_HUD_score_2P).w
	lea	(Score_2P).w,a3
	add.l	d0,(a3)	; add d0*10 to the score
	move.l	#999999,d1
	cmp.l	(a3),d1	; is #999999 higher than the score?
	bhi.s	+	; if yes, branch
	move.l	d1,(a3)	; set score to #999999
+
	move.l	(a3),d0
	cmp.l	(Next_Extra_life_score_2P).w,d0
	blo.s	+	; rts
	addi.l	#5000,(Next_Extra_life_score_2P).w
	addq.b	#1,(Life_count_2P).w
	addq.b	#1,(Update_HUD_lives_2P).w
	move.w	#MusID_ExtraLife,d0
	jmp	(PlayMusic).l
; ===========================================================================
+	rts
; End of function AddPoints2

; ---------------------------------------------------------------------------
; Subroutine to update the HUD
; ---------------------------------------------------------------------------

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_40D8A:
HudUpdate:
	nop
	lea	(VDP_data_port).l,a6
	tst.w	(Two_player_mode).w
	bne.w	loc_40F50
	tst.w	(Debug_mode_flag).w	; is debug mode on?
	bne.w	loc_40E9A	; if yes, branch
	tst.b	(Update_HUD_score).w	; does the score need updating?
	beq.s	Hud_ChkRings	; if not, branch
	clr.b	(Update_HUD_score).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Score),VRAM,WRITE),d0	; set VRAM address
	move.l	(Score).w,d1	; load score
	bsr.w	Hud_Score
; loc_40DBA:
Hud_ChkRings:
	tst.b	(Update_HUD_rings).w	; does the ring counter need updating?
	beq.s	Hud_ChkTime	; if not, branch
	bpl.s	loc_40DC6
	bsr.w	Hud_InitRings

loc_40DC6:
	clr.b	(Update_HUD_rings).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Rings),VRAM,WRITE),d0
	moveq	#0,d1
	move.w	(Ring_count).w,d1
	bsr.w	Hud_Rings
; loc_40DDA:
Hud_ChkTime:
	tst.b	(Update_HUD_timer).w	; does the time need updating?
	beq.s	Hud_ChkLives	; if not, branch
	tst.w	(Game_paused).w	; is the game paused?
	bne.s	Hud_ChkLives	; if yes, branch
	lea	(Timer).w,a1
	cmpi.l	#$93B3B,(a1)+	; is the time 9.59?
	beq.w	loc_40E84	; if yes, branch
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	blo.s	Hud_ChkLives
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#60,(a1)
	blo.s	+
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	blo.s	+
	move.b	#9,(a1)
+
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Minutes),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Timer_minute).w,d1
	bsr.w	Hud_Mins
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Seconds),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Timer_second).w,d1
	bsr.w	Hud_Secs
; loc_40E38:
Hud_ChkLives:
	tst.b	(Update_HUD_lives).w	; does the lives counter need updating?
	beq.s	Hud_ChkBonus	; if not, branch
	clr.b	(Update_HUD_lives).w
	bsr.w	Hud_Lives
; loc_40E46:
Hud_ChkBonus:
	tst.b	(Update_Bonus_score).w	; do time/ring bonus counters need updating?
	beq.s	Hud_End	; if not, branch
	clr.b	(Update_Bonus_score).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Bonus_Score),VRAM,WRITE),(VDP_control_port).l
	moveq	#0,d1
	move.w	(Total_Bonus_Countdown).w,d1
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_1).w,d1	 ; load time bonus
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_2).w,d1	 ; load ring bonus
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_3).w,d1	 ; load perfect bonus
	bsr.w	Hud_TimeRingBonus
; return_40E82:
Hud_End:
	rts
; ===========================================================================

loc_40E84:
	clr.b	(Update_HUD_timer).w
	lea	(MainCharacter).w,a0 ; a0=character
	movea.l	a0,a2
	bsr.w	KillCharacter
	move.b	#1,(Time_Over_flag).w
	rts
; ===========================================================================

loc_40E9A:
	bsr.w	HudDb_XY
	tst.b	(Update_HUD_rings).w
	beq.s	loc_40EBE
	bpl.s	loc_40EAA
	bsr.w	Hud_InitRings

loc_40EAA:
	clr.b	(Update_HUD_rings).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Rings),VRAM,WRITE),d0

	moveq	#0,d1
	move.w	(Ring_count).w,d1
	bsr.w	Hud_Rings

loc_40EBE:
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Seconds),VRAM,WRITE),d0
	moveq	#0,d1
	move.b	(Sprite_count).w,d1
	bsr.w	Hud_Secs
	tst.b	(Update_HUD_lives).w
	beq.s	loc_40EDC
	clr.b	(Update_HUD_lives).w
	bsr.w	Hud_Lives

loc_40EDC:
	tst.b	(Update_Bonus_score).w
	beq.s	loc_40F18
	clr.b	(Update_Bonus_score).w
	move.l	#vdpComm(tiles_to_bytes(ArtTile_HUD_Bonus_Score),VRAM,WRITE),(VDP_control_port).l
	moveq	#0,d1
	move.w	(Total_Bonus_Countdown).w,d1
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_1).w,d1
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_2).w,d1
	bsr.w	Hud_TimeRingBonus
	moveq	#0,d1
	move.w	(Bonus_Countdown_3).w,d1
	bsr.w	Hud_TimeRingBonus

loc_40F18:
	tst.w	(Game_paused).w
	bne.s	return_40F4E
	lea	(Timer).w,a1
	cmpi.l	#$93B3B,(a1)+
	nop			; You can't get a Time Over in Debug Mode, so this branch is dummied-out
	addq.b	#1,-(a1)
	cmpi.b	#$3C,(a1)
	blo.s	return_40F4E
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#$3C,(a1)
	blo.s	return_40F4E
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	blo.s	return_40F4E
	move.b	#9,(a1)

return_40F4E:
	rts
; ===========================================================================

loc_40F50:
	tst.w	(Game_paused).w
	bne.w	return_4101A
	tst.b	(Update_HUD_timer).w
	beq.s	loc_40F90
	lea	(Timer).w,a1
	cmpi.l	#$93B3B,(a1)+
	beq.w	TimeOver
	addq.b	#1,-(a1)
	cmpi.b	#$3C,(a1)
	blo.s	loc_40F90
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#$3C,(a1)
	blo.s	loc_40F90
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	blo.s	loc_40F90
	move.b	#9,(a1)

loc_40F90:
	tst.b	(Update_HUD_timer_2P).w
	beq.s	loc_40FC8
	lea	(Timer_2P).w,a1
	cmpi.l	#$93B3B,(a1)+
	beq.w	TimeOver2
	addq.b	#1,-(a1)
	cmpi.b	#$3C,(a1)
	blo.s	loc_40FC8
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#$3C,(a1)
	blo.s	loc_40FC8
	move.b	#0,(a1)
	addq.b	#1,-(a1)
	cmpi.b	#9,(a1)
	blo.s	loc_40FC8
	move.b	#9,(a1)

loc_40FC8:
	tst.b	(Update_HUD_lives).w
	beq.s	loc_40FD6
	clr.b	(Update_HUD_lives).w
	bsr.w	Hud_Lives

loc_40FD6:
	tst.b	(Update_HUD_lives_2P).w
	beq.s	loc_40FE4
	clr.b	(Update_HUD_lives_2P).w
	bsr.w	Hud_Lives2

loc_40FE4:
	move.b	(Update_HUD_timer).w,d0
	or.b	(Update_HUD_timer_2P).w,d0
	beq.s	return_4101A
	lea	(Loser_Time_Left).w,a1
	tst.w	(a1)+
	beq.s	return_4101A
	subq.b	#1,-(a1)
	bhi.s	return_4101A
	move.b	#$3C,(a1)
	cmpi.b	#$C,-1(a1)
	bne.s	loc_41010
	move.w	#MusID_Countdown,d0
	jsr	(PlayMusic).l

loc_41010:
	subq.b	#1,-(a1)
	bcc.s	return_4101A
	move.w	#0,(a1)
	bsr.s	TimeOver0

return_4101A:

	rts
; End of function HudUpdate


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_4101C:
TimeOver0:
	tst.b	(Update_HUD_timer).w
	bne.s	TimeOver
	tst.b	(Update_HUD_timer_2P).w
	bne.s	TimeOver2
	rts
; ===========================================================================
; loc_4102A:
TimeOver:
	clr.b	(Update_HUD_timer).w
	lea	(MainCharacter).w,a0 ; a0=character
	movea.l	a0,a2
	bsr.w	KillCharacter
	move.b	#1,(Time_Over_flag).w
	tst.b	(Update_HUD_timer_2P).w
	beq.s	+	; rts
; loc_41044:
TimeOver2:
	clr.b	(Update_HUD_timer_2P).w
	lea	(Sidekick).w,a0 ; a0=character
	movea.l	a0,a2
	bsr.w	KillCharacter
	move.b	#1,(Time_Over_flag_2P).w
+
	rts
; End of function TimeOver0


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




; ===========================================================================
; ---------------------------------------------------------------------------
; When debug mode is currently in use
; ---------------------------------------------------------------------------
; loc_41A78:
DebugMode:
	moveq	#0,d0
	move.b	(Debug_placement_mode).w,d0
	move.w	Debug_Index(pc,d0.w),d1
	jmp	Debug_Index(pc,d1.w)
; ===========================================================================
; off_41A86:
Debug_Index:	offsetTable
		offsetTableEntry.w Debug_Init	; 0
		offsetTableEntry.w Debug_Main	; 2
; ===========================================================================
; loc_41A8A: Debug_Main:
Debug_Init:
	addq.b	#2,(Debug_placement_mode).w
	move.w	(Camera_Min_Y_pos).w,(Camera_Min_Y_pos_Debug_Copy).w
	move.w	(Camera_Max_Y_pos).w,(Camera_Max_Y_pos_Debug_Copy).w
	cmpi.b	#sky_chase_zone,(Current_Zone).w
	bne.s	+
	move.w	#0,(Camera_Min_X_pos).w
	move.w	#$3FFF,(Camera_Max_X_pos).w
+
	andi.w	#$7FF,(MainCharacter+y_pos).w
	andi.w	#$7FF,(Camera_Y_pos).w
	andi.w	#$7FF,(Camera_BG_Y_pos).w
	clr.b	(Scroll_lock).w
	move.b	#0,mapping_frame(a0)
	move.b	#AniIDSonAni_Walk,anim(a0)
	; S1 leftover
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w ; special stage mode? (you can't enter debug mode in S2's special stage)
	bne.s	.islevel	; if not, branch
	moveq	#6,d0		; force zone 6's debug object list (was the ending in S1)
	bra.s	.selectlist
; ===========================================================================
.islevel:
	moveq	#0,d0
	move.b	(Current_Zone).w,d0

.selectlist:
	lea	(JmpTbl_DbgObjLists).l,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d6
	cmp.b	(Debug_object).w,d6
	bhi.s	+
	move.b	#0,(Debug_object).w
+
	bsr.w	LoadDebugObjectSprite
	move.b	#$C,(Debug_Accel_Timer).w
	move.b	#1,(Debug_Speed).w
; loc_41B0C:
Debug_Main:
	; S1 leftover
	moveq	#6,d0		; force zone 6's debug object list (was the ending in S1)
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; special stage mode? (you can't enter debug mode in S2's special stage)
	beq.s	.isntlevel	; if yes, branch

	moveq	#0,d0
	move.b	(Current_Zone).w,d0

.isntlevel:
	lea	(JmpTbl_DbgObjLists).l,a2
	add.w	d0,d0
	adda.w	(a2,d0.w),a2
	move.w	(a2)+,d6
	bsr.w	Debug_Control
	jmp	(DisplaySprite).l

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41B34:
Debug_Control:
;Debug_ControlMovement:
	moveq	#0,d4
	move.w	#1,d1
	move.b	(Ctrl_1_Press).w,d4
	andi.w	#button_up_mask|button_down_mask|button_left_mask|button_right_mask,d4
	bne.s	Debug_Move
	move.b	(Ctrl_1_Held).w,d0
	andi.w	#button_up_mask|button_down_mask|button_left_mask|button_right_mask,d0
	bne.s	Debug_ContinueMoving
	move.b	#$C,(Debug_Accel_Timer).w
	move.b	#$F,(Debug_Speed).w
	bra.w	Debug_ControlObjects
; ===========================================================================
; loc_41B5E:
Debug_ContinueMoving:
	subq.b	#1,(Debug_Accel_Timer).w
	bne.s	Debug_TimerNotOver
	move.b	#1,(Debug_Accel_Timer).w
	addq.b	#1,(Debug_Speed).w
	bne.s	Debug_Move
	move.b	#-1,(Debug_Speed).w
; loc_41B76:
Debug_Move:
	move.b	(Ctrl_1_Held).w,d4
; loc_41B7A:
Debug_TimerNotOver:
	moveq	#0,d1
	move.b	(Debug_Speed).w,d1
	addq.w	#1,d1
	swap	d1
	asr.l	#4,d1
	move.l	y_pos(a0),d2
	move.l	x_pos(a0),d3

	; Move up
	btst	#button_up,d4
	beq.s	.upNotHeld
	sub.l	d1,d2
	moveq	#0,d0
	move.w	(Camera_Min_Y_pos).w,d0
	swap	d0
	cmp.l	d0,d2
	bge.s	.minYPosNotReached
	move.l	d0,d2
.minYPosNotReached:
; loc_41BA4:
.upNotHeld:
	; Move down
	btst	#button_down,d4
	beq.s	.downNotHeld
	add.l	d1,d2
	moveq	#0,d0
	move.w	(Camera_Max_Y_pos).w,d0
	addi.w	#224-1,d0
	swap	d0
	cmp.l	d0,d2
	blt.s	.maxYPosNotReached
	move.l	d0,d2
.maxYPosNotReached:
; loc_41BBE:
.downNotHeld:
	; Move left
	btst	#button_left,d4
	beq.s	.leftNotHeld
	sub.l	d1,d3
	bcc.s	.minXPosNotReached
	moveq	#0,d3
.minXPosNotReached:
; loc_41BCA:
.leftNotHeld:
	; Move right
	btst	#button_right,d4
	beq.s	.rightNotHeld
	add.l	d1,d3
; loc_41BD2:
.rightNotHeld:
	move.l	d2,y_pos(a0)
	move.l	d3,x_pos(a0)
; loc_41BDA:
Debug_ControlObjects:
;Debug_CycleObjectsBackwards:
	btst	#button_A,(Ctrl_1_Held).w
	beq.s	Debug_SpawnObject
	btst	#button_C,(Ctrl_1_Press).w
	beq.s	Debug_CycleObjects
	; Cycle backwards though object list
	subq.b	#1,(Debug_object).w
	bcc.s	BranchTo_LoadDebugObjectSprite
	add.b	d6,(Debug_object).w
	bra.s	BranchTo_LoadDebugObjectSprite
; ===========================================================================
; loc_41BF6:
Debug_CycleObjects:
	btst	#button_A,(Ctrl_1_Press).w
	beq.s	Debug_SpawnObject
	; Cycle forwards though object list
	addq.b	#1,(Debug_object).w
	cmp.b	(Debug_object).w,d6
	bhi.s	BranchTo_LoadDebugObjectSprite
	move.b	#0,(Debug_object).w

BranchTo_LoadDebugObjectSprite 
	bra.w	LoadDebugObjectSprite
; ===========================================================================
; loc_41C12:
Debug_SpawnObject:
	btst	#button_C,(Ctrl_1_Press).w
	beq.s	Debug_ExitDebugMode
	; Spawn object
	jsr	(SingleObjLoad).l
	bne.s	Debug_ExitDebugMode
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	_move.b	mappings(a0),id(a1) ; load obj
	move.b	render_flags(a0),render_flags(a1)
	move.b	render_flags(a0),status(a1)
	andi.b	#$7F,status(a1)
	moveq	#0,d0
	move.b	(Debug_object).w,d0
	lsl.w	#3,d0
	move.b	4(a2,d0.w),subtype(a1)
	rts
; ===========================================================================
; loc_41C56:
Debug_ExitDebugMode:
	btst	#button_B,(Ctrl_1_Press).w
	beq.s	return_41CB6
	; Exit debug mode
	moveq	#0,d0
	move.w	d0,(Debug_placement_mode).w
	lea	(MainCharacter).w,a1 ; a1=character
	move.l	#Mapunc_Sonic,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtUnc_Sonic,0,0),art_tile(a1)
	tst.w	(Two_player_mode).w
	beq.s	.notTwoPlayerMode
	move.w	#make_art_tile_2p(ArtTile_ArtUnc_Sonic,0,0),art_tile(a1)
; loc_41C82:
.notTwoPlayerMode:
	bsr.s	Debug_ResetPlayerStats
	move.b	#$13,y_radius(a1)
	move.b	#9,x_radius(a1)
	move.w	(Camera_Min_Y_pos_Debug_Copy).w,(Camera_Min_Y_pos).w
	move.w	(Camera_Max_Y_pos_Debug_Copy).w,(Camera_Max_Y_pos).w
	; useless leftover; this is for S1's special stage
	cmpi.b	#GameModeID_SpecialStage,(Game_Mode).w	; special stage mode?
	bne.s	return_41CB6		; if not, branch
	move.b	#AniIDSonAni_Roll,(MainCharacter+anim).w
	bset	#2,(MainCharacter+status).w
	bset	#1,(MainCharacter+status).w

return_41CB6:
	rts
; End of function Debug_Control


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41CB8:
Debug_ResetPlayerStats:
	move.b	d0,anim(a1)
	move.w	d0,2+x_pos(a1) ; subpixel x
	move.w	d0,2+y_pos(a1) ; subpixel y
	move.b	d0,obj_control(a1)
	move.b	d0,spindash_flag(a1)
	move.w	d0,x_vel(a1)
	move.w	d0,y_vel(a1)
	move.w	d0,inertia(a1)
	; note: this resets the 'is underwater' flag, causing the bug where
	; if you enter Debug Mode underwater, and exit it above-water, Sonic
	; will still move as if he's underwater
	move.b	#2,status(a1)
	move.b	#2,routine(a1)
	move.b	#0,routine_secondary(a1)
	rts
; End of function Debug_ResetPlayerStats


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_41CEC:
LoadDebugObjectSprite:
	moveq	#0,d0
	move.b	(Debug_object).w,d0
	lsl.w	#3,d0
	move.l	(a2,d0.w),mappings(a0)
	move.w	6(a2,d0.w),art_tile(a0)
	move.b	5(a2,d0.w),mapping_frame(a0)
	jsrto	(Adjust2PArtPointer).l, JmpTo66_Adjust2PArtPointer
	rts
; End of function LoadDebugObjectSprite

; ===========================================================================
; ---------------------------------------------------------------------------
; OBJECT DEBUG LISTS

; The jump table goes by level ID, so Metropolis Zone's list is repeated to
; account for its third act. Hidden Palace Zone uses Oil Ocean Zone's list.
; ---------------------------------------------------------------------------
JmpTbl_DbgObjLists: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w DbgObjList_EHZ	; 0
	zoneOffsetTableEntry.w DbgObjList_Def	; 1
	zoneOffsetTableEntry.w DbgObjList_Def	; 2
	zoneOffsetTableEntry.w DbgObjList_Def	; 3
	zoneOffsetTableEntry.w DbgObjList_MTZ	; 4
	zoneOffsetTableEntry.w DbgObjList_MTZ	; 5
	zoneOffsetTableEntry.w DbgObjList_WFZ	; 6
	zoneOffsetTableEntry.w DbgObjList_HTZ	; 7
	zoneOffsetTableEntry.w DbgObjList_HPZ	; 8
	zoneOffsetTableEntry.w DbgObjList_Def	; 9
	zoneOffsetTableEntry.w DbgObjList_OOZ	; $A
	zoneOffsetTableEntry.w DbgObjList_MCZ	; $B
	zoneOffsetTableEntry.w DbgObjList_CNZ	; $C
	zoneOffsetTableEntry.w DbgObjList_CPZ	; $D
	zoneOffsetTableEntry.w DbgObjList_Def	; $E
	zoneOffsetTableEntry.w DbgObjList_ARZ	; $F
	zoneOffsetTableEntry.w DbgObjList_SCZ	; $10
    zoneTableEnd

; macro for a debug object list header
; must be on the same line as a label that has a corresponding _End label later
dbglistheader macro {INTLABEL}
__LABEL__ label *
	dc.w ((__LABEL___End - __LABEL__ - 2) >> 3)
    endm

; macro to define debug list object data
dbglistobj macro   obj, mapaddr, subtype, frame, vram
	dc.l obj<<24|mapaddr
	dc.b subtype,frame
	dc.w vram
    endm

DbgObjList_Def: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0) ; obj25 = ring
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0) ; obj26 = monitor
DbgObjList_Def_End

DbgObjList_EHZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_EHZWaterfall,	Obj49_MapUnc_20C50,   0,   0, make_art_tile(ArtTile_ArtNem_Waterfall,1,0)
	dbglistobj ObjID_EHZWaterfall,	Obj49_MapUnc_20C50,   2,   3, make_art_tile(ArtTile_ArtNem_Waterfall,1,0)
	dbglistobj ObjID_EHZWaterfall,	Obj49_MapUnc_20C50,   4,   5, make_art_tile(ArtTile_ArtNem_Waterfall,1,0)
	dbglistobj ObjID_EHZPlatform,	Obj18_MapUnc_107F6,   1,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_EHZPlatform,	Obj18_MapUnc_107F6, $9A,   1, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $A0,   6, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $30,   7, make_art_tile(ArtTile_ArtNem_DignlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $40,  $A, make_art_tile(ArtTile_ArtNem_DignlSprng,0,0)
	dbglistobj ObjID_Buzzer,	Obj4B_MapUnc_2D2EA,   0,   0, make_art_tile(ArtTile_ArtNem_Buzzer,0,0)
	dbglistobj ObjID_Masher,	Obj5C_MapUnc_2D442,   0,   0, make_art_tile(ArtTile_ArtNem_Masher,0,0)
	dbglistobj ObjID_Coconuts,	Obj9D_Obj98_MapUnc_37D96, $1E,   0, make_art_tile(ArtTile_ArtNem_Coconuts,0,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_EHZ_End

DbgObjList_MTZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_SteamSpring,	Obj42_MapUnc_2686C,   1,   7, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_MTZTwinStompers, Obj64_MapUnc_26A5C,   1,   0, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_MTZTwinStompers, Obj64_MapUnc_26A5C, $11,   1, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_MTZLongPlatform, Obj65_Obj6A_Obj6B_MapUnc_26EC8, $80,   0, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_MTZLongPlatform, Obj65_Obj6A_Obj6B_MapUnc_26EC8, $13,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_Button,	Obj47_MapUnc_24D96,   0,   2, make_art_tile(ArtTile_ArtNem_Button,0,0)
	dbglistobj ObjID_Barrier,	Obj2D_MapUnc_11822,   1,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_MTZSpringWall,	Obj66_MapUnc_27120,   1,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_MTZSpringWall,	Obj66_MapUnc_27120, $11,   1, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_SpikyBlock,	Obj68_Obj6D_MapUnc_27750,   0,   4, make_art_tile(ArtTile_ArtNem_MtzSpikeBlock,3,0)
	dbglistobj ObjID_Nut,		Obj69_MapUnc_27A26,   4,   0, make_art_tile(ArtTile_ArtNem_MtzAsstBlocks,1,0)
	dbglistobj ObjID_MTZMovingPforms, Obj65_Obj6A_Obj6B_MapUnc_26EC8,   0,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_MTZPlatform,	Obj65_Obj6A_Obj6B_MapUnc_26EC8,   7,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_FloorSpike,	Obj68_Obj6D_MapUnc_27750,   0,   0, make_art_tile(ArtTile_ArtNem_MtzSpike,1,0)
	dbglistobj ObjID_LargeRotPform,	Obj6E_MapUnc_2852C,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_LargeRotPform,	Obj6E_MapUnc_2852C, $10,   1, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_LargeRotPform,	Obj6E_MapUnc_2852C, $20,   2, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_Cog,		Obj70_MapUnc_28786, $10,   0, make_art_tile(ArtTile_ArtNem_MtzWheel,3,1)
	dbglistobj ObjID_MTZLavaBubble,	Obj71_MapUnc_11576, $22,   5, make_art_tile(ArtTile_ArtNem_MtzLavaBubble,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_11552,   0,   0, make_art_tile(ArtTile_ArtNem_BoltEnd_Rope,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_11552,   1,   1, make_art_tile(ArtTile_ArtNem_BoltEnd_Rope,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_11552,   3,   2, make_art_tile(ArtTile_ArtNem_BoltEnd_Rope,1,0)
	dbglistobj ObjID_MTZLongPlatform, Obj65_Obj6A_Obj6B_MapUnc_26EC8, $B0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,3,0)
	dbglistobj ObjID_Shellcracker,	Obj9F_MapUnc_38314, $24,   0, make_art_tile(ArtTile_ArtNem_Shellcracker,0,0)
	dbglistobj ObjID_Asteron,	ObjA4_Obj98_MapUnc_38A96, $2E,   0, make_art_tile(ArtTile_ArtNem_MtzSupernova,0,1)
	dbglistobj ObjID_Slicer,	ObjA1_MapUnc_385E2, $28,   0, make_art_tile(ArtTile_ArtNem_MtzMantis,1,0)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   0,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   1,   1, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   2,   2, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_MTZ_End

DbgObjList_WFZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_WFZPalSwitcher, Obj03_MapUnc_1FFB8,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $5E,   0, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $60,   1, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $62,   2, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_VPropeller,	ObjB4_MapUnc_3B3BE, $64,   0, make_art_tile(ArtTile_ArtNem_WfzVrtclPrpllr,1,1)
	dbglistobj ObjID_HPropeller,	ObjB5_MapUnc_3B548, $66,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1)
	dbglistobj ObjID_HPropeller,	ObjB5_MapUnc_3B548, $68,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1)
	dbglistobj ObjID_CluckerBase,	ObjAD_Obj98_MapUnc_395B4, $42,  $C, make_art_tile(ArtTile_ArtNem_WfzScratch,0,0)
	dbglistobj ObjID_Clucker,	ObjAD_Obj98_MapUnc_395B4, $44,  $B, make_art_tile(ArtTile_ArtNem_WfzScratch,0,0)
	dbglistobj ObjID_TiltingPlatform, ObjB6_MapUnc_3B856, $6A,   0, make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1)
	dbglistobj ObjID_TiltingPlatform, ObjB6_MapUnc_3B856, $6C,   0, make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1)
	dbglistobj ObjID_TiltingPlatform, ObjB6_MapUnc_3B856, $6E,   0, make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1)
	dbglistobj ObjID_TiltingPlatform, ObjB6_MapUnc_3B856, $70,   0, make_art_tile(ArtTile_ArtNem_WfzTiltPlatforms,1,1)
	dbglistobj ObjID_VerticalLaser,	ObjB7_MapUnc_3B8E4, $72,   0, make_art_tile(ArtTile_ArtNem_WfzVrtclLazer,2,1)
	dbglistobj ObjID_WallTurret,	ObjB8_Obj98_MapUnc_3BA46, $74,   0, make_art_tile(ArtTile_ArtNem_WfzWallTurret,0,0)
	dbglistobj ObjID_Laser,		ObjB9_MapUnc_3BB18, $76,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlLazer,2,1)
	dbglistobj ObjID_WFZWheel,	ObjBA_MapUnc_3BB70, $78,   0, make_art_tile(ArtTile_ArtNem_WfzConveyorBeltWheel,2,1)
	dbglistobj ObjID_WFZShipFire,	ObjBC_MapUnc_3BC08, $7C,   0, make_art_tile(ArtTile_ArtNem_WfzThrust,2,0)
	dbglistobj ObjID_SmallMetalPform, ObjBD_MapUnc_3BD3E, $7E,   0, make_art_tile(ArtTile_ArtNem_WfzBeltPlatform,3,1)
	dbglistobj ObjID_SmallMetalPform, ObjBD_MapUnc_3BD3E, $80,   0, make_art_tile(ArtTile_ArtNem_WfzBeltPlatform,3,1)
	dbglistobj ObjID_LateralCannon,	ObjBE_MapUnc_3BE46, $82,   0, make_art_tile(ArtTile_ArtNem_WfzGunPlatform,3,1)
	dbglistobj ObjID_WFZStick,	ObjBF_MapUnc_3BEE0, $84,   0, make_art_tile(ArtTile_ArtNem_WfzUnusedBadnik,3,1)
	dbglistobj ObjID_SpeedLauncher,	ObjC0_MapUnc_3C098,   8,   0, make_art_tile(ArtTile_ArtNem_WfzLaunchCatapult,1,0)
	dbglistobj ObjID_BreakablePlating, ObjC1_MapUnc_3C280, $88,   0, make_art_tile(ArtTile_ArtNem_BreakPanels,3,1)
	dbglistobj ObjID_Rivet,		ObjC2_MapUnc_3C3C2, $8A,   0, make_art_tile(ArtTile_ArtNem_WfzSwitch,1,1)
	dbglistobj ObjID_WFZPlatform,	Obj19_MapUnc_2222A, $38,   3, make_art_tile(ArtTile_ArtNem_WfzFloatingPlatform,1,1)
	dbglistobj ObjID_Grab,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_MovingVine,	Obj80_MapUnc_29DD0,   0,   0, make_art_tile(ArtTile_ArtNem_WfzHook_Fudge,1,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_WFZ_End

DbgObjList_HTZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_ForcedSpin,	Obj03_MapUnc_1FFB8,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_ForcedSpin,	Obj03_MapUnc_1FFB8,   4,   4, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_EHZPlatform,	Obj18_MapUnc_107F6,   1,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_EHZPlatform,	Obj18_MapUnc_107F6, $9A,   1, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Seesaw,	Obj14_MapUnc_21CF0,   0,   0, make_art_tile(ArtTile_ArtNem_HtzSeeSaw,0,0)
	dbglistobj ObjID_Barrier,	Obj2D_MapUnc_11822,   0,   0, make_art_tile(ArtTile_ArtNem_HtzValveBarrier,1,0)
	dbglistobj ObjID_SmashableGround, Obj2F_MapUnc_236FA,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,1)
	dbglistobj ObjID_LavaBubble,	Obj20_MapUnc_23254, $44,   2, make_art_tile(ArtTile_ArtNem_HtzFireball2,0,1)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $A0,   6, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $30,   7, make_art_tile(ArtTile_ArtNem_DignlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $40,  $A, make_art_tile(ArtTile_ArtNem_DignlSprng,0,0)
	dbglistobj ObjID_HTZLift,	Obj16_MapUnc_21F14,   0,   0, make_art_tile(ArtTile_ArtNem_HtzZipline,2,0)
	dbglistobj ObjID_BridgeStake,	Obj16_MapUnc_21F14,   4,   3, make_art_tile(ArtTile_ArtNem_HtzZipline,2,0)
	dbglistobj ObjID_BridgeStake,	Obj16_MapUnc_21F14,   5,   4, make_art_tile(ArtTile_ArtNem_HtzZipline,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_113D6,   7,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_Scenery,	Obj1C_MapUnc_113D6,   8,   1, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_BreakableRock,	Obj32_MapUnc_23852,   0,   0, make_art_tile(ArtTile_ArtNem_HtzRock,2,0)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   0,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   1,   1, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LavaMarker,	Obj31_MapUnc_20E74,   2,   2, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_Rexon2,	Obj94_Obj98_MapUnc_37678,  $E,   2, make_art_tile(ArtTile_ArtNem_Rexon,3,0)
	dbglistobj ObjID_Spiker,	Obj92_Obj93_MapUnc_37092,  $A,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_Sol,		Obj95_MapUnc_372E6,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_HTZ_End

DbgObjList_HPZ:; dbglistheader
;	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
;	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
;DbgObjList_HPZ_End

DbgObjList_OOZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_OOZPoppingPform, Obj33_MapUnc_23DDC,   1,   0, make_art_tile(ArtTile_ArtNem_BurnerLid,3,0)
	dbglistobj ObjID_SlidingSpike,	Obj43_MapUnc_23FE0,   0,   0, make_art_tile(ArtTile_ArtNem_SpikyThing,2,1)
	dbglistobj ObjID_OOZMovingPform, Obj19_MapUnc_2222A, $23,   2, make_art_tile(ArtTile_ArtNem_OOZElevator,3,0)
	dbglistobj ObjID_OOZSpring,	Obj45_MapUnc_2451A,   2,   0, make_art_tile(ArtTile_ArtNem_PushSpring,2,0)
	dbglistobj ObjID_OOZSpring,	Obj45_MapUnc_2451A, $12,  $A, make_art_tile(ArtTile_ArtNem_PushSpring,2,0)
	dbglistobj ObjID_OOZBall,	Obj46_MapUnc_24C52,   0,   1, make_art_tile(ArtTile_ArtNem_BallThing,3,0)
	dbglistobj ObjID_Button,	Obj47_MapUnc_24D96,   0,   2, make_art_tile(ArtTile_ArtNem_Button,0,0)
	dbglistobj ObjID_SwingingPlatform, Obj15_MapUnc_101E8, $88,   1, make_art_tile(ArtTile_ArtNem_OOZSwingPlat,2,0)
	dbglistobj ObjID_OOZLauncher,	Obj3D_MapUnc_250BA,   0,   0, make_art_tile(ArtTile_ArtNem_StripedBlocksVert,3,0)
	dbglistobj ObjID_LauncherBall,	Obj48_MapUnc_254FE, $80,   0, make_art_tile(ArtTile_ArtNem_LaunchBall,3,0)
	dbglistobj ObjID_LauncherBall,	Obj48_MapUnc_254FE, $81,   1, make_art_tile(ArtTile_ArtNem_LaunchBall,3,0)
	dbglistobj ObjID_LauncherBall,	Obj48_MapUnc_254FE, $82,   2, make_art_tile(ArtTile_ArtNem_LaunchBall,3,0)
	dbglistobj ObjID_LauncherBall,	Obj48_MapUnc_254FE, $83,   3, make_art_tile(ArtTile_ArtNem_LaunchBall,3,0)
	dbglistobj ObjID_CollapsPform,	Obj1F_MapUnc_110C6,   0,   0, make_art_tile(ArtTile_ArtNem_OOZPlatform,3,0)
	dbglistobj ObjID_Fan,		Obj3F_MapUnc_2AA12,   0,   0, make_art_tile(ArtTile_ArtNem_OOZFanHoriz,3,0)
	dbglistobj ObjID_Fan,		Obj3F_MapUnc_2AAC4, $80,   0, make_art_tile(ArtTile_ArtNem_OOZFanHoriz,3,0)
	dbglistobj ObjID_Aquis,		Obj50_MapUnc_2CF94,   0,   0, make_art_tile(ArtTile_ArtNem_Aquis,1,0)
	dbglistobj ObjID_Octus,		Obj4A_MapUnc_2CBFE,   0,   0, make_art_tile(ArtTile_ArtNem_Octus,1,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $A,   0, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $B,   1, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $C,   2, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $D,   3, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $E,   4, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_11406,  $F,   5, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $10,   0, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $11,   1, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $12,   2, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $13,   3, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_FallingOil,	Obj1C_MapUnc_114AE, $14,   4, make_art_tile(ArtTile_ArtNem_Oilfall2,2,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_OOZ_End

DbgObjList_MCZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_SwingingPlatform, Obj15_Obj7A_MapUnc_10256, $48,   2, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_CollapsPform,	Obj1F_MapUnc_11106,   0,   0, make_art_tile(ArtTile_ArtNem_MCZCollapsePlat,3,0)
	dbglistobj ObjID_RotatingRings,	Obj73_MapUnc_28B9C, $F5,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_MCZRotPforms,	Obj6A_MapUnc_27D30, $18,   0, make_art_tile(ArtTile_ArtNem_Crate,3,0)
	dbglistobj ObjID_Stomper,	Obj2A_MapUnc_11666,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68, $40,   4, make_art_tile(ArtTile_ArtNem_HorizSpike,1,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Springboard,	Obj40_MapUnc_265F4,   1,   0, make_art_tile(ArtTile_ArtNem_LeverSpring,0,0)
	dbglistobj ObjID_InvisibleBlock, Obj74_MapUnc_20F66, $11,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_MCZBrick,	Obj75_MapUnc_28D8A, $18,   2, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_SlidingSpikes,	Obj76_MapUnc_28F3A,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_MCZBridge,	Obj77_MapUnc_29064,   1,   0, make_art_tile(ArtTile_ArtNem_MCZGateLog,3,0)
	dbglistobj ObjID_VineSwitch,	Obj7F_MapUnc_29938,   0,   0, make_art_tile(ArtTile_ArtNem_VineSwitch,3,0)
	dbglistobj ObjID_MovingVine,	Obj80_MapUnc_29C64,   0,   0, make_art_tile(ArtTile_ArtNem_VinePulley,3,0)
	dbglistobj ObjID_MCZDrawbridge,	Obj81_MapUnc_2A24E,   0,   1, make_art_tile(ArtTile_ArtNem_MCZGateLog,3,0)
	dbglistobj ObjID_SidewaysPform,	Obj15_Obj7A_MapUnc_10256, $12,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_Flasher,	ObjA3_MapUnc_388F0, $2C,   0, make_art_tile(ArtTile_ArtNem_Flasher,0,1)
	dbglistobj ObjID_Crawlton,	Obj9E_MapUnc_37FF2, $22,   0, make_art_tile(ArtTile_ArtNem_Crawlton,1,0)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_MCZ_End

DbgObjList_CNZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_PinballMode,	Obj03_MapUnc_1FFB8,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_PinballMode,	Obj03_MapUnc_1FFB8,   4,   4, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,  $D,   5, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_RoundBumper,	Obj44_MapUnc_1F85A,   0,   0, make_art_tile(ArtTile_ArtNem_CNZRoundBumper,2,0)
	dbglistobj ObjID_LauncherSpring, Obj85_MapUnc_2B07E,   0,   0, make_art_tile(ArtTile_ArtNem_CNZVertPlunger,0,0)
	dbglistobj ObjID_LauncherSpring, Obj85_MapUnc_2B0EC, $81,   0, make_art_tile(ArtTile_ArtNem_CNZDiagPlunger,0,0)
	dbglistobj ObjID_Flipper,	Obj86_MapUnc_2B45A,   0,   0, make_art_tile(ArtTile_ArtNem_CNZFlipper,2,0)
	dbglistobj ObjID_Flipper,	Obj86_MapUnc_2B45A,   1,   4, make_art_tile(ArtTile_ArtNem_CNZFlipper,2,0)
	dbglistobj ObjID_CNZRectBlocks,	ObjD2_MapUnc_2B694,   1,   0, make_art_tile(ArtTile_ArtNem_CNZSnake,2,0)
	dbglistobj ObjID_BombPrize,	ObjD3_MapUnc_2B8D4,   0,   0, make_art_tile(ArtTile_ArtNem_CNZBonusSpike,0,0)
	dbglistobj ObjID_CNZBigBlock,	ObjD4_MapUnc_2B9CA,   0,   0, make_art_tile(ArtTile_ArtNem_BigMovingBlock,2,0)
	dbglistobj ObjID_CNZBigBlock,	ObjD4_MapUnc_2B9CA,   2,   0, make_art_tile(ArtTile_ArtNem_BigMovingBlock,2,0)
	dbglistobj ObjID_Elevator,	ObjD5_MapUnc_2BB40, $18,   0, make_art_tile(ArtTile_ArtNem_CNZElevator,2,0)
	dbglistobj ObjID_PointPokey,	ObjD6_MapUnc_2BEBC,   1,   0, make_art_tile(ArtTile_ArtNem_CNZCage,0,0)
	dbglistobj ObjID_Bumper,	ObjD7_MapUnc_2C626,   0,   0, make_art_tile(ArtTile_ArtNem_CNZHexBumper,2,0)
	dbglistobj ObjID_BonusBlock,	ObjD8_MapUnc_2C8C4,   0,   0, make_art_tile(ArtTile_ArtNem_CNZMiniBumper,2,0)
	dbglistobj ObjID_BonusBlock,	ObjD8_MapUnc_2C8C4, $40,   1, make_art_tile(ArtTile_ArtNem_CNZMiniBumper,2,0)
	dbglistobj ObjID_BonusBlock,	ObjD8_MapUnc_2C8C4, $80,   2, make_art_tile(ArtTile_ArtNem_CNZMiniBumper,2,0)
	dbglistobj ObjID_Crawl,		ObjC8_MapUnc_3D450, $AC,   0, make_art_tile(ArtTile_ArtNem_Crawl,0,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_CNZ_End

DbgObjList_CPZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_TippingFloor,	Obj0B_MapUnc_201A0, $70,   0, make_art_tile(ArtTile_ArtNem_CPZAnimatedBits,3,1)
	dbglistobj ObjID_SpeedBooster,	Obj1B_MapUnc_223E2,   0,   0, make_art_tile(ArtTile_ArtNem_CPZBooster,3,1)
	dbglistobj ObjID_BlueBalls,	Obj1D_MapUnc_22576,   5,   0, make_art_tile(ArtTile_ArtNem_CPZDroplet,3,1)
	dbglistobj ObjID_CPZPlatform,	Obj19_MapUnc_2222A,   6,   0, make_art_tile(ArtTile_ArtNem_CPZElevator,3,0)
	dbglistobj ObjID_Barrier,	Obj2D_MapUnc_11822,   2,   2, make_art_tile(ArtTile_ArtNem_ConstructionStripes_2,1,0)
	dbglistobj ObjID_BreakableBlock, Obj32_MapUnc_23886,   0,   0, make_art_tile(ArtTile_ArtNem_CPZMetalBlock,3,0)
	dbglistobj ObjID_CPZSquarePform, Obj6B_MapUnc_2800E, $10,   0, make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,0)
	dbglistobj ObjID_CPZStaircase,	Obj6B_MapUnc_2800E,   0,   0, make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,0)
	dbglistobj ObjID_SidewaysPform,	Obj7A_MapUnc_29564,   0,   0, make_art_tile(ArtTile_ArtNem_CPZStairBlock,3,1)
	dbglistobj ObjID_PipeExitSpring, Obj7B_MapUnc_29780,   2,   0, make_art_tile(ArtTile_ArtNem_CPZTubeSpring,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,  $D,   5, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $A0,   6, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Springboard,	Obj40_MapUnc_265F4,   1,   0, make_art_tile(ArtTile_ArtNem_LeverSpring,0,0)
	dbglistobj ObjID_Spiny,		ObjA5_ObjA6_Obj98_MapUnc_38CCA, $32,   0, make_art_tile(ArtTile_ArtNem_Spiny,1,0)
	dbglistobj ObjID_SpinyOnWall,	ObjA5_ObjA6_Obj98_MapUnc_38CCA, $32,   3, make_art_tile(ArtTile_ArtNem_Spiny,1,0)
	dbglistobj ObjID_Grabber,	ObjA7_ObjA8_ObjA9_Obj98_MapUnc_3921A, $36,   0, make_art_tile(ArtTile_ArtNem_Grabber,1,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_CPZ_End

DbgObjList_ARZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_Starpost,	Obj79_MapUnc_1F424,   1,   0, make_art_tile(ArtTile_ArtNem_Checkpoint,0,0)
	dbglistobj ObjID_SwingingPlatform, Obj15_Obj83_MapUnc_1021E, $88,   2, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_ARZPlatform,	Obj18_MapUnc_1084E,   1,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_ARZPlatform,	Obj18_MapUnc_1084E, $9A,   1, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_ArrowShooter,	Obj22_MapUnc_25804,   0,   1, make_art_tile(ArtTile_ArtNem_ArrowAndShooter,0,0)
	dbglistobj ObjID_FallingPillar,	Obj23_MapUnc_259E6,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_RisingPillar,	Obj2B_MapUnc_25C6E,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,1,0)
	dbglistobj ObjID_LeavesGenerator, Obj31_MapUnc_20E74,   0,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LeavesGenerator, Obj31_MapUnc_20E74,   1,   1, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_LeavesGenerator, Obj31_MapUnc_20E74,   2,   2, make_art_tile(ArtTile_ArtNem_Powerups,0,1)
	dbglistobj ObjID_Springboard,	Obj40_MapUnc_265F4,   1,   0, make_art_tile(ArtTile_ArtNem_LeverSpring,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $81,   0, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $90,   3, make_art_tile(ArtTile_ArtNem_HrzntlSprng,0,0)
	dbglistobj ObjID_Spring,	Obj41_MapUnc_1901C, $A0,   6, make_art_tile(ArtTile_ArtNem_VrtclSprng,0,0)
	dbglistobj ObjID_PlaneSwitcher,	Obj03_MapUnc_1FFB8,   9,   1, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Spikes,	Obj36_MapUnc_15B68,   0,   0, make_art_tile(ArtTile_ArtNem_Spikes,1,0)
	dbglistobj ObjID_Barrier,	Obj2D_MapUnc_11822,   3,   3, make_art_tile(ArtTile_ArtNem_ARZBarrierThing,1,0)
	dbglistobj ObjID_CollapsPform,	Obj1F_MapUnc_1115E,   0,   0, make_art_tile(ArtTile_ArtKos_LevelArt,2,0)
	dbglistobj ObjID_SwingingPform,	Obj82_MapUnc_2A476,   3,   0, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_SwingingPform,	Obj82_MapUnc_2A476, $11,   1, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_ARZRotPforms,	Obj15_Obj83_MapUnc_1021E, $10,   1, make_art_tile(ArtTile_ArtKos_LevelArt,0,0)
	dbglistobj ObjID_ARZBubbles,	Obj24_MapUnc_1FBF6, $81,  $E, make_art_tile(ArtTile_ArtNem_BigBubbles,0,1)
	dbglistobj ObjID_ChopChop,	Obj91_MapUnc_36EF6,   8,   0, make_art_tile(ArtTile_ArtNem_ChopChop,1,0)
	dbglistobj ObjID_Whisp,		Obj8C_MapUnc_36A4E,   0,   0, make_art_tile(ArtTile_ArtNem_Whisp,1,1)
	dbglistobj ObjID_GrounderInWall, Obj8D_MapUnc_36CF0,   2,   0, make_art_tile(ArtTile_ArtNem_Grounder,1,1)
	dbglistobj ObjID_GrounderInWall2, Obj8D_MapUnc_36CF0,   2,   0, make_art_tile(ArtTile_ArtNem_Grounder,1,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_ARZ_End

DbgObjList_SCZ: dbglistheader
	dbglistobj ObjID_Ring,		Obj25_MapUnc_12382,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,1,0)
	dbglistobj ObjID_Monitor,	Obj26_MapUnc_12D36,   8,   0, make_art_tile(ArtTile_ArtNem_Powerups,0,0)
	dbglistobj ObjID_WFZPalSwitcher, Obj03_MapUnc_1FFB8,   0,   0, make_art_tile(ArtTile_ArtNem_Ring,0,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $5E,   0, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $60,   1, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_Cloud,		ObjB3_MapUnc_3B32C, $62,   2, make_art_tile(ArtTile_ArtNem_Clouds,2,0)
	dbglistobj ObjID_VPropeller,	ObjB4_MapUnc_3B3BE, $64,   0, make_art_tile(ArtTile_ArtNem_WfzVrtclPrpllr,1,1)
	dbglistobj ObjID_HPropeller,	ObjB5_MapUnc_3B548, $66,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1)
	dbglistobj ObjID_HPropeller,	ObjB5_MapUnc_3B548, $68,   0, make_art_tile(ArtTile_ArtNem_WfzHrzntlPrpllr,1,1)
	dbglistobj ObjID_Turtloid,	Obj9A_Obj98_MapUnc_37B62, $16,   0, make_art_tile(ArtTile_ArtNem_Turtloid,0,0)
	dbglistobj ObjID_Balkiry,	ObjAC_MapUnc_393CC, $40,   0, make_art_tile(ArtTile_ArtNem_Balkrie,0,0)
	dbglistobj ObjID_Nebula,	Obj99_Obj98_MapUnc_3789A, $12,   0, make_art_tile(ArtTile_ArtNem_Nebula,1,1)
	dbglistobj ObjID_EggPrison,	Obj3E_MapUnc_3F436,   0,   0, make_art_tile(ArtTile_ArtNem_Capsule,1,0)
DbgObjList_SCZ_End

    if ~~removeJmpTos
JmpTo66_Adjust2PArtPointer 
	jmp	(Adjust2PArtPointer).l

	align 4
    endif




; ---------------------------------------------------------------------------
; "MAIN LEVEL LOAD BLOCK" (after Nemesis)
;
; This struct array tells the engine where to find all the art associated with
; a particular zone. Each zone gets three longwords, in which it stores three
; pointers (in the lower 24 bits) and three jump table indeces (in the upper eight
; bits). The assembled data looks something like this:
;
; aaBBBBBB
; ccDDDDDD
; eeFFFFFF
;
; aa = index for primary pattern load request list
; BBBBBB = pointer to level art
; cc = index for secondary pattern load request list
; DDDDDD = pointer to 16x16 block mappings
; ee = index for palette
; FFFFFF = pointer to 128x128 block mappings
;
; Nemesis refers to this as the "main level load block". However, that name implies
; that this is code (obviously, it isn't), or at least that it points to the level's
; collision, object and ring placement arrays (it only points to art...
; although the 128x128 mappings do affect the actual level layout and collision)
; ---------------------------------------------------------------------------

; declare some global variables to be used by the levartptrs macro
cur_zone_id := 0
cur_zone_str := "0"

; macro for declaring a "main level load block" (MLLB)
levartptrs macro plc1,plc2,palette,art,map16x16,map128x128
	!org LevelArtPointers+zone_id_{cur_zone_str}*12
	dc.l (plc1<<24)|art
	dc.l (plc2<<24)|map16x16
	dc.l (palette<<24)|map128x128
cur_zone_id := cur_zone_id+1
cur_zone_str := "\{cur_zone_id}"
    endm

; BEGIN SArt_Ptrs Art_Ptrs_Array[17]
; dword_42594: MainLoadBlocks: saArtPtrs:
LevelArtPointers:
	levartptrs PLCID_Ehz1,     PLCID_Ehz2,      PalID_EHZ,  ArtKos_EHZ, BM16_EHZ, BM128_EHZ ;   0 ; EHZ  ; EMERALD HILL ZONE
	levartptrs PLCID_Miles1up, PLCID_MilesLife, PalID_EHZ2, ArtKos_EHZ, BM16_EHZ, BM128_EHZ ;   1 ; LEV1 ; LEVEL 1 (UNUSED)
	levartptrs PLCID_Tails1up, PLCID_TailsLife, PalID_WZ,   ArtKos_EHZ, BM16_EHZ, BM128_EHZ ;   2 ; LEV2 ; LEVEL 2 (UNUSED)
	levartptrs PLCID_Unused1,  PLCID_Unused2,   PalID_EHZ3, ArtKos_EHZ, BM16_EHZ, BM128_EHZ ;   3 ; LEV3 ; LEVEL 3 (UNUSED)
	levartptrs PLCID_Mtz1,     PLCID_Mtz2,      PalID_MTZ,  ArtKos_MTZ, BM16_MTZ, BM128_MTZ ;   4 ; MTZ  ; METROPOLIS ZONE ACTS 1 & 2
	levartptrs PLCID_Mtz1,     PLCID_Mtz2,      PalID_MTZ,  ArtKos_MTZ, BM16_MTZ, BM128_MTZ ;   5 ; MTZ3 ; METROPOLIS ZONE ACT 3
	levartptrs PLCID_Wfz1,     PLCID_Wfz2,      PalID_WFZ,  ArtKos_SCZ, BM16_WFZ, BM128_WFZ ;   6 ; WFZ  ; WING FORTRESS ZONE
	levartptrs PLCID_Htz1,     PLCID_Htz2,      PalID_HTZ,  ArtKos_EHZ, BM16_EHZ, BM128_EHZ ;   7 ; HTZ  ; HILL TOP ZONE
	levartptrs PLCID_Hpz1,     PLCID_Hpz2,      PalID_HPZ,  ArtKos_HPZ, BM16_HPZ, BM128_HPZ ;   8 ; HPZ  ; HIDDEN PALACE ZONE (UNUSED)
	levartptrs PLCID_Unused3,  PLCID_Unused4,   PalID_EHZ4, ArtKos_EHZ, BM16_EHZ, BM128_EHZ ;   9 ; LEV9 ; LEVEL 9 (UNUSED)
	levartptrs PLCID_Ooz1,     PLCID_Ooz2,      PalID_OOZ,  ArtKos_OOZ, BM16_OOZ, BM128_OOZ ;  $A ; OOZ  ; OIL OCEAN ZONE
	levartptrs PLCID_Mcz1,     PLCID_Mcz2,      PalID_MCZ,  ArtKos_MCZ, BM16_MCZ, BM128_MCZ ;  $B ; MCZ  ; MYSTIC CAVE ZONE
	levartptrs PLCID_Cnz1,     PLCID_Cnz2,      PalID_CNZ,  ArtKos_CNZ, BM16_CNZ, BM128_CNZ ;  $C ; CNZ  ; CASINO NIGHT ZONE
	levartptrs PLCID_Cpz1,     PLCID_Cpz2,      PalID_CPZ,  ArtKos_CPZ, BM16_CPZ, BM128_CPZ ;  $D ; CPZ  ; CHEMICAL PLANT ZONE
	levartptrs PLCID_Dez1,     PLCID_Dez2,      PalID_DEZ,  ArtKos_CPZ, BM16_CPZ, BM128_CPZ ;  $E ; DEZ  ; DEATH EGG ZONE
	levartptrs PLCID_Arz1,     PLCID_Arz2,      PalID_ARZ,  ArtKos_ARZ, BM16_ARZ, BM128_ARZ ;  $F ; ARZ  ; AQUATIC RUIN ZONE
	levartptrs PLCID_Scz1,     PLCID_Scz2,      PalID_SCZ,  ArtKos_SCZ, BM16_WFZ, BM128_WFZ ; $10 ; SCZ  ; SKY CHASE ZONE

    if (cur_zone_id<>no_of_zones)&&(MOMPASS=1)
	message "Warning: Table LevelArtPointers has \{cur_zone_id/1.0} entries, but it should have \{no_of_zones/1.0} entries"
    endif
	!org LevelArtPointers+cur_zone_id*12

; ---------------------------------------------------------------------------
; END Art_Ptrs_Array[17]




; ---------------------------------------------------------------------------
; PATTERN LOAD REQUEST LISTS
;
; Pattern load request lists are simple structures used to load
; Nemesis-compressed art for sprites.
;
; The decompressor predictably moves down the list, so request 0 is processed first, etc.
; This only matters if your addresses are bad and you overwrite art loaded in a previous request.
;

; NOTICE: The load queue buffer can only hold $10 (16) load requests. None of the routines
; that load PLRs into the queue do any bounds checking, so it's possible to create a buffer
; overflow and completely screw up the variables stored directly after the queue buffer.
; (in my experience this is a guaranteed crash or hang)
;
; Many levels queue more than 16 items overall,
; but they don't exceed the limit because
; their PLRs are split into multiple parts (like PlrList_Mtz1 and PlrList_Mtz2)
; and they fully process the first part before requesting the rest.
; 
; If you can find some extra RAM for it (which is easy in Sonic 2),
; you can increase this limit by increasing the size of Plc_Buffer.
; ---------------------------------------------------------------------------

;---------------------------------------------------------------------------------------
; Table of pattern load request lists. Remember to use word-length data when adding lists
; otherwise you'll break the array.
;---------------------------------------------------------------------------------------
; word_42660 ; OffInd_PlrLists:
ArtLoadCues:		offsetTable
PLCptr_Std1:		offsetTableEntry.w PlrList_Std1			; 0
PLCptr_Std2:		offsetTableEntry.w PlrList_Std2			; 1
PLCptr_StdWtr:		offsetTableEntry.w PlrList_StdWtr		; 2
PLCptr_GameOver:	offsetTableEntry.w PlrList_GameOver		; 3
PLCptr_Ehz1:		offsetTableEntry.w PlrList_Ehz1			; 4
PLCptr_Ehz2:		offsetTableEntry.w PlrList_Ehz2			; 5
PLCptr_Miles1up:	offsetTableEntry.w PlrList_Miles1up		; 6
PLCptr_MilesLife:	offsetTableEntry.w PlrList_MilesLifeCounter	; 7
PLCptr_Tails1up:	offsetTableEntry.w PlrList_Tails1up		; 8
PLCptr_TailsLife:	offsetTableEntry.w PlrList_TailsLifeCounter	; 9
PLCptr_Unused1:		offsetTableEntry.w PlrList_Mtz1			; 10
PLCptr_Unused2:		offsetTableEntry.w PlrList_Mtz1			; 11
PLCptr_Mtz1:		offsetTableEntry.w PlrList_Mtz1			; 12
PLCptr_Mtz2:		offsetTableEntry.w PlrList_Mtz2			; 13
			offsetTableEntry.w PlrList_Wfz1			; 14
			offsetTableEntry.w PlrList_Wfz1			; 15
PLCptr_Wfz1:		offsetTableEntry.w PlrList_Wfz1			; 16
PLCptr_Wfz2:		offsetTableEntry.w PlrList_Wfz2			; 17
PLCptr_Htz1:		offsetTableEntry.w PlrList_Htz1			; 18
PLCptr_Htz2:		offsetTableEntry.w PlrList_Htz2			; 19
PLCptr_Hpz1:		offsetTableEntry.w PlrList_Hpz1			; 20
PLCptr_Hpz2:		offsetTableEntry.w PlrList_Hpz2			; 21
PLCptr_Unused3:		offsetTableEntry.w PlrList_Ooz1			; 22
PLCptr_Unused4:		offsetTableEntry.w PlrList_Ooz1			; 23
PLCptr_Ooz1:		offsetTableEntry.w PlrList_Ooz1			; 24
PLCptr_Ooz2:		offsetTableEntry.w PlrList_Ooz2			; 25
PLCptr_Mcz1:		offsetTableEntry.w PlrList_Mcz1			; 26
PLCptr_Mcz2:		offsetTableEntry.w PlrList_Mcz2			; 27
PLCptr_Cnz1:		offsetTableEntry.w PlrList_Cnz1			; 28
PLCptr_Cnz2:		offsetTableEntry.w PlrList_Cnz2			; 29
PLCptr_Cpz1:		offsetTableEntry.w PlrList_Cpz1			; 30
PLCptr_Cpz2:		offsetTableEntry.w PlrList_Cpz2			; 31
PLCptr_Dez1:		offsetTableEntry.w PlrList_Dez1			; 32
PLCptr_Dez2:		offsetTableEntry.w PlrList_Dez2			; 33
PLCptr_Arz1:		offsetTableEntry.w PlrList_Arz1			; 34
PLCptr_Arz2:		offsetTableEntry.w PlrList_Arz2			; 35
PLCptr_Scz1:		offsetTableEntry.w PlrList_Scz1			; 36
PLCptr_Scz2:		offsetTableEntry.w PlrList_Scz2			; 37
PLCptr_Results:		offsetTableEntry.w PlrList_Results		; 38
PLCptr_Signpost:	offsetTableEntry.w PlrList_Signpost		; 39
PLCptr_CpzBoss:		offsetTableEntry.w PlrList_CpzBoss		; 40
PLCptr_EhzBoss:		offsetTableEntry.w PlrList_EhzBoss		; 41
PLCptr_HtzBoss:		offsetTableEntry.w PlrList_HtzBoss		; 42
PLCptr_ArzBoss:		offsetTableEntry.w PlrList_ArzBoss		; 43
PLCptr_MczBoss:		offsetTableEntry.w PlrList_MczBoss		; 44
PLCptr_CnzBoss:		offsetTableEntry.w PlrList_CnzBoss		; 45
PLCptr_MtzBoss:		offsetTableEntry.w PlrList_MtzBoss		; 46
PLCptr_OozBoss:		offsetTableEntry.w PlrList_OozBoss		; 47
PLCptr_FieryExplosion:	offsetTableEntry.w PlrList_FieryExplosion	; 48
PLCptr_DezBoss:		offsetTableEntry.w PlrList_DezBoss		; 49
PLCptr_EhzAnimals:	offsetTableEntry.w PlrList_EhzAnimals		; 50
PLCptr_MczAnimals:	offsetTableEntry.w PlrList_MczAnimals		; 51
PLCptr_HtzAnimals:
PLCptr_MtzAnimals:
PLCptr_WfzAnimals:	offsetTableEntry.w PlrList_WfzAnimals		; 52
PLCptr_DezAnimals:	offsetTableEntry.w PlrList_DezAnimals		; 53
PLCptr_HpzAnimals:	offsetTableEntry.w PlrList_HpzAnimals		; 54
PLCptr_OozAnimals:	offsetTableEntry.w PlrList_OozAnimals		; 55
PLCptr_SczAnimals:	offsetTableEntry.w PlrList_SczAnimals		; 56
PLCptr_CnzAnimals:	offsetTableEntry.w PlrList_CnzAnimals		; 57
PLCptr_CpzAnimals:	offsetTableEntry.w PlrList_CpzAnimals		; 58
PLCptr_ArzAnimals:	offsetTableEntry.w PlrList_ArzAnimals		; 59
PLCptr_SpecialStage:	offsetTableEntry.w PlrList_SpecialStage		; 60
PLCptr_SpecStageBombs:	offsetTableEntry.w PlrList_SpecStageBombs	; 61
PLCptr_WfzBoss:		offsetTableEntry.w PlrList_WfzBoss		; 62
PLCptr_Tornado:		offsetTableEntry.w PlrList_Tornado		; 63
PLCptr_Capsule:		offsetTableEntry.w PlrList_Capsule		; 64
PLCptr_Explosion:	offsetTableEntry.w PlrList_Explosion		; 65
PLCptr_ResultsTails:	offsetTableEntry.w PlrList_ResultsTails		; 66

; macro for a pattern load request list header
; must be on the same line as a label that has a corresponding _End label later
plrlistheader macro {INTLABEL}
__LABEL__ label *
	dc.w (((__LABEL___End - __LABEL__Plc) / 6) - 1)
__LABEL__Plc:
    endm

; macro for a pattern load request
plreq macro toVRAMaddr,fromROMaddr
	dc.l	fromROMaddr
	dc.w	tiles_to_bytes(toVRAMaddr)
    endm

;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Standard 1 - loaded for every level
;---------------------------------------------------------------------------------------
PlrList_Std1: plrlistheader
	plreq ArtTile_ArtNem_HUD, ArtNem_HUD
	plreq ArtTile_ArtNem_life_counter, ArtNem_Sonic_life_counter
	plreq ArtTile_ArtNem_Ring, ArtNem_Ring
	plreq ArtTile_ArtNem_Numbers, ArtNem_Numbers
PlrList_Std1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Standard 2 - loaded for every level
;---------------------------------------------------------------------------------------
PlrList_Std2: plrlistheader
	plreq ArtTile_ArtNem_Checkpoint, ArtNem_Checkpoint
	plreq ArtTile_ArtNem_Powerups, ArtNem_Powerups
	plreq ArtTile_ArtNem_Shield, ArtNem_Shield
	plreq ArtTile_ArtNem_Invincible_stars, ArtNem_Invincible_stars
PlrList_Std2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Aquatic level standard
;---------------------------------------------------------------------------------------
PlrList_StdWtr:	plrlistheader
	plreq ArtTile_ArtNem_Explosion, ArtNem_Explosion
	plreq ArtTile_ArtNem_SuperSonic_stars, ArtNem_SuperSonic_stars
	plreq ArtTile_ArtNem_Bubbles, ArtNem_Bubbles
PlrList_StdWtr_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Game/Time over
;---------------------------------------------------------------------------------------
PlrList_GameOver: plrlistheader
	plreq ArtTile_ArtNem_Game_Over, ArtNem_Game_Over
PlrList_GameOver_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Emerald Hill Zone primary
;---------------------------------------------------------------------------------------
PlrList_Ehz1: plrlistheader
	plreq ArtTile_ArtNem_Waterfall, ArtNem_Waterfall
	plreq ArtTile_ArtNem_EHZ_Bridge, ArtNem_EHZ_Bridge
	plreq ArtTile_ArtNem_Buzzer_Fireball, ArtNem_HtzFireball1
	plreq ArtTile_ArtNem_Buzzer, ArtNem_Buzzer
	plreq ArtTile_ArtNem_Coconuts, ArtNem_Coconuts
	plreq ArtTile_ArtNem_Masher, ArtNem_Masher
PlrList_Ehz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Emerald Hill Zone secondary
;---------------------------------------------------------------------------------------
PlrList_Ehz2: plrlistheader
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_DignlSprng
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Ehz2_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Miles 1up patch
;---------------------------------------------------------------------------------------
PlrList_Miles1up: plrlistheader
	plreq ArtTile_ArtUnc_2p_life_counter, ArtUnc_MilesLife
PlrList_Miles1up_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Miles life counter
;---------------------------------------------------------------------------------------
PlrList_MilesLifeCounter: plrlistheader
	plreq ArtTile_ArtNem_life_counter, ArtUnc_MilesLife
PlrList_MilesLifeCounter_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Tails 1up patch
;---------------------------------------------------------------------------------------
PlrList_Tails1up: plrlistheader
	plreq ArtTile_ArtUnc_2p_life_counter, ArtNem_TailsLife
PlrList_Tails1up_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Tails life counter
;---------------------------------------------------------------------------------------
PlrList_TailsLifeCounter: plrlistheader
	plreq ArtTile_ArtNem_life_counter, ArtNem_TailsLife
PlrList_TailsLifeCounter_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Metropolis Zone primary
;---------------------------------------------------------------------------------------
PlrList_Mtz1: plrlistheader
	plreq ArtTile_ArtNem_MtzWheel, ArtNem_MtzWheel
	plreq ArtTile_ArtNem_MtzWheelIndent, ArtNem_MtzWheelIndent
	plreq ArtTile_ArtNem_LavaCup, ArtNem_LavaCup
	plreq ArtTile_ArtNem_BoltEnd_Rope, ArtNem_BoltEnd_Rope
	plreq ArtTile_ArtNem_MtzSteam, ArtNem_MtzSteam
	plreq ArtTile_ArtNem_MtzSpikeBlock, ArtNem_MtzSpikeBlock
	plreq ArtTile_ArtNem_MtzSpike, ArtNem_MtzSpike
	plreq ArtTile_ArtNem_Shellcracker, ArtNem_Shellcracker
	plreq ArtTile_ArtNem_MtzSupernova, ArtNem_MtzSupernova
PlrList_Mtz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Metropolis Zone secondary
;---------------------------------------------------------------------------------------
PlrList_Mtz2: plrlistheader
	plreq ArtTile_ArtNem_Button, ArtNem_Button
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_MtzMantis, ArtNem_MtzMantis
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
	plreq ArtTile_ArtNem_MtzAsstBlocks, ArtNem_MtzAsstBlocks
	plreq ArtTile_ArtNem_MtzLavaBubble, ArtNem_MtzLavaBubble
	plreq ArtTile_ArtNem_MtzCog, ArtNem_MtzCog
	plreq ArtTile_ArtNem_MtzSpinTubeFlash, ArtNem_MtzSpinTubeFlash
PlrList_Mtz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Wing Fortress Zone primary
;---------------------------------------------------------------------------------------
PlrList_Wfz1: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
	plreq ArtTile_ArtNem_WfzVrtclPrpllr, ArtNem_WfzVrtclPrpllr
	plreq ArtTile_ArtNem_WfzHrzntlPrpllr, ArtNem_WfzHrzntlPrpllr
	plreq ArtTile_ArtNem_Balkrie, ArtNem_Balkrie
	plreq ArtTile_ArtNem_BreakPanels, ArtNem_BreakPanels
	plreq ArtTile_ArtNem_WfzScratch, ArtNem_WfzScratch
	plreq ArtTile_ArtNem_WfzTiltPlatforms, ArtNem_WfzTiltPlatforms
	; These two are already in the list, so this is redundant
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
PlrList_Wfz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Wing Fortress Zone secondary
;---------------------------------------------------------------------------------------
PlrList_Wfz2: plrlistheader
	plreq ArtTile_ArtNem_WfzVrtclPrpllr, ArtNem_WfzVrtclPrpllr
	plreq ArtTile_ArtNem_WfzHrzntlPrpllr, ArtNem_WfzHrzntlPrpllr
	plreq ArtTile_ArtNem_WfzVrtclLazer, ArtNem_WfzVrtclLazer
	plreq ArtTile_ArtNem_WfzWallTurret, ArtNem_WfzWallTurret
	plreq ArtTile_ArtNem_WfzHrzntlLazer, ArtNem_WfzHrzntlLazer
	plreq ArtTile_ArtNem_WfzConveyorBeltWheel, ArtNem_WfzConveyorBeltWheel
	plreq ArtTile_ArtNem_WfzHook, ArtNem_WfzHook
	plreq ArtTile_ArtNem_WfzThrust, ArtNem_WfzThrust
	plreq ArtTile_ArtNem_WfzBeltPlatform, ArtNem_WfzBeltPlatform
	plreq ArtTile_ArtNem_WfzGunPlatform, ArtNem_WfzGunPlatform
	plreq ArtTile_ArtNem_WfzUnusedBadnik, ArtNem_WfzUnusedBadnik
	plreq ArtTile_ArtNem_WfzLaunchCatapult, ArtNem_WfzLaunchCatapult
	plreq ArtTile_ArtNem_WfzSwitch, ArtNem_WfzSwitch
	plreq ArtTile_ArtNem_WfzFloatingPlatform, ArtNem_WfzFloatingPlatform
PlrList_Wfz2_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Hill Top Zone primary
;---------------------------------------------------------------------------------------
PlrList_Htz1: plrlistheader
	plreq ArtTile_ArtNem_HtzFireball1, ArtNem_HtzFireball1
	plreq ArtTile_ArtNem_HtzRock, ArtNem_HtzRock
	plreq ArtTile_ArtNem_HtzSeeSaw, ArtNem_HtzSeeSaw
	plreq ArtTile_ArtNem_Sol, ArtNem_Sol
	plreq ArtTile_ArtNem_Rexon, ArtNem_Rexon
	plreq ArtTile_ArtNem_Spiker, ArtNem_Spiker
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_DignlSprng
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Htz1_End
;---------------------------------------------------------------------------------------
; PATTERN LOAD REQUEST LIST
; Hill Top Zone secondary
;---------------------------------------------------------------------------------------
PlrList_Htz2: plrlistheader
	plreq ArtTile_ArtNem_HtzZipline, ArtNem_HtzZipline
	plreq ArtTile_ArtNem_HtzFireball2, ArtNem_HtzFireball2
	plreq ArtTile_ArtNem_HtzValveBarrier, ArtNem_HtzValveBarrier
PlrList_Htz2_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; HPZ Primary
;---------------------------------------------------------------------------------------
PlrList_Hpz1: ;plrlistheader
;	plreq ArtTile_ArtNem_WaterSurface, ArtNem_WaterSurface
;PlrList_Hpz1_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; HPZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Hpz2: ;plrlistheader
;PlrList_Hpz2_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; OOZ Primary
;---------------------------------------------------------------------------------------
PlrList_Ooz1: plrlistheader
	plreq ArtTile_ArtNem_OOZBurn, ArtNem_OOZBurn
	plreq ArtTile_ArtNem_OOZElevator, ArtNem_OOZElevator
	plreq ArtTile_ArtNem_SpikyThing, ArtNem_SpikyThing
	plreq ArtTile_ArtNem_BurnerLid, ArtNem_BurnerLid
	plreq ArtTile_ArtNem_StripedBlocksVert, ArtNem_StripedBlocksVert
	plreq ArtTile_ArtNem_Oilfall, ArtNem_Oilfall
	plreq ArtTile_ArtNem_Oilfall2, ArtNem_Oilfall2
	plreq ArtTile_ArtNem_BallThing, ArtNem_BallThing
	plreq ArtTile_ArtNem_LaunchBall, ArtNem_LaunchBall
PlrList_Ooz1_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; OOZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Ooz2: plrlistheader
	plreq ArtTile_ArtNem_OOZPlatform, ArtNem_OOZPlatform
	plreq ArtTile_ArtNem_PushSpring, ArtNem_PushSpring
	plreq ArtTile_ArtNem_OOZSwingPlat, ArtNem_OOZSwingPlat
	plreq ArtTile_ArtNem_StripedBlocksHoriz, ArtNem_StripedBlocksHoriz
	plreq ArtTile_ArtNem_OOZFanHoriz, ArtNem_OOZFanHoriz
	plreq ArtTile_ArtNem_Button, ArtNem_Button
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_DignlSprng
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
	plreq ArtTile_ArtNem_Aquis, ArtNem_Aquis
	plreq ArtTile_ArtNem_Octus, ArtNem_Octus
PlrList_Ooz2_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; MCZ Primary
;---------------------------------------------------------------------------------------
PlrList_Mcz1: plrlistheader
	plreq ArtTile_ArtNem_Crate, ArtNem_Crate
	plreq ArtTile_ArtNem_MCZCollapsePlat, ArtNem_MCZCollapsePlat
	plreq ArtTile_ArtNem_VineSwitch, ArtNem_VineSwitch
	plreq ArtTile_ArtNem_VinePulley, ArtNem_VinePulley
	plreq ArtTile_ArtNem_Flasher, ArtNem_Flasher
	plreq ArtTile_ArtNem_Crawlton, ArtNem_Crawlton
PlrList_Mcz1_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; MCZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Mcz2: plrlistheader
	plreq ArtTile_ArtNem_HorizSpike, ArtNem_HorizSpike
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_MCZGateLog, ArtNem_MCZGateLog
	plreq ArtTile_ArtNem_LeverSpring, ArtNem_LeverSpring
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Mcz2_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; CNZ Primary
;---------------------------------------------------------------------------------------
PlrList_Cnz1: plrlistheader
	plreq ArtTile_ArtNem_Crawl, ArtNem_Crawl
	plreq ArtTile_ArtNem_BigMovingBlock, ArtNem_BigMovingBlock
	plreq ArtTile_ArtNem_CNZSnake, ArtNem_CNZSnake
	plreq ArtTile_ArtNem_CNZBonusSpike, ArtNem_CNZBonusSpike
	plreq ArtTile_ArtNem_CNZElevator, ArtNem_CNZElevator
	plreq ArtTile_ArtNem_CNZCage, ArtNem_CNZCage
	plreq ArtTile_ArtNem_CNZHexBumper, ArtNem_CNZHexBumper
	plreq ArtTile_ArtNem_CNZRoundBumper, ArtNem_CNZRoundBumper
	plreq ArtTile_ArtNem_CNZFlipper, ArtNem_CNZFlipper
	plreq ArtTile_ArtNem_CNZMiniBumper, ArtNem_CNZMiniBumper
PlrList_Cnz1_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; CNZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Cnz2: plrlistheader
	plreq ArtTile_ArtNem_CNZDiagPlunger, ArtNem_CNZDiagPlunger
	plreq ArtTile_ArtNem_CNZVertPlunger, ArtNem_CNZVertPlunger
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_DignlSprng
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Cnz2_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; CPZ Primary
;---------------------------------------------------------------------------------------
PlrList_Cpz1: plrlistheader
	plreq ArtTile_ArtNem_CPZMetalThings, ArtNem_CPZMetalThings
	plreq ArtTile_ArtNem_ConstructionStripes_2, ArtNem_ConstructionStripes
	plreq ArtTile_ArtNem_CPZBooster, ArtNem_CPZBooster
	plreq ArtTile_ArtNem_CPZElevator, ArtNem_CPZElevator
	plreq ArtTile_ArtNem_CPZAnimatedBits, ArtNem_CPZAnimatedBits
	plreq ArtTile_ArtNem_CPZTubeSpring, ArtNem_CPZTubeSpring
	plreq ArtTile_ArtNem_WaterSurface, ArtNem_WaterSurface
	plreq ArtTile_ArtNem_CPZStairBlock, ArtNem_CPZStairBlock
	plreq ArtTile_ArtNem_CPZMetalBlock, ArtNem_CPZMetalBlock
PlrList_Cpz1_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; CPZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Cpz2: plrlistheader
	plreq ArtTile_ArtNem_Grabber, ArtNem_Grabber
	plreq ArtTile_ArtNem_Spiny, ArtNem_Spiny
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_DignlSprng, ArtNem_CPZDroplet
	plreq ArtTile_ArtNem_LeverSpring, ArtNem_LeverSpring
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Cpz2_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; DEZ Primary
;---------------------------------------------------------------------------------------
PlrList_Dez1: plrlistheader
	plreq ArtTile_ArtNem_ConstructionStripes_1, ArtNem_ConstructionStripes
PlrList_Dez1_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; DEZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Dez2: plrlistheader
	plreq ArtTile_ArtNem_SilverSonic, ArtNem_SilverSonic
	plreq ArtTile_ArtNem_DEZWindow, ArtNem_DEZWindow
	plreq ArtTile_ArtNem_RobotnikRunning, ArtNem_RobotnikRunning
	plreq ArtTile_ArtNem_RobotnikUpper, ArtNem_RobotnikUpper
	plreq ArtTile_ArtNem_RobotnikLower, ArtNem_RobotnikLower
PlrList_Dez2_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; ARZ Primary
;---------------------------------------------------------------------------------------
PlrList_Arz1: plrlistheader
	plreq ArtTile_ArtNem_ARZBarrierThing, ArtNem_ARZBarrierThing
	plreq ArtTile_ArtNem_WaterSurface, ArtNem_WaterSurface2
	plreq ArtTile_ArtNem_Leaves, ArtNem_Leaves
	plreq ArtTile_ArtNem_ArrowAndShooter, ArtNem_ArrowAndShooter
PlrList_Arz1_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; ARZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Arz2: plrlistheader
	plreq ArtTile_ArtNem_ChopChop, ArtNem_ChopChop
	plreq ArtTile_ArtNem_Whisp, ArtNem_Whisp
	plreq ArtTile_ArtNem_Grounder, ArtNem_Grounder
	plreq ArtTile_ArtNem_BigBubbles, ArtNem_BigBubbles
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_LeverSpring, ArtNem_LeverSpring
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Arz2_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; SCZ Primary
;---------------------------------------------------------------------------------------
PlrList_Scz1: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
PlrList_Scz1_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; SCZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Scz2: plrlistheader
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
	plreq ArtTile_ArtNem_WfzVrtclPrpllr, ArtNem_WfzVrtclPrpllr
	plreq ArtTile_ArtNem_WfzHrzntlPrpllr, ArtNem_WfzHrzntlPrpllr
	plreq ArtTile_ArtNem_Balkrie, ArtNem_Balkrie
	plreq ArtTile_ArtNem_Turtloid, ArtNem_Turtloid
	plreq ArtTile_ArtNem_Nebula, ArtNem_Nebula
PlrList_Scz2_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Sonic end of level results screen
;---------------------------------------------------------------------------------------
PlrList_Results: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniSonic
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_Results_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; End of level signpost
;---------------------------------------------------------------------------------------
PlrList_Signpost: plrlistheader
	plreq ArtTile_ArtNem_Signpost, ArtNem_Signpost
PlrList_Signpost_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; CPZ Boss
;---------------------------------------------------------------------------------------
PlrList_CpzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_3, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CPZBoss, ArtNem_CPZBoss
	plreq ArtTile_ArtNem_EggpodJets_1, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_BossSmoke_1, ArtNem_BossSmoke
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CpzBoss_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; EHZ Boss
;---------------------------------------------------------------------------------------
PlrList_EhzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_1, ArtNem_Eggpod
	plreq ArtTile_ArtNem_EHZBoss, ArtNem_EHZBoss
	plreq ArtTile_ArtNem_EggChoppers, ArtNem_EggChoppers
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_EhzBoss_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; HTZ Boss
;---------------------------------------------------------------------------------------
PlrList_HtzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_2, ArtNem_Eggpod
	plreq ArtTile_ArtNem_HTZBoss, ArtNem_HTZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
	plreq ArtTile_ArtNem_BossSmoke_2, ArtNem_BossSmoke
PlrList_HtzBoss_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; ARZ Boss
;---------------------------------------------------------------------------------------
PlrList_ArzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_ARZBoss, ArtNem_ARZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_ArzBoss_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; MCZ Boss
;---------------------------------------------------------------------------------------
PlrList_MczBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MCZBoss, ArtNem_MCZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MczBoss_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; CNZ Boss
;---------------------------------------------------------------------------------------
PlrList_CnzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CNZBoss, ArtNem_CNZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CnzBoss_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; MTZ Boss
;---------------------------------------------------------------------------------------
PlrList_MtzBoss: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MTZBoss, ArtNem_MTZBoss
	plreq ArtTile_ArtNem_EggpodJets_2, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MtzBoss_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; OOZ Boss
;---------------------------------------------------------------------------------------
PlrList_OozBoss: plrlistheader
	plreq ArtTile_ArtNem_OOZBoss, ArtNem_OOZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_OozBoss_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Fiery Explosion
;---------------------------------------------------------------------------------------
PlrList_FieryExplosion: plrlistheader
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_FieryExplosion_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Death Egg
;---------------------------------------------------------------------------------------
PlrList_DezBoss: plrlistheader
	plreq ArtTile_ArtNem_DEZBoss, ArtNem_DEZBoss
PlrList_DezBoss_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; EHZ Animals
;---------------------------------------------------------------------------------------
PlrList_EhzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Squirrel
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Bird
PlrList_EhzAnimals_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; MCZ Animals
;---------------------------------------------------------------------------------------
PlrList_MczAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_MczAnimals_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; HTZ/MTZ/WFZ animals
;---------------------------------------------------------------------------------------
PlrList_HtzAnimals:
PlrList_MtzAnimals:
PlrList_WfzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Beaver
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_HtzAnimals_End
PlrList_MtzAnimals_End
PlrList_WfzAnimals_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; DEZ Animals
;---------------------------------------------------------------------------------------
PlrList_DezAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Pig
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_DezAnimals_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; HPZ animals
;---------------------------------------------------------------------------------------
PlrList_HpzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_HpzAnimals_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; OOZ Animals
;---------------------------------------------------------------------------------------
PlrList_OozAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_OozAnimals_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; SCZ Animals
;---------------------------------------------------------------------------------------
PlrList_SczAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Turtle
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_SczAnimals_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; CNZ Animals
;---------------------------------------------------------------------------------------
PlrList_CnzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Bear
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Bird
PlrList_CnzAnimals_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; CPZ Animals
;---------------------------------------------------------------------------------------
PlrList_CpzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Rabbit
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_CpzAnimals_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; ARZ Animals
;---------------------------------------------------------------------------------------
PlrList_ArzAnimals: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Bird
PlrList_ArzAnimals_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Special Stage
;---------------------------------------------------------------------------------------
PlrList_SpecialStage: plrlistheader
	plreq ArtTile_ArtNem_SpecialEmerald, ArtNem_SpecialEmerald
	plreq ArtTile_ArtNem_SpecialMessages, ArtNem_SpecialMessages
	plreq ArtTile_ArtNem_SpecialHUD, ArtNem_SpecialHUD
	plreq ArtTile_ArtNem_SpecialFlatShadow, ArtNem_SpecialFlatShadow
	plreq ArtTile_ArtNem_SpecialDiagShadow, ArtNem_SpecialDiagShadow
	plreq ArtTile_ArtNem_SpecialSideShadow, ArtNem_SpecialSideShadow
	plreq ArtTile_ArtNem_SpecialExplosion, ArtNem_SpecialExplosion
	plreq ArtTile_ArtNem_SpecialRings, ArtNem_SpecialRings
	plreq ArtTile_ArtNem_SpecialStart, ArtNem_SpecialStart
	plreq ArtTile_ArtNem_SpecialPlayerVSPlayer, ArtNem_SpecialPlayerVSPlayer
	plreq ArtTile_ArtNem_SpecialBack, ArtNem_SpecialBack
	plreq ArtTile_ArtNem_SpecialStars, ArtNem_SpecialStars
	plreq ArtTile_ArtNem_SpecialTailsText, ArtNem_SpecialTailsText
PlrList_SpecialStage_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Special Stage Bombs
;---------------------------------------------------------------------------------------
PlrList_SpecStageBombs: plrlistheader
	plreq ArtTile_ArtNem_SpecialBomb, ArtNem_SpecialBomb
PlrList_SpecStageBombs_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; WFZ Boss
;---------------------------------------------------------------------------------------
PlrList_WfzBoss: plrlistheader
	plreq ArtTile_ArtNem_WFZBoss, ArtNem_WFZBoss
	plreq ArtTile_ArtNem_RobotnikRunning, ArtNem_RobotnikRunning
	plreq ArtTile_ArtNem_RobotnikUpper, ArtNem_RobotnikUpper
	plreq ArtTile_ArtNem_RobotnikLower, ArtNem_RobotnikLower
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_WfzBoss_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Tornado
;---------------------------------------------------------------------------------------
PlrList_Tornado: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_TornadoThruster, ArtNem_TornadoThruster
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
PlrList_Tornado_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Capsule/Egg Prison
;---------------------------------------------------------------------------------------
PlrList_Capsule: plrlistheader
	plreq ArtTile_ArtNem_Capsule, ArtNem_Capsule
PlrList_Capsule_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Normal explosion
;---------------------------------------------------------------------------------------
PlrList_Explosion: plrlistheader
	plreq ArtTile_ArtNem_Explosion, ArtNem_Explosion
PlrList_Explosion_End
;---------------------------------------------------------------------------------------
; Pattern load queue
; Tails end of level results screen
;---------------------------------------------------------------------------------------
PlrList_ResultsTails: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniTails
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_ResultsTails_End




;---------------------------------------------------------------------------------------
; Weird revision-specific duplicates of portions of the PLR lists (unused)
;---------------------------------------------------------------------------------------
    if gameRevision=0
	; half of PlrList_ResultsTails
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniTails
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_ResultsTails_Dup_End
	dc.l	0
    elseif gameRevision=2
	; half of the second ARZ PLR list
	plreq ArtTile_ArtNem_Grounder, ArtNem_Grounder
	plreq ArtTile_ArtNem_BigBubbles, ArtNem_BigBubbles
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_LeverSpring, ArtNem_LeverSpring
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Arz2_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; SCZ Primary
;---------------------------------------------------------------------------------------
PlrList_Scz1_Dup: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
PlrList_Scz1_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; SCZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Scz2_Dup: plrlistheader
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
	plreq ArtTile_ArtNem_WfzVrtclPrpllr, ArtNem_WfzVrtclPrpllr
	plreq ArtTile_ArtNem_WfzHrzntlPrpllr, ArtNem_WfzHrzntlPrpllr
	plreq ArtTile_ArtNem_Balkrie, ArtNem_Balkrie
	plreq ArtTile_ArtNem_Turtloid, ArtNem_Turtloid
	plreq ArtTile_ArtNem_Nebula, ArtNem_Nebula
PlrList_Scz2_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Sonic end of level results screen
;---------------------------------------------------------------------------------------
PlrList_Results_Dup: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniSonic
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_Results_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; End of level signpost
;---------------------------------------------------------------------------------------
PlrList_Signpost_Dup: plrlistheader
	plreq ArtTile_ArtNem_Signpost, ArtNem_Signpost
PlrList_Signpost_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; CPZ Boss
;---------------------------------------------------------------------------------------
PlrList_CpzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_3, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CPZBoss, ArtNem_CPZBoss
	plreq ArtTile_ArtNem_EggpodJets_1, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_BossSmoke_1, ArtNem_BossSmoke
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CpzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; EHZ Boss
;---------------------------------------------------------------------------------------
PlrList_EhzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_1, ArtNem_Eggpod
	plreq ArtTile_ArtNem_EHZBoss, ArtNem_EHZBoss
	plreq ArtTile_ArtNem_EggChoppers, ArtNem_EggChoppers
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_EhzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; HTZ Boss
;---------------------------------------------------------------------------------------
PlrList_HtzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_2, ArtNem_Eggpod
	plreq ArtTile_ArtNem_HTZBoss, ArtNem_HTZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
	plreq ArtTile_ArtNem_BossSmoke_2, ArtNem_BossSmoke
PlrList_HtzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; ARZ Boss
;---------------------------------------------------------------------------------------
PlrList_ArzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_ARZBoss, ArtNem_ARZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_ArzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; MCZ Boss
;---------------------------------------------------------------------------------------
PlrList_MczBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MCZBoss, ArtNem_MCZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MczBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; CNZ Boss
;---------------------------------------------------------------------------------------
PlrList_CnzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CNZBoss, ArtNem_CNZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CnzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; MTZ Boss
;---------------------------------------------------------------------------------------
PlrList_MtzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MTZBoss, ArtNem_MTZBoss
	plreq ArtTile_ArtNem_EggpodJets_2, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MtzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; OOZ Boss
;---------------------------------------------------------------------------------------
PlrList_OozBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_OOZBoss, ArtNem_OOZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_OozBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Fiery Explosion
;---------------------------------------------------------------------------------------
PlrList_FieryExplosion_Dup: plrlistheader
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_FieryExplosion_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Death Egg
;---------------------------------------------------------------------------------------
PlrList_DezBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_DEZBoss, ArtNem_DEZBoss
PlrList_DezBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; EHZ Animals
;---------------------------------------------------------------------------------------
PlrList_EhzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Squirrel
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Bird
PlrList_EhzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; MCZ Animals
;---------------------------------------------------------------------------------------
PlrList_MczAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_MczAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; HTZ/MTZ/WFZ animals
;---------------------------------------------------------------------------------------
PlrList_HtzAnimals_Dup:
PlrList_MtzAnimals_Dup:
PlrList_WfzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Beaver
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_HtzAnimals_Dup_End
PlrList_MtzAnimals_Dup_End
PlrList_WfzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; DEZ Animals
;---------------------------------------------------------------------------------------
PlrList_DezAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Pig
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_DezAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; HPZ animals
;---------------------------------------------------------------------------------------
PlrList_HpzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_HpzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; OOZ Animals
;---------------------------------------------------------------------------------------
PlrList_OozAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_OozAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; SCZ Animals
;---------------------------------------------------------------------------------------
PlrList_SczAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Turtle
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_SczAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; CNZ Animals
;---------------------------------------------------------------------------------------
PlrList_CnzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Bear
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Bird
PlrList_CnzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; CPZ Animals
;---------------------------------------------------------------------------------------
PlrList_CpzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Rabbit
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_CpzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; ARZ Animals
;---------------------------------------------------------------------------------------
PlrList_ArzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Bird
PlrList_ArzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Special Stage
;---------------------------------------------------------------------------------------
PlrList_SpecialStage_Dup: plrlistheader
	plreq ArtTile_ArtNem_SpecialEmerald, ArtNem_SpecialEmerald
	plreq ArtTile_ArtNem_SpecialMessages, ArtNem_SpecialMessages
	plreq ArtTile_ArtNem_SpecialHUD, ArtNem_SpecialHUD
	plreq ArtTile_ArtNem_SpecialFlatShadow, ArtNem_SpecialFlatShadow
	plreq ArtTile_ArtNem_SpecialDiagShadow, ArtNem_SpecialDiagShadow
	plreq ArtTile_ArtNem_SpecialSideShadow, ArtNem_SpecialSideShadow
	plreq ArtTile_ArtNem_SpecialExplosion, ArtNem_SpecialExplosion
	plreq ArtTile_ArtNem_SpecialRings, ArtNem_SpecialRings
	plreq ArtTile_ArtNem_SpecialStart, ArtNem_SpecialStart
	plreq ArtTile_ArtNem_SpecialPlayerVSPlayer, ArtNem_SpecialPlayerVSPlayer
	plreq ArtTile_ArtNem_SpecialBack, ArtNem_SpecialBack
	plreq ArtTile_ArtNem_SpecialStars, ArtNem_SpecialStars
	plreq ArtTile_ArtNem_SpecialTailsText, ArtNem_SpecialTailsText
PlrList_SpecialStage_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Special Stage Bombs
;---------------------------------------------------------------------------------------
PlrList_SpecStageBombs_Dup: plrlistheader
	plreq ArtTile_ArtNem_SpecialBomb, ArtNem_SpecialBomb
PlrList_SpecStageBombs_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; WFZ Boss
;---------------------------------------------------------------------------------------
PlrList_WfzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_WFZBoss, ArtNem_WFZBoss
	plreq ArtTile_ArtNem_RobotnikRunning, ArtNem_RobotnikRunning
	plreq ArtTile_ArtNem_RobotnikUpper, ArtNem_RobotnikUpper
	plreq ArtTile_ArtNem_RobotnikLower, ArtNem_RobotnikLower
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_WfzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Tornado
;---------------------------------------------------------------------------------------
PlrList_Tornado_Dup: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_TornadoThruster, ArtNem_TornadoThruster
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
PlrList_Tornado_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Capsule/Egg Prison
;---------------------------------------------------------------------------------------
PlrList_Capsule_Dup: plrlistheader
	plreq ArtTile_ArtNem_Capsule, ArtNem_Capsule
PlrList_Capsule_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Normal explosion
;---------------------------------------------------------------------------------------
PlrList_Explosion_Dup: plrlistheader
	plreq ArtTile_ArtNem_Explosion, ArtNem_Explosion
PlrList_Explosion_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Tails end of level results screen
;---------------------------------------------------------------------------------------
PlrList_ResultsTails_Dup: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniTails
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_ResultsTails_Dup_End
    endif



;---------------------------------------------------------------------------------------
; Curve and resistance mapping
;---------------------------------------------------------------------------------------
ColCurveMap:	BINCLUDE	"collision/Curve and resistance mapping.bin"
	even
;--------------------------------------------------------------------------------------
; Collision arrays
;--------------------------------------------------------------------------------------
ColArray:	BINCLUDE	"collision/Collision array 1.bin"
ColArray2:	BINCLUDE	"collision/Collision array 2.bin"
	even
;---------------------------------------------------------------------------------------
; EHZ and HTZ primary 16x16 collision index (Kosinski compression)
ColP_EHZHTZ:	BINCLUDE	"collision/EHZ and HTZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; EHZ and HTZ secondary 16x16 collision index (Kosinski compression)
ColS_EHZHTZ:	BINCLUDE	"collision/EHZ and HTZ secondary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; MTZ primary 16x16 collision index (Kosinski compression)
ColP_MTZ:	BINCLUDE	"collision/MTZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; HPZ primary 16x16 collision index (Kosinski compression)
ColP_HPZ:	;BINCLUDE	"collision/HPZ primary 16x16 collision index.bin"
	;even
;---------------------------------------------------------------------------------------
; HPZ secondary 16x16 collision index (Kosinski compression)
ColS_HPZ:	;BINCLUDE	"collision/HPZ secondary 16x16 collision index.bin"
	;even
;---------------------------------------------------------------------------------------
; OOZ primary 16x16 collision index (Kosinski compression)
ColP_OOZ:	BINCLUDE	"collision/OOZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; MCZ primary 16x16 collision index (Kosinski compression)
ColP_MCZ:	BINCLUDE	"collision/MCZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; CNZ primary 16x16 collision index (Kosinski compression)
ColP_CNZ:	BINCLUDE	"collision/CNZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; CNZ secondary 16x16 collision index (Kosinski compression)
ColS_CNZ:	BINCLUDE	"collision/CNZ secondary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; CPZ and DEZ primary 16x16 collision index (Kosinski compression)
ColP_CPZDEZ:	BINCLUDE	"collision/CPZ and DEZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; CPZ and DEZ secondary 16x16 collision index (Kosinski compression)
ColS_CPZDEZ:	BINCLUDE	"collision/CPZ and DEZ secondary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; ARZ primary 16x16 collision index (Kosinski compression)
ColP_ARZ:	BINCLUDE	"collision/ARZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; ARZ secondary 16x16 collision index (Kosinski compression)
ColS_ARZ:	BINCLUDE	"collision/ARZ secondary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; WFZ/SCZ primary 16x16 collision index (Kosinski compression)
ColP_WFZSCZ:	BINCLUDE	"collision/WFZ and SCZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; WFZ/SCZ secondary 16x16 collision index (Kosinski compression)
ColS_WFZSCZ:	BINCLUDE	"collision/WFZ and SCZ secondary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------

ColP_Invalid:




;---------------------------------------------------------------------------------------
; Offset index of level layouts
; Two entries per zone, pointing to the level layouts for acts 1 and 2 of each zone
; respectively.
;---------------------------------------------------------------------------------------
Off_Level: zoneOrderedOffsetTable 2,2
	zoneOffsetTableEntry.w Level_EHZ1
	zoneOffsetTableEntry.w Level_EHZ2	; 1
	zoneOffsetTableEntry.w Level_EHZ1	; 2
	zoneOffsetTableEntry.w Level_EHZ1	; 3
	zoneOffsetTableEntry.w Level_EHZ1	; 4
	zoneOffsetTableEntry.w Level_EHZ1	; 5
	zoneOffsetTableEntry.w Level_EHZ1	; 6
	zoneOffsetTableEntry.w Level_EHZ1	; 7
	zoneOffsetTableEntry.w Level_MTZ1	; 8
	zoneOffsetTableEntry.w Level_MTZ2	; 9
	zoneOffsetTableEntry.w Level_MTZ3	; 10
	zoneOffsetTableEntry.w Level_MTZ3	; 11
	zoneOffsetTableEntry.w Level_WFZ	; 12
	zoneOffsetTableEntry.w Level_WFZ	; 13
	zoneOffsetTableEntry.w Level_HTZ1	; 14
	zoneOffsetTableEntry.w Level_HTZ2	; 15
	zoneOffsetTableEntry.w Level_HPZ1	; 16
	zoneOffsetTableEntry.w Level_HPZ1	; 17
	zoneOffsetTableEntry.w Level_EHZ1	; 18
	zoneOffsetTableEntry.w Level_EHZ1	; 19
	zoneOffsetTableEntry.w Level_OOZ1	; 20
	zoneOffsetTableEntry.w Level_OOZ2	; 21
	zoneOffsetTableEntry.w Level_MCZ1	; 22
	zoneOffsetTableEntry.w Level_MCZ2	; 23
	zoneOffsetTableEntry.w Level_CNZ1	; 24
	zoneOffsetTableEntry.w Level_CNZ2	; 25
	zoneOffsetTableEntry.w Level_CPZ1	; 26
	zoneOffsetTableEntry.w Level_CPZ2	; 27
	zoneOffsetTableEntry.w Level_DEZ	; 28
	zoneOffsetTableEntry.w Level_DEZ	; 29
	zoneOffsetTableEntry.w Level_ARZ1	; 30
	zoneOffsetTableEntry.w Level_ARZ2	; 31
	zoneOffsetTableEntry.w Level_SCZ	; 32
	zoneOffsetTableEntry.w Level_SCZ	; 33
    zoneTableEnd
;---------------------------------------------------------------------------------------
; EHZ act 1 level layout (Kosinski compression)
Level_EHZ1:	BINCLUDE	"levels/layout/EHZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; EHZ act 2 level layout (Kosinski compression)
Level_EHZ2:	BINCLUDE	"levels/layout/EHZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; MTZ act 1 level layout (Kosinski compression)
Level_MTZ1:	BINCLUDE	"levels/layout/MTZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; MTZ act 2 level layout (Kosinski compression)
Level_MTZ2:	BINCLUDE	"levels/layout/MTZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; MTZ act 3 level layout (Kosinski compression)
Level_MTZ3:	BINCLUDE	"levels/layout/MTZ_3.bin"
	even
;---------------------------------------------------------------------------------------
; WFZ level layout (Kosinski compression)
Level_WFZ:	BINCLUDE	"levels/layout/WFZ.bin"
	even
;---------------------------------------------------------------------------------------
; HTZ act 1 level layout (Kosinski compression)
Level_HTZ1:	BINCLUDE	"levels/layout/HTZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; HTZ act 2 level layout (Kosinski compression)
Level_HTZ2:	BINCLUDE	"levels/layout/HTZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; HPZ act 1 level layout (Kosinski compression)
Level_HPZ1:	;BINCLUDE	"levels/layout/HPZ_1.bin"
	;even
;---------------------------------------------------------------------------------------
; OOZ act 1 level layout (Kosinski compression)
Level_OOZ1:	BINCLUDE	"levels/layout/OOZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; OOZ act 2 level layout (Kosinski compression)
Level_OOZ2:	BINCLUDE	"levels/layout/OOZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; MCZ act 1 level layout (Kosinski compression)
Level_MCZ1:	BINCLUDE	"levels/layout/MCZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; MCZ act 2 level layout (Kosinski compression)
Level_MCZ2:	BINCLUDE	"levels/layout/MCZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; CNZ act 1 level layout (Kosinski compression)
Level_CNZ1:	BINCLUDE	"levels/layout/CNZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; CNZ act 2 level layout (Kosinski compression)
Level_CNZ2:	BINCLUDE	"levels/layout/CNZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; CPZ act 1 level layout (Kosinski compression)
Level_CPZ1:	BINCLUDE	"levels/layout/CPZ_1.bin"
	even
;---------------------------------------------------------------------------------------
; CPZ act 2 level layout (Kosinski compression)
Level_CPZ2:	BINCLUDE	"levels/layout/CPZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; DEZ level layout (Kosinski compression)
Level_DEZ:	BINCLUDE	"levels/layout/DEZ.bin"
	even
;---------------------------------------------------------------------------------------
; ARZ act 1 level layout (Kosinski compression)
Level_ARZ1:	BINCLUDE	"levels/layout/ARZ_1.bin"
	even

;---------------------------------------------------------------------------------------
; ARZ act 2 level layout (Kosinski compression)
Level_ARZ2:	BINCLUDE	"levels/layout/ARZ_2.bin"
	even
;---------------------------------------------------------------------------------------
; SCZ level layout (Kosinski compression)
Level_SCZ:	BINCLUDE	"levels/layout/SCZ.bin"
	even




;---------------------------------------------------------------------------------------
; Uncompressed art
; Animated flowers in EHZ and HTZ ; ArtUnc_49714: ArtUnc_49794: ArtUnc_49814: ArtUnc_49894:
;---------------------------------------------------------------------------------------
ArtUnc_Flowers1:	BINCLUDE	"art/uncompressed/EHZ and HTZ flowers - 1.bin"
ArtUnc_Flowers2:	BINCLUDE	"art/uncompressed/EHZ and HTZ flowers - 2.bin"
ArtUnc_Flowers3:	BINCLUDE	"art/uncompressed/EHZ and HTZ flowers - 3.bin"
ArtUnc_Flowers4:	BINCLUDE	"art/uncompressed/EHZ and HTZ flowers - 4.bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Pulsing thing against checkered backing from EHZ ; ArtUnc_49914:
ArtUnc_EHZPulseBall:	BINCLUDE	"art/uncompressed/Pulsing ball against checkered background (EHZ).bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (192 blocks)
; Dynamically reloaded cliffs in background from HTZ ; ArtNem_49A14: ArtUnc_HTZCliffs:
ArtNem_HTZCliffs:	BINCLUDE	"art/nemesis/Dynamically reloaded cliffs in HTZ background.bin"
	even
;---------------------------------------------------------------------------------------
; Uncompressed art
; Dynamically reloaded clouds in background from HTZ ; ArtUnc_4A33E:
ArtUnc_HTZClouds:	BINCLUDE	"art/uncompressed/Background clouds (HTZ).bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Spinning metal cylinder patterns in MTZ ; ArtUnc_4A73E:
ArtUnc_MTZCylinder:	BINCLUDE	"art/uncompressed/Spinning metal cylinder (MTZ).bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Lava patterns in MTZ and HTZ  ; ArtUnc_4B73E:
ArtUnc_Lava:	BINCLUDE	"art/uncompressed/Lava.bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Animated section of MTZ background ; ArtUnc_4BD3E:
ArtUnc_MTZAnimBack:	BINCLUDE	"art/uncompressed/Animated section of MTZ background.bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Pulsing orb in HPZ
ArtUnc_HPZPulseOrb:	;BINCLUDE	"art/uncompressed/Pulsing orb (HPZ).bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Pulsing ball in OOZ   ; ArtUnc_4BF7E:
ArtUnc_OOZPulseBall:	BINCLUDE	"art/uncompressed/Pulsing ball (OOZ).bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Square rotating around ball in OOZ ; ArtUnc_4C0FE: ArtUnc_4C2FE:
ArtUnc_OOZSquareBall1:	BINCLUDE	"art/uncompressed/Square rotating around ball in OOZ - 1.bin"
ArtUnc_OOZSquareBall2:	BINCLUDE	"art/uncompressed/Square rotating around ball in OOZ - 2.bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Oil in OOZ    ; ArtUnc_4C4FE: ArtUnc_4CCFE:
ArtUnc_Oil1:	BINCLUDE	"art/uncompressed/Oil - 1.bin"
ArtUnc_Oil2:	BINCLUDE	"art/uncompressed/Oil - 2.bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Flipping foreground section in CNZ ; ArtUnc_4D4FE:
ArtUnc_CNZFlipTiles:	BINCLUDE	"art/uncompressed/Flipping foreground section (CNZ).bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Bonus pictures for slots in CNZ ; ArtUnc_4EEFE:
ArtUnc_CNZSlotPics:	BINCLUDE	"art/uncompressed/Slot pictures.bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Animated background section in CPZ and DEZ ; ArtUnc_4FAFE:
ArtUnc_CPZAnimBack:	BINCLUDE	"art/uncompressed/Animated background section (CPZ and DEZ).bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Waterfall patterns from ARZ   ; ArtUnc_4FCFE: ArtUnc_4FDFE: ArtUnc_4FEFE:
ArtUnc_Waterfall1:	BINCLUDE	"art/uncompressed/ARZ waterfall patterns - 1.bin"
ArtUnc_Waterfall2:	BINCLUDE	"art/uncompressed/ARZ waterfall patterns - 2.bin"
ArtUnc_Waterfall3:	BINCLUDE	"art/uncompressed/ARZ waterfall patterns - 3.bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Patterns for Sonic  ; ArtUnc_50000:
;---------------------------------------------------------------------------------------
	align $20
ArtUnc_Sonic:	BINCLUDE	"art/uncompressed/Sonic's art.bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Patterns for Tails  ; ArtUnc_64320:
;---------------------------------------------------------------------------------------
	align $20
ArtUnc_Tails:	BINCLUDE	"art/uncompressed/Tails's art.bin"
;--------------------------------------------------------------------------------------
; Sprite Mappings
; Sonic			; MapUnc_6FBE0: SprTbl_Sonic:
;--------------------------------------------------------------------------------------
Mapunc_Sonic:	BINCLUDE	"mappings/sprite/Sonic.bin"
;--------------------------------------------------------------------------------------
; Sprite Dynamic Pattern Reloading
; Sonic DPLCs   		; MapRUnc_714E0:
;--------------------------------------------------------------------------------------
; WARNING: the build script needs editing if you rename this label
;          or if you move Sonic's running frame to somewhere else than frame $2D
MapRUnc_Sonic:	BINCLUDE	"mappings/spriteDPLC/Sonic.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (32 blocks)
; Shield			; ArtNem_71D8E:
ArtNem_Shield:	BINCLUDE	"art/nemesis/Shield.bin"
	even
;--------------------------------------------------------------------------------------
; Nemesis compressed art (34 blocks)
; Invincibility stars		; ArtNem_71F14:
ArtNem_Invincible_stars:	BINCLUDE	"art/nemesis/Invincibility stars.bin"
	even
;--------------------------------------------------------------------------------------
; Uncompressed art
; Splash in water and dust from skidding	; ArtUnc_71FFC:
ArtUnc_SplashAndDust:	BINCLUDE	"art/uncompressed/Splash and skid dust.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (14 blocks)
; Supersonic stars		; ArtNem_7393C:		
ArtNem_SuperSonic_stars:	BINCLUDE	"art/nemesis/Super Sonic stars.bin"
	even
;--------------------------------------------------------------------------------------
; Sprite Mappings
; Tails			; MapUnc_739E2:
;--------------------------------------------------------------------------------------
MapUnc_Tails:	BINCLUDE	"mappings/sprite/Tails.bin"
;--------------------------------------------------------------------------------------
; Sprite Dynamic Pattern Reloading
; Tails DPLCs	; MapRUnc_7446C:
;--------------------------------------------------------------------------------------
MapRUnc_Tails:	BINCLUDE	"mappings/spriteDPLC/Tails.bin"
;-------------------------------------------------------------------------------------
; Nemesis compressed art (127 blocks)
; "SEGA" Patterns	; ArtNem_74876:
	even
ArtNem_SEGA:	BINCLUDE	"art/nemesis/SEGA.bin"
;-------------------------------------------------------------------------------------
; Nemesis compressed art (9 blocks)
; Shaded blocks from intro	; ArtNem_74CF6:
	even
ArtNem_IntroTrails:	BINCLUDE	"art/nemesis/Shaded blocks from intro.bin"
;---------------------------------------------------------------------------------------
; Enigma compressed art mappings
; "SEGA" mappings		; MapEng_74D0E:
	even
MapEng_SEGA:	BINCLUDE	"mappings/misc/SEGA mappings.bin"
;---------------------------------------------------------------------------------------
; Enigma compressed art mappings
; Mappings for title screen background	; ArtNem_74DC6:
	even
MapEng_TitleScreen:	BINCLUDE	"mappings/misc/Mappings for title screen background.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed art mappings
; Mappings for title screen background (smaller part, water/horizon)	; MapEng_74E3A:
	even
MapEng_TitleBack:	BINCLUDE	"mappings/misc/Mappings for title screen background 2.bin"
;---------------------------------------------------------------------------------------
; Enigma compressed art mappings
; "Sonic the Hedgehog 2" title screen logo mappings	; MapEng_74E86:
	even
MapEng_TitleLogo:	BINCLUDE	"mappings/misc/Sonic the Hedgehog 2 title screen logo mappings.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (336 blocks)
; Main patterns from title screen	; ArtNem_74F6C:
	even
ArtNem_Title:	BINCLUDE	"art/nemesis/Main patterns from title screen.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (674 blocks)
; Sonic and tails from title screen	; ArtNem_7667A:
	even
ArtNem_TitleSprites:	BINCLUDE	"art/nemesis/Sonic and Tails from title screen.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (10 blocks)
; A few menu patterns	; ArtNem_78CBC:
	even
ArtNem_MenuJunk:	BINCLUDE	"art/nemesis/A few menu blocks.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Button			ArtNem_78DAC:
	even
ArtNem_Button:	BINCLUDE	"art/nemesis/Button.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; Vertical Spring		ArtNem_78E84:
	even
ArtNem_VrtclSprng:	BINCLUDE	"art/nemesis/Vertical spring.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Horizontal spring		ArtNem_78FA0:
	even
ArtNem_HrzntlSprng:	BINCLUDE	"art/nemesis/Horizontal spring.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (32 blocks)
; Diagonal spring		ArtNem_7906A:
	even
ArtNem_DignlSprng:	BINCLUDE	"art/nemesis/Diagonal spring.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (24 blocks)
; Score, Rings, Time patterns	ArtNem_7923E:
	even
ArtNem_HUD:	BINCLUDE	"art/nemesis/HUD.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Sonic lives counter		ArtNem_79346:
	even
ArtNem_Sonic_life_counter:	BINCLUDE	"art/nemesis/Sonic lives counter.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (14 blocks)
; Ring				ArtNem_7945C:
	even
ArtNem_Ring:	BINCLUDE	"art/nemesis/Ring.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (60 blocks)
; Monitors and contents		ArtNem_79550:
	even
ArtNem_Powerups:	BINCLUDE	"art/nemesis/Monitor and contents.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (8 blocks)
; Spikes			7995C:
	even
ArtNem_Spikes:	BINCLUDE	"art/nemesis/Spikes.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (18 blocks)
; Numbers			799AC:
	even
ArtNem_Numbers:	BINCLUDE	"art/nemesis/Numbers.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Star pole			79A86:
	even
ArtNem_Checkpoint:	BINCLUDE	"art/nemesis/Star pole.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (78 blocks)
; Signpost		; ArtNem_79BDE:
	even
ArtNem_Signpost:	BINCLUDE	"art/nemesis/Signpost.bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Signpost		; ArtUnc_7A18A:
; Yep, it's in the ROM twice: once compressed and once uncompressed
	even
ArtUnc_Signpost:	BINCLUDE	"art/uncompressed/Signpost.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (28 blocks)
; Lever spring		; ArtNem_7AB4A:
	even
ArtNem_LeverSpring:	BINCLUDE	"art/nemesis/Lever spring.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (8 blocks)
; Long horizontal spike		; ArtNem_7AC9A:
	even
ArtNem_HorizSpike:	BINCLUDE	"art/nemesis/Long horizontal spike.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (24 blocks)
; Bubble thing from underwater	; ArtNem_7AD16:
	even
ArtNem_BigBubbles:	BINCLUDE	"art/nemesis/Bubble generator.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (10 blocks)
; Bubbles from character	7AEE2:
	even
ArtNem_Bubbles:	BINCLUDE	"art/nemesis/Bubbles.bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Countdown text for drowning	; ArtUnc_7AF80:
	even
ArtUnc_Countdown:	BINCLUDE	"art/uncompressed/Numbers for drowning countdown.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (34 blocks)
; Game/Time over text		7B400:
	even
ArtNem_Game_Over:	BINCLUDE	"art/nemesis/Game and Time Over text.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (68 blocks)
; Explosion			7B592:
	even
ArtNem_Explosion:	BINCLUDE	"art/nemesis/Explosion.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Miles life counter	; ArtNem_7B946:
	even
ArtUnc_MilesLife:	BINCLUDE	"art/nemesis/Miles life counter.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (49 blocks)
; Egg prison		; ArtNem_7BA32:
	even
ArtNem_Capsule:	BINCLUDE	"art/nemesis/Egg Prison.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (36 blocks)
; Tails on the continue screen (nagging Sonic)	; ArtNem_7BDBE:
	even
ArtNem_ContinueTails:	BINCLUDE	"art/nemesis/Tails on continue screen.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Sonic extra continue icon	; ArtNem_7C0AA:
	even
ArtNem_MiniSonic:	BINCLUDE	"art/nemesis/Sonic continue.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Tails life counter		; ArtNem_7C20C:
	even
ArtNem_TailsLife:	BINCLUDE	"art/nemesis/Tails life counter.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Tails extra continue icon	; ArtNem_7C2F2:
	even
ArtNem_MiniTails:	BINCLUDE	"art/nemesis/Tails continue.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (88 blocks)
; Standard font		; ArtNem_7C43A:
	even
ArtNem_FontStuff:	BINCLUDE	"art/nemesis/Standard font.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (38 blocks)
; 1P/2P wins text from 2P mode		; ArtNem_7C9AE:
	even
ArtNem_1P2PWins:	BINCLUDE	"art/nemesis/1P and 2P wins text from 2P mode.bin"
;---------------------------------------------------------------------------------------
; Enigma compressed art mappings
; Sonic/Miles animated background mappings	; MapEng_7CB80:
	even
MapEng_MenuBack:	BINCLUDE	"mappings/misc/Sonic and Miles animated background.bin"
;---------------------------------------------------------------------------------------
; Uncompressed art
; Sonic/Miles animated background patterns	; ArtUnc_7CD2C:
	even
ArtUnc_MenuBack:	BINCLUDE	"art/uncompressed/Sonic and Miles animated background.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (94 blocks)
; Title card patterns		; ArtNem_7D22C:
	even
ArtNem_TitleCard:	BINCLUDE	"art/nemesis/Title card.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (92 blocks)
; Alphabet for font using large broken letters	; ArtNem_7D58A:
	even
ArtNem_TitleCard2:	BINCLUDE	"art/nemesis/Font using large broken letters.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (21 blocks)
; A menu box with a shadow	; ArtNem_7D990:
	even
ArtNem_MenuBox:	BINCLUDE	"art/nemesis/A menu box with a shadow.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (170 blocks)
; Pictures in level preview box in level select		; ArtNem_7DA10:
	even
ArtNem_LevelSelectPics:	BINCLUDE	"art/nemesis/Pictures in level preview box from level select.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (68 blocks)
; Text for Sonic or Tails Got Through Act and Bonus/Perfect	; ArtNem_7E86A:
	even
ArtNem_ResultsText:	BINCLUDE	"art/nemesis/End of level results text.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (72 blocks)
; Text for end of special stage, along with patterns for 3 emeralds.	; ArtNem_7EB58:
	even
ArtNem_SpecialStageResults:	BINCLUDE	"art/nemesis/Special stage results screen art and some emeralds.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (14 blocks)
; "Perfect" text	; ArtNem_7EEBE:
	even
ArtNem_Perfect:	BINCLUDE	"art/nemesis/Perfect text.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Flicky		; ArtNem_7EF60:
	even
ArtNem_Bird:	BINCLUDE	"art/nemesis/Flicky.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; Squirrel		; ArtNem_7F0A2:
	even
ArtNem_Squirrel:	BINCLUDE	"art/nemesis/Squirrel.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Mouse			; ArtNem_7F206:
	even
ArtNem_Mouse:	BINCLUDE	"art/nemesis/Mouse.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Chicken		; ArtNem_7F340:
	even
ArtNem_Chicken:	BINCLUDE	"art/nemesis/Chicken.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; Beaver		; ArtNem_7F4A2:
	even
ArtNem_Beaver:	BINCLUDE	"art/nemesis/Beaver.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Some bird		; ArtNem_7F5E2:
	even
ArtNem_Eagle:	BINCLUDE	"art/nemesis/Penguin.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (10 blocks)
; Pig			; ArtNem_7F710:
	even
ArtNem_Pig:	BINCLUDE	"art/nemesis/Pig.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (14 blocks)
; Seal			; ArtNem_7F846:
	even
ArtNem_Seal:	BINCLUDE	"art/nemesis/Seal.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (18 blocks)
; Penguin		; ArtNem_7F962:
	even
ArtNem_Penguin:	BINCLUDE	"art/nemesis/Penguin 2.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; Turtle		; ArtNem_7FADE:
	even
ArtNem_Turtle:	BINCLUDE	"art/nemesis/Turtle.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; Bear			; ArtNem_7FC90:
	even
ArtNem_Bear:	BINCLUDE	"art/nemesis/Bear.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (18 blocks)
; Splats		; ArtNem_7FDD2:
	even
ArtNem_Rabbit:	BINCLUDE	"art/nemesis/Rabbit.bin"
;---------------------------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; Rivet thing that you bust to get inside ship at the end of WFZ	; ArtNem_7FF2A:
	even
ArtNem_WfzSwitch:	BINCLUDE	"art/nemesis/WFZ boss chamber switch.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (15 blocks)
; Breakaway panels in WFZ	; ArtNem_7FF98:
	even
ArtNem_BreakPanels:	BINCLUDE	"art/nemesis/Breakaway panels from WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (32 blocks)
; Spiked thing from OOZ		; ArtNem_8007C:
	even
ArtNem_SpikyThing:	BINCLUDE	"art/nemesis/Spiked ball from OOZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (6 blocks)
; Green platform over the burners in OOZ	; ArtNem_80274:
	even
ArtNem_BurnerLid:	BINCLUDE	"art/nemesis/Burner Platform from OOZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; Striped blocks from OOZ	; ArtNem_8030A:
	even
ArtNem_StripedBlocksVert:	BINCLUDE	"art/nemesis/Striped blocks from CPZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Oil splashing into oil in OOZ	; ArtNem_80376:
	even
ArtNem_Oilfall:	BINCLUDE	"art/nemesis/Cascading oil hitting oil from OOZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (13 blocks)
; Cascading oil from OOZ	; ArtNem_804F2:
	even
ArtNem_Oilfall2:	BINCLUDE	"art/nemesis/Cascading oil from OOZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; Ball thing (unused?) from OOZ	; ArtNem_805C0:
	even
ArtNem_BallThing:	BINCLUDE	"art/nemesis/Ball on spring from OOZ (beta holdovers).bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (53 blocks)
; Spinball from OOZ	; ArtNem_806E0:
	even
ArtNem_LaunchBall:	BINCLUDE	"art/nemesis/Transporter ball from OOZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (40 blocks)
; Collapsing platform from OOZ	; ArtNem_809D0:
	even
ArtNem_OOZPlatform:	BINCLUDE	"art/nemesis/OOZ collapsing platform.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (30 blocks)
; Diagonal and vertical weird spring from OOZ	; ArtNem_80C64:
	even
ArtNem_PushSpring:	BINCLUDE	"art/nemesis/Push spring from OOZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (28 blocks)
; Swinging platform from OOZ	; ArtNem_80E26:
	even
ArtNem_OOZSwingPlat:	BINCLUDE	"art/nemesis/Swinging platform from OOZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; 4 stripy blocks from OOZ	; ArtNem_81048:
	even
ArtNem_StripedBlocksHoriz:	BINCLUDE	"art/nemesis/4 stripy blocks from OOZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (24 blocks)
; Raising platform from OOZ	; ArtNem_810B8:
	even
ArtNem_OOZElevator:	BINCLUDE	"art/nemesis/Rising platform from OOZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (30 blocks)
; Fan in OOZ		; ArtNem_81254:
	even
ArtNem_OOZFanHoriz:	BINCLUDE	"art/nemesis/Fan from OOZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (18 blocks)
; Green flame thing that shoots platform up in OOZ	; ArtNem_81514:
	even
ArtNem_OOZBurn:	BINCLUDE	"art/nemesis/Green flame from OOZ burners.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; Patterns for appearing and disappearing string of platforms in CNZ	; ArtNem_81600:
	even
ArtNem_CNZSnake:	BINCLUDE	"art/nemesis/Caterpiller platforms from CNZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; Spikey ball from pokie in CNZ		; ArtNem_81668:
	even
ArtNem_CNZBonusSpike:	BINCLUDE	"art/nemesis/Spikey ball from CNZ slots.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Moving cube from either CNZ or CPZ	; ArtNem_816C8:
	even
ArtNem_BigMovingBlock:	BINCLUDE	"art/nemesis/Moving block from CNZ and CPZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; Elevator in CNZ		; ArtNem_817B4:
	even
ArtNem_CNZElevator:	BINCLUDE	"art/nemesis/CNZ elevator.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Bars from pokies in CNZ	; ArtNem_81826:
	even
ArtNem_CNZCage:	BINCLUDE	"art/nemesis/CNZ slot machine bars.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (6 blocks)
; Hexagonal bumper in CNZ	; ArtNem_81894:
	even
ArtNem_CNZHexBumper:	BINCLUDE	"art/nemesis/Hexagonal bumper from CNZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (24 blocks)
; Normal round bumper from CNZ	; ArtNem_8191E:
	even
ArtNem_CNZRoundBumper:	BINCLUDE	"art/nemesis/Round bumper from CNZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (32 blocks)
; Diagonal spring from CNZ that you charge up	; ArtNem_81AB0:
	even
ArtNem_CNZDiagPlunger:	BINCLUDE	"art/nemesis/Diagonal impulse spring from CNZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (18 blocks)
; Vertical red spring		; ArtNem_81C96:
	even
ArtNem_CNZVertPlunger:	BINCLUDE	"art/nemesis/Vertical impulse spring.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (28 blocks)
; Weird blocks from CNZ that you hit 3 times to get rid of	; ArtNem_81DCC:
	even
ArtNem_CNZMiniBumper:	BINCLUDE	"art/nemesis/Drop target from CNZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (52 blocks)
; Flippers from CNZ	; ArtNem_81EF2:
	even
ArtNem_CNZFlipper:	BINCLUDE	"art/nemesis/Flippers.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Large moving platform from CPZ	; ArtNem_82216:
	even
ArtNem_CPZElevator:	BINCLUDE	"art/nemesis/Large moving platform from CNZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (24 blocks)
; Top of water in HPZ and CPZ	; ArtNem_82364:
	even
ArtNem_WaterSurface:	BINCLUDE	"art/nemesis/Top of water in HPZ and CNZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; Booster things in CPZ		; ArtNem_824D4:
	even
ArtNem_CPZBooster:	BINCLUDE	"art/nemesis/Speed booster from CPZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; CPZ droplet chain enemy	; ArtNem_8253C:
	even
ArtNem_CPZDroplet:	BINCLUDE	"art/nemesis/CPZ worm enemy.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (33 blocks)
; CPZ metal things (girder, cylinders)	; ArtNem_825AE:
	even
ArtNem_CPZMetalThings:	BINCLUDE	"art/nemesis/CPZ metal things.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; CPZ metal block		; ArtNem_827B8:
	even
ArtNem_CPZMetalBlock:	BINCLUDE	"art/nemesis/CPZ large moving platform blocks.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (8 blocks)
; Yellow and black stripy tiles from DEZ	; ArtNem_827F8:
	even
ArtNem_ConstructionStripes:	BINCLUDE	"art/nemesis/Stripy blocks from CPZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (48 blocks)
; Yellow flipping platforms and stuff CPZ	; ArtNem_82864:
	even
ArtNem_CPZAnimatedBits:	BINCLUDE	"art/nemesis/Small yellow moving platform from CPZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (24 blocks)
; Moving block from CPZ		; ArtNem_82A46:
	even
ArtNem_CPZStairBlock:	BINCLUDE	"art/nemesis/Moving block from CPZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (32 blocks)
; Spring that covers tube in CPZ	; ArtNem_82C06:
	even
ArtNem_CPZTubeSpring:	BINCLUDE	"art/nemesis/CPZ spintube exit cover.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Top of water in ARZ		; ArtNem_82E02:
	even
ArtNem_WaterSurface2:	BINCLUDE	"art/nemesis/Top of water in ARZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (7 blocks)
; Leaves from ARZ	; ArtNem_82EE8:
	even
ArtNem_Leaves:	BINCLUDE	"art/nemesis/Leaves in ARZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (17 blocks)
; Arrow shooter and arrow from ARZ	; ArtNem_82F74:
	even
ArtNem_ArrowAndShooter:	BINCLUDE	"art/nemesis/Arrow shooter and arrow from ARZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (8 blocks)
; One way barrier from ARZ (unused?)	; ArtNem_830D2:
	even
ArtNem_ARZBarrierThing:	BINCLUDE	"art/nemesis/One way barrier from ARZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (28 blocks)
; Buzz bomber			; ArtNem_8316A:
	even
ArtNem_Buzzer:	BINCLUDE	"art/nemesis/Buzzer enemy.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (58 blocks)
; Octopus badnik from OOZ	; ArtNem_8336A:
	even
ArtNem_Octus:	BINCLUDE	"art/nemesis/Octopus badnik from OOZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (56 blocks)
; Flying badnik from OOZ	; ArtNem_8368A:
	even
ArtNem_Aquis:	BINCLUDE	"art/nemesis/Seahorse from OOZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (22 blocks)
; Fish badnik from EHZ		; ArtNem_839EA:	ArtNem_Pirahna:
	even
ArtNem_Masher:	BINCLUDE	"art/nemesis/EHZ Pirahna badnik.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (96 blocks)
; Robotnik's main ship		; ArtNem_83BF6:
	even
ArtNem_Eggpod:	BINCLUDE	"art/nemesis/Eggpod.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (111 blocks)
; CPZ Boss			; ArtNem_84332:
	even
ArtNem_CPZBoss:	BINCLUDE	"art/nemesis/CPZ boss.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (100 blocks)
; Large explosion		; ArtNem_84890:
	even
ArtNem_FieryExplosion:	BINCLUDE	"art/nemesis/Large explosion.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (8 blocks)
; Horizontal jet		; ArtNem_84F18:
	even
ArtNem_EggpodJets:	BINCLUDE	"art/nemesis/Horizontal jet.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Smoke trail from CPZ and HTZ bosses	; ArtNem_84F96:
	even
ArtNem_BossSmoke:	BINCLUDE	"art/nemesis/Smoke trail from CPZ and HTZ bosses.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (128 blocks)
; EHZ Boss	; ArtNem_8507C:
	even
ArtNem_EHZBoss:	BINCLUDE	"art/nemesis/EHZ boss.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; Helicopter blades for EHZ boss	; ArtNem_85868:
	even
ArtNem_EggChoppers:	BINCLUDE	"art/nemesis/Chopper blades for EHZ boss.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (107 blocks)
; HTZ boss			; ArtNem_8595C:
	even
ArtNem_HTZBoss:	BINCLUDE	"art/nemesis/HTZ boss.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (166 blocks)
; ARZ boss			; ArtNem_86128:
	even
ArtNem_ARZBoss:	BINCLUDE	"art/nemesis/ARZ boss.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (204 blocks)
; MCZ boss			; ArtNem_86B6E:
	even
ArtNem_MCZBoss:	BINCLUDE	"art/nemesis/MCZ boss.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (133 blocks)
; CNZ boss			; ArtNem_87AAC:
	even
ArtNem_CNZBoss:	BINCLUDE	"art/nemesis/CNZ boss.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (181 blocks)
; OOZ boss			; ArtNem_882D6:
	even
ArtNem_OOZBoss:	BINCLUDE	"art/nemesis/OOZ boss.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (124 blocks)
; MTZ boss			; ArtNem_88DA6:
	even
ArtNem_MTZBoss:	BINCLUDE	"art/nemesis/MTZ boss.bin"
;--------------------------------------------------------------------------------------
; Uncompressed art (8 blocks)
; Falling rocks and stalactites from MCZ	; ArtUnc_894E4:
	even
ArtUnc_FallingRocks:	BINCLUDE	"art/uncompressed/Falling rocks and stalactites from MCZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (9 blocks)
; Blowfly from ARZ	; ArtNem_895E4:
	even
ArtNem_Whisp:	BINCLUDE	"art/nemesis/Blowfly from ARZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (50 blocks)
; Grounder from ARZ	; ArtNem_8970E:
	even
ArtNem_Grounder:	BINCLUDE	"art/nemesis/Grounder from ARZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (24 blocks)
; Fish from ARZ		; ArtNem_89B9A:
	even
ArtNem_ChopChop:	BINCLUDE	"art/nemesis/Shark from ARZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (19 blocks)
; Lava snake from HTZ		89DEC: ArtNem_HtzRexxon:
	even
ArtNem_Rexon:	BINCLUDE	"art/nemesis/Rexxon (lava snake) from HTZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; Enemy with spike cone on top from HTZ		89FAA:	ArtNem_HtzDriller:
	even
ArtNem_Spiker:	BINCLUDE	"art/nemesis/Driller badnik from HTZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (28 blocks)
; Bomber badnik from SCZ	; ArtNem_8A142:
	even
ArtNem_Nebula:	BINCLUDE	"art/nemesis/Bomber badnik from SCZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (57 blocks)
; Turtle badnik from SCZ	; ArtNem_8A362:
	even
ArtNem_Turtloid:	BINCLUDE	"art/nemesis/Turtle badnik from SCZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (38 blocks)
; Coconuts monkey badnik from EHZ
	even
ArtNem_Coconuts:	BINCLUDE	"art/nemesis/Coconuts badnik from EHZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (10 blocks)
; Snake badnik from MCZ		; ArtNem_8AB36:
	even
ArtNem_Crawlton:	BINCLUDE	"art/nemesis/Snake badnik from MCZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; Firefly from MCZ		; ArtNem_8AC5E:
	even
ArtNem_Flasher:	BINCLUDE	"art/nemesis/Firefly from MCZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (32 blocks)
; Praying mantis badnik from MTZ	8AD80:
	even
ArtNem_MtzMantis:	BINCLUDE	"art/nemesis/Praying mantis badnik from MTZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (36 blocks)
; Crab badnik from MTZ			8B058:
	even
ArtNem_Shellcracker:	BINCLUDE	"art/nemesis/Shellcracker badnik from MTZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (15 blocks)
; Exploding star badnik from MTZ	8B300:
	even
ArtNem_MtzSupernova:	BINCLUDE	"art/nemesis/Exploding star badnik from MTZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (32 blocks)
; Weird crawling badnik from CPZ	; ArtNem_8B430:
	even
ArtNem_Spiny:	BINCLUDE	"art/nemesis/Weird crawling badnik from CPZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (45 blocks)
; Spider badnik from CPZ 	ArtNem_8B6B4:
	even
ArtNem_Grabber:	BINCLUDE	"art/nemesis/Spider badnik from CPZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (26 blocks)
; Chicken badnik from WFZ		8B9DC:
	even
ArtNem_WfzScratch:	BINCLUDE	"art/nemesis/Scratch from WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (25 blocks)
; Jet like badnik from SCZ		8BC16:
	even
ArtNem_Balkrie:	BINCLUDE	"art/nemesis/Balkrie (jet badnik) from SCZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (217 blocks)
; Silver Sonic			; ArtNem_8BE12:
	even
ArtNem_SilverSonic:	BINCLUDE	"art/nemesis/Silver Sonic.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (79 blocks)
; The Tornado			8CC44:
	even
ArtNem_Tornado:	BINCLUDE	"art/nemesis/The Tornado.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (24 blocks)
; Wall turret from WFZ		8D1A0:
	even
ArtNem_WfzWallTurret:	BINCLUDE	"art/nemesis/Wall turret from WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; Hook on chain in WFZ		8D388:
	even
ArtNem_WfzHook:	BINCLUDE	"art/nemesis/Hook on chain from WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (54 blocks)
; Retracting platform from WFZ		8D540:
	even
ArtNem_WfzGunPlatform:	BINCLUDE	"art/nemesis/Retracting platform from WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Wheel for belt in WFZ		8D7D8:
	even
ArtNem_WfzConveyorBeltWheel:	BINCLUDE	"art/nemesis/Wheel for belt in WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Moving platform in WFZ	8D96E:
	even
ArtNem_WfzFloatingPlatform:	BINCLUDE	"art/nemesis/Moving platform from WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Giant unused vertical red laser in WFZ	8DA6E:
	even
ArtNem_WfzVrtclLazer:	BINCLUDE	"art/nemesis/Unused vertical laser in WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (18 blocks)
; Clouds			8DAFC:
	even
ArtNem_Clouds:	BINCLUDE	"art/nemesis/Clouds.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (10 blocks)
; Red horizontal laser in WFZ		8DC42:
	even
ArtNem_WfzHrzntlLazer:	BINCLUDE	"art/nemesis/Red horizontal laser from WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (5 blocks)
; Catapult that shoots sonic across quickly in WFZ	8DCA2:
	even
ArtNem_WfzLaunchCatapult:	BINCLUDE	"art/nemesis/Catapult that shoots Sonic to the side from WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Rising platforms on belt from WFZ	8DD0C:
	even
ArtNem_WfzBeltPlatform:	BINCLUDE	"art/nemesis/Platform on belt in WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Unused badnik in WFZ		8DDF6:
	even
ArtNem_WfzUnusedBadnik:	BINCLUDE	"art/nemesis/Unused badnik from WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; Vertical spinning blades from WFZ	8DEB8:
	even
ArtNem_WfzVrtclPrpllr:	BINCLUDE	"art/nemesis/Vertical spinning blades in WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (29 blocks)
; Horizontal spinning blades from WFZ		8DEE8:
	even
ArtNem_WfzHrzntlPrpllr:	BINCLUDE	"art/nemesis/Horizontal spinning blades in WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Platforms that tilt in WFZ		8E010:
	even
ArtNem_WfzTiltPlatforms:	BINCLUDE	"art/nemesis/Tilting plaforms in WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (8 blocks)
; Thrust from Robotnic's getaway ship in WFZ		8E0C4:
	even
ArtNem_WfzThrust:	BINCLUDE	"art/nemesis/Thrust from Robotnik's getaway ship in WFZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (117 blocks)
; Laser boss from WFZ	; ArtNem_8E138:
	even
ArtNem_WFZBoss:	BINCLUDE	"art/nemesis/WFZ boss.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (24 blocks)
; Robotnik's head	; ArtNem_8E886:
	even
ArtNem_RobotnikUpper:	BINCLUDE	"art/nemesis/Robotnik's head.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (76 blocks)
; Robotnik		; ArtNem_8EA5A:
	even
ArtNem_RobotnikRunning:	BINCLUDE	"art/nemesis/Robotnik.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (28 blocks)
; Robotnik's lower half	; ArtNem_8EE52:
	even
ArtNem_RobotnikLower:	BINCLUDE	"art/nemesis/Robotnik's lover half.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (8 blocks)
; Window in back that Robotnic looks through in DEZ	; ArtNem_8EF96:
	even
ArtNem_DEZWindow:	BINCLUDE	"art/nemesis/Window in back that Robotnik looks through in DEZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (327 blocks)
; Eggrobo		; ArtNem_8F024:
	even
ArtNem_DEZBoss:	BINCLUDE	"art/nemesis/Eggrobo.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (42 blocks)
; Bouncer badnik from CNZ	; ArtNem_901A4:
	even
ArtNem_Crawl:	BINCLUDE	"art/nemesis/Bouncer badnik from CNZ.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (26 blocks)
; Rocket thruster for Tornado	; ArtNem_90520:
	even
ArtNem_TornadoThruster:	BINCLUDE	"art/nemesis/Rocket thruster for Tornado.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Frame 1 of end of game sequence	; MapEng_906E0:
	even
MapEng_Ending1:	BINCLUDE	"mappings/misc/End of game sequence frame 1.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Frame 2 of end of game sequence	; MapEng_906F8:
	even
MapEng_Ending2:	BINCLUDE	"mappings/misc/End of game sequence frame 2.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Frame 3 of end of game sequence	; MapEng_90722:
	even
MapEng_Ending3:	BINCLUDE	"mappings/misc/End of game sequence frame 3.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Frame 4 of end of game sequence	; MapEng_9073C:
	even
MapEng_Ending4:	BINCLUDE	"mappings/misc/End of game sequence frame 4.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Closeup of Tails flying plane in ending sequence	; MapEng_9076E:
	even
MapEng_EndingTailsPlane:	BINCLUDE	"mappings/misc/Closeup of Tails flying plane in ending sequence.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Closeup of Sonic flying plane in ending sequence	; MapEng_907C0:
	even
MapEng_EndingSonicPlane:	BINCLUDE	"mappings/misc/Closeup of Sonic flying plane in ending sequence.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (duplicate of MapEng_EndGameLogo)
	even
; MapEng_9082A:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 1.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_90852:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 2.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_9087A:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 3.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_908A2:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 4.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_908CA:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 5.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_908F2:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 6.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_9091A:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 7.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_90942:
	BINCLUDE	"mappings/misc/Strange unused mappings 1 - 8.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed sprite mappings
; Strange unused mappings (same as above)
	even
; MapEng_9096A:
	BINCLUDE	"mappings/misc/Strange unused mappings 2.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (363 blocks)
; Movie sequence at end of game		; ArtNem_90992:
	even
ArtNem_EndingPics:	BINCLUDE	"art/nemesis/Movie sequence at end of game.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (127 blocks)
; Final image of Tornado with it and Sonic facing screen	; ArtNem_91F3C:
	even
ArtNem_EndingFinalTornado:	BINCLUDE	"art/nemesis/Final image of Tornado with it and Sonic facing screen.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (109 blocks)
; Mini pictures of Tornado in final ending sequence	; ArtNem_927E0:
	even
ArtNem_EndingMiniTornado:	BINCLUDE	"art/nemesis/Small pictures of Tornado in final ending sequence.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (135 blocks)
; Mini pictures of Sonic and final image of Sonic
	even
ArtNem_EndingSonic:	BINCLUDE	"art/nemesis/Small pictures of Sonic and final image of Sonic.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (117 blocks)
; Mini pictures of Sonic and final image of Sonic in supersonic mode	; ArtNem_93848:
	even
ArtNem_EndingSuperSonic:	BINCLUDE	"art/nemesis/Small pictures of Sonic and final image of Sonic in Super Sonic mode.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (181 blocks)
; Final image of Tails		; ArtNem_93F3C:
	even
ArtNem_EndingTails:	BINCLUDE	"art/nemesis/Final image of Tails.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (72 blocks)
; Sonic the Hedgehog 2 image at end of credits	; ArtNem_94B28:
	even
ArtNem_EndingTitle:	BINCLUDE	"art/nemesis/Sonic the Hedgehog 2 image at end of credits.bin"


; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; LEVEL ART AND BLOCK MAPPINGS (16x16 and 128x128)
;
; #define BLOCK_TBL_LEN  // table length unknown
; #define BIGBLOCK_TBL_LEN // table length unknown
; typedef uint16_t uword
;
; struct blockMapElement {
;  uword unk : 5;    // u
;  uword patternIndex : 11; };  // i
; // uuuu uiii iiii iiii
;
; blockMapElement (*blockMapTable)[BLOCK_TBL_LEN][4] = 0xFFFF9000
;
; struct bigBlockMapElement {
;  uword : 4
;  uword blockMapIndex : 12; };  //I
; // 0000 IIII IIII IIII
;
; bigBlockMapElement (*bigBlockMapTable)[BIGBLOCK_TBL_LEN][64] = 0xFFFF0000
;
; /*
; This data determines how the level blocks will be constructed graphically. There are
; two kinds of block mappings: 16x16 and 128x128.
;
; 16x16 blocks are made up of four cells arranged in a square (thus, 16x16 pixels).
; Two bytes are used to define each cell, so the block is 8 bytes long. It can be
; represented by the bitmap blockMapElement, of which the members are:
;
; unk
;  These bits have to do with pattern orientation. I do not know their exact
;  meaning.
; patternIndex
;  The pattern's address divided by $20. Otherwise said: an index into the
;  pattern array.
;
; Each mapping can be expressed as an array of four blockMapElements, while the
; whole table is expressed as a two-dimensional array of blockMapElements (blockMapTable).
; The maps are read in left-to-right, top-to-bottom order.
;
; 128x128 maps are basically lists of indices into blockMapTable. The levels are built
; out of these "big blocks", rather than the "small" 16x16 blocks. bigBlockMapTable is,
; predictably, the table of big block mappings.
; Each big block is 8 16x16 blocks, or 16 cells, square. This produces a total of 16
; blocks or 64 cells.
; As noted earlier, each element of the table provides 'i' for blockMapTable[i][j].
; */

;----------------------------------------------------------------------------------
; EHZ 16x16 block mappings (Kosinski compression) ; was: (Kozinski compression)
BM16_EHZ:	BINCLUDE	"mappings/16x16/EHZ.bin"
;-----------------------------------------------------------------------------------
; EHZ/HTZ main level patterns (Kosinski compression)
; ArtKoz_95C24:
ArtKos_EHZ:	BINCLUDE	"art/kosinski/EHZ_HTZ.bin"
;-----------------------------------------------------------------------------------
; HTZ 16x16 block mappings (Kosinski compression)
BM16_HTZ:	BINCLUDE	"mappings/16x16/HTZ.bin"
;-----------------------------------------------------------------------------------
; HTZ pattern suppliment to EHZ level patterns (Kosinski compression)
; ArtKoz_98AB4:
ArtKos_HTZ:	BINCLUDE	"art/kosinski/HTZ_Supp.bin"
;-----------------------------------------------------------------------------------
; EHZ/HTZ 128x128 block mappings (Kosinski compression)
BM128_EHZ:	BINCLUDE	"mappings/128x128/EHZ_HTZ.bin"
;-----------------------------------------------------------------------------------
; MTZ 16x16 block mappings (Kosinski compression)
BM16_MTZ:	BINCLUDE	"mappings/16x16/MTZ.bin"
;-----------------------------------------------------------------------------------
; MTZ main level patterns (Kosinski compression)
; ArtKoz_9DB64:
ArtKos_MTZ:	BINCLUDE	"art/kosinski/MTZ.bin"
;-----------------------------------------------------------------------------------
; MTZ 128x128 block mappings (Kosinski compression)
BM128_MTZ:	BINCLUDE	"mappings/128x128/MTZ.bin"
;-----------------------------------------------------------------------------------
; HPZ 16x16 block mappings (Kosinski compression)
BM16_HPZ:	;BINCLUDE	"mappings/16x16/HPZ.bin"
;-----------------------------------------------------------------------------------
; HPZ main level patterns (Kosinski compression)
ArtKos_HPZ:	;BINCLUDE	"art/kosinski/HPZ.bin"
;-----------------------------------------------------------------------------------
; HPZ 128x128 block mappings (Kosinski compression)
BM128_HPZ:	;BINCLUDE	"mappings/128x128/HPZ.bin"
;-----------------------------------------------------------------------------------
; OOZ 16x16 block mappings (Kosinski compression)
BM16_OOZ:	BINCLUDE	"mappings/16x16/OOZ.bin"
;-----------------------------------------------------------------------------------
; OOZ main level patterns (Kosinski compression)
; ArtKoz_A4204:
ArtKos_OOZ:	BINCLUDE	"art/kosinski/OOZ.bin"
;-----------------------------------------------------------------------------------
; OOZ 128x128 block mappings (Kosinski compression)
BM128_OOZ:	BINCLUDE	"mappings/128x128/OOZ.bin"
;-----------------------------------------------------------------------------------
; MCZ 16x16 block mappings (Kosinski compression)
BM16_MCZ:	BINCLUDE	"mappings/16x16/MCZ.bin"
;-----------------------------------------------------------------------------------
; MCZ main level patterns (Kosinski compression)
; ArtKoz_A9D74:
ArtKos_MCZ:	BINCLUDE	"art/kosinski/MCZ.bin"
;-----------------------------------------------------------------------------------
; MCZ 128x128 block mappings (Kosinski compression)
BM128_MCZ:	BINCLUDE	"mappings/128x128/MCZ.bin"
;-----------------------------------------------------------------------------------
; CNZ 16x16 block mappings (Kosinski compression)
BM16_CNZ:	BINCLUDE	"mappings/16x16/CNZ.bin"
;-----------------------------------------------------------------------------------
; CNZ main level patterns (Kosinski compression)
; ArtKoz_B0894:
ArtKos_CNZ:	BINCLUDE	"art/kosinski/CNZ.bin"
;-----------------------------------------------------------------------------------
; CNZ 128x128 block mappings (Kosinski compression)
BM128_CNZ:	BINCLUDE	"mappings/128x128/CNZ.bin"
;-----------------------------------------------------------------------------------
; CPZ/DEZ 16x16 block mappings (Kosinski compression)
BM16_CPZ:	BINCLUDE	"mappings/16x16/CPZ_DEZ.bin"
;-----------------------------------------------------------------------------------
; CPZ/DEZ main level patterns (Kosinski compression)
; ArtKoz_B6174:
ArtKos_CPZ:	BINCLUDE	"art/kosinski/CPZ_DEZ.bin"
;-----------------------------------------------------------------------------------
; CPZ/DEZ 128x128 block mappings (Kosinski compression)
BM128_CPZ:	BINCLUDE	"mappings/128x128/CPZ_DEZ.bin"
;-----------------------------------------------------------------------------------
; ARZ 16x16 block mappings (Kosinski compression)
BM16_ARZ:	BINCLUDE	"mappings/16x16/ARZ.bin"
;-----------------------------------------------------------------------------------
; ARZ main level patterns (Kosinski compression)
; ArtKoz_BCC24:
ArtKos_ARZ:	BINCLUDE	"art/kosinski/ARZ.bin"
;-----------------------------------------------------------------------------------
; ARZ 128x128 block mappings (Kosinski compression)
BM128_ARZ:	BINCLUDE	"mappings/128x128/ARZ.bin"
;-----------------------------------------------------------------------------------
; WFZ/SCZ 16x16 block mappings (Kosinski compression)
BM16_WFZ:	BINCLUDE	"mappings/16x16/WFZ_SCZ.bin"
;-----------------------------------------------------------------------------------
; WFZ/SCZ main level patterns (Kosinski compression)
; ArtKoz_C5004:
ArtKos_SCZ:	BINCLUDE	"art/kosinski/WFZ_SCZ.bin"
;-----------------------------------------------------------------------------------
; WFZ pattern suppliment to SCZ tiles (Kosinski compression)
; ArtKoz_C7EC4:
ArtKos_WFZ:	BINCLUDE	"art/kosinski/WFZ_Supp.bin"
;-----------------------------------------------------------------------------------
; WFZ/SCZ 128x128 block mappings (Kosinski compression)
BM128_WFZ:	BINCLUDE	"mappings/128x128/WFZ_SCZ.bin"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;-----------------------------------------------------------------------------------
; Exit curve + slope up
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CA904:
MapSpec_Rise1:	BINCLUDE	"mappings/special stage/Slope up - Frame 1.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CADA8:
MapSpec_Rise2:	BINCLUDE	"mappings/special stage/Slope up - Frame 2.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CB376:
MapSpec_Rise3:	BINCLUDE	"mappings/special stage/Slope up - Frame 3.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CB92E:
MapSpec_Rise4:	BINCLUDE	"mappings/special stage/Slope up - Frame 4.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CBF92:
MapSpec_Rise5:	BINCLUDE	"mappings/special stage/Slope up - Frame 5.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CC5BE:
MapSpec_Rise6:	BINCLUDE	"mappings/special stage/Slope up - Frame 6.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CCC7A:
MapSpec_Rise7:	BINCLUDE	"mappings/special stage/Slope up - Frame 7.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CD282:
MapSpec_Rise8:	BINCLUDE	"mappings/special stage/Slope up - Frame 8.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CD7C0:
MapSpec_Rise9:	BINCLUDE	"mappings/special stage/Slope up - Frame 9.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CDD44:
MapSpec_Rise10:	BINCLUDE	"mappings/special stage/Slope up - Frame 10.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CE2BE:
MapSpec_Rise11:	BINCLUDE	"mappings/special stage/Slope up - Frame 11.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CE7DE:
MapSpec_Rise12:	BINCLUDE	"mappings/special stage/Slope up - Frame 12.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CEC52:
MapSpec_Rise13:	BINCLUDE	"mappings/special stage/Slope up - Frame 13.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CF0BC:
MapSpec_Rise14:	BINCLUDE	"mappings/special stage/Slope up - Frame 14.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CF580:
MapSpec_Rise15:	BINCLUDE	"mappings/special stage/Slope up - Frame 15.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CFA00:
MapSpec_Rise16:	BINCLUDE	"mappings/special stage/Slope up - Frame 16.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_CFE4A:
MapSpec_Rise17:	BINCLUDE	"mappings/special stage/Slope up - Frame 17.bin"

;-----------------------------------------------------------------------------------
; Straight path
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D028C:
MapSpec_Straight1:	BINCLUDE	"mappings/special stage/Straight path - Frame 1.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D090A:
MapSpec_Straight2:	BINCLUDE	"mappings/special stage/Straight path - Frame 2.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D0EA6:
MapSpec_Straight3:	BINCLUDE	"mappings/special stage/Straight path - Frame 3.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D1400:
MapSpec_Straight4:	BINCLUDE	"mappings/special stage/Straight path - Frame 4.bin"

;-----------------------------------------------------------------------------------
; Exit curve + slope down
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D19FC:
MapSpec_Drop1:	BINCLUDE	"mappings/special stage/Slope down - Frame 1.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D1EAC:
MapSpec_Drop2:	BINCLUDE	"mappings/special stage/Slope down - Frame 2.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D23AE:
MapSpec_Drop3:	BINCLUDE	"mappings/special stage/Slope down - Frame 3.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D27C6:
MapSpec_Drop4:	BINCLUDE	"mappings/special stage/Slope down - Frame 4.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D2C14:
MapSpec_Drop5:	BINCLUDE	"mappings/special stage/Slope down - Frame 5.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D3092:
MapSpec_Drop6:	BINCLUDE	"mappings/special stage/Slope down - Frame 6.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D3522:
MapSpec_Drop7:	BINCLUDE	"mappings/special stage/Slope down - Frame 7.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D39EC:
MapSpec_Drop8:	BINCLUDE	"mappings/special stage/Slope down - Frame 8.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D3F78:
MapSpec_Drop9:	BINCLUDE	"mappings/special stage/Slope down - Frame 9.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D4660:
MapSpec_Drop10:	BINCLUDE	"mappings/special stage/Slope down - Frame 10.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D4DA6:
MapSpec_Drop11:	BINCLUDE	"mappings/special stage/Slope down - Frame 11.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D53FC:
MapSpec_Drop12:	BINCLUDE	"mappings/special stage/Slope down - Frame 12.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D5958:
MapSpec_Drop13:	BINCLUDE	"mappings/special stage/Slope down - Frame 13.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D5F02:
MapSpec_Drop14:	BINCLUDE	"mappings/special stage/Slope down - Frame 14.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D6596:
MapSpec_Drop15:	BINCLUDE	"mappings/special stage/Slope down - Frame 15.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D6BAA:
MapSpec_Drop16:	BINCLUDE	"mappings/special stage/Slope down - Frame 16.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D702E:
MapSpec_Drop17:	BINCLUDE	"mappings/special stage/Slope down - Frame 17.bin"

;-----------------------------------------------------------------------------------
; Curved path
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D749C:
MapSpec_Turning1:	BINCLUDE	"mappings/special stage/Curve right - Frame 1.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D7912:
MapSpec_Turning2:	BINCLUDE	"mappings/special stage/Curve right - Frame 2.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D7DAA:
MapSpec_Turning3:	BINCLUDE	"mappings/special stage/Curve right - Frame 3.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D8250:
MapSpec_Turning4:	BINCLUDE	"mappings/special stage/Curve right - Frame 4.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D85F8:
MapSpec_Turning5:	BINCLUDE	"mappings/special stage/Curve right - Frame 5.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings ; MapSpec_D89EC:
MapSpec_Turning6:	BINCLUDE	"mappings/special stage/Curve right - Frame 6.bin"

;-----------------------------------------------------------------------------------
; Exit curve
;-----------------------------------------------------------------------------------
; Special stage tube mappings
; Exit curve  ; MapSpec_D8E24:
MapSpec_Unturn1:	BINCLUDE	"mappings/special stage/Curve right - Frame 7.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings
; Exit curve  ; MapSpec_D92B6:
MapSpec_Unturn2:	BINCLUDE	"mappings/special stage/Curve right - Frame 8.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings
; Exit curve  ; MapSpec_D9778:
MapSpec_Unturn3:	BINCLUDE	"mappings/special stage/Curve right - Frame 9.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings
; Exit curve  ; MapSpec_D9B80:
MapSpec_Unturn4:	BINCLUDE	"mappings/special stage/Curve right - Frame 10.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings
; Exit curve  ; MapSpec_DA016:
MapSpec_Unturn5:	BINCLUDE	"mappings/special stage/Curve right - Frame 11.bin"

;-----------------------------------------------------------------------------------
; Enter curve
;-----------------------------------------------------------------------------------
; Special stage tube mappings
; Begin curve right ; MapSpec_DA4CE:
MapSpec_Turn1:	BINCLUDE	"mappings/special stage/Begin curve right - Frame 1.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings
; Begin curve right ; MapSpec_DAB20:
MapSpec_Turn2:	BINCLUDE	"mappings/special stage/Begin curve right - Frame 2.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings
; Begin curve right ; MapSpec_DB086:
MapSpec_Turn3:	BINCLUDE	"mappings/special stage/Begin curve right - Frame 3.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings
; Begin curve right ; MapSpec_DB5AE:
MapSpec_Turn4:	BINCLUDE	"mappings/special stage/Begin curve right - Frame 4.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings
; Begin curve right ; MapSpec_DBB62:
MapSpec_Turn5:	BINCLUDE	"mappings/special stage/Begin curve right - Frame 5.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings
; Begin curve right ; MapSpec_DC154:
MapSpec_Turn6:	BINCLUDE	"mappings/special stage/Begin curve right - Frame 6.bin"
;-----------------------------------------------------------------------------------
; Special stage tube mappings
; Begin curve right ; MapSpec_DC5E8:
MapSpec_Turn7:	BINCLUDE	"mappings/special stage/Begin curve right - Frame 7.bin"

;--------------------------------------------------------------------------------------
; Kosinski compressed art
; Special stage level patterns
; Note: Only one line of each tile is stored in this archive. The other 7 lines are
;  the same as this one line, so to get the full tiles, each line needs to be
;  duplicated 7 times over.					; ArtKoz_DCA38:
;--------------------------------------------------------------------------------------
ArtKos_Special:	BINCLUDE	"art/kosinski/SpecStag.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (127 blocks)
; Background patterns for special stage		; ArtNem_DCD68:
	even
ArtNem_SpecialBack:	BINCLUDE	"art/nemesis/Background art for special stage.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed tile mappings
; Main background mappings for special stage	; MapEng_DD1DE:
	even
MapEng_SpecialBack:	BINCLUDE	"mappings/misc/Main background mappings for special stage.bin"
;--------------------------------------------------------------------------------------
; Enigma compressed tile mappings
; Lower background mappings for special stage	; MapEng_DD30C:
	even
MapEng_SpecialBackBottom:	BINCLUDE	"mappings/misc/Lower background mappings for special stage.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (62 blocks)
; Sonic/Miles and number text from special stage	; ArtNem_DD48A:
	even
ArtNem_SpecialHUD:	BINCLUDE	"art/nemesis/Sonic and Miles number text from special stage.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (48 blocks)
; "Start" and checkered flag patterns in special stage	; ArtNem_DD790:
	even
ArtNem_SpecialStart:	BINCLUDE	"art/nemesis/Start text from special stage.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (37 blocks)
; Stars in special stage	; ArtNem_DD8CE:
	even
ArtNem_SpecialStars:	BINCLUDE	"art/nemesis/Stars in special stage.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (13 blocks)
; Text for most of the "Player VS Player" message in 2P special stage	; ArtNem_DD9C8:
	even
ArtNem_SpecialPlayerVSPlayer:	BINCLUDE	"art/nemesis/Special stage Player VS Player text.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (104 blocks)
; Ring patterns in special stage	; ArtNem_DDA7E:
	even
ArtNem_SpecialRings:	BINCLUDE	"art/nemesis/Special stage ring art.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (38 blocks)
; Horizontal shadow patterns in special stage	; ArtNem_DDFA4:
	even
ArtNem_SpecialFlatShadow:	BINCLUDE	"art/nemesis/Horizontal shadow from special stage.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (58 blocks)
; Diagonal shadow patterns in special stage	; ArtNem_DE05A:
	even
ArtNem_SpecialDiagShadow:	BINCLUDE	"art/nemesis/Diagonal shadow from special stage.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (25 blocks)
; Vertical shadow patterns in special stage	; ArtNem_DE120:
	even
ArtNem_SpecialSideShadow:	BINCLUDE	"art/nemesis/Vertical shadow from special stage.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (48 blocks)
; Explosion patterns in special stage	; ArtNem_DE188:
	even
ArtNem_SpecialExplosion:	BINCLUDE	"art/nemesis/Explosion from special stage.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (80 blocks)
; Bomb patterns in special stage	; ArtNem_DE4BC:
	even
ArtNem_SpecialBomb:	BINCLUDE	"art/nemesis/Bomb from special stage.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (46 blocks)
; Emerald patterns in special stage	; ArtNem_DE8AC:
	even
ArtNem_SpecialEmerald:	BINCLUDE	"art/nemesis/Emerald from special stage.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (99 blocks)
; Text for the messages and thumbs up/down icon in special stage	; ArtNem_DEAF4:
	even
ArtNem_SpecialMessages:	BINCLUDE	"art/nemesis/Special stage messages and icons.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (851 blocks)
; Sonic and Tails animation frames from special stage
; Art for Obj09 and Obj10 and Obj88	; ArtNem_DEEAE:
	even
ArtNem_SpecialSonicAndTails:	BINCLUDE	"art/nemesis/Sonic and Tails animation frames in special stage.bin"
;--------------------------------------------------------------------------------------
; Nemesis compressed art (5 blocks)
; "Tails" patterns from special stage	; ArtNem_E247E:
	even
ArtNem_SpecialTailsText:	BINCLUDE	"art/nemesis/Tails text patterns from special stage.bin"

;--------------------------------------------------------------------------------------
; Special stage object perspective data (Kosinski compression)	; MiscKoz_E24FE:
;--------------------------------------------------------------------------------------
MiscKoz_SpecialPerspective:	BINCLUDE	"misc/Special stage object perspective data (Kosinski compression).bin"
;--------------------------------------------------------------------------------------
; Special stage level layout (Nemesis compression)	; MiscNem_E34EE:
;--------------------------------------------------------------------------------------
	even
MiscKoz_SpecialLevelLayout:	BINCLUDE	"misc/Special stage level layouts (Nemesis compression).bin"
;--------------------------------------------------------------------------------------
; Special stage object location list (Kosinski compression)	; MiscKoz_E35F2:
;--------------------------------------------------------------------------------------
MiscKoz_SpecialObjectLocations:	BINCLUDE	"misc/Special stage object location lists (Kosinski compression).bin"
	
;--------------------------------------------------------------------------------------
; Filler (free space) (unnecessary; could be replaced with "even")
;--------------------------------------------------------------------------------------
	align $100




;--------------------------------------------------------------------------------------
; Offset index of ring locations
;  The first commented number on each line is an array index; the second is the
;  associated zone.
;--------------------------------------------------------------------------------------
Off_Rings: zoneOrderedOffsetTable 2,2
	zoneOffsetTableEntry.w  Rings_EHZ_1	; 0  $00
	zoneOffsetTableEntry.w  Rings_EHZ_2	; 1
	zoneOffsetTableEntry.w  Rings_Lev1_1	; 2  $01
	zoneOffsetTableEntry.w  Rings_Lev1_2	; 3
	zoneOffsetTableEntry.w  Rings_Lev2_1	; 4  $02
	zoneOffsetTableEntry.w  Rings_Lev2_2	; 5
	zoneOffsetTableEntry.w  Rings_Lev3_1	; 6  $03
	zoneOffsetTableEntry.w  Rings_Lev3_2	; 7
	zoneOffsetTableEntry.w  Rings_MTZ_1	; 8  $04
	zoneOffsetTableEntry.w  Rings_MTZ_2	; 9
	zoneOffsetTableEntry.w  Rings_MTZ_3	; 10 $05
	zoneOffsetTableEntry.w  Rings_MTZ_4	; 11
	zoneOffsetTableEntry.w  Rings_WFZ_1	; 12 $06
	zoneOffsetTableEntry.w  Rings_WFZ_2	; 13
	zoneOffsetTableEntry.w  Rings_HTZ_1	; 14 $07
	zoneOffsetTableEntry.w  Rings_HTZ_2	; 15
	zoneOffsetTableEntry.w  Rings_HPZ_1	; 16 $08
	zoneOffsetTableEntry.w  Rings_HPZ_2	; 17
	zoneOffsetTableEntry.w  Rings_Lev9_1	; 18 $09
	zoneOffsetTableEntry.w  Rings_Lev9_2	; 19
	zoneOffsetTableEntry.w  Rings_OOZ_1	; 20 $0A
	zoneOffsetTableEntry.w  Rings_OOZ_2	; 21
	zoneOffsetTableEntry.w  Rings_MCZ_1	; 22 $0B
	zoneOffsetTableEntry.w  Rings_MCZ_2	; 23
	zoneOffsetTableEntry.w  Rings_CNZ_1	; 24 $0C
	zoneOffsetTableEntry.w  Rings_CNZ_2	; 25
	zoneOffsetTableEntry.w  Rings_CPZ_1	; 26 $0D
	zoneOffsetTableEntry.w  Rings_CPZ_2	; 27
	zoneOffsetTableEntry.w  Rings_DEZ_1	; 28 $0E
	zoneOffsetTableEntry.w  Rings_DEZ_2	; 29
	zoneOffsetTableEntry.w  Rings_ARZ_1	; 30 $0F
	zoneOffsetTableEntry.w  Rings_ARZ_2	; 31
	zoneOffsetTableEntry.w  Rings_SCZ_1	; 32 $10
	zoneOffsetTableEntry.w  Rings_SCZ_2	; 33
    zoneTableEnd

Rings_EHZ_1:	BINCLUDE	"levels/rings/EHZ_1.bin"
Rings_EHZ_2:	BINCLUDE	"levels/rings/EHZ_2.bin"
Rings_Lev1_1:	BINCLUDE	"levels/rings/01_1.bin"
Rings_Lev1_2:	BINCLUDE	"levels/rings/01_2.bin"
Rings_Lev2_1:	BINCLUDE	"levels/rings/02_1.bin"
Rings_Lev2_2:	BINCLUDE	"levels/rings/02_2.bin"
Rings_Lev3_1:	BINCLUDE	"levels/rings/03_1.bin"
Rings_Lev3_2:	BINCLUDE	"levels/rings/03_2.bin"
Rings_MTZ_1:	BINCLUDE	"levels/rings/MTZ_1.bin"
Rings_MTZ_2:	BINCLUDE	"levels/rings/MTZ_2.bin"
Rings_MTZ_3:	BINCLUDE	"levels/rings/MTZ_3.bin"
Rings_MTZ_4:	BINCLUDE	"levels/rings/MTZ_4.bin"
Rings_HTZ_1:	BINCLUDE	"levels/rings/HTZ_1.bin"
Rings_HTZ_2:	BINCLUDE	"levels/rings/HTZ_2.bin"
Rings_HPZ_1:	BINCLUDE	"levels/rings/HPZ_1.bin"
Rings_HPZ_2:	BINCLUDE	"levels/rings/HPZ_2.bin"
Rings_Lev9_1:	BINCLUDE	"levels/rings/09_1.bin"
Rings_Lev9_2:	BINCLUDE	"levels/rings/09_2.bin"
Rings_OOZ_1:	BINCLUDE	"levels/rings/OOZ_1.bin"
Rings_OOZ_2:	BINCLUDE	"levels/rings/OOZ_2.bin"
Rings_MCZ_1:	BINCLUDE	"levels/rings/MCZ_1.bin"
Rings_MCZ_2:	BINCLUDE	"levels/rings/MCZ_2.bin"
Rings_CNZ_1:	BINCLUDE	"levels/rings/CNZ_1.bin"
Rings_CNZ_2:	BINCLUDE	"levels/rings/CNZ_2.bin"
Rings_CPZ_1:	BINCLUDE	"levels/rings/CPZ_1.bin"
Rings_CPZ_2:	BINCLUDE	"levels/rings/CPZ_2.bin"
Rings_DEZ_1:	BINCLUDE	"levels/rings/DEZ_1.bin"
Rings_DEZ_2:	BINCLUDE	"levels/rings/DEZ_2.bin"
Rings_WFZ_1:	BINCLUDE	"levels/rings/WFZ_1.bin"
Rings_WFZ_2:	BINCLUDE	"levels/rings/WFZ_2.bin"
Rings_ARZ_1:	BINCLUDE	"levels/rings/ARZ_1.bin"
Rings_ARZ_2:	BINCLUDE	"levels/rings/ARZ_2.bin"
Rings_SCZ_1:	BINCLUDE	"levels/rings/SCZ_1.bin"
Rings_SCZ_2:	BINCLUDE	"levels/rings/SCZ_2.bin"

; --------------------------------------------------------------------------------------
; Filler (free space) (unnecessary; could be replaced with "even")
; --------------------------------------------------------------------------------------
	align $200

; --------------------------------------------------------------------------------------
; Offset index of object locations
; --------------------------------------------------------------------------------------
Off_Objects: zoneOrderedOffsetTable 2,2
	zoneOffsetTableEntry.w  Objects_EHZ_1	; 0  $00
	zoneOffsetTableEntry.w  Objects_EHZ_2	; 1
	zoneOffsetTableEntry.w  Objects_Null	; 2  $01
	zoneOffsetTableEntry.w  Objects_Null	; 3
	zoneOffsetTableEntry.w  Objects_Null	; 4  $02
	zoneOffsetTableEntry.w  Objects_Null	; 5
	zoneOffsetTableEntry.w  Objects_Null	; 6  $03
	zoneOffsetTableEntry.w  Objects_Null	; 7
	zoneOffsetTableEntry.w  Objects_MTZ_1	; 8  $04
	zoneOffsetTableEntry.w  Objects_MTZ_2	; 9
	zoneOffsetTableEntry.w  Objects_MTZ_3	; 10 $05
	zoneOffsetTableEntry.w  Objects_MTZ_3	; 11
	zoneOffsetTableEntry.w  Objects_WFZ_1	; 12 $06
	zoneOffsetTableEntry.w  Objects_WFZ_2	; 13
	zoneOffsetTableEntry.w  Objects_HTZ_1	; 14 $07
	zoneOffsetTableEntry.w  Objects_HTZ_2	; 15
	zoneOffsetTableEntry.w  Objects_HPZ_1	; 16 $08
	zoneOffsetTableEntry.w  Objects_HPZ_2	; 17
	zoneOffsetTableEntry.w  Objects_Null	; 18 $09
	zoneOffsetTableEntry.w  Objects_Null	; 19
	zoneOffsetTableEntry.w  Objects_OOZ_1	; 20 $0A
	zoneOffsetTableEntry.w  Objects_OOZ_2	; 21
	zoneOffsetTableEntry.w  Objects_MCZ_1	; 22 $0B
	zoneOffsetTableEntry.w  Objects_MCZ_2	; 23
	zoneOffsetTableEntry.w  Objects_CNZ_1	; 24 $0C
	zoneOffsetTableEntry.w  Objects_CNZ_2	; 25
	zoneOffsetTableEntry.w  Objects_CPZ_1	; 26 $0D
	zoneOffsetTableEntry.w  Objects_CPZ_2	; 27
	zoneOffsetTableEntry.w  Objects_DEZ_1	; 28 $0E
	zoneOffsetTableEntry.w  Objects_DEZ_2	; 29
	zoneOffsetTableEntry.w  Objects_ARZ_1	; 30 $0F
	zoneOffsetTableEntry.w  Objects_ARZ_2	; 31
	zoneOffsetTableEntry.w  Objects_SCZ_1	; 32 $10
	zoneOffsetTableEntry.w  Objects_SCZ_2	; 33
    zoneTableEnd

	; These things act as boundaries for the object layout parser, so it doesn't read past the end/beginning of the file
	ObjectLayoutBoundary
Objects_EHZ_1:	BINCLUDE	"levels/objects/EHZ_1.bin"
	ObjectLayoutBoundary

    if gameRevision=0
; A collision switcher was improperly placed
Objects_EHZ_2:	BINCLUDE	"levels/objects/EHZ_2 (REV00).bin"
    else
Objects_EHZ_2:	BINCLUDE	"levels/objects/EHZ_2.bin"
    endif

	ObjectLayoutBoundary
Objects_MTZ_1:	BINCLUDE	"levels/objects/MTZ_1.bin"
	ObjectLayoutBoundary
Objects_MTZ_2:	BINCLUDE	"levels/objects/MTZ_2.bin"
	ObjectLayoutBoundary
Objects_MTZ_3:	BINCLUDE	"levels/objects/MTZ_3.bin"
	ObjectLayoutBoundary

    if gameRevision=0
; The lampposts were bugged: their 'remember state' flags weren't set
Objects_WFZ_1:	BINCLUDE	"levels/objects/WFZ_1 (REV00).bin"
    else
Objects_WFZ_1:	BINCLUDE	"levels/objects/WFZ_1.bin"
    endif

	ObjectLayoutBoundary
Objects_WFZ_2:	BINCLUDE	"levels/objects/WFZ_2.bin"
	ObjectLayoutBoundary
Objects_HTZ_1:	BINCLUDE	"levels/objects/HTZ_1.bin"
	ObjectLayoutBoundary
Objects_HTZ_2:	BINCLUDE	"levels/objects/HTZ_2.bin"
	ObjectLayoutBoundary
Objects_HPZ_1:	BINCLUDE	"levels/objects/HPZ_1.bin"
	ObjectLayoutBoundary
Objects_HPZ_2:	BINCLUDE	"levels/objects/HPZ_2.bin"
	ObjectLayoutBoundary
	; Oddly, there's a gap for another layout here
	ObjectLayoutBoundary
Objects_OOZ_1:	BINCLUDE	"levels/objects/OOZ_1.bin"
	ObjectLayoutBoundary
Objects_OOZ_2:	BINCLUDE	"levels/objects/OOZ_2.bin"
	ObjectLayoutBoundary
Objects_MCZ_1:	BINCLUDE	"levels/objects/MCZ_1.bin"
	ObjectLayoutBoundary
Objects_MCZ_2:	BINCLUDE	"levels/objects/MCZ_2.bin"
	ObjectLayoutBoundary

    if gameRevision=0
; The signposts are too low, causing them to poke out the bottom of the ground
Objects_CNZ_1:	BINCLUDE	"levels/objects/CNZ_1 (REV00).bin"
	ObjectLayoutBoundary
Objects_CNZ_2:	BINCLUDE	"levels/objects/CNZ_2 (REV00).bin"
    else
Objects_CNZ_1:	BINCLUDE	"levels/objects/CNZ_1.bin"
	ObjectLayoutBoundary
Objects_CNZ_2:	BINCLUDE	"levels/objects/CNZ_2.bin"
    endif

	ObjectLayoutBoundary
Objects_CPZ_1:	BINCLUDE	"levels/objects/CPZ_1.bin"
	ObjectLayoutBoundary
Objects_CPZ_2:	BINCLUDE	"levels/objects/CPZ_2.bin"
	ObjectLayoutBoundary
Objects_DEZ_1:	BINCLUDE	"levels/objects/DEZ_1.bin"
	ObjectLayoutBoundary
Objects_DEZ_2:	BINCLUDE	"levels/objects/DEZ_2.bin"
	ObjectLayoutBoundary
Objects_ARZ_1:	BINCLUDE	"levels/objects/ARZ_1.bin"
	ObjectLayoutBoundary
Objects_ARZ_2:	BINCLUDE	"levels/objects/ARZ_2.bin"
	ObjectLayoutBoundary
Objects_SCZ_1:	BINCLUDE	"levels/objects/SCZ_1.bin"
	ObjectLayoutBoundary
Objects_SCZ_2:	BINCLUDE	"levels/objects/SCZ_2.bin"
	ObjectLayoutBoundary
Objects_Null:
	ObjectLayoutBoundary
	; Another strange space for a layout
	ObjectLayoutBoundary
	; And another
	ObjectLayoutBoundary
	; And another
	ObjectLayoutBoundary

; --------------------------------------------------------------------------------------
; Filler (free space) (unnecessary; could be replaced with "even")
; --------------------------------------------------------------------------------------
	align $1000




; ---------------------------------------------------------------------------
; Subroutine to load the sound driver
; ---------------------------------------------------------------------------
; sub_EC000:
SoundDriverLoad:
	move	sr,-(sp)
	movem.l	d0-a6,-(sp)
	move	#$2700,sr
	lea	(Z80_Bus_Request).l,a3
	lea	(Z80_Reset).l,a2
	moveq	#0,d2
	move.w	#$100,d1
	move.w	d1,(a3)	; get Z80 bus
	move.w	d1,(a2)	; release Z80 reset (was held high by console on startup)
-	btst	d2,(a3)
	bne.s	-	; wait until the 68000 has the bus
	jsr	DecompressSoundDriver(pc)
	btst	#0,(VDP_control_port+1).l	; check video mode
	sne	(Z80_RAM+zPalModeByte).l	; set if PAL
	move.w	d2,(a2)	; hold Z80 reset
	move.w	d2,(a3)	; release Z80 bus
	moveq	#$E6,d0
-	dbf	d0,-	; wait for 2,314 cycles
	move.w	d1,(a2)	; release Z80 reset
	movem.l	(sp)+,d0-a6
	move	(sp)+,sr
	rts

; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||
; Handles the decompression of the sound driver (Saxman compression, an LZSS variant)
; https://segaretro.org/Saxman_compression

; a4 == start of decompressed data (used for dictionary match offsets)
; a5 == current address of end of decompressed data 
; a6 == current address in compressed sound driver
; d3 == length of match minus 1
; d4 == offset into decompressed data of dictionary match
; d5 == number of bytes decompressed so far
; d6 == descriptor field
; d7 == bytes left to decompress

; Interestingly, this appears to be a direct translation of the Z80 version in the sound driver
; (or maybe the Z80 version is a direct translation of this...)

; loc_EC04A:
DecompressSoundDriver:
	lea	Snd_Driver(pc),a6
; WARNING: the build script needs editing if you rename this label
movewZ80CompSize:	move.w	#Snd_Driver_End-Snd_Driver,d7 ; patched (by fixpointer.exe) after compression since the exact size can't be known beforehand
	moveq	#0,d6	; The decompressor knows it's run out of descriptor bits when it starts reading 0's in bit 8
	lea	(Z80_RAM).l,a5
	moveq	#0,d5
	lea	(Z80_RAM).l,a4
; loc_EC062:
SaxDec_Loop:
	lsr.w	#1,d6	; Next descriptor bit
	btst	#8,d6	; Check if we've run out of bits
	bne.s	+	; (lsr 'shifts in' 0's)
	jsr	SaxDec_GetByte(pc)
	move.b	d0,d6
	ori.w	#$FF00,d6	; These set bits will disappear from the high byte as the register is shifted
+
	btst	#0,d6
	beq.s	SaxDec_ReadCompressed

; SaxDec_ReadUncompressed:
	jsr	SaxDec_GetByte(pc)
	move.b	d0,(a5)+
	addq.w	#1,d5
	bra.w	SaxDec_Loop
; ---------------------------------------------------------------------------
; loc_EC086:
SaxDec_ReadCompressed:
	jsr	SaxDec_GetByte(pc)
	moveq	#0,d4
	move.b	d0,d4
	jsr	SaxDec_GetByte(pc)
	move.b	d0,d3
	andi.w	#$F,d3
	addq.w	#2,d3	; d3 is the length of the match minus 1
	andi.w	#$F0,d0
	lsl.w	#4,d0
	add.w	d0,d4
	addi.w	#$12,d4
	andi.w	#$FFF,d4	; d4 is the offset into the current $1000-byte window
	; This part is a little tricky. You see, d4 currently contains the low three nibbles of an offset into the decompressed data,
	; where the dictionary match lies. The way the high nibble is decided is first by taking it from d5 - the offset of the end
	; of the decompressed data so far. Then, we see if the resulting offset in d4 is somehow higher than d5.
	; If it is, then it's invalid... *unless* you subtract $1000 from it, in which case it refers to data in the previous $1000 block of bytes.
	; This is all just a really gimmicky way of having an offset with a range of $1000 bytes from the end of the decompressed data.
	; If, however, we cannot subtract $1000 because that would put the pointer before the start of the decompressed data, then
	; this is actually a 'zero-fill' match, which encodes a series of zeroes.
	move.w	d5,d0
	andi.w	#$F000,d0
	add.w	d0,d4
	cmp.w	d4,d5
	bhs.s	SaxDec_IsDictionaryReference
	subi.w	#$1000,d4
	bcc.s	SaxDec_IsDictionaryReference

; SaxDec_IsSequenceOfZeroes:
	add.w	d3,d5
	addq.w	#1,d5

-	move.b	#0,(a5)+
	dbf	d3,-

	bra.w	SaxDec_Loop
; ---------------------------------------------------------------------------
; loc_EC0CC:
SaxDec_IsDictionaryReference:
	add.w	d3,d5
	addq.w	#1,d5

-	move.b	(a4,d4.w),(a5)+
	addq.w	#1,d4
	dbf	d3,-

	bra.w	SaxDec_Loop
; End of function DecompressSoundDriver


; ||||||||||||||| S U B R O U T I N E |||||||||||||||||||||||||||||||||||||||

; sub_EC0DE:
SaxDec_GetByte:
	move.b	(a6)+,d0
	subq.w	#1,d7	; Decrement remaining number of bytes
	bne.s	+
	addq.w	#4,sp	; Exit the decompressor by meddling with the stack
+
	rts
; End of function SaxDec_GetByte

; ===========================================================================
; ---------------------------------------------------------------------------
; S2 sound driver (Sound driver compression (slightly modified Saxman))
; ---------------------------------------------------------------------------
; loc_EC0E8:
Snd_Driver:
	save
	include "s2.sounddriver.asm" ; CPU Z80
	restore
	padding off
	!org (Snd_Driver+Size_of_Snd_driver_guess) ; don't worry; I know what I'm doing


; loc_ED04C:
Snd_Driver_End:




; ---------------------------------------------------------------------------
; Filler (free space)
; ---------------------------------------------------------------------------
	; the DAC data has to line up with the end of the bank.

	; actually it only has to fit within one bank, but we'll line it up to the end anyway
	; because the padding gives the sound driver some room to grow
	cnop -Size_of_DAC_samples, $8000

; ---------------------------------------------------------------------------
; DAC samples
; ---------------------------------------------------------------------------
; loc_ED100:
SndDAC_Start:

SndDAC_Sample1:
	BINCLUDE	"sound/DAC/Sample 1.bin"
SndDAC_Sample1_End

SndDAC_Sample2:
	BINCLUDE	"sound/DAC/Sample 2.bin"
SndDAC_Sample2_End

SndDAC_Sample5:
	BINCLUDE	"sound/DAC/Sample 5.bin"
SndDAC_Sample5_End

SndDAC_Sample6:
	BINCLUDE	"sound/DAC/Sample 6.bin"
SndDAC_Sample6_End

SndDAC_Sample3:
	BINCLUDE	"sound/DAC/Sample 3.bin"
SndDAC_Sample3_End

SndDAC_Sample4:
	BINCLUDE	"sound/DAC/Sample 4.bin"
SndDAC_Sample4_End

SndDAC_Sample7:
	BINCLUDE	"sound/DAC/Sample 7.bin"
SndDAC_Sample7_End

SndDAC_End

	if SndDAC_End - SndDAC_Start > $8000
		fatal "DAC samples must fit within $8000 bytes, but you have $\{SndDAC_End-SndDAC_Start } bytes of DAC samples."
	endif
	if SndDAC_End - SndDAC_Start > Size_of_DAC_samples
		fatal "Size_of_DAC_samples = $\{Size_of_DAC_samples}, but you have $\{SndDAC_End-SndDAC_Start} bytes of DAC samples."
	endif

; ---------------------------------------------------------------------------
; Music pointers
; ---------------------------------------------------------------------------
; loc_F0000:
MusicPoint1:	startBank
MusPtr_Continue:	rom_ptr_z80	Mus_Continue


Mus_Continue:   BINCLUDE	"sound/music/Continue.bin"

	finishBank

; --------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; HTZ boss lava ball / Sol fireball
	even
ArtNem_HtzFireball1:	BINCLUDE	"art/nemesis/Fireball 1.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (24 blocks)
; Waterfall tiles
	even
ArtNem_Waterfall:	BINCLUDE	"art/nemesis/Waterfall tiles.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Another fireball
	even
ArtNem_HtzFireball2:	BINCLUDE	"art/nemesis/Fireball 2.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (8 blocks)
; Bridge in EHZ
	even
ArtNem_EHZ_Bridge:	BINCLUDE	"art/nemesis/EHZ bridge.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (48 blocks)
; Diagonally moving lift in HTZ
	even
ArtNem_HtzZipline:	BINCLUDE	"art/nemesis/HTZ zip-line platform.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; One way barrier from HTZ
	even
ArtNem_HtzValveBarrier:	BINCLUDE	"art/nemesis/One way barrier from HTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (24 blocks)
; See-saw in HTZ
	even
ArtNem_HtzSeeSaw:	BINCLUDE	"art/nemesis/See-saw in HTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (24 blocks)
; Unused Fireball
	even
;ArtNem_F0B06:
	BINCLUDE	"art/nemesis/Fireball 3.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; Rock from HTZ
	even
ArtNem_HtzRock:	BINCLUDE	"art/nemesis/Rock from HTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; Orbit badnik from HTZ		; ArtNem_HtzSol:
	even
ArtNem_Sol:	BINCLUDE	"art/nemesis/Sol badnik from HTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (120 blocks)
; Large spinning wheel from MTZ
	even
ArtNem_MtzWheel:	BINCLUDE	"art/nemesis/Large spinning wheel from MTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (9 blocks)
; Indent in large spinning wheel from MTZ
	even
ArtNem_MtzWheelIndent:	BINCLUDE	"art/nemesis/Large spinning wheel from MTZ - indent.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (8 blocks)
; Spike block from MTZ
	even
ArtNem_MtzSpikeBlock:	BINCLUDE	"art/nemesis/MTZ spike block.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (15 blocks)
; Steam from MTZ
	even
ArtNem_MtzSteam:	BINCLUDE	"art/nemesis/Steam from MTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (8 blocks)
; Spike from MTZ
	even
ArtNem_MtzSpike:	BINCLUDE	"art/nemesis/Spike from MTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (54 blocks)
; Similarly shaded blocks from MTZ
	even
ArtNem_MtzAsstBlocks:	BINCLUDE	"art/nemesis/Similarly shaded blocks from MTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (9 blocks)
; Lava bubble from MTZ
	even
ArtNem_MtzLavaBubble:	BINCLUDE	"art/nemesis/Lava bubble from MTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; Lava cup
	even
ArtNem_LavaCup:	BINCLUDE	"art/nemesis/Lava cup from MTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (8 blocks)
; End of a bolt and rope from MTZ
	even
ArtNem_BoltEnd_Rope:	BINCLUDE	"art/nemesis/Bolt end and rope from MTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (12 blocks)
; Small cog from MTZ
	even
ArtNem_MtzCog:	BINCLUDE	"art/nemesis/Small cog from MTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (4 blocks)
; Flash inside spin tube from MTZ
	even
ArtNem_MtzSpinTubeFlash:	BINCLUDE	"art/nemesis/Spin tube flash from MTZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (32 blocks)
; Large wooden box from MCZ	; ArtNem_F187C:
	even
ArtNem_Crate:	BINCLUDE	"art/nemesis/Large wooden box from MCZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (26 blocks)
; Collapsing platform from MCZ	; ArtNem_F1ABA:
	even
ArtNem_MCZCollapsePlat:	BINCLUDE	"art/nemesis/Collapsing platform from MCZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (16 blocks)
; Switch that you pull on from MCZ	; ArtNem_F1C64:
	even
ArtNem_VineSwitch:	BINCLUDE	"art/nemesis/Pull switch from MCZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (10 blocks)
; Vine that lowers in MCZ	; ArtNem_F1D5C:
	even
ArtNem_VinePulley:	BINCLUDE	"art/nemesis/Vine that lowers from MCZ.bin"
; --------------------------------------------------------------------
; Nemesis compressed art (20 blocks)
; Log viewed from the end for folding gates in MCZ (start of MCZ2)	; ArtNem_F1E06:
	even
ArtNem_MCZGateLog:	BINCLUDE	"art/nemesis/Drawbridge logs from MCZ.bin"

; ----------------------------------------------------------------------------------
; Filler (free space)
; ----------------------------------------------------------------------------------
	; the PCM data has to line up with the end of the bank.
	cnop -Size_of_SEGA_sound, $8000

; -------------------------------------------------------------------------------
; Sega Intro Sound
; 8-bit unsigned raw audio at 16Khz
; -------------------------------------------------------------------------------
; loc_F1E8C:
Snd_Sega:	BINCLUDE	"sound/PCM/SEGA.bin"
Snd_Sega_End:

	if Snd_Sega_End - Snd_Sega > $8000
		fatal "Sega sound must fit within $8000 bytes, but you have a $\{Snd_Sega_End-Snd_Sega} byte Sega sound."
	endif
	if Snd_Sega_End - Snd_Sega > Size_of_SEGA_sound
		fatal "Size_of_SEGA_sound = $\{Size_of_SEGA_sound}, but you have a $\{Snd_Sega_End-Snd_Sega} byte Sega sound."
	endif

; ------------------------------------------------------------------------------
; Music pointers
; ------------------------------------------------------------------------------
; loc_F8000:
MusicPoint2:	startBank
MusPtr_CNZ_2P:		rom_ptr_z80	Mus_CNZ_2P
MusPtr_EHZ:		rom_ptr_z80	Mus_EHZ
MusPtr_MTZ:		rom_ptr_z80	Mus_MTZ
MusPtr_CNZ:		rom_ptr_z80	Mus_CNZ
MusPtr_MCZ:		rom_ptr_z80	Mus_MCZ
MusPtr_MCZ_2P:		rom_ptr_z80	Mus_MCZ_2P
MusPtr_ARZ:		rom_ptr_z80	Mus_ARZ
MusPtr_DEZ:		rom_ptr_z80	Mus_DEZ
MusPtr_SpecStage:	rom_ptr_z80	Mus_SpecStage
MusPtr_Options:		rom_ptr_z80	Mus_Options
MusPtr_Ending:		rom_ptr_z80	Mus_Ending
MusPtr_EndBoss:		rom_ptr_z80	Mus_EndBoss
MusPtr_CPZ:		rom_ptr_z80	Mus_CPZ
MusPtr_Boss:		rom_ptr_z80	Mus_Boss
MusPtr_SCZ:		rom_ptr_z80	Mus_SCZ
MusPtr_OOZ:		rom_ptr_z80	Mus_OOZ
MusPtr_WFZ:		rom_ptr_z80	Mus_WFZ
MusPtr_EHZ_2P:		rom_ptr_z80	Mus_EHZ_2P
MusPtr_2PResult:	rom_ptr_z80	Mus_2PResult
MusPtr_SuperSonic:	rom_ptr_z80	Mus_SuperSonic
MusPtr_HTZ:		rom_ptr_z80	Mus_HTZ
MusPtr_ExtraLife:	rom_ptr_z80	Mus_ExtraLife
MusPtr_Title:		rom_ptr_z80	Mus_Title
MusPtr_EndLevel:	rom_ptr_z80	Mus_EndLevel
MusPtr_GameOver:	rom_ptr_z80	Mus_GameOver
MusPtr_Invincible:	rom_ptr_z80	Mus_Invincible
MusPtr_Emerald:		rom_ptr_z80	Mus_Emerald
MusPtr_HPZ:		rom_ptr_z80	Mus_HPZ
MusPtr_Drowning:	rom_ptr_z80	Mus_Drowning
MusPtr_Credits:		rom_ptr_z80	Mus_Credits

; loc_F803C:
Mus_HPZ:	BINCLUDE	"sound/music/HPZ.bin"
Mus_Drowning:	BINCLUDE	"sound/music/Drowning.bin"
Mus_Invincible:	BINCLUDE	"sound/music/Invincible.bin"
Mus_CNZ_2P:	BINCLUDE	"sound/music/CNZ_2p.bin"
Mus_EHZ:	BINCLUDE	"sound/music/EHZ.bin"
Mus_MTZ:	BINCLUDE	"sound/music/MTZ.bin"
Mus_CNZ:	BINCLUDE	"sound/music/CNZ.bin"
Mus_MCZ:	BINCLUDE	"sound/music/MCZ.bin"
Mus_MCZ_2P:	BINCLUDE	"sound/music/MCZ_2p.bin"
Mus_ARZ:	BINCLUDE	"sound/music/ARZ.bin"
Mus_DEZ:	BINCLUDE	"sound/music/DEZ.bin"
Mus_SpecStage:	BINCLUDE	"sound/music/SpecStg.bin"
Mus_Options:	BINCLUDE	"sound/music/Options.bin"
Mus_Ending:	BINCLUDE	"sound/music/Ending.bin"
Mus_EndBoss:	BINCLUDE	"sound/music/End_Boss.bin"
Mus_CPZ:	BINCLUDE	"sound/music/CPZ.bin"
Mus_Boss:	BINCLUDE	"sound/music/Boss.bin"
Mus_SCZ:	BINCLUDE	"sound/music/SCZ.bin"
Mus_OOZ:	BINCLUDE	"sound/music/OOZ.bin"
Mus_WFZ:	BINCLUDE	"sound/music/WFZ.bin"
Mus_EHZ_2P:	BINCLUDE	"sound/music/EHZ_2p.bin"
Mus_2PResult:	BINCLUDE	"sound/music/2player results screen.bin"
Mus_SuperSonic:	BINCLUDE	"sound/music/Supersonic.bin"
Mus_HTZ:	BINCLUDE	"sound/music/HTZ.bin"
Mus_Title:	BINCLUDE	"sound/music/Title screen.bin"
Mus_EndLevel:	BINCLUDE	"sound/music/End of level.bin"

	; The following act mostly like sound effects
	; despite being listed with the music.
	; This means they're uncompressed format with absolute pointers
	; instead of compressed with relative pointers.
	; Because they have absolute pointers,
	; they have to be assembled rather than BINCLUDE'd.
	; See below (right before Sound20) for other notes
	; about the sound format that apply to these too.

;Mus_ExtraLife:	BINCLUDE	"sound/music/Extra life.bin"
Mus_ExtraLife:	dc.w z80_ptr(Mus_EL_Voices),$0603,$02CD
		dc.w z80_ptr(Mus_EL_DAC),$0000
		dc.w z80_ptr(Mus_EL_FM1),$E810
		dc.w z80_ptr(Mus_EL_FM2),$E810
		dc.w z80_ptr(Mus_EL_FM3),$E810
		dc.w z80_ptr(Mus_EL_FM4),$E810
		dc.w z80_ptr(Mus_EL_FM5),$E810
		dc.w z80_ptr(Mus_EL_PSG1),$D008,$0005
		dc.w z80_ptr(Mus_EL_PSG2),$DC08,$0005
		dc.w z80_ptr(Mus_EL_PSG3),$DC00,$0004
Mus_EL_FM4:	dc.b $E1,$03,$E0,$40,$F6
		dc.w z80_ptr(+)
Mus_EL_FM1:	dc.b $E0,$80
+		dc.b $EF,$00,$E8,$06,$D9,$06,$03,$03,$06,$06
		dc.b $E8,$00,$DB,$09,$D7,$D6,$06,$D9,$18,$F2
Mus_EL_FM2:	dc.b $EF,$01,$E8,$06,$E2,$01,$D6,$06,$03,$03,$06,$06
		dc.b $E8,$00,$D7,$09,$D4,$D2,$06,$D6,$18,$E2,$01,$F2
Mus_EL_FM5:	dc.b $E1,$03,$E0,$40,$F6
		dc.w z80_ptr(+)
Mus_EL_FM3:	dc.b $E0,$80
+		dc.b $EF,$02,$BA,$0C,$80,$06,$BA,$B8,$80,$03
		dc.b $B8,$06,$80,$03,$B8,$06,$BA,$18,$F2
Mus_EL_PSG1:	dc.b $E8,$06,$D6,$06,$03,$03,$06,$06,$E8,$00,$D7,$09
		dc.b $D4,$D2,$06,$D6,$18
Mus_EL_PSG2:
Mus_EL_PSG3:	dc.b $F2
Mus_EL_DAC:	dc.b $88,$12,$06,$8B,$09,$09,$06,$88,$06,$8A,$88,$8A
		dc.b $88,$0C,$E4
Mus_EL_Voices:	dc.b $3A,$01,$01,$07,$01,$8E,$8D,$8E,$53,$0E,$0E,$0E
		dc.b $03,$00,$00,$00,$00,$1F,$1F,$FF,$0F,$18,$16,$4E,$80
		dc.b $3A,$01,$01,$07,$01,$8E,$8D,$8E,$53,$0E,$0E,$0E
		dc.b $03,$00,$00,$00,$00,$1F,$1F,$FF,$0F,$18,$27,$28,$80
		dc.b $3A,$01,$01,$07,$01,$8E,$8D,$8E,$53,$0E,$0E,$0E
		dc.b $03,$00,$00,$00,$07,$1F,$1F,$FF,$0F,$18,$27,$28,$80


;Mus_GameOver:	BINCLUDE	"sound/music/Game over.bin"
Mus_GameOver:	dc.w z80_ptr(MusGO_Voices),$0603,$02F2
		dc.w z80_ptr(MusGOver_DAC),$0000
		dc.w z80_ptr(MusGOver_FM1),$E80A
		dc.w z80_ptr(MusGOver_FM2),$F40F
		dc.w z80_ptr(MusGOver_FM3),$F40F
		dc.w z80_ptr(MusGOver_FM4),$F40D
		dc.w z80_ptr(MusGOver_FM5),$DC16
		dc.w z80_ptr(MusGOver_PSG),$D003,$0005
		dc.w z80_ptr(MusGOver_PSG),$DC06,$0005
		dc.w z80_ptr(MusGOver_PSG),$DC00,$0004
MusGOver_FM1:	dc.b $EF,$00
		dc.b $F0,$20,$01,$04,$05
		dc.b $80,$0C,$CA,$12,$80,$06,$CA,$80,$CB,$12,$C8,$1E
		dc.b $CA,$06,$80,$CA,$80,$CA,$80,$C6,$80,$C4,$12,$C8
		dc.b $0C,$80,$12,$C9,$04,$80,$C9,$C8,$06,$80,$C7,$80
		dc.b $C6,$80
		dc.b $F0,$28,$01,$18,$05
		dc.b $C5,$60,$F2
MusGOver_FM2:	dc.b $EF,$01,$80,$01,$D9,$06,$80,$D9,$80,$D6,$80,$D6
		dc.b $80,$D7,$15,$D7,$1B,$D9,$06,$80,$D9,$80,$D6,$80
		dc.b $D6,$80,$DC,$15,$DC,$1B,$F2
MusGOver_FM3:	dc.b $EF,$01,$D6,$0C,$D6,$D2,$D2,$D4,$15,$D4,$1B,$D6
		dc.b $0C,$D6,$D2,$D2,$D7,$15,$D7,$1B,$F2
MusGOver_FM4:	dc.b $EF,$02,$E2,$01,$AE,$06,$80,$AE,$80,$A9,$80,$A9
		dc.b $80,$AC,$15,$AB,$0C,$AC,$03,$AB,$0C,$AE,$06,$80
		dc.b $AE,$80,$A9,$80,$A9,$80,$B3,$15,$B2,$0C,$B3,$03
		dc.b $B2,$0C,$AE,$04,$80,$AE,$AD,$06,$80,$AC,$80,$AB
		dc.b $80,$AB,$60,$E2,$01,$F2
MusGOver_FM5:	dc.b $EF,$03,$80,$30,$D7,$12,$80,$03,$D7,$1B,$80,$30
		dc.b $DC,$12,$80,$03,$DC,$1B
MusGOver_PSG:	dc.b $F2
MusGOver_DAC:	dc.b $80,$18,$81
		dc.b $F7,$00,$04
		dc.w z80_ptr(MusGOver_DAC)
		dc.b $F2
MusGO_Voices:	dc.b $3A,$51,$51,$08,$02,$1E,$1E,$1E,$10,$1F,$1F,$1F
		dc.b $0F,$00,$00,$00,$02,$0F,$0F,$0F,$1F,$18,$22,$24,$81
		dc.b $3C,$33,$73,$30,$70,$94,$96,$9F,$9F,$12,$14,$00
		dc.b $0F,$04,$04,$0A,$0D,$2F,$4F,$0F,$2F,$33,$1A,$80,$80
		dc.b $3A,$01,$01,$07,$01,$8E,$8D,$8E,$53,$0E,$0E,$0E
		dc.b $03,$00,$00,$00,$07,$1F,$1F,$FF,$0F,$1C,$27,$28,$80
		dc.b $1F,$66,$53,$31,$22,$1C,$1F,$98,$1F,$12,$0F,$0F
		dc.b $0F,$00,$00,$00,$00,$FF,$0F,$0F,$0F,$8C,$8A,$8D,$8B

;Mus_Emerald:	BINCLUDE	"sound/music/Got an emerald.bin"
Mus_Emerald:	dc.w z80_ptr(MusEmrldVoices),$0703,$01D5
		dc.w z80_ptr(MusEmeraldDAC),$0000
		dc.w z80_ptr(MusEmeraldFM1),$F408
		dc.w z80_ptr(MusEmeraldFM2),$F408
		dc.w z80_ptr(MusEmeraldFM3),$F407
		dc.w z80_ptr(MusEmeraldFM4),$F416
		dc.w z80_ptr(MusEmeraldFM5),$F416
		dc.w z80_ptr(MusEmeraldFM6),$F416
		dc.w z80_ptr(MusEmeraldPSG1),$F402,$0004
		dc.w z80_ptr(MusEmeraldPSG2),$F402,$0005
		dc.w z80_ptr(MusEmeraldPSG3),$F400,$0004
MusEmeraldFM3:	dc.b $E1,$02
MusEmeraldFM1:	dc.b $EF,$00,$C1,$06,$C4,$C9,$CD,$0C,$C9,$D0,$2A,$F2
MusEmeraldFM2:	dc.b $EF,$00,$BD,$06,$C1,$C4,$C9,$0C,$C6,$CB,$2A,$F2
MusEmeraldFM4:	dc.b $EF,$01,$C1,$0C,$C1,$06,$C4,$06,$80,$C4,$80,$C9
		dc.b $2A,$F2
MusEmeraldFM5:	dc.b $EF,$01,$C9,$0C,$C9,$06,$CD,$06,$80,$CD,$80,$D0
		dc.b $2A,$F2
MusEmeraldFM6:	dc.b $EF,$01,$C4,$0C,$C4,$06,$C9,$06,$80,$C9,$80,$CD
		dc.b $2A,$F2
MusEmeraldPSG2:	dc.b $80,$2D
-		dc.b $C4,$06,$C2,$C1,$BF,$EC,$03
		dc.b $F7,$00,$04
		dc.w z80_ptr(-)
		dc.b $F2
MusEmeraldPSG1:	dc.b $E2,$01,$80,$02,$80,$2D
-		dc.b $C4,$06,$C2,$C1,$BF,$EC,$03
		dc.b $F7,$00,$04
		dc.w z80_ptr(-)
MusEmeraldPSG3:
MusEmeraldDAC:	dc.b $E2,$01,$F2
MusEmrldVoices:	dc.b $04,$35,$54,$72,$46,$1F,$1F,$1F,$1F,$07,$07,$0A
		dc.b $0D,$00,$00,$0B,$0B,$1F,$1F,$0F,$0F,$23,$1D,$14,$80
		dc.b $3C,$31,$50,$52,$30,$52,$52,$53,$53,$08,$08,$00
		dc.b $00,$04,$04,$00,$00,$10,$10,$07,$07,$1A,$16,$80,$80

;Mus_Credits:	BINCLUDE	"sound/music/Credits.bin"
Mus_Credits:	dc.w z80_ptr(MusCred_Voices),$0603,$01F0
		dc.w z80_ptr(MusCred_DAC),$0000
		dc.w z80_ptr(MusCred_FM1),$000E
		dc.w z80_ptr(MusCred_FM2),$180A
		dc.w z80_ptr(MusCred_FM3),$0014
		dc.w z80_ptr(MusCred_FM4),$0016
		dc.w z80_ptr(MusCred_FM5),$0C16
		dc.w z80_ptr(MusCred_PSG1),$E806,$000B
		dc.w z80_ptr(MusCred_PSG2),$DC07,$000B
		dc.w z80_ptr(MusCred_PSG3),$0002,$0003
MusCred_FM1:	dc.b $E9,$F4,$E6,$FE,$F8
		dc.w z80_ptr(MusCreditsDB06)
		dc.b $E9,$0C,$E6,$02
-		dc.b $80,$30
		dc.b $F7,$00,$08
		dc.w z80_ptr(-)
		dc.b $EF,$03,$F8
		dc.w z80_ptr(MusCreditsD9D1)
		dc.b $AE,$06,$A2,$F8
		dc.w z80_ptr(MusCreditsD9D1)
		dc.b $E6,$FD
-		dc.b $EF,$00,$B7,$06,$BA,$F8
		dc.w z80_ptr(MusCreditsDA13)
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $80,$06,$80,$80,$30,$80,$EF,$0B,$E9,$18,$E6,$02
-		dc.b $94,$0C,$8F,$92,$8F,$06,$94,$05,$94,$07,$06,$8F
		dc.b $0C,$92,$8F
		dc.b $F7,$00,$05
		dc.w z80_ptr(-)
		dc.b $80,$30,$80,$EF,$0E,$E6,$FF,$E9,$E8,$F8
		dc.w z80_ptr(MusCreditsDAE5)
		dc.b $80,$12,$91,$94,$06,$80,$18,$96,$12,$9A,$06,$80
		dc.b $80,$12,$8F,$93,$08,$80,$16,$96,$06,$91,$92,$94
		dc.b $96,$F8
		dc.w z80_ptr(MusCreditsDAE5)
		dc.b $80,$12,$9D,$9A,$08,$80,$16,$96,$12,$9D,$08,$80
		dc.b $04,$EF,$12
		dc.b $F0,$18,$01,$0A,$04
		dc.b $80,$30,$80,$F8
		dc.w z80_ptr(MusCreditsDA5F)
		dc.b $E7,$24,$E7,$C5,$01,$E7,$C4,$E7,$C3,$E7,$C2,$E7
		dc.b $C1,$E7,$C0,$E7,$BF,$E7,$BE,$E7,$BD,$E7,$BC,$E7
		dc.b $BB,$E7,$BA,$80,$60,$EF,$01,$E9,$F4,$E6,$FA,$F4
		dc.b $F8
		dc.w z80_ptr(MusCreditsDA99)
		dc.b $B1,$03,$F8
		dc.w z80_ptr(MusCreditsDA99)
		dc.b $80,$03,$80,$60,$E6,$04,$E1,$01,$EF,$1B,$E6,$06
		dc.b $C1,$0C,$E8,$06,$BD,$06,$BA,$BD,$0C,$80,$80,$EF
		dc.b $1C,$E6,$FA,$E8,$00,$BC,$0C,$12,$06,$EF,$1B,$E6
		dc.b $06,$E8,$06,$C2,$06,$C2,$80,$C2,$80,$C2,$E8,$00
		dc.b $C3,$0C,$C4,$80,$E8,$06,$C4,$06,$06,$C6,$C4,$E8
		dc.b $00,$C1,$0C,$E8,$06,$BD,$06,$BA,$BD,$0C,$80,$80
		dc.b $E8,$00,$EF,$1C,$E6,$FA,$C1,$C4,$C1,$EF,$1A,$E6
		dc.b $06,$E8,$06,$C2,$06,$C2,$80,$C2,$80,$C2,$E8,$00
		dc.b $C3,$0C,$C4,$06,$80,$80,$24,$80,$30,$80,$EF,$1F
		dc.b $E9,$18,$E6,$F7,$E1,$00,$80,$06,$AC,$AE,$80,$B1
		dc.b $80,$B3,$80,$B4,$80,$B3,$80,$B1,$B3,$80,$B1,$E9
		dc.b $F4,$EF,$00,$80,$0C,$AC,$06,$AE,$B1,$80,$12,$AC
		dc.b $06,$AE,$B1,$80,$B4,$B1,$80,$B1,$E9,$0C,$EF,$1F
		dc.b $80,$06,$B8,$12,$B4,$06,$80,$B3,$80,$B4,$80,$B3
		dc.b $80,$B1,$AE,$80,$B1,$E9,$F4,$EF,$00,$80,$06,$AF
		dc.b $12,$AE,$06,$80,$12,$AF,$06,$80,$AE,$80,$AF,$B1
		dc.b $80,$B1,$80,$30,$80,$EF,$21,$E9,$0C,$80,$30,$80
		dc.b $08,$A0,$04,$9E,$0C,$9D,$9B,$99,$08,$04,$91,$0C
		dc.b $92,$93,$94,$98,$99,$9B,$9D,$98,$95,$93,$91,$98
		dc.b $9D,$91,$96,$98,$99,$98,$96,$99,$9D,$96,$95,$97
		dc.b $99,$97,$95,$96,$97,$98,$99,$98,$99,$9B,$9D,$08
		dc.b $04,$98,$0C,$91,$95,$96,$98,$99,$9D,$9E,$08,$96
		dc.b $10,$97,$0C,$98,$F8
		dc.w z80_ptr(MusCreditsDAFE)
		dc.b $9E,$E6,$04,$F8
		dc.w z80_ptr(MusCreditsDAFE)
		dc.b $9E,$E6,$FC,$F8
		dc.w z80_ptr(MusCreditsDAFE)
		dc.b $9E,$08,$99,$04,$EF,$23,$E9,$E8,$E6,$07,$80,$60
		dc.b $F8
		dc.w z80_ptr(MusCreditsDABE)
		dc.b $80,$60,$E6,$FB,$80,$0C,$CD,$06,$80,$D4,$CD,$06
		dc.b $80,$0C,$CD,$06,$80,$D4,$CD,$06,$80,$18,$E6,$05
		dc.b $80,$0C,$AE,$80,$AE,$80,$24,$E1,$02,$E6,$08,$A2
		dc.b $6C,$F2
MusCreditsD9D1:	dc.b $A5,$0C,$B1,$06,$80,$B1,$0C,$AC,$B3,$12,$B1,$0C
		dc.b $AC,$06,$AE,$B1,$A7,$0C,$B3,$06,$80,$B3,$0C,$AE
		dc.b $B5,$12,$B3,$06,$80,$AE,$B0,$B3,$A3,$0C,$AF,$06
		dc.b $80,$AF,$0C,$AA,$B1,$12,$AF,$0C,$AA,$06,$AC,$AF
		dc.b $A2,$0C,$AE,$06,$A2,$A4,$0C,$B0,$06,$A4,$A5,$0C
		dc.b $B1,$06,$A5,$A2,$0C,$E3
MusCreditsDA13:	dc.b $BE,$0C,$BC,$06,$BA,$BC,$BA,$04,$E7,$08,$BA,$04
		dc.b $80,$0E,$EF,$07,$B7,$06,$B2,$B5,$B7,$EF,$00,$B7
		dc.b $BA,$BE,$0C,$BC,$06,$BA,$BC,$BA,$0C,$BC,$04,$80
		dc.b $08,$BA,$04,$80,$08,$BC,$04,$80,$08,$BE,$12,$BA
		dc.b $06,$B7,$80,$B7,$80,$24,$EF,$07,$B7,$06,$B2,$B5
		dc.b $B7,$80,$0C,$80,$30,$BE,$06,$BE,$BA,$04,$80,$08
		dc.b $BC,$06,$BE,$E3
MusCreditsDA5F:	dc.b $C3,$01,$E7,$C4,$E7,$C5,$E7,$C6,$2D,$E9,$02,$C3
		dc.b $01,$E7,$C4,$E7,$C5,$E7,$C6,$2D,$E9,$01,$C3,$01
		dc.b $E7,$C4,$E7,$C5,$E7,$C6,$2D,$E9,$FC,$C3,$01,$E7
		dc.b $C4,$E7,$C5,$E7,$C6,$2D,$E9,$01,$C3,$01,$E7,$C4
		dc.b $E7,$C5,$E7,$C6,$2D,$E7,$30,$E7,$30,$E3
MusCreditsDA99:	dc.b $A7,$0C,$B3,$06,$80,$B1,$80,$B3,$0C,$A7,$03,$80
		dc.b $06,$A7,$03,$B3,$0C,$B1,$B3,$09,$AE,$03,$AC,$06
		dc.b $80,$AC,$0C,$AE,$06,$80,$AE,$0C,$AF,$06,$80,$27
		dc.b $E3
MusCreditsDABE:	dc.b $80,$0C,$CA,$15,$80,$03,$CA,$06,$80,$CB,$0F,$80
		dc.b $03,$C8,$18,$80,$06,$CA,$80,$CA,$80,$CA,$80,$C6
		dc.b $80,$C4,$0F,$80,$03,$C8,$18,$80,$06
		dc.b $F7,$00,$02
		dc.w z80_ptr(MusCreditsDABE)
		dc.b $E3
MusCreditsDAE5:	dc.b $80,$12,$94,$97,$06,$80,$18,$99,$12,$94,$06,$80
		dc.b $80,$12,$92,$96,$06,$80,$18,$97,$12,$92,$06,$80
		dc.b $E3
MusCreditsDAFE:	dc.b $80,$99,$80,$99,$80,$9E,$80,$E3
MusCreditsDB06:	dc.b $EF,$07,$80,$54,$C7,$04,$C8,$C9,$CA,$24,$CD,$D2
		dc.b $18,$D0,$24,$CF,$CB,$18,$CB,$0C,$CA,$80,$CD,$60
		dc.b $E7,$3C,$CA,$24,$CD,$D2,$18,$D4,$24,$D0,$D4,$18
		dc.b $D4,$24,$D6,$60,$E7,$3C,$E3
MusCred_FM2:	dc.b $80,$60,$EF,$01,$E8,$06,$F8
		dc.w z80_ptr(MusCreditsDE2A)
		dc.b $F8
		dc.w z80_ptr(MusCreditsDE2A)
-		dc.b $85,$0C
		dc.b $F7,$00,$0C
		dc.w z80_ptr(-)
		dc.b $8A,$87,$88,$89,$F8
		dc.w z80_ptr(MusCreditsDE2A)
-		dc.b $88
		dc.b $F7,$00,$0B
		dc.w z80_ptr(-)
-		dc.b $8A
		dc.b $F7,$00,$0A
		dc.w z80_ptr(-)
		dc.b $E8,$00,$E6,$FC,$8A,$8B,$8C,$E6,$04,$E8,$09
-		dc.b $8D,$0C
		dc.b $F7,$00,$0C
		dc.w z80_ptr(-)
		dc.b $E8,$00,$8D,$8A,$8B,$8C,$E8,$09
-		dc.b $8D,$0C
		dc.b $F7,$00,$0C
		dc.w z80_ptr(-)
		dc.b $8D,$06,$99,$E8,$00,$8A,$0C,$8B,$8C,$E9,$E8,$E6
		dc.b $0C,$EF,$04
-		dc.b $F8
		dc.w z80_ptr(MusCreditsDD59)
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $E6,$F9,$EF,$08
MusCreditsDB93:	dc.b $F8
		dc.w z80_ptr(MusCreditsDD8D)
-		dc.b $9F,$04,$80,$08,$9F,$0C
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $06,$9C,$12,$9D,$0C,$9E,$F8
		dc.w z80_ptr(MusCreditsDD8D)
-		dc.b $9D,$04,$80,$08,$9D,$0C
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
-		dc.b $9C,$04,$80,$08,$9C,$0C
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $F7,$01,$02
		dc.w z80_ptr(MusCreditsDB93)
		dc.b $80,$60,$80,$48,$EF,$0C,$E6,$13,$F8
		dc.w z80_ptr(MusCreditsDD9D)
		dc.b $24,$80,$60,$EF,$0F,$E6,$F3
		dc.b $F0,$04,$02,$03,$02
		dc.b $F8
		dc.w z80_ptr(MusCreditsDDB5)
		dc.b $C4,$18,$C3,$30,$E7,$18,$80,$0C,$F8
		dc.w z80_ptr(MusCreditsDDB5)
		dc.b $BE,$EF,$13,$E6,$F5,$F4,$80,$60
-		dc.b $F8
		dc.w z80_ptr(MusCreditsDDEA)
		dc.b $A8,$0C,$A9,$08,$A1,$10,$F8
		dc.w z80_ptr(MusCreditsDDEA)
		dc.b $A8,$08,$A9,$04,$80,$18
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $80,$60,$EF,$17,$E1,$02,$E9,$F4,$E6,$0A,$F8
		dc.w z80_ptr(MusCreditsDDD5)
		dc.b $CE,$15,$CD,$03,$CB,$06,$80,$C9,$0C,$CD,$06,$80
		dc.b $C9,$0C,$CB,$06,$80,$12,$80,$60,$EF,$1B,$E1,$00
		dc.b $E8,$06,$80,$3C,$B8,$06,$06,$BA,$BD,$BD,$BA,$EF
		dc.b $1D,$E6,$FA,$E8,$00,$F8
		dc.w z80_ptr(MusCreditsDDF9)
		dc.b $80,$F8
		dc.w z80_ptr(MusCreditsDE09)
		dc.b $F8
		dc.w z80_ptr(MusCreditsDDF9)
		dc.b $EF,$1C,$BD,$EF,$1D,$F8
		dc.w z80_ptr(MusCreditsDE09)
		dc.b $80,$30,$80,$EF,$01,$E9,$18,$E6,$F9
-		dc.b $99,$0C,$A5,$06,$80,$96,$0C,$A2,$06,$80,$97,$0C
		dc.b $A3,$06,$80,$98,$0C,$A8,$06,$A7,$99,$06,$99,$12
		dc.b $96,$0C,$A2,$06,$80,$97,$0C,$A3,$06,$80,$98,$0C
		dc.b $A4,$06,$80
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $80,$60,$EF,$22,$E9,$E8,$E6,$03
		dc.b $F0,$1C,$01,$06,$04
		dc.b $80,$50,$AC,$04,$AE,$08,$B1,$04,$B5,$30,$80,$0C
		dc.b $B5,$08,$80,$04,$B6,$08,$B5,$10,$B9,$08,$04,$80
		dc.b $08,$B5,$34,$80,$0C,$B5,$BA,$08,$04,$80,$08,$B5
		dc.b $04,$B1,$24,$80,$0C,$B1,$08,$80,$04,$B3,$08,$B1
		dc.b $04,$B4,$0C,$B3,$08,$B1,$4C,$80,$0C,$B5,$08,$80
		dc.b $04,$B6,$08,$80,$04,$B5,$08,$80,$04,$B9,$08,$04
		dc.b $80,$08,$B5,$1C,$80,$0C,$BA,$18,$BC,$08,$BA,$04
		dc.b $BD,$18,$80,$0C,$BA,$04,$80,$08,$B8,$18,$B5,$B1
		dc.b $B3,$0C,$E6,$04,$F8
		dc.w z80_ptr(MusCreditsDE17)
		dc.b $B3,$0C,$E6,$FC,$F8
		dc.w z80_ptr(MusCreditsDE17)
		dc.b $B3,$14,$B1,$04,$E6,$FF,$EF,$24,$F4,$80,$60
-		dc.b $F8
		dc.w z80_ptr(MusCreditsDE20)
		dc.b $AC,$12,$AB,$0C,$AC,$06,$AB,$0C,$F8
		dc.w z80_ptr(MusCreditsDE20)
		dc.b $B3,$12,$B2,$0C,$B3,$06,$B2,$0C
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $AC,$06,$80,$A9,$80,$AA,$80,$AB,$80,$AC,$AC,$A9
		dc.b $80,$AA,$80,$AC,$80,$A9,$80,$A9,$80,$AD,$80,$AD
		dc.b $80,$B0,$80,$B0,$80,$B3,$80,$B3,$80,$80,$0C,$A2
		dc.b $12,$80,$06,$A2,$12,$AD,$AE,$06,$80,$E6,$FD,$A2
		dc.b $6C,$F2
MusCreditsDD59:	dc.b $80,$0C,$C4,$06,$80,$C6,$80,$C4,$80,$C9,$80,$C9
		dc.b $80,$CB,$CD,$80,$0C,$80,$CB,$18,$C6,$06,$80,$C9
		dc.b $C9,$80,$CB,$0C,$80,$12,$80,$1E,$C7,$06,$C9,$C7
		dc.b $CB,$80,$C9,$80,$C7,$C9,$80,$C6,$E7,$C6,$30,$E7
		dc.b $18,$80,$18,$E3
MusCreditsDD8D:	dc.b $9F,$04,$80,$08,$9F,$0C
		dc.b $F7,$00,$03
		dc.w z80_ptr(MusCreditsDD8D)
		dc.b $06,$AB,$9F,$0C,$E3
MusCreditsDD9D:	dc.b $B8,$08,$BA,$BC,$B6,$30,$E7,$30,$E7,$B6,$80,$18
		dc.b $B8,$08,$BA,$BC,$B6,$30,$E7,$30,$E7,$30,$E7,$E3
MusCreditsDDB5:	dc.b $BF,$06,$BD,$BF,$12,$C2,$BF,$0C,$C1,$80,$06,$12
		dc.b $C4,$0C,$C2,$06,$80,$C9,$C6,$3C,$80,$06,$0C,$C7
		dc.b $12,$C6,$C4,$06,$C2,$C1,$18,$E3
MusCreditsDDD5:	dc.b $CE,$15,$CD,$03,$CB,$06,$80,$C9,$0C,$CD,$06,$80
		dc.b $C9,$0C,$CB,$06,$80,$12,$80,$60,$E3
MusCreditsDDEA:	dc.b $A2,$0C,$AE,$AC,$08,$AE,$04,$AC,$08,$A9,$04,$A7
		dc.b $08,$04,$E3
MusCreditsDDF9:	dc.b $80,$0C,$B1,$AE,$06,$06,$AC,$0C,$80,$B0,$AE,$06
		dc.b $06,$AC,$0C,$E3
MusCreditsDE09:	dc.b $AE,$AC,$06,$06,$AA,$0C,$80,$AC,$0C,$06,$06,$AE
		dc.b $AC,$E3
MusCreditsDE17:	dc.b $BA,$04,$80,$08,$B8,$18,$B5,$B1,$E3
MusCreditsDE20:	dc.b $AE,$06,$80,$AE,$80,$A9,$80,$A9,$80,$E3
MusCreditsDE2A:	dc.b $8A,$0C
		dc.b $F7,$00,$08
		dc.w z80_ptr(MusCreditsDE2A)
		dc.b $E3
MusCred_FM3:	dc.b $80,$60,$F8
		dc.w z80_ptr(MusCreditsE065)
		dc.b $E9,$18,$EF,$02,$F8
		dc.w z80_ptr(MusCreditsE040)
		dc.b $B8,$3C,$F8
		dc.w z80_ptr(MusCreditsE040)
		dc.b $BD,$3C,$E9,$E8,$E6,$02,$E1,$03,$EF,$04,$E0,$80
-		dc.b $F8
		dc.w z80_ptr(MusCreditsDD59)
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $EF,$09,$E9,$0C,$E6,$FD,$E0,$40
		dc.b $F0,$06,$01,$05,$04
		dc.b $E1,$00
-		dc.b $9F,$0C,$AB,$06,$80,$A9,$80,$AB,$9F,$80,$9F,$AB
		dc.b $80,$A9,$80,$AB,$0C
		dc.b $F7,$00,$03
		dc.w z80_ptr(-)
		dc.b $9D,$0C,$A9,$06,$80,$A8,$80,$A9,$9C,$80,$9C,$A8
		dc.b $80,$A6,$80,$A8,$0C
		dc.b $F7,$01,$02
		dc.w z80_ptr(-)
		dc.b $80,$60,$EF,$0D,$E6,$FB,$E0,$C0,$F4,$80,$60
-		dc.b $F8
		dc.w z80_ptr(MusCreditsDFF2)
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $80,$60,$EF,$0F,$E0,$80,$E6,$0B,$F8
		dc.w z80_ptr(MusCreditsDDB5)
		dc.b $C4,$18,$C3,$48,$80,$0C,$F8
		dc.w z80_ptr(MusCreditsDDB5)
		dc.b $BE,$0C
		dc.b $F0,$18,$01,$03,$04
		dc.b $E6,$F3,$E0,$C0,$EF,$14,$A2,$14,$A4,$04,$A5,$04
		dc.b $80,$08,$A9,$04,$80,$08,$A8,$04,$80,$08,$A9,$04
		dc.b $80,$08,$AC,$08,$A9,$10
-		dc.b $80,$30
		dc.b $F7,$00,$0A
		dc.w z80_ptr(-)
		dc.b $EF,$18,$E9,$F4,$E6,$08,$F4,$E0,$40,$80,$60,$80
		dc.b $30,$C6,$06,$80,$C2,$0C,$C4,$09,$C2,$03,$BF,$0C
		dc.b $80,$60,$80,$3C,$80,$60,$EF,$1B,$E6,$FB,$E0,$C0
		dc.b $E8,$06,$C4,$06,$06,$C6,$C9,$C9,$C6,$E8,$00,$CD
		dc.b $0C,$E8,$06,$C9,$06,$C6,$C9,$0C,$80,$80,$12,$EF
		dc.b $1C,$E8,$00,$BD,$BA,$0C,$E8,$06,$EF,$1B,$CE,$06
		dc.b $CE,$80,$CE,$80,$CE,$E8,$00,$CF,$0C,$D0,$80,$E8
		dc.b $06,$D0,$06,$06,$D2,$D0,$E8,$00,$CD,$0C,$E8,$06
		dc.b $C9,$06,$C6,$C9,$0C,$E8,$00,$EF,$1C,$80,$1E,$C2
		dc.b $0C,$C2,$BD,$06,$80,$60,$80,$60,$EF,$00,$E9,$18
		dc.b $80,$60,$80,$0C,$AC,$06,$AE,$B1,$80,$12,$AC,$06
		dc.b $AE,$B1,$80,$B4,$B1,$80,$B1,$80,$60,$80,$06,$AF
		dc.b $12,$AE,$06,$80,$12,$AF,$06,$80,$AE,$80,$AF,$B1
		dc.b $80,$B1,$80,$60,$EF,$22,$E9,$DC,$E6,$FF,$E0,$80
		dc.b $80,$60,$F8
		dc.w z80_ptr(MusCreditsE004)
		dc.b $CD,$30,$CB,$18,$CD,$0C,$CB,$C9,$30,$CE,$F8
		dc.w z80_ptr(MusCreditsE051)
		dc.b $E6,$04,$F8
		dc.w z80_ptr(MusCreditsE051)
		dc.b $E6,$FC,$80,$C4,$80,$C4,$80,$C6,$18,$08,$C4,$04
		dc.b $E9,$0C,$E6,$FF,$E0,$C0,$EF,$00,$80,$60
-		dc.b $F8
		dc.w z80_ptr(MusCreditsE05B)
		dc.b $CB,$12,$CB,$1E,$F8
		dc.w z80_ptr(MusCreditsE05B)
		dc.b $D0,$12,$D0,$1E
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $80,$0C,$CB,$12,$80,$06,$CB,$80,$CA,$12,$CB,$CA
		dc.b $0C,$C5,$18,$C8,$CB,$D1,$80,$0C,$CD,$80,$CD,$12
		dc.b $CC,$CD,$06,$80,$E6,$F8,$EF,$01,$E1,$03,$A2,$6C
		dc.b $F2
MusCreditsDFF2:	dc.b $80,$60,$BC,$06,$BD,$BC,$B8,$BA,$B6,$0C,$B8,$B3
		dc.b $B3,$06,$B6,$0C,$B8,$E3
MusCreditsE004:	dc.b $80,$0C,$CD,$04,$80,$10,$CD,$04,$80,$0C,$CD,$0C
		dc.b $CE,$08,$CD,$04,$80,$18,$80,$0C,$CB,$04,$80,$10
		dc.b $CB,$04,$80,$0C,$CB,$0C,$CD,$08,$CB,$04,$80,$18
-		dc.b $80,$0C,$C9,$04,$80,$10,$C9,$04,$80,$0C,$C9,$0C
		dc.b $CB,$08,$C9,$04,$80,$18
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $E3
MusCreditsE040:	dc.b $80,$18,$B8,$0B,$80,$0D,$BA,$0C,$0B,$80,$19,$BD
		dc.b $0C,$0B,$80,$0D,$E3
MusCreditsE051:	dc.b $80,$0C,$C4,$80,$C4,$80,$C6,$80,$C6,$E3
MusCreditsE05B:	dc.b $CD,$06,$80,$CD,$80,$CA,$80,$CA,$80,$E3
MusCreditsE065:	dc.b $EF,$05,$E9,$F4,$C6,$60,$CB,$CD,$E7,$CD,$C6,$60
		dc.b $D0,$D0,$24,$D2,$60,$E7,$3C,$E3
MusCred_FM4:	dc.b $80,$60,$E9,$FB,$E6,$FE,$F8
		dc.w z80_ptr(MusCreditsE065)
		dc.b $E9,$1D,$E6,$02,$EF,$02,$F8
		dc.w z80_ptr(MusCreditsE2AE)
		dc.b $B5,$3C,$F8
		dc.w z80_ptr(MusCreditsE2AE)
		dc.b $B8,$3C,$E6,$06,$EF,$05
		dc.b $F0,$02,$01,$FE,$04
-		dc.b $C1,$30,$E7,$30,$C3,$E7,$30,$BF,$E7,$30,$BD,$E7
		dc.b $30
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $EF,$0A,$E9,$F4,$E6,$F7
		dc.b $F0,$0C,$01,$FB,$04
-		dc.b $F8
		dc.w z80_ptr(MusCreditsE2BF)
		dc.b $80,$25,$C3,$06,$C3,$80,$0C,$C3,$06,$C3,$05,$80
		dc.b $0D,$C3,$06,$C5,$30,$E7,$06,$F8
		dc.w z80_ptr(MusCreditsE2BF)
		dc.b $80,$31,$80,$60
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $80,$60,$80,$48,$EF,$0C,$E6,$05,$F4,$E1,$02,$E0
		dc.b $80,$F8
		dc.w z80_ptr(MusCreditsDD9D)
		dc.b $24,$80,$0C,$80,$60,$EF,$10,$E6,$F7,$E1,$00,$E0
		dc.b $40,$F8
		dc.w z80_ptr(MusCreditsE2D2)
		dc.b $B3,$B7,$06,$AE,$0C,$B1,$B3,$B7,$06,$80,$B7,$AE
		dc.b $0C,$B1,$F8
		dc.w z80_ptr(MusCreditsE2D2)
		dc.b $EF,$15,$E6,$01,$F8
		dc.w z80_ptr(MusCreditsE22D)
-		dc.b $EF,$14,$80,$4E,$E0,$40,$A1,$12,$A2,$06,$E0,$C0
		dc.b $EF,$16,$80,$30,$80,$06,$BA,$08,$B9,$04,$B8,$08
		dc.b $B7,$04,$B6,$08,$B5,$04
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $80,$60,$EF,$17,$E9,$F4,$E6,$02,$E0,$C0
		dc.b $F0,$01,$01,$03,$03
-		dc.b $F8
		dc.w z80_ptr(MusCreditsDDD5)
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $80,$60,$EF,$1E,$E0,$40,$E6,$FE,$E9,$F4,$F4,$E8
		dc.b $06,$80,$0C,$C1,$06,$12,$18,$C4,$06,$12,$0C,$EF
		dc.b $1C,$E0,$C0,$E6,$FA,$E8,$00,$C6,$E8,$06,$E6,$06
		dc.b $EF,$1E,$E0,$40,$C2,$06,$12,$18,$C4,$06,$12,$18
		dc.b $C1,$06,$12,$18,$C4,$06,$12,$0C,$EF,$1A,$E0,$C0
		dc.b $E9,$0C,$C6,$06,$C6,$80,$C6,$80,$C6,$E8,$00,$C7
		dc.b $0C,$C8,$06,$EF,$1E,$E0,$40,$E9,$F4,$E8,$06,$80
		dc.b $C4,$06,$12,$0C,$80,$60,$EF,$20,$E9,$18,$E6,$FA
		dc.b $E0,$C0,$E8,$00,$B4,$03,$E7,$B6,$5D,$B3,$03,$E7
		dc.b $B5,$5D,$B1,$03,$E7,$B3,$5D,$B3,$03,$E7,$B5,$5D
		dc.b $80,$60,$EF,$22,$E0,$40,$E9,$E8,$E6,$04,$80,$30
		dc.b $80,$F8
		dc.w z80_ptr(MusCreditsE246)
		dc.b $C9,$30,$C8,$18,$C9,$0C,$C8,$C6,$30,$C9,$80,$0C
		dc.b $C1,$80,$C1,$80,$C2,$80,$C2,$E6,$04,$80,$C1,$80
		dc.b $C1,$80,$C2,$80,$C2,$E6,$FC,$80,$C1,$80,$C1,$80
		dc.b $C2,$18,$08,$C1,$04,$E9,$0C,$E6,$FF,$E0,$C0,$EF
		dc.b $00,$80,$60
-		dc.b $F8
		dc.w z80_ptr(MusCreditsE2C8)
		dc.b $C8,$12,$C8,$1E,$F8
		dc.w z80_ptr(MusCreditsE2C8)
		dc.b $CB,$12,$CB,$1E
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $E1,$03,$E6,$08,$F8
		dc.w z80_ptr(MusCreditsE28F)
		dc.b $E6,$F0,$EF,$01
		dc.b $F0,$00,$01,$06,$04
		dc.b $A2,$6C,$F2
MusCreditsE22D:	dc.b $A2,$14,$A4,$04,$A5,$04,$80,$08,$A9,$04,$80,$08
		dc.b $A8,$04,$80,$08,$A9,$04,$80,$08,$AC,$08,$A9,$10
		dc.b $E3
MusCreditsE246:	dc.b $80,$0C
		dc.b $C9,$04,$80,$10
		dc.b $C9,$04,$80,$0C
		dc.b $C9,$0C
		dc.b $CB,$08
		dc.b $C9,$04,$80,$18,$80,$0C
		dc.b $C8,$04,$80,$10
		dc.b $C8,$04,$80,$0C
		dc.b $C8,$0C
		dc.b $C9,$08
		dc.b $C8,$04,$80,$18,$80,$0C

    if 1==1
		; this part of the original credits music (CNZ PSG) sounds buggy (dissonant)
		dc.b $C6,$04,$80,$10
		dc.b $C6,$04,$80,$0C
		dc.b $C6,$0C
		dc.b $C8,$08
		dc.b $C6,$04,$80,$18,$80,$0C
		dc.b $C5,$04,$80,$10
		dc.b $C5,$04,$80,$0C
		dc.b $C5,$0C
		dc.b $C7,$08
    else
		; replace the above block of notes with this to fix it.
		; (I'm not sure why, but the notes $C6 and $C7 are broken here,
		;  so I've replaced them with pitch-shifted $C8s)
		dc.b	$E1,-64
		dc.b $C8,$04,$80,$10 ; $C6
		dc.b $C8,$04,$80,$0C ; $C6
		dc.b $C8,$0C ; $C6
		dc.b	$E1,0
		dc.b $C8,$08
		dc.b	$E1,-64
		dc.b $C8,$04,$80,$24 ; $C6
		dc.b	$E1,0
		dc.b $C5,$04,$80,$10
		dc.b $C5,$04,$80,$0C
		dc.b $C5,$0C
		dc.b	$E1,-32
		dc.b $C8,$08 ; $C7
		dc.b	$E1,0
    endif

		dc.b $C5,$04,$80,$18
		dc.b $E3
MusCreditsE28F:	dc.b $EF,$25,$80,$0C,$D0,$D4,$D7,$DB,$0C,$80,$06,$DB
		dc.b $0C,$DC,$06,$DB,$0C,$DD,$60,$DE,$0C,$80,$DE,$80
		dc.b $80,$06,$DD,$12,$DE,$0C,$E3
MusCreditsE2AE:	dc.b $80,$18,$B5,$0B,$80,$0D,$B7,$0C,$0B,$80,$19,$BA
		dc.b $0C,$0B,$80,$0D,$E3
MusCreditsE2BF:	dc.b $C3,$05,$80,$13,$C3,$12,$C3,$05,$E3
MusCreditsE2C8:	dc.b $CA,$06,$80,$CA,$80,$C6,$80,$C6,$80,$E3
MusCreditsE2D2:	dc.b $AF,$0C,$B3,$06,$B6,$0C,$AF,$B1,$06,$80,$B1,$0C
		dc.b $B5,$06,$B8,$0C,$B1,$06,$80,$B6,$0C,$BA,$06,$B1
		dc.b $0C,$B5,$B6,$BA,$06,$80,$BA,$AF,$0C,$B3,$B5,$B8
		dc.b $06,$B2,$0C,$B3,$B5,$B8,$06,$80,$B8,$B2,$0C,$B5
		dc.b $E3
MusCred_FM5:	dc.b $E9,$E8,$E6,$F8,$E1,$05,$F8
		dc.w z80_ptr(MusCreditsDB06)
		dc.b $E9,$18,$E6,$08,$E1,$00,$EF,$02
		dc.b $F0,$0C,$01,$FC,$04
		dc.b $F8
		dc.w z80_ptr(MusCreditsE4E8)
		dc.b $B1,$3C,$F8
		dc.w z80_ptr(MusCreditsE4E8)
		dc.b $B5,$3C,$E9,$F4,$E6,$07
		dc.b $F0,$30,$01,$04,$04
		dc.b $EF,$06
-		dc.b $C4,$30,$E7,$30,$C6,$E7,$30,$C2,$E7,$30,$C1,$E7
		dc.b $30
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $EF,$0A,$E6,$F6
		dc.b $F0,$0C,$01,$05,$04
		dc.b $E0,$80
-		dc.b $F8
		dc.w z80_ptr(MusCreditsE4F9)
		dc.b $80,$25,$C6,$06,$C6,$80,$0C,$C6,$06,$C6,$05,$80
		dc.b $0D,$C6,$06,$C8,$30,$E7,$06,$F8
		dc.w z80_ptr(MusCreditsE4F9)
		dc.b $80,$31,$80,$60
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $80,$60,$80,$48,$E6,$05,$F4,$80,$01,$EF,$0C,$E1
		dc.b $FE,$E0,$40,$F8
		dc.w z80_ptr(MusCreditsDD9D)
		dc.b $23,$80,$0C,$80,$60,$EF,$11,$E9,$F4,$E6,$F4,$E1
		dc.b $00,$E0,$C0
		dc.b $F0,$06,$01,$06,$05
		dc.b $80,$60,$80,$30,$C2,$06,$C2,$C9,$C6,$1E,$80,$60
		dc.b $80,$06,$CB,$80,$CB,$C9,$80,$C9,$80,$C7,$80,$C7
		dc.b $80,$C6,$03,$80,$C6,$80,$09,$80,$06,$80,$60,$80
		dc.b $30,$C2,$06,$C2,$C9,$C6,$1E,$80,$60,$EF,$16,$E9
		dc.b $0C,$E6,$04,$F4,$E0,$80,$80,$01,$F8
		dc.w z80_ptr(MusCreditsE22D)
		dc.b $80,$2F,$F8
		dc.w z80_ptr(MusCreditsE4CD)
		dc.b $80,$30,$F8
		dc.w z80_ptr(MusCreditsE4CD)
		dc.b $80,$60,$EF,$19,$E9,$F4,$E0,$C0,$F8
		dc.w z80_ptr(MusCreditsE502)
		dc.b $80,$27,$B1,$03,$F8
		dc.w z80_ptr(MusCreditsE502)
		dc.b $80,$2A,$80,$60,$EF,$1E,$E9,$F4,$E8,$06
-		dc.b $80,$0C,$C4,$06,$12,$18,$C8,$06,$12,$0C,$80,$C6
		dc.b $06,$12,$18,$C8,$06,$12,$0C
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $80,$60,$EF,$20,$E8,$00,$E9,$18,$E6,$FA,$B8,$03
		dc.b $E7,$BA,$5D,$B6,$03,$E7,$B8,$5D,$B4,$03,$E7,$B6
		dc.b $5D,$B6,$03,$E7,$B8,$5D,$80,$60,$EF,$22,$E9,$F4
		dc.b $E6,$05
		dc.b $F0,$1C,$01,$06,$04
		dc.b $80,$50,$A7,$04,$A9,$08,$AC,$04,$B1,$30,$80,$0C
		dc.b $B1,$08,$80,$04,$B3,$08,$B1,$10,$B5,$08,$B5,$04
		dc.b $80,$08,$B0,$34,$80,$0C,$B0,$B5,$08,$04,$80,$08
		dc.b $B1,$04,$AE,$24,$80,$0C,$AE,$08,$80,$04,$B0,$08
		dc.b $AE,$04,$B1,$0C,$AF,$08,$AD,$4C,$80,$0C,$B1,$08
		dc.b $80,$04,$B3,$08,$80,$04,$B1,$08,$80,$04,$B5,$08
		dc.b $B5,$04,$80,$08,$B0,$1C,$80,$0C,$B5,$18,$B8,$08
		dc.b $B5,$04,$BA,$18,$80,$0C,$B6,$04,$80,$08,$B5,$18
		dc.b $B1,$AE,$B0,$0C,$E6,$04,$B6,$04,$80,$08,$B5,$18
		dc.b $B1,$AE,$B0,$0C,$E6,$F8,$B6,$04,$80,$08,$B5,$18
		dc.b $B1,$AE,$AA,$14,$A9,$04,$E6,$0C,$EF,$23,$E1,$03
		dc.b $E6,$F7,$80,$60,$F8
		dc.w z80_ptr(MusCreditsDABE)
		dc.b $E6,$09
		dc.b $F0,$00,$01,$06,$04
		dc.b $F8
		dc.w z80_ptr(MusCreditsE28F)
		dc.b $F2
MusCreditsE4CD:	dc.b $80,$1E,$EF,$14,$A4,$12,$A5,$06,$EF,$16,$80,$30
		dc.b $80,$06,$BD,$08,$BC,$04,$BB,$08,$BA,$04,$B9,$08
		dc.b $B8,$04,$E3
MusCreditsE4E8:	dc.b $80,$18,$B1,$0B,$80,$0D,$B3,$0C,$0B,$80,$19,$B6
		dc.b $0C,$0B,$80,$0D,$E3
MusCreditsE4F9:	dc.b $C6,$05,$80,$13,$C6,$12,$C6,$05,$E3
MusCreditsE502:	dc.b $80,$60,$AC,$06,$80,$AC,$0C,$AE,$06,$80,$AE,$0C
		dc.b $AF,$06,$E3
MusCred_PSG1:	dc.b $80,$30
		dc.b $F7,$00,$1A
		dc.w z80_ptr(MusCred_PSG1)
-		dc.b $C4,$30,$E7,$30,$C6,$E7,$30,$C2,$E7,$30,$C1,$E7
		dc.b $30
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
-		dc.b $80,$30
		dc.b $F7,$00,$10
		dc.w z80_ptr(-)
		dc.b $80,$60
-		dc.b $80,$30
		dc.b $F7,$00,$0A
		dc.w z80_ptr(-)
		dc.b $80,$60,$E9,$F4,$E6,$FE,$F5,$01,$F8
		dc.w z80_ptr(MusCreditsE635)
		dc.b $AE,$B3,$06,$AC,$0C,$AE,$AE,$B3,$06,$80,$B3,$AB
		dc.b $0C,$AE,$F8
		dc.w z80_ptr(MusCreditsE635)
		dc.b $F5,$0B,$80,$04,$80,$60,$F8
		dc.w z80_ptr(MusCreditsDA5F)
		dc.b $E7,$20,$E7,$C5,$01,$E7,$C4,$E7,$C3,$E7,$C2,$E7
		dc.b $C1,$E7,$C0,$E7,$BF,$E7,$BE,$E7,$BD,$E7,$BC,$E7
		dc.b $BB,$E7,$BA,$80,$60,$F5,$00,$E8,$06,$E9,$F4,$F8
		dc.w z80_ptr(MusCreditsE62C)
		dc.b $C2,$80,$C2,$F8
		dc.w z80_ptr(MusCreditsE62C)
		dc.b $C2,$04,$80,$C2,$80,$0C,$C2,$80,$60,$F5,$08,$E9
		dc.b $04,$EC,$02,$E8,$06
-		dc.b $F8
		dc.w z80_ptr(MusCreditsE618)
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
-		dc.b $80,$30
		dc.b $F7,$00,$0A
		dc.w z80_ptr(-)
		dc.b $80,$60,$F5,$00,$E9,$F0,$EC,$FF,$80,$60
		dc.b $F8
		dc.w z80_ptr(MusCreditsE004)
		dc.b $E9,$18,$EC,$02,$B5,$30,$B3,$18,$B5,$0C,$B3,$B1
		dc.b $30,$B6,$EC,$FE,$80,$0C,$B8,$80,$B8,$80,$BA,$80
		dc.b $BA,$EC,$03,$C4,$18,$C1,$BD,$BF,$0C,$80,$EC,$FC
		dc.b $80,$B8,$80,$B8,$80,$BA,$18,$08,$B8,$04,$E9,$F4
		dc.b $EC,$01,$F5,$05
-		dc.b $80,$60
		dc.b $F7,$00,$05
		dc.w z80_ptr(-)
		dc.b $80,$0C,$C8,$12,$80,$06,$C8,$80,$C6,$12,$C8,$C6
		dc.b $0C,$C1,$18,$C5,$C8,$CB,$80,$0C,$CA,$80,$CA,$12
		dc.b $C9,$CA,$06,$80,$09,$E9,$30,$EC,$FC,$F6
		dc.w z80_ptr(MusCreditsE770)
		dc.b $F2
MusCreditsE618:	dc.b $80,$0C,$BD,$06,$12,$18,$C4,$06,$12,$0C,$80,$C2
		dc.b $06,$12,$18,$C4,$06,$12,$0C,$E3
MusCreditsE62C:	dc.b $80,$60,$80,$0C,$C2,$80,$C2,$80,$E3
MusCreditsE635:	dc.b $AC,$0C,$AF,$06,$B3,$0C,$AC,$AC,$06,$80,$AC,$0C
		dc.b $AF,$06,$B5,$0C,$AC,$06,$80,$06,$B1,$0C,$B6,$06
		dc.b $AE,$0C,$B1,$B3,$B6,$06,$80,$B6,$AA,$0C,$AF,$AF
		dc.b $B5,$06,$AC,$0C,$AF,$B2,$B5,$06,$80,$B5,$AE,$0C
		dc.b $B2,$E3
MusCred_PSG2:	dc.b $80,$30
		dc.b $F7,$00,$1A
		dc.w z80_ptr(MusCred_PSG2)
-		dc.b $C1,$30,$E7,$30,$C3,$E7,$30,$BF,$E7,$30,$BD,$E7
		dc.b $30
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
-		dc.b $80,$30
		dc.b $F7,$00,$10
		dc.w z80_ptr(-)
		dc.b $80,$60,$E9,$0C,$EC,$FD,$F5,$04,$80
-		dc.b $F8
		dc.w z80_ptr(MusCreditsDFF2)
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
		dc.b $80,$60
		dc.b $F0,$03,$02,$01,$05
		dc.b $F5,$0A,$E9,$E8,$EC,$02,$80,$30,$80,$80,$BD,$06
		dc.b $BF,$C6,$C2,$1E,$80,$60,$80,$06,$C6,$80,$C6,$C4
		dc.b $80,$C4,$80,$C3,$80,$C3,$80,$BF,$03,$80,$BF,$80
		dc.b $09,$80,$06,$80,$30,$80,$80,$BD,$06,$BF,$C6,$C2
		dc.b $1E,$80,$60,$F4
-		dc.b $80,$30
		dc.b $F7,$00,$0C
		dc.w z80_ptr(-)
		dc.b $F5,$00,$EC,$FE,$E8,$06,$80,$60,$80,$0C,$BF,$80
		dc.b $BF,$80,$BF,$80,$BF,$80,$60,$80,$0C,$BF,$80,$BF
		dc.b $80,$BF,$04,$80,$BF,$80,$0C,$BF,$80,$60,$EC,$02
-		dc.b $F8
		dc.w z80_ptr(MusCreditsE618)
		dc.b $F7,$00,$02
		dc.w z80_ptr(-)
-		dc.b $80,$30
		dc.b $F7,$00,$0A
		dc.w z80_ptr(-)
		dc.b $80,$60,$F5,$00,$E9,$F4,$EC,$FF,$E9,$E8,$80,$60
		dc.b $F8
		dc.w z80_ptr(MusCreditsE246)
		dc.b $E9,$18,$EC,$02,$B1,$30,$B0,$18,$B1,$0C,$B0,$AE
		dc.b $30,$B1,$EC,$FE,$80,$0C,$B5,$80,$B5,$80,$B6,$80
		dc.b $B6,$EC,$03,$80,$B1,$80,$B1,$80,$B1,$80,$B1,$EC
		dc.b $FC,$80,$B1,$80,$B1,$80,$B1,$18,$08,$B1,$04,$EC
		dc.b $01,$E9,$18,$F5,$05,$E1,$01,$80,$60,$80,$80,$80
		dc.b $80,$80,$80,$0C,$CD,$06,$80,$D4,$CD,$80,$0C,$CD
		dc.b $06,$80,$D4,$CD,$80,$18,$80,$54,$E9,$24,$EC,$FD
MusCreditsE770:	dc.b $F5,$03,$80,$06
-		dc.b $BF,$03,$C1,$C3,$EC,$01,$E9,$FF
		dc.b $F7,$00,$05
		dc.w z80_ptr(-)
-		dc.b $BF,$03,$C1,$C3,$EC,$01,$E9,$01
		dc.b $F7,$00,$07
		dc.w z80_ptr(-)
		dc.b $F2
MusCred_PSG3:	dc.b $F3,$E7,$80,$60,$F5,$02
-		dc.b $C6,$0C,$0C,$0C,$06,$06,$0C,$0C,$06,$06,$0C
		dc.b $F7,$00,$08
		dc.w z80_ptr(-)
-		dc.b $80,$30
		dc.b $F7,$00,$08
		dc.w z80_ptr(-)
-		dc.b $C6,$0C,$06,$06
		dc.b $F7,$00,$1F
		dc.w z80_ptr(-)
		dc.b $0C,$F5,$03,$C6,$F5,$02
-		dc.b $C6,$0C,$06,$06
		dc.b $F7,$00,$07
		dc.w z80_ptr(-)
		dc.b $06,$06,$06,$06
		dc.b $F7,$01,$04
		dc.w z80_ptr(-)
-		dc.b $80,$30
		dc.b $F7,$00,$0C
		dc.w z80_ptr(-)
		dc.b $F5,$04,$EC,$02
-		dc.b $E8,$03,$C6,$06,$06,$E8,$00,$0C
		dc.b $F7,$00,$04
		dc.w z80_ptr(-)
		dc.b $F5,$02,$EC,$FD
-		dc.b $80,$0C,$C6,$06,$80,$07,$C6,$06,$80,$11,$C6,$0C
		dc.b $80,$06,$C6,$0C,$80,$06,$C6,$80
		dc.b $F7,$00,$07
		dc.w z80_ptr(-)
		dc.b $EC,$02
-		dc.b $C6,$0C,$08,$04
		dc.b $F7,$00,$18
		dc.w z80_ptr(-)
-		dc.b $C6,$0C,$0C,$0C,$08,$04
		dc.b $F7,$00,$08
		dc.w z80_ptr(-)
		dc.b $80,$60,$F5,$04,$EC,$02
-		dc.b $C6,$06,$06,$0C
		dc.b $F7,$00,$10
		dc.w z80_ptr(-)
-		dc.b $80,$30
		dc.b $F7,$00,$0A
		dc.w z80_ptr(-)
		dc.b $80,$60,$EC,$FF
-		dc.b $F5,$01,$C6,$0C,$F5,$02,$EC,$FF,$08,$F5,$01,$EC
		dc.b $01,$04
		dc.b $F7,$00,$27
		dc.w z80_ptr(-)
		dc.b $EC,$FF,$F5,$04
-		dc.b $E8,$03,$C6,$0C,$E8,$0C,$0C
		dc.b $F7,$00,$1E
		dc.w z80_ptr(-)
		dc.b $E8,$03,$C6,$06,$E8,$0E,$12,$E8,$03,$0C,$E8,$0F
		dc.b $0C,$F2
MusCred_DAC:	dc.b $82,$06,$82,$82,$82,$82,$0C,$06,$0C,$06,$0C,$0C
		dc.b $0C
-		dc.b $81,$18,$82
		dc.b $F7,$00,$0E
		dc.w z80_ptr(-)
		dc.b $81,$0C
-		dc.b $82
		dc.b $F7,$00,$07
		dc.w z80_ptr(-)
		dc.b $EA,$EA,$F8
		dc.w z80_ptr(MusCreditsEA6E)
		dc.b $81,$0C,$8D,$82,$81,$81,$8E,$82,$84,$04,$06,$02
		dc.b $81,$0C,$82,$06,$82,$82,$82,$81,$0C,$82,$06,$82
		dc.b $81,$81,$82,$82,$82,$82
-		dc.b $81,$18,$82,$81,$82
		dc.b $F7,$00,$07
		dc.w z80_ptr(-)
		dc.b $81,$0C,$82,$82,$82,$82,$06,$82,$8C,$8C,$8D,$8D
		dc.b $8E,$8E,$F8
		dc.w z80_ptr(MusCreditsEA84)
		dc.b $81,$18,$82,$0C,$81,$18,$82,$0C,$82,$82,$06,$82
		dc.b $F8
		dc.w z80_ptr(MusCreditsEA84)
		dc.b $81,$0C,$82,$82,$82,$8D,$06,$8D,$8E,$8E,$82,$06
		dc.b $82,$8D,$0C,$82,$0C,$82,$06,$82,$80,$82,$82,$0C
MusCreditsE8E5:	dc.b $82,$0C,$82,$82,$06,$82,$8D,$8D
-		dc.b $81,$0C,$8F,$06,$90,$82,$0C,$90,$06,$91,$81,$0C
		dc.b $8F,$06,$91,$82,$0C,$8F,$06,$91
		dc.b $F7,$00,$04
		dc.w z80_ptr(-)
		dc.b $81,$0C,$8F,$06,$91,$82,$0C,$8F,$06,$91,$8C,$06
		dc.b $03,$03,$8D,$06,$8D,$8D,$8E,$8E,$8E,$81,$06,$0C
		dc.b $82,$06,$80,$0C,$81,$82,$8E,$82,$06,$82,$82,$82
-		dc.b $81,$0C,$82,$06,$81,$12,$81,$06,$81,$12,$8C,$06
		dc.b $82,$0C,$83,$06,$81,$80
		dc.b $F7,$00,$06
		dc.w z80_ptr(-)
		dc.b $81,$0C,$82,$06,$81,$12,$81,$06,$81,$06,$82,$06
		dc.b $81,$0C,$06,$82,$0C,$08,$04,$EA,$CD,$82,$30,$82
		dc.b $0C,$82,$82,$82,$08,$04,$F8
		dc.w z80_ptr(MusCreditsEA9F)
		dc.b $F8
		dc.w z80_ptr(MusCreditsEA9F)
		dc.b $81,$08,$0C,$04,$82,$0C,$81,$08,$04,$82,$08,$04
		dc.b $08,$04,$04,$04,$04,$08,$04,$EA,$C5
-		dc.b $81,$09,$81,$03,$0C,$82,$81,$81,$18,$82
		dc.b $F7,$00,$03
		dc.w z80_ptr(-)
		dc.b $81,$09,$81,$03,$0C,$82,$81,$81,$18,$82,$0C,$06
		dc.b $06,$81,$0C,$82,$06,$82,$82,$82,$8D,$0C,$82,$0C
		dc.b $0C,$0C,$06,$06
-		dc.b $81,$0C,$81,$82,$80,$81,$81,$82,$83
		dc.b $F7,$00,$03
		dc.w z80_ptr(-)
		dc.b $81,$82,$82,$82,$82,$06,$06,$06,$06,$0C,$06,$06
		dc.b $81,$06,$81,$82,$82,$81,$82,$81,$81,$82,$02,$82
		dc.b $04,$81,$0C,$06,$82,$0C,$06,$06,$81,$18,$82,$0C
		dc.b $81,$81,$18,$82,$81,$06,$81,$12,$82,$0C,$81,$81
		dc.b $18,$82,$81,$18,$82,$0C,$81,$81,$18,$82,$81,$06
		dc.b $81,$12,$82,$0C,$0C,$06,$06,$06,$06,$0C,$06,$06
		dc.b $82,$02,$04,$81,$0C,$06,$0C,$82,$02,$04,$81,$0C
		dc.b $06,$0C,$82,$06,$82,$82,$82,$EA,$C0,$81,$0C,$82
		dc.b $81,$82,$81,$82,$81,$08,$82,$04,$0C
-		dc.b $81,$0C,$82
		dc.b $F7,$00,$0F
		dc.w z80_ptr(-)
		dc.b $81,$08,$82,$04,$0C
-		dc.b $81,$0C,$82
		dc.b $F7,$00,$13
		dc.w z80_ptr(-)
		dc.b $82,$08,$0C,$04,$81,$0C,$82,$81,$82,$81,$0C,$82
		dc.b $81,$06,$80,$02,$82,$82,$82,$09,$82,$03
-		dc.b $81,$0C,$82
		dc.b $F7,$00,$06
		dc.w z80_ptr(-)
		dc.b $81,$0C,$82,$81,$06,$80,$02,$82,$82,$82,$09,$82
		dc.b $03
		dc.b $F7,$01,$03
		dc.w z80_ptr(-)
		dc.b $81,$0C,$82,$81,$82,$81,$06,$82,$12,$82,$0C,$81
		dc.b $F2
MusCreditsEA6E:	dc.b $81,$0C,$8D,$82,$81,$81,$8E,$82,$84,$04,$06,$02
		dc.b $81,$0C,$8D,$82,$81,$81,$8E,$82,$83,$E3
MusCreditsEA84:	dc.b $81,$18,$82,$0C,$81,$18,$0C,$82,$81,$81,$18,$82
		dc.b $0C,$81,$12,$81,$82,$18,$81,$82,$0C,$81,$18,$0C
		dc.b $82,$81,$E3
MusCreditsEA9F:	dc.b $81,$08,$0C,$04,$82,$0C,$81,$08,$0C,$82,$04,$81
		dc.b $0C,$82,$81,$81,$08,$0C,$04,$82,$0C,$81,$08,$0C
		dc.b $82,$04,$81,$0C,$82,$82,$08,$04,$E3,$81,$06,$80
		dc.b $03,$81,$81,$06,$82,$81,$06,$80,$03,$81,$81,$06
		dc.b $82,$03,$82,$81,$06,$80,$03,$81,$81,$06,$82,$E3
MusCred_Voices:	dc.b $3A,$01,$01,$07,$01,$8E,$8D,$8E,$53,$0E,$0E,$0E
		dc.b $03,$00,$00,$00,$01,$1F,$1F,$FF,$0F,$17,$27,$28,$80
		dc.b $08,$09,$30,$70,$00,$1F,$5F,$1F,$5F,$12,$0A,$0E
		dc.b $0A,$00,$04,$04,$03,$2F,$2F,$2F,$2F,$25,$0E,$30,$84
		dc.b $3C,$31,$50,$52,$30,$52,$52,$53,$53,$08,$08,$00
		dc.b $00,$04,$04,$00,$00,$10,$10,$0B,$0D,$19,$0B,$80,$80
		dc.b $08,$0A,$30,$70,$00,$1F,$5F,$1F,$5F,$12,$0A,$0E
		dc.b $0A,$00,$04,$04,$03,$2F,$2F,$2F,$2F,$24,$13,$2D,$80
		dc.b $3D,$01,$51,$21,$01,$12,$14,$14,$0F,$0A,$05,$05
		dc.b $05,$00,$00,$00,$00,$2B,$2B,$2B,$1B,$19,$80,$80,$80
		dc.b $04,$57,$70,$02,$50,$1F,$1F,$1F,$1F,$00,$00,$00
		dc.b $00,$06,$00,$0A,$0A,$00,$00,$0F,$0F,$1A,$10,$80,$80
		dc.b $35,$01,$13,$01,$00,$1F,$18,$1D,$19,$00,$06,$09
		dc.b $0D,$00,$02,$00,$03,$00,$15,$06,$16,$1E,$83,$80,$80
		dc.b $3C,$31,$50,$52,$30,$52,$52,$53,$53,$08,$08,$00
		dc.b $00,$04,$04,$00,$00,$1F,$1F,$0F,$0F,$1A,$16,$88,$88
		dc.b $20,$36,$30,$35,$31,$DF,$9F,$DF,$9F,$07,$09,$06
		dc.b $06,$07,$06,$06,$08,$2F,$1F,$1F,$FF,$14,$0F,$37,$80
		dc.b $3B,$0F,$01,$06,$02,$DF,$1F,$1F,$DF,$0C,$0A,$00
		dc.b $03,$0F,$00,$00,$01,$F3,$55,$05,$5C,$22,$22,$20,$80
		dc.b $3C,$31,$50,$52,$30,$52,$52,$53,$53,$08,$08,$00
		dc.b $00,$04,$04,$00,$00,$1F,$1F,$0F,$0F,$1C,$14,$84,$80
		dc.b $3A,$69,$50,$70,$60,$1C,$1A,$18,$18,$10,$02,$0C
		dc.b $09,$08,$06,$06,$03,$F9,$06,$56,$06,$28,$14,$15,$00
		dc.b $3D,$00,$02,$01,$01,$4C,$50,$0F,$12,$0C,$00,$02
		dc.b $05,$01,$00,$00,$00,$28,$2A,$29,$19,$1A,$06,$00,$00
		dc.b $2C,$71,$31,$71,$31,$1F,$1F,$16,$16,$00,$00,$0F
		dc.b $0F,$00,$00,$0F,$0F,$00,$00,$FA,$FA,$15,$14,$00,$00
		dc.b $18,$37,$31,$32,$31,$9E,$1C,$DC,$9C,$0D,$04,$06
		dc.b $01,$08,$03,$0A,$05,$B6,$36,$B6,$28,$2C,$14,$22,$00
		dc.b $3D,$01,$02,$02,$02,$10,$50,$50,$50,$07,$08,$08
		dc.b $08,$01,$00,$00,$00,$24,$18,$18,$18,$1C,$82,$82,$82
		dc.b $32,$71,$33,$0D,$01,$5F,$5F,$99,$94,$05,$05,$05
		dc.b $07,$02,$02,$02,$02,$11,$11,$11,$72,$23,$26,$2D,$80
		dc.b $3A,$32,$52,$01,$31,$1F,$1F,$1F,$18,$01,$00,$1F
		dc.b $00,$00,$00,$0F,$00,$5A,$03,$0F,$1A,$3B,$4F,$30,$00
		dc.b $3C,$42,$32,$41,$41,$12,$12,$12,$12,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$06,$06,$08,$08,$24,$24,$08,$08
		dc.b $31,$34,$30,$35,$31,$DF,$9F,$DF,$9F,$0C,$0C,$07
		dc.b $09,$07,$07,$07,$08,$2F,$1F,$1F,$2F,$17,$14,$32,$80
		dc.b $3D,$01,$01,$01,$01,$10,$50,$50,$50,$07,$08,$08
		dc.b $08,$01,$00,$00,$00,$20,$1A,$1A,$1A,$19,$84,$84,$84
		dc.b $24,$70,$30,$74,$38,$12,$1F,$1F,$1F,$05,$05,$03
		dc.b $03,$05,$05,$03,$03,$36,$26,$2C,$2C,$0A,$06,$08,$08
		dc.b $3A,$01,$01,$01,$02,$8D,$07,$07,$52,$09,$00,$00
		dc.b $03,$01,$02,$02,$00,$5F,$0F,$0F,$2F,$18,$18,$22,$80
		dc.b $3A,$01,$01,$07,$01,$8E,$8D,$8E,$53,$0E,$0E,$0E
		dc.b $03,$00,$00,$00,$00,$1F,$1F,$FF,$0F,$18,$16,$4E,$80
		dc.b $3A,$03,$03,$08,$01,$8E,$8D,$8E,$53,$0E,$0E,$0E
		dc.b $03,$00,$00,$00,$00,$1F,$1F,$FF,$0F,$17,$20,$28,$80
		dc.b $20,$7A,$00,$31,$00,$9F,$DC,$D8,$DF,$10,$04,$0A
		dc.b $04,$0F,$08,$08,$08,$5F,$BF,$5F,$BF,$14,$17,$2B,$80
		dc.b $3A,$61,$51,$08,$02,$5D,$5D,$5D,$50,$04,$1F,$0F
		dc.b $1F,$00,$00,$00,$00,$1F,$0F,$5F,$0F,$22,$22,$1E,$80
		dc.b $02,$01,$02,$55,$04,$92,$8E,$8D,$54,$0D,$00,$0C
		dc.b $03,$00,$00,$00,$00,$FF,$0F,$2F,$5F,$16,$1D,$2A,$80
		dc.b $02,$75,$73,$71,$31,$1F,$96,$58,$9F,$01,$03,$1B
		dc.b $08,$01,$01,$04,$05,$FF,$3F,$2F,$2F,$24,$30,$29,$80
		dc.b $20,$66,$60,$65,$60,$DF,$9F,$DF,$1F,$00,$09,$06
		dc.b $0C,$07,$06,$06,$08,$2F,$1F,$1F,$FF,$1C,$16,$3A,$80
		dc.b $0D,$32,$06,$08,$01,$1F,$19,$19,$19,$0A,$05,$05
		dc.b $05,$00,$02,$02,$02,$3F,$2F,$2F,$2F,$28,$86,$80,$8D
		dc.b $38,$3A,$11,$0A,$02,$D4,$50,$14,$0E,$05,$02,$08
		dc.b $88,$00,$00,$00,$00,$99,$09,$09,$1A,$2D,$19,$2C,$86
		dc.b $0D,$32,$02,$04,$01,$1F,$19,$19,$19,$0A,$05,$05
		dc.b $05,$00,$02,$02,$02,$3F,$2F,$2F,$2F,$28,$8B,$86,$93
		dc.b $3A,$20,$60,$23,$01,$1E,$1F,$1F,$1F,$0A,$0B,$0A
		dc.b $0A,$05,$0A,$07,$08,$A4,$96,$85,$78,$21,$28,$25,$00
		dc.b $3A,$32,$32,$56,$42,$8D,$15,$4F,$52,$06,$07,$08
		dc.b $04,$02,$00,$00,$00,$18,$28,$18,$28,$19,$2A,$20,$00
		dc.b $3A,$51,$51,$08,$02,$1E,$1E,$1E,$10,$1F,$1F,$1F
		dc.b $0F,$00,$00,$00,$02,$0F,$0F,$0F,$1F,$18,$22,$24,$81
		dc.b $20,$36,$30,$35,$31,$DF,$9F,$DF,$9F,$07,$09,$06
		dc.b $06,$07,$06,$06,$08,$2F,$1F,$1F,$FF,$19,$13,$37,$80
		dc.b $3D,$01,$02,$02,$02,$14,$8C,$0E,$0E,$08,$02,$05
		dc.b $05,$00,$00,$00,$00,$1F,$1F,$1F,$1F,$1A,$80,$80,$80
; end of Mus_Credits

; ------------------------------------------------------------------------------------------
; Sound effect pointers
; ------------------------------------------------------------------------------------------
; WARNING the sound driver treats certain sounds specially
; going by the ID of the sound.
; SndID_Ring, SndID_RingLeft, SndID_Gloop, SndID_SpindashRev
; are referenced by the sound driver directly.
; If needed you can change this in s2.sounddriver.asm


; NOTE: the exact order of this list determines the priority of each sound, since it determines the sound's SndID.
;       a sound can get dropped if a higher-priority sound is already playing.
;	see zSFXPriority for the priority allocation itself.
; loc_FEE91: SoundPoint:
SoundIndex:
SndPtr_Jump:		rom_ptr_z80	Sound20	; jumping sound
SndPtr_Checkpoint:	rom_ptr_z80	Sound21	; checkpoint ding-dong sound
SndPtr_SpikeSwitch:	rom_ptr_z80	Sound22	; spike switch sound
SndPtr_Hurt:		rom_ptr_z80	Sound23	; hurt sound
SndPtr_Skidding:	rom_ptr_z80	Sound24	; skidding sound
SndPtr_BlockPush:	rom_ptr_z80	Sound25	; block push sound
SndPtr_HurtBySpikes:	rom_ptr_z80	Sound26	; spiky impalement sound
SndPtr_Sparkle:		rom_ptr_z80	Sound27	; sparkling sound
SndPtr_Beep:		rom_ptr_z80	Sound28	; short beep
SndPtr_Bwoop:		rom_ptr_z80	Sound29	; bwoop (unused)
SndPtr_Splash:		rom_ptr_z80	Sound2A	; splash sound
SndPtr_Swish:		rom_ptr_z80	Sound2B	; swish
SndPtr_BossHit:		rom_ptr_z80	Sound2C	; boss hit
SndPtr_InhalingBubble:	rom_ptr_z80	Sound2D	; inhaling a bubble
SndPtr_ArrowFiring:
SndPtr_LavaBall:	rom_ptr_z80	Sound2E	; arrow firing
SndPtr_Shield:		rom_ptr_z80	Sound2F	; shield sound
SndPtr_LaserBeam:	rom_ptr_z80	Sound30	; laser beam
SndPtr_Zap:		rom_ptr_z80	Sound31	; zap (unused)
SndPtr_Drown:		rom_ptr_z80	Sound32	; drownage
SndPtr_FireBurn:	rom_ptr_z80	Sound33	; fire + burn
SndPtr_Bumper:		rom_ptr_z80	Sound34	; bumper bing
SndPtr_Ring:
SndPtr_RingRight:	rom_ptr_z80	Sound35	; ring sound
SndPtr_SpikesMove:	rom_ptr_z80	Sound36
SndPtr_Rumbling:	rom_ptr_z80	Sound37	; rumbling
			rom_ptr_z80	Sound38	; (unused)
SndPtr_Smash:		rom_ptr_z80	Sound39	; smash/breaking
			rom_ptr_z80	Sound3A	; nondescript ding (unused)
SndPtr_DoorSlam:	rom_ptr_z80	Sound3B	; door slamming shut
SndPtr_SpindashRelease:	rom_ptr_z80	Sound3C	; spindash unleashed
SndPtr_Hammer:		rom_ptr_z80	Sound3D	; slide-thunk
SndPtr_Roll:		rom_ptr_z80	Sound3E	; rolling sound
SndPtr_ContinueJingle:	rom_ptr_z80	Sound3F	; got continue
SndPtr_CasinoBonus:	rom_ptr_z80	Sound40	; short bonus ding
SndPtr_Explosion:	rom_ptr_z80	Sound41	; badnik bust
SndPtr_WaterWarning:	rom_ptr_z80	Sound42	; warning ding-ding
SndPtr_EnterGiantRing:	rom_ptr_z80	Sound43	; special stage ring flash (mostly unused)
SndPtr_BossExplosion:	rom_ptr_z80	Sound44	; thunk
SndPtr_TallyEnd:	rom_ptr_z80	Sound45	; cha-ching
SndPtr_RingSpill:	rom_ptr_z80	Sound46	; losing rings
			rom_ptr_z80	Sound47	; chain pull chink-chink (unused)
SndPtr_Flamethrower:	rom_ptr_z80	Sound48	; flamethrower
SndPtr_Bonus:		rom_ptr_z80	Sound49	; bonus pwoieeew (mostly unused)
SndPtr_SpecStageEntry:	rom_ptr_z80	Sound4A	; special stage entry
SndPtr_SlowSmash:	rom_ptr_z80	Sound4B	; slower smash/crumble
SndPtr_Spring:		rom_ptr_z80	Sound4C	; spring boing
SndPtr_Blip:		rom_ptr_z80	Sound4D	; selection blip
SndPtr_RingLeft:	rom_ptr_z80	Sound4E	; another ring sound (only plays in the left speaker?)
SndPtr_Signpost:	rom_ptr_z80	Sound4F	; signpost spin sound
SndPtr_CNZBossZap:	rom_ptr_z80	Sound50	; mosquito zapper
			rom_ptr_z80	Sound51	; (unused)
			rom_ptr_z80	Sound52	; (unused)
SndPtr_Signpost2P:	rom_ptr_z80	Sound53
SndPtr_OOZLidPop:	rom_ptr_z80	Sound54	; OOZ lid pop sound
SndPtr_SlidingSpike:	rom_ptr_z80	Sound55
SndPtr_CNZElevator:	rom_ptr_z80	Sound56
SndPtr_PlatformKnock:	rom_ptr_z80	Sound57
SndPtr_BonusBumper:	rom_ptr_z80	Sound58	; CNZ bonusy bumper sound
SndPtr_LargeBumper:	rom_ptr_z80	Sound59	; CNZ baaang bumper sound
SndPtr_Gloop:		rom_ptr_z80	Sound5A	; CNZ gloop / water droplet sound
SndPtr_PreArrowFiring:	rom_ptr_z80	Sound5B
SndPtr_Fire:		rom_ptr_z80	Sound5C
SndPtr_ArrowStick:	rom_ptr_z80	Sound5D	; chain clink
SndPtr_Helicopter:
SndPtr_WingFortress:	rom_ptr_z80	Sound5E	; helicopter
SndPtr_SuperTransform:	rom_ptr_z80	Sound5F
SndPtr_SpindashRev:	rom_ptr_z80	Sound60	; spindash charge
SndPtr_Rumbling2:	rom_ptr_z80	Sound61	; rumbling
SndPtr_CNZLaunch:	rom_ptr_z80	Sound62
SndPtr_Flipper:		rom_ptr_z80	Sound63	; CNZ blooing bumper
SndPtr_HTZLiftClick:	rom_ptr_z80	Sound64	; HTZ track click sound
SndPtr_Leaves:		rom_ptr_z80	Sound65	; kicking up leaves sound
SndPtr_MegaMackDrop:	rom_ptr_z80	Sound66	; leaf splash?
SndPtr_DrawbridgeMove:	rom_ptr_z80	Sound67
SndPtr_QuickDoorSlam:	rom_ptr_z80	Sound68	; door slamming quickly (unused)
SndPtr_DrawbridgeDown:	rom_ptr_z80	Sound69
SndPtr_LaserBurst:	rom_ptr_z80	Sound6A	; robotic laser burst
SndPtr_Scatter:
SndPtr_LaserFloor:	rom_ptr_z80	Sound6B	; scatter
SndPtr_Teleport:	rom_ptr_z80	Sound6C
SndPtr_Error:		rom_ptr_z80	Sound6D	; error sound
SndPtr_MechaSonicBuzz:	rom_ptr_z80	Sound6E	; silver sonic buzz saw
SndPtr_LargeLaser:	rom_ptr_z80	Sound6F
SndPtr_OilSlide:	rom_ptr_z80	Sound70
SndPtr__End:

	; There are many non-relative pointers in these sound effects,
	; so the sounds shouldn't simply be BINCLUDE'd.
	; They could be included as separate .asm files using "include" instead of "binclude",
	; but I wanted to minimize the number of included asm files.

	; some comments on what the various script commands do (after the header):
	;  0x00-0x7F sets the note duration (of the previous note and following notes)
	;  0x81-0xDF plays a note (the valid range may be smaller for PSG or DAC)
	;  0x80 plays silence
	;  0xE0-0xFF does special things. I won't list them here... search for "Coordination flags" sonic 2.

	; the FM voices (poorly named "ssamp" or "samples" below)
	; are 25 bytes each and go directly to YM2612 registers.
	; they can be hard to edit (there's an art to it)
	; but search for sonic "Voice editing" for more info if you want to try.

; jumping sound
Sound20:	dc.w $0000,$0101
		dc.w $8080,z80_ptr(+),$F400
+		dc.b $F5,$00,$9E,$05,$F0,$02,$01,$F8,$65,$A3,$15,$F2

; checkpoint ding-dong sound
Sound21:	dc.w z80_ptr(ssamp21),$0101
		dc.w $8005,z80_ptr(+),$0001
ssamp21:	dc.b $3C,$05,$0A,$01,$01,$56,$5C,$5C,$5C,$0E,$11,$11
		dc.b $11,$09,$06,$0A,$0A,$4F,$3F,$3F,$3F,$17,$20,$80,$80
+		dc.b $EF,$00,$BD,$06,$BA,$16,$F2

; spike switch sound
Sound22:	dc.w $0000,$0101
		dc.w $80C0,z80_ptr(+),$0000
+		dc.b $F0,$01,$01,$F0,$08,$F3,$E7,$C0,$04,$CA,$04
-		dc.b $C0,$01,$EC
		dc.w $01F7,$0006,z80_ptr(-)
		dc.b $F2

; hurt sound
Sound23:	dc.w z80_ptr(ssamp23),$0101
		dc.w $8005,z80_ptr(+),$F400
+		dc.b $EF,$00,$B0,$07,$E7,$AD
-		dc.b $01,$E6
		dc.w $01F7,$002F,z80_ptr(-)
		dc.b $F2
ssamp23:	dc.b $30,$30,$30,$30,$30,$9E,$DC,$D8,$DC,$0E,$04,$0A
		dc.b $05,$08,$08,$08,$08,$BF,$BF,$BF,$BF,$14,$14,$3C,$80

; skidding sound
Sound24:	dc.w $0000,$0102 ; sound header... no sample and 2 script entries
		dc.w $80A0,z80_ptr(+),$F400 ; entry 1 header
		dc.w $80C0,z80_ptr(++),$F400 ; entry 2 header
+		dc.b $F5,$00,$AF,$01,$80,$AF,$80,$03 ; script entry 1
-		dc.b $AF,$01,$80
		dc.w $01F7,$000B,z80_ptr(-) ; loopback
		dc.b $F2 ; script 1 end
+		dc.b $F5,$00,$80,$01,$AD,$80,$AD,$80,$03 ; script entry 2
-		dc.b $AD,$01,$80
		dc.w $01F7,$000B,z80_ptr(-) ; loopback
		dc.b $F2 ; script 2 end

; block push sound
Sound25:	dc.w z80_ptr(ssamp25),$0101
		dc.w $8005,z80_ptr(+),$0000
+		dc.b $EF,$00,$80,$01,$8B,$0A,$80,$02,$F2
ssamp25:	dc.b $FA,$21,$10,$30,$32,$2F,$2F,$1F,$2F,$05,$09,$08
		dc.b $02,$06,$06,$0F,$02,$1F,$4F,$2F,$2F,$0F,$0E,$1A,$80

; spiky impalement sound
Sound26:	dc.w z80_ptr(ssamp26),$0101
		dc.w $8005,z80_ptr(+),$F200
+		dc.b $EF,$00,$F0,$01,$01,$10,$FF,$CF,$05,$D7,$25,$F2
ssamp26:	dc.b $3B,$3C,$30,$39,$31,$DF,$1F,$1F,$DF,$04,$04,$05
		dc.b $01,$04,$04,$04,$02,$FF,$1F,$0F,$AF,$29,$0F,$20,$80

; sparkling sound
Sound27:	dc.w z80_ptr(ssamp27),$0101
		dc.w $8004,z80_ptr(+),$0C1C
+		dc.b $EF,$00,$C1,$05,$C4,$05,$C9,$2B,$F2
ssamp27:	dc.b $07,$73,$33,$33,$73,$0F,$19,$14,$1A,$0A,$0A,$0A
		dc.b $0A,$0A,$0A,$0A,$0A,$57,$57,$57,$57,$00,$00,$00,$00

; short beep
Sound28:	dc.w $0000,$0101
		dc.w $8080,z80_ptr(+),$E803
+		dc.b $F5,$04,$CB,$04,$F2

; bwoop (unused)
Sound29:	dc.w $0000,$0101
		dc.w $80A0,z80_ptr(+),$0000
+		dc.b $F0,$01,$01,$E6,$35,$8E,$06,$F2

; splash sound
Sound2A:	dc.w z80_ptr(ssamp2A),$0102
		dc.w $80C0,z80_ptr(+),$0000
		dc.w $8005,z80_ptr(++),$0003
+		dc.b $F5,$00,$F3,$E7,$C2,$05,$C6,$05,$E7
-		dc.b $07,$EC,$01
		dc.w $E7F7,$000F,z80_ptr(-)
		dc.b $F2
+		dc.b $EF,$00,$A6,$14,$F2
ssamp2A:	dc.b $00,$00,$02,$03,$00,$D9,$1F,$DF,$1F,$12,$14,$11
		dc.b $0F,$0A,$0A,$00,$0D,$FF,$FF,$FF,$FF,$22,$27,$07,$80

; swish
Sound2B:	dc.w $0000,$0101
		dc.w $80C0,z80_ptr(+),$0000
+		dc.b $F5,$00,$F3,$E7,$C6,$03,$80,$03,$C6,$01,$E7
-		dc.b $01,$EC,$01
		dc.w $E7F7,$0015,z80_ptr(-)
		dc.b $F2

; boss hit
Sound2C:	dc.w z80_ptr(smashsamp),$0101
		dc.w $8005,z80_ptr(+),$0000
+		dc.b $EF,$00,$F0,$01,$01,$0C,$01
-		dc.b $81,$0A,$E6
		dc.w $10F7,$0004,z80_ptr(-)
		dc.b $F2
smashsamp:	dc.b $F9,$21,$10,$30,$32,$1F,$1F,$1F,$1F,$05,$09,$18
		dc.b $02,$0B,$10,$1F,$05,$1F,$4F,$2F,$2F,$0E,$04,$07,$80

; inhaling a bubble
Sound2D:	dc.w z80_ptr(ssamp2D),$0101
		dc.w $8005,z80_ptr(+),$0E00
+		dc.b $EF,$00,$F0,$01,$01,$21,$6E,$A6,$07
		dc.b $80,$06,$F0,$01,$01,$44,$1E,$AD,$08,$F2
ssamp2D:	dc.b $35,$05,$08,$09,$07,$1E,$0D,$0D,$0E,$0C,$03,$15
		dc.b $06,$16,$09,$0E,$10,$2F,$1F,$2F,$1F,$15,$12,$12,$80

; arrow firing
Sound2E:	dc.w z80_ptr(ssamp2E),$0102
		dc.w $8005,z80_ptr(+),$0000
		dc.w $80C0,z80_ptr(++),$0000
+		dc.b $EF,$00,$80,$01,$F0,$01,$01,$40,$48,$83,$06,$85,$02,$F2
+		dc.b $F5,$00,$80,$0B,$F3,$E7,$C6,$01,$E7
-		dc.b $02,$EC,$01
		dc.w $E7F7,$0010,z80_ptr(-)
		dc.b $F2
ssamp2E:	dc.b $FA,$02,$00,$03,$05,$12,$0F,$11,$13,$05,$09,$18
		dc.b $02,$06,$06,$0F,$02,$1F,$4F,$2F,$2F,$2F,$0E,$1A,$80

; shield sound
Sound2F:	dc.w z80_ptr(ssamp2F),$0101
		dc.w $8005,z80_ptr(+),$0C00
+		dc.b $EF,$00,$80,$01,$A3,$05,$E7,$A4,$26,$F2
ssamp2F:	dc.b $30,$30,$30,$30,$30,$9E,$AC,$A8,$DC,$0E,$04,$0A
		dc.b $05,$08,$08,$08,$08,$BF,$BF,$BF,$BF,$04,$14,$2C,$80

; laser beam
Sound30:	dc.w z80_ptr(ssamp30),$0101 ; sound header... a voice and 1 script entry
		dc.w $8005,z80_ptr(+),$FB05 ; script entry header
+		dc.b $EF,$00,$DF,$7F ; script start
-		dc.b $DF,$02,$E6 ; script continued
		dc.w $01F7,$001B,z80_ptr(-) ; loopback
		dc.b $F2 ; script end
ssamp30:	dc.b $83,$1F,$1F,$15,$1F,$1F,$1F,$1F,$1F,$00,$00,$00 ; voice
		dc.b $00,$02,$02,$02,$02,$2F,$FF,$2F,$3F,$0B,$01,$16,$82 ; (fixed length)

; zap (unused)
Sound31:	dc.w z80_ptr(ssamp31),$0101
		dc.w $8005,z80_ptr(+),$FB02
+		dc.b $EF,$00,$B3,$05,$80,$01,$B3,$09,$F2
ssamp31:	dc.b $83,$12,$13,$10,$1E,$1F,$1F,$1F,$1F,$00,$00,$00
		dc.b $00,$02,$02,$02,$02,$2F,$FF,$2F,$3F,$05,$34,$10,$87

; drownage
Sound32:	dc.w z80_ptr(ssamp32),$0102
		dc.w $8004,z80_ptr(++),$0C04
		dc.w $8005,z80_ptr(+),$0E02
+		dc.b $EF,$00,$F0,$01,$01,$83,$0C
-		dc.b $8A,$05,$05,$E6
		dc.w $03F7,$000A,z80_ptr(-)
		dc.b $F2
+		dc.b $80,$06,$EF,$00,$F0,$01,$01,$6F,$0E
-		dc.b $8D,$04,$05,$E6
		dc.w $03F7,$000A,z80_ptr(-)
		dc.b $F2
ssamp32:	dc.b $35,$14,$04,$1A,$09,$0E,$11,$10,$0E,$0C,$03,$15
		dc.b $06,$16,$09,$0E,$10,$2F,$4F,$2F,$4F,$2F,$12,$12,$80

; fire + burn
Sound33:	dc.w z80_ptr(ssamp2E),$0102
		dc.w $8005,z80_ptr(+),$0000
		dc.w $80C0,z80_ptr(++),$0000
+		dc.b $EF,$00,$80,$01,$F0,$01,$01,$40,$48,$83,$06,$85,$02,$F2
+		dc.b $F5,$00,$80,$0B,$F3,$E7,$A7,$25,$E7
-		dc.b $02,$EC,$01
		dc.w $E7F7,$0010,z80_ptr(-)
		dc.b $F2

; bumper bing
Sound34:	dc.w z80_ptr(ssamp34),$0103
		dc.w $8005,z80_ptr(+),$0000
		dc.w $8004,z80_ptr(++),$0000
		dc.w $8002,z80_ptr(+++),$0002
+		dc.b $EF,$00,$F6
		dc.w z80_ptr(Sound34_3)
+		dc.b $EF,$00,$E1,$07,$80,$01
Sound34_3:
		dc.b $BA,$20,$F2
+		dc.b $EF,$01,$9A,$03,$F2
ssamp34:	dc.b $3C,$05,$0A,$01,$01,$56,$5C,$5C,$5C,$0E,$11,$11
		dc.b $11,$09,$06,$0A,$0A,$4F,$3F,$3F,$3F,$1F,$2B,$80,$80
		dc.b $05,$00,$00,$00,$00,$1F,$1F,$1F,$1F,$12,$0C,$0C
		dc.b $0C,$12,$08,$08,$08,$1F,$5F,$5F,$5F,$07,$80,$80,$80

; ring sound
Sound35:	dc.w z80_ptr(ringsamp),$0101
		dc.w $8005,z80_ptr(+),$0005
+		dc.b $EF,$00,$E0,$40,$C1,$05,$C4,$05,$C9,$1B,$F2


Sound36:	dc.w $0000,$0101
		dc.w $80C0,z80_ptr(+),$0000
+		dc.b $F0,$01,$01,$F0,$08,$F3,$E7,$C1,$07
-		dc.b $D0,$01,$EC
		dc.w $01F7,$000C,z80_ptr(-)
		dc.b $F2

; rumbling
Sound37:	dc.w z80_ptr(ssamp37),$0101
		dc.w $8005,z80_ptr(+),$0000
+		dc.b $EF,$00,$F0,$01,$01,$20,$08
-		dc.b $8B
		dc.w $0AF7,$0008,z80_ptr(-)
-		dc.b $8B,$10,$E6
		dc.w $03F7,$0009,z80_ptr(-)
		dc.b $F2
ssamp37:	dc.b $FA,$21,$10,$30,$32,$1F,$1F,$1F,$1F,$05,$09,$18
		dc.b $02,$06,$06,$0F,$02,$1F,$4F,$2F,$2F,$0F,$0E,$1A,$80

; (unused)
Sound38:	dc.w $0000,$0101
		dc.w $80C0,z80_ptr(+),$0000
+		dc.b $F0,$01,$01,$F0,$08,$F3,$E7,$B4,$08
-		dc.b $B0,$02,$EC
		dc.w $01F7,$0003,z80_ptr(-)
		dc.b $F2

; smash/breaking
Sound39:	dc.w z80_ptr(smashsamp),$0104
		dc.w $8002,z80_ptr(+),$1000
		dc.w $8004,z80_ptr(+++),$0000
		dc.w $8005,z80_ptr(++),$1000
		dc.w $80C0,z80_ptr(s39s4),$0000
+		dc.b $E0,$40,$80,$02,$F6
		dc.w z80_ptr(++)
+		dc.b $E0,$80,$80,$01
+		dc.b $EF,$00,$F0,$03,$01,$20,$04
-		dc.b $81,$18,$E6
		dc.w $0AF7,$0006,z80_ptr(-)
		dc.b $F2
s39s4:		dc.b $F0,$01,$01,$0F,$05,$F3,$E7
-		dc.b $B0,$18,$E7,$EC
		dc.w $03F7,$0005,z80_ptr(-)
		dc.b $F2

; nondescript ding (unused)
Sound3A:	dc.w z80_ptr(ssamp3A),$0101
		dc.w $8005,z80_ptr(+),$0007
+		dc.b $EF,$00,$AE,$08,$F2
ssamp3A:	dc.b $1C,$2E,$0F,$02,$02,$1F,$1F,$1F,$1F,$18,$14,$0F
		dc.b $0E,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$20,$1B,$80,$80

; door slamming shut
Sound3B:	dc.w z80_ptr(ssamp3B),$0101
		dc.w $8005,z80_ptr(+),$F400
+		dc.b $EF,$00,$9B,$04,$80,$A0,$06,$F2
ssamp3B:	dc.b $3C,$00,$00,$00,$00,$1F,$1F,$1F,$1F,$00,$0F,$16
		dc.b $0F,$00,$00,$00,$00,$0F,$FF,$AF,$FF,$00,$0A,$80,$80

; spindash unleashed
Sound3C:	dc.w z80_ptr(ssamp3C),$0102
		dc.w $8005,z80_ptr(+),$9000
		dc.w $80C0,z80_ptr(++),$0000
+		dc.b $EF,$00,$F0,$01,$01,$C5,$1A,$CD,$07,$F2
+		dc.b $F5,$07,$80,$07,$F0,$01,$02,$05,$FF,$F3,$E7,$BB,$4F,$F2
ssamp3C:	dc.b $FD,$09,$00,$03,$00,$1F,$1F,$1F,$1F,$10,$0C,$0C
		dc.b $0C,$0B,$10,$1F,$05,$1F,$4F,$2F,$2F,$09,$92,$84,$8E

; slide-thunk
Sound3D:	dc.w z80_ptr(ssamp3D),$0102
		dc.w $8005,z80_ptr(+),$100A
		dc.w $8004,z80_ptr(++),$0000
+		dc.b $EF,$00,$F0,$01,$01,$60,$01,$A7,$08,$F2
+		dc.b $80,$08,$EF,$01,$84,$22,$F2
ssamp3D:	dc.b $FA,$21,$19,$3A,$30,$1F,$1F,$1F,$1F,$05,$09,$18
		dc.b $02,$0B,$10,$1F,$05,$1F,$4F,$2F,$2F,$0E,$04,$07,$80
		dc.b $FA,$31,$10,$30,$32,$1F,$1F,$1F,$1F,$05,$05,$18
		dc.b $10,$0B,$10,$1F,$10,$1F,$1F,$2F,$2F,$0D,$01,$00,$80

; rolling sound
Sound3E:	dc.w z80_ptr(ssamp3E),$0101
		dc.w $8004,z80_ptr(+),$0C05
+		dc.b $EF,$00,$80,$01,$F0,$03,$01,$09,$FF,$CA,$25,$F4
-		dc.b $E7,$E6,$01,$D0
		dc.w $02F7,$002A,z80_ptr(-)
		dc.b $F2
ssamp3E:	dc.b $3C,$00,$02,$44,$02,$1F,$1F,$1F,$15,$00,$00,$1F
		dc.b $00,$00,$00,$00,$00,$0F,$0F,$0F,$0F,$0D,$28,$00,$00

; got continue
Sound3F:	dc.w z80_ptr(ssamp3F),$0103
		dc.w $8002,z80_ptr(+),$F406
		dc.w $8004,z80_ptr(++),$F406
		dc.w $8005,z80_ptr(+++),$F406
+		dc.b $EF,$00,$C9,$07,$CD,$D0,$CB,$CE,$D2,$CD,$D0,$D4,$CE,$D2,$D5
-		dc.b $D0,$07,$D4,$D7,$E6
		dc.w $05F7,$0008,z80_ptr(-)
		dc.b $F2
+		dc.b $EF,$00,$E1,$01,$80,$07,$CD,$15,$CE,$D0,$D2
-		dc.b $D4,$15,$E6
		dc.w $05F7,$0008,z80_ptr(-)
		dc.b $F2
+		dc.b $EF,$00,$E1,$01,$C9,$15,$CB,$CD,$CE
-		dc.b $D0,$15,$E6
		dc.w $05F7,$0008,z80_ptr(-)
		dc.b $F2
ssamp3F:	dc.b $14,$25,$36,$33,$11,$1F,$1F,$1F,$1F,$15,$1C,$18
		dc.b $13,$0B,$0D,$08,$09,$0F,$8F,$9F,$0F,$24,$0A,$05,$80

; short bonus ding
Sound40:	dc.w z80_ptr(ssamp3F),$0102
		dc.w $8005,z80_ptr(++),$0008
		dc.w $8004,z80_ptr(+),$0008
+		dc.b $E1,$03,$80,$02
+		dc.b $EF,$00,$C4,$16,$F2

; badnik bust
Sound41:	dc.w z80_ptr(ssamp41),$0102
		dc.w $8005,z80_ptr(+),$0000
		dc.w $80C0,z80_ptr(++),$0002
+		dc.b $F0,$03,$01,$72,$0B,$EF,$00,$BA,$16,$F2
+		dc.b $F5,$01,$F3,$E7,$B0,$1B,$F2
ssamp41:	dc.b $3C,$0F,$03,$01,$01,$1F,$1F,$1F,$1F,$19,$19,$12
		dc.b $0E,$05,$00,$12,$0F,$0F,$FF,$7F,$FF,$00,$00,$80,$80

; warning ding-ding
Sound42:	dc.w z80_ptr(ssamp3F),$0101
		dc.w $8005,z80_ptr(+),$0C08
+		dc.b $EF,$00,$BA,$08,$BA,$25,$F2

; special stage ring flash (mostly unused)
Sound43:	dc.w z80_ptr(ssamp43),$0102
		dc.w $8004,z80_ptr(+),$0C00
		dc.w $8005,z80_ptr(++),$0013
+		dc.b $EF,$01,$80,$01,$A2,$08,$EF,$00,$E7,$AD,$26,$F2
+		dc.b $EF,$02,$F0,$06,$01,$03,$FF,$80,$0A
-		dc.b $C3
		dc.w $06F7,$0005,z80_ptr(-)
		dc.b $C3,$17,$F2
ssamp43:	dc.b $30,$30,$34,$5C,$30,$9E,$AC,$A8,$DC,$0E,$04,$0A
		dc.b $05,$08,$08,$08,$08,$BF,$BF,$BF,$BF,$24,$04,$1C,$80
		dc.b $30,$30,$34,$5C,$30,$9E,$AC,$A8,$DC,$0E,$04,$0A
		dc.b $05,$08,$08,$08,$08,$BF,$BF,$BF,$BF,$24,$04,$2C,$80
		dc.b $04,$37,$77,$72,$49,$1F,$1F,$1F,$1F,$07,$07,$0A
		dc.b $0D,$00,$00,$0B,$0B,$1F,$1F,$0F,$0F,$13,$13,$81,$88

; thunk
Sound44:	dc.w z80_ptr(ssamp44),$0101
		dc.w $8005,z80_ptr(+),$0000
+		dc.b $EF,$00,$8A,$22,$F2
ssamp44:	dc.b $FA,$21,$10,$30,$32,$1F,$1F,$1F,$1F,$05,$05,$18
		dc.b $10,$0B,$10,$1F,$10,$1F,$4F,$2F,$2F,$0D,$04,$07,$80

; cha-ching
Sound45:	dc.w z80_ptr(ssamp45),$0103
		dc.w $8005,z80_ptr(+),$0000
		dc.w $8004,z80_ptr(++),$0000
		dc.w $80C0,z80_ptr(+++),$0000
+		dc.b $EF,$00,$8A,$08,$80,$02,$8A,$08,$F2
+		dc.b $EF,$01,$80,$12,$C6,$55,$F2
+		dc.b $F5,$02,$F3,$E7,$80,$02,$C2,$05,$C4,$04,$C2,$05,$C4,$04,$F2
ssamp45:	dc.b $3B,$03,$02,$02,$06,$18,$1A,$1A,$96,$17,$0A,$0E
		dc.b $10,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$00,$39,$28,$80
ringsamp:	dc.b $04,$37,$77,$72,$49,$1F,$1F,$1F,$1F,$07,$07,$0A
		dc.b $0D,$00,$00,$0B,$0B,$1F,$1F,$0F,$0F,$23,$23,$80,$80

; losing rings (scatter)
Sound46:	dc.w z80_ptr(ringsamp),$0102
		dc.w $8004,z80_ptr(+),$0005
		dc.w $8005,z80_ptr(++),$0008
+		dc.b $EF,$00,$C6,$02,$05,$05,$05,$05,$05,$05,$3A,$F2
+		dc.b $EF,$00,$80,$02,$C4,$02,$05,$15,$02,$05,$32,$F2

; chain pull chink-chink (unused)
Sound47:	dc.w z80_ptr(ssamp47),$0101
		dc.w $8005,z80_ptr(+),$0000
+		dc.b $EF,$00,$BE,$05,$80,$04,$BE,$04,$80,$04,$F2
ssamp47:	dc.b $28,$2F,$37,$5F,$2B,$1F,$1F,$1F,$1F,$15,$15,$15
		dc.b $13,$13,$0D,$0C,$10,$2F,$3F,$2F,$2F,$00,$1F,$10,$80

; flamethrower
Sound48:	dc.w $0000,$0101
		dc.w $80C0,z80_ptr(+),$0000
+		dc.b $F5,$00,$F3,$E7,$A7,$25,$F2

; bonus pwoieeew (mostly unused)
Sound49:	dc.w z80_ptr(ssamp49),$0101
		dc.w $8005,z80_ptr(+),$0E00
+		dc.b $EF,$00,$F0,$01,$01,$33,$18,$B9,$1A,$F2
ssamp49:	dc.b $3B,$0A,$05,$31,$02,$5F,$5F,$5F,$5F,$04,$16,$14
		dc.b $0C,$00,$00,$04,$00,$1F,$D8,$6F,$FF,$03,$00,$25,$80

; special stage entry
Sound4A:	dc.w z80_ptr(ssamp4A),$0101
		dc.w $8005,z80_ptr(+),$0002
+		dc.b $EF,$00,$F0,$01,$01,$5B,$02,$CC,$65,$F2
ssamp4A:	dc.b $20,$36,$30,$35,$31,$41,$3B,$49,$4B,$09,$09,$06
		dc.b $08,$01,$02,$03,$A9,$0F,$0F,$0F,$0F,$29,$23,$27,$80

; slower smash/crumble
Sound4B:	dc.w z80_ptr(smashsamp),$0102
		dc.w $8005,z80_ptr(+),$0000
		dc.w $80C0,z80_ptr(++),$0000
+		dc.b $EF,$00,$F0,$03,$01,$20,$04
-		dc.b $81,$18,$E6
		dc.w $0AF7,$0006,z80_ptr(-)
		dc.b $F2
+		dc.b $F0,$01,$01,$0F,$05,$F3,$E7
-		dc.b $B0,$18,$E7,$EC
		dc.w $03F7,$0005,z80_ptr(-)
		dc.b $F2

; spring boing
Sound4C:	dc.w z80_ptr(ssamp4C),$0101
		dc.w $8004,z80_ptr(+),$0002
+		dc.b $EF,$00,$80,$01,$F0,$03,$01,$5D,$0F,$B0,$0C,$F4
-		dc.b $E7,$E6,$02,$BD
		dc.w $02F7,$0019,z80_ptr(-)
		dc.b $F2
ssamp4C:	dc.b $20,$36,$30,$35,$31,$DF,$9F,$DF,$9F,$07,$09,$06
		dc.b $06,$07,$06,$06,$08,$2F,$1F,$1F,$FF,$16,$13,$30,$80

; selection blip
Sound4D:	dc.w $0000,$0101
		dc.w $80C0,z80_ptr(+),$0000
+		dc.b $BB,$02,$F2

; another ring sound (only plays in the left speaker?)
Sound4E:	dc.w z80_ptr(ringsamp),$0101
		dc.w $8004,z80_ptr(+),$0005
+		dc.b $EF,$00,$E0,$80,$C1,$04,$C4,$05,$C9,$1B,$F2

; signpost spin sound
Sound4F:	dc.w z80_ptr(ssamp4F),$0102
		dc.w $8004,z80_ptr(+),$2703
		dc.w $8005,z80_ptr(++),$2700
+		dc.b $80,$04
+		dc.b $EF,$00
-		dc.b $B4,$05,$E6
		dc.w $02F7,$0015,z80_ptr(-)
		dc.b $F2
ssamp4F:	dc.b $F4,$06,$0F,$04,$0E,$1F,$1F,$1F,$1F,$00,$0B,$00
		dc.b $0B,$00,$05,$00,$08,$0F,$FF,$0F,$FF,$0C,$03,$8B,$80

; mosquito zapper
Sound50:	dc.w z80_ptr(ssamp50),$0101
		dc.w $8005,z80_ptr(+),$F400
+		dc.b $EF,$00,$B3,$04,$80,$01
-		dc.b $B4,$04,$80
		dc.w $01F7,$0004,z80_ptr(-)
		dc.b $F2
ssamp50:	dc.b $83,$12,$13,$10,$1E,$1F,$1F,$1F,$1F,$00,$00,$00
		dc.b $00,$02,$02,$02,$02,$2F,$FF,$2F,$3F,$06,$34,$10,$87

; (unused)
Sound51:	dc.w z80_ptr(ssamp51),$0102
		dc.w $80C0,z80_ptr(+),$0001
		dc.w $8005,z80_ptr(++),$000B
+		dc.b $F5,$02,$F3,$E4,$B0,$04,$85,$02,$F2
+		dc.b $EF,$00,$E8,$04,$A5,$06,$F2
ssamp51:	dc.b $3C,$02,$01,$00,$01,$1F,$1F,$1F,$1F,$00,$19,$0E
		dc.b $10,$00,$00,$0C,$0F,$0F,$FF,$EF,$FF,$05,$00,$80,$80

; (unused)
Sound52:	dc.w z80_ptr(ssamp52),$0101
		dc.w $8005,z80_ptr(+),$0002
+		dc.b $F0,$01,$01,$2A,$07,$EF,$00
-		dc.b $A5,$03
		dc.w $E7F7,$0013,z80_ptr(-)
-		dc.b $A5,$03,$E7,$E6
		dc.w $02F7,$0013,z80_ptr(-)
		dc.b $F2
ssamp52:	dc.b $28,$21,$21,$21,$30,$1F,$1F,$1F,$1F,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$29,$20,$29,$80


Sound53:	dc.w z80_ptr(ssamp53),$0101
		dc.w $8005,z80_ptr(+),$F503
+		dc.b $EF,$00,$F0,$01,$01,$46,$09,$A7,$14,$E7,$14,$E7,$E6,$04
		dc.b $14,$E7,$E6,$04,$14,$E7,$E6,$04,$0A,$E7,$E6,$04,$0A,$F2
ssamp53:	dc.b $07,$0A,$0C,$0C,$0C,$1F,$1F,$1F,$1F,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$FF,$FF,$FF,$FF,$2A,$0F,$0F,$80

; OOZ lid pop sound
Sound54:	dc.w z80_ptr(ssamp54),$0102
		dc.w $8005,z80_ptr(+),$0000
		dc.w $80C0,z80_ptr(++),$0006
+		dc.b $EF,$00,$B6,$15,$F2
+		dc.b $F3,$E7,$F5,$04,$C6,$03,$E7,$C5,$E7
		dc.b $C4,$E7,$C3,$E7,$C2,$E7,$C1,$E7,$C0,$F2
ssamp54:	dc.b $07,$03,$02,$03,$00,$FF,$6F,$6F,$3F,$12,$14,$11
		dc.b $0E,$1A,$0A,$03,$0D,$FF,$FF,$FF,$FF,$03,$07,$07,$80


Sound55:	dc.w z80_ptr(ssamp55),$0101
		dc.w $8005,z80_ptr(+),$0000
+		dc.b $EF,$00,$AA,$07,$B6,$15,$F2
ssamp55:	dc.b $42,$20,$0E,$0F,$0F,$1F,$1F,$1F,$1F,$1F,$1F,$1F
		dc.b $1F,$0F,$0E,$0F,$0E,$0F,$0F,$0F,$0F,$2E,$80,$20,$80


Sound56:	dc.w z80_ptr(ssamp56),$0101
		dc.w $8005,z80_ptr(+),$100E
+		dc.b $EF,$00,$F0,$01,$01,$1E,$FF,$8F,$1C,$F4
-		dc.b $E7,$9A
		dc.w $05F7,$0009,z80_ptr(-)
-		dc.b $E7,$9A,$04,$E6,$02,$E7,$9A,$04,$E6
		dc.w $02F7,$0008,z80_ptr(-)
		dc.b $F2
ssamp56:	dc.b $0D,$06,$00,$00,$E5,$1F,$1F,$1F,$1F,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$0F,$0F,$0F,$0F,$27,$80,$80,$80


Sound57:	dc.w z80_ptr(ssamp57),$0101
		dc.w $8005,z80_ptr(+),$0000
+		dc.b $EF,$00,$CA,$15,$F2
ssamp57:	dc.b $04,$09,$70,$00,$30,$1C,$1F,$DF,$1F,$15,$12,$0B
		dc.b $0F,$0C,$0D,$00,$0D,$07,$2F,$FA,$FA,$00,$29,$00,$00

; CNZ bonusy bumper sound
Sound58:	dc.w z80_ptr(ssamp58),$0101
		dc.w $8005,z80_ptr(+),$0007
+		dc.b $EF,$00,$B3,$06,$B3,$15,$F2
ssamp58:	dc.b $3C,$05,$0A,$01,$01,$56,$5C,$5C,$5C,$0E,$11,$11
		dc.b $11,$09,$06,$0A,$0A,$4F,$3F,$3F,$3F,$17,$20,$80,$80

; CNZ baaang bumper sound
Sound59:	dc.w z80_ptr(ssamp59),$0103
		dc.w $8004,z80_ptr(+),$0000
		dc.w $8002,z80_ptr(++),$0002
		dc.w $8005,z80_ptr(+++),$0000
+		dc.b $EF,$00,$E1,$0C,$B5,$14,$F2
+		dc.b $EF,$01,$9A,$03,$F2
+		dc.b $EF,$00,$B6,$14,$F2
ssamp59:	dc.b $32,$30,$30,$40,$70,$1F,$1F,$1F,$1F,$12,$0A,$01
		dc.b $0D,$00,$01,$01,$0C,$00,$23,$C3,$F6,$08,$07,$1C,$03
		dc.b $05,$00,$00,$00,$00,$1F,$1F,$1F,$1F,$12,$0C,$0C
		dc.b $0C,$12,$08,$08,$08,$1F,$5F,$5F,$5F,$07,$80,$80,$80

; CNZ gloop / water droplet sound
Sound5A:	dc.w z80_ptr(ssamp5A),$0101
		dc.w $8005,z80_ptr(+),$0000
+		dc.b $EF,$00,$F0,$01,$01,$7F,$F1,$AA,$0A,$F2
ssamp5A:	dc.b $47,$03,$02,$02,$04,$5F,$5F,$5F,$5F,$0E,$1A,$11
		dc.b $0A,$09,$0A,$0A,$0A,$4F,$3F,$3F,$3F,$7F,$80,$80,$A3


Sound5B:	dc.w z80_ptr(ssamp5B),$0101
		dc.w $8005,z80_ptr(+),$0000
+		dc.b $EF,$00,$80,$02,$A5,$01,$E7
-		dc.b $01,$E7,$E6
		dc.w $02F7,$0005,z80_ptr(-)
		dc.b $F2
ssamp5B:	dc.b $38,$0F,$0F,$0F,$0F,$1F,$1F,$1F,$0E,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$0F,$0F,$0F,$1F,$00,$00,$00,$80


Sound5C:	dc.w z80_ptr(ssamp5C),$0102
		dc.w $8004,z80_ptr(+),$000E
		dc.w $80C0,z80_ptr(++),$0000
+		dc.b $EF,$00,$85,$40
-		dc.b $E7,$04,$E6
		dc.w $04F7,$000A,z80_ptr(-)
		dc.b $F2
+		dc.b $F5,$00,$F3,$E7,$A7,$40
-		dc.b $E7,$08,$E6
		dc.w $01F7,$0005,z80_ptr(-)
		dc.b $F2
ssamp5C:	dc.b $FA,$12,$01,$01,$01,$1F,$1F,$1F,$1F,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$0F,$0F,$0F,$0F,$81,$8E,$14,$80

; chain clink
Sound5D:	dc.w z80_ptr(ssamp5D),$0101
		dc.w $8005,z80_ptr(+),$0000
+		dc.b $EF,$00,$C0,$04,$F2
ssamp5D:	dc.b $28,$2F,$37,$5F,$2B,$1F,$1F,$1F,$1F,$15,$15,$15
		dc.b $13,$13,$0D,$0C,$10,$2F,$3F,$2F,$2F,$00,$1F,$10,$80

; helicopter
Sound5E:	dc.w z80_ptr(ssamp5E),$0101
		dc.w $8002,z80_ptr(+),$1405
+		dc.b $EF,$00
-		dc.b $95,$02,$95
		dc.w $01F7,$0013,z80_ptr(-)
-		dc.b $95,$02,$95,$01,$E6
		dc.w $01F7,$001B,z80_ptr(-)
		dc.b $F2
ssamp5E:	dc.b $35,$30,$44,$40,$51,$1F,$1F,$1F,$1F,$10,$00,$13
		dc.b $15,$1F,$00,$1F,$1A,$7F,$0F,$7F,$5F,$02,$A8,$80,$80


Sound5F:	dc.w z80_ptr(ssamp5F),$0103
		dc.w $8005,z80_ptr(s5Fs1),$0000
		dc.w $80C0,z80_ptr(s5Fs2),$0000
		dc.w $80A0,z80_ptr(s5Fs3),$0000
s5Fs1		dc.b $EF,$00,$F0,$01,$01,$C5,$1A,$CD,$07,$E6,$0A,$80
		dc.b $06,$EF,$01,$F0,$01,$01,$11,$FF,$A2,$28
-		dc.b $E7,$03,$E6
		dc.w $03F7,$0005,z80_ptr(-)
		dc.b $F2
s5Fs2		dc.b $80,$07,$F0,$01,$02,$05,$FF,$F3,$E7,$BB,$1D
-		dc.b $E7,$07,$EC
		dc.w $01F7,$0010,z80_ptr(-)
		dc.b $F2
s5Fs3		dc.b $80,$16,$F5,$03
-		dc.b $BF,$04,$C1,$C3,$EC,$01,$E9
		dc.w $FFF7,$0005,z80_ptr(-)
-		dc.b $BF,$04,$C1,$C3,$EC,$01,$E9
		dc.w $01F7,$0007,z80_ptr(-)
		dc.b $F2
ssamp5F:	dc.b $FD,$09,$00,$03,$00,$1F,$1F,$1F,$1F,$10,$0C,$0C
		dc.b $0C,$0B,$10,$1F,$05,$1F,$4F,$2F,$2F,$09,$92,$84,$8E
		dc.b $3A,$70,$30,$04,$01,$0F,$14,$19,$16,$08,$0A,$0B
		dc.b $05,$03,$03,$03,$05,$1F,$6F,$8F,$5F,$1F,$22,$1F,$80

; spindash charge
Sound60:	dc.w z80_ptr(ssamp60),$0101
		dc.w $8005,z80_ptr(+),$FE00
+		dc.b $EF,$00,$F0,$00,$01,$20,$F6,$C4,$16,$E7,$F4,$D0,$18,$E7
-		dc.b $04,$E7,$E6
		dc.w $03F7,$0010,z80_ptr(-)
		dc.b $F2
ssamp60:	dc.b $34,$00,$03,$0C,$09,$9F,$8C,$8F,$95,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$0F,$0F,$0F,$0F,$00,$1D,$00,$00

; rumbling
Sound61:	dc.w z80_ptr(ssamp61),$0101
		dc.w $8004,z80_ptr(+),$0004
+		dc.b $80,$01,$EF,$00,$F0,$00,$01,$70,$06,$82,$06,$85,$08,$83
		dc.b $01,$82,$05,$86,$06,$89,$03,$82,$08,$88,$04,$82,$06,$E6
		dc.b $02,$85,$08,$E6,$02,$83,$01,$E6,$02,$82,$05,$E6,$02,$86
		dc.b $06,$E6,$02,$89,$03,$E6,$02,$82,$08,$E6,$02,$88,$04,$E6,$02,$F2
ssamp61:	dc.b $32,$30,$30,$50,$30,$1F,$0E,$19,$0E,$07,$12,$15
		dc.b $09,$0A,$09,$1D,$06,$E8,$03,$0A,$17,$07,$00,$00,$00


Sound62:	dc.w z80_ptr(ssamp62),$0101
		dc.w $8005,z80_ptr(+),$FF00
+		dc.b $EF,$00,$A6,$05,$F0,$01,$01,$E7,$40
-		dc.b $C4,$02,$E7,$E6
		dc.w $01F7,$0012,z80_ptr(-)
		dc.b $F2
ssamp62:	dc.b $34,$0C,$10,$73,$0C,$AF,$AC,$FF,$D5,$06,$00,$02
		dc.b $01,$02,$0A,$04,$08,$BF,$BF,$BF,$BF,$00,$08,$80,$80

; CNZ blooing bumper
Sound63:	dc.w z80_ptr(ssamp63),$0101
		dc.w $8005,z80_ptr(+),$0907
+		dc.b $EF,$00,$F0,$01,$01,$04,$56,$92,$03,$9A,$25,$F2
ssamp63:	dc.b $3D,$12,$10,$77,$30,$5F,$5F,$5F,$5F,$0F,$0A,$00
		dc.b $01,$0A,$0A,$0D,$0D,$4F,$0F,$0F,$0F,$13,$80,$80,$80

; HTZ track click sound
Sound64:	dc.w z80_ptr(ssamp64),$0101
		dc.w $8005,z80_ptr(+),$1100
+		dc.b $EF,$00,$C7,$02,$F2
ssamp64:	dc.b $24,$2A,$02,$05,$01,$1A,$1F,$10,$1F,$0F,$1F,$1F
		dc.b $1F,$0C,$0D,$11,$11,$0C,$09,$09,$0F,$0E,$04,$80,$80

; kicking up leaves sound
Sound65:	dc.w z80_ptr(ssamp65),$0101
		dc.w $80C0,z80_ptr(+),$F800
+		dc.b $F5,$03,$F3,$E7,$CE,$03,$F5,$06,$CE,$04,$EC
		dc.b $02,$CE,$02,$F5,$03,$EC,$FE,$CE,$08,$CE,$18,$F2
ssamp65:	; uhm... apparently they forgot to null out the pointer to here.
		; luckily, sound 65 doesn't really use its sample

; leaf splash?
Sound66:	dc.w z80_ptr(ssamp66),$0102
		dc.w $8005,z80_ptr(++),$EE08
		dc.w $80C0,z80_ptr(+),$0000
+		dc.b $F3,$E7,$F5,$09,$C6,$36,$F2
+		dc.b $EF,$00,$80,$01,$92,$02,$02,$02,$30,$F2
ssamp66:	dc.b $32,$33,$17,$34,$13,$0F,$0D,$1B,$17,$00,$04,$02
		dc.b $0B,$08,$00,$08,$09,$6F,$5F,$4F,$6F,$05,$00,$00,$80


Sound67:	dc.w z80_ptr(ssamp67),$0101
		dc.w $80C0,z80_ptr(+),$0000
+		dc.b $F5,$06,$F3,$E7,$90,$0A,$94,$0A,$98,$0A,$9C
		dc.b $0A,$A0,$0A,$A4,$08,$A8,$08,$AC,$08,$B0,$08,$F2
ssamp67:	; another not-really-used sample (like Sound65)

; door slamming quickly (unused)
Sound68:	dc.w z80_ptr(ssamp68),$0101
		dc.w $8005,z80_ptr(+),$F400
+		dc.b $EF,$00,$9B,$04,$A5,$06,$F2
ssamp68:	dc.b $3C,$00,$00,$00,$00,$1F,$1F,$1F,$1F,$00,$0F,$16
		dc.b $0F,$00,$00,$00,$00,$0F,$FF,$AF,$FF,$00,$0A,$80,$80


Sound69:	dc.w z80_ptr(ssamp69),$0102
		dc.w $8005,z80_ptr(+),$F400
		dc.w $80C0,z80_ptr(++),$0000
+		dc.b $EF,$00,$9B,$03,$A8,$06,$9E,$08,$F2
+		dc.b $F5,$04,$F3,$E7,$C6,$03,$C6,$06,$C6,$08,$F2
ssamp69:	dc.b $3C,$00,$00,$00,$00,$1F,$1F,$1F,$1F,$00,$0F,$16
		dc.b $0F,$00,$00,$00,$00,$0F,$FF,$AF,$FF,$00,$0A,$80,$80

; robotic laser burst
Sound6A:	dc.w z80_ptr(ssamp6A),$0101
		dc.w $8005,z80_ptr(+),$0004
+		dc.b $EF,$00,$DF,$14,$E6,$18,$06,$F2
ssamp6A:	dc.b $3D,$09,$34,$34,$28,$1F,$16,$16,$16,$00,$00,$00
		dc.b $04,$00,$00,$00,$00,$0F,$0F,$0F,$0F,$15,$02,$02,$00

; scatter
Sound6B:	dc.w z80_ptr(ssamp6B),$0101
		dc.w $8004,z80_ptr(+),$0002
+		dc.b $EF,$00,$81,$04,$80,$0C,$F2
ssamp6B:	dc.b $3A,$30,$30,$40,$70,$1F,$1F,$1F,$1F,$12,$0A,$01
		dc.b $07,$00,$01,$01,$03,$00,$23,$C3,$46,$08,$07,$1C,$03


Sound6C:	dc.w z80_ptr(ssamp6C),$0104
		dc.w $8005,z80_ptr(++),$0010
		dc.w $8004,z80_ptr(+),$0010
		dc.w $80C0,z80_ptr(s5Fs2),$0000
		dc.w $80A0,z80_ptr(s5Fs3),$0000
+		dc.b $E1,$10
+		dc.b $EF,$01,$F0,$01,$01,$EC,$56,$C0,$24,$F4,$EF,$00,$E6,$F0
-		dc.b $BB,$02,$E7,$E6,$02,$E9
		dc.w $01F7,$0020,z80_ptr(-)
		dc.b $F2
ssamp6C:	dc.b $00,$53,$30,$03,$30,$1F,$1F,$1F,$1F,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$00,$00,$00,$0F,$0F,$06,$23,$80
		dc.b $3C,$72,$32,$32,$72,$14,$14,$0F,$0F,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$02,$02,$08,$08,$35,$14,$00,$00

; error sound
Sound6D:	dc.w z80_ptr(ssamp6D),$0101
		dc.w $8005,z80_ptr(+),$0004
+		dc.b $EF,$00,$B0,$06,$80,$06,$B0,$18,$F2
ssamp6D:	dc.b $38,$00,$00,$00,$00,$1F,$1F,$1F,$1F,$00,$00,$00
		dc.b $00,$00,$00,$00,$00,$0F,$0F,$0F,$0F,$1F,$0C,$17,$00

; silver sonic buzz saw
Sound6E:	dc.w z80_ptr(ssamp6E),$0102
		dc.w $8005,z80_ptr(+),$0000
		dc.w $80C0,z80_ptr(++),$0000
+		dc.b $EF,$00,$C6,$24,$E7
-		dc.b $C6,$04,$E7,$E6
		dc.w $04F7,$0008,z80_ptr(-)
		dc.b $F2
+		dc.b $F3,$E7,$C7,$44,$F2
ssamp6E:	dc.b $33,$00,$10,$00,$31,$1F,$1D,$1E,$0E,$00,$0C,$1D
		dc.b $00,$00,$00,$01,$00,$0F,$0F,$0F,$0F,$08,$06,$07,$80


Sound6F:	dc.w z80_ptr(ssamp6A),$0103
		dc.w $8005,z80_ptr(++),$000B
		dc.w $8004,z80_ptr(+),$0012
		dc.w $80C0,z80_ptr(+++),$0000
+		dc.b $E1,$02,$80,$02
+		dc.b $EF,$00,$E6,$0C,$DF,$06,$E7,$E6,$F4,$06,$E7
		dc.b $E6,$F4,$12,$E7,$E6,$0C,$06,$E7,$E6,$0C,$06,$F2
+		dc.b $F3,$E7,$C6,$04,$C0,$BA,$B4,$AE,$E6
		dc.b $01,$AE,$E6,$01,$AE,$E6,$01,$AE,$F2


Sound70:	dc.w $0000,$0101
		dc.w $80C0,z80_ptr(+),$0000
+		dc.b $F3,$E7,$C6,$18
-		dc.b $E7,$03,$E6
		dc.w $01F7,$0008,z80_ptr(-)
		dc.b $F2


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
