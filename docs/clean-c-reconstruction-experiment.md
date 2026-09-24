# Clean C reconstruction experiment

The two-world method works for the reviewed position-history **semantic domain**:
four C leaves compose into two larger C regions, with no historical ABI adapters.
Both regions were tested again as wholes. This is an experimental source closure,
not a completed game or a proof that historical register outputs are globally dead.

## Separate worlds

World A remains the maintained exact ASM, original addresses, register contracts,
and binary verification. Neither R00..R17 nor either conversion lab was changed.
The earlier prefix/trampoline experiments remain verification research, not the
architecture of World B.

World B is [research/clean_reconstruction/src](../research/clean_reconstruction/src).
It contains ordinary C data and calls. Original addresses appear only in the test
mapping and provenance metadata. No original image, extracted executable bytes,
bridge, continuation identifier, CPU-state struct or gameplay ASM is linked into it.
The newer two-world instruction supersedes the preceding mixed-runtime proposal;
no attempt was made to package the frozen main under a different name.

## Source and dependency tree

[HISTORY.H](../research/clean_reconstruction/src/HISTORY.H) defines:

- `Position { y, x }`, with native DOS 16-bit unsigned values;
- `History`, containing 48 positions and four cursor indices;
- ordinary position pointers for optional selected destinations; null means absent.

[HISTORY.C](../research/clean_reconstruction/src/HISTORY.C) owns four leaves.
[UPDATE.C](../research/clean_reconstruction/src/UPDATE.C) composes them:

```text
history_init                         LEAF_C_VERIFIED

history_update                       C_CLUSTER_VERIFIED
  history_advance                    LEAF_C_VERIFIED
  history_store_apply                C_CLUSTER_VERIFIED
    history_store                    LEAF_C_VERIFIED
    history_apply                    LEAF_C_VERIFIED
```

These are actual linked C calls, checked against the linker map and disassembled
call destinations in both link layouts. They are not diagram-only relationships.
There is no C-to-ASM-to-C path between these functions.

The central caller is simply:

```c
void history_update(History *h, const volatile Position *source,
                    volatile Position *const selected[2], u8 input,
                    u16 adjustment)
{
    history_advance(h, input, adjustment);
    history_store_apply(h, source, selected);
}
```

The history names are conservative modern choices. The four cursor roles retain
the reviewed write, delayed-15, delayed-31 and unresolved-other-47 meanings. No
player/enemy role, original struct declaration or historical filename is claimed.
The native small-memory-model proof is not a selection of the eventual whole-game
memory model or a design for a modern port.

## State relation and proof boundary

The verifier relates World A and World B; this mapping is not runtime code:

- Original ring offsets A27A..A339 correspond to `samples[0..47]`.
- A cursor value maps to `(offset - A27A) / 4`. C advances an index by one and wraps
  on equality with 48. Neither C code nor its data contains A27A or A33A.
- Original record fields +2/+4 map to a `Position` object, independent of its address.
- Original FFFF record selections map to null pointers. Present selections map
  to the corresponding position object, preserving object identity and aliases.
- Input low nibble, adjustment word, coordinate values and write sequencing retain
  their original semantics.

Preconditions are explicit:

1. Initialization has a disjoint source position. Afterwards all four indices are
   in 0..47. The original initializer establishes these bounds and the reviewed
   advance operation preserves them; store/apply do not modify cursor metadata in
   this domain. This is a local inductive invariant, not a global proof about
   still-unknown code.
2. Source and selected positions are valid typed objects. They may coincide wholly
   with each other or a ring sample. Pointer arrays and cursor metadata are disjoint
   from position storage. Arbitrary half-object overlap and corrupting a selector
   through a coordinate store are not included.
3. Original DS, SS and CS:9596 designate the common state segment, as established
   by startup. DF is clear. No concurrent mutation is introduced during a region.
4. Each world has valid private call-stack storage and returns through its own ABI.

The existing conversion labs tested broader malformed-offset, partial-overlap and
separate-segment cases. Those results remain evidence in World A. They are **not**
relabelled as verification of this smaller typed C domain. No invented validation
or clamping was inserted to make malformed inputs pass.

This is a state-refinement test: mapped positions, cursor state and ordered semantic
writes agree. Complete memory outside the mapped objects and private stack is also
checked for unintended changes. Historical GP registers are not copied into C
state. Each world is independently checked for correct return, stack balance and
DS/SS preservation; equal stack usage or scratch registers are not required.

A consequential limit remains: outer callers' uses of AX/BX/SI/DI/ES are not all
resolved. Nothing here silently upgrades them to dead registers. These tests prove
memory-effects equivalence of a semantic region, not a drop-in historical-machine
replacement or whole-game contextual equivalence. Before reconstructing a parent,
any consumed value must be recovered as a semantic dependency and tested in that
larger closure. It must not become a permanent register adapter.

## Bottom-up progression and results

| Region | Oracle extent | Original bytes / instructions | Region-state cases | Status |
|---|---|---:|---:|---|
| Initialization | 99BF..99F5 | 55 / 16 | 7 | LEAF_C_VERIFIED |
| Advance | 9CF1..9D4C | 92 / 22 | 36,864 | LEAF_C_VERIFIED |
| Store | 9CD9..9CF0 | 24 / 9 | 2,176 | LEAF_C_VERIFIED |
| Apply | A031..A05F | 47 / 17 | 2,176 | LEAF_C_VERIFIED |
| Store/apply | 9BE2..9BE7 plus its two helpers | 77 / 28 | 2,176 | C_CLUSTER_VERIFIED |
| Update | 9BDF..9BE7 plus all three helpers | 172 / 51 | 2,176 | C_CLUSTER_VERIFIED |

Statuses apply only to the stated semantic domain. Regions overlap; summing their
sizes would inflate coverage. The largest single verified closure is **172 original
bytes / 51 instructions**. Initialization is a separate region.

The C tree was grown in two steps: store plus apply became `history_store_apply`;
then advance plus that cluster became `history_update`. The original has an
additional external entry at9BE2. It remains representable as the normal C
`history_store_apply` operation; it is not an internal label assumed private.

[verify.py](../research/clean_reconstruction/verify.py) runs original instructions
from fresh extraction and actual compiled C from **both** linked executables.
It does not compare C to a second Python implementation of history behavior.

**45,575 region-state cases pass per linked C layout**, covering:

- all 48 initialized phases, all 256 input bytes and adjustment values 0/1/FFFF
  for the advance leaf;
- every selection-presence combination, same destinations, source aliases,
  read-sample and write-sample destinations, and a source within the ring;
- independent randomized cursor phases, destinations and 16-bit coordinate values;
- initialization boundary values, including signed boundaries and unsigned overflow.

Every original instruction site in each selected region was exercised. A separate
sequence test initializes once, carries actual observed state through 120 updates,
and includes paused advancement. It is a reverified sequence, not an invented
larger original function or a gameplay replay.

Both negative controls pass:

1. Changing a compiled leaf ADD8 to ADD9 is rejected by the **whole update** test.
2. Reversing store/apply calls while leaving both leaf bodies intact is also rejected
   by the **whole update** test. The control explicitly checks that each callee still
   receives its correct arguments; only their execution order changes.

The second control is important: verified leaves alone do not prove their caller.
The larger-region test catches a sequencing error that independent leaf tests miss.

## Coupling retained as semantics

- Initialization uses X+9; subsequent history stores use X+8. C preserves the
  asymmetry rather than regularizing it.
- No advancement request still overwrites the current sample. This is not a simple
  frame counter or proof that the source position moved.
- Y is stored before X is read/stored. Whole-position aliases and two destinations
  referring to the same object retain the original ordering.
- The later read can observe an earlier write. Volatile position views preserve
  these accesses without introducing CPU or segment abstractions into the C tree.
- Four cursors move together; only two delayed consumers are understood. The fourth
  role remains unresolved instead of receiving an attractive gameplay name.

## Diagnostic residual

No matching recipe or inline gameplay ASM was introduced. The initial semantic C
needed no correction in the tested domain. Test infrastructure corrections involved
locating a 16-bit immediate for the negative control and bounding the DOS runner's
environment; neither changed game semantics.

| Category | Evidence / disposition |
|---|---|
| SEMANTIC | Index and pointer representations use an explicit relation; mapped final state and ordered writes agree. |
| ABI | Ordinary C arguments and returns replace implicit machine inputs. Test setup knows both interfaces; runtime C knows only C. |
| CODEGEN | BP frames, temporaries, indexed MOV, shifts for array access and loop induction replace register/string choreography. Discarded rather than matched. |
| CONTROL_FLOW_SHAPE | A C loop replaces four unrolled advances; normal C calls compose the two larger regions. |
| PLATFORM | Only a minimal DOS process entry/exit module exists; no history operation was misclassified as platform code. |
| UNKNOWN | Global input invariants and outer caller liveness remain obligations for upward reconstruction. |

## Independent native build

```powershell
python research/clean_reconstruction/run.py
```

The build consumes clean source and pinned tools only. It never reads
`build/program.bin`, original assets or lab executables as code inputs. Verification
separately requires the exact oracle build. The compiler is Turbo C2.0 with
`-c -ms -1- -f- -N- -O -Z -G-`; TASM1.0 and TLINK2.0 produce normal relocatable
OMF objects and a native DOS EXE. Compiler/TASM use the pinned nmlgc player; linking
uses the previously measured i86 runner.

`START.ASM` initializes the compiler data segment, calls ordinary C `main`, and exits
through DOS. It is a 15-byte process-start module, not an original-ABI wrapper.
`SHIFT.ASM` contains 37 unreachable padding bytes solely to perturb linking.
No C function calls it or any original ASM routine.

| Layout | Object order after START | history_advance | EXE size |
|---|---|---|---:|
| base | HISTORY, UPDATE, DEMO | 0000:0069 | 1,069 bytes |
| moved | SHIFT, UPDATE, DEMO, HISTORY | 0000:0197 | 1,106 bytes |

[DEMO.C](../research/clean_reconstruction/src/DEMO.C) initializes history, performs
120 ordinary C updates, and checks chronological delayed values across wraps.
Both linked programs run under the primary **nmlgc MS-DOS Player** and exit with
code0. Both also pass the independent ASM-versus-C region tests. Their linked
addresses differ; their source-level relationships do not.

This is a standalone semantic demonstrator, **not the reconstructed game**. It does
not claim to reach original startup9690. World B does not contain the unreconstructed
rest of the game. That limitation is preferable to hiding the old frozen image
behind a native linker or substituting a fake startup.

## Metrics and next step

| Metric | Value |
|---|---:|
| Verified C leaves | 4 |
| Verified C clusters | 2 |
| Largest verified original region | 172 bytes / 51 instructions |
| Historical ABI adapters in clean runtime | 0 |
| Historical address dependencies in clean source | 0 |
| Calls from clean C to unreconstructed gameplay ASM | 0 |
| Game platform-ASM boundaries introduced | 0 |
| DOS process entry/exit ASM modules | 1 |

World A remains unchanged and passes its full verifier: main143,088 bytes and both
separate audio modules exact, zero mismatches, 36 tests. Its reconstruction counts
remain36,603 instruction bytes,106,419 UNKNOWN bytes,39 reviewed contracts/boundaries
(38 strong/proven), and57 active unresolved indirect sites. These experiments do
not increase exact-ASM understanding metrics merely by compiling C.

The next semantic parent is the continuation9BE8..9BFA, including optional
9FAF/9FEA offset placement. Resolve field+8 table-index bounds and selected-record
lifetime before adopting another typed table model. Review the actual outer
consumers of transfer outputs instead of adding compatibility fields. The larger
9B2E caller also has input/movement dependencies; do not call back into that ASM
from clean C to bypass the missing work.

The empirical answer is **yes for this bounded semantic closure**: leaves compose
naturally into larger verified C, and the historical ABI disappears internally.
The evidence does not yet establish complete-game equivalence or validate the
model for unknown/malformed historical states. The next proof should grow the
semantic boundary, not the adapter count.
