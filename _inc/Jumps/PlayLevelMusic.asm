; loc_F626:
PlayLevelMusic:
	move.w	(Level_Music).w,d0
	jmpto	(PlayMusic).l, JmpTo3_PlayMusic
; ===========================================================================