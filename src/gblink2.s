INCLUDE "common.s"

SECTION "boot",ROM0[$100]
	jp _start

SECTION "header",ROM0[$134]
	db "{name}"
REPT ($f - strlen("{name}"))
	db 0
ENDR
	db $00 ; TODO: CGB support
	db $00, $00 ; Licensee code
	db $00 ; SGB flag
	db $00, $00, $00 ; MBC, ROM size, RAM size
	db $01 ; Destination code
	db $33 ; Use new licensee code
	db $00 ; Version

SECTION "main",ROM0[$150]
_start:
	di
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

	ld hl, tilemap + end_header - header
	ld bc, $03C0
	call zero

	ld hl, template_text
	ld bc, template_tilemap
	ld de, template_text.end - template_text
	call copy

	ld hl, oam_dma_rom
	ld bc, oam_dma
	ld de, oam_dma_rom.end - oam_dma_rom
	call copy

	ld hl, indirect_call_rom
	ld bc, indirect_call
	ld de, indirect_call_rom.end - indirect_call_rom
	call copy

	ld hl, command_table_rom
	ld bc, command_table
	ld de, $200
	call copy

	ld hl, mbc_table_rom
	ld bc, mbc_table
	ld de, end_mbc_table_rom - mbc_table_rom
	call copy

	ld hl, oam_start
	ld bc, $a0
	call zero

	ld hl, code_rom
	ld bc, code_ram
	ld de, end_code_rom - code_rom
	call copy

	ld hl, clock_oam
	ld bc, clock_oam_buffer
	ld de, clock_oam.end - clock_oam
	call copy

	ld hl, extra_text
	ld bc, extra_text_buffer
	ld de, extra_text.end - extra_text
	call copy

	ld hl, header_oam
	ld bc, oam_header
	ld de, header_oam.end - header_oam
	call copy
	call oam_dma

	xor a
	ld [info_outdated], a
	ld [oam_outdated], a
	ld [status_outdated], a

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
	ld a, $09
	ldio [rIE], a
	jp runloop

SECTION "utils",ROM0[$60]
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

SECTION "template",ROM0
header:
; Row 0
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

; Row 1
	db line_v, "{name}", line_v
REPT ($12 - strlen("{name}")) / 2 + $c
	db sq_1
ENDR

; Row 2
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
	ds $60
	underline "Status:"
	db "Disconnected"
.end:

header_oam:
	db $20, $4 + ($13 - strlen("{name}")) * 4
	db tee_u, $0

	db $20, $c + ($13 + strlen("{name}")) * 4
	db tee_u, $0

	db $18, $c + ($13 + strlen("{name}")) * 4
	db line_v, $10

	db $18, $c + ($13 + strlen("{name}")) * 4
	db line_v, $10
.end:

clock_oam:
	db $8E, $96
	db hourglass, $00

	db $8E, $9E
	db hourglass, $20

	db $96, $96
	db hourglass, $50

	db $96, $9E
	db hourglass, $70
.end:

extra_text::
.busy::
	db "Busy...",0
.idle::
	db "Idle",0
.no_cart::
	db "(no cartridge)",0
.end:

SECTION "tables",WRAM0
command_table::
	ds $200
mbc_table::
	ds $340

SECTION "wram",WRAM0
down_buttons::
	ds 1
rom_info::
	ds $15
info_outdated::
	ds 1
oam_outdated::
	ds 1
status_outdated::
	ds 1
arguments::
range_start::
	ds 2
range_size::
single_byte::
	ds 2
clock_oam_buffer::
	ds $10
status_buffer::
	ds $10
extra_text_buffer::
	ds extra_text.end - extra_text

SECTION "oam_buffer",WRAM0[$C000]
oam_start::
oam_header::
	ds $10
oam_clock::
	ds $10
oam_reserved::
	ds $80
