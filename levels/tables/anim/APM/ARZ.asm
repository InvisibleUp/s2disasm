; byte_4077A:
APM_ARZ:	begin_animpat
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall3+$0  ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall3+$1  ,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall3+$2  ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall3+$3  ,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall2+$0  ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall2+$1  ,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall2+$2  ,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall2+$3  ,0,0,2,1)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$0,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$1,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$2,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$3,0,0,2,1)
	
    if 1==0
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$0,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$1,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$2,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$3,0,0,2,1)
    else
	; These are invalid animation entries for waterfalls (bug in original game):
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$C,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$D,0,0,2,1)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$E,0,0,2,1),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$F,0,0,2,1)
    endif
	
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall3+$0  ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall3+$1  ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall3+$2  ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall3+$3  ,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall2+$0  ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall2+$1  ,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall2+$2  ,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall2+$3  ,0,0,2,0)
	
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$2,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_1+$3,0,0,2,0)
	
    if 1==0
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$0,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$1,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$2,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$3,0,0,2,0)
    else
	; These are invalid animation entries for waterfalls (bug in original game):
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$C,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$D,0,0,2,0)
	dc.w make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$E,0,0,2,0),make_block_tile(ArtTile_ArtUnc_Waterfall1_2+$F,0,0,2,0)
    endif
APM_ARZ_End:
