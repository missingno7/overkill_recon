# Position-history transfer swap experiment

This second bounded experiment is **SWAP_VERIFIED_C** under the boundary below.
It adds one closed cluster to the [first cursor-advance experiment](swap-unit-experiment.md).
It does not promote experimental C into production, introduce a matching language,
or establish whole-game behavioral equivalence.

## Unit and boundary

Modern name: `StoreAndApplyPositionHistory`. GAME_LOGIC with DOS memory-model
constraints; no hardware, OS calls, timers or external callbacks in the unit.

| Original region | Role | Bytes | Instructions |
|---|---|---:|---:|
|0000:9BE2..9BE7|two calls, common entry|6|2|
|0000:9CD9..9CF0|store current position +8|24|9|
|0000:A031..A05F|apply zero, one or two delayed positions|47|17|
|Total||77|28|

Known decoded incoming edges are CALLs at978C, CFF0 andD171, and fallthrough
from9BDF. All enter9BE2. Neither helper has another known caller. The only
external continuation is9BE8; helper RETs are internal to this cluster. The
machine-readable boundary checks these edges against the maintained runtime graph.
This is closure of known decoded edges, not proof that all unresolved indirect
transfers elsewhere cannot enter a helper.

Inputs:

- SS:BP supplies record Y at+2 and X at+4. DS addresses cursors A33A/A33C/A33E,
  selections A962/A964 and delayed source/record storage.
- CS:9596 supplies the output segment. The write offset is captured from DS:A33A.
- Incoming BX/SI survive if no delayed copy is selected. Other preserved registers
  and control flags are also part of the boundary.
- DF=0 is required for this forward-pair interpretation. Startup establishes CLD;
  this is not a claim that every possible incoming machine state has DF clear.
- Data and a private 64-byte below-SP stack reservation must not alias. Synthetic
  states provide that space; global stack capacity is not proven here.
- Selected offsets must designate accessible storage. No asynchronous mutation of
  these state cells during the unit is assumed; arbitrary IRQ interleavings and
  instruction timing are not equivalence claims.

Observable result:

- Ordered writes: biased Y, biased X, optional first delayed Y/X, optional second
  delayed Y/X. Reads occur between writes as in the original.
- AX is the last transferred X; DI is initial write offset+4; ES is CS:9596.
- If a delayed pair was applied, BX is its record offset and SI its source offset+4.
  Otherwise BX/SI are unchanged.
- CX/DX/BP/DS/SS and stack position at9BE8 are preserved. The far gate returns
  before the unchanged next instruction, without consuming an external near return.
- Arithmetic flags differ but are killed by the original CMP at9BE8. Tests compare
  control flags at entry to that instruction and all flags after it.

## Canonical C and residual

[TRANSFER.C](../research/history_transfer/TRANSFER.C) owns the complete transfer:
load source Y, add8 modulo65536, store; then independently load/add/store X;
then test and perform each delayed copy. Volatile qualified native DOS views retain
ordered overlapping accesses. The second selector and cursor are read only after
first-copy stores. A plain early snapshot of all fields would be incorrect.

The C uses `Record`, `Position`, `Cursors`, `Selections` and `TransferProgress`.
Y/X ordering and delayed15/delayed31 names come from existing history contracts;
no entity/enemy role is inferred. `other47` retains the unresolved fourth-cursor
role. These are modern source representations, not historical struct declarations.
The C is DOS-specific, not an ISO-portable type-punning or flat-pointer model.

`TransferProgress` carries last X, write end, last applied record/read end and
whether a delayed copy occurred. This is extra interface surface required to
preserve conservative original register outputs. It is not a CPU register object,
but it is an ABI-induced cost. Proving some outputs dead or choosing a larger
closed boundary may make it unnecessary later. Do not describe that cost as free.

Turbo C2.0, small model, near cdecl, flags
`-c -ms -1- -f- -N- -O -Z -G-` produces **210 bytes /73 instructions**.
The separate [bridge](../research/history_transfer/TRANSFER.ASM) is **101 bytes /
51 instructions**. It marshals near/far pointers, preserves registers/control
flags, and maps progress to original outputs. Its conditional mapping of BX/SI
adapts presence of outputs; all selection, copying and arithmetic remain in C.
No matching recipe, generated canonical C, CRT, interpreter or fallback is used.
Deleting the diagnostic residual leaves independently compilable C.

| Residual category | Finding |
|---|---|
|SEMANTIC|No known difference under the stated domain; ordered alias tests agree.|
|ABI|Implicit segment/register/global inputs become C arguments; original live outputs require progress results and a bridge.|
|CODEGEN|BP frame, pointer reloads, local slots, SI temporary, indexed MOV instead of LODS/STOS.|
|CONTROL_FLOW_SHAPE|Two helper calls become one function with optional blocks and a common epilogue.|
|PLATFORM|16-bit near/far pointer and stack conventions remain explicit. No hardware effects.|
|UNKNOWN|Undecoded incoming control flow, unrestricted asynchronous mutation and global stack headroom remain open.|

No semantic correction to the initial C was required by the tested residual.
An initial instruction-count assertion was corrected from29 to28 against the graph.
A harness-only failure on repeated runs was resolved by explicit instruction hooks
at the boundaries instead of relying on repeated `emu_start` end/count behavior.
Neither issue was hidden by changing C semantics or original ASM.

Exact-body matching is not worthwhile here: reproducing the original would require
specifying string-operation register choreography, absolute addresses, implicit
outputs, helper call topology and return layout. The bridge alone is larger than
the original cluster. This supports behavioral verification for this boundary,
not a claim that a small matching diff explains it.

## Differential evidence

`python research/history_transfer/verify_transfer.py` executes the actual loaded
MZ images, including relocations, C body and ABI gates. It does not compare C to
a second Python implementation of the algorithm.

**3,647 test states PASS**:

- 3,072 combinations of four actual incoming edges,48 ring phases, four selection
 masks and four source/output segment configurations; all four ASM/C combinations.
- 56 targeted alias cases: source-X overwrite; next-sample-X overwrite; same record
 twice; first copy changes second selector, cursor or source; writer changes
 selectors or cursors.
- 7 offset boundary cases including FFFC/FFFE/FFFF, exercising16-bit address wrap.
- 512 deterministic random states with overlapping records and independent cursors.

The full boundary comparison includes all general/segment registers, SP, exit,
control flags, ordered non-stack writes, and complete DS/SS/output memory windows
except the64-byte private below-SP reservation. All flags agree after the next
original CMP. Every one of the28 original instruction sites is exercised. C
variants never execute either original helper body. A negative control changing
a generated ADD8 toADD9 is rejected on a fresh CPU instance.

Measured deepest stack use from the synthetic caller's SP:

|Advance implementation|Transfer implementation|Bytes|
|---|---|---:|
|ASM|ASM|4|
|ASM|C|64|
|C|ASM|38|
|C|C|64|

The64-byte domain is a tested resource precondition, not a global proof. Excluded
private stack contents and dead arithmetic flags are explicit, not arbitrary
memory/register allowlists.

## Real build and bounded integration

`python research/history_transfer/run.py` rebuilds the exact main, compiles both
research units, builds four native packages, tests the local boundary and runs
bounded startup. Modes `aa/ac/ca/cc` select advance then transfer independently.
Packages are `build/history_transfer/<mode>/PLAY.EXE`. Each also contains the
`OVERKILL` resource-container copy and original launcher used as integrity input;
launch PLAY.EXE, not the original launcher.

The common1KiB prefix contains launch, both bridges and compiled C in every mode.
ASM mode retains original main instructions; C mode changes only the relevant
six-byte entry gate. The transfer gate is far CALL plus NOP, continuing at9BE8.
The first unit retains its far CALL plus RET gate. Main image topology and123
ordered original relocation sites are retained with the prefix adjustment; gate
and launch relocations are explicit. Resource payload is unchanged; the original
container checksum footer is regenerated and checked, never bypassed.

**All four native packages reach0000:9690**, Tandy/PCjr +AdLib/OPL2 +keyboard,
with authentic original startup in the existing modeled DOS/hardware environment.
Each takes3,723,611 harness steps and loads the exact original AdLib module. Main
memory differences are restricted to selected gates and independently recomputed
checksum scratch words. No execution went beyond first gameplay.

This startup frontier precedes either swap unit: it proves packaging/loading/
initialization, not natural gameplay execution of C. Actual caller and continuation
execution is established separately by the synthetic full-image tests above. No
native-player gameplay or exhaustive integration-coverage claim is made.

The shared packager change is limited to explicit prefix size, destination folder
and entry gates. Default operation reproduces both first-experiment packages
byte-for-byte against committed543f93c results, so their previous machine-image
verification remains applicable. New regression provenance is recorded separately;
old test receipts are not relabeled as freshly rerun tests.

## Decision and next boundary

The puzzle-piece method works for this second known cluster and composes with the
first. Classification: **SWAP_VERIFIED_C**, with explicit domain and known-graph
closure limits. It is not MATCHED_C or evidence for a generally cheap ABI shim.
Production remains entirely exact ASM; full verification passes36 tests, main
143,088 bytes and both separate audio modules with zero mismatches.

Next high-information work is static: establish which progress registers are
actually consumed beyond9BE8, and bound the optional clamp continuation9FAF and
record field+8. A larger closed movement/history cluster may eliminate scratch
outputs and reduce bridge cost. That should be established before another C unit;
do not scale by mechanically wrapping every anonymous label.
