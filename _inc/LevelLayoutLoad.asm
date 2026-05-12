; ---------------------------------------------------------------------------
; Subroutine to load basic level data
; https://github.com/MDTravisYT/sonic-to-1
; ---------------------------------------------------------------------------

LevelDataLoad:
		moveq	#0,d0
		move.b	(v_zone).w,d0
		lsl.w	#4,d0
		lea	(LevelHeaders).l,a2
		lea	(a2,d0.w),a2
		move.l	a2,-(sp)
		addq.l	#4,a2
		movea.l	(a2)+,a0
		lea	(v_16x16).w,a1	; RAM address for 16x16 mappings
		bsr.w	KosDec
		tst.w	(Two_player_mode).w
		beq.s	LevelDataLoad2
		; In 2P mode, adjust the block table to halve the pattern index on each block
		lea	(v_16x16).w,a1

		move.w	#bytesToWcnt(v_16x16_end-v_16x16),d2
-		move.w	(a1),d0		; read an entry
		move.w	d0,d1
		andi.w	#$F800,d0	; filter for upper five bits
		andi.w	#$7FF,d1	; filter for lower eleven bits (patternIndex)
		lsr.w	#1,d1		; halve the pattern index
		or.w	d1,d0		; put the parts back together
		move.w	d0,(a1)+	; change the entry with the adjusted value
		dbf	d2,-

LevelDataLoad2:
		movea.l	(a2)+,a0
		lea	(v_128x128).l,a1	; RAM address for 128x128 mappings
		bsr.w	KosDec
		bsr.w	LevelLayoutLoad
		move.w	(a2)+,d0
		move.w	(a2),d0
		andi.w	#$FF,d0
		bsr.w	PalLoad1		; load palette (based on d0)
		movea.l	(sp)+,a2
		addq.w	#4,a2		; read number for 2nd PLC
		moveq	#0,d0
		move.b	(a2),d0
		beq.s	.skipPLC	; if 2nd PLC is 0 (i.e. the ending sequence), branch
		bsr.w	LoadPLC		; load pattern load cues

.skipPLC:
		rts
; End of function LevelDataLoad

; ===========================================================================
; ---------------------------------------------------------------------------
; Level layout loading subroutine
; ---------------------------------------------------------------------------

LevelLayoutLoad:
		moveq	#0,d0
		move.w	(v_zone).w,d0
		ror.b	#1,d0
		lsr.w	#6,d0
		lea	(v_collindex).l,a0
		move.w	(a0,d0.w),d0
		lea	(a0,d0.l),a0
		lea	(v_lvllayout).w,a1
		jsr	KosDec
		lea	(v_lvllayout).w,a3
		move.w	#bytesToLcnt(v_lvllayout_end-v_lvllayout),d1
		moveq	#0,d0
-		move.l	d0,(a3)+
		dbf	d1,-

		; The rows of the foreground and background layouts are interleaved
		; in memory. This is done here:
		lea	(v_lvllayout).w,a3		; Foreground.
		moveq	#0,d1				; Index into 'Off_Level' to get level foreground layout.
		bsr.w	.loadlayout
		lea	(v_lvllayout_bg).w,a3	; Background.
		moveq	#2,d1				; Index into 'Off_Level' to get level background layout.

.loadlayout:
		moveq	#0,d0
		move.w	(v_zone).w,d0
		ror.b	#1,d0
		lsr.w	#5,d0
		add.w	d1,d0
		lea	(Level_Index).l,a1
		move.w	(a1,d0.w),d0
		lea	(a1,d0.w),a1
		
		moveq	#0,d1
		move.w	d1,d2
		move.b	(a1)+,d1	; Layout width.
		move.b	(a1)+,d2	; Layout height.
		move.l	d1,d5
		addq.l	#1,d5
		moveq	#0,d3
		move.w	#$80,d3	; Size of layout row in memory.
		divu.w	d5,d3	; Get how many times to repeat the source row to fill the destination row.
		subq.w	#1,d3	; Turn into loop counter.

.nextrow:
		movea.l	a3,a0
		move.w	d3,d4

.repeatrow:
		move.l	a1,-(sp)
		move.w	d1,d0

.nextbyte:
		move.b	(a1)+,(a0)+
		dbf	d0,.nextbyte
		
		movea.l	(sp)+,a1
		dbf	d4,.repeatrow

		lea	(a1,d5.w),a1	; Next row in source data.
		lea	$100(a3),a3		; Next row in destination data.
		dbf	d2,.nextrow

		rts
; End of function LevelLayoutLoad
