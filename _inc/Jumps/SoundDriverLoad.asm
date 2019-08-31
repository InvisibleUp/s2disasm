; JumpTo load the sound driver
; sub_130A:
JmpTo_SoundDriverLoad 
	nop
	jmp	(SoundDriverLoad).l
; End of function JmpTo_SoundDriverLoad