; ---------------------------------------------------------------------------
; Pointers to primary collision indexes

; Contains an array of pointers to the primary collision index data for each
; level. 1 pointer for each level, pointing the primary collision index.
; ---------------------------------------------------------------------------
Off_ColP: zoneOrderedTable 4,1
	zoneTableEntry.l ColP_EHZHTZ
	zoneTableEntry.l ColP_Invalid	; 1
	zoneTableEntry.l ColP_MTZ	; 2
	zoneTableEntry.l ColP_Invalid	; 3
	zoneTableEntry.l ColP_MTZ	; 4
	zoneTableEntry.l ColP_MTZ	; 5
	zoneTableEntry.l ColP_WFZSCZ	; 6
	zoneTableEntry.l ColP_EHZHTZ	; 7
	zoneTableEntry.l ColP_HPZ	; 8
	zoneTableEntry.l ColP_Invalid	; 9
	zoneTableEntry.l ColP_OOZ	; 10
	zoneTableEntry.l ColP_MCZ	; 11
	zoneTableEntry.l ColP_CNZ	; 12
	zoneTableEntry.l ColP_CPZDEZ	; 13
	zoneTableEntry.l ColP_CPZDEZ	; 14
	zoneTableEntry.l ColP_ARZ	; 15
	zoneTableEntry.l ColP_WFZSCZ	; 16
    zoneTableEnd

; ---------------------------------------------------------------------------
; Pointers to secondary collision indexes

; Contains an array of pointers to the secondary collision index data for
; each level. 1 pointer for each level, pointing the secondary collision
; index.
; ---------------------------------------------------------------------------
Off_ColS: zoneOrderedTable 4,1
	zoneTableEntry.l ColS_EHZHTZ
	zoneTableEntry.l ColP_Invalid	; 1
	zoneTableEntry.l ColP_MTZ	; 2
	zoneTableEntry.l ColP_Invalid	; 3
	zoneTableEntry.l ColP_MTZ	; 4
	zoneTableEntry.l ColP_MTZ	; 5
	zoneTableEntry.l ColS_WFZSCZ	; 6
	zoneTableEntry.l ColS_EHZHTZ	; 7
	zoneTableEntry.l ColS_HPZ	; 8
	zoneTableEntry.l ColP_Invalid	; 9
	zoneTableEntry.l ColP_OOZ	; 10
	zoneTableEntry.l ColP_MCZ	; 11
	zoneTableEntry.l ColS_CNZ	; 12
	zoneTableEntry.l ColS_CPZDEZ	; 13
	zoneTableEntry.l ColS_CPZDEZ	; 14
	zoneTableEntry.l ColS_ARZ	; 15
	zoneTableEntry.l ColS_WFZSCZ	; 16
    zoneTableEnd