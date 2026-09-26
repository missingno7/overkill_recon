# Next work

Addresses are main-image offsets (frame 0000 unless shown). `python tools/where.py ADDR`
prints the source line; build/asm/OVERKILL.MAP shows the linked segments.

## Undecoded code with known structure

- 21 original relocations still fall in UNKNOWN db: far calls into frame 0F7F inside
  R03 (7BF6..7E18), R04 (8D34..8D86), R05 (B4F6..B532), R06 (CB62..CB83, D68F) and
  FAR0F7F (FA5E..100D7). Decoding those regions as code will let TLINK produce them.
- 50CC..5122: decodes as small input-wait and border helpers with no known caller.
- The one VIDEO_ADAPTER dispatch table left numeric (04711h, 046AAh, 04684h) points into
  undecoded bytes in R02.

## Data

- DATA.ASM is the game's state segment (DS). Scalar variables are named data; tables
  (key tables, KEY_DOWN_TABLE, score and high-score blocks, SFX tables, the record pools)
  are still address constants. tools/define.py handles bytes and words only; tables need
  a multi-row variant.
- SFX tables at DS:BEF0..C2FC (command table, divisors, effect table, streams).

## Open questions worth settling statically

- 9A06 mode dispatch: five apparent words at 9A0C are not a proven bound on DS:A47C.
- Pool-A allocation callers C450 and D1AE do not check for FFFF (pool full).
- 9CB6: keep unnamed until 9E19's countdown and the 511F/61DC effects are clear.
- 1534:004E critical-error continuation and its saved stack relation.
- DS:BEDA/BEDC (choose-screen slot and D-key option), DS:235A, DS:2350 (9Ch gates
  RunTimedSequenceUntilPrimary), A95A/A95C and A97A (HUD meters, roles unproven).
- CS:9594 holds B800h; its reader has not been reviewed.
- Record fields +1C and +36 are type-dependent; REC_KIND values 0, 2, 6 are unexplained.

## Next reconstruction targets

- Record update handlers dispatched by REC_KIND through the table at CS:AA36
  (BC45, AD04, EFAE, 44AF, AAC2, AB10) and the destroy/free path BFC7/BD0D/BD17.
- About 330 `[bx + N]` record accesses whose BX provenance is inherited.
- Collision loops 62F6..741F (pool B unrolled) and AC8B/BDD0.
- AllocateBuffers: identify the remaining CS segment words (95A6..95B8, 959A, 959C).
- Replace remaining `loc_XXXXX` labels with control-flow names region by region.
