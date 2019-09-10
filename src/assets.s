size_font    EQU $0600
size_symbols EQU $0200

GLOBAL size_font
GLOBAL size_symbols

SECTION "tilerom",ROM0
symbols::
INCBIN "symbols.2bpp"
font::
INCBIN "font.2bpp"

SECTION "tiles",VRAM[$8000]
tiles::
	ds size_symbols
	ds size_font

SECTION "tilemap",VRAM[$9800]
tilemap::
	ds $81
template_tilemap::
	ds $40
game_name::
	ds $A0
mbc_name::
	ds $A0
status::
