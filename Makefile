all: gblink2.gb

install: gblink2.gb
	ems-flasher --format
	ems-flasher --write $<

build:
	mkdir -p build

build/gblink2.o: build/symbols.2bpp build/font.2bpp

build/%.o: src/%.s build
	rgbasm -i build/ -o $@ $<

build/%.2bpp: assets/%.png build
	rgbgfx -o $@ $<

gblink2.gb: build/gblink2.o build/command-table.o build/mbc-table.o
	rgblink -o $@ -n $(patsubst %.gb,%.sym,$@) $^
	rgbfix -vp 0xFF -t GBlink2 $@

clean:
	rm -r build/ *.gb *.sym

.PHONY: clean
