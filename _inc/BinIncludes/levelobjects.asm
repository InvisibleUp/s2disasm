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
