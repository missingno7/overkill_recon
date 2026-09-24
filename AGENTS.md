# Reconstruction rules

These rules apply only inside overkill_recon.

- Preserve originals and metadata/inputs.json. Verify hashes before using inputs.
- Never modify overkill_forged, legacy/overkill_port or empires_reconstruction for this work.
- Deliver assembly. Do not begin a C port, SDL work or broad ASM-to-C conversion.
- Keep build independent of neighboring projects. Use the local nmlgc MS-DOS Player
  as the primary runner for DOS assembler compilation. The local upstream i86 player
  is the measured TLINK runner.
- Run `python tools/verify.py` after every reconstruction batch; use `--full` after
  extractor, toolchain, graph-boundary or semantic-test changes. Never regenerate
  source implicitly during acceptance. A successful build that includes raw bytes
  is not a claim those bytes were reconstructed.
- Unknown code/data remains UNKNOWN, not guessed data or guessed functions. Account
  for every byte and expose every DB/bootstrap fallback. Do not use INCBIN to hide code.
- Work from leaves and verified hardware/format facts upward. Review callers,
  callees, flags, segment defaults, memory writes and shared/nonlocal tails.
- Keep original relative segment:offset provenance. Load segment 1010h is one
  verification configuration, never a universal physical address.
- Keep BYTE_EXACT, STRUCTURALLY_SUPPORTED, SEMANTICALLY_SUPPORTED and
  HISTORICALLY_PROVEN independent. Keep PROVEN/STRONG/INFERRED/SPECULATIVE/UNKNOWN
  per evidence dimension. Matching instructions does not prove historical tools.
- Use candidate assembler/linker experiments to test alignment, object ordering,
  segment topology, relocations and probable module boundaries. Record models
  that produce identical output too: non-uniqueness is evidence against certainty.
- Modern source names, macros and physical chunks must not be presented as recovered
  original names. Original-project reconstruction evolves with both semantic and
  binary/build evidence; do not force either stream to fit an attractive architecture.
- Update docs/original-project-reconstruction.md and metadata/project-model.json
  with structural claims. Recurring patterns alone do not prove a historical macro.
- Keep C_READY classifications conservative. Shared tails, asynchronous state,
  interrupts and nonlocal stack unwinds must remain explicit. No statistics gaming.
- `bootstrap_source.py --replace-bootstrap` overwrites source; it is never an
  ordinary build step. Preserve manually recovered work when expanding coverage.

- Preserve Oracle A at0000:95C9. Candidate runtime Oracle B at0000:9690 is an
  additional environment-specific artifact, not a replacement or global stability proof.
- The 5E42..5F1A write is pre-A EXEPACK materialization. Do not treat that main
  address as a post-A cold/runtime split. The optional1022 module slot does have
  initial, AdLib and Roland identities; loaded header data must not inherit cold
  stub instruction classifications.
- Runtime execution must start from pinned originals, not legacy/generated memory
  snapshots. Trace original CPU writes and modeled environment writes separately;
  retain unknown post-frontier mutations. Use original IRQ handlers for scripted input.
- Use metadata/runtime and metadata/drivers for active bottom-up semantics. Keep
  discovery coverage, maintained mnemonic source coverage and semantic confidence separate.
- Every source promotion must rebuild exactly. Existing reviewed instruction text
  and contracts must survive incremental UNKNOWN-range promotion.

## Static-first research policy (user direction, 2026-09-24)

- Prioritize static bottom-up reconstruction: small leaf contracts, callers/callees,
  register and memory effects, data fields, conservative names, and build evidence.
- Run original game code only to resolve a specific uncertainty that static work
  cannot settle or to verify the pinned startup oracle. Do not routinely replay it.
- Never continue an investigation run beyond first gameplay entry (0000:97B2).
  The harness enforces that frontier. Earlier exploratory traces are historical
  evidence, not a requirement or a recipe for further state-space exploration.
- Do not require exhaustive levels, deaths, bosses, endings or possible game states
  as an acceptance condition. Track static unknowns explicitly and resolve them
  locally. Isolated routine contract tests remain appropriate.
- Normal verification assembles and compares bytes without whole-game execution.
  Full verification performs one necessary, bounded startup-oracle check at9690;
  repeated startup runs require a specific determinism investigation.

- Current semantic priority: Tandy/PCjr + AdLib/OPL2 with default keyboard.
  Keep other implementations intact. Use packed-pixel and bank-address facts in
  metadata/reconstruction-focus.json; visual equality with EGA is unproven.

## Source usefulness and current priorities

- Exact build comes first; semantic usefulness and local contracts take precedence
  over speculative historical filenames, module ownership or future C shapes.
- Propagate proven names, field offsets and state constants into maintained ASM.
  Modern EQU names are reconstruction choices, not historical-source claims.
- Track GAME_LOGIC / PLATFORM_LOGIC / MIXED / UNKNOWN separately from convertibility.
- Distinguish modified registers/flags from values actually consumed by callers.
- Revisit generic record/game behavior regularly; avoid indefinite driver work.
- No broad C work, mixed C/ASM game, port APIs or new analysis framework in this phase.

## Previous two-world experimental reconstruction (paused)

- World A remains the independent byte-exact ASM oracle with unchanged acceptance.
- World B under research/clean_reconstruction may reconstruct reviewed game-logic
  leaves and callers as ordinary C, verified against World A. No runtime historical
  ABI adapters, frozen-image substrate, matching DSL or calls back to unrecovered
  gameplay ASM. This bounded exception does not authorize broad game conversion.
- Existing swap labs remain verifier/conversion research, not the clean architecture.
- Record typed-state proof domains and unresolved parent dependencies explicitly.
  Do not claim original ABI outputs dead merely because C no longer exposes them.

## Current phase: semantic exact ASM

- All C, swap-unit, matching-diff, mixed-build and port research is paused, including
  earlier research-local exceptions. Preserve the research as evidence; do not expand it.
- Prioritize meaningful routine/local/state/field/table symbols in maintained ASM,
  with exact bytes and relocation order unchanged. Semantic relationships must spread
  into callers and shared-state consumers, not remain only in external notes.
- Use many Luna workers for narrow independent static investigations when requested;
  workers gather evidence and do not mass-edit. The supervisor reconciles claims,
  edits the smallest supported source batch and runs exact verification.
- Do not infer entity roles, global index bounds or historical module ownership from
  attractive names or adjacent table data. Keep remaining uncertainty explicit.
