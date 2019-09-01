;---------------------------------------------------------------------------------------
; Weird revision-specific duplicates of portions of the PLR lists (unused)
;---------------------------------------------------------------------------------------
    if gameRevision=0
	; half of PlrList_ResultsTails
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniTails
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_ResultsTails_Dup_End
	dc.l	0
    elseif gameRevision=2
	; half of the second ARZ PLR list
	plreq ArtTile_ArtNem_Grounder, ArtNem_Grounder
	plreq ArtTile_ArtNem_BigBubbles, ArtNem_BigBubbles
	plreq ArtTile_ArtNem_Spikes, ArtNem_Spikes
	plreq ArtTile_ArtNem_LeverSpring, ArtNem_LeverSpring
	plreq ArtTile_ArtNem_VrtclSprng, ArtNem_VrtclSprng
	plreq ArtTile_ArtNem_HrzntlSprng, ArtNem_HrzntlSprng
PlrList_Arz2_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; SCZ Primary
;---------------------------------------------------------------------------------------
PlrList_Scz1_Dup: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
PlrList_Scz1_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; SCZ Secondary
;---------------------------------------------------------------------------------------
PlrList_Scz2_Dup: plrlistheader
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
	plreq ArtTile_ArtNem_WfzVrtclPrpllr, ArtNem_WfzVrtclPrpllr
	plreq ArtTile_ArtNem_WfzHrzntlPrpllr, ArtNem_WfzHrzntlPrpllr
	plreq ArtTile_ArtNem_Balkrie, ArtNem_Balkrie
	plreq ArtTile_ArtNem_Turtloid, ArtNem_Turtloid
	plreq ArtTile_ArtNem_Nebula, ArtNem_Nebula
PlrList_Scz2_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Sonic end of level results screen
;---------------------------------------------------------------------------------------
PlrList_Results_Dup: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniSonic
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_Results_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; End of level signpost
;---------------------------------------------------------------------------------------
PlrList_Signpost_Dup: plrlistheader
	plreq ArtTile_ArtNem_Signpost, ArtNem_Signpost
PlrList_Signpost_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; CPZ Boss
;---------------------------------------------------------------------------------------
PlrList_CpzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_3, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CPZBoss, ArtNem_CPZBoss
	plreq ArtTile_ArtNem_EggpodJets_1, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_BossSmoke_1, ArtNem_BossSmoke
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CpzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; EHZ Boss
;---------------------------------------------------------------------------------------
PlrList_EhzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_1, ArtNem_Eggpod
	plreq ArtTile_ArtNem_EHZBoss, ArtNem_EHZBoss
	plreq ArtTile_ArtNem_EggChoppers, ArtNem_EggChoppers
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_EhzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; HTZ Boss
;---------------------------------------------------------------------------------------
PlrList_HtzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_2, ArtNem_Eggpod
	plreq ArtTile_ArtNem_HTZBoss, ArtNem_HTZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
	plreq ArtTile_ArtNem_BossSmoke_2, ArtNem_BossSmoke
PlrList_HtzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; ARZ Boss
;---------------------------------------------------------------------------------------
PlrList_ArzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_ARZBoss, ArtNem_ARZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_ArzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; MCZ Boss
;---------------------------------------------------------------------------------------
PlrList_MczBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MCZBoss, ArtNem_MCZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MczBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; CNZ Boss
;---------------------------------------------------------------------------------------
PlrList_CnzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_CNZBoss, ArtNem_CNZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_CnzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; MTZ Boss
;---------------------------------------------------------------------------------------
PlrList_MtzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_Eggpod_4, ArtNem_Eggpod
	plreq ArtTile_ArtNem_MTZBoss, ArtNem_MTZBoss
	plreq ArtTile_ArtNem_EggpodJets_2, ArtNem_EggpodJets
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_MtzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; OOZ Boss
;---------------------------------------------------------------------------------------
PlrList_OozBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_OOZBoss, ArtNem_OOZBoss
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_OozBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Fiery Explosion
;---------------------------------------------------------------------------------------
PlrList_FieryExplosion_Dup: plrlistheader
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_FieryExplosion_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Death Egg
;---------------------------------------------------------------------------------------
PlrList_DezBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_DEZBoss, ArtNem_DEZBoss
PlrList_DezBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; EHZ Animals
;---------------------------------------------------------------------------------------
PlrList_EhzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Squirrel
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Bird
PlrList_EhzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; MCZ Animals
;---------------------------------------------------------------------------------------
PlrList_MczAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_MczAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; HTZ/MTZ/WFZ animals
;---------------------------------------------------------------------------------------
PlrList_HtzAnimals_Dup:
PlrList_MtzAnimals_Dup:
PlrList_WfzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Beaver
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_HtzAnimals_Dup_End
PlrList_MtzAnimals_Dup_End
PlrList_WfzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; DEZ Animals
;---------------------------------------------------------------------------------------
PlrList_DezAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Pig
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_DezAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; HPZ animals
;---------------------------------------------------------------------------------------
PlrList_HpzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Mouse
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_HpzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; OOZ Animals
;---------------------------------------------------------------------------------------
PlrList_OozAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Seal
PlrList_OozAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; SCZ Animals
;---------------------------------------------------------------------------------------
PlrList_SczAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Turtle
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Chicken
PlrList_SczAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; CNZ Animals
;---------------------------------------------------------------------------------------
PlrList_CnzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Bear
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Bird
PlrList_CnzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; CPZ Animals
;---------------------------------------------------------------------------------------
PlrList_CpzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Rabbit
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Eagle
PlrList_CpzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; ARZ Animals
;---------------------------------------------------------------------------------------
PlrList_ArzAnimals_Dup: plrlistheader
	plreq ArtTile_ArtNem_Animal_1, ArtNem_Penguin
	plreq ArtTile_ArtNem_Animal_2, ArtNem_Bird
PlrList_ArzAnimals_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Special Stage
;---------------------------------------------------------------------------------------
PlrList_SpecialStage_Dup: plrlistheader
	plreq ArtTile_ArtNem_SpecialEmerald, ArtNem_SpecialEmerald
	plreq ArtTile_ArtNem_SpecialMessages, ArtNem_SpecialMessages
	plreq ArtTile_ArtNem_SpecialHUD, ArtNem_SpecialHUD
	plreq ArtTile_ArtNem_SpecialFlatShadow, ArtNem_SpecialFlatShadow
	plreq ArtTile_ArtNem_SpecialDiagShadow, ArtNem_SpecialDiagShadow
	plreq ArtTile_ArtNem_SpecialSideShadow, ArtNem_SpecialSideShadow
	plreq ArtTile_ArtNem_SpecialExplosion, ArtNem_SpecialExplosion
	plreq ArtTile_ArtNem_SpecialRings, ArtNem_SpecialRings
	plreq ArtTile_ArtNem_SpecialStart, ArtNem_SpecialStart
	plreq ArtTile_ArtNem_SpecialPlayerVSPlayer, ArtNem_SpecialPlayerVSPlayer
	plreq ArtTile_ArtNem_SpecialBack, ArtNem_SpecialBack
	plreq ArtTile_ArtNem_SpecialStars, ArtNem_SpecialStars
	plreq ArtTile_ArtNem_SpecialTailsText, ArtNem_SpecialTailsText
PlrList_SpecialStage_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Special Stage Bombs
;---------------------------------------------------------------------------------------
PlrList_SpecStageBombs_Dup: plrlistheader
	plreq ArtTile_ArtNem_SpecialBomb, ArtNem_SpecialBomb
PlrList_SpecStageBombs_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; WFZ Boss
;---------------------------------------------------------------------------------------
PlrList_WfzBoss_Dup: plrlistheader
	plreq ArtTile_ArtNem_WFZBoss, ArtNem_WFZBoss
	plreq ArtTile_ArtNem_RobotnikRunning, ArtNem_RobotnikRunning
	plreq ArtTile_ArtNem_RobotnikUpper, ArtNem_RobotnikUpper
	plreq ArtTile_ArtNem_RobotnikLower, ArtNem_RobotnikLower
	plreq ArtTile_ArtNem_FieryExplosion, ArtNem_FieryExplosion
PlrList_WfzBoss_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Tornado
;---------------------------------------------------------------------------------------
PlrList_Tornado_Dup: plrlistheader
	plreq ArtTile_ArtNem_Tornado, ArtNem_Tornado
	plreq ArtTile_ArtNem_TornadoThruster, ArtNem_TornadoThruster
	plreq ArtTile_ArtNem_Clouds, ArtNem_Clouds
PlrList_Tornado_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Capsule/Egg Prison
;---------------------------------------------------------------------------------------
PlrList_Capsule_Dup: plrlistheader
	plreq ArtTile_ArtNem_Capsule, ArtNem_Capsule
PlrList_Capsule_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Normal explosion
;---------------------------------------------------------------------------------------
PlrList_Explosion_Dup: plrlistheader
	plreq ArtTile_ArtNem_Explosion, ArtNem_Explosion
PlrList_Explosion_Dup_End
;---------------------------------------------------------------------------------------
; Pattern load queue (duplicate)
; Tails end of level results screen
;---------------------------------------------------------------------------------------
PlrList_ResultsTails_Dup: plrlistheader
	plreq ArtTile_ArtNem_TitleCard, ArtNem_TitleCard
	plreq ArtTile_ArtNem_ResultsText, ArtNem_ResultsText
	plreq ArtTile_ArtNem_MiniCharacter, ArtNem_MiniTails
	plreq ArtTile_ArtNem_Perfect, ArtNem_Perfect
PlrList_ResultsTails_Dup_End
    endif
