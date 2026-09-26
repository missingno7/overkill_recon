# Next work

Choose by: what would force a future C translator to guess? Addresses are main-image
offsets (frame 0000 unless shown). `python tools/where.py ADDR` prints the source line.

## Unclassified bytes

None in the main image. Unreferenced bytes are named Unused*/…Slack with the reason
(allocation slack, unused table half, filler between routines). The sound modules
(src/drivers) are still mostly unclassified.

## Semantics still open

- PanelImageBytes/BlueBitsImageBytes groups: tie each size group to its images.


## Next reconstruction targets

- Hard-coded row strides in the CGA/Tandy video routines (workspace rows 34h/68h,
  often written as the row minus bytes already advanced) and EGA screen-side copies.
- Raw game constants: sprite numbers, sfx ids (shared by unrelated events).
