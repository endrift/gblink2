SRC  := gblink2 \
        assets \
        code-ram \
        command-table \
        mbc-table
PNGS := font \
        symbols

OBJS = $(foreach S,$(SRC),build/$(S).o)
2BPP = $(foreach PNG,$(PNGS),build/$(PNG).2bpp)

all: gblink2.gb

install: gblink2.gb
	ems-flasher --format
	ems-flasher --write $<

build/assets.o: $(2BPP)

build/%.o: src/%.s
	@mkdir -p build
	rgbasm -i build/ -i src/ -o $@ $<

build/%.2bpp: assets/%.png
	@mkdir -p build
	rgbgfx -o $@ $<

%.gb %.sym: $(OBJS)
	rgblink -o $*.gb -n $*.sym -p 0xFF $^
	rgbfix -vp 0xFF $*.gb

clean:
	rm -r build/ *.gb *.sym

.PHONY: all clean
.PRECIOUS: $(OBJS) $(2BPP)
