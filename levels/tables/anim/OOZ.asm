; word_400C8:  Animated_OOZ2:
Animated_OOZ:	zoneanimstart
	; Pulsing ball from OOZ
	zoneanimdecl -1, ArtUnc_OOZPulseBall, ArtTile_ArtUnc_OOZPulseBall, 4, 4
	dc.b   0, $B
	dc.b   4,  5
	dc.b   8,  9
	dc.b   4,  3
	even
	; Square rotating around ball in OOZ
	zoneanimdecl 6, ArtUnc_OOZSquareBall1, ArtTile_ArtUnc_OOZSquareBall1, 4, 4
	dc.b   0
	dc.b   4
	dc.b   8
	dc.b  $C
	even
	; Square rotating around ball
	zoneanimdecl 6, ArtUnc_OOZSquareBall2, ArtTile_ArtUnc_OOZSquareBall2, 4, 4
	dc.b   0
	dc.b   4
	dc.b   8
	dc.b  $C
	even
	; Oil
	zoneanimdecl $11, ArtUnc_Oil1, ArtTile_ArtUnc_Oil1, 6,$10
	dc.b   0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $20
	dc.b $10
	even
	; Oil
	zoneanimdecl $11, ArtUnc_Oil2, ArtTile_ArtUnc_Oil2, 6,$10
	dc.b   0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $20
	dc.b $10
	even

	zoneanimend