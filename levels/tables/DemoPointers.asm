; ---------------------------------------------------------------------------
; DEMO SCRIPT POINTERS

; Contains an array of pointers to the script controlling the players actions
; to use for each level.
; ---------------------------------------------------------------------------
; off_4948:
DemoScriptPointers: zoneOrderedTable 4,1
	zoneTableEntry.l Demo_EHZ	; $00
	zoneTableEntry.l Demo_EHZ	; $01
	zoneTableEntry.l Demo_EHZ	; $02
	zoneTableEntry.l Demo_EHZ	; $03
	zoneTableEntry.l Demo_EHZ	; $04
	zoneTableEntry.l Demo_EHZ	; $05
	zoneTableEntry.l Demo_EHZ	; $06
	zoneTableEntry.l Demo_EHZ	; $07
	zoneTableEntry.l Demo_EHZ	; $08
	zoneTableEntry.l Demo_EHZ	; $09
	zoneTableEntry.l Demo_EHZ	; $0A
	zoneTableEntry.l Demo_EHZ	; $0B
	zoneTableEntry.l Demo_CNZ	; $0C
	zoneTableEntry.l Demo_CPZ	; $0D
	zoneTableEntry.l Demo_EHZ	; $0E
	zoneTableEntry.l Demo_ARZ	; $0F
	zoneTableEntry.l Demo_EHZ	; $10
    zoneTableEnd
; ---------------------------------------------------------------------------
; dword_498C:
EndingDemoScriptPointers:
	; these values are invalid addresses, but they were used for the ending
	; demos, which aren't present in Sonic 2
	dc.l   $8B0837
	dc.l   $42085C	; 1
	dc.l   $6A085F	; 2
	dc.l   $2F082C	; 3
	dc.l   $210803	; 4
	dc.l $28300808	; 5
	dc.l   $2E0815	; 6
	dc.l	$F0846	; 7
	dc.l   $1A08FF	; 8
	dc.l  $8CA0000	; 9
	dc.l	     0	; 10
	dc.l	     0	; 11
