; ---------------------------------------------------------------------------
; Constants
; ---------------------------------------------------------------------------

Size_of_SegaPCM:		equ $6978
Size_of_DAC_driver_guess:	equ $1760

; Clocks
Master_Clock:    equ 53693175
M68000_Clock:    equ Master_Clock/7
Z80_Clock:       equ Master_Clock/15
FM_Sample_Rate:  equ M68000_Clock/(6*6*4)
PSG_Sample_Rate: equ Z80_Clock/16

; VDP addressses
vdp_data_port:		equ $C00000
vdp_control_port:	equ $C00004
VDP_data_port:		equ vdp_data_port
VDP_control_port: 	equ vdp_control_port
vdp_counter:	equ $C00008
psg_input:		equ $C00011
debug_reg:		equ $C0001C

; Z80 addresses
z80_ram:		equ $A00000	; start of Z80 RAM
z80_dac3_pitch:		equ $A000EA
z80_dac_status:		equ $A01FFD
z80_dac_sample:		equ $A01FFF
z80_ram_end:		equ $A02000	; end of non-reserved Z80 RAM
ym2612_a0:		equ $A04000
ym2612_d0:		equ $A04001
ym2612_a1:		equ $A04002
ym2612_d1:		equ $A04003
z80_bus_request:	equ $A11100
z80_reset:		equ $A11200

; I/O addresses
console_version:	equ $A10001
port_1_data_hi:		equ $A10002
port_1_data:		equ $A10003
port_2_data_hi:		equ $A10004
port_2_data:		equ $A10005
port_1_control_hi:	equ $A10008
port_1_control:		equ $A10009
port_2_control_hi:	equ $A1000A
port_2_control:		equ $A1000B
expansion_control_hi:	equ $A1000C
expansion_control:	equ $A1000D

; Misc addresses
sram_port:		equ $A130F1
security_addr:		equ $A14000

; VRAM data
vram_fg:	equ $C000				; foreground namespace
vram_bg:	equ $E000				; background namespace
vram_fg_2p:	equ $A000				; foreground namespace
vram_bg_2p:	equ $8000				; background namespace
vram_sprites:	equ $F800				; sprite table
vram_hscroll:	equ $FC00				; horizontal scroll table

; Various sizes
tile_size:	equ 8*8/2	; size of a single 8x8 tile
chunk_size_128:	equ $80		; size of a single 128x128 chunk
plane_size_64x32: equ 64*32*2	; size of plane in 512x256 mode

palette_size:	equ $80

layout_row_interlaced:	equ $80	; size of a single level layout row (FG/BG alternating)
layout_row:		equ layout_row_interlaced*2	; size of a single level layout row (skipping over other plane)

; Sonic 1 Constants
S1_EndOfRom:	equ $80000			; Sonic 1 End of Rom size

; ===========================================================================
; ---------------------------------------------------------------------------
; Object Status Table offsets
; ---------------------------------------------------------------------------

; Object variables
obID:		equ 0					; object ID number
obRender:	equ 1					; bitfield for x/y flip, display mode
obGfx:		equ 2					; palette line & VRAM setting (2 bytes)
obMap:		equ 4					; mappings address (4 bytes)
obX:		equ 8					; x-axis position (2-4 bytes)
obScreenY:	equ $A					; y-axis position for screen-fixed items (2 bytes)
obY:		equ $C					; y-axis position (2-4 bytes)
obVelX:		equ $10					; x-axis velocity (2 bytes)
obVelY:		equ $12					; y-axis velocity (2 bytes)
obInertia:	equ $14					; potential speed (2 bytes)
obHeight:	equ $16					; height/2
obWidth:	equ $17					; width/2
obPriority:	equ $18					; sprite stack priority -- 0 is front
obActWid:	equ $19					; action width
obFrame:	equ $1A					; current frame displayed
obAniFrame:	equ $1B					; current frame in animation script
obAnim:		equ $1C					; current animation
obPrevAni:	equ $1D					; previous animation
obTimeFrame:	equ $1E					; time to next frame
obDelayAni:	equ $1F					; time to delay animation
obColType:	equ $20					; collision response type
obColProp:	equ $21					; collision extra property
obStatus:	equ $22					; orientation or mode
obRespawnNo:	equ $23					; respawn list index number
obRoutine:	equ $24					; routine number
ob2ndRout:	equ $25					; secondary routine number
obAngle:	equ $26					; angle
obSubtype:	equ $28					; object subtype
obSolid:	equ ob2ndRout				; solid status flag

top_solid_bit:	equ	$3E 			; the bit to check for top solidity (either $C or $E)
lrb_solid_bit:	equ	$3F 			; the bit to check for left/right/bottom solidity (either $D or $F)

obTopSolidBit:	equ $3E					; bit to check for top solidity (either $C or $E)
obLRBSolidBit:	equ $3F					; bit to check for left/right/bottom solidity (either $D or $F)

; Object variables used by Sonic/Tails
flip_angle:	equ $27 ; angle about the x axis (360 degrees = 256) (twist/tumble)
flips_remaining: equ $2C ; number of flip revolutions remaining
flip_speed:	equ $2D ; number of flip revolutions per frame / 256
locktime:	equ $2E	; temporary D-Pad control lock timer (2 bytes)
flashtime:	equ $30	; time between flashes after getting hit (2 bytes)
invtime:	equ $32	; time left for invincibility (2 bytes)
shoetime:	equ $34	; time left for speed shoes (2 bytes)
angleright:	equ $36	; angle of floor on Sonic's right side
angleleft:	equ $37	; angle of floor on Sonic's left side
sticktoconvex:	equ $38	; flag set while running on an SBZ gear
spindash_flag:	equ $39	; 0 for normal, 1 for charging a spindash or forced rolling
restartime:	equ $3A	; time left before level restarts after dying (2 bytes)
jumping:	equ $3C	; flag set while Sonic is jumping
standonobject:	equ $3D	; object index Sonic stands on

; Miscellaneous object scratch-RAM
objoff_25:	equ $25
objoff_26:	equ $26
objoff_27:	equ $27
objoff_29:	equ $29
objoff_2A:	equ $2A
objoff_2B:	equ $2B
objoff_2C:	equ $2C
objoff_2D:	equ $2D
objoff_2E:	equ $2E
objoff_2F:	equ $2F
objoff_30:	equ $30
objoff_32:	equ $32
objoff_33:	equ $33
objoff_34:	equ $34
objoff_35:	equ $35
objoff_36:	equ $36
objoff_37:	equ $37
objoff_38:	equ $38
objoff_39:	equ $39
objoff_3A:	equ $3A
objoff_3B:	equ $3B
objoff_3C:	equ $3C
objoff_3D:	equ $3D
objoff_3E:	equ $3E
objoff_3F:	equ $3F

object_size_bits:	equ 6
object_size:	equ 1<<object_size_bits

; ---------------------------------------------------------------------------
; when childsprites are activated (i.e. bit #6 of render_flags set)
next_subspr	= 6
mainspr_mapframe	= $B
mainspr_width	= $E
mainspr_childsprites = $F	; amount of child sprites
mainspr_height	= $14
subspr_data	= $10
sub2_x_pos	= subspr_data+next_subspr*0+0	;x_vel
sub2_y_pos	= subspr_data+next_subspr*0+2	;y_vel
sub2_mapframe	= subspr_data+next_subspr*0+5
sub3_x_pos	= subspr_data+next_subspr*1+0	;y_radius
sub3_y_pos	= subspr_data+next_subspr*1+2	;priority
sub3_mapframe	= subspr_data+next_subspr*1+5	;anim_frame
sub4_x_pos	= subspr_data+next_subspr*2+0	;anim
sub4_y_pos	= subspr_data+next_subspr*2+2	;anim_frame_duration
sub4_mapframe	= subspr_data+next_subspr*2+5	;collision_property
sub5_x_pos	= subspr_data+next_subspr*3+0	;status
sub5_y_pos	= subspr_data+next_subspr*3+2	;routine
sub5_mapframe	= subspr_data+next_subspr*3+5
sub6_x_pos	= subspr_data+next_subspr*4+0	;subtype
sub6_y_pos	= subspr_data+next_subspr*4+2
sub6_mapframe	= subspr_data+next_subspr*4+5
sub7_x_pos	= subspr_data+next_subspr*5+0
sub7_y_pos	= subspr_data+next_subspr*5+2
sub7_mapframe	= subspr_data+next_subspr*5+5
sub8_x_pos	= subspr_data+next_subspr*6+0
sub8_y_pos	= subspr_data+next_subspr*6+2
sub8_mapframe	= subspr_data+next_subspr*6+5
sub9_x_pos	= subspr_data+next_subspr*7+0
sub9_y_pos	= subspr_data+next_subspr*7+2
sub9_mapframe	= subspr_data+next_subspr*7+5

; Levels
id_GHZ:	equ 0
id_LZ:	equ 1
id_CPZ:	equ 2
id_MZ:	equ 2
id_EHZ:	equ 3
id_SLZ:	equ 3
id_HPZ:	equ 4
id_SYZ:	equ 4
id_HTZ:	equ 5
id_SBZ:	equ 5
id_EndZ:	equ 6
id_SS:	equ 7

; Colours
cBlack:	equ $000				; colour black
cWhite:	equ $EEE				; colour white
cBlue:	equ $E00				; colour blue
cGreen:	equ $0E0				; colour green
cRed:	equ $00E				; colour red
cYellow:	equ cGreen+cRed				; colour yellow
cAqua:	equ cGreen+cBlue			; colour aqua
cMagenta:	equ cBlue+cRed				; colour magenta
cCyan:	equ $880				; colour cyan
; ---------------------------------------------------------------------------
; Controller Buttons

; Buttons bit numbers
bitUp:	EQU	0
bitDn:	EQU	1
bitL:	EQU	2
bitR:	EQU	3
bitB:	EQU	4
bitC:	EQU	5
bitA:	EQU	6
bitStart:	EQU	7
; Buttons masks (1 << x == pow(2, x))
btnUp:	EQU	1<<bitUp		; $01
btnDn:	EQU	1<<bitDn		; $02
btnL:	EQU	1<<bitL			; $04
btnR:	EQU	1<<bitR			; $08
btnB:	EQU	1<<bitB			; $10
btnC:	EQU	1<<bitC			; $20
btnA:	EQU	1<<bitA			; $40
btnABC:	EQU	btnA+btnB+btnC		; $70
btnStart:	EQU	1<<bitStart		; $80
; ---------------------------------------------------------------------------
; Art tile stuff
flip_x	=	(1<<11)
flip_y	=	(1<<12)
palette_bit_0	=	5
palette_bit_1	=	6
palette_line_0	=	(0<<13)
palette_line_1	=	(1<<13)
palette_line_2	=	(2<<13)
palette_line_3	=	(3<<13)
high_priority_bit	=	7
high_priority	=	(1<<15)
palette_mask	=	$6000
tile_mask	=	$7FF
nontile_mask	=	$F800
drawing_mask	=	$7FFF

; Animation IDs
	phase 0
AniIDSonAni_Walk:		ds.b 1
AniIDSonAni_Run:		ds.b 1
AniIDSonAni_Roll:		ds.b 1
AniIDSonAni_Roll2:		ds.b 1
AniIDSonAni_Push:		ds.b 1
AniIDSonAni_Wait:		ds.b 1
AniIDSonAni_Balance:	ds.b 1
AniIDSonAni_LookUp:		ds.b 1
AniIDSonAni_Duck:		ds.b 1
AniIDSonAni_Spindash:	ds.b 1
AniIDSonAni_WallRecoil1:	ds.b 1
AniIDSonAni_WallRecoil2:	ds.b 1
AniIDSonAni_WailRecoil3:	ds.b 1
AniIDSonAni_Stop:		ds.b 1
AniIDSonAni_Float:		ds.b 1
AniIDSonAni_Float2:		ds.b 1
AniIDSonAni_Spring:		ds.b 1
AniIDSonAni_S1Hang:		ds.b 1
AniIDSonAni_S1Leap1:	ds.b 1
AniIDSonAni_S1Leap2:	ds.b 1
AniIDSonAni_S1Surf:		ds.b 1
AniIDSonAni_Bubble:		ds.b 1
AniIDSonAni_Burnt:		ds.b 1
AniIDSonAni_Drown:		ds.b 1
AniIDSonAni_Death:		ds.b 1
AniIDSonAni_S1Shrink:	ds.b 1
AniIDSonAni_Hurt:		ds.b 1
AniIDSonAni_WaterSlide:	ds.b 1
AniIDSonAni_Blank:		ds.b 1
AniIDSonAni_Float3:		ds.b 1
AniIDSonAni_S1Float4:	ds.b 1
	dephase
	!org 0

	phase 0
AniIDTailsAni_Walk:		ds.b 1
AniIDTailsAni_Run:		ds.b 1
AniIDTailsAni_Roll:		ds.b 1
AniIDTailsAni_Roll2:		ds.b 1
AniIDTailsAni_Push:		ds.b 1
AniIDTailsAni_Wait:		ds.b 1
AniIDTailsAni_Balance:	ds.b 1
AniIDTailsAni_LookUp:		ds.b 1
AniIDTailsAni_Duck:		ds.b 1
AniIDTailsAni_Spindash:	ds.b 1
AniIDTailsAni_WallRecoil1:	ds.b 1
AniIDTailsAni_WallRecoil2:	ds.b 1
AniIDTailsAni_WailRecoil3:	ds.b 1
AniIDTailsAni_Stop:		ds.b 1
AniIDTailsAni_Fly:		ds.b 1
AniIDTailsAni_Float2:		ds.b 1
AniIDTailsAni_Spring:		ds.b 1
AniIDTailsAni_Hang:		ds.b 1
AniIDTailsAni_Leap1:	ds.b 1
AniIDTailsAni_Leap2:	ds.b 1
AniIDTailsAni_Surf:		ds.b 1
AniIDTailsAni_Bubble:		ds.b 1
AniIDTailsAni_Burnt:		ds.b 1
AniIDTailsAni_Drown:		ds.b 1
AniIDTailsAni_Death:		ds.b 1
AniIDTailsAni_Shrink:	ds.b 1
AniIDTailsAni_Hurt:		ds.b 1
AniIDTailsAni_WaterSlide:	ds.b 1
AniIDTailsAni_Blank:		ds.b 1
AniIDTailsAni_Float3:		ds.b 1
AniIDTailsAni_Float4:	ds.b 1
	dephase
	!org 0

; ===========================================================================
; ---------------------------------------------------------------------------
; V-Int routines
offset :=	Vint_SwitchTbl
ptrsize :=	1
idstart :=	0

VintID_Lag =	id(Vint_Lag_ptr)	; 0
VintID_SEGA =	id(Vint_SEGA_ptr)	; 2
VintID_Title =	id(Vint_Title_ptr)	; 4
VintID_Unused6 =	id(Vint_Unused6_ptr)	; 6
VintID_Level =	id(Vint_Level_ptr)	; 8
VintID_S1SS =	id(Vint_S1SS_ptr)	; $A
VintID_TitleCard =	id(Vint_TitleCard_ptr)	; $C
VintID_UnusedE =	id(Vint_UnusedE_ptr)	; $E
VintID_Pause =	id(Vint_Pause_ptr)	; $10
VintID_Fade =	id(Vint_Fade_ptr)	; $12
VintID_PCM =	id(Vint_PCM_ptr)	; $14
VintID_SSResults =	id(Vint_SSResults_ptr)	; $16
VintID_TitleCard2 =	id(Vint_TitleCard2_ptr)	; $18

; Game modes
offset :=	GameModeArray
ptrsize :=	1
idstart :=	0
GameModeID_SegaScreen =		id(GameMode_SegaScreen)	; 0
GameModeID_TitleScreen =	id(GameMode_TitleScreen) ; 4
GameModeID_Demo =		id(GameMode_Demo)	; 8
GameModeID_Level =		id(GameMode_Level)	; $C
GameModeID_SpecialStage =	id(GameMode_SpecialStage) ; $10
GameModeID_ContinueScreen:	equ $14			; $14 ; referenced despite it not existing
GameModeID_S1Ending:		equ $18			; $18 ; referenced despite it not existing
GameModeID_S1Credits:		equ $1C			; $1C ; referenced despite it not existing
GameModeID_S1End: 			equ	GameModeID_S1Credits	; $1C ; referenced despite it not existing
GameModeID_End: 			equ	GameModeID_SpecialStage	; $10
GameModeFlag_TitleCard:		equ 7			; flag bit
GameModeID_TitleCard:		equ 1<<GameModeFlag_TitleCard ; $80 ; flag mask

; I/O Area
HW_Version:			equ $A10001
HW_Port_1_Data:			equ $A10003
HW_Port_2_Data:			equ $A10005
HW_Expansion_Data:		equ $A10007
HW_Port_1_Control:		equ $A10009
HW_Port_2_Control:		equ $A1000B
HW_Expansion_Control:		equ $A1000D
HW_Port_1_TxData:		equ $A1000F
HW_Port_1_RxData:		equ $A10011
HW_Port_1_SCtrl:		equ $A10013
HW_Port_2_TxData:		equ $A10015
HW_Port_2_RxData:		equ $A10017
HW_Port_2_SCtrl:		equ $A10019
HW_Expansion_TxData:		equ $A1001B
HW_Expansion_RxData:		equ $A1001D
HW_Expansion_SCtrl:		equ $A1001F

; Background music
offset :=	MusicIndex
ptrsize :=	4
idstart :=	$81

bgm__First =	idstart
bgm_GHZ =	id(ptr_mus81)
bgm_LZ =	id(ptr_mus82)
bgm_MZ =	id(ptr_mus83)
bgm_SLZ =	id(ptr_mus84)
bgm_SYZ =	id(ptr_mus85)
bgm_SBZ =	id(ptr_mus86)
bgm_Invincible =	id(ptr_mus87)
bgm_ExtraLife =	id(ptr_mus88)
bgm_SS =	id(ptr_mus89)
bgm_Title =	id(ptr_mus8A)
bgm_Ending =	id(ptr_mus8B)
bgm_Boss =	id(ptr_mus8C)
bgm_FZ =	id(ptr_mus8D)
bgm_GotThrough =	id(ptr_mus8E)
bgm_GameOver =	id(ptr_mus8F)
bgm_Continue =	id(ptr_mus90)
bgm_Credits =	id(ptr_mus91)
bgm_Drowning =	id(ptr_mus92)
bgm_Emerald =	id(ptr_mus93)
bgm__Last =	id(ptr_musend)-1

; Sound effects
offset :=	SoundIndex
ptrsize :=	4
idstart :=	$A0

sfx__First =	idstart
sfx_Jump =	id(ptr_sndA0)
sfx_Lamppost =	id(ptr_sndA1)
sfx_A2 =	id(ptr_sndA2)
sfx_Death =	id(ptr_sndA3)
sfx_Skid =	id(ptr_sndA4)
sfx_A5 =	id(ptr_sndA5)
sfx_HitSpikes =	id(ptr_sndA6)
sfx_Push =	id(ptr_sndA7)
sfx_SSGoal =	id(ptr_sndA8)
sfx_SSItem =	id(ptr_sndA9)
sfx_Splash =	id(ptr_sndAA)
sfx_AB =	id(ptr_sndAB)
sfx_HitBoss =	id(ptr_sndAC)
sfx_Bubble =	id(ptr_sndAD)
sfx_Fireball =	id(ptr_sndAE)
sfx_Shield =	id(ptr_sndAF)
sfx_Saw =	id(ptr_sndB0)
sfx_Electric =	id(ptr_sndB1)
sfx_Drown =	id(ptr_sndB2)
sfx_Flamethrower =	id(ptr_sndB3)
sfx_Bumper =	id(ptr_sndB4)
sfx_Ring =	id(ptr_sndB5)
sfx_SpikesMove =	id(ptr_sndB6)
sfx_Rumbling =	id(ptr_sndB7)
sfx_B8 =	id(ptr_sndB8)
sfx_Collapse =	id(ptr_sndB9)
sfx_SSGlass =	id(ptr_sndBA)
sfx_Door =	id(ptr_sndBB)
sfx_Teleport =	id(ptr_sndBC)
sfx_ChainStomp =	id(ptr_sndBD)
sfx_Roll =	id(ptr_sndBE)
sfx_Continue =	id(ptr_sndBF)
sfx_Basaran =	id(ptr_sndC0)
sfx_BreakItem =	id(ptr_sndC1)
sfx_Warning =	id(ptr_sndC2)
sfx_GiantRing =	id(ptr_sndC3)
sfx_Bomb =	id(ptr_sndC4)
sfx_Cash =	id(ptr_sndC5)
sfx_RingLoss =	id(ptr_sndC6)
sfx_ChainRise =	id(ptr_sndC7)
sfx_Burning =	id(ptr_sndC8)
sfx_Bonus =	id(ptr_sndC9)
sfx_EnterSS =	id(ptr_sndCA)
sfx_WallSmash =	id(ptr_sndCB)
sfx_Spring =	id(ptr_sndCC)
sfx_Switch =	id(ptr_sndCD)
sfx_RingLeft =	id(ptr_sndCE)
sfx_Signpost =	id(ptr_sndCF)
sfx__Last =	id(ptr_sndend)-1

; Special sound effects
offset :=	SpecSoundIndex
ptrsize :=	4
idstart :=	$D0

spec__First =	idstart
sfx_Waterfall =	id(ptr_sndD0)
spec__Last =	id(ptr_specend)-1

offset :=	Sound_ExIndex
ptrsize :=	4
idstart :=	$E0

flg__First =	idstart
bgm_Fade =	id(ptr_flgE0)
sfx_Sega =	id(ptr_flgE1)
bgm_Speedup =	id(ptr_flgE2)
bgm_Slowdown =	id(ptr_flgE3)
bgm_Stop =	id(ptr_flgE4)
flg__Last =	id(ptr_flgend)-1

; Boss locations
; The main values are based on where the camera boundaries mainly lie
; The end values are where the camera scrolls towards after defeat
boss_ghz_x:	equ $2960		; Green Hill Zone
boss_ghz_y:	equ $300
boss_ghz_end:	equ boss_ghz_x+$160

boss_lz_x:	equ $1DE0		; Labyrinth Zone
boss_lz_y:	equ $C0
boss_lz_end:	equ boss_lz_x+$250

boss_mz_x:	equ $1800		; Marble Zone
boss_mz_y:	equ $210
boss_mz_end:	equ boss_mz_x+$160

boss_slz_x:	equ $2000		; Star Light Zone
boss_slz_y:	equ $210
boss_slz_end:	equ boss_slz_x+$160

boss_syz_x:	equ $2C00		; Spring Yard Zone
boss_syz_y:	equ $4CC
boss_syz_end:	equ boss_syz_x+$140

boss_sbz2_x:	equ $2050		; Scrap Brain Zone Act 2 Cutscene
boss_sbz2_y:	equ $510

boss_fz_x:	equ $2450		; Final Zone
boss_fz_y:	equ $510
boss_fz_end:	equ boss_fz_x+$2B0

; Tile VRAM Locations

; Shared
ArtTile_GHZ_MZ_Swing:		equ $380
ArtTile_GHZ_Swing:	equ $4D0
ArtTile_MZ_SYZ_Caterkiller:	equ $4FF
ArtTile_GHZ_SLZ_Smashable_Wall:	equ $50F

; Green Hill Zone
ArtTile_GHZ_Flower_4:		equ ArtTile_Level+$340
ArtTile_GHZ_Edge_Wall:		equ $34C
ArtTile_GHZ_Flower_Stalk:	equ ArtTile_Level+$358
ArtTile_GHZ_Big_Flower_1:	equ ArtTile_Level+$35C
ArtTile_GHZ_Small_Flower:	equ ArtTile_Level+$36C
ArtTile_GHZ_Waterfall:		equ ArtTile_Level+$378
ArtTile_GHZ_Flower_3:		equ ArtTile_Level+$380
ArtTile_GHZ_Bridge:		equ $4C6
ArtTile_GHZ_Big_Flower_2:	equ ArtTile_Level+$390
ArtTile_GHZ_Spike_Pole:		equ $398
ArtTile_GHZ_Giant_Ball:		equ $3AA
ArtTile_GHZ_Purple_Rock:	equ $6C0

; Marble Zone
ArtTile_MZ_Block:		equ $2B8
ArtTile_MZ_Animated_Magma:	equ ArtTile_Level+$2D2
ArtTile_MZ_Animated_Lava:	equ ArtTile_Level+$2E2
ArtTile_MZ_Torch:		equ ArtTile_Level+$2F2
ArtTile_MZ_Spike_Stomper:	equ $300
ArtTile_MZ_Fireball:		equ $345
ArtTile_MZ_Glass_Pillar:	equ $38E
ArtTile_MZ_Lava:		equ $3A8

; Spring Yard Zone
ArtTile_SYZ_Bumper:		equ $380
ArtTile_SYZ_Big_Spikeball:	equ $396
ArtTile_SYZ_Spikeball_Chain:	equ $3BA

; Labyrinth Zone
ArtTile_LZ_Block_1:		equ $1E0
ArtTile_LZ_Block_2:		equ $1F0
ArtTile_LZ_Splash:		equ $259
ArtTile_LZ_Gargoyle:		equ $2E9
ArtTile_LZ_Water_Surface:	equ $300
ArtTile_LZ_Spikeball_Chain:	equ $310
ArtTile_LZ_Flapping_Door:	equ $328
ArtTile_LZ_Bubbles:		equ $348
ArtTile_LZ_Moving_Block:	equ $3BC
ArtTile_LZ_Door:		equ $3C4
ArtTile_LZ_Harpoon:		equ $3CC
ArtTile_LZ_Pole:		equ $3DE
ArtTile_LZ_Push_Block:		equ $3DE
ArtTile_LZ_Blocks:		equ $3E6
ArtTile_LZ_Conveyor_Belt:	equ $3F6
ArtTile_LZ_Sonic_Drowning:	equ $440
ArtTile_LZ_Rising_Platform:	equ ArtTile_LZ_Blocks+$69
ArtTile_LZ_Orbinaut:		equ $467
ArtTile_LZ_Cork:		equ ArtTile_LZ_Blocks+$11A

; Star Light Zone
ArtTile_SLZ_Seesaw:		equ $374
ArtTile_SLZ_Fan:		equ $3A0
ArtTile_SLZ_Pylon:		equ $3CC
ArtTile_SLZ_Swing:		equ $3DC
ArtTile_SLZ_Orbinaut:		equ $429
ArtTile_SLZ_Fireball:		equ $480
ArtTile_SLZ_Fireball_Launcher:	equ $4D8
ArtTile_SLZ_Collapsing_Floor:	equ $4E0
ArtTile_SLZ_Spikeball:		equ $4F0

; Scrap Brain Zone
ArtTile_SBZ_Caterkiller:	equ $2B0
ArtTile_SBZ_Moving_Block_Short:	equ $2C0
ArtTile_SBZ_Door:		equ $2E8
ArtTile_SBZ_Girder:		equ $2F0
ArtTile_SBZ_Disc:		equ $344
ArtTile_SBZ_Junction:		equ $348
ArtTile_SBZ_Swing:		equ $391
ArtTile_SBZ_Saw:		equ $3B5
ArtTile_SBZ_Flamethrower:	equ $3D9
ArtTile_SBZ_Collapsing_Floor:	equ $3F5
ArtTile_SBZ_Orbinaut:		equ $429
ArtTile_SBZ_Smoke_Puff_1:	equ ArtTile_Level+$448
ArtTile_SBZ_Smoke_Puff_2:	equ ArtTile_Level+$454
ArtTile_SBZ_Moving_Block_Long:	equ $460
ArtTile_SBZ_Horizontal_Door:	equ $46F
ArtTile_SBZ_Electric_Orb:	equ $47E
ArtTile_SBZ_Trap_Door:		equ $492
ArtTile_SBZ_Vanishing_Block:	equ $4C3
ArtTile_SBZ_Spinning_Platform:	equ $4DF

; Final Zone
ArtTile_FZ_Boss:		equ $300
ArtTile_FZ_Eggman_Fleeing:	equ $3A0
ArtTile_FZ_Eggman_No_Vehicle:	equ $470

; General Level Art
ArtTile_Level:			equ $000
ArtTile_Ball_Hog:		equ $302
ArtTile_Bomb:			equ $400
ArtTile_Crabmeat:		equ $400
ArtTile_Missile_Disolve:	equ $41C ; Unused
ArtTile_Spikes:			equ $434
ArtTile_S1_Spikes:		equ $4A0
ArtTile_Buzz_Bomber:		equ $444
ArtTile_Chopper:		equ $470
ArtTile_Yadrin:			equ $47B
ArtTile_Lamppost:		equ $47C
ArtTile_Jaws:			equ $486
ArtTile_Newtron:		equ $49B
ArtTile_Burrobot:		equ $4A6
ArtTile_Basaran:		equ $4B8
ArtTile_Roller:			equ $4B8
ArtTile_Moto_Bug:		equ $4E0
ArtTile_Button:			equ $50F
ArtTile_S1_Spring_Horizontal:	equ $4A8
ArtTile_S1_Spring_Vertical:	equ $4B8
ArtTile_Shield:			equ $4BE
ArtTile_Invincibility:		equ $4DE
ArtTile_Game_Over:		equ $55E
ArtTile_Title_Card:		equ $580
ArtTile_Animal_1:		equ $580
ArtTile_Animal_2:		equ $592
ArtTile_Explosion:		equ $5A0
ArtTile_Monitor:		equ $680
ArtTile_HUD:			equ $6CA
ArtTile_Sonic:			equ $780
ArtTile_Points:			equ $4AC
ArtTile_Tails:			equ $7A0
ArtTile_TailsTails:		equ $7B0
ArtTile_Ring:			equ $6BC
ArtTile_Lives_Counter:		equ $7D4
ArtTile_Water_Surface:		equ $400
ArtTile_Spring_Horizontal:	equ $470
ArtTile_Spring_Vertical:	equ $45C
ArtTile_Spring_Diagonal:	equ $43C

ArtTile_S1_Ring:		equ $7B2

; Eggman
ArtTile_Eggman:			equ $400
ArtTile_Eggman_Weapons:		equ $46C
ArtTile_Eggman_Button:		equ $4A4
ArtTile_Eggman_Spikeball:	equ $518
ArtTile_Eggman_Trap_Floor:	equ $518
ArtTile_Eggman_Exhaust:		equ ArtTile_Eggman+$12A

; End of Level
ArtTile_Giant_Ring:		equ $400
ArtTile_Giant_Ring_Flash:	equ $462
ArtTile_Prison_Capsule:		equ $49D
ArtTile_Hidden_Points:		equ $4B6
ArtTile_Warp:			equ $541
ArtTile_Mini_Sonic:		equ $551
ArtTile_Bonuses:		equ $570
ArtTile_Signpost:		equ $680

; Sega Screen
ArtTile_Sega_Tiles:		equ $000

; Title Screen
ArtTile_Title_Japanese_Text:	equ $000
ArtTile_Title_Foreground:	equ $000
ArtTile_Title_Sonic_And_Tails:	equ $200
ArtTile_Title_Sonic:		equ $300
ArtTile_Title_Trademark:	equ $510
ArtTile_Level_Select_Font:	equ $680

; Continue Screen
ArtTile_Continue_Sonic:		equ $500
ArtTile_Continue_Number:	equ $6FC

; Ending
ArtTile_Ending_Flowers:		equ $3A0
ArtTile_Ending_Emeralds:	equ $3C5
ArtTile_Ending_Sonic:		equ $3E1
ArtTile_Ending_Eggman:		equ $524
ArtTile_Ending_Rabbit:		equ $553
ArtTile_Ending_Chicken:		equ $565
ArtTile_Ending_Penguin:		equ $573
ArtTile_Ending_Seal:		equ $585
ArtTile_Ending_Pig:		equ $593
ArtTile_Ending_Flicky:		equ $5A5
ArtTile_Ending_Squirrel:	equ $5B3
ArtTile_Ending_STH:		equ $5C5

; Try Again Screen
ArtTile_Try_Again_Emeralds:	equ $3C5
ArtTile_Try_Again_Eggman:	equ $3E1

; Special Stage
ArtTile_SS_Background_Clouds:	equ $000
ArtTile_SS_Background_Fish:	equ $051
ArtTile_SS_Wall:		equ $142
ArtTile_SS_Plane_1:		equ $200
ArtTile_SS_Bumper:		equ $23B
ArtTile_SS_Goal:		equ $251
ArtTile_SS_Up_Down:		equ $263
ArtTile_SS_R_Block:		equ $2F0
ArtTile_SS_Plane_2:		equ $300
ArtTile_SS_Extra_Life:		equ $370
ArtTile_SS_Emerald_Sparkle:	equ $3F0
ArtTile_SS_Plane_3:		equ $400
ArtTile_SS_Red_White_Block:	equ $470
ArtTile_SS_Ghost_Block:		equ $4F0
ArtTile_SS_Plane_4:		equ $500
ArtTile_SS_W_Block:		equ $570
ArtTile_SS_Glass:		equ $5F0
ArtTile_SS_Plane_5:		equ $600
ArtTile_SS_Plane_6:		equ $700
ArtTile_SS_Emerald:		equ $770
ArtTile_SS_Zone_1:		equ $797
ArtTile_SS_Zone_2:		equ $7A0
ArtTile_SS_Zone_3:		equ $7A9
ArtTile_SS_Zone_4:		equ $797
ArtTile_SS_Zone_5:		equ $7A0
ArtTile_SS_Zone_6:		equ $7A9

; Special Stage Results
ArtTile_SS_Results_Emeralds:	equ $541

; Font
ArtTile_Sonic_Team_Font:	equ $0A6
ArtTile_Credits_Font:		equ $5A0

; Error Handler
ArtTile_Error_Handler_Font:	equ $7C0

; EHZ, HTZ
ArtTile_Checkers:		equ ArtTile_Level+$158
ArtTile_Art_Flowers1:		equ $394
ArtTile_Art_Flowers2:		equ $396
ArtTile_Art_Flowers3:		equ $398
ArtTile_Art_Flowers4:		equ $39A
ArtTile_HTZ:			equ ArtTile_Level+$1FC
ArtTile_EHZ_Shield:			equ $560

; CPZ
ArtTile_CPZ_Buildings:		equ $3D0
ArtTile_CPZ_Lights:		equ $480
ArtTile_CPZ_Conveyor:		equ $484
ArtTile_CPZ_Pistons:		equ $48C
ArtTile_CPZ_Metre:		equ $48E
ArtTile_CPZ_Cross_Circle:	equ $490
ArtTile_CPZ_Propeller:		equ $491
ArtTile_CPZ_Liquid:		equ $495
ArtTile_CPZ_Conveyor_2:		equ $498

; HPZ
ArtTile_Art_HPZPulseOrb_1:	equ $2E8
ArtTile_Art_HPZPulseOrb_2:	equ $2F0
ArtTile_Art_HPZPulseOrb_3:	equ $2F8
ArtTile_HPZ_Bridge:		equ $300
ArtTile_HPZ_Waterfall:		equ $315
ArtTile_HPZ_Platform:		equ $34A
ArtTile_HPZ_Orb:		equ $35A
ArtTile_HPZ_Various:		equ $37C
ArtTile_HPZ_Emerald:		equ $392

; ---------------------------------------------------------------------------
; Level-specific objects and badniks.

; EHZ
ArtTile_Art_EHZPulseBall:	equ $39C
ArtTile_Fireball:		equ $39E
ArtTile_Waterfall:		equ $3AE
ArtTile_EHZ_Bridge:		equ $3C6
ArtTile_Buzzer:			equ $3E6
ArtTile_Buzzer_Fireball:	equ $3BE	; Actually unused
ArtTile_Snail:			equ $402
ArtTile_Masher:			equ $41C
ArtTile_Art_EHZMountains:	equ $500

; EHZ boss
ArtTile_ArtNem_Eggpod_1:	equ $460
ArtTile_ArtNem_EHZBoss:	equ $4C0
ArtTile_ArtNem_EggChoppers:	equ $540

; CPZ
ArtTile_CPZ_Platform:		equ $400
ArtTile_CPZ_Float_Platform:	equ $418
ArtTile_CPZ_Water_Surface:	equ $440

; CPZ boss
ArtTile_ArtNem_EggpodJets_1:	equ $418
ArtTile_ArtNem_Eggpod_3:	equ $420
ArtTile_ArtNem_CPZBoss:	equ $500
ArtTile_ArtNem_BossSmoke_1:	equ $570

; HPZ
ArtTile_Redz:			equ $500
ArtTile_BBat:			equ $530

; HTZ
ArtTile_Rexon:			equ $37E
ArtTile_HTZ_Fireball:		equ $3AE
ArtTile_HTZ_AutomaticDoor:	equ $3BE
ArtTile_HTZ_Seesaw:		equ $3CE
ArtTile_Sol:			equ $3DE
ArtTile_HtzZipline:		equ $3E6
ArtTile_HtzValveBarrier:	equ $426
ArtTile_HTZMountains:	equ $500
ArtTile_Spiker:			equ $520

; Unused
ArtTile_Gator:			equ $300
ArtTile_Early_Buzzer:		equ $32C
ArtTile_Early_BBat:		equ $350
ArtTile_Stegway:		equ $3C4
ArtTile_BFish:			equ $530
ArtTile_Aquis:			equ $570
ArtTile_Aquis_Child:		equ $4E0
ArtTile_Octus:			equ $38A
ArtTile_Octus_Child:		equ $4C6