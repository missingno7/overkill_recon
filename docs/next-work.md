# Next work

Choose by: what would force a future C translator to guess? Addresses are main-image
offsets (frame 0000 unless shown). `python tools/where.py ADDR` prints the source line.

## Freeze bar

The ASM is frozen as the semantic oracle (AGENTS.md, Oracle status) when all of these
hold; `python tools/verify.py` checks the first group.

- Exact: main image, entry point, relocation set, AdLib and Roland modules; zero
  UNKNOWN bytes in all three images.
- Every byte classified; unreferenced bytes named conservatively (Unused*, ...Slack,
  padding) without invented meaning.
- Every routine has a purpose-level or deliberately conservative name; contracts where a
  caller depends on registers, flags, shared tails or side effects.
- Game state, the 38h-byte record and its type-dependent field roles, record lifecycle,
  pool visitation order and mid-frame spawning written down.
- Level map, formation, encounter and boss data formats; resource, graphics and ENC
  decode formats; hiscore.dat; music-module formats and ABI.
- Gameplay/platform crossings marked at the seam (timer, keyboard, input bits, sfx
  mailbox, music request, render-side REC_FLASH_TIMER).
- Original quirks a faithful C port must keep are written at their sites: stale record
  fields and registers, equality-only limits, signed/unsigned compares, 16-bit wraps,
  counters that survive new games, duplicate destruction effects, out-of-table reads.
  They are found by searching the source for words such as stale, Throttled, never
  reset, equality, unsigned, wraps, reads past.

Not required: names for every literal (sprite numbers, sfx ids, coordinates, timings and
REC_TYPE values stay literal where a handler label already names the behaviour), human
descriptions of sprites, meanings for unused bytes, historical module fidelity.

## Deliberately left open

None of these affects reproducing behaviour.

- Hardware blitters stay low-level assembly; their memory traversal is written with the
  layout constants in HARDWARE.INC/SYSTEM.INC.
- Unused bytes and routines with no caller keep conservative names.
- The launcher (OVERKILL.EXE) is not reconstructed; the game side of its interface is.
