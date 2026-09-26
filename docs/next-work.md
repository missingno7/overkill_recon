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
- Handler-level meaning of the REC_TYPE handlers (TypeHandlerNN) and the remaining
  loc_ labels; `[bx + N]` record fields where BX provenance is not a null check.
- Effects of WhatOilShortageFlag and AllCheatsFlag beyond what their readers show.

## Open questions worth settling statically

- 9A06 mode dispatch: its table has five slots (code follows at 9A16); that DS:A47C
  stays within 0..4 is not yet shown.
- Pool-A allocation callers C450 and D1AE do not check for FFFF (pool full).
- 9CB6: keep unnamed until 9E19's countdown and the 511F/61DC effects are clear.
- MapScrollPos 9Ch gates RunTimedSequenceUntilPrimary.
- Record fields +1C and +36 are type-dependent.

## Next reconstruction targets

- TypeHandlers (REC_TYPE 0..94h): the handlers carry TypeHandlerNN labels only; name
  them by behaviour, bottom-up from the shared helpers they call (loc_0AFD8 step,
  loc_0BC45/loc_0BC4B post-move, loc_0BFC7 destroy).

- Record update handlers dispatched by REC_KIND through the table at CS:AA36
  (BC45, AD04, EFAE, 44AF, AAC2, AB10) and the destroy/free path BFC7/BD0D/BD17.
- About 330 `[bx + N]` record accesses whose BX provenance is inherited.
- Collision loops 62F6..741F (pool B unrolled) and AC8B/BDD0.
- Replace remaining `loc_XXXXX` labels with control-flow names region by region.
