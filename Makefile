all: gblink2.gb

install: gblink2.gb
	ems-flasher --format
	ems-flasher --write $<

gblink2.o: symbols.2bpp font.2bpp

%.o: %.s
	rgbasm -o $@ $<

%.2bpp: %.png
	rgbgfx -o $@ $<

gblink2.gb: gblink2.o command-table.o mbc-table.o
	rgblink -o $@ -n $(patsubst %.gb,%.sym,$@) $^
	rgbfix -vp 0xFF -t GBlink2 $@

clean:
	rm *.o *.sym

.PHONY: clean
