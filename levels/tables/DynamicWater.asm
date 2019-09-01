    if useFullWaterTables
Dynamic_water_routine_table: zoneOrderedOffsetTable 2,2
	zoneOffsetTableEntry.w DynamicWaterNull ; EHZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; EHZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 1
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 1
	zoneOffsetTableEntry.w DynamicWaterNull ; WZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; WZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 3
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 3
	zoneOffsetTableEntry.w DynamicWaterNull ; MTZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; MTZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; MTZ 3
	zoneOffsetTableEntry.w DynamicWaterNull ; MTZ 4
	zoneOffsetTableEntry.w DynamicWaterNull ; WFZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; WFZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; HTZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; HTZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; HPZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; HPZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 9
	zoneOffsetTableEntry.w DynamicWaterNull ; Zone 9
	zoneOffsetTableEntry.w DynamicWaterNull ; OOZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; OOZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; MCZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; MCZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; CNZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; CNZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; CPZ 1
	zoneOffsetTableEntry.w DynamicWaterCPZ2 ; CPZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; DEZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; DEZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; ARZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; ARZ 2
	zoneOffsetTableEntry.w DynamicWaterNull ; SCZ 1
	zoneOffsetTableEntry.w DynamicWaterNull ; SCZ 2
    zoneTableEnd
    else
; off_45D8:
Dynamic_water_routine_table: offsetTable
	offsetTableEntry.w DynamicWaterNull ; HPZ 1
	offsetTableEntry.w DynamicWaterNull ; HPZ 2
	offsetTableEntry.w DynamicWaterNull ; Zone 9
	offsetTableEntry.w DynamicWaterNull ; Zone 9
	offsetTableEntry.w DynamicWaterNull ; OOZ 1
	offsetTableEntry.w DynamicWaterNull ; OOZ 2
	offsetTableEntry.w DynamicWaterNull ; MCZ 1
	offsetTableEntry.w DynamicWaterNull ; MCZ 2
	offsetTableEntry.w DynamicWaterNull ; CNZ 1
	offsetTableEntry.w DynamicWaterNull ; CNZ 2
	offsetTableEntry.w DynamicWaterNull ; CPZ 1
	offsetTableEntry.w DynamicWaterCPZ2 ; CPZ 2
	offsetTableEntry.w DynamicWaterNull ; DEZ 1
	offsetTableEntry.w DynamicWaterNull ; DEZ 2
	offsetTableEntry.w DynamicWaterNull ; ARZ 1
	offsetTableEntry.w DynamicWaterNull ; ARZ 2
    endif
; ===========================================================================
; return_45F8:
DynamicWaterNull:
	rts
; ===========================================================================
; loc_45FA:
DynamicWaterCPZ2:
	cmpi.w	#$1DE0,(Camera_X_pos).w
	blo.s	+	; rts
	move.w	#$510,(Water_Level_3).w
+	rts
