# Next work

Choose by: what would force a future C translator to guess? Addresses are main-image
offsets (frame 0000 unless shown). `python tools/where.py ADDR` prints the source line.

## Unclassified bytes

What remains UNKNOWN (about 270 bytes) has no reader found anywhere in the image:
zero or FFh runs (DS:0000, 2162, 9944 after KeyDownTable, 98AE, C440 region ends,
MAIN ECB8 after EncRingBuffer), two text-record-like runs (DS:BE0C and after
DemoFireCycle), and single bytes between routines. Classify them only if a reader or a
layout argument appears (as the linker padding at far 10162 did).

## Semantics still open

- PanelImageBytes/BlueBitsImageBytes groups: tie each size group to its images.


## Next reconstruction targets

- Hard-coded row strides in the CGA/Tandy video routines (workspace rows 34h/68h,
  often written as the row minus bytes already advanced) and EGA screen-side copies.
- Raw game constants: sprite numbers, sfx ids (shared by unrelated events).
