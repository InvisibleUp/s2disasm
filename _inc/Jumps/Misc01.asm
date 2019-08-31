    if gameRevision<2
	nop
    endif

    if ~~removeJmpTos
JmpTo_SingleObjLoad 
	jmp	(SingleObjLoad).l
JmpTo3_PlaySound 
	jmp	(PlaySound).l
; JmpTo2_PalLoad2 
JmpTo2_PalLoad_Now 
	jmp	(PalLoad_Now).l
JmpTo2_LoadPLC 
	jmp	(LoadPLC).l
JmpTo3_PlayMusic 
	jmp	(PlayMusic).l

	align 4
    endif