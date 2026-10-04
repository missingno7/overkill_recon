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
native build consumes resource, terrain, checkpoint, timeline, formation and path
definitions through a binding adapter, writing legacy streams into the original
initial DS layout. Map recipes, encounter descriptors and authored departure components use immutable
native level data. With all six originals this reproduces every initialization
byte, including neighboring data. Native code
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
Boss member data and encounter selection now use per-level descriptors described below.

The combat director has four demonstrated choices: segmented boss, fallers then
invaders, leader path, and fallers then burster. A level's `encounter` section
selects those existing procedures, phase thresholds and director damage eligibility.
Faller health, variant assignment and motion are separate policies because their
live selection also occurs after spawning and on subsequent record updates.
The six originals supply explicit burster HP instead of a runtime calculation
from level position. This is a descriptor for the existing director, not a new
encounter scripting system or the opening ambush's formation definition.

The spawner still allocates and assigns a column before applying faller policies;
allocation failure consumes neither the column nor the variant counter. Director
conversion still writes type, then sprite, then health, then X. Health selection
rereads the live level identity after the first two writes, preserving their
possible aliases. Existing animation tables, RNG consumption, boss construction,
leader streams and invader spawning remain authoritative procedures/live data.
Bounded comparisons move encounter descriptors between slots and separately edit
timings, health and policies. They prove this subsystem travels with its content;
they do not establish complete playable-level swaps yet.

Invader slot geometry now belongs to the director's `slots` list: the original
level-3 encounter fills 24 ordered targets. This is a distinct stream from the
slot-hopper leader's `FormationSlots` and the march leader's follower positions.
The native view retains the original DS cursor and exact end identity. Canonical
coordinates remain live DS reads; authored coordinates have independent level
storage. Both Y and X are read after allocation, with the saved-Y write between
them, so table/cursor aliases retain their original order. Fixed 24-slot capacity
is a temporary adapter limit.

The level-5 opening's marchers are a separate behavior. `marching_formation`
selects whether the pre-record-pass march clocks run and supplies separate ordered
member-count tiers for step and fire delays. They do not use the invader slot list.
Original byte-counter wrap, zero-delay semantics, edge/drop latches and first-member
fire-pulse consumption remain in the engine. Leader initialization still resets
march state for every leader, and the type-80 reader still uses the march leader's
end identity. Initial step, edges, drop distance and member behavior parameters
remain procedural defaults; this extraction does not make whole openings portable.

The segmented boss has four fixed roles: anchor, upper-right, core and lower-right.
Its definition separates initial record positions from later anchor-relative offsets:
the lower parts begin at Y zero and acquire their 32-pixel offsets on subsequent
updates. Common health and each role's sprite are data; the director's conversion,
ordered allocation and linked damage/destruction are one unique engine procedure.
This does not imply a generalized boss framework. Canonical offsets remain live DS;
edited geometry has independent per-level storage. Core fire precedes offset reads,
and placement writes/clamps Y before reading X, preserving physical aliases.
Failure retains the reverse smart-bomb pass and stale part pointers. The first
destroyed part has zero HP; parts exploded through its release keep initialized HP
because later smart-bomb visits skip explosion types. These rules explain why a
clean-looking construction rollback would change observable behavior.

Map recipes cover all defined level-1/level-3 actions, center-facing choices across
five levels, the level-2 plunger offset, and fixed-field/clear-only choices across
levels 0/4/5. A recipe names the existing enemy behavior,
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
Level 1 and all defined level-3 cases now dispatch through the generic evaluator; converted cases in
other levels use it before their original handlers. Removing a covered recipe disables it;
omitting the section keeps the originals. Gated runners/cruiser placement, conditional
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
Center-facing definitions write right-side defaults, then test live initialized
X as unsigned against the playfield center; equality selects the left-side fields.
The same policy explains launchers, burst firers and several crawlers without
generalizing their movement. Sprite omission preserves the actual stale value.
Pixel offsets apply after those fields/facing with word wrapping, retaining saved
coordinates. The plunger uses only a Y offset; gated runners and cruiser movement
also copy or conditionally alter coordinates and remain separate evidence work.

Canonical fixtures now use version 3 for the expanded map recipe scope. Version-1/2
definitions retain their earlier scopes, so an older explicit empty/partial list
does not disable actions that were procedural when that definition was written.

## Next boundaries to prove

1. Remaining map recipes: conditional groups, gated/conditional positional changes,
   RNG-dependent selection, retained stale group fields and exceptional scan-cursor
   results. Compare every conversion against the original handler before dispatch.
2. Remaining formation/enemy parameters and level-specific defaults,
   parameters, retaining unique procedural implementations initially.

Only after those boundaries pass should the native game load full external levels
by default. Binding fixtures version the implemented slice; future sections must
be justified by all six originals before joining the public format.

## Level identity and episode progression

### A level includes arrival through departure

The repeated original flow is plaque/arrival presentation, an opening ambush,
the scrolling terrain stage with timed encounters, and the mothership departure.
These belong to the complete level definition, rather than being implicitly
attached to its episode slot. This describes the observed flow, not a commitment
to a new generic phase interpreter.

All six scripts start at countdown 272 with one formation leader. The canonical
definitions already contain those events, formations and their leader/path data:

| Original level ID | Opening leader preset |
|---|---|
| `original-level-0` | `sweep_leader` |
| `original-level-1` | `slot_hopper_leader` |
| `original-level-2` | `bob_chase_leader` |
| `original-level-3` | `sway_leader` |
| `original-level-4` | `sweeper_leader` |
| `original-level-5` | `march_leader` |

Evidence: `LevelScript0..5` and `Formation39..44` in `DATA.ASM`,
`start_leader_script` and `type13_formation_leader` in `spawn.c`.
Leader setup holds scrolling through the live encounter count and end delay;
`scroll_forward_and_check_level_end` observes both. These timing and release
rules must survive extraction. The opening is playable combat, distinct from
`show_level_intro`'s plaque display. Early map-position gates also affect weapons,
pods and rendering; an opening definition needs those policies, not just enemies.

The mothership is distinct from the combat encounter director and segmented boss.
`load_level_map` installs `LevelEndMapRows`; at `MAP_END_POS`, the frame coordinator
smart-bombs live enemies and allocates four animated records from `Type53SpawnTable`.
`run_level_end_sequence` then guides the player through two autopilot waypoints,
creates the extra ship record and refills fuel/energy before requesting progression.
The five map rows, four animated parts and both waypoints are now exported as
`departure` data in each original `.lvl`. Native coordinators use a shared content
view at their original use points. Canonical components retain live DS references;
authored components use independent immutable per-level storage. Neither switching
levels nor restarting patches a shared table. Counts remain the original fixed
five rows/four parts. Triggers, the extra record preset, refill rules, common ship
resources and music remain shared procedural/default content pending extraction.
Allocation failures, stale fields and same-frame phase transitions are preserved.

A complete `.lvl` must resolve every dependency for this whole sequence, including
level-specific behavior parameters and resources. It must not consult another
level definition or an original numeric slot to recover missing content. Common
behavior implementations can remain in the engine. Referenced resources may become
members of a `.lvl` container; physical packaging is still undecided. Independence
must be verified by loading one level without the other five definitions, as well
as by episode permutation tests.

### Episode boundary

The required endpoint is a complete level swap: moving a level to another place
in an episode moves its map, resources, spawn rules, paths, encounters, enemy
parameters, checkpoints, music and presentation together. Episode position must
not implicitly select gameplay rules. The original burster HP formula based on
`LevelIndex` is now an explicit level parameter; the remaining spawn/child HP
formulas and gameplay choices still need the same treatment.

A level definition owns content and the policies needed to interpret that content.
An episode definition references levels in order and owns selection, starting
position, progression and completion policy. The original campaign must be
represented through this same mechanism, preserving its observed chooser order,
wraparound and completion behavior. Start with ordered references; additional
progression features need evidence or an explicit editing requirement.

Neither episode loading nor complete swaps are implemented yet. The current
adapter requires six definitions, binds them by original slot and retains shared
storage/capacity constraints. Definitions are consumed during the native build;
they are not yet loaded from arbitrary files when the executable starts.

Remaining work toward this endpoint:

1. Complete map recipes and drop rules, remaining formation/enemy parameters, reset rules
   and the remaining level-dependent gameplay and presentation parameters.
2. Separate level identity from episode position and introduce episode selection
   and progression without changing the DOS/oracle coordinator.
3. Replace the fixed original-storage adapter with validated runtime loading of
   complete level and episode files, including custom resource references. Shared
   original data must not make an edit to one custom level alter another.
4. Add permutation regressions: with identical initial gameplay state, inputs and
   RNG, a level in different episode positions must retain its gameplay behavior,
   resources and restart behavior. Episode progression follows the authored order.
   The original episode must continue to pass the original equivalence gates.
5. Build the level/episode GUI only after the CLI loader, validator and original
   definitions satisfy those contracts. A custom episode must launch in the same
   executable without rebuilding it or selecting a separate original-game path.

## Comparison rules

Use identical state, map, input and RNG. Compare the full DS window (except actual
stack scratch), map and other affected memory, meaningful return values and
ordered platform requests. Preserve allocation order, stale fields, arithmetic
width and RNG calls. Minimize mismatches before adding a rule. A compatibility
property must describe a proven original behavior, not suppress a failed check.

The ASM exact verifier, DOS `tools/difftest.py` gate and native comparisons are
separate gates. Headless native flows exercise all six selections/transitions;
they supplement bounded state comparisons and do not prove full-playthrough parity.
