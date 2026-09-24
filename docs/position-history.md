# Position history and offset placement

This static batch reviews six existing main-image entries, without executing a
gameplay replay. All names are modern reconstruction choices. Original byte
hashes, contracts and uncertainty are in `metadata/position-history.json` and
`metadata/symbols.json`; the maintained ASM now uses these names and field/state
constants directly. No historical module ownership is inferred.

## History leaves

| Entry | Name | Established operation |
|---|---|---|
| 99BF | InitPositionHistory | Fill 48 Y/X pairs; initialize four cursors |
| 9CD9 | StorePositionHistory | Write a biased position at the current cursor |
| 9CF1 | AdvancePositionHistoryIfRequested | Conditionally advance all four cursors |
| A031 | ApplyPositionHistoryToRecords | Copy two delayed positions to selected records |

The ring occupies data offsets A27A..A339: 48 entries of four bytes, with Y at+0
and X at+2. A33A is the write cursor; A33C and A33E lag it by15 and31 entries
modulo48, and feed records selected by A962 and A964. FFFF means absent; no
activation or type check occurs here. A340 maintains a fourth phase,47 entries
behind, but its consumer is not established in the known code. This is not a
claim that no consumer exists in still-unknown regions.

Initialization reads record237C repeatedly and fills (Y+8, X+9). Subsequent
writes use (Y+8, X+8). Both wrap at16 bits. The one-unit X difference is original
behavior and is preserved. The cursor advances only when the input low nibble
or the adjustment word A360 is nonzero. All four cursors advance together, before
the position store. They wrap only on equality with A33A after adding4; they do
not validate arbitrary pointers. If cursors do not advance, the current entry
is still overwritten. This therefore is not necessarily a history of frames,
nor of actual coordinate changes: a guarded movement request can advance it.

The high-level caller remains partially reviewed. At9BDF it calls the cursor
advance and falls through9BE2, which stores the position, applies delayed
positions, then optionally invokes the offset-placement cluster. The same9BE2
entry is called during initial setup. We do not rename it UpdatePlayer.

## Offset-placement feedback

`PlaceRecordFromOffsetPair` at9FEA is a normal near entry and also the fallthrough
tail of `PlaceFourRecordsFromOffsetTables` at9FAF. Given a present destination,
it selects a pair using source record field+8, computes wrapped16-bit Y/X sums,
and clamps X using **signed** comparisons to0..192. This differs from the
unsigned movement bound176 in A60A. AX retains the unclamped X, even when memory
is clamped. These are distinct observable values.

Four adjacent pair groups at DS:A368/A374/A380/A38C are now explicit word data
in R15.ASM (48 bytes). Each group has three pairs before the next base. This
does **not** prove an index bound:9FEA multiplies the full word field+8 by4 with
wraparound, and9FAF does not check it. The tests deliberately include index3
and FFFF using valid synthetic table storage. Other record types use field+8
for different operations; its offset-index name is local to this helper.

The wrapper processes slots A96C,A968,A96A,A966 in that order. The first pair
of slots uses twice A39A as extra X displacement; the second uses twice A39C,
through shared scratch A398. It first clears A39E/A39F. The helper sets these
bytes when lower/upper clamping occurs, and does not clear earlier results.
Coincident destination records are overwritten in this same order.

This explains a feedback chain already partly reconstructed:

`9FAF -> clamp bytes A39E/A39F -> next 9C01 -> guarded primary-record X adjustment`

9C01 consumes these bytes before the next9BE2/9FAF placement on the reviewed
update path. The bytes record clamping, not record counts or whether movement
actually occurred. The four associated records' entity roles remain UNKNOWN.

## Preconditions and translation boundaries

The history and offset operations are GAME_LOGIC: coordinates, lookup pairs,
state and records, with no direct hardware access. The enclosing9B2E region is
still MIXED because it polls input and has other incompletely understood work.

The ordinary pair interpretation needs DF=0, valid selected pointers and suitable
nonaliasing. Startup95D3 clears DF, and95D5/95DA set DS/SS from CS:9596. These are
evidence for the environment, not an all-path proof. The original instructions
do not silently inherit a flat-memory model: history writes use ES loaded from
CS:9596, source fields use SS:BP, and state/cursor reads use DS.

Sequential loads and stores matter under aliasing. The tests deliberately show
a first store overwriting the second source word in both the position writer
and history reader. Any later native-source formula will need either an honest
nonaliasing precondition or these exact sequential effects.

9CF1's flags are killed by the following9CD9 ADD;9CD9's flags by A031's first
CMP; A031's flags by9BE8 CMP. This does not establish every register as dead
at the outer9BE2 return. Initializer and offset-helper scratch results remain
documented, rather than discarded through an assumed high-level ABI.

Five leaves are C_READY_WITH_ENV candidates for later behavioral verification,
not converted C and not MATCHED_C. The9FAF shared-tail cluster remains ASM_COUPLED;
its shared scratch and exact call/fallthrough structure remain explicit. No new
compiler-matching evidence or permanent hardware island was discovered.

## Verification and remaining questions

`tests/test_history.py` executes only original isolated routines. It checks all48
cursor phases against all256 input bytes and three adjustment states, full-buffer
write footprints, wraparound, segment separation, alias order, absent slots,
signed clamps, all16 four-slot presence combinations and120 synthetic history
updates across two wraps. These are local semantic tests, not whole-game states.

Six contracts add348 unique reviewed instruction bytes; no additional instruction
bytes were decoded in this batch.48 previously opaque bytes are now reviewed
data. All accepted main/AdLib/Roland byte identities remain exact.

Highest-value questions are the offset-index domain on actual callers, the fourth
history cursor, record lifetimes and unchecked pool-A search results at C450/D1AE.
BD17 clears status first but then branches by+16/+18, calls C054, and can tail to
AC19. Its BD0D wrapper must not yet be advertised as a pure free-record operation.

## Semantic source consolidation

`include/MOVEMENT.INC` now carries the shared coordinate, movement, history and
placement symbols used by R04/R05 and the R06 displacement initializers. This is
modern reconstruction vocabulary; it asserts no historical include or module.
The include is audited as literal EQU definitions only and hashed with the source.

The newly reviewed `StoreApplyHistoryAndConditionalPlacement` entry at9BE2 is
called by978C, CFF0 and D171, and reached by fallthrough after9BDF. Those source
references now use its name. It composes the store, delayed-record copies and
optional four-record placement through their existing named calls. The condition
is **BDAC != 0 OR unsigned2350 > B6h**. The JNE at9BED goes to the placement call,
not to the return. These two state words remain anonymous: this local gate does
not establish their broader meaning.

`CLAMP_X_LOW_SEEN` / `CLAMP_X_HIGH_SEEN` name the exact-1 feedback sentinels.
Skipping placement preserves them and the shared X scratch. The code atA000 in
R05 is the continuation of9FEA from R04, not an independent clamp routine or a
second producer. Physical chunks must not be mistaken for semantic boundaries.
`X_ADJUST_PATH_TAKEN` records an attempted adjustment path: the movement limit
can prevent an actual coordinate change. It too can survive when9C01 is skipped.
These lifetimes forbid treating either signal as necessarily fresh each frame.

Five helper names now expose reviewed coordinate semantics, including
`DecRecordYUnlessAtMin`, `IncRecordYUnlessAtMax`, `DecRecordXUnlessZero`,
`IncRecordXBelowMax` and `CopyRecordPositionPlus10`. The count-dispatch tails now
refer to the named X helpers directly. The Y sentinels are equality guards, not
saturation. `PLACEMENT_X_SIGNED_MAX` remains distinct from the unsigned movement
bound. Group displacement symbols also reach their movement consumers and reset
sites, connecting placement dataflow beyond the individual leaves.

The field at2384 is explicitly assigned3 at9EB0 and9EFC; C559 initializes it to0.
D183 increments it without a local bound, then D199 setsBP=237C and D19C jumps to
placement. An incoming2 there would select index3 across an adjacent pair-group
boundary. Actual reachability of that incoming value, and placement following
those assignment sites, remain unproved. A global field0..2 invariant is false;
three literal pairs per group cannot supply the missing caller proof.

The new isolated caller test covers12 gate combinations (includingB6/B7 andFFFF),
complete DS/ES memory effects with absent selected records, scratch outputs,
preserved registers/segments and the normal stack return. Existing leaf tests
cover present slots, aliasing, wraparound and clamp behavior. The newly reviewed
caller contributes25 bytes /8 instructions; its closed callee set occupies226
unique instruction bytes (caller, store, delayed-copy and placement/shared tail).
No additional bytes were decoded or reclassified as data in this pass.

The nine-entry count dispatch remains resolved. The separate mode dispatch at
9A06 is still unresolved: five apparent words at9A0C are not a proof of a bounded
A47C. Its unknown producer/target code needs recovery before closing that edge.
Unchecked pool-A capacity atC450/D1AE remains unproved as well.

## Displacement producers joined to their consumers

The second review names `UpdatePlacementXOffsetsAtRecordEdges` (A616) and
`UpdatePlacementXGroupA` (A648). This closed producer region is89 bytes /
30 instructions. The parent calls the group-A leaf before updating group B;
9BC7 now uses the parent's semantic name. It runs only for unsigned movement
mode<=1 and unsigned2350>B6. Those gates are different from the later placement
gate, so placement does not imply these words were freshly updated.

At X=0 with negative-X input, group A decrements unless exactly-8; otherwise
it increments unless0. At X=B0 with positive-X input, group B increments unless
exactly8; otherwise it decrements unless0. From zero initialization, these updates
preserve the intervals-8..0 and0..8 under the ordinary nonaliasing state model.
No all-path invariant is claimed. Values outside those intervals follow modular
INC/DEC, rather than being repaired. A648's flags are killed byA622; A616's flags
are killed by9BCA. Both preserve all general and segment registers.

A local6336-case test independently checks the leaf and its parent, both gate
sides, input bits, X edges, accumulator endpoints, out-of-range values and wrap.
It compares complete DS contents, source X, preserved registers/segments, IF/DF
and stack return. The reviewed link is now explicit in source:

`initialization -> edge/input offset updates -> four-record placement -> clamp
feedback -> count/input adjustment -> history advancement/store/application`

The enclosing9B2E caller remains MIXED and partly unresolved; this dataflow chain
is not a claim that its entire subsystem or all record lifetimes are understood.
