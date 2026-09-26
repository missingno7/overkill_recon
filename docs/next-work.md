# Next work

Choose by: what would force a future C translator to guess? Addresses are main-image
offsets (frame 0000 unless shown). `python tools/where.py ADDR` prints the source line.

## Unclassified bytes

None in the main image or the sound modules. Unreferenced bytes are named Unused*/…Slack
(allocation slack, unused table half, filler between routines).

## Subsystems reviewed for contracts

Record lifecycle, player movement/terrain/collision, level scripts/encounters/bosses,
game state/scoring/RNG/demo, resources and graphics decoding, input/speaker effects/
rendering, startup/shutdown/runtime, REC_TYPE handler names, AdLib and Roland modules.

## Still open

- Weapons, pods, pickups and upgrades: contract review (named, not yet reviewed as a
  subsystem).
- Shared helpers (steering, direction/quadrant, Bresenham steps, BCD): contract review.
- Confidence review of the non-type routine names given in bulk.
- PANEL/BLUEBITS image-size terms are allocation-only; tying them to images is not
  needed by the code.
- Hard-coded row strides in the CGA/Tandy video routines (workspace rows 34h/68h,
  often written as the row minus bytes already advanced) and EGA screen-side copies.
- Raw game constants left deliberately: sprite numbers, REC_TYPE values in type changes,
  sfx ids (shared by unrelated events).
