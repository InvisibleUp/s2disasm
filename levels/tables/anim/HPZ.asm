; word_4009C: Animated_OOZ:
Animated_HPZ:	zoneanimstart
	; Supposed to be the pulsing orb from HPZ, but uses OOZ's pulsing ball art
	zoneanimdecl 8, ArtUnc_HPZPulseOrb, ArtTile_ArtUnc_HPZPulseOrb_1, 6, 8
	dc.b   0
	dc.b   0
	dc.b   8
	dc.b $10
	dc.b $10
	dc.b   8
	even
	; Supposed to be the pulsing orb from HPZ, but uses OOZ's pulsing ball art
	zoneanimdecl 8, ArtUnc_HPZPulseOrb, ArtTile_ArtUnc_HPZPulseOrb_2, 6, 8
	dc.b   8
	dc.b $10
	dc.b $10
	dc.b   8
	dc.b   0
	dc.b   0
	even
	; Supposed to be the pulsing orb from HPZ, but uses OOZ's pulsing ball art
	zoneanimdecl 8, ArtUnc_HPZPulseOrb, ArtTile_ArtUnc_HPZPulseOrb_3, 6, 8
	dc.b $10
	dc.b   8
	dc.b   0
	dc.b   0
	dc.b   8
	dc.b $10
	even

	zoneanimend