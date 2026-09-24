# C + matching-diff: bounded language experiment

The evidence supports **a narrow subset, not a general matching architecture**.
Of ten primary routines, none matched directly with the tested normal C ABIs;
readable reshaping and register hints also produced no exact matches. Four bodies
became exact after explicit ABI specialization and return-layout changes. Two are
useful small demonstrations; two remain borderline because the implementation
still depends on compiler-text patterns and substantial ABI binding.

The practical boundary is currently straight-line field operations and small
conditional returns. String loops, pool scans, shared return-address tricks and
hardware timing did not yield a small demonstrated recipe within this experiment.
Behavioral verification is the preferred next research path for those ordinary
helpers; existing platform ASM remains preferable for the DOS oracle.

These are feasibility results, not production C promotions. Main143,088-byte
Oracle A, its123 relocations, the9690 startup artifact and both audio module
identities remain authoritative. No research code enters the normal build.

## Scope and method

The first request specified10-20 routines; an initial16-routine pilot was compiled.
The follow-up narrowed the language study to6-10. The primary sample below is ten;
the six additional pilot results remain in `research/c_matching/results/codegen.json`
and are not silently folded into the primary success rate.

All functions had reviewed ASM contracts. The primary sample deliberately includes
an ASCII leaf, arithmetic/field updates, ordered alias-sensitive stores, a circular
pool scan, a history update, string operations, a shared tail, Tandy copying and
an AdLib/PIT loop. UNKNOWN here means the domain/entity role is unknown, not that
the sampled instruction behavior was guessed. No fully reviewed MIXED boundary
was available in this selection; there is no claim about that class.

The three artifacts are separate:

1. `research/c_matching/clean/`: canonical native16-bit C and two explicit byte-I/O
   primitives. No emulated AX/BX machine context. `Record`, `Pair`, `HistoryCursors`
   and `TransferEnd` capture data/outputs; fixed-width arithmetic remains DOS-like.
2. `research/c_matching/abi/`: original argument/result locations and two executable
   wrappers. Original SS:BP, DS:BX, global cells, preserved state and observable
   flags are **ABI facts**, not matching-diff freedom.
3. `research/c_matching/matching/`: body-layout choices. Generated output is never
   edited as canonical logic and does not read original bytes to construct a body.

The ordinary C is compiled and executed independently before matching is attempted.
The successful matching path is C -> Turbo C listing -> audited ABI specialization
-> return-layout choices -> TASM. This is **not** a claim that a historical C
compiler accepts a magic flag that emits the original custom ABI. A separate,
tightly bounded C -> semantic IR -> ASM prototype tests a stronger restriction
for two functions.

## Compiler configurations

Observed tool banners identify Turbo C2.0 and Microsoft C5.10. TASM1.0 and TLINK2.0
assemble/link the probes. This does not identify OVERKILL's historical compiler.
Hashes and local provenance are in `research/c_matching/toolchain-lock.json`.

| Configuration | Options | ABI/model |
|---|---|---|
| tc_size | `-c -ms -1- -f- -N- -O -Z -G-` | small; near cdecl code; explicit far data arguments |
| tc_speed | same, with `-G` | same |
| msc_size | `/c /AS /G0 /Gs /Os /Zl` | small; near cdecl code; explicit far data arguments |
| msc_speed | `/c /AS /G0 /Gs /Ot /Ol /Zl` | same |

Four additional probes use size configurations: early-return ASCII source,
countdown XOR loop and readable saturating double-decrement reshaping; separately,
`register` hints on record pointers and loop variables. `/Oa` is deliberately not
used because ignoring aliases would invalidate the copy contracts. No headers,
CRT, external C library or network downloads are needed. The linked probe image
contains native DOS instructions and is invoked locally at public function entries.

MS-DOS Player/nmlgc is the compiler/TASM runner. The existing pinned i86 runner is
used for TLINK. Source is supplied as ASCII CRLF: a LF-only probe caused Turbo C
to emit an empty object. Required-public checks reject that result. All build and
verification inputs are local to overkill_recon.

## Clean-C verification and its limits

Eight fresh compiler/shape configurations passed **365,280 isolated ASM/C
comparisons** across the retained16-routine pilot. This includes:

- All256 ASCII values; all65,536 input words for five guarded/double-step leaves
  in tc_size, with boundaries/representative high words in the other builds.
- Every pool-A cursor/free-slot combination and full pools.
- All48 history phases, selected input/gate combinations, signed-clamp boundaries,
  separated segments and deliberately overlapping copy/source destinations.
- Whole64KiB Tandy destination checks, including untouched bytes, plus returned
  source/destination cursors, remaining count and row width.
- AdLib status256 values and five PIT scripts including signed comparisons/repeats.

C explicitly exposes string/copy cursor results through `TransferEnd`, and the
history store returns its X result and next destination offset. This prevents a
future recipe from inventing missing cursor arithmetic. Result buffers are private
ABI-adapter storage and must be disjoint from source/game data. Ordinary C argument
marshalling and return/out parameters are projected onto the original contract.
The tests do not imply that unimplemented wrappers preserve every scratch register
or flag automatically. That full boundary property is separately checked for the
two real wrappers and all claimed exact matching bodies.

Port-event agreement is not elapsed-time agreement. The PIT C sample preserves
its protocol, but extra instructions/calls can change actual hardware timing.
It is not approved as a replacement for the ASM delay. No whole-game replay was
used in this research.

A useful negative result occurred before matching: the PIT C test falsified an
existing contract.0584 loads1FFFh once;059F jumps back to0587. Repeats write the
previous counter reading, not1FFFh again. Earlier tests read1FFFh before repeating
and therefore missed it. Clean C, the maintained ASM **comment**, metadata and the
regression input were corrected. No executable ASM instruction changed. This
correction belongs in semantics and was not hidden in a match recipe.

## Primary results

C LOC counts nonblank body lines, including declarations; it is not a measure of
semantic simplicity. Code sizes below use tc_size and complete function extents.
They include explicit result marshalling where needed. Port primitives add21 shared
bytes beyond the listed platform bodies. Detailed listings, eight-configuration
sizes, positional byte matches and aligned byte/mnemonic comparisons are retained
in `results/codegen.json`; a byte-alignment percentage is not a proof of equivalence.

| Routine / original entry | Domain | C LOC | Original bytes/instructions | C bytes/instructions | Result |
|---|---|---:|---:|---:|---|
| upper_ascii C7FE | UNKNOWN/text | 2 | 13 / 8 | 28 / 12 | MATCH_DIFF_BORDERLINE |
| dec_x A5FC | GAME_LOGIC | 1 | 11 / 5 | 19 / 8 | MATCH_DIFF_GOOD |
| copy_position A571 | GAME_LOGIC | 2 | 19 / 7 | 39 / 14 | MATCH_DIFF_GOOD |
| xor_copy C9D3 | UNKNOWN/memory | 9 | 10 / 5 | 76 / 25 | VERIFIED_C_PREFERRED |
| find_free 7524 | GAME_LOGIC | 13 | 35 / 13 | 77 / 31 | VERIFIED_C_PREFERRED |
| advance_history 9CF1 | GAME_LOGIC | 5 | 92 / 22 | 102 / 28 | MATCH_DIFF_BORDERLINE |
| store_history 9CD9 | GAME_LOGIC | 4 | 24 / 9 | 59 / 21 | VERIFIED_C_PREFERRED |
| dec_x_twice A5F9 + tail | GAME_LOGIC | 2 | 14 / 6 | 33 / 12 | VERIFIED_C_PREFERRED |
| tandy_copy 306F | PLATFORM_LOGIC | 11 | 40 / 18 | 140 / 50 | ASM_PREFERRED |
| pit_delay AdLib0579 | PLATFORM_LOGIC | 11 | 48 / 25 | 167 / 85 | ASM_PREFERRED |

For all ten, tested clean semantics/projections pass, exact normal C is **no**, and
exact shaped/hinted C is **no**. Smallest shaped examples were27 bytes for upper
and31 for double-decrement, still different. The classifications are provisional
research recommendations, not VERIFIED_C or MATCHED_C production badges.

The successful four contain135 original bytes. The extra pilot's lowercase and
three sibling field guards also match using the same mechanism: eight successes
in the initial16, but these near-duplicate leaves are not evidence that half the
whole game is readily matchable.

## ABI cost is not body cost

The C functions independently use cdecl and explicit near/far arguments. Two
actual ASM wrappers call that unmodified C and preserve the original local ABI:

| Boundary | Wrapper | C body | Combined vs original | Full boundary checks |
|---|---:|---:|---:|---:|
| AL ASCII transform | 22 bytes /19 instructions | 28 bytes | 50 vs13 | 1,024 states |
| SS:BP guarded X decrement | 24 bytes /22 instructions | 19 bytes | 43 vs11 | 1,052 states |

They only marshal arguments, preserve state and restore the return boundary. They
contain no ASCII transform or decrement algorithm. Tests compare all general
registers, DS/ES/SS, SP, flags and record effects; relocated return-code addresses
and private temporary stack cells are excluded. The stack must not alias data. Flag tests use the vendored CPU model; undefined
architectural flag bits do not acquire a new hardware guarantee.
These are conservative working wrappers, not proven minimum-size wrappers.

No wrapper was built for the other eight primary routines. Their cost is
**unmeasured**, not zero. Observable output cursors and any live flags must be
handled explicitly before future drop-in C use. In particular, an unknown live-out
must not be labeled dead merely to make a recipe easier.

The exact-body experiments fuse reviewed ABI bindings into instruction realization,
so they emit no separate call wrapper. This is distinct from the normal-C-plus-
wrapper result. Frame removal in that adapter follows the original register ABI;
it must not be misreported as a general matching-language optimization.

## Mismatch distribution and stopping points

| Category | Observed evidence |
|---|---|
| CALLING_CONVENTION | All ten: stack C arguments/returns versus original registers, globals or string cursors |
| ADDRESSING_MODE | Far argument loads and ES:BX versus SS:BP, DS:BX or direct DS state cells |
| STACK_FRAME / PROLOGUE_EPILOGUE | Compiler BP frames, saved registers and cleanup absent in the small original leaves |
| BLOCK_LAYOUT | Original conditional RET blocks versus compiler shared epilogues; scan/loop restructuring |
| REGISTER_ALLOCATION / SPILL_LOCATION | Explicit C counters/pointers spilled or saved versus original CX/SI/DI/BX choreography |
| INSTRUCTION_SELECTION / ORDER | MOVSB/STOSW/REP MOVSW/LOOP versus ordinary loads/stores/counter branches and C calls |
| DEAD_FLAG_SHAPE | XOR-loop bookkeeping changes flags; deadness beyond reviewed callers is not assumed |
| OTHER / physical timing | PIT protocol can match while instruction timing differs |
| SEMANTIC_DIFFERENCE | The discovered PIT repeat reload error; corrected in C and contract before matching |

BRANCH_ENCODING and STRENGTH_REDUCTION did not require a standalone primitive in
the successful subset. Likewise no evidence justifies a general spill-slot,
temporary-reuse or dead-flag override language yet. The CPU target was8086 in all
measurements. Semantic pointer/copy order was never changed to improve percentages.

The difficult cases were stopped deliberately:

- XOR copy is five original instructions. Choosing CX, DS:SI/ES:DI, MOVSB and LOOP,
  plus cursor outputs/preservation, would describe almost the entire realization.
  The current recipe generator rejects such a loop; it does not have an emit-ASM
  escape hatch. No claim that a larger compiler could never generate it is made.
- Pool search has a normal algorithm but different loop/dataflow and BX/CX output
  allocation. The sample exhausts valid cursor/slot states, but demonstrates no
  small exact recipe. Behavioral C is useful without recreating every branch.
- History storage requires STOSW progression and original segment/global binding.
  Its clean API now exposes the cursor result. A general string-store lowering was
  not built just to rescue one example.
- Double-decrement's natural unit is routine plus shared tail. Original CALL to
  its own next instruction and fallthrough execute the tail twice. The C states
  two guarded decrements directly. A recipe that narrates return-address tricks
  would be much more fragile than this small semantic source.
- Tandy copy has a proved memory transformation, but almost all18 instructions are
  tuned string/bank/register mechanics. PIT adds actual timing sensitivity. Keep
  those ASM islands for the current DOS oracle; source-level behavioral tests
  remain useful evidence.

## Honest recipe size

The successful body recipes select early-return sites; all values/addresses and
pointer roles below are accounted for separately as ABI constraints.

| Routine | Body constraints / kinds | ABI bindings | Body-selected instruction sites | ABI-selected operand sites |
|---|---:|---:|---:|---:|
| upper_ascii | 2 /1 | 1 | 4/8 (50%) | 2/8 (25%) |
| dec_x | 1 /1 | 1 | 2/5 (40%) | 2/5 (40%) |
| copy_position | 0 /0 | 2 | 0/7 | 4/7 (57%) |
| advance_history | 1 /1 | 3 | 2/22 (9%) | 14/22 (64%) |

A selected return site counts its conditional branch and inserted RET. Operand
counts measure output sites, not independent bits or algorithmic facts. Frame/load
eliminations are additionally reported as ABI work. These figures show why a short
JSON file can still constrain much of a tiny target. They are not semantic progress
percentages and should not be summed into a success score.

The pilot JSON has25 serialized bytes for a nonempty layout recipe and2 for an
empty one: approximately1.92x,2.27x,0.11x and0.27x the original byte sizes above.
That syntax-dependent ratio is retained honestly but is less informative than
constraint count/reuse. **Zero original machine-code bytes are embedded in any
recipe.** The shared adapter itself is roughly80 lines and is not cost-free.
For the other routines, delta size is unmeasured: no invented exact-delta numbers
or successful Level5 ASM rewrites are reported.

The upper/history results remain BORDERLINE despite exact bytes: compiler label
anchors and the sizeable ABI mapping are still too fragile to advertise as a
stable semantic language. The two firewall cases provide stronger separation.

## Semantic-firewall prototype

`firewall.py` accepts only two reviewed C source forms. It is not a general C
parser. Unsupported syntax fails; no hand-edited IR is accepted as canonical input.

For copy_position it derives two ordered COPY_ADD operations from actual C:

```
dst->x = (u16)(src->x + 10);
dst->y = (u16)(src->y + 10);
```

Each carries source field, destination field and constant from C. Field offsets
come from the canonical Record declaration. Lowering retains load/add/store order,
including tested overlaps. The ABI separately specifies src=SS:BP, dst=DS:BX and
AX=last stored value. No body recipe is needed to obtain the exact19 bytes.

For dec_x it derives GUARD_NONZERO / DECREMENT_FIELD from C. The ABI specifies
SS:BP, preserved registers and the CMP/optional-DEC flag contract. The recipe may
choose joined or split conditional return; it cannot choose the field, condition,
zero constant or decrement amount. Split produces the exact11 bytes.

The IR records are immutable generated operations. Tests reject eight families
of forbidden recipe keys per function. Changing10 to11 **in C** changes IR/output;
the recipe cannot restore the old arithmetic. Alternate equivalent lowerings
(joined return, or a backend-only DX scratch experiment with ABI restoration) are
executed against the original with full local-state checks. The DX test is not a
new DSL primitive: no successful sampled compiler mismatch required it.

This is encouraging for a small firewall, but the trust base includes the tiny
frontend, lowering, ABI description and assembler. Six generated instructions
from six semantic operations do not establish a trustworthy general C backend.
Do not scale this by adding function-specific emission templates indefinitely.

## Minimal candidate schema, after the evidence

Only one public matching primitive is justified at present:

```json
{
  "schema": "match-recipe-v0-candidate",
  "function": "dec_x",
  "control_flow": {
    "guard_nonzero_x": { "conditional_return": "split" }
  }
}
```

`conditional_return` chooses between a shared return label and an equivalent
conditional-continue / RET block. It cannot invert the semantic predicate, move a
state operation across it, or alter its inputs. This family is reused by three
primary functions/four sites and seven pilot functions/nine sites. The actual
compiler-listing probe uses an ordinal count; **that unstable syntax is not the
proposed semantic identifier**. The two-form firewall demonstrates the semantic
anchor for dec_x; broader anchoring is unimplemented.

Argument binding, result binding, segment locations and required preservation live
in `abi/`, outside the recipe. Ordinary ABI wrappers remain available when exact
body matching is not worth the cost. General register binding, frame/spill choices,
branch-width control and instruction-form selection are deferred until a concrete
sample demonstrates a small, safe need. The schema is a candidate, not adopted
production architecture.

## Forbidden and rejected capabilities

The matching language must reject:

- `arbitrary_emit_asm` / raw bytes / replace-body: can encode an entire second game.
- `override_constant`, change condition or loop bound: semantic mutation belongs in C.
- Add/remove/reorder observable stores or change fields/locations: breaks aliasing
  and state semantics. Even a plausible field rename must originate in reviewed C.
- Insert/remove gameplay calls or transitions: changes the algorithm.
- Result/argument remapping hidden in a diff: observable ABI belongs in its contract.
- Arbitrary flag synthesis: live flags belong in ABI; deadness needs evidence first.
- Per-function string/stack trick escape hatches: rejected as a way to claim this
  sample successful without a reusable semantics-preserving lowering.

Not every low-level rule is inherently unsafe, but safety and usefulness are
separate. An operation-by-operation instruction recipe can preserve semantics and
still fail the purpose by becoming a second ASM implementation.

## Deletion property and recommendation

`python research/c_matching/run.py --clean-only` rebuilds and executes the C without
loading recipes, specialized ASM or the firewall. The ordinary-C semantic results
are therefore independent of matching. `check_delete.py` additionally repeats
these fresh builds/tests with the matching directory physically absent, then
restores every recipe byte in finally; `results/deletion.json` records the result. Two ordinary-C wrappers additionally pass
full ABI comparisons with no matching layer. All claimed exact bodies assemble
from compiler/IR operations and compare byte-for-byte; standalone tests require
no original-code fallback. No generated artifact is a production dependency.

For GAME_LOGIC in this sample: two GOOD, one BORDERLINE and three VERIFIED_C_PREFERRED.
For PLATFORM_LOGIC: two ASM_PREFERRED. UNKNOWN-domain helpers: one BORDERLINE and
one VERIFIED_C_PREFERRED. MIXED: not sampled. These tiny reviewed sets are not
population estimates and do not justify a general-purpose matching backend.

The supported boundary is: **small existing semantic bodies plus explicit ABI
binding and a few reusable return-layout choices can match usefully. Once the
recipe has to choose the loop algorithm's entire register/string/stack realization,
it is approaching another ASM program.** Preserve such algorithms as clear C for
future behavioral verification, with justified ASM/ABI islands, rather than forcing
exact C matching. Continue the main exact-ASM reconstruction; this research is
bounded and complete for the selected sample.
