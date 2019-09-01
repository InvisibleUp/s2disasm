; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; LEVEL ART AND BLOCK MAPPINGS (16x16 and 128x128)
;
; #define BLOCK_TBL_LEN  // table length unknown
; #define BIGBLOCK_TBL_LEN // table length unknown
; typedef uint16_t uword
;
; struct blockMapElement {
;  uword unk : 5;    // u
;  uword patternIndex : 11; };  // i
; // uuuu uiii iiii iiii
;
; blockMapElement (*blockMapTable)[BLOCK_TBL_LEN][4] = 0xFFFF9000
;
; struct bigBlockMapElement {
;  uword : 4
;  uword blockMapIndex : 12; };  //I
; // 0000 IIII IIII IIII
;
; bigBlockMapElement (*bigBlockMapTable)[BIGBLOCK_TBL_LEN][64] = 0xFFFF0000
;
; /*
; This data determines how the level blocks will be constructed graphically. There are
; two kinds of block mappings: 16x16 and 128x128.
;
; 16x16 blocks are made up of four cells arranged in a square (thus, 16x16 pixels).
; Two bytes are used to define each cell, so the block is 8 bytes long. It can be
; represented by the bitmap blockMapElement, of which the members are:
;
; unk
;  These bits have to do with pattern orientation. I do not know their exact
;  meaning.
; patternIndex
;  The pattern's address divided by $20. Otherwise said: an index into the
;  pattern array.
;
; Each mapping can be expressed as an array of four blockMapElements, while the
; whole table is expressed as a two-dimensional array of blockMapElements (blockMapTable).
; The maps are read in left-to-right, top-to-bottom order.
;
; 128x128 maps are basically lists of indices into blockMapTable. The levels are built
; out of these "big blocks", rather than the "small" 16x16 blocks. bigBlockMapTable is,
; predictably, the table of big block mappings.
; Each big block is 8 16x16 blocks, or 16 cells, square. This produces a total of 16
; blocks or 64 cells.
; As noted earlier, each element of the table provides 'i' for blockMapTable[i][j].
; */

;----------------------------------------------------------------------------------
; EHZ 16x16 block mappings (Kosinski compression) ; was: (Kozinski compression)
BM16_EHZ:	BINCLUDE	"mappings/16x16/EHZ.bin"
;-----------------------------------------------------------------------------------
; EHZ/HTZ main level patterns (Kosinski compression)
; ArtKoz_95C24:
ArtKos_EHZ:	BINCLUDE	"art/kosinski/EHZ_HTZ.bin"
;-----------------------------------------------------------------------------------
; HTZ 16x16 block mappings (Kosinski compression)
BM16_HTZ:	BINCLUDE	"mappings/16x16/HTZ.bin"
;-----------------------------------------------------------------------------------
; HTZ pattern suppliment to EHZ level patterns (Kosinski compression)
; ArtKoz_98AB4:
ArtKos_HTZ:	BINCLUDE	"art/kosinski/HTZ_Supp.bin"
;-----------------------------------------------------------------------------------
; EHZ/HTZ 128x128 block mappings (Kosinski compression)
BM128_EHZ:	BINCLUDE	"mappings/128x128/EHZ_HTZ.bin"
;-----------------------------------------------------------------------------------
; MTZ 16x16 block mappings (Kosinski compression)
BM16_MTZ:	BINCLUDE	"mappings/16x16/MTZ.bin"
;-----------------------------------------------------------------------------------
; MTZ main level patterns (Kosinski compression)
; ArtKoz_9DB64:
ArtKos_MTZ:	BINCLUDE	"art/kosinski/MTZ.bin"
;-----------------------------------------------------------------------------------
; MTZ 128x128 block mappings (Kosinski compression)
BM128_MTZ:	BINCLUDE	"mappings/128x128/MTZ.bin"
;-----------------------------------------------------------------------------------
; HPZ 16x16 block mappings (Kosinski compression)
BM16_HPZ:	;BINCLUDE	"mappings/16x16/HPZ.bin"
;-----------------------------------------------------------------------------------
; HPZ main level patterns (Kosinski compression)
ArtKos_HPZ:	;BINCLUDE	"art/kosinski/HPZ.bin"
;-----------------------------------------------------------------------------------
; HPZ 128x128 block mappings (Kosinski compression)
BM128_HPZ:	;BINCLUDE	"mappings/128x128/HPZ.bin"
;-----------------------------------------------------------------------------------
; OOZ 16x16 block mappings (Kosinski compression)
BM16_OOZ:	BINCLUDE	"mappings/16x16/OOZ.bin"
;-----------------------------------------------------------------------------------
; OOZ main level patterns (Kosinski compression)
; ArtKoz_A4204:
ArtKos_OOZ:	BINCLUDE	"art/kosinski/OOZ.bin"
;-----------------------------------------------------------------------------------
; OOZ 128x128 block mappings (Kosinski compression)
BM128_OOZ:	BINCLUDE	"mappings/128x128/OOZ.bin"
;-----------------------------------------------------------------------------------
; MCZ 16x16 block mappings (Kosinski compression)
BM16_MCZ:	BINCLUDE	"mappings/16x16/MCZ.bin"
;-----------------------------------------------------------------------------------
; MCZ main level patterns (Kosinski compression)
; ArtKoz_A9D74:
ArtKos_MCZ:	BINCLUDE	"art/kosinski/MCZ.bin"
;-----------------------------------------------------------------------------------
; MCZ 128x128 block mappings (Kosinski compression)
BM128_MCZ:	BINCLUDE	"mappings/128x128/MCZ.bin"
;-----------------------------------------------------------------------------------
; CNZ 16x16 block mappings (Kosinski compression)
BM16_CNZ:	BINCLUDE	"mappings/16x16/CNZ.bin"
;-----------------------------------------------------------------------------------
; CNZ main level patterns (Kosinski compression)
; ArtKoz_B0894:
ArtKos_CNZ:	BINCLUDE	"art/kosinski/CNZ.bin"
;-----------------------------------------------------------------------------------
; CNZ 128x128 block mappings (Kosinski compression)
BM128_CNZ:	BINCLUDE	"mappings/128x128/CNZ.bin"
;-----------------------------------------------------------------------------------
; CPZ/DEZ 16x16 block mappings (Kosinski compression)
BM16_CPZ:	BINCLUDE	"mappings/16x16/CPZ_DEZ.bin"
;-----------------------------------------------------------------------------------
; CPZ/DEZ main level patterns (Kosinski compression)
; ArtKoz_B6174:
ArtKos_CPZ:	BINCLUDE	"art/kosinski/CPZ_DEZ.bin"
;-----------------------------------------------------------------------------------
; CPZ/DEZ 128x128 block mappings (Kosinski compression)
BM128_CPZ:	BINCLUDE	"mappings/128x128/CPZ_DEZ.bin"
;-----------------------------------------------------------------------------------
; ARZ 16x16 block mappings (Kosinski compression)
BM16_ARZ:	BINCLUDE	"mappings/16x16/ARZ.bin"
;-----------------------------------------------------------------------------------
; ARZ main level patterns (Kosinski compression)
; ArtKoz_BCC24:
ArtKos_ARZ:	BINCLUDE	"art/kosinski/ARZ.bin"
;-----------------------------------------------------------------------------------
; ARZ 128x128 block mappings (Kosinski compression)
BM128_ARZ:	BINCLUDE	"mappings/128x128/ARZ.bin"
;-----------------------------------------------------------------------------------
; WFZ/SCZ 16x16 block mappings (Kosinski compression)
BM16_WFZ:	BINCLUDE	"mappings/16x16/WFZ_SCZ.bin"
;-----------------------------------------------------------------------------------
; WFZ/SCZ main level patterns (Kosinski compression)
; ArtKoz_C5004:
ArtKos_SCZ:	BINCLUDE	"art/kosinski/WFZ_SCZ.bin"
;-----------------------------------------------------------------------------------
; WFZ pattern suppliment to SCZ tiles (Kosinski compression)
; ArtKoz_C7EC4:
ArtKos_WFZ:	BINCLUDE	"art/kosinski/WFZ_Supp.bin"
;-----------------------------------------------------------------------------------
; WFZ/SCZ 128x128 block mappings (Kosinski compression)
BM128_WFZ:	BINCLUDE	"mappings/128x128/WFZ_SCZ.bin"
