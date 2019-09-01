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