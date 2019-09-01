Animated_MTZ:	zoneanimstart
	; Spinning metal cylinder
	zoneanimdecl 0, ArtUnc_MTZCylinder, ArtTile_ArtUnc_MTZCylinder, 8,$10
	dc.b   0
	dc.b $10
	dc.b $20
	dc.b $30
	dc.b $40
	dc.b $50
	dc.b $60
	dc.b $70
	even
	; lava
	zoneanimdecl $D, ArtUnc_Lava, ArtTile_ArtUnc_Lava, 6,$C
	dc.b   0
	dc.b  $C
	dc.b $18
	dc.b $24
	dc.b $18
	dc.b  $C
	even
	; MTZ background animated section
	zoneanimdecl -1, ArtUnc_MTZAnimBack, ArtTile_ArtUnc_MTZAnimBack_1, 4, 6
	dc.b   0,$13
	dc.b   6,  7
	dc.b  $C,$13
	dc.b   6,  7
	even
	; MTZ background animated section
	zoneanimdecl -1, ArtUnc_MTZAnimBack, ArtTile_ArtUnc_MTZAnimBack_2, 4, 6
	dc.b  $C,$13
	dc.b   6,  7
	dc.b   0,$13
	dc.b   6,  7
	even

	zoneanimend