#!/usr/bin/env python3
import struct
f = open("symbols.raw", "rb")
o = open("symbols.bin", "wb")
while True:
    line = f.read(8)
    if not line:
        break
    unpacked = list(struct.unpack("BBBBBBBB", line))
    accum1 = 0
    accum2 = 0
    for b in unpacked:
        accum1 <<= 1
        accum1 |= b & 1
        accum2 <<= 1
        accum2 |= (b >> 1) & 1
    o.write(bytes([accum1, accum2]))
