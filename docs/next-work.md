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

## Open questions worth settling statically

- DemoStepLaunchFrontPod and DemoStepSpawnPathEnemy51 do not check for FFFFh (pool full).
- MapScrollPos 9Ch gates RunTimedSequenceUntilPrimary.
- Type 2Eh never sets SteerSpeed and inherits the previous handler's value.

## Next reconstruction targets

- Hard-coded row strides outside the EGA blitters (ClearScreen104x200Ega, stars, the
  CGA/Tandy blitters and background save/restore): per-adapter stride constants.
- KIND_EXHAUST is inferred from placement and animation; confirm from sprites 9..0Dh.
- Raw game constants: sprite numbers, sfx ids (shared by unrelated events), X 60h screen centre,
  music numbers.
- Remaining `loc_XXXXX` labels are local control flow; name them region by region.
