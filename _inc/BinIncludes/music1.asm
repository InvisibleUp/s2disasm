; ---------------------------------------------------------------------------
; Music pointers
; ---------------------------------------------------------------------------
; loc_F0000:
MusicPoint1:	startBank
MusPtr_Continue:	rom_ptr_z80	Mus_Continue


Mus_Continue:   BINCLUDE	"sound/music/Continue.bin"

