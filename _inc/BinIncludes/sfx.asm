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

