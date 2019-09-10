INCLUDE "common.s"

RSYM: MACRO
IF DEF(RSYM_FUNC)
.end:

SECTION "code_ram",WRAM0
RSYM_DEF EQUS "{RSYM_FUNC}::\n\tds _{RSYM_FUNC}_rom.end - _{RSYM_FUNC}_rom\n"
RSYM_DEF
PURGE RSYM_DEF
PURGE RSYM_FUNC
ENDC

RSYM_FUNC EQUS "\1"
SECTION "code_rom",ROM0
_\1_rom:
ENDM

SECTION "code_ram",WRAM0
code_ram::

SECTION "code_rom",ROM0
code_rom::
	RSYM runloop
.serial
	ld a, $b4
	ldio [rSB], a
	ld a, $80
	ldio [rSC], a

.test
	halt
	ld hl, rIF
	ld a, [hl]

.test3
	bit 3, a
	jr z, .test0
	res 3, [hl]
	call serial_irq
	ld a, [rSC]
	bit 7, a
	jr z, .serial

.test0
	bit 0, a
	jr z, .test
	res 0, [hl]
	call nz, vblank_irq
	jr .test

	RSYM vblank_irq
	push bc
	call read_buttons
	ld b, a
	ld a, [down_buttons]
	and a, b
	ld a, b
	ld [down_buttons], a
	bit 3, a
	call nz, reload_rom_info
	ld a, [rSTAT]
	and a, $3
	cp a, $1
	jr nz, .ret
	ld a, [info_outdated]
	or a
	call nz, update_rom_info
	ld a, [oam_outdated]
	or a
	call nz, oam_dma
	ld a, [status_outdated]
	or a
	call nz, update_status
.ret:
	pop bc
	ret

	RSYM serial_irq
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

	RSYM test_link
	call reload_rom_info
	ld a, $1d
	call write_byte
	SET_RAM range_start, rom_info
	SET_RAM range_size, $15
	call dump_range
	xor a
	call write_byte
	ld a, $ff
	call write_byte
	ret

	RSYM init_link
	push af
	call test_link
	SET_RAM range_start, 0
	SET_RAM range_size, $4000
	call dump_range
.ret:
	pop af
	ret

	RSYM init_link_2
	push af
	call test_link
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
	WAIT_SERIAL
	xor a
	or b
	or c
	jr z, .ret
	jr .loop
.ret:
	pop hl
	pop de
	pop bc
	pop af
	ret

	RSYM load_range
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
	call read_byte
	ld [hl+], a
	dec bc
	xor a
	or b
	or c
	jr z, .ret
	jr .loop
.ret:
	pop hl
	pop de
	pop bc
	pop af
	ret

	RSYM write_byte
	ldio [rSB], a
	WAIT_SERIAL
	ret

	RSYM read_byte
	WAIT_SERIAL
	ldio a, [rSB]
	ret

	RSYM exc_byte
	ldio [rSB], a
	WAIT_SERIAL
	ldio a, [rSB]
	ret

	RSYM read_args
	push af
	push bc
	push de
	push hl
	ld hl, arguments
	ld d, a
.loop:
	xor a
	ld b, a
	call read_byte
	ld c, a
	dec d
	jr z, .write
	call read_byte
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
	pop af
	ret

	RSYM read_x
	push af
	ld a, 4
	call read_args
	call dump_range
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

	ld d, 0
	ld e, $10
	ld bc, $134
.nameloop:
	ld a, [bc]
	ld [hl+], a
	inc bc
	cpl
	or d
	ld d, a
	dec e
	jr nz, .nameloop

	xor a
	or d
	ld a, 3
	jr z, .mark_outdated
	srl a
.mark_outdated
	ld [info_outdated], a
	pop hl
	pop de
	pop bc
	pop af
	ret

	RSYM update_rom_info
	push bc
	ld b, a
	ldio a, [rSTAT]
	and a, $3
	cp a, $1
	jr nz, .ret2
	push de
	push hl
	ld hl, game_name
	ld d, b
	ld bc, rom_info + 5
	ld e, $10

	bit 1, d
	jr z, .namecopy
	ld bc, extra_text.no_cart - extra_text + extra_text_buffer

.namecopy:
	ld a, [bc]
	ld [hl+], a
	inc bc
	dec e
	jr nz, .namecopy

	ld a, [rom_info]
	ld c, a
	bit 1, d
	jr z, .mbcload
	ld bc, extra_text.no_cart - extra_text + extra_text_buffer
	jr .copystart
.mbcload:
	xor a
	ld b, a
	ld hl, mbc_table
	add hl, bc
	add hl, bc
	ld a, [hl+]
	ld c, a
	ld b, [hl]
.copystart:
	ld hl, mbc_name
	call copy_string
.ret:
	xor a
	ld [info_outdated], a
	pop hl
	pop de
.ret2:
	pop bc
	ret

	RSYM update_status
	push bc
	push hl
	ld bc, status_buffer
	ld hl, status
	call copy_string
	xor a
	ld [status_outdated], a
	pop hl
	pop bc
	ret

	RSYM copy_string
	push de
	ld d, 20
.copyloop
	ld a, [bc]
	or a
	jr z, .zeroloop
	inc bc
	ld [hl+], a
	dec d
	jr .copyloop
.zeroloop:
	ld [hl+], a
	dec d
	jr nz, .zeroloop
	pop de
	ret

	RSYM show_busy
	push af
	push bc
	push de
	push hl
	ld hl, clock_oam_buffer
	ld bc, oam_clock
	ld d, $10
.loop:
	ld a, [hl+]
	ld [bc], a
	inc bc
	dec d
	jr nz, .loop
	ld a, $1
	ld [oam_outdated], a
	ld bc, extra_text.busy - extra_text + extra_text_buffer
	ld hl, status_buffer
	call copy_string
	ld a, $1
	ld [status_outdated], a
	pop hl
	pop de
	pop bc
	pop af
	ret

	RSYM hide_busy
	push af
	push bc
	push hl
	ld hl, oam_clock
	ld b, $10
	xor a
.loop:
	ld [hl+], a
	dec b
	jr nz, .loop
	ld a, $1
	ld [oam_outdated], a
	ld bc, extra_text.idle - extra_text + extra_text_buffer
	ld hl, status_buffer
	call copy_string
	ld a, $1
	ld [status_outdated], a
	pop hl
	pop bc
	pop af
	ret

	RSYM _

SECTION "code_rom",ROM0
end_code_rom::

SECTION "code_hram",ROM0[$80]
code_hram::
indirect_call_rom::
	push bc
	ret
.end::

oam_dma_rom::
	ld a, oam_start / $100
	ld [rDMA], a
	ld a, $28
.loop:
	dec a
	jr nz, .loop
	ld [oam_outdated], a
	ret
.end::

SECTION "hram",HRAM
oam_dma::
	ds oam_dma_rom.end - oam_dma_rom
indirect_call::
	ds indirect_call_rom.end - indirect_call_rom