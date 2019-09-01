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
