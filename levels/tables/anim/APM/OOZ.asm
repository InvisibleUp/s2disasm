; byte_405B6:
APM_OOZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_OOZPulseBall+$0,0,0,0,1),make_block_tile(ArtTile_ArtUnc_OOZPulseBall+$2,0,0,0,1)
	dc.w make_block_tile(ArtTile_ArtUnc_OOZPulseBall+$1,0,0,0,1),make_block_tile(ArtTile_ArtUnc_OOZPulseBall+$3,0,0,0,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall1+$0,0,0,3,1),make_block_tile(ArtTile_ArtUnc_OOZSquareBall1+$1,0,0,3,1)
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall1+$2,0,0,3,1),make_block_tile(ArtTile_ArtUnc_OOZSquareBall1+$3,0,0,3,1)
	
    if gameRevision<2
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0),make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$2,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$1,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$3,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,0,0)
    else
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$0,0,0,3,0)
	dc.w make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$2,0,0,3,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$1,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_OOZSquareBall2+$3,0,0,3,0),make_block_tile(ArtTile_ArtKos_LevelArt+$0,0,0,2,0)
    endif
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$0,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$1,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$8,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$9,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$2,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$3,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$A,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$B,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$4,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$5,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$C,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$D,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$6,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$7,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil1+$E,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil1+$F,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$0,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$1,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$8,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$9,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$2,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$3,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$A,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$B,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$4,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$5,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$C,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$D,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$6,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$7,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Oil2+$E,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Oil2+$F,0,0,2,1)
APM_OOZ_End:
