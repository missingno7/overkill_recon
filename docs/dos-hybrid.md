# DOS hybrid: the oracle with gameplay moving to C

```
original binary
      | byte exact            python tools/verify.py
frozen ASM oracle (tag asm-semantic-oracle-v1, src/ + include/)
      | behavioural equivalence   python tools/difftest.py
DOS hybrid: the same program with C-owned routines (c/)
```

One executable, one state. The hybrid is the oracle's own sources, linked with C objects
that replace some of its routines. There is one PrimaryRecord, one pool A and B, one map,
one renderer and one sound system; C reads and writes the same DS bytes as the ASM.
Platform code (blitters, interrupts, PC speaker, AdLib/Roland, DOS and EMS glue) may stay
ASM indefinitely.

## Build and run

```powershell
python tools/verify.py        # the oracle: must stay exact
python tools/hybrid.py        # build/oracle-sym, build/hybrid, build/run/{oracle,hybrid}
python tools/difftest.py      # all suites (tests/*.py); a number scales the case count
python tools/difftest.py --mutants    # every listed mutant must be detected
python tools/difftest.py --coverage   # oracle instructions of C-owned code reached
python tools/graph.py         # migration graph + ranked candidate C regions: build/graph/report.md, graph.json
```

`build/run/hybrid` (and `build/run/oracle`) hold a runnable `OVERKILL`: the linked EXE,
the original resource container and a recomputed integrity checksum (tools/package.py),
next to the original launcher. Run `OVERKILL.EXE /T /A` there (Tandy + AdLib; `/C`, `/E`,
`/R` as in OVERKILL.DOC), e.g. in DOSBox-X with `machine=tandy`.

## How the hybrid is made

- `c/*.c` state what they replace with `OWNS:` lines: entry labels plus every label and
  jump table inside the replaced code.
- tools/hybrid.py copies the oracle sources into build/hybrid, cuts each owned range (from
  an owned label to the next label that is not owned), turns fall-through into it into a
  `jmp`, short and conditional jumps into near jumps, `public` into `extrn`, and makes every
  label public (no bytes change). The oracle files are never edited.
- `c/<region>.asm` (one bridge per region, next to `c/<region>.c`) defines the owned labels the remaining ASM still reaches: a few
  instructions each that adapt the oracle's register contract (BP = record, results in
  flags, registers the oracle preserves) to the C convention. Calls between C functions do
  not pass through it.
- `build/hybrid/GAME_GEN.H` is generated from include/*.INC and src/DATA.ASM: every
  constant, the 38h-byte `Record` (size and each field offset checked at compile time),
  role aliases, and an `extern` for every state-segment label. Nothing is kept by hand.
- TLINK links the derived objects, the bridge and the C objects in the oracle's order.
- The same tool builds `build/oracle-sym`, the oracle with every label public, and
  refuses it unless its image and relocations equal the exact oracle.

## Compiler: Watcom C16 10.0a

Chosen after controlled experiments with Turbo C 2.0, Microsoft C 5.10 and 6.00A, and
Watcom C16 10.0a (9.5b has no usable 16-bit compiler here). All four produce OMF that
TLINK 2.0 links with TASM 1.0 objects, can place code in segment MAIN and reach the
game's DATA symbols with DS = SS. Watcom was chosen because:

- `#pragma aux` gives C functions a register convention with an exact clobber list, so C
  preserves every register but AX and the bridge is a `mov si, bp`; C can call ASM
  routines that take register inputs directly (the others clobber AX-DX and ES and need a
  save/restore thunk per edge; Turbo C and MSC 5.10 cannot call BP-input routines without one);
- it runs natively on Windows (no DOS player) and is deterministic; its 8086 code is
  clean (16-bit wrap, signed/unsigned compares, switch tables in CS, no helper calls
  except 32-bit multiply/divide);
- its external data fixups use the target's own frame, so no group or glue is needed.

Pinned by metadata/c-toolchain-lock.json: `toolchain/watcom/BINNT/WCC.EXE` (Win32 loader)
and `toolchain/watcom/BINB/WCC.EXE` (the compiler), copied from C:\tools\watcom-10.0a;
private like TASM/TLINK. Options: `-ms -0 -s -zl -zld -zq -ox -w4 -we -nt=MAIN -nc=CODE`.

## ABI and rules for C code

| Item | Rule |
|---|---|
| Names | `#pragma aux default "^"`: upper-cased C names, matching TASM's case-insensitive publics; use snake_case so C names never equal ASM labels |
| Arguments / result | SI, then DI; result in AX |
| Preserved | everything but AX (`modify exact [ax]`); flags are scratch |
| Segments | DS = SS = the game state segment, DF = 0 (the game keeps both); ES never assumed |
| Code | segment MAIN (near calls both ways); MAIN is now F797h bytes of 64 KiB |
| Data | C owns none: no statics, no string literals, no tentative definitions; tools/hybrid.py rejects C objects with data or local/communal symbols (TLINK 2.0 cannot link LPUBDEF/COMDEF) |
| Arithmetic | 16-bit types from GAME_GEN.H (`word` unsigned, casts to `sword` where the oracle compares signed); no 32-bit multiply/divide (runtime helpers) |
| Behaviour | the oracle's, including its bugs: comment deliberate quirks as intentional |

## Differential tests

tools/emu.py loads a linked EXE as DOS would (Unicorn, real mode) and runs the game's own
AllocateBuffers, BuildRowTables and InitStars (Tandy) under a DOS stub that only
allocates memory. tools/difftest.py runs build/oracle-sym and build/hybrid side by side:
each case writes the same state into both, enters the same oracle label with the same
registers, and compares the whole state segment (except the four static tables of code
addresses and stack scratch below SP), the registers and flags the contract keeps or
returns, every write outside the state segment (by symbol or address), and port traffic.

Building blocks, reused by every region:

- `tools/world.py`: memory-state builders (World, Record, pools, player, counters,
  plausible mid-game worlds, stale slots, full pools); field names and constants come
  from include/*.INC. They only place values; no game behaviour is modelled.
- Sequences: a suite may yield a list of cases; each step continues from the state the
  previous one left on each side and both sides are compared after every step.
- `tools/fuzz.py`: coverage-guided differential fuzzing. A suite declares
  `FUZZ = [Target(...)]` (entry label, seed builder, the region's oracle labels, register
  contract, record types and globals worth mutating, and `domains`: value sets of fields
  or globals whose range is an oracle precondition, e.g. an unchecked jump-table index or
  a pointer that only ever holds table addresses). Features come from the oracle run:
  branch edges in the region, entry-record type/kind/status transitions, pool occupancy
  changes, watched globals; `cmp` operands are logged and a mutation copies one operand
  into state words holding the other (reaches exact-equality branches). Every candidate
  is compared on both sides; a state on which the ORACLE crashes is discarded as
  unreachable, any other difference fails. `--save` stores the corpus in tests/corpus/,
  which difftest replays as regression cases.

Suites: `tests/movement.py` (entries, fuzz targets), `tests/movement_callers.py` (the real
ASM callers: tail jumps, fall-through, far trampoline, ZF consumers), `tests/sequences.py`
(UpdateAllRecords / TickFrameTimers sequences over populated worlds), `tests/quirks.py`
(documented original bugs asserted on the oracle, then compared).

A region is ready to merge when its fuzz targets and sequences reach every reachable
oracle instruction of the region (`python tools/fuzz.py <suite>` prints the union
coverage), its suites, the corpus and all older suites pass, and a few representative
mutants (signedness, off-by-one, wrong transition, omitted side effect, wrong allocation
path, bridge preservation) are caught. As C regions merge, prefer higher entry points
(a handler, UpdateRecordByKind, UpdateAllRecords) over more direct entries.

Each C region is proven on its own, through its entry labels and its real ASM callers;
whole-game runs are a manual play check, not a test method (no set of runs covers all
states and levels). Limits of the cases: graphics files are not loaded (allocated
buffers hold a fixed pattern) and no interrupt runs inside a case.

## Growing the C region

Move coherent regions, not single routines: the goal is a C island with a small, stable
ASM boundary. Bridge stubs exist only where remaining ASM enters C; as callers move to C
they disappear. If bridge code grows with C coverage, stop and redraw the boundary.
MAIN has 64 KiB: C code replaces the ASM it owns, so space grows only by the size
difference; if C outgrows it, the island moves to its own code segment behind far entries.
