;byte_13F62:
Animal_PLCTable: zoneOrderedTable 1,1
	zoneTableEntry.b PLCID_EhzAnimals	; EHZ - $0
	zoneTableEntry.b PLCID_EhzAnimals	; $1
	zoneTableEntry.b PLCID_EhzAnimals	; WZ - $2
	zoneTableEntry.b PLCID_EhzAnimals	; $3
	zoneTableEntry.b PLCID_MtzAnimals	; MTZ - $4
	zoneTableEntry.b PLCID_MtzAnimals	; MTZ - $5
	zoneTableEntry.b PLCID_WfzAnimals	; WFZ - $6
	zoneTableEntry.b PLCID_HtzAnimals	; HTZ - $7
	zoneTableEntry.b PLCID_HpzAnimals	; HPZ - $8
	zoneTableEntry.b PLCID_HpzAnimals	; $9
	zoneTableEntry.b PLCID_OozAnimals	; OOZ - $A
	zoneTableEntry.b PLCID_MczAnimals	; MCZ - $B
	zoneTableEntry.b PLCID_CnzAnimals	; CNZ - $C
	zoneTableEntry.b PLCID_CpzAnimals	; CPZ - $D
	zoneTableEntry.b PLCID_DezAnimals	; DEZ - $E
	zoneTableEntry.b PLCID_ArzAnimals	; ARZ - $F
	zoneTableEntry.b PLCID_SczAnimals	; SCZ - $10
    zoneTableEnd

	dc.b PLCID_SczAnimals	; level slot $11 (non-existent), not part of main table
	even