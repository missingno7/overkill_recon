# Next work

Choose by: what would force a future C translator to guess? Addresses are main-image
offsets (frame 0000 unless shown). `python tools/where.py ADDR` prints the source line.

## Unclassified bytes

- SEG153A 0040..04D7 and 0D3A..: far library routines; only 153A:0000 and
  OpenResourceFile (04D7) are ever called, so no entry is proven for the rest.
- MAIN EE06..: a table of (value, 4E65h/4E5Fh) word pairs with FFFFh separators; find
  its reader. MAIN 5960, 58F9, 5AF4 (CS variables of the packed-row drawer), 050CC and
  051FB (small helpers with no known caller).
- DATA: 1514..1816 (zero, no reader found), 96AA.., 9828.., 9944 (zero), BB85..,
  BCC5.., BD53.., C440 (zero), 20A6.., 215C.., 2283.., 22D0...
- GeometryWords: name the per-adapter buffer and image sizes AllocateBuffers uses.
- `[bx + N]` in the decoded REC_TYPE handlers: where BX is a record (after
  FindFreeRecordPool*), write REC_* fields.
- Effects of WhatOilShortageFlag and AllCheatsFlag: no reader found yet.

## Data still to name

- Level script event state at DS:2070/209A..20A0; the second copy of the script cursor
  pointers at DS:20CA; DS:2306/2304/2308/230A (steering target and arrival flag used
  by loc_05DB2).

## Open questions worth settling statically

- 9A06 mode dispatch: its table has five slots (code follows at 9A16); that DS:A47C
  stays within 0..4 is not yet shown.
- Pool-A allocation callers C450 and D1AE do not check for FFFF (pool full).
- 9CB6: keep unnamed until 9E19's countdown and the 511F/61DC effects are clear.
- 1534:004E critical-error continuation and its saved stack relation.
- DS:235A, A95A/A95C and A97A (HUD meters, roles unproven); MapScrollPos 9Ch gates
  RunTimedSequenceUntilPrimary.
- CS:9594 holds B800h; its reader has not been reviewed.
- Record fields +1C and +36 are type-dependent; REC_KIND values 0, 2, 6 are unexplained.

## Next reconstruction targets

- TypeHandlers (REC_TYPE 0..94h): the handlers carry TypeHandlerNN labels only; name
  them by behaviour, bottom-up from the shared helpers they call (loc_0AFD8 step,
  loc_0BC45/loc_0BC4B post-move, loc_0BFC7 destroy).

- Record update handlers dispatched by REC_KIND through the table at CS:AA36
  (BC45, AD04, EFAE, 44AF, AAC2, AB10) and the destroy/free path BFC7/BD0D/BD17.
- About 330 `[bx + N]` record accesses whose BX provenance is inherited.
- Collision loops 62F6..741F (pool B unrolled) and AC8B/BDD0.
- AllocateBuffers: identify the remaining CS segment words (95A6..95B8, 959A, 959C).
- Replace remaining `loc_XXXXX` labels with control-flow names region by region.
