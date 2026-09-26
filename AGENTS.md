# Reconstruction rules

These rules apply only inside overkill_recon.

## Goal

Turn the maintained byte-exact ASM into a clean, readable, structured source tree of
what the original game source could plausibly have looked like. The exact build is
the proof; the source is the single maintained artifact.

```
original binary + maintained source -> build -> exact verification
```

## The loop

1. Inspect the current source.
2. Investigate one small unknown or poorly understood region (callers, callees,
   state accesses, data). Grep labels/symbols; `python tools/where.py ADDR` finds the
   source line of an address; build/asm/OVERKILL.MAP shows the linked layout.
3. Improve its semantics and structure: names, control-flow labels, state symbols,
   record fields, constants, data tables, concise comments.
4. `python tools/verify.py` (about 3 s). If it fails, fix or revert before continuing.
5. Continue.

## Fixed constraints

- Preserve originals and metadata/inputs.json. Never modify overkill_forged,
  legacy/overkill_port or empires_reconstruction.
- Deliver assembly. No C port, SDL work or ASM-to-C conversion in this phase.
- Keep the build independent of neighboring projects: TASM 1.0 under the local nmlgc
  MS-DOS Player, TLINK 2.0 under the local i86 player.
- Acceptance is exact identity: the linked EXE's load module equals a fresh extraction
  pinned by metadata/oracle.json, its entry point matches, every relocation TLINK emits is
  an original one, and both optional sound modules match. Never pull original bytes in
  via INCBIN or asset includes.
- Unknown code/data stays marked `; UNKNOWN` (visible `db`) until understood. Do not
  guess routines or data meanings; do not hide code in data.
- Names, files and structure are modern, evidence-supported reconstructions, never
  claims of recovered historical identifiers or module boundaries.
- Static work first. Run original code only for a specific question that static work
  cannot settle, and never beyond first gameplay entry (0000:97B2).

## Source style

- Comments explain purpose, non-obvious intent, hardware/DOS behavior, unusual ABI or
  control flow (shared tails, nonlocal returns, interrupts), state meaning, subtle
  side effects and real uncertainty. No per-instruction addresses, byte dumps,
  provenance boilerplate or English restatements of instructions.
- Local labels should describe control flow; routine names should be conservative.
- CS-relative names (e.g. VIDEO_ADAPTER) are valid only in the main 0000 frame; DS
  names assume the game state segment. Check segment context before renaming.
- Let file structure emerge from understanding. R00..R07 are physical chunks of the
  MAIN segment; FAR0F7F, SLOT1022, SEG1534, SEG153A and DATA each hold one address frame.
  Code may move between files of the same segment at routine boundaries (short jumps
  cannot cross files); run `python tools/externs.py --apply` after moving or naming.
- Write far calls and segment values symbolically (`call far ptr X`, `seg X`) so TLINK
  produces the relocation.
- Variables are named data where they live (DATA.ASM for the DS state segment, the code
  files for CS-resident words): `python tools/define.py ADDR Name byte|word [OLD_CONST]`
  splits the db row, names it and rewrites `[OLD_CONST]` operands. Include files keep
  constants, bit masks, field offsets and table addresses that are not yet data labels.

## Process

- One source of truth. Do not maintain the same knowledge in comments, JSON, docs
  and symbol databases. Derive what can be derived (listings, grep) on demand.
- Every tool, report or metadata file must have a current consumer in the loop.
  Delete what no longer earns its place; git history is the archive.
- Workers may investigate narrow regions and report findings; the supervisor makes
  small conservative edits and runs the exact verifier after each batch.
- Current semantic priority: Tandy/PCjr + AdLib with default keyboard; keep all
  other paths intact.
