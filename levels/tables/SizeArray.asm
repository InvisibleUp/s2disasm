; ----------------------------------------------------------------------------
; LEVEL SIZE ARRAY

; This array defines the screen boundaries for each act in the game.
; ----------------------------------------------------------------------------
;				xstart	xend	ystart	yend	; ZID ; Zone
LevelSize: zoneOrderedTable 2,8	; WrdArr_LvlSize
	zoneTableEntry.w	$0,	$29A0,	$0,	$320	; EHZ act 1
	zoneTableEntry.w	$0,	$2940,	$0,	$420	; EHZ act 2
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; $01
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; $02
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; $03
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
	zoneTableEntry.w	$0,	$2280,	-$100,	$800	; MTZ act 1
	zoneTableEntry.w	$0,	$1E80,	-$100,	$800	; MTZ act 2
	zoneTableEntry.w	$0,	$2A80,	-$100,	$800	; MTZ act 3
	zoneTableEntry.w	$0,	$3FFF,	-$100,	$800
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; WFZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
	zoneTableEntry.w	$0,	$2800,	$0,	$720	; HTZ act 1
	zoneTableEntry.w	$0,	$3280,	$0,	$720	; HTZ act 2
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; $08
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720	; $09
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
	zoneTableEntry.w	$0,	$2F80,	$0,	$680	; OOZ act 1
	zoneTableEntry.w	$0,	$2D00,	$0,	$680	; OOZ act 2
	zoneTableEntry.w	$0,	$2380,	$3C0,	$720	; MCZ act 1
	zoneTableEntry.w	$0,	$3FFF,	$60,	$720	; MCZ act 2
	zoneTableEntry.w	$0,	$27A0,	$0,	$720	; CNZ act 1
	zoneTableEntry.w	$0,	$2A80,	$0,	$720	; CNZ act 2
	zoneTableEntry.w	$0,	$2780,	$0,	$720	; CPZ act 1
	zoneTableEntry.w	$0,	$2A80,	$0,	$720	; CPZ act 2
	zoneTableEntry.w	$0,	$1000,	$C8,	 $C8	; DEZ
	zoneTableEntry.w	$0,	$1000,  $C8,	 $C8
	zoneTableEntry.w	$0,	$28C0,	$200,	$600	; ARZ act 1
	zoneTableEntry.w	$0,	$3FFF,	$180,	$710	; ARZ act 2
	zoneTableEntry.w	$0,	$3FFF,	$0,	$000	; SCZ
	zoneTableEntry.w	$0,	$3FFF,	$0,	$720
    zoneTableEnd
