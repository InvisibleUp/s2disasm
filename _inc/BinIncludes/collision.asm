;---------------------------------------------------------------------------------------
; Curve and resistance mapping
;---------------------------------------------------------------------------------------
ColCurveMap:	BINCLUDE	"collision/Curve and resistance mapping.bin"
	even
;--------------------------------------------------------------------------------------
; Collision arrays
;--------------------------------------------------------------------------------------
ColArray:	BINCLUDE	"collision/Collision array 1.bin"
ColArray2:	BINCLUDE	"collision/Collision array 2.bin"
	even
;---------------------------------------------------------------------------------------
; EHZ and HTZ primary 16x16 collision index (Kosinski compression)
ColP_EHZHTZ:	BINCLUDE	"collision/EHZ and HTZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; EHZ and HTZ secondary 16x16 collision index (Kosinski compression)
ColS_EHZHTZ:	BINCLUDE	"collision/EHZ and HTZ secondary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; MTZ primary 16x16 collision index (Kosinski compression)
ColP_MTZ:	BINCLUDE	"collision/MTZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; HPZ primary 16x16 collision index (Kosinski compression)
ColP_HPZ:	;BINCLUDE	"collision/HPZ primary 16x16 collision index.bin"
	;even
;---------------------------------------------------------------------------------------
; HPZ secondary 16x16 collision index (Kosinski compression)
ColS_HPZ:	;BINCLUDE	"collision/HPZ secondary 16x16 collision index.bin"
	;even
;---------------------------------------------------------------------------------------
; OOZ primary 16x16 collision index (Kosinski compression)
ColP_OOZ:	BINCLUDE	"collision/OOZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; MCZ primary 16x16 collision index (Kosinski compression)
ColP_MCZ:	BINCLUDE	"collision/MCZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; CNZ primary 16x16 collision index (Kosinski compression)
ColP_CNZ:	BINCLUDE	"collision/CNZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; CNZ secondary 16x16 collision index (Kosinski compression)
ColS_CNZ:	BINCLUDE	"collision/CNZ secondary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; CPZ and DEZ primary 16x16 collision index (Kosinski compression)
ColP_CPZDEZ:	BINCLUDE	"collision/CPZ and DEZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; CPZ and DEZ secondary 16x16 collision index (Kosinski compression)
ColS_CPZDEZ:	BINCLUDE	"collision/CPZ and DEZ secondary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; ARZ primary 16x16 collision index (Kosinski compression)
ColP_ARZ:	BINCLUDE	"collision/ARZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; ARZ secondary 16x16 collision index (Kosinski compression)
ColS_ARZ:	BINCLUDE	"collision/ARZ secondary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; WFZ/SCZ primary 16x16 collision index (Kosinski compression)
ColP_WFZSCZ:	BINCLUDE	"collision/WFZ and SCZ primary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------
; WFZ/SCZ secondary 16x16 collision index (Kosinski compression)
ColS_WFZSCZ:	BINCLUDE	"collision/WFZ and SCZ secondary 16x16 collision index.bin"
	even
;---------------------------------------------------------------------------------------

ColP_Invalid:
