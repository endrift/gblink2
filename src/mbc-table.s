mbc: MACRO
	dw mbc_table - mbc_table_rom + mbc_\1
ENDM

SECTION "mbc_table",ROM0
mbc_table_rom::
	mbc rom      ; 00
	mbc mbc1     ; 01
	mbc mbc1_r   ; 02
	mbc mbc1_rb  ; 03
	mbc unk      ; 04
	mbc mbc2     ; 05
	mbc mbc2_b   ; 06
	mbc unk      ; 07
	mbc rom_r    ; 08
	mbc rom_rb   ; 09
	mbc unk      ; 0A
	mbc mmm01    ; 0B
	mbc mmm01_r  ; 0C
	mbc mmm01_rb ; 0D
	mbc unk      ; 0E
	mbc mbc3_tb  ; 0F
	mbc mbc3_trb ; 10
	mbc mbc3     ; 11
	mbc mbc3_r   ; 12
	mbc mbc3_rb  ; 13
	mbc unk      ; 14
	mbc unk      ; 15
	mbc unk      ; 16
	mbc unk      ; 17
	mbc unk      ; 18
	mbc mbc5     ; 19
	mbc mbc5_r   ; 1A
	mbc mbc5_rb  ; 1B
	mbc mbc5_v   ; 1C
	mbc mbc5_vr  ; 1D
	mbc mbc5_vrb ; 1E
	mbc unk      ; 1F
	mbc mbc6     ; 20
	mbc unk      ; 21
	mbc mbc7     ; 22
	mbc unk      ; 23
	mbc unk      ; 24
	mbc unk      ; 25
	mbc unk      ; 26
	mbc unk      ; 27
	mbc unk      ; 28
	mbc unk      ; 29
	mbc unk      ; 2A
	mbc unk      ; 2B
	mbc unk      ; 2C
	mbc unk      ; 2D
	mbc unk      ; 2E
	mbc unk      ; 2F
	mbc unk      ; 30
	mbc unk      ; 31
	mbc unk      ; 32
	mbc unk      ; 33
	mbc unk      ; 34
	mbc unk      ; 35
	mbc unk      ; 36
	mbc unk      ; 37
	mbc unk      ; 38
	mbc unk      ; 39
	mbc unk      ; 3A
	mbc unk      ; 3B
	mbc unk      ; 3C
	mbc unk      ; 3D
	mbc unk      ; 3E
	mbc unk      ; 3F
	mbc unk      ; 40
	mbc unk      ; 41
	mbc unk      ; 42
	mbc unk      ; 43
	mbc unk      ; 44
	mbc unk      ; 45
	mbc unk      ; 46
	mbc unk      ; 47
	mbc unk      ; 48
	mbc unk      ; 49
	mbc unk      ; 4A
	mbc unk      ; 4B
	mbc unk      ; 4C
	mbc unk      ; 4D
	mbc unk      ; 4E
	mbc unk      ; 4F
	mbc unk      ; 50
	mbc unk      ; 51
	mbc unk      ; 52
	mbc unk      ; 53
	mbc unk      ; 54
	mbc unk      ; 55
	mbc unk      ; 56
	mbc unk      ; 57
	mbc unk      ; 58
	mbc unk      ; 59
	mbc unk      ; 5A
	mbc unk      ; 5B
	mbc unk      ; 5C
	mbc unk      ; 5D
	mbc unk      ; 5E
	mbc unk      ; 5F
	mbc unk      ; 60
	mbc unk      ; 61
	mbc unk      ; 62
	mbc unk      ; 63
	mbc unk      ; 64
	mbc unk      ; 65
	mbc unk      ; 66
	mbc unk      ; 67
	mbc unk      ; 68
	mbc unk      ; 69
	mbc unk      ; 6A
	mbc unk      ; 6B
	mbc unk      ; 6C
	mbc unk      ; 6D
	mbc unk      ; 6E
	mbc unk      ; 6F
	mbc unk      ; 70
	mbc unk      ; 71
	mbc unk      ; 72
	mbc unk      ; 73
	mbc unk      ; 74
	mbc unk      ; 75
	mbc unk      ; 76
	mbc unk      ; 77
	mbc unk      ; 78
	mbc unk      ; 79
	mbc unk      ; 7A
	mbc unk      ; 7B
	mbc unk      ; 7C
	mbc unk      ; 7D
	mbc unk      ; 7E
	mbc unk      ; 7F
	mbc unk      ; 80
	mbc unk      ; 81
	mbc unk      ; 82
	mbc unk      ; 83
	mbc unk      ; 84
	mbc unk      ; 85
	mbc unk      ; 86
	mbc unk      ; 87
	mbc unk      ; 88
	mbc unk      ; 89
	mbc unk      ; 8A
	mbc unk      ; 8B
	mbc unk      ; 8C
	mbc unk      ; 8D
	mbc unk      ; 8E
	mbc unk      ; 8F
	mbc unk      ; 90
	mbc unk      ; 91
	mbc unk      ; 92
	mbc unk      ; 93
	mbc unk      ; 94
	mbc unk      ; 95
	mbc unk      ; 96
	mbc unk      ; 97
	mbc unk      ; 98
	mbc unk      ; 99
	mbc unk      ; 9A
	mbc unk      ; 9B
	mbc unk      ; 9C
	mbc unk      ; 9D
	mbc unk      ; 9E
	mbc unk      ; 9F
	mbc unk      ; A0
	mbc unk      ; A1
	mbc unk      ; A2
	mbc unk      ; A3
	mbc unk      ; A4
	mbc unk      ; A5
	mbc unk      ; A6
	mbc unk      ; A7
	mbc unk      ; A8
	mbc unk      ; A9
	mbc unk      ; AA
	mbc unk      ; AB
	mbc unk      ; AC
	mbc unk      ; AD
	mbc unk      ; AE
	mbc unk      ; AF
	mbc unk      ; B0
	mbc unk      ; B1
	mbc unk      ; B2
	mbc unk      ; B3
	mbc unk      ; B4
	mbc unk      ; B5
	mbc unk      ; B6
	mbc unk      ; B7
	mbc unk      ; B8
	mbc unk      ; B9
	mbc unk      ; BA
	mbc unk      ; BB
	mbc unk      ; BC
	mbc unk      ; BD
	mbc unk      ; BE
	mbc unk      ; BF
	mbc unk      ; C0
	mbc unk      ; C1
	mbc unk      ; C2
	mbc unk      ; C3
	mbc unk      ; C4
	mbc unk      ; C5
	mbc unk      ; C6
	mbc unk      ; C7
	mbc unk      ; C8
	mbc unk      ; C9
	mbc unk      ; CA
	mbc unk      ; CB
	mbc unk      ; CC
	mbc unk      ; CD
	mbc unk      ; CE
	mbc unk      ; CF
	mbc unk      ; D0
	mbc unk      ; D1
	mbc unk      ; D2
	mbc unk      ; D3
	mbc unk      ; D4
	mbc unk      ; D5
	mbc unk      ; D6
	mbc unk      ; D7
	mbc unk      ; D8
	mbc unk      ; D9
	mbc unk      ; DA
	mbc unk      ; DB
	mbc unk      ; DC
	mbc unk      ; DD
	mbc unk      ; DE
	mbc unk      ; DF
	mbc unk      ; E0
	mbc unk      ; E1
	mbc unk      ; E2
	mbc unk      ; E3
	mbc unk      ; E4
	mbc unk      ; E5
	mbc unk      ; E6
	mbc unk      ; E7
	mbc unk      ; E8
	mbc unk      ; E9
	mbc unk      ; EA
	mbc unk      ; EB
	mbc unk      ; EC
	mbc unk      ; ED
	mbc unk      ; EE
	mbc unk      ; EF
	mbc unk      ; F0
	mbc unk      ; F1
	mbc unk      ; F2
	mbc unk      ; F3
	mbc unk      ; F4
	mbc unk      ; F5
	mbc unk      ; F6
	mbc unk      ; F7
	mbc unk      ; F8
	mbc unk      ; F9
	mbc unk      ; FA
	mbc unk      ; FB
	mbc gbcam    ; FC
	mbc tama5    ; FD
	mbc huc3     ; FE
	mbc huc1     ; FF

mbc_descs:
mbc_rom:
	db "ROM",0
mbc_rom_r:
	db "ROM+RAM",0
mbc_rom_rb:
	db "ROM+RAM+BATTERY",0
mbc_mbc1:
	db "MBC1",0
mbc_mbc1_r:
	db "MBC1+RAM",0
mbc_mbc1_rb:
	db "MBC1+RAM+BATTERY",0
mbc_mbc2:
	db "MBC2",0
mbc_mbc2_b:
	db "MBC2+BATTERY",0
mbc_mmm01:
	db "MMM01",0
mbc_mmm01_r:
	db "MMM01+RAM",0
mbc_mmm01_rb:
	db "MMM01+RAM+BATTERY",0
mbc_mbc3:
	db "MBC3",0
mbc_mbc3_r:
	db "MBC3+RAM",0
mbc_mbc3_rb:
	db "MBC3+RAM+BATTERY",0
mbc_mbc3_tb:
	db "MBC3+RTC",0
mbc_mbc3_trb:
	db "MBC3+RAM+RTC",0
mbc_mbc5:
	db "MBC5",0
mbc_mbc5_r:
	db "MBC5+RAM",0
mbc_mbc5_rb:
	db "MBC5+RAM+BATTERY",0
mbc_mbc5_v:
	db "MBC5+RUMBLE",0
mbc_mbc5_vr:
	db "MBC5+RUMBLE+RAM",0
mbc_mbc5_vrb:
	db "MBC5+RUMBLE+RAM+BAT",0
mbc_mbc6:
	db "MBC6",0
mbc_mbc7:
	db "MBC7",0
mbc_gbcam:
	db "Pocket Cam",0
mbc_tama5:
	db "TAMA5",0
mbc_huc3:
	db "HuC-3",0
mbc_huc1:
	db "HuC-1",0
mbc_unk:
	db "(unknown)",0

end_mbc_table_rom::
