	include "s1.sounddriver.ram.asm"

; Main RAM
	phase	($FE0000)
RAM_debug_start:	ds.b	$8000

RAM_debug_demo_record:	ds.w	$2000

RAM_debug_demo_record_2P:	ds.w	$2000

RAM_debug_end:
	dephase

; sign-extends a 32-bit integer to 64-bit
; all RAM addresses are run through this function to allow them to work in both 16-bit and 32-bit addressing modes
ramaddr function x,(-(x&$80000000)<<1)|x

; Variables (v) and Flags (f)

	phase ramaddr ( $FFFF0000 )
v_ram_start_def:
v_ram_start:		equ	v_ram_start_def&$FFFFFF	; 24-bit addressing

v_128x128_def:		ds.b	chunk_size_128*$100	; 128x128 tile mappings ($100 chunks)
v_128x128:		equ	v_128x128_def&$FFFFFF	; 24-bit addressing
v_128x128_end:

v_lvllayout:		ds.b	layout_row*$10		; level layouts (FG/BG rows interlaced, 8 rows and $400 total)
v_lvllayout_fg:		equ	v_lvllayout		; start address of foreground's first row
v_lvllayout_bg:		equ	v_lvllayout+layout_row_interlaced ; start address of background's first row
v_lvllayout_end:

v_collision1:		ds.b	$300
v_collision1_end:
v_collision2:		ds.b	$300
v_collision2_end:

			ds.b	$600		; unused
v_bgscroll_buffer:	ds.b	$200		; background scroll buffer
v_ngfx_buffer:		ds.b	$200		; Nemesis graphics decompression buffer
v_ngfx_buffer_end:
v_spritequeue:		ds.b	$400		; sprite display queue, in order of priority
v_spritequeue_end:
v_16x16:		ds.b	$1800		; 16x16 tile mappings
v_16x16_end:

VDP_Command_Buffer:	ds.w	7*$12		; stores 18 ($12) VDP commands to issue the next time ProcessDMAQueue is called
VDP_Command_Buffer_end:
VDP_Command_Buffer_Slot:ds.l	1		; stores the address of the next open slot for a queued VDP command

v_hscrolltablebuffer:	ds.b	$380		; scrolling table data
v_hscrolltablebuffer_end:
			ds.b	$80		; would be unused, but data from v_hscrolltablebuffer can spill into here
v_hscrolltablebuffer_end_padded:

v_objspace:		ds.b	object_size*$80		; object variable space ($40 bytes per object)
v_objspace_end

; 2P mode reserves 6 'blocks' of 12 RAM slots at the end.
Dynamic_Object_RAM_2P_End = v_objspace_end - ($C * 6) * object_size

; Title screen objects
v_titlesonic:	equ v_objspace+object_size*1	; object variable space for Sonic in the title screen ($40 bytes)
v_titletails:	equ v_objspace+object_size*2	; object variable space for the "SONIC TEAM PRESENTS" text ($40 bytes)
v_pressstart:	equ	v_objspace+object_size*2	; object variable space for the "PRESS START BUTTON" text ($40 bytes)
v_titletm:	equ	v_objspace+object_size*3	; object variable space for the trademark symbol ($40 bytes)
v_ttlsonichide:	equ	v_objspace+object_size*4	; object variable space for hiding part of Sonic ($40 bytes)

; Level objects
v_player:	equ	v_objspace+object_size*0	; object variable space for Sonic ($40 bytes)
v_player2:	equ v_objspace+object_size*1	; object variable space for Tails ($40 bytes)
v_player2tails:	equ v_objspace+object_size*7; object variable space for Tails' Tails ($40 bytes)
v_hud:		equ v_objspace+object_size*14	; object variable space for the HUD ($40 bytes)

v_titlecard:	equ	v_objspace+object_size*2	; object variable space for the title card ($100 bytes)
v_ttlcardname:	equ	v_titlecard+object_size*0	; object variable space for the title card zone name text ($40 bytes)
v_ttlcardzone:	equ	v_titlecard+object_size*1	; object variable space for the title card "ZONE" text ($40 bytes)
v_ttlcardact:	equ	v_titlecard+object_size*2	; object variable space for the title card act text ($40 bytes)
v_ttlcardoval:	equ	v_titlecard+object_size*3	; object variable space for the title card oval ($40 bytes)

v_gameovertext1:equ	v_objspace+object_size*2	; object variable space for the "GAME"/"TIME" in "GAME OVER"/"TIME OVER" text ($40 bytes)
v_gameovertext2:equ	v_objspace+object_size*3	; object variable space for the "OVER" in "GAME OVER"/"TIME OVER" text ($40 bytes)

v_shieldobj:	equ	v_objspace+object_size*6	; object variable space for the shield ($40 bytes)
v_starsobj1:	equ	v_objspace+object_size*8	; object variable space for the invincibility stars #1 ($40 bytes)
v_starsobj2:	equ	v_objspace+object_size*9	; object variable space for the invincibility stars #2 ($40 bytes)
v_starsobj3:	equ	v_objspace+object_size*10	; object variable space for the invincibility stars #3 ($40 bytes)
v_starsobj4:	equ	v_objspace+object_size*11	; object variable space for the invincibility stars #4 ($40 bytes)

v_splash:	equ	v_objspace+object_size*12	; object variable space for the water splash ($40 bytes)
v_sonicbubbles:	equ	v_objspace+object_size*13	; object variable space for the bubbles that come out of Sonic's mouth/drown countdown ($40 bytes)
v_watersurface1:equ	v_objspace+object_size*30	; object variable space for the water surface #1 ($40 bytes)
v_watersurface2:equ	v_objspace+object_size*31	; object variable space for the water surface #1 ($40 bytes)

v_endcard:	equ	v_objspace+object_size*23	; object variable space for the level results card ($1C0 bytes)
v_endcardsonic:	equ	v_endcard+object_size*0		; object variable space for the level results card "SONIC HAS" text ($40 bytes)
v_endcardpassed:equ	v_endcard+object_size*1		; object variable space for the level results card "PASSED" text ($40 bytes)
v_endcardact:	equ	v_endcard+object_size*2		; object variable space for the level results card act text ($40 bytes)
v_endcardscore:	equ	v_endcard+object_size*3		; object variable space for the level results card score tally ($40 bytes)
v_endcardtime:	equ	v_endcard+object_size*4		; object variable space for the level results card time bonus tally ($40 bytes)
v_endcardring:	equ	v_endcard+object_size*5		; object variable space for the level results card ring bonus tally ($40 bytes)
v_endcardoval:	equ	v_endcard+object_size*6		; object variable space for the level results card oval ($40 bytes)

v_lvlobjspace:	equ	v_objspace+object_size*32	; level object variable space ($1800 bytes)
v_lvlobjend:	equ	v_lvlobjspace+object_size*96
v_objend:	equ v_lvlobjend

; Special Stage objects
v_ssrescard:	equ	v_objspace+object_size*23	; object variable space for the Special Stage results card ($140 bytes)
v_ssrestext:	equ	v_ssrescard+object_size*0	; object variable space for the Special Stage results card text ($40 bytes)
v_ssresscore:	equ	v_ssrescard+object_size*1	; object variable space for the Special Stage results card score tally ($40 bytes)
v_ssresring:	equ	v_ssrescard+object_size*2	; object variable space for the Special Stage results card ring bonus tally ($40 bytes)
v_ssresoval:	equ	v_ssrescard+object_size*3	; object variable space for the Special Stage results card oval ($40 bytes)
v_ssrescontinue:equ	v_ssrescard+object_size*4	; object variable space for the Special Stage results card continue icon ($40 bytes)
v_ssresemeralds:equ	v_objspace+object_size*32	; object variable space for the emeralds in the Special Stage results ($180 bytes)

; Continue screen objects
v_continuetext:	equ	v_objspace+object_size*1	; object variable space for the continue screen text ($40 bytes)
v_continuelight:equ	v_objspace+object_size*2	; object variable space for the continue screen light spot ($40 bytes)
v_continueicon:	equ	v_objspace+object_size*3	; object variable space for the continue screen icon ($40 bytes)

; Ending objects
v_endemeralds:	equ	v_objspace+object_size*16	; object variable space for the emeralds in the ending ($180 bytes)
v_endemeralds_end:equ	v_objspace+object_size*32
v_endlogo:	equ	v_objspace+object_size*16	; object variable space for the logo in the ending ($40 bytes)

; Credits objects
v_credits:	equ	v_objspace+object_size*2	; object variable space for the credits text ($40 bytes)
v_endeggman:	equ	v_objspace+object_size*2	; object variable space for Eggman after the credits ($40 bytes)
v_tryagain:	equ	v_objspace+object_size*3	; object variable space for the "TRY AGAIN" text ($40 bytes)
v_eggmanchaos:	equ	v_objspace+object_size*32	; object variable space for the emeralds juggled by Eggman ($180 bytes)

Sprite_Table_P2:	ds.b	$280	; Sprite attribute table buffer for the bottom split screen in 2-player mode
Sprite_Table_P2_end:
			ds.b	$80			; unused

Sonic_Stat_Record_Buf:		ds.b	$100
Sonic_Pos_Record_Buf:		ds.b	$100

Tails_Pos_Record_Buf:		ds.b	$100
Tails_Pos_Record_Buf_Dup:	ds.b	$100

Ring_Positions:		ds.b	$600
Ring_Positions_End:

Camera_RAM:

Camera_Positions:
Camera_X_pos:		ds.l	1
Camera_Y_pos:		ds.l	1
Camera_BG_X_pos:	ds.l	1	; only used sometimes as the layer deformation makes it sort of redundant
Camera_BG_Y_pos:	ds.l	1
Camera_BG2_X_pos:	ds.l	1	; used in CPZ
Camera_BG2_Y_pos:	ds.l	1	; used in CPZ
Camera_BG3_X_pos:	ds.l	1	; unused (only initialised at beginning of level)?
Camera_BG3_Y_pos:	ds.l	1	; unused (only initialised at beginning of level)?
Camera_Positions_end:

v_screenposx:	 	equ		Camera_X_pos
v_screenposy:	 	equ		Camera_Y_pos
v_bgscreenposx:	 	equ		Camera_BG_X_pos
v_bgscreenposy:  	equ		Camera_BG_Y_pos
v_bg2screenposx: 	equ		Camera_BG2_X_pos
v_bg2screenposy: 	equ		Camera_BG2_Y_pos
v_bg3screenposx: 	equ		Camera_BG3_X_pos
v_bg3screenposy: 	equ		Camera_BG3_Y_pos

Camera_Positions_P2:
Camera_X_pos_P2:	ds.l	1
Camera_Y_pos_P2:	ds.l	1
Camera_BG_X_pos_P2:	ds.l	1	; only used sometimes as the layer deformation makes it sort of redundant
Camera_BG_Y_pos_P2:	ds.l	1
Camera_BG2_X_pos_P2:ds.l	1	; unused (only initialised at beginning of level)?
Camera_BG2_Y_pos_P2:ds.l	1	; unused (only initialised at beginning of level)?
Camera_BG3_X_pos_P2:ds.l	1	; unused (only initialised at beginning of level)?
Camera_BG3_Y_pos_P2:ds.l	1	; unused (only initialised at beginning of level)?
Camera_Positions_P2_End:

Block_Crossed_Flags:
Horiz_block_crossed_flag:	ds.b	1		; toggles between 0 and $10 when you cross a block boundary horizontally
Verti_block_crossed_flag:	ds.b	1		; toggles between 0 and $10 when you cross a block boundary vertically
Horiz_block_crossed_flag_BG:	ds.b	1		; toggles between 0 and $10 when background camera crosses a block boundary horizontally
Verti_block_crossed_flag_BG:	ds.b	1		; toggles between 0 and $10 when background camera crosses a block boundary vertically
Horiz_block_crossed_flag_BG2:	ds.b	1		; used in CPZ
			ds.b	1		; $FFFFEE45 ; seems unused
Horiz_block_crossed_flag_BG3:	ds.b	1
			ds.b	1		; $FFFFEE47 ; seems unused
Block_Crossed_Flags_End:

Block_Crossed_Flags_P2:
Horiz_block_crossed_flag_P2:	ds.b	1		; toggles between 0 and $10 when you cross a block boundary horizontally
Verti_block_crossed_flag_P2:	ds.b	1		; toggles between 0 and $10 when you cross a block boundary vertically
			ds.b	6		; $FFFFEE4A-$FFFFEE4F ; seems unused
Block_Crossed_Flags_P2_End:

Scroll_Flags_All:
Scroll_flags:		ds.w	1	; bitfield ; bit 0 = redraw top row, bit 1 = redraw bottom row, bit 2 = redraw left-most column, bit 3 = redraw right-most column
Scroll_flags_BG:	ds.w	1	; bitfield ; bits 0-3 as above, bit 4 = redraw top row (except leftmost block), bit 5 = redraw bottom row (except leftmost block), bits 6-7 = as bits 0-1
Scroll_flags_BG2:	ds.w	1	; bitfield ; essentially unused; bit 0 = redraw left-most column, bit 1 = redraw right-most column
Scroll_flags_BG3:	ds.w	1	; bitfield ; for CPZ; bits 0-3 as Scroll_flags_BG but using Y-dependent BG camera; bits 4-5 = bits 2-3; bits 6-7 = bits 2-3
Scroll_Flags_All_End:

Scroll_Flags_All_P2:
Scroll_flags_P2:	ds.w	1	; bitfield ; bit 0 = redraw top row, bit 1 = redraw bottom row, bit 2 = redraw left-most column, bit 3 = redraw right-most column
Scroll_flags_BG_P2:	ds.w	1	; bitfield ; bits 0-3 as above, bit 4 = redraw top row (except leftmost block), bit 5 = redraw bottom row (except leftmost block), bits 6-7 = as bits 0-1
Scroll_flags_BG2_P2:ds.w	1	; bitfield ; essentially unused; bit 0 = redraw left-most column, bit 1 = redraw right-most column
Scroll_flags_BG3_P2:ds.w	1	; bitfield ; for CPZ; bits 0-3 as Scroll_flags_BG but using Y-dependent BG camera; bits 4-5 = bits 2-3; bits 6-7 = bits 2-3
Scroll_Flags_All_P2_End:

Camera_Positions_Copy:
Camera_RAM_copy:	ds.l	2	; copied over every V-int
Camera_BG_copy:		ds.l	2	; copied over every V-int
Camera_BG2_copy:	ds.l	2	; copied over every V-int
Camera_BG3_copy:	ds.l	2	; copied over every V-int
Camera_Positions_Copy_End:

Camera_Positions_Copy_P2:
Camera_P2_copy:		ds.l	8	; copied over every V-int
Camera_Positions_Copy_P2_End:

Scroll_Flags_Copy_All:
Scroll_flags_copy:	ds.w	1	; copied over every V-int
Scroll_flags_BG_copy:	ds.w	1	; copied over every V-int
Scroll_flags_BG2_copy:	ds.w	1	; copied over every V-int
Scroll_flags_BG3_copy:	ds.w	1	; copied over every V-int
Scroll_Flags_Copy_All_End:

Scroll_Flags_Copy_All_P2:
Scroll_flags_copy_P2:	ds.w	1	; copied over every V-int
Scroll_flags_BG_copy_P2:ds.w	1	; copied over every V-int
Scroll_flags_BG2_copy_P2:	ds.w	1	; copied over every V-int
Scroll_flags_BG3_copy_P2:	ds.w	1	; copied over every V-int
Scroll_Flags_Copy_All_P2_End:

Camera_Difference:
Camera_X_pos_diff:	ds.w	1		; (new X pos - old X pos) * 256
Camera_Y_pos_diff:	ds.w	1		; (new Y pos - old Y pos) * 256
Camera_Difference_End:

Camera_BG_X_pos_diff:	ds.w	1	; Effective camera change used in WFZ ending and HTZ screen shake
Camera_BG_Y_pos_diff:	ds.w	1	; Effective camera change used in WFZ ending and HTZ screen shake

Camera_Difference_P2:
Camera_X_pos_diff_P2:	ds.w	1	; (new X pos - old X pos) * 256
Camera_Y_pos_diff_P2:	ds.w	1	; (new Y pos - old Y pos) * 256
Camera_Difference_P2_End:
			ds.b	4		; $FFFFEEBC-$FFFFEEBF ; seems unused

Camera_Min_X_pos_target:ds.w	1	; unused, except on write in LevelSizeLoad...
Camera_Max_X_pos_target:ds.w	1	; unused
Camera_Min_Y_pos_target:ds.w	1	; same as above. The write being a long also overwrites the address below
Camera_Max_Y_pos_target:ds.w	1

Camera_Boundaries:
Camera_Min_X_pos:	ds.w	1
Camera_Max_X_pos:	ds.w	1
Camera_Min_Y_pos:	ds.w	1
Camera_Max_Y_pos:	ds.w	1
Camera_Boundaries_End:

v_limitleft2: equ	Camera_Min_X_pos
v_limitright2: equ	Camera_Max_X_pos
v_limittop2: equ	Camera_Min_Y_pos
v_limitbtm2: equ	Camera_Max_Y_pos

Camera_Delay:
Horiz_scroll_delay_val:		ds.w	1	; if its value is a, where a != 0, X scrolling will be based on the player's X position a-1 frames ago
Sonic_Pos_Record_Index:		ds.w	1	; into Sonic_Pos_Record_Buf and Sonic_Stat_Record_Buf
Camera_Delay_End:

Camera_Delay_P2:
Horiz_scroll_delay_val_P2:	ds.w	1
Tails_Pos_Record_Index:		ds.w	1	; into Tails_Pos_Record_Buf
Camera_Delay_P2_End:

Camera_Y_pos_bias:	ds.w	1		; added to y position for lookup/lookdown, $60 is center
Camera_Y_pos_bias_End:

Camera_Y_pos_bias_P2:	ds.w	1	; for Tails
Camera_Y_pos_bias_P2_End:

Deform_lock:		ds.b	1		; set to 1 to stop all deformation
			ds.b	1		; $FFFFEEDD ; seems unused
Camera_Max_Y_Pos_Changing:	ds.b	1
Dynamic_Resize_Routine:	ds.b	1
RecordPos_Unused:	ds.w	1		; $FFFFEEE0-$FFFFEEE1
Camera_BG_X_offset:	ds.w	1		; Used to control background scrolling in X in WFZ ending and HTZ screen shake
Camera_BG_Y_offset:	ds.w	1		; Used to control background scrolling in Y in WFZ ending and HTZ screen shake
HTZ_Terrain_Delay:	ds.w	1		; During HTZ screen shake, this is a delay between rising and sinking terrain during which there is no shaking
HTZ_Terrain_Direction:	ds.b	1			; During HTZ screen shake, 0 if terrain/lava is rising, 1 if lowering
			ds.b	3		; $FFFFEEE9-$FFFFEEEB ; seems unused
Vscroll_Factor_P2_HInt:	ds.l	1
Camera_X_pos_copy:	ds.l	1
Camera_Y_pos_copy:	ds.l	1

Camera_Boundaries_P2:
Tails_Min_X_pos:	ds.w	1
Tails_Max_X_pos:	ds.w	1
Tails_Min_Y_pos:	ds.w	1		; seems not actually implemented (only written to)
Tails_Max_Y_pos:	ds.w	1
Camera_Boundaries_P2_End:

Camera_RAM_end:

Block_cache:		ds.w	512/16*2		; Width of plane in blocks, with each block getting two words.
			ds.b	$80			; unused

v_snddriver_ram:	SMPS_RAM		; sound driver state
			ds.b	$40		; unused

v_gamemode:		ds.b	1		; game mode (00=Sega; 04=Title; 08=Demo; 0C=Level; 10=SS; 14=Cont; 18=End; 1C=Credit; +8C=PreLevel)
			ds.b	1		; unused
v_jpadhold2:		ds.b	1		; joypad input - held, duplicate
v_jpadpress2:		ds.b	1		; joypad input - pressed, duplicate
v_jpadhold1:		ds.b	1		; joypad input - held
v_jpadpress1:		ds.b	1		; joypad input - pressed
v_P2jpadhold:		ds.b	1		; joypad input - held (P2)
v_P2jpadpress:		ds.b	1		; joypad input - pressed (P2)
			ds.b	4		; unused
v_vdp_buffer1:		ds.w	1		; VDP instruction buffer of register $81 (used for enabling/disabling display)
			ds.b	6		; unused
v_generictimer:		ds.w	1		; generic timer, decrements to 0 in vblank (word)
v_scrposy_vdp:		ds.w	1		; screen position y (VDP)
v_bgscrposy_vdp:	ds.w	1		; background screen position y (VDP)
v_scrposx_vdp:		ds.w	1		; screen position x (VDP)
v_bgscrposx_vdp:	ds.w	1		; background screen position x (VDP)
v_bg3scrposy_vdp:	ds.w	1
v_bg3scrposx_vdp:	ds.w	1
			ds.b	2		; unused
v_hblank_hreg:		ds.w	1		; VDP H.interrupt register buffer (8Axx) (previously called v_hblank_hreg)
v_hblank_line = v_hblank_hreg+1			; screen line where water starts and palette is changed by HBlank (previously called v_hblank_line)
v_pfade_start:		ds.b	1		; palette fading - start position in bytes
v_pfade_size:		ds.b	1		; palette fading - number of colours

v_misc_variables:
v_vblank_0e_counter:	ds.b	1		; tracks how many times vertical interrupts routine 0E occured (pretty much unused because routine 0E is unused)
			ds.b	1		; unused
v_vblank_routine:	ds.b	1		; VBlank - routine counter (previously called v_vbla_routine)
			ds.b	1		; unused
v_spritecount:		ds.b	1		; number of sprites on-screen
			ds.b	5		; unused
v_pcyc_num:		ds.w	1		; palette cycling - current reference number
v_pcyc_time:		ds.w	1		; palette cycling - time until the next change
v_random:		ds.l	1		; pseudo random number buffer
f_pause:		ds.w	1		; flag set to pause the game
			ds.b	4		; unused
v_vdp_buffer2:		ds.w	1		; VDP instruction buffer
			ds.b	2		; unused
f_hblank_pal:		ds.w	1		; flag set to change palette during HBlank (0000 = no; 0001 = change) (previously called f_hbla_pal)
v_waterpos1:		ds.w	1		; water height, actual
v_waterpos2:		ds.w	1		; water height, ignoring sway
v_waterpos3:		ds.w	1		; water height, next target
f_water:		ds.b	1		; flag set for water
v_wtr_routine:		ds.b	1		; water event - routine counter
f_wtr_state:		ds.b	1		; water palette state when water is above/below the screen (00 = partly/all dry; 01 = all underwater)
f_doupdatesinhblank:	ds.b	1		; defers performing various tasks to the Horizontal Interrupt (HBlank)
v_pal_buffer:		ds.b	$30		; palette data buffer (used for palette cycling)
v_misc_variables_end:

plc_slot_size:		equ	4+2		; size of a single PLC slot: 6 bytes = 4 bytes (data address) + 2 bytes (VRAM target address)
v_plc_buffer:		ds.b	plc_slot_size*16 ; pattern load cues buffer (maximum $10 PLCs)
v_plc_buffer_dest:	equ	v_plc_buffer+4	; VRAM destination for 1st item in PLC buffer (2 bytes)
v_plc_buffer_only_end:
v_plc_ptrnemcode:	ds.l	1		; pointer for nemesis decompression code ($1502 or $150C)
v_plc_repeatcount:	ds.l	1
v_plc_paletteindex:	ds.l	1
v_plc_previousrow:	ds.l	1
v_plc_dataword:		ds.l	1
v_plc_shiftvalue:	ds.l	1
v_plc_patternsleft:	ds.w	1
v_plc_framepatternsleft:ds.w	1
			ds.b	4		; unused
v_plc_buffer_end:

v_levelvariables:				; variables that are reset between levels

; extra variables for the second player (CPU) in 1-player mode
Tails_unused1:		ds.w	1	; set to 0 in Tails_Control, otherwise unused
Tails_control_counter:	ds.w	1
Tails_respawn_counter:	ds.w	1
Tails_unused_counter:	ds.w	1	; apart of an unused routine for Tails's CPU.
Tails_CPU_routine:	ds.w	1
			ds.b	8		; unused

Rings_manager_routine:	ds.b	1
Level_started_flag:	ds.b	1

Ring_Manager_Addresses:
Ring_start_addr:		ds.w	1
Ring_end_addr:			ds.w	1
Ring_Manager_Addresses_End:

Ring_Manager_Addresses_P2:
Ring_start_addr_P2:		ds.w	1
Ring_end_addr_P2:		ds.w	1
Ring_Manager_Addresses_P2_End:
			ds.b	6		; unused

Screen_redraw_flag:		ds.b	1	; if whole screen needs to redraw, such as when you destroy that piston before the boss in WFZ
CPZ_UnkScroll_Timer:	ds.b	1	; Used only in unused CPZ scrolling function
			ds.b	$E		; unused

Water_flag:	ds.b	1		; if the level has water
			ds.b	$F		; unused

Demo_button_index_2P:	ds.w	1	; index into button press demo data, for player 2
Demo_press_counter_2P:	ds.w	1	; frames remaining until next button press, for player 2
			ds.b	$1C			; unused

Sonic_Speeds:
Sonic_top_speed:		ds.w	1
Sonic_acceleration:		ds.w	1
Sonic_deceleration:		ds.w	1
Sonic_Speeds_End:

v_sonframenum:		ds.b	1		; frame to display for Sonic
			ds.b	1			; $FFFFF767 ; seems unused
Primary_Angle:		ds.b	1
			ds.b	1			; $FFFFF769 ; seems unused
Secondary_Angle:	ds.b	1
			ds.b	1			; $FFFFF76B ; seems unused
Obj_placement_routine:	ds.b	1
			ds.b	1			; $FFFFF76D ; seems unused
Camera_X_pos_last:	ds.w	1		; Camera_X_pos_coarse from the previous frame
Camera_X_pos_last_End:

Object_Manager_Addresses:
Obj_load_addr_right:	ds.l	1	; contains the address of the next object to load when moving right
Obj_load_addr_left:		ds.l	1	; contains the address of the last object loaded when moving left
Object_Manager_Addresses_End:

Object_Manager_Addresses_P2:
Obj_load_addr_right_P2:	ds.l	1
Obj_load_addr_left_P2:	ds.l	1
Object_Manager_Addresses_P2_End:

Object_manager_2P_RAM:				; The next 16 bytes belong to this.
Object_RAM_block_indices:	ds.b	6	; seems to be an array of horizontal chunk positions, used for object position range checks
Player_1_loaded_object_blocks:	ds.b	3
Player_2_loaded_object_blocks:	ds.b	3

Camera_X_pos_last_P2:	ds.w	1
Camera_X_pos_last_P2_End:

Obj_respawn_index_P2:	ds.b	2	; respawn table indices of the next objects when moving left or right for the second player
Obj_respawn_index_P2_End:
Object_manager_2P_RAM_End:

Demo_button_index:		ds.w	1	; index into button press demo data, for player 1
Demo_press_counter:		ds.b	1	; frames remaining until next button press, for player 1
			ds.b	1		; $FFFFF793 ; seems unused
PalChangeSpeed:		ds.w	1
v_collindex:		ds.w	1		; RAM address for collision index of current level
v_palss_num:		ds.w	1		; palette cycling in Special Stage - reference number
v_palss_time:		ds.w	1		; palette cycling in Special Stage - time until next change
v_palss_index:		ds.w	1		; palette cycling in Special Stage - index into palette cycle 2 (unused?)
v_ssbganim:		ds.w	1		; Special Stage background animation
			ds.b	5		; seems unused
v_bossstatus:		ds.b	1
			ds.b	2		; seems unused
f_lockscreen:		ds.b	1
			ds.b	$13		; unused
v_gfxbigring:		ds.w	1		; settings for giant ring graphics loading
			ds.b	7		; unused
f_wtunnelmode:		ds.b	1		; LZ water tunnel mode
f_playerctrl:		ds.b	1		; Player control override flags (object ineraction, control enable)
f_wtunnelallow:		ds.b	1		; LZ water tunnels (00 = enabled; 01 = disabled)
f_slidemode:		ds.b	1		; LZ water slide mode
			ds.b	1		; unused
f_lockctrl:		ds.b	1		; flag set to lock controls during ending sequence
f_bigring:		ds.b	1		; flag set when Sonic collects the giant ring
			ds.b	2		; unused
v_itembonus:		ds.w	1		; item bonus from broken enemies, blocks etc.
v_timebonus:		ds.w	1		; time bonus at the end of an act
v_ringbonus:		ds.w	1		; ring bonus at the end of an act
f_endactbonus:		ds.b	1		; time/ring bonus update flag at the end of an act
			ds.b	1		; unused
v_lz_deform:		ds.w	1		; LZ deformation offset, in units of $80

Camera_X_pos_coarse:		ds.w	1	; (Camera_X_pos - 128) / 256
Camera_X_pos_coarse_End:

Camera_X_pos_coarse_P2:		ds.w	1
Camera_X_pos_coarse_P2_End:

v_tlsframenum:	ds.b	1			; frame to display for Tails
v_tlstlsframenum:	ds.b	1		; frame to display for Tails' tails

f_switch:		ds.b	$10			; flags set when Sonic stands on a switch

Anim_Counters:	ds.b	$10		; $FFFFF7F0-$FFFFF7FF

v_levelvariables_end:

v_spritetablebuffer:	ds.b	$280		; sprite table (last $80 bytes are overwritten by v_palette_water_fading)
v_spritetablebuffer_end:

v_palette_water_fading = v_spritetablebuffer_end-palette_size	; duplicate underwater palette, used for transitions ($80 bytes)

v_palette_water:	; main underwater palette
v_palette_water_line_1:	ds.b $20
v_palette_water_line_2:	ds.b $20
v_palette_water_line_3:	ds.b $20
v_palette_water_line_4:	ds.b $20
v_palette_water_end:

v_palette:		; main palette
v_palette_line_1:	ds.b $20
v_palette_line_2:	ds.b $20
v_palette_line_3:	ds.b $20
v_palette_line_4:	ds.b $20
v_palette_end:

v_palette_fading:	; duplicate palette, used for transitions
v_palette_fading_line_1:ds.b $20
v_palette_fading_line_2:ds.b $20
v_palette_fading_line_3:ds.b $20
v_palette_fading_line_4:ds.b $20
v_palette_fading_end:

v_objstate:		ds.b	$C0		; object state list
v_objstate_end:
			ds.b	$140		; stack
v_systemstack:
v_crossresetram:				; RAM beyond this point is only cleared on a cold-boot
			ds.b	2		; unused
f_restart:		ds.w	1		; restart level flag
v_framecount:		ds.w	1		; frame counter (adds 1 every frame)
			ds.b	1		; unused
v_debugitem:		ds.b	1		; debug item currently selected (NOT the object number of the item)
v_debuguse:		ds.w	1		; debug mode use & routine counter (when Sonic is a ring/item)
v_debugspeedtimer:	ds.b	1		; debug mode - timer before movement starts
v_debugspeed:		ds.b	1		; debug mode - movement speed
v_vblank_count:		ds.l	1		; vertical interrupt counter (adds 1 every VBlank)


v_zone:			ds.b	1			; (1 byte)
v_act:			ds.b	1			; (1 byte)
v_lives:		ds.b	1			; (1 byte)
			ds.b	1		; unused
v_air:			ds.w	1		; air remaining while underwater
v_airbyte:	equ	v_air+1			; low byte for air
v_lastspecial:		ds.b	1		; last special stage number
			ds.b	1		; unused
v_continues:		ds.b	1		; number of continues
			ds.b	1		; unused
f_timeover:		ds.b	1		; time over flag
v_lifecount:		ds.b	1		; lives counter value (for actual number, see "v_lives")
f_lifecount:		ds.b	1		; lives counter update flag
f_ringcount:		ds.b	1		; ring counter update flag
f_timecount:		ds.b	1		; time counter update flag
f_scorecount:		ds.b	1		; score counter update flag
v_rings:		ds.w	1		; rings
v_ringbyte:	equ	v_rings+1		; low byte for rings
v_time:			ds.l	1		; time
v_timemin:	equ	v_time+1		; time - minutes
v_timesec:	equ	v_time+2		; time - seconds
v_timecent:	equ	v_time+3		; time - centiseconds
v_score:		ds.l	1		; score
			ds.b	2		; unused
v_shield:		ds.b	1		; shield status (00 = no; 01 = yes)
v_invinc:		ds.b	1		; invinciblity status (00 = no; 01 = yes)
v_shoes:		ds.b	1		; speed shoes status (00 = no; 01 = yes)
v_unused1:		ds.b	1		; an unused fourth player status (Goggles?)

v_lastlamp:		ds.b	2		; number of the last lamppost you hit
v_lamp_xpos:		ds.w	1		; x-axis for Sonic to respawn at lamppost
v_lamp_ypos:		ds.w	1		; y-axis for Sonic to respawn at lamppost
v_lamp_rings:		ds.w	1		; rings stored at lamppost
v_lamp_time:		ds.l	1		; time stored at lamppost
v_lamp_dle:		ds.b	1		; dynamic level event routine counter at lamppost
			ds.b	1		; unused
v_lamp_limitbtm:	ds.w	1		; level bottom boundary at lamppost
v_lamp_scrx:		ds.w	1		; x-axis screen at lamppost
v_lamp_scry:		ds.w	1		; y-axis screen at lamppost
v_lamp_bgscrx:		ds.w	1		; x-axis BG screen at lamppost
v_lamp_bgscry:		ds.w	1		; y-axis BG screen at lamppost
v_lamp_bg2scrx:		ds.w	1		; x-axis BG2 screen at lamppost
v_lamp_bg2scry:		ds.w	1		; y-axis BG2 screen at lamppost
v_lamp_bg3scrx:		ds.w	1		; x-axis BG3 screen at lamppost
v_lamp_bg3scry:		ds.w	1		; y-axis BG3 screen at lamppost
v_lamp_wtrpos:		ds.w	1		; water position at lamppost
v_lamp_wtrrout:		ds.b	1		; water routine at lamppost
v_lamp_wtrstat:		ds.b	1		; water state at lamppost
v_lamp_lives:		ds.b	1		; lives counter at lamppost
			ds.b	2		; unused
v_emeralds:		ds.b	1		; number of chaos emeralds
v_emldlist:		ds.b	6		; special stage where each emerald was obtained
v_oscillate:		ds.w	1		; oscillation bitfield

v_timingvariables:
			ds.b	$40		; values which oscillate - for swinging platforms, et al
			ds.b	$20		; unused
v_ani0_time:		ds.b	1		; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame:		ds.b	1		; synchronised sprite animation 0 - current frame
v_ani1_time:		ds.b	1		; synchronised sprite animation 1 - time until next frame
v_ani1_frame:		ds.b	1		; synchronised sprite animation 1 - current frame
v_ani2_time:		ds.b	1		; synchronised sprite animation 2 - time until next frame
v_ani2_frame:		ds.b	1		; synchronised sprite animation 2 - current frame
v_ani3_time:		ds.b	1		; synchronised sprite animation 3 - time until next frame
v_ani3_frame:		ds.b	1		; synchronised sprite animation 3 - current frame
v_ani3_buf:		ds.w	1		; synchronised sprite animation 3 - info buffer
			ds.b	$26		; unused
v_limittopdb:		ds.w	1		; level upper boundary, buffered for debug mode
v_limitbtmdb:		ds.w	1		; level bottom boundary, buffered for debug mode
			ds.b	$8C		; unused
v_timingvariables_end:

v_levseldelay:		ds.w	1		; level select - time until change when up/down is held
v_levselitem:		ds.w	1		; level select - item selected
v_levselsound:		ds.w	1		; level select - sound selected
			ds.b	$3A		; unused

v_scorelife:		ds.l	1		; points required for an extra life
			ds.b	$1C		; unused
f_levselcheat:		ds.b	1		; level select cheat flag
f_slomocheat:		ds.b	1		; slow motion & frame advance cheat flag
f_debugcheat:		ds.b	1		; debug mode cheat flag
f_creditscheat:		ds.b	1		; hidden credits & press start cheat flag
v_title_dcount:		ds.w	1		; number of times the d-pad is pressed on title screen
v_title_ccount:		ds.w	1		; number of times C is pressed on title screen
Two_player_mode:	ds.w	1
Two_player_mode_lo	= Two_player_mode+1
word_FFEA:			ds.w	1
			ds.w	2		; unused
f_demo:			ds.w	1		; demo mode flag (0 = no; 1 = yes; $8001 = ending)
v_demonum:		ds.w	1		; demo level number (not the same as the level number)
v_creditsnum:		ds.w	1		; credits index number
			ds.b	2		; unused
v_megadrive:		ds.b	1		; Megadrive machine type
			ds.b	1		; unused
f_debugmode:		ds.w	1		; debug mode flag
v_init:			ds.l	1		; 'init' text string
v_ram_end:
    if * > 0	 ; Don't declare more space than the RAM can contain!
	fatal "The RAM variable declarations are too large by $\{*} bytes."
    elseif * < 0 ; Likely missing or misaligned RAM declarations!
	warning "RAM variable declarations are \{signedToString(*)} bytes smaller than expected. Some variables may be missing or not aligned correctly!"
    endif

	dephase

; Special stage
v_ssangle:			equ ramaddr($FFFFF780)
v_ssrotate:			equ ramaddr($FFFFF782)
v_ssbuffer1:		equ	v_ram_start
v_ssblockbuffer:	equ	v_ssbuffer1+$1020 ; ($2000 bytes)
v_ssblockbuffer_end:	equ	v_ssblockbuffer+$80*$40
v_ssbuffer2:		equ	v_ram_start+$4000
v_ssblocktypes:		equ	v_ssbuffer2
v_ssitembuffer:		equ	v_ssbuffer2+$400 ; ($100 bytes)
v_ssitembuffer_end:	equ	v_ssitembuffer+$100
v_ssbuffer3:		equ	v_ram_start_def+$8000
v_ssscroll_buffer:	equ	v_ngfx_buffer+$100

; Error handler
	phase v_objstate
v_regbuffer:	ds.b	$40	; stores registers d0-a7 during an error event
v_spbuffer:	ds.l	1	; stores most recent sp address
v_errortype:	ds.b	1	; error type
	dephase

	!org 0