; ---------------------------------------------------------------------------
; PATTERN LOAD REQUEST LISTS
;
; Pattern load request lists are simple structures used to load
; Nemesis-compressed art for sprites.
;
; The decompressor predictably moves down the list, so request 0 is processed first, etc.
; This only matters if your addresses are bad and you overwrite art loaded in a previous request.
;

; NOTICE: The load queue buffer can only hold $10 (16) load requests. None of the routines
; that load PLRs into the queue do any bounds checking, so it's possible to create a buffer
; overflow and completely screw up the variables stored directly after the queue buffer.
; (in my experience this is a guaranteed crash or hang)
;
; Many levels queue more than 16 items overall,
; but they don't exceed the limit because
; their PLRs are split into multiple parts (like PlrList_Mtz1 and PlrList_Mtz2)
; and they fully process the first part before requesting the rest.
; 
; If you can find some extra RAM for it (which is easy in Sonic 2),
; you can increase this limit by increasing the size of Plc_Buffer.
; ---------------------------------------------------------------------------

;---------------------------------------------------------------------------------------
; Table of pattern load request lists. Remember to use word-length data when adding lists
; otherwise you'll break the array.
;---------------------------------------------------------------------------------------
; word_42660 ; OffInd_PlrLists:
ArtLoadCues:		offsetTable
PLCptr_Std1:		offsetTableEntry.w PlrList_Std1			; 0
PLCptr_Std2:		offsetTableEntry.w PlrList_Std2			; 1
PLCptr_StdWtr:		offsetTableEntry.w PlrList_StdWtr		; 2
PLCptr_GameOver:	offsetTableEntry.w PlrList_GameOver		; 3
PLCptr_Ehz1:		offsetTableEntry.w PlrList_Ehz1			; 4
PLCptr_Ehz2:		offsetTableEntry.w PlrList_Ehz2			; 5
PLCptr_Miles1up:	offsetTableEntry.w PlrList_Miles1up		; 6
PLCptr_MilesLife:	offsetTableEntry.w PlrList_MilesLifeCounter	; 7
PLCptr_Tails1up:	offsetTableEntry.w PlrList_Tails1up		; 8
PLCptr_TailsLife:	offsetTableEntry.w PlrList_TailsLifeCounter	; 9
PLCptr_Unused1:		offsetTableEntry.w PlrList_Mtz1			; 10
PLCptr_Unused2:		offsetTableEntry.w PlrList_Mtz1			; 11
PLCptr_Mtz1:		offsetTableEntry.w PlrList_Mtz1			; 12
PLCptr_Mtz2:		offsetTableEntry.w PlrList_Mtz2			; 13
			offsetTableEntry.w PlrList_Wfz1			; 14
			offsetTableEntry.w PlrList_Wfz1			; 15
PLCptr_Wfz1:		offsetTableEntry.w PlrList_Wfz1			; 16
PLCptr_Wfz2:		offsetTableEntry.w PlrList_Wfz2			; 17
PLCptr_Htz1:		offsetTableEntry.w PlrList_Htz1			; 18
PLCptr_Htz2:		offsetTableEntry.w PlrList_Htz2			; 19
PLCptr_Hpz1:		offsetTableEntry.w PlrList_Hpz1			; 20
PLCptr_Hpz2:		offsetTableEntry.w PlrList_Hpz2			; 21
PLCptr_Unused3:		offsetTableEntry.w PlrList_Ooz1			; 22
PLCptr_Unused4:		offsetTableEntry.w PlrList_Ooz1			; 23
PLCptr_Ooz1:		offsetTableEntry.w PlrList_Ooz1			; 24
PLCptr_Ooz2:		offsetTableEntry.w PlrList_Ooz2			; 25
PLCptr_Mcz1:		offsetTableEntry.w PlrList_Mcz1			; 26
PLCptr_Mcz2:		offsetTableEntry.w PlrList_Mcz2			; 27
PLCptr_Cnz1:		offsetTableEntry.w PlrList_Cnz1			; 28
PLCptr_Cnz2:		offsetTableEntry.w PlrList_Cnz2			; 29
PLCptr_Cpz1:		offsetTableEntry.w PlrList_Cpz1			; 30
PLCptr_Cpz2:		offsetTableEntry.w PlrList_Cpz2			; 31
PLCptr_Dez1:		offsetTableEntry.w PlrList_Dez1			; 32
PLCptr_Dez2:		offsetTableEntry.w PlrList_Dez2			; 33
PLCptr_Arz1:		offsetTableEntry.w PlrList_Arz1			; 34
PLCptr_Arz2:		offsetTableEntry.w PlrList_Arz2			; 35
PLCptr_Scz1:		offsetTableEntry.w PlrList_Scz1			; 36
PLCptr_Scz2:		offsetTableEntry.w PlrList_Scz2			; 37
PLCptr_Results:		offsetTableEntry.w PlrList_Results		; 38
PLCptr_Signpost:	offsetTableEntry.w PlrList_Signpost		; 39
PLCptr_CpzBoss:		offsetTableEntry.w PlrList_CpzBoss		; 40
PLCptr_EhzBoss:		offsetTableEntry.w PlrList_EhzBoss		; 41
PLCptr_HtzBoss:		offsetTableEntry.w PlrList_HtzBoss		; 42
PLCptr_ArzBoss:		offsetTableEntry.w PlrList_ArzBoss		; 43
PLCptr_MczBoss:		offsetTableEntry.w PlrList_MczBoss		; 44
PLCptr_CnzBoss:		offsetTableEntry.w PlrList_CnzBoss		; 45
PLCptr_MtzBoss:		offsetTableEntry.w PlrList_MtzBoss		; 46
PLCptr_OozBoss:		offsetTableEntry.w PlrList_OozBoss		; 47
PLCptr_FieryExplosion:	offsetTableEntry.w PlrList_FieryExplosion	; 48
PLCptr_DezBoss:		offsetTableEntry.w PlrList_DezBoss		; 49
PLCptr_EhzAnimals:	offsetTableEntry.w PlrList_EhzAnimals		; 50
PLCptr_MczAnimals:	offsetTableEntry.w PlrList_MczAnimals		; 51
PLCptr_HtzAnimals:
PLCptr_MtzAnimals:
PLCptr_WfzAnimals:	offsetTableEntry.w PlrList_WfzAnimals		; 52
PLCptr_DezAnimals:	offsetTableEntry.w PlrList_DezAnimals		; 53
PLCptr_HpzAnimals:	offsetTableEntry.w PlrList_HpzAnimals		; 54
PLCptr_OozAnimals:	offsetTableEntry.w PlrList_OozAnimals		; 55
PLCptr_SczAnimals:	offsetTableEntry.w PlrList_SczAnimals		; 56
PLCptr_CnzAnimals:	offsetTableEntry.w PlrList_CnzAnimals		; 57
PLCptr_CpzAnimals:	offsetTableEntry.w PlrList_CpzAnimals		; 58
PLCptr_ArzAnimals:	offsetTableEntry.w PlrList_ArzAnimals		; 59
PLCptr_SpecialStage:	offsetTableEntry.w PlrList_SpecialStage		; 60
PLCptr_SpecStageBombs:	offsetTableEntry.w PlrList_SpecStageBombs	; 61
PLCptr_WfzBoss:		offsetTableEntry.w PlrList_WfzBoss		; 62
PLCptr_Tornado:		offsetTableEntry.w PlrList_Tornado		; 63
PLCptr_Capsule:		offsetTableEntry.w PlrList_Capsule		; 64
PLCptr_Explosion:	offsetTableEntry.w PlrList_Explosion		; 65
PLCptr_ResultsTails:	offsetTableEntry.w PlrList_ResultsTails		; 66

; macro for a pattern load request list header
; must be on the same line as a label that has a corresponding _End label later
plrlistheader macro {INTLABEL}
__LABEL__ label *
	dc.w (((__LABEL___End - __LABEL__Plc) / 6) - 1)
__LABEL__Plc:
    endm

; macro for a pattern load request
plreq macro toVRAMaddr,fromROMaddr
	dc.l	fromROMaddr
	dc.w	tiles_to_bytes(toVRAMaddr)
    endm
