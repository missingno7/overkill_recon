# Reconstruction rules

These rules apply only inside overkill_recon.

## Goal

Produce the clearest possible byte-exact ASM representation of the original program,
so that it can later be translated to C, and then ported, with as little guessing as
possible. The source tree is the single maintained semantic representation of the
program; pinned hashes, the oracle manifest, build configuration and short docs about
the oracle boundary support it but carry no parallel semantics.

```
original binary + maintained source -> build -> exact verification
```

Intended later path (not this phase): exact ASM -> replace well-understood leaf
routines by C one at a time, still on the original DOS platform model (memory layout,
timer, framebuffer, input, sound interfaces), compared against the exact ASM ->
complete C -> replace the platform layer. Game-logic translation and platform porting
are validated separately. Shape the ASM so that such replacement is straightforward.

Priorities:

1. Exact binary match is absolute.
2. Semantic clarity for a later C translation.
3. Separation of game logic from platform/hardware code, where the program really has it.
4. Resemblance to a historical source project: useful, secondary. The ASM may be more
   modern than the lost original; do not keep disassembly-shaped structure for the
   sake of possible historical fidelity.

## The loop

1. Choose the next target by asking: what unresolved part of this ASM would force a
   future C translator to guess?
2. Investigate one small region (callers, callees, state accesses, data). Grep
   labels/symbols; `python tools/where.py ADDR` finds the source line of an address
   (`--disasm N`, `--refs`); build/asm/OVERKILL.MAP shows the linked layout.
3. Improve the source representation, in this order of value:
   - classify UNKNOWN bytes (code, or a known data class);
   - global state, records/structures, field offsets, arrays, pointer and dispatch
     tables, index bounds, kind/state values, buffer ownership, state machines;
   - routine boundaries and contracts (inputs, state read/written, results, flags and
     registers callers consume, hardware effects, async/interrupt state, shared tails,
     nonlocal returns), expressed through names, structure and brief comments;
   - game logic vs platform classification and purpose-level platform names
     (e.g. WaitVerticalRetrace, SetVideoMode, LoadFile) without hiding side effects
     that matter to program semantics;
   - local control-flow labels last.
4. `python tools/verify.py` (about 3 s). If it fails, fix or revert before continuing.
5. Continue.

ASM-phase end state: exact match, closed relocation set, every byte classified,
game state and structures understood, routine boundaries and side effects clear,
platform code and game logic identifiable, few raw offsets or magic constants, no
disassembly-dump look, no extra infrastructure needed to read it.

## Fixed constraints

- Preserve originals and metadata/inputs.json. Never modify overkill_forged,
  legacy/overkill_port or empires_reconstruction.
- Deliver assembly. No C port, SDL work or ASM-to-C conversion in this phase.
- Keep the build independent of neighboring projects: TASM 1.0 under the local nmlgc
  MS-DOS Player, TLINK 2.0 under the local i86 player.
- Acceptance is exact identity: the linked EXE's load module equals a fresh extraction
  pinned by metadata/oracle.json, its entry point matches, every relocation TLINK emits is
  an original one (missing ones only inside undecoded `db`; final closure is set
  equality, see docs/executable-wrapping.md), and both optional sound modules match.
  Never pull original bytes in via INCBIN or asset includes: unclassified or executable
  bytes must stay visible in the source.
- Two separate questions: *classification* (what kind of bytes?) and *semantics*
  (what do they mean?). `; UNKNOWN` marks unclassified bytes only. The target is zero
  unclassified bytes. Classes: code, initialized state, table, pointer table, string,
  graphics, level/map, sound, padding/alignment, workspace/buffer, or another named
  data class. Once bytes are proven data, write them as data (strings as literals,
  words as `dw`, pointer tables as `dw offset X`) under a conservative name even if
  their meaning is still open; say what is unknown in a comment. Proven code is
  written as instructions, never left as `db`. Do not guess.
- Names, files and structure are modern, evidence-supported reconstructions, never
  claims of recovered historical identifiers or module boundaries.
- Do not force a game/platform split where the code mixes concerns (e.g. a renderer
  that mutates game state); record the real boundary.
- No C work until explicitly asked.
- Static work first. Run original code only for a specific question that static work
  cannot settle, and never beyond first gameplay entry (0000:97B2).

## Source style

- Comments explain purpose, non-obvious intent, hardware/DOS behavior, unusual ABI or
  control flow (shared tails, nonlocal returns, interrupts), state meaning, subtle
  side effects and real uncertainty. No per-instruction addresses, byte dumps,
  provenance boilerplate or English restatements of instructions.
- Prefer symbolic fields (`[bx + REC_X]`), named state, constants and tables over raw
  offsets and magic numbers. Routine names should be conservative and say what the
  routine does; local labels describe control flow.
- CS-relative names (e.g. VIDEO_ADAPTER) are valid only in the main 0000 frame; DS
  names assume the game state segment. Check segment context before renaming.
- File organization serves understanding. MODULE1..3 reflect the three link modules
  implied by the original relocation order (each has a MAIN and a FAR0F7F part);
  SLOT1022, SEG1534, SEG153A and DATA each hold one address frame. Link order fixes
  physical order, so a file can only hold a contiguous range of a segment; split
  where a range is a coherent subsystem. Do not spend effort on module archaeology
  unless it matters for linking or understanding. Short jumps cannot cross files. `python tools/externs.py --apply` recomputes public/extrn after
  moving or naming a label that is used across files.
- Write far calls and segment values symbolically (`call far ptr X`, `seg X`) so TLINK
  produces the relocation.
- Variables are named data where they live (DATA.ASM for the DS state segment, the code
  files for CS-resident words): `python tools/define.py ADDR Name byte|word [OLD_CONST]`
  splits the db row, names it and rewrites `[OLD_CONST]` operands (`label:N` names a
  table). Include files hold constants only: bit masks, field offsets, sizes, state
  values. Objects that occupy memory are labels in the source.

## Process

- One source of truth. Do not maintain the same knowledge in comments, JSON, docs
  and symbol databases. Derive what can be derived (listings, grep) on demand.
- Every tool, report or metadata file must have a current consumer in the loop.
  Delete what no longer earns its place; git history is the archive.
- Workers may investigate narrow regions and report findings; the supervisor makes
  small conservative edits and runs the exact verifier after each batch.
- Current semantic priority: Tandy/PCjr + AdLib with default keyboard; keep all
  other paths intact.
