; -------------------------------------------------------------------------------
; Main game level order

; One value per act. That value is the levels/act number of the level to load when
; that act finishes.
;
; Note that the acts aren't in sequential order. Any act with a * preceding
; it is unused. The 2P table is likely unused, as that would only apply to
; the competition mode.
; -------------------------------------------------------------------------------

LevelOrder: zoneOrderedTable 2,2	; WrdArr_LevelOrder
	zoneTableEntry.w  emerald_hill_zone_act_2       ; EHZ 1 - 0
	zoneTableEntry.w  chemical_plant_zone_act_1     ; EHZ 2 - 1
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *Z1 1 - 2
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *Z1 2 - 3
	zoneTableEntry.w  wood_zone_act_2               ; *WZ 1 - 4
	zoneTableEntry.w  metropolis_zone_act_1         ; *WZ 2 - 5
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *Z3 1 - 6
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *Z3 2 - 7
	zoneTableEntry.w  metropolis_zone_act_2         ; MTZ 1 - 8
	zoneTableEntry.w  metropolis_zone_act_3         ; MTZ 2 - 9
	zoneTableEntry.w  sky_chase_zone_act_1          ; MTZ 3 - 10
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *MTZ4 - 11
	zoneTableEntry.w  death_egg_zone_act_1          ; WFZ 1 - 12
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *WFZ2 - 13
	zoneTableEntry.w  hill_top_zone_act_2           ; HTZ 1 - 14
	zoneTableEntry.w  mystic_cave_zone_act_1        ; HTZ 2 - 15
	zoneTableEntry.w  hidden_palace_zone_act_2      ; *HPZ1 - 16
	zoneTableEntry.w  oil_ocean_zone_act_1          ; *HPZ2 - 17
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *Z9 1 - 18
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *Z9 2 - 19
	zoneTableEntry.w  oil_ocean_zone_act_2          ; OOZ 1 - 20
	zoneTableEntry.w  metropolis_zone_act_1         ; OOZ 2 - 21
	zoneTableEntry.w  mystic_cave_zone_act_2        ; MCZ 1 - 22
	zoneTableEntry.w  oil_ocean_zone_act_1          ; MCZ 2 - 23
	zoneTableEntry.w  casino_night_zone_act_2       ; CNZ 1 - 24
	zoneTableEntry.w  hill_top_zone_act_1           ; CNZ 2 - 25
	zoneTableEntry.w  chemical_plant_zone_act_2     ; CPZ 1 - 26
	zoneTableEntry.w  aquatic_ruin_zone_act_1       ; CPZ 2 - 27
	zoneTableEntry.w  $FFFF ; game end              ; DEZ 1 - 28
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *DEZ2 - 29
	zoneTableEntry.w  aquatic_ruin_zone_act_2       ; ARZ 1 - 30
	zoneTableEntry.w  casino_night_zone_act_1       ; ARZ 2 - 31
	zoneTableEntry.w  wing_fortress_zone_act_1      ; SCZ 1 - 32
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *SCZ2 - 33
    zoneTableEnd

;word_1433C:
LevelOrder_2P: zoneOrderedTable 2,2	; WrdArr_LevelOrder_2P
	zoneTableEntry.w  emerald_hill_zone_act_2       ; EHZ 1 - 0
	zoneTableEntry.w  casino_night_zone_act_1       ; EHZ 2 - 1
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *Z1 1 - 2
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *Z1 2 - 3
	zoneTableEntry.w  wood_zone_act_2               ; *WZ 1 - 4
	zoneTableEntry.w  metropolis_zone_act_1         ; *WZ 2 - 5
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *Z3 1 - 6
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *Z3 2 - 7
	zoneTableEntry.w  metropolis_zone_act_2         ; MTZ 1 - 8
	zoneTableEntry.w  metropolis_zone_act_3         ; MTZ 2 - 9
	zoneTableEntry.w  sky_chase_zone_act_1          ; MTZ 3 - 10
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *MTZ4 - 11
	zoneTableEntry.w  death_egg_zone_act_1          ; WFZ 1 - 12
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *WFZ2 - 13
	zoneTableEntry.w  hill_top_zone_act_2           ; HTZ 1 - 14
	zoneTableEntry.w  mystic_cave_zone_act_1        ; HTZ 2 - 15
	zoneTableEntry.w  hidden_palace_zone_act_2      ; *HPZ1 - 16
	zoneTableEntry.w  oil_ocean_zone_act_1          ; *HPZ2 - 17
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *Z9 1 - 18
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *Z9 2 - 19
	zoneTableEntry.w  oil_ocean_zone_act_2          ; OOZ 1 - 20
	zoneTableEntry.w  metropolis_zone_act_1         ; OOZ 2 - 21
	zoneTableEntry.w  mystic_cave_zone_act_2        ; MCZ 1 - 22
	zoneTableEntry.w  $FFFF ; game end              ; MCZ 2 - 23
	zoneTableEntry.w  casino_night_zone_act_2       ; CNZ 1 - 24
	zoneTableEntry.w  mystic_cave_zone_act_1        ; CNZ 2 - 25
	zoneTableEntry.w  chemical_plant_zone_act_2     ; CPZ 1 - 26
	zoneTableEntry.w  aquatic_ruin_zone_act_1       ; CPZ 2 - 27
	zoneTableEntry.w  $FFFF ; game end              ; DEZ 1 - 28
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *DEZ2 - 29
	zoneTableEntry.w  aquatic_ruin_zone_act_2       ; ARZ 1 - 30
	zoneTableEntry.w  casino_night_zone_act_1       ; ARZ 2 - 31
	zoneTableEntry.w  wing_fortress_zone_act_1      ; SCZ 1 - 32
	zoneTableEntry.w  emerald_hill_zone_act_1       ; *SCZ2 - 33
    zoneTableEnd
