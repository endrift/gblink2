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

size_font	      EQU $0600
size_symbols      EQU $0200
tilemap           EQU $9800
template_tilemap  EQU $98A1
game_name         EQU $98E1
mbc_name          EQU $9981

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

RSYM: MACRO
IF DEF(RSYM_FUNC)
RSYM_END EQUS "_end_{RSYM_FUNC}_rom:\n"
RSYM_DEF EQUS "{RSYM_FUNC}::\n\tds _end_{RSYM_FUNC}_rom - _{RSYM_FUNC}_rom\n"
RSYM_END
SECTION "code_ram",BSS
RSYM_DEF
PURGE RSYM_END
PURGE RSYM_DEF
PURGE RSYM_FUNC
ENDC

RSYM_FUNC EQUS "\1"
SECTION "code_rom",CODE
_\1_rom:
ENDM

SET_RAM: MACRO
	ld a, \2 & $FF
	ld [\1], a
	ld a, \2 >> 8
	ld [\1 + 1], a
ENDM

SECTION "boot",HOME[$100]
	jp _start

SECTION "main",HOME[$150]
_start:
	xor a
	ldio [rLCDC], a

	ld hl, symbols
	ld bc, tiles
	ld de, size_symbols + size_font
	call copy

	ld hl, header
	ld bc, tilemap
	ld de, end_header - header
	call copy

	ld hl, tilemap+end_header - header
	ld bc, $03C0
	call zero

	ld hl, template_text
	ld bc, template_tilemap
	ld de, end_template_text - template_text
	call copy

	ld hl, oam_dma_rom
	ld bc, oam_dma
	ld de, end_oam_dma_rom - oam_dma_rom
	call copy

	ld hl, indirect_call_rom
	ld bc, indirect_call
	ld de, end_indirect_call_rom - indirect_call_rom
	call copy

	ld hl, command_table_rom
	ld bc, command_table
	ld de, $200
	call copy

	ld hl, mbc_table_rom
	ld bc, mbc_table
	ld de, end_mbc_table_rom - mbc_table_rom
	call copy

	ld hl, oam
	ld bc, $a0
	call zero

	xor a
	ld [link_active], a

	ld hl, code_rom
	ld bc, code_ram
	ld de, end_code_rom - code_rom
	call copy

	ld hl, header_oam
	ld bc, oam
	ld de, end_header_oam - header_oam
	call copy
	call oam_dma

	ld a, $c4
	ldio [rBGP], a
	ld a, $d4
	ldio [rOBP0], a
	ld a, $d0
	ldio [rOBP1], a
	ld a, $04
	ldio [rSCX], a
	ld a, $93
	ldio [rLCDC], a
	jp runloop

indirect_call_rom:
	push bc
	ret
end_indirect_call_rom:

SECTION "code_ram",BSS
code_ram::

	RSYM runloop
code_rom::
	ld a, $09
	ldio [rIE], a
	ld a, $b4
	ldio [rSB], a
	ld a, $80
	ldio [rSC], a
	halt
	ldio a, [rIF]
	ld b, a
	xor a
	ldio [rIF], a
	bit 3, b
	call nz, serial
	bit 0, b
	call nz, vblank

	jr _runloop_rom

	RSYM vblank
	push af
	push bc
	call read_buttons
	ld b, a
	ld a, [down_buttons]
	and a, b
	ld a, b
	ld [down_buttons], a
	bit 3, a
	call nz, reload_rom_info
	pop bc
	pop af
	ret

	RSYM serial
	push af
	push bc
	push hl
	ldio a, [rSB]
	ld l, a
	ld h, $0
	add hl, hl
	ld bc, command_table
	add hl, bc
	inc hl
	ld a, [hl-]
	or a
	jr z, .ret
	ld b, a
	ld a, [hl]
	ld c, a
	call indirect_call
.ret
	pop hl
	pop bc
	pop af
	ret

	RSYM read_buttons
	ld a, $20
	ldio [rJOYP], a
	ldio a, [rJOYP]
	ldio a, [rJOYP]
	ldio a, [rJOYP]
	ldio a, [rJOYP]
	cpl
	and a, $f
	swap a
	ld b, a
	ld a, $10
	ldio [rJOYP], a
	ldio a, [rJOYP]
	ldio a, [rJOYP]
	ldio a, [rJOYP]
	ldio a, [rJOYP]
	cpl
	and a, $f
	or a, b
	ret

	RSYM init_link
	push af
	ld a, [link_active]
	ld b, a
	ld a, $1d
	ldio [rSB], a
	ld a, $80
	ldio [rSC], a
	ld a, 1
	or b
	ld [link_active], a
	jr z, .ret
	call reload_rom_info
	SET_RAM range_start, rom_info
	SET_RAM range_size, $15
	call wait_serial
	call dump_range
	xor a
	call wait_serial
	ldio [rSB], a
	ld a, $80
	ldio [rSC], a
	ld a, $ff
	call wait_serial
	ldio [rSB], a
	ld a, $80
	ldio [rSC], a
	SET_RAM range_start, 0
	SET_RAM range_size, $4000
	call wait_serial
	call dump_range
.ret:
	pop af
	ret

	RSYM init_link_2
	push af
	ld a, [link_active]
	ld b, a
	ld a, $1d
	ldio [rSB], a
	ld a, $80
	ldio [rSC], a
	ld a, 1
	or b
	ld [link_active], a
	pop af
	ret

	RSYM dump_range
	push af
	push bc
	push de
	push hl
	ld hl, sp+0
	ld sp, range_start
	pop de
	pop bc
	ld sp, hl
	ld h, d
	ld l, e
.loop:
	ld a, [hl+]
	dec bc
	ldio [rSB], a
	ld a, $80
	ldio [rSC], a
	xor a
	or b
	or c
	jr z, .ret
	call wait_serial
	ldio a, [rSB]
	ld d, $90
	and d
	cp d
	jr z, .ret
	jr .loop
.ret:
	pop hl
	pop de
	pop bc
	pop af
	ret

	RSYM wait_serial
	push af
	ld a, $8
	ldio [rIE], a
	halt
	xor a
	ldio [rIF], a
	pop af
	ret

	RSYM wait_vram
	push hl
	ld hl, rSTAT
	xor a
.m0
	cp a, [hl]
	jr nc, .m0
.m2
	bit 1, [hl]
	jr nz, .m2
	pop hl
	ret

	RSYM read_args
	push af
	push bc
	push de
	push hl
	ld hl, arguments
	ld d, a
.loop:
	ld a, $80
	ldio [rSC], a
	xor a
	ld b, a
	ld c, a
	call wait_serial
	ldio a, [rSB]
	ld c, a
	dec d
	jr z, .write
	ld a, $80
	ldio [rSC], a
	call wait_serial
	ldio a, [rSB]
	ld b, a
	dec d
.write:
	ld a, b
	ld [hl+], a
	ld a, c
	ld [hl+], a
	xor a
	or d
	jr nz, .loop
	pop hl
	pop de
	pop bc
	pop af
	ret

	RSYM read_1
	push af
	ld a, 2
	call read_args
	SET_RAM range_size, $1
	call dump_range
	call wait_serial
	pop af
	ret

	RSYM read_x
	push af
	ld a, 4
	call read_args
	call dump_range
	call wait_serial
	pop af
	ret

	RSYM write_1
	push af
	push bc
	ld a, 3
	call read_args
	ld hl, sp+0
	ld sp, range_start
	pop bc
	pop af
	ld sp, hl
	ld [bc], a
	pop bc
	pop af
	ret

	RSYM do_call
	push af
	push bc
	push hl
	ld a, 2
	call read_args
	ld hl, arguments
	ld a, [hl+]
	ld c, a
	ld b, [hl]
	call indirect_call
	pop hl
	pop bc
	pop af
	ret

	RSYM reload_rom_info
	push af
	push bc
	push de
	push hl
	ld hl, rom_info
	ld bc, $147
	ld a, [bc]
	ld [hl+], a
	inc bc
	ld a, [bc]
	ld [hl+], a
	inc bc
	ld a, [bc]
	ld [hl+], a
	inc bc

	ld bc, $14e
	ld a, [bc]
	ld [hl+], a
	inc bc
	ld a, [bc]
	ld [hl+], a
	inc bc

	ld de, game_name
	call wait_vram
	ld bc, $134
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a
	inc bc
	inc de
	ld a, [bc]
	ld [hl+], a
	ld [de], a

	ld a, [rom_info]
	ld c, a
	xor a
	ld b, a
	ld hl, mbc_table
	add hl, bc
	add hl, bc
	ld a, [hl+]
	ld c, a
	ld b, [hl]
	ld hl, mbc_name
.loop
	ld a, [bc]
	or a
	jr z, .ret
	inc bc
	ld [hl+], a
	jr .loop
.ret:
	pop hl
	pop de
	pop bc
	pop af
	ret

end_code_rom:
	ds 1 ; Make sure the symbol is in the right place
	RSYM _

SECTION "utils",HOME[$400]
copy:
	push hl
	push bc
	push de
.loop
	ld a, [hl+]
	ld [bc], a
	inc bc
	dec de
	ld a, d
	or a, e
	jr nz, .loop
	pop de
	pop bc
	pop hl
	ret

zero:
	xor a
	ld [hl+], a
	dec bc
	ld a, b
	or a, c
	jr nz, zero
	ret

header:
REPT ($14 - strlen("{name}")) / 2
	db sq_1
ENDR

	db corner_tl
REPT strlen("{name}")
	db line_h
ENDR
	db corner_tr
REPT $1e - strlen("{name}")
	db sq_1
ENDR

	db line_v, "{name}", line_v
REPT ($12 - strlen("{name}")) / 2 + $c
	db sq_1
ENDR

REPT ($13 - strlen("{name}")) / 2
	db line_h
ENDR
	db tee_u
REPT strlen("{name}")
	db line_h
ENDR
	db tee_u
REPT ($13 - strlen("{name}")) / 2
	db line_h
ENDR
end_header:

underline: MACRO
	db \1
	ds 31 - strlen(\1)
REPT 32
	db line_h
ENDR
	ds 1
ENDM


template_text:
	underline "Current game:"
	ds $60
	underline "Cartridge type:"
end_template_text:

header_oam:
	db $20, $4 + ($13 - strlen("{name}")) * 4
	db tee_u, $0

	db $20, $c + ($13 + strlen("{name}")) * 4
	db tee_u, $0

	db $18, $c + ($13 + strlen("{name}")) * 4
	db line_v, $10

	db $18, $c + ($13 + strlen("{name}")) * 4
	db line_v, $10
end_header_oam:

oam_dma_rom:
	ld a, oam / $100
	ld [rDMA], a
	ld a, $28
.loop
	dec a
	jr nz, .loop
	ret
end_oam_dma_rom

SECTION "ram",BSS[$C800]
command_table:
	ds $200
oam:
	ds $a0
mbc_table::
	ds $340
down_buttons:
	ds 1
link_active:
	ds 1
rom_info:
	ds $15
arguments:
range_start:
	ds 2
range_size:
single_byte:
	ds 2

SECTION "tilerom",HOME
symbols:
INCBIN "symbols.bin"
font:
INCBIN "font.bin"

SECTION "tiles",VRAM[$8000]
tiles:
	ds size_symbols
	ds size_font

SECTION "oam_dma",HRAM
oam_dma:
	ds end_oam_dma_rom - oam_dma_rom
indirect_call:
	ds end_indirect_call_rom - indirect_call_rom
