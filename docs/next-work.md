# Next work

Choose by: what would force a future C translator to guess? Addresses are main-image
offsets (frame 0000 unless shown). `python tools/where.py ADDR` prints the source line.

## Unclassified bytes

- Code still without a proven entry: MODULE1 1AEB..2193 and 3E12.. (blit code; find the
  remaining pointer tables that reach them), MODULE2 83D7.., MODULE3 EE06.. (a table of
  (value, 4E65h) word pairs), far code at 0F7F:FEA5.. and SEG153A 153E0... Decode only
  by recursive descent from proven entries; bytes nothing reaches stay UNKNOWN.
- The largest DATA runs: DS:1514.. (after PlaqueFiles), DS:A47E.., DS:C04A..
  (8-byte records starting E7h 84h), DS:C601..C85C, DS:D1BC.. and DS:95EA...
- 13 original relocations are still inside UNKNOWN db (far calls in undecoded code).
- GeometryWords: name the per-adapter buffer and image sizes AllocateBuffers uses.
- `[bx + N]` in the decoded REC_TYPE handlers: where BX is a record (after
  FindFreeRecordPool*), write REC_* fields.
- Effects of WhatOilShortageFlag and AllCheatsFlag: no reader found yet.

## Data

- DATA.ASM is the game's state segment (DS). Scalars and known tables are named data;
  known strings are literals. Next, bottom-up by class: remaining `$`/NUL-terminated
  strings, pointer tables (`dw offset X`), fixed-size numeric tables, then record
  arrays; only where the byte class is proven by a reader.
- SFX tables at DS:BEF0..C2FC (command table, divisors, effect table, streams).
- Level scripts and formations (LevelScript0..5, Formation00..52) are structured; name
  the event state at DS:2070/209A..20A0 and the per-trigger table at DS:C81A.

## Open questions worth settling statically

- 9A06 mode dispatch: its table has five slots (code follows at 9A16); that DS:A47C
  stays within 0..4 is not yet shown.
- Pool-A allocation callers C450 and D1AE do not check for FFFF (pool full).
- 9CB6: keep unnamed until 9E19's countdown and the 511F/61DC effects are clear.
- 1534:004E critical-error continuation and its saved stack relation.
- DS:BEDA (choose-screen slot; saved with DifficultySetting), DS:235A, DS:2350 (9Ch gates
  RunTimedSequenceUntilPrimary), A95A/A95C and A97A (HUD meters, roles unproven).
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
