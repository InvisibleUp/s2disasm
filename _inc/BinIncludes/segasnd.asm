; ----------------------------------------------------------------------------------
; Filler (free space)
; ----------------------------------------------------------------------------------
	; the PCM data has to line up with the end of the bank.
	cnop -Size_of_SEGA_sound, $8000

; -------------------------------------------------------------------------------
; Sega Intro Sound
; 8-bit unsigned raw audio at 16Khz
; -------------------------------------------------------------------------------
; loc_F1E8C:
Snd_Sega:	BINCLUDE	"sound/PCM/SEGA.bin"
Snd_Sega_End:

	if Snd_Sega_End - Snd_Sega > $8000
		fatal "Sega sound must fit within $8000 bytes, but you have a $\{Snd_Sega_End-Snd_Sega} byte Sega sound."
	endif
	if Snd_Sega_End - Snd_Sega > Size_of_SEGA_sound
		fatal "Size_of_SEGA_sound = $\{Size_of_SEGA_sound}, but you have a $\{Snd_Sega_End-Snd_Sega} byte Sega sound."
	endif
