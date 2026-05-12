; ---------------------------------------------------------------------------
; Level Headers
; ---------------------------------------------------------------------------

LevelHeaders:

lhead:	macro plc1,lvlgfx,plc2,sixteen,twofivesix,music,pal
		dc.l (plc1<<24)+lvlgfx
		dc.l (plc2<<24)+sixteen
		dc.l twofivesix
		dc.b 0, music, pal, pal
		endm

; 1st PLC, level gfx (unused), 2nd PLC, 16x16 data, 128x128 data,
; music (unused), palette (unused), palette

;			1st PLC				2nd PLC				128x128 data			palette
;					level gfx*			16x16 data			music*

		lhead plcid_GHZ, Nem_GHZ, plcid_GHZ2, Map16_GHZ, Map128_GHZ, bgm_GHZ, palid_GHZ ; GHZ  ; GREEN HILL ZONE
		lhead plcid_LZ, Nem_CPZ, plcid_LZ2, Map16_CPZ, Map128_CPZ, bgm_LZ, palid_LZ ; LZ   ; LABYRINTH ZONE
		lhead plcid_CPZ, Nem_CPZ, plcid_CPZ2, Map16_CPZ, Map128_CPZ, bgm_MZ, palid_CPZ ; CPZ  ; CHEMICAL PLANT ZONE
		lhead plcid_EHZ, Nem_EHZ, plcid_EHZ2, Map16_EHZ, Map128_EHZ, bgm_SLZ, palid_EHZ ; EHZ  ; EMERALD HILL ZONE
		lhead plcid_HPZ, Nem_HPZ, plcid_HPZ2, Map16_HPZ, Map128_HPZ, bgm_SYZ, palid_HPZ ; HPZ  ; HIDDEN PALACE ZONE
		lhead plcid_HTZ, Nem_EHZ, plcid_HTZ2, Map16_EHZ, Map128_EHZ, bgm_SBZ, palid_HTZ1 ; HTZ  ; HILL TOP ZONE
		lhead 0, 0, plcid_GHZ2, Map16_GHZ, Map128_GHZ, bgm_SBZ, palid_Ending ; LEV6 ; LEVEL 6 (UNUSED, SONIC 1 ENDING)

;	* music and level gfx are actually set elsewhere, so these values are useless