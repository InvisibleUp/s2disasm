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
