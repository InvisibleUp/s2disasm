; ---------------------------------------------------------------------------
; OBJECT DEBUG LISTS

; The jump table goes by level ID, so Metropolis Zone's list is repeated to
; account for its third act. Hidden Palace Zone uses Oil Ocean Zone's list.
; ---------------------------------------------------------------------------
JmpTbl_DbgObjLists: zoneOrderedOffsetTable 2,1
	zoneOffsetTableEntry.w DbgObjList_EHZ	; 0
	zoneOffsetTableEntry.w DbgObjList_Def	; 1
	zoneOffsetTableEntry.w DbgObjList_Def	; 2
	zoneOffsetTableEntry.w DbgObjList_Def	; 3
	zoneOffsetTableEntry.w DbgObjList_MTZ	; 4
	zoneOffsetTableEntry.w DbgObjList_MTZ	; 5
	zoneOffsetTableEntry.w DbgObjList_WFZ	; 6
	zoneOffsetTableEntry.w DbgObjList_HTZ	; 7
	zoneOffsetTableEntry.w DbgObjList_HPZ	; 8
	zoneOffsetTableEntry.w DbgObjList_Def	; 9
	zoneOffsetTableEntry.w DbgObjList_OOZ	; $A
	zoneOffsetTableEntry.w DbgObjList_MCZ	; $B
	zoneOffsetTableEntry.w DbgObjList_CNZ	; $C
	zoneOffsetTableEntry.w DbgObjList_CPZ	; $D
	zoneOffsetTableEntry.w DbgObjList_Def	; $E
	zoneOffsetTableEntry.w DbgObjList_ARZ	; $F
	zoneOffsetTableEntry.w DbgObjList_SCZ	; $10
    zoneTableEnd

; macro for a debug object list header
; must be on the same line as a label that has a corresponding _End label later
dbglistheader macro {INTLABEL}
__LABEL__ label *
	dc.w ((__LABEL___End - __LABEL__ - 2) >> 3)
    endm

; macro to define debug list object data
dbglistobj macro   obj, mapaddr, subtype, frame, vram
	dc.l obj<<24|mapaddr
	dc.b subtype,frame
	dc.w vram
    endm
