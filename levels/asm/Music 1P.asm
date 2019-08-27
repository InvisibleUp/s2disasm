;----------------------------------------------------------------------------
; 1P Music Playlist
;----------------------------------------------------------------------------
; byte_3EA0:
MusicList: zoneOrderedTable 1,1
	zoneTableEntry.b MusID_EHZ	; 0 ; EHZ
	zoneTableEntry.b MusID_EHZ	; 1
	zoneTableEntry.b MusID_MTZ	; 2
	zoneTableEntry.b MusID_OOZ	; 3
	zoneTableEntry.b MusID_MTZ	; 4 ; MTZ1,2
	zoneTableEntry.b MusID_MTZ	; 5 ; MTZ3
	zoneTableEntry.b MusID_WFZ	; 6 ; WFZ
	zoneTableEntry.b MusID_HTZ	; 7 ; HTZ
	zoneTableEntry.b MusID_HPZ	; 8
	zoneTableEntry.b MusID_SCZ	; 9
	zoneTableEntry.b MusID_OOZ	; 10 ; OOZ
	zoneTableEntry.b MusID_MCZ	; 11 ; MCZ
	zoneTableEntry.b MusID_CNZ	; 12 ; CNZ
	zoneTableEntry.b MusID_CPZ	; 13 ; CPZ
	zoneTableEntry.b MusID_DEZ	; 14 ; DEZ
	zoneTableEntry.b MusID_ARZ	; 15 ; ARZ
	zoneTableEntry.b MusID_SCZ	; 16 ; SCZ
    zoneTableEnd
	even