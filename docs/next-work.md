# Next work

Choose by: what would force a future C translator to guess? Addresses are main-image
offsets (frame 0000 unless shown). `python tools/where.py ADDR` prints the source line.

## Unclassified bytes (65876)

| File | UNKNOWN bytes | raw `[reg + N]` | `loc_` labels |
|---|---:|---:|---:|
| MODULE1 | 9387 | 146 | 349 |
| MODULE2 | 5461 | 260 | 688 |
| MODULE3 | 7716 | 193 | 842 |
| SLOT1022 | 20759 | 0 | 1 |
| SEG153A | 1414 | 4 | 41 |
| SEG1534 | 18 | 0 | 0 |
| DATA | 21121 | 0 | 0 |

- The remaining large code runs have no proven entry yet: they are reached only
  indirectly (e.g. the unrolled blit code in MODULE1 around 103C..2000 and 3849.., via
  pointers such as the table used with CS:0BDE) or from other undecoded code. Find the
  pointer tables (mostly in DATA) that reach them, then decode from those entries.
  Decode only by recursive descent from proven entries; bytes nothing reaches stay
  UNKNOWN.
- DATA: the remaining zero runs need their readers/writers before classification.
- SLOT1022: the initial contents of the sound-module slot (overwritten by ADLIB.ENC or
  ROLAND.ENC at startup). Classify them without inheriting the loaded modules' roles.
- `[bx + N]` in the decoded REC_TYPE handlers: where BX is a record (after
  FindFreeRecordPool*), write REC_* fields.

## Undecoded code with known structure

- 13 original relocations still fall in UNKNOWN db inside far calls in still
  undecoded code; decoding those regions as code closes the relocation set.
- The MAIN 2/3 and both far module splits are chosen inside evidence ranges; decoding
  8D88..9592, F826..F949 and FFF6..100BD may narrow them.
- 50CC..5122: decodes as small input-wait and border helpers with no known caller.
- The one VIDEO_ADAPTER dispatch table left numeric (04711h, 046AAh, 04684h) points into
  undecoded bytes in MODULE1.

## Data

- DATA.ASM is the game's state segment (DS). Scalars and known tables are named data;
  known strings are literals. Next, bottom-up by class: remaining `$`/NUL-terminated
  strings, pointer tables (`dw offset X`), fixed-size numeric tables, then record
  arrays; only where the byte class is proven by a reader.
- SFX tables at DS:BEF0..C2FC (command table, divisors, effect table, streams).

## Open questions worth settling statically

- 9A06 mode dispatch: five apparent words at 9A0C are not a proven bound on DS:A47C.
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
