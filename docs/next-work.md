# Current direction: static bottom-up reconstruction

The user has explicitly limited execution to necessary probes ending no later than
first gameplay entry. Broader scenario exploration is no longer a work item or an
acceptance criterion. Existing long traces are retained as prior evidence only.

1. Review the smallest runtime leaf candidates and their callers, register/flag
   contracts, memory accesses and constants. Separate main and optional-module identities.
2. Resolve executable-write questions by static destination/alias analysis. Keep
   unknown indirect writes visible; do not substitute endless gameplay exploration.
3. Recover data-field facts and propagate supported names upward. No speculative
   subsystem architecture or original filenames.
4. Assemble and compare after every meaningful batch. Use isolated original-routine
   tests when they clarify a contract; use a bounded startup probe only when needed.

# Remaining work, in evidence order

The initial exact ASM bootstrap is accepted. The requested final reconstruction
phase is **not complete**. This file identifies concrete outstanding work rather
than disguising unknown regions as finished reconstruction.

1. Resolve the remaining indirect sites in `metadata/analysis.json`. The initial
   three-way selector pattern is supported at startup but not proved exhaustive.
   Other table lengths require actual bounds from their callers/writers. In
   particular inspect 5AB1/5ADC, AA30, 759B, D5F9, the record-driven callbacks at
   83AC/856F, and the AX/BP bridge at 8D8B/8D8E. Do not scan arbitrary words and
   declare each plausible pointer a function.
2. Review the now-observed INT08, INT09 and INT24 handlers bottom-up. In
   particular retain nonlocal stack/state effects in the INT24 contract.
3. Decode reachable additions, promote only proved tables/data extents, and drive
   explicit raw source bytes down. The current bootstrap helper can produce a
   candidate transcription, but must not overwrite reviewed source without a diff.
4. Add leaf contracts and tests, then revisit callers. The buffered byte/word
   readers demonstrate why even small helpers may be ASM_COUPLED: their DOS error
   route restores an outer SP and exits through a shared tail.
5. Use CS writes and xrefs to identify self-modifying regions and add versioned
   runtime code evidence. Preserve the original initial image as a distinct oracle.
6. Continue static reconstruction of the independently extracted AdLib and Roland
   modules. Directory and decoder recovery are complete; indirect dispatch and
   record-field contracts remain open.
7. Run real object-topology experiments at supported candidate boundaries. The
   existing tests establish alignment/non-uniqueness behavior, not original module
   ownership. Keep library/runtime identification UNKNOWN until evidenced.
8. Reconstruct the launcher and wrapper source and a deterministic repacking route
   if technically practical. Whole original file identity is still unmet. Any
   compression token recipe or residual wrapper bytes must be explicitly accounted.
9. Build a genuine DOS launchable reconstruction once its header/allocation model
   is supported. `program.bin` is currently a normalized image, not an EXE.

Keep the two independent evidence streams in sync: semantic relationships and
binary/linker constraints. No broad C translation belongs in this phase.

## Runtime investigation follow-up

- Preserve Oracle A; use the shared main runtime graph and separate audio graphs.
  The alleged post-A 5E42 replacement was actually pre-A EXEPACK materialization.
- Reproduce the candidate 9690 frontier with tools/materialize_runtime.py. Full
  verification executes one bounded startup check and checks ASM correspondence plus deterministic
  artifacts. Do not reuse generated RAM as an execution input.
- Runtime environment limitations remain documented. Resolve concrete uncertainties
  statically or with a targeted probe capped at first gameplay entry. Broad scenario
  exploration and exhaustive state coverage are deliberately not acceptance requirements.
- Keep 9690 as the bounded, reproducible startup boundary. Its absolute minimality
  is unproven and is not a reason to expand execution. Refine it only if static
  evidence exposes a concrete reconstruction need.
- Resolve new observed control-flow edges and reconstruct newly identified main
  instruction bytes incrementally. Keep the reviewed R00..R17 source intact until
  explicit, independently verified edits are made; new CFG coverage is not ASM coverage.
- Investigate module indirect dispatch tables, nine stride-20h record bases in the
  AdLib tick routine, and shared audio-driver conventions. Keep field roles and
  historical macro/file names uncertain until supported.
- ReadOpl2Status is a tested leaf. Propagate its evidence into the register writer,
  timer probe and callers; preserve PIT/port61 side effects in their contracts.

## Immediate Tandy + AdLib queue

Eight main helpers and the AdLib delay/register writer now have reviewed contracts.
See [tandy-adlib.md](tandy-adlib.md). Continue with AdLib04A4's register table,
024F's frequency words and fallthrough predecessor, then Tandy3153's mask renderer
and3354's workspace-to-display copy. Resolve caller preconditions and field use
before assigning gameplay or original module names. No further game replay is
needed for this queue.

## Completed second batch and next local questions

04A4,024F,0244,3354 and3389 now have reviewed contracts and tests. The56-byte
AdLib command table is reconstructed data with independent accounting. Next:
- Trace AdLib02AA's conditional cached write and02C9/02F6's shared frequency-update
  tail using the newly established record fields; retain their shared stack state.
- Review the Tandy3153 mask renderer's normal and16/17 control paths, with caller
  bounds for color and character indices rather than invented clipping.
- Propagate DS:234C's demonstrated source-window role through its writers before
  assigning scrolling or gameplay names.

## Current highest-information work: records and movement

See [record-movement.md](record-movement.md). Seven main routines now have reviewed
contracts; the9C6B dispatch is closed and its52 branch-body bytes plus18 table bytes
are maintained source. Field and pool constants are propagated into the ASM.
The position-history follow-up is reviewed below. Pool-reuse BD0D and unchecked
search callers C450/D1AE remain open. Keep AdLib work bounded to specific contract questions.
The earlier platform queues above remain useful secondary work, not the sole path.

## Position-history and placement follow-up

Six more entries now have source names and contracts; see [position-history.md](position-history.md).
9CF1 advances four cursors;9CD9 stores a pair;A031 copies delayed positions.
9FAF/9FEA explain the clamp-byte feedback consumed by9C01. Continue with:

- Bound the primary record's field+8 at9FAF callers. Four bases12 bytes apart are
  evidence for adjacent groups, not proof that the index is always0..2.
- Trace record creation and retirement for A962/A964 and A966..A96C. Use these
  consumers to clarify roles conservatively; do not jump directly to enemy names.
- Resolve BD17's C054/AC19 effects before naming BD0D as a release operation.
  Preserve its type-dependent state changes and nontrivial shared tails.
- Examine capacity guarantees at unchecked pool-A callers C450/D1AE. Do not infer
  successful allocation merely because most other callers check BX againstFFFF.
- Investigate A340 only through concrete xrefs or recovered code; no broad replay
  is needed. Preserve the unresolved fourth-cursor role.

## Bounded C/matching research completed

The ten-routine primary study is in [c-match-diff-language.md](c-match-diff-language.md).
Do not generalize it into a compiler or production conversion: two GOOD and two
BORDERLINE small exact demonstrations do not settle the remaining game. Return to
the record/index/lifetime questions above. The research also corrected the AdLib0579
contract: repeats reload the previous counter reading, not the initial1FFFh.

## One native DOS swap unit completed

The bounded [swap experiment](swap-unit-experiment.md) establishes a native C option
for9CF1 under its reviewed caller contract, with104,544 synthetic comparisons and
both native packages reaching9690. It does not expand production C scope or prove
unknown call edges, all interrupt schedules, or unlimited stack capacity. Next
consider the9CD9/A031 history store/application boundary: preserve sequential alias
effects and review scratch outputs before deciding whether to combine the routines.
The main exact-ASM queues and acceptance criteria above remain in force.

## Second bounded swap cluster

The [history-transfer experiment](history-transfer-swap.md) verifies9BE2/9CD9/A031
in four combinations with the first unit. Its101-byte bridge exceeds the77-byte
original cluster. Before another C unit, establish caller-visible progress-register
liveness after9BE8 and the9FAF field+8 bounds. A larger closed boundary may reduce
ABI surface; do not assume every helper should become a separate C function.

## Previous clean-world pass (paused)

[The clean C experiment](clean-c-reconstruction-experiment.md) verifies four history
leaves and two C-to-C clusters under a typed initialized-state relation. Next review
9BE8..9BFA and the9FAF/9FEA dependencies: field+8 bounds, record lifetime and actual
parent-visible values. Grow semantic closure; do not add historical register or
continuation adapters. Keep original malformed-state behavior in the exact oracle
and do not overstate the clean proof domain. The standalone C demo is not the game.

## Active exact-ASM priority

All C, swap/matching, mixed-build and port research above is paused and preserved.
Continue the named history/movement/placement cluster in maintained ASM:

- Recover the predecessor constraints atD183 and whether assigned index3 at9EB0/
  9EFC reaches placement. The primary field is not globally limited to0..2.
- Recover A47C producer/target islands around9A16..9AFD before declaring9A06's
  apparent five-entry dispatch closed. Preserve possible overlapping entries.
- Trace selected-record lifetimes and pool-A capacity before stronger entity names.
- Prove parent-visible scratch/flags at978C, CFF0 andD171;9BE2 now has a reviewed
  composition contract, but no blanket dead-register claim.
- A616/A648 now have reviewed contracts and a reverified producer cluster. Follow
  their surrounding9B2E paths (9CB6 and mode dispatch) without inferring global
  accumulator or mode bounds solely from equality guards.

See position-history.md for the exact gate, feedback lifetimes and source changes.
