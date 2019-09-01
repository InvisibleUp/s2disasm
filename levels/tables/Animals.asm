; byte_118CE:
Obj28_ZoneAnimals:	zoneOrderedTable 1,2

zoneAnimals macro first,second
	zoneTableEntry.b (Obj28_Properties_first - Obj28_Properties) / 8
	zoneTableEntry.b (Obj28_Properties_second - Obj28_Properties) / 8
    endm
	; This table declares what animals will appear in the zone.
	; When an enemy is destroyed, a random animal is chosen from the 2 selected animals.

	; Note: you must also load the corresponding art in the PLCs, by
	;       editing the table in AnimalPLCs.asm

	; Valid choices: Rabbit, Chicken, Penguin, Seal, Pig, Bird, Squirrel,
	;                Eagle, Mouse, Beaver, Turtle, Bear

	zoneAnimals.b Squirrel,	Bird	; EHZ - $0
	zoneAnimals.b Squirrel,	Bird	; $1
	zoneAnimals.b Squirrel,	Bird	; WZ - $2
	zoneAnimals.b Squirrel,	Bird	; $3
	zoneAnimals.b Beaver,	Eagle	; MTZ - $4
	zoneAnimals.b Beaver,	Eagle	; MTZ - $5
	zoneAnimals.b Beaver,	Eagle	; WFZ - $6
	zoneAnimals.b Beaver,	Eagle	; HTZ - $7
	zoneAnimals.b Mouse,	Seal	; HPZ - $8
	zoneAnimals.b Mouse,	Seal	; $9
	zoneAnimals.b Penguin,	Seal	; OOZ - $A
	zoneAnimals.b Mouse,	Chicken	; MCZ - $B
	zoneAnimals.b Bear,	Bird	; CNZ - $C
	zoneAnimals.b Rabbit,	Eagle	; CPZ - $D
	zoneAnimals.b Pig,	Chicken	; DEZ - $E
	zoneAnimals.b Penguin,	Bird	; ARZ - $F
	zoneAnimals.b Turtle,	Chicken	; SCZ - $10
    zoneTableEnd