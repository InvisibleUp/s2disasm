; word_40160:
Animated_CNZ_2P:	zoneanimstart
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_2_2p, $10,$10
	dc.b   0,$C7
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,$C7
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	dc.b   0,  5
	dc.b $10,  5
	dc.b $20,  5
	dc.b $30,  5
	dc.b $40,  5
	dc.b $50,  5
	dc.b $20,  5
	dc.b $60,  5
	even
	; Flipping foreground section in CNZ
	zoneanimdecl -1, ArtUnc_CNZFlipTiles, ArtTile_ArtUnc_CNZFlipTiles_1_2p, $10,$10
	dc.b $70,  5
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,  5
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	dc.b $70,$C7
	dc.b $80,  5
	dc.b $20,  5
	dc.b $90,  5
	dc.b $A0,$C7
	dc.b $B0,  5
	dc.b $20,  5
	dc.b $C0,  5
	even

	zoneanimend
