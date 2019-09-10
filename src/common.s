rJOYP       EQU $ff00
rSB         EQU $ff01
rSC         EQU $ff02
rIF         EQU $ff0f
rLCDC       EQU $ff40
rSTAT       EQU $ff41
rSCY        EQU $ff42
rSCX        EQU $ff43
rDMA        EQU $ff46
rBGP        EQU $ff47
rOBP0       EQU $ff48
rOBP1       EQU $ff49
rIE         EQU $ffff

name      EQUS "GBlink2"
sq_0      EQU $00
arrow_u   EQU $01
arrow_d   EQU $02
arrow_r   EQU $03
arrow_l   EQU $04
line_h    EQU $05
line_v    EQU $06
corner_tl EQU $07
corner_tr EQU $08
corner_br EQU $09
corner_bl EQU $0a
tee_u     EQU $0b
tee_r     EQU $0c
tee_d     EQU $0d
tee_l     EQU $0e
sq_1      EQU $0f
sq_2      EQU $10
sq_3      EQU $11
clock_nw  EQU $12
clock_sw  EQU $13
clock_ne  EQU $14
clock_se  EQU $15

SET_RAM: MACRO
	ld a, \2 & $FF
	ld [\1], a
	ld a, \2 >> 8
	ld [\1 + 1], a
ENDM

WAIT_SERIAL: MACRO
	ld a, $80
	ldio [rSC], a
.serloop:
	ldio a, [rSC]
	bit 7, a
	jr nz, .serloop
ENDM