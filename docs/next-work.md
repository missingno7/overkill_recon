# Next work

Choose by: what would force a future C translator to guess? Addresses are main-image
offsets (frame 0000 unless shown). `python tools/where.py ADDR` prints the source line.

## Unclassified bytes

What remains UNKNOWN (about 290 bytes) has no reader found anywhere in the image:
zero or FFh runs (DS:0000, 2162, 9944 after KeyDownTable, 98AE, C440 region ends,
MAIN ECB8 after EncRingBuffer), small word tables (DS:214E, 236E), two text records
at DS:BE0C, and single bytes between routines. Classify them only if a reader or a
layout argument appears (as the linker padding at far 10162 did).

## Semantics still open

- PanelImageBytes/BlueBitsImageBytes groups: tie each size group to its images.
- REC_TYPE handlers are named TypeNN<Behaviour>; roles of 09h (externally moved shot)
  and 26h (wall probe) are uncertain, and their inner loc_ labels remain.
- Effects of WhatOilShortageFlag and AllCheatsFlag beyond what their readers show.

## Open questions worth settling statically

- DemoStepLaunchFrontPod and DemoStepSpawnPathEnemy51 do not check for FFFFh (pool full).
- MapScrollPos 9Ch gates RunTimedSequenceUntilPrimary.
- Record fields +1C and +36 are type-dependent.
- Type 2Eh never sets SteerSpeed and inherits the previous handler's value.

## Next reconstruction targets

- Hard-coded row strides outside the EGA blitters (ClearScreen104x200Ega, stars, the
  CGA/Tandy blitters and background save/restore): per-adapter stride constants.
- KIND_EXHAUST is inferred from placement and animation; confirm from sprites 9..0Dh.
- Raw game constants: sprite numbers, sfx ids, directions (0..7), X 60h screen centre,
  music numbers and MapScrollPos landmarks (9Ch, 750h, 0E52h, 0EA0h).
- Remaining `loc_XXXXX` labels are local control flow; name them region by region.
