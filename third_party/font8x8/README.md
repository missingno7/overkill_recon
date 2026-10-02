# 8x8 CP437 text font

`font8x8_cp437.h` is a readable C array with one 8-byte row bitmap for every
CP437 byte. The presenter indexes the array directly with the text-page character
byte; it does not substitute or silently blank unsupported characters. The only
fully empty glyphs are NUL, ordinary space, and non-breaking space at 0xFF.

The table is derived from the 8-pixel CP437 font in Dominus, file
`d08cp437.fnt`, at upstream commit
`3000baf80ed701eac407207d2fda48369cd1af48`:
<https://github.com/studio8502/Dominus>.
The original README and SIL Open Font License 1.1 are preserved in
`Dominus-readme.txt` and `Dominus-copying.txt`. The table is a modified font
software file and remains under OFL 1.1; it does not use the reserved font name
Terminus or Dominus.

Dominus documents an IBM Euro substitution at byte 0xD5. That slot is replaced
here with CP437 U+2552, using the matching box-drawing glyph from Daniel
Hepper's public-domain `font8x8_box.h`, pinned at
`8e279d2d864e79128e96188a6b9526cfa3fbfef9`:
<https://github.com/dhepper/font8x8>.
Its README is preserved in `dhepper-README`. Hepper's table stores the leftmost
pixel in the least-significant bit; the replacement row bytes are reversed to
match the MSB-left convention of the DOS bitmap table.

This is a complete CP437 glyph map, not a claim of pixel identity with any
particular IBM BIOS or adapter ROM font. The CP437 slot mapping and coverage are
preserved while the selected glyph design comes from the licensed Dominus font.
