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

- GeometryWords: name the per-adapter buffer and image sizes AllocateBuffers uses.
- REC_TYPE handlers are named TypeNN<Behaviour>; roles of 09h (externally moved shot)
  and 26h (wall probe) are uncertain, and their inner loc_ labels remain.
- `[bx + N]` record fields where BX provenance is not a null check.
- Effects of WhatOilShortageFlag and AllCheatsFlag beyond what their readers show.

## Open questions worth settling statically

- 9A06 mode dispatch: its table has five slots (code follows at 9A16); that DS:A47C
  stays within 0..4 is not yet shown.
- Pool-A allocation callers C450 and D1AE do not check for FFFF (pool full).
- 9CB6: keep unnamed until 9E19's countdown and the 511F/61DC effects are clear.
- MapScrollPos 9Ch gates RunTimedSequenceUntilPrimary.
- Record fields +1C and +36 are type-dependent.
- Type 2Eh never sets SteerSpeed and inherits the previous handler's value.

## Next reconstruction targets

- About 330 `[bx + N]` record accesses whose BX provenance is inherited.
- Collision loops 62F6..741F (pool B unrolled) and AC8B/BDD0.
- Replace remaining `loc_XXXXX` labels with control-flow names region by region.
