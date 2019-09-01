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
