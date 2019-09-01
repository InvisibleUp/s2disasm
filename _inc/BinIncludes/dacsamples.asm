; ---------------------------------------------------------------------------
; Filler (free space)
; ---------------------------------------------------------------------------
	; the DAC data has to line up with the end of the bank.

	; actually it only has to fit within one bank, but we'll line it up to the end anyway
	; because the padding gives the sound driver some room to grow
	cnop -Size_of_DAC_samples, $8000

; ---------------------------------------------------------------------------
; DAC samples
; ---------------------------------------------------------------------------
; loc_ED100:
SndDAC_Start:

SndDAC_Sample1:
	BINCLUDE	"sound/DAC/Sample 1.bin"
SndDAC_Sample1_End

SndDAC_Sample2:
	BINCLUDE	"sound/DAC/Sample 2.bin"
SndDAC_Sample2_End

SndDAC_Sample5:
	BINCLUDE	"sound/DAC/Sample 5.bin"
SndDAC_Sample5_End

SndDAC_Sample6:
	BINCLUDE	"sound/DAC/Sample 6.bin"
SndDAC_Sample6_End

SndDAC_Sample3:
	BINCLUDE	"sound/DAC/Sample 3.bin"
SndDAC_Sample3_End

SndDAC_Sample4:
	BINCLUDE	"sound/DAC/Sample 4.bin"
SndDAC_Sample4_End

SndDAC_Sample7:
	BINCLUDE	"sound/DAC/Sample 7.bin"
SndDAC_Sample7_End

SndDAC_End

	if SndDAC_End - SndDAC_Start > $8000
		fatal "DAC samples must fit within $8000 bytes, but you have $\{SndDAC_End-SndDAC_Start } bytes of DAC samples."
	endif
	if SndDAC_End - SndDAC_Start > Size_of_DAC_samples
		fatal "Size_of_DAC_samples = $\{Size_of_DAC_samples}, but you have $\{SndDAC_End-SndDAC_Start} bytes of DAC samples."
	endif
