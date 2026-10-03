# Discovering the Overkill engine

Work on `data-driven-levels` starts from the reconstructed SDL3 game. The frozen
ASM and DOS hybrid remain authoritative. This is an incremental extraction, not
a rewrite. No new enemy implementation or normalized game record is required.

## Model supported by the original

A level combines a terrain map, tile attributes, resource banks, map-cell spawn
actions, timed formation events, restart checkpoints and an encounter choice.
Shared gameplay interprets these over the original record pools and state layout.
Definitions describe initial/static choices; cursors, counters, mutated map cells,
group membership and RNG remain runtime state in the existing memory window.

The map is currently both terrain and spawn-command storage. Separate editor
objects may eventually compile into it, but separating those layers at runtime
now would lose observable mutations. Similarly, several path-like streams have
different formats: waypoint paths, leader scripts, formation slots and invader
slots must first retain their own semantics.

## Initial extraction

The native `LevelDef` binds map, sprite bank, block bank, plaque and ordered tile
attribute patches, checkpoints and timeline cursors. References point at original DS pointer-table slots, not cached
targets. Reading each slot at the original use point preserves mutations and loader
callback ordering. No gameplay state is shadowed. Out-of-range word indices retain
the original, independently wrapped table arithmetic.

Canonical `.lvl` fixtures are generated from a freshly built exact oracle. The
native build consumes resource, terrain, checkpoint, timeline, formation and path definitions through a generic
binding adapter, writing into the original initial DS layout. With all six originals
this reproduces every initialization byte, including neighboring data. Native code
uses those bindings through the same live state view. DOS initialization and its
coordinator remain unchanged. Complete external gameplay definitions and runtime
JSON loading are still pending.

Terrain has three observed properties: open, wall, and wall that passes player
shots. All 256 entries start as wall; ordered overrides follow. Preserve duplicate
writes rather than reduce the stream to a dictionary. The legacy terminator is a
tile ID with no value; tile 255 therefore remains wall. The demo separately clears
attributes as runtime policy. Patch writes may alter subsequent DS stream reads;
the native initializer retains this order and does not prebuffer live patches.

The current binding adapter preserves original filename identities, patch storage
capacities and the shared level-1/level-4 stream. Conflicting shared definitions,
longer streams and unbound asset names fail explicitly. These are temporary adapter
limits, not a proposed editor architecture. A future storage expansion must be
proved against ordinary state access and unchecked neighboring reads first.

Checkpoints name map rows, restored countdown clocks and next-event indices. All
24 original cursor values resolve to event boundaries, including scripts with
optional marker words. Selection thresholds equal the next checkpoint's position
in all six levels; the final checkpoint is unconditional. Its unused fourth-word
read stays an internal compatibility rule. Resume clocks/events are independent:
level 2 retains its final clock 77/event-trigger 80 mismatch, and level 5 retains
the same resume event for its last two checkpoints.

The native reader now follows the ASM candidate writes before threshold reads.
The previous C selection skipped intermediate writes; aliases of a threshold or
following record into `CheckpointScriptCursor` expose the difference. Two small
mutated-stream regressions preserve the demonstrated ASM order. Canonical restarts
remain equivalent; the DOS implementation and load module remain unchanged.

The six scripts contain 138 ordered events referencing 52 shared formations. An
event names a countdown, formation, origin and group drop; a formation names an
existing behavior preset, size/layer and ordered offsets. The unused Formation48
is retained in initial DS, outside exported level content. The native spawner reads
its live timeline cursor through LevelDef and keeps its established initializer.
Equal-clock events execute in order; cursor advance precedes allocation, so pool
exhaustion consumes events. Event-marker compatibility preserves variable framing.
Rebinding a changed marker resolves checkpoint indices to their new byte cursors.

Semantic presets expose handler identities without REC_TYPE numbers. Their registry
is a binding, not a behavior-family abstraction. Path movement, leader spawning,
spawn-time HP/record setup and encounter logic still use the original procedures.
The temporary layout adapter preserves shared formations and the group-drop table
also used by map cells; conflicting edits fail instead of silently choosing one.

Paths expose ordered playfield positions, with distinct endings inferred from the
readers: fly off toward a far target, restart, jump, or continue into an adjacent
route. Public Y coordinates include the original reader's 32-pixel offset; encoding
wraps to words. Ordinary followers advance and steer again on arrival in the same
call. Sweep arrivals also consume RNG; the level-4 encounter leader advances its
separate CS cursor and spawns a child. These remain different procedures.

Leader paths expose targets and, where present, follower positions. A null follower
means suppress spawning only for readers that check that marker. The bob/chase
leader does not check it; a source FFFF coordinate becomes a real public Y of 31.
The slot-hopper leader owns an ordered slot list and advances five slots on arrival,
even if allocation fails. End addresses synchronize follower behavior, so the
temporary adapter retains original leader step/slot counts. Ordinary fly-off routes
retain their point count because there is no checked terminator; sweep lead-in
adjacency and the proven self-loop target are also fixed. These are reader/layout
constraints pending further evidence and storage migration.

Canonical definitions include routes used by their formations and directors,
including the boss anchor. The demo route and unreferenced Type4A route remain
in DS and have supported codecs, but are not invented level dependencies.
Boss parts, invader layout and encounter selection remain pending.

Map recipes cover all level-1 actions and fixed-field choices, clear-only cells
and a group-only hole across levels 0/3/4/5. A recipe names the existing enemy behavior,
ordinary, large or no record allocation, ordered relative map-cell writes, and optional sprite
and direction. No general instruction interpreter is needed. The native build
compiles these `.lvl` definitions into immutable per-level recipe tables; shared
runtime state remains in DS. The generic evaluator uses the existing initializers.

Map mutation precedes record allocation, including full pools. Ordinary initialization copies
saved coordinates from the caller before overriding map position; large initialization
leaves saved coordinates stale. Omitted sprite/direction overrides retain the
initializer's actual result, including stale sprites. The hatch's four writes retain
their source order and word offset wrapping. Physical map/DS aliases are resolved
by the existing native memory layer, including high offsets in the ordinary map segment.

An internal migration mask distinguishes converted cells from pending procedures.
Level 1 now dispatches entirely through the generic evaluator; converted cases in
other levels use it before their original handlers. Removing a covered recipe disables it;
omitting the section keeps the originals. Center-facing placement, conditional
sprites, RNG-dependent grouping and fuel scan-cursor behavior remain procedural. Retained C
switches are temporary comparison references, and DOS dispatch is unchanged.

Group preparation is separate from membership. Importer-generated compatibility
data retains allocation-only cases, normal joining before field overrides and large
joining afterward. Preparation precedes map writes, even for the real no-spawn hole
and clear-only cells; failed record allocation still leaves its global effects.
Joining uses the live globals at that phase, including mutations through DS/map
aliases. The current drop source remains the shared legacy offset cycle, also used
by timeline events. Complete map drop-rule extraction remains pending rather than
inventing a separate per-enemy drop that cannot represent the original.
Canonical fixtures now use version 2 for the expanded map recipe scope. Version-1
definitions retain their earlier scope, so an older explicit empty/partial list
does not disable actions that were procedural when that definition was written.

## Next boundaries to prove

1. Remaining map recipes: conditional groups, center-facing/offset placement,
   RNG-dependent selection, retained stale group fields and exceptional scan-cursor
   results. Compare every conversion against the original handler before dispatch.
2. Encounter descriptors retaining unique procedural implementations initially.

Only after those boundaries pass should the native game load full external levels
by default. Binding fixtures version the implemented slice; future sections must
be justified by all six originals before joining the public format.

## Comparison rules

Use identical state, map, input and RNG. Compare the full DS window (except actual
stack scratch), map and other affected memory, meaningful return values and
ordered platform requests. Preserve allocation order, stale fields, arithmetic
width and RNG calls. Minimize mismatches before adding a rule. A compatibility
property must describe a proven original behavior, not suppress a failed check.

The ASM exact verifier, DOS `tools/difftest.py` gate and native comparisons are
separate gates. Headless native flows exercise all six selections/transitions;
they supplement bounded state comparisons and do not prove full-playthrough parity.
