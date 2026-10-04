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

## Content ownership inventory

The boundary is between static choices and the existing procedures that consume
them; it is not a conversion to a second game-state model.

| Owner | Concepts | Current rule |
|---|---|---|
| Engine/runtime | Record pools and allocation, movement and combat procedures, RNG, scrolling, collision, rendering/audio services, encounter and script cursors, counters, mutable map cells and checkpoint state | Keep observable execution state in the original memory layout. Authored timeline event ordinals occupy the existing `LevelScriptCursors[behavior_profile]` DS word; canonical timelines keep their original byte offsets there. Preserve procedure order, stale fields, timing and side effects. |
| Shared game content | Common graphics/resources and common start, end, late-level and title music tracks; shared rules for intro, encounter release and mothership departure | Keep content shared when the original uses one identity or one policy across levels. A shared trigger does not make its selected level resource shared. |
| Level-specific content | Map, banks and plaque, level palette/digit choices (pending), tile properties, spawn recipes, timelines, formations and their spawn HP, semantic checkpoints, paths, invader slots, encounter choice/parameters, boss setup, departure geometry, checkpoint restoration and level theme | These choices travel with a level definition only where runtime loading supports them. Version 10 loose content additionally owns the ten ordinary fly-off waypoint routes. Version 9 owns its map, timeline, formations, arbitrary semantic checkpoint list, formation member HP, checkpoint restoration and music. Level soundtrack selection uses `music: {level: 8}`; this example is a tune index, not a recovered track name. |
| Legacy packaging/compatibility | SHADOW archive distribution, BIC/ENC encodings, original DS/CS tables, pointer slots, aliases, unchecked neighboring reads, marker framing, physical segment wrapping and read/write order | Canonical generated definitions retain live source bindings at each original use point. Authored definitions store their explicit values independently even when equal to canonical values; internal compatibility metadata identifies a live canonical binding without making it a public editing concept. |

This inventory is a working ownership boundary, not a claim that every item is
already independently loaded from an external file at runtime. Loose content still
selects one of six original behavior profiles. Resource identities need a broader
audit, including the chooser's `choose.enc` six-slot boundary and unchecked
seventh-level behavior. Episode progression and fully independent bank, path,
spawn-recipe and encounter data remain pending.

The version 10 loose content object owns an immutable source map, timeline, named
formations, checkpoint rows, formation spawn HP, restart/music policies, ordinary
fly-off waypoint routes and a content ID distinct from its original behavior profile.
Versions 8 and 9 remain accepted with their earlier content slices. Loading is transactional: a failed
validation or asset read retains the active content. Map reload copies source tiles
into the existing mutable map arena; it does not create a second gameplay map.
Timeline events and formations are read from immutable owned descriptors while
the event ordinal stays in the profile's existing DS cursor word. All other
unextracted fields are checked against the profile's canonical fixture and rejected
if edited. This remains a narrow migration boundary, not a fully independent level
runtime.

## Initial extraction

The native `LevelDef` binds canonical map, sprite bank, block bank, plaque, ordered
tile-attribute patches, checkpoints and timeline cursor slots. Canonical references
point at original DS pointer-table slots, not cached targets. Reading each slot at
the original use point preserves mutations and loader callback ordering. For
authored version 9 timelines, immutable event/formation descriptors replace the
source stream, but the existing profile cursor word stores the next event ordinal;
there is no parallel runtime cursor. Out-of-range canonical word indices retain
the original, independently wrapped table arithmetic.

Canonical `.lvl` fixtures are generated from a freshly built exact oracle. The
native build consumes resource, terrain, checkpoint, timeline, formation and path
definitions through a binding adapter, writing legacy streams into the original
initial DS layout. Map recipes, encounter descriptors and authored departure components use immutable
native level data. With all six originals this reproduces every initialization
byte, including neighboring data. Native code
uses those bindings through the same live state view. DOS initialization and its
coordinator remain unchanged. The version 10 runtime JSON loader supports copied
content with a new ID and independent map, timeline, formations, checkpoint rows,
formation-member HP, checkpoint-restoration rules, music and ordinary fly-off
waypoint routes. Sprite/block/plaque resources, terrain patches, special paths,
leader paths, map-spawn recipes and parameters, group tables,
departure, encounter, marching formation and boss sections must still match the
explicit original behavior profile; unsupported edits fail before gameplay.
Episode progression and fully independent resource selection remain pending.

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

Checkpoint selection and map restoration are separate level choices. Canonical
checkpoint selection retains the live four-record DS walk, provisional cursor
writes, unsigned thresholds and ignored fourth-word overread. Authored version 9
checkpoints are semantic `{map_row, script_clock, resume_event}` rows; selection
uses the following row as the unsigned threshold and makes the final row
unconditional, with no legacy overread. Restart captures the selected resume
ordinal in `CheckpointScriptCursor`, performs the ordinary map reload and rewind,
then restores that ordinal into the existing profile cursor at the original final
write point. The level-specific `checkpoint_restart` policy independently restores
the preceding map window with ordered first-match rules.

The six canonical scripts contain 138 ordered events referencing 52 used
formations. Canonical execution keeps its live DS byte-offset cursor, variable
marker framing, shared formation/drop bindings and source order. Version 9 authored
content instead resolves an ordinal in its immutable event list and named formation
descriptors; the DS ordinal advances before member allocation, so pool exhaustion
still consumes the event. Every map load first performs the original six cursor
initializations; an owned timeline then sets only its behavior-profile slot to zero.
A resume ordinal equal to event count is the terminal boundary. Formation spawn HP
is also data in version 9; canonical
`live_original` parameters preserve the original level-dependent tile-member value
and fixed other-member value. Enemy movement, initialization order, group allocation,
and REC_TYPE behavior remain in their existing procedures. The unused Formation48
remains untouched in the canonical DS image.

Semantic presets expose handler identities without REC_TYPE numbers. Their registry
is a binding, not a behavior-family abstraction. Path movement, leader spawning,
record initialization and encounter logic still use the original procedures. The
selected behavior profile also supplies the global DS path tables those procedures
may read; a preset name does not make those path payloads independently editable. The
build-time canonical binder preserves shared formation and group-drop storage.
Authored version 9 timelines own their event drops and formations independently;
map-spawn recipes and map-group-drop compatibility still follow their separate
profile/equality boundaries.

Paths expose ordered playfield positions, with distinct endings inferred from the
readers: fly off toward a far target, restart, jump, or continue into an adjacent
route. Public Y coordinates include the original reader's 32-pixel offset; encoding
wraps to words. Version 10 owns only the ten ordinary fly-off presets used by the
REC_TYPE 0x10/0x11, 0x41, 0x43/0x44/0x45, 0x4A, 0x51 and 0x66/0x67 starters. The shared defaults come
from `levels/shared/waypoint-presets.json`; generation checks them against the
maintained oracle route streams. All ten routes occupy one flattened immutable
point array, and their start ordinals are substituted for the original byte
addresses. `REC_PATH` remains the existing runtime cursor, with no shadow cursor.
Ordinary followers still advance and steer again on arrival in the same call.
Canonical execution has no owned-route provider and continues reading live DS
words at the original byte offset plus four. For an authored route, the generated
fly-off terminal is clamped if an unusual state reaches it; this prevents the
canonical reader's otherwise unchecked next-word read from escaping the authored
array. Sweep arrivals also consume RNG; the level-4 encounter leader advances its
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
including the boss anchor. Version 10 can edit the ten ordinary fly-off routes;
leader scripts, sweep lead-in/loop, encounter-leader route and boss anchor remain
profile-bound to canonical data. The demo route and unreferenced Type4A route remain
in DS and are not evidence of additional level dependencies.
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

Map recipes now cover every defined original action in all six levels, including
conditional crawler sprites, random jitter-shooter membership and the fuel pickup. A recipe names the existing enemy behavior,
ordinary, large, pickup or no record allocation, ordered relative map-cell writes, and optional sprite
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
All defined cases in all six levels now dispatch through the generic evaluator. Removing a covered recipe disables it;
omitting the section keeps the originals. Older definitions retain their narrower
conversion scopes. Retained C switches are temporary comparison references, and DOS dispatch is unchanged.

Group preparation is separate from membership. Importer-generated compatibility
data retains allocation-only cases, normal joining before field overrides and large
joining afterward. Preparation precedes map writes, even for the real no-spawn hole
and clear-only cells; failed record allocation still leaves its global effects.
Joining uses the live globals at that phase, including mutations through DS/map
aliases. All six fixtures export the original 64-entry map drop cycle with semantic
names. A changed cycle becomes independent immutable map data for that level;
an identical cycle retains live shared DS reads, including mutations from event
bindings and physical aliases. Explicit recipe `group.drop` takes priority before
allocation. Normal authored enemies join before field overrides, large enemies
afterward; compatibility phases preserve original nonmembers and exceptions.
Zero drop leaves the slot index stale; a full 16-slot scan leaves it at 16.
Timeline drops still bind shared original DS cells in the build-time canonical
binder, so conflicting canonical fixture edits remain rejected there. Loose
version 9 events carry their own drop values; map-group-drop policy remains
separately profile-bound. No new table mirrors runtime DS.
Center-facing definitions write right-side defaults, then test live initialized
X as unsigned against the playfield center; equality selects the left-side fields.
The same policy explains launchers, burst firers and several crawlers without
generalizing their movement. Sprite omission preserves the actual stale value.
Ordinary pixel offsets apply after those fields/facing with word wrapping,
retaining saved coordinates. The plunger uses only a Y offset. Runner admission
instead tests the map column before any mutation, then applies its X offset and
copies shifted X before behavior fields. Saved Y remains inherited. Cruiser
placement first subtracts its distance, tests the result unsigned, then conditionally
changes direction and adds twice that distance; saved positions stay unchanged.
The hatch's retained group slot is a separate initialization policy: skip that
field write, while preserving the same ordered large-record initializer.

Two narrow level parameters describe upward-crawler sprite offsets and the jitter
shooter's masked random-word test. Importer compatibility requests live level
selection at the original phase: after initial crawler fields, or before jitter
map writes/allocation. A disabled test consumes no RNG; an enabled test consumes
one word even when the pool is full. These are proven data choices, not a generic
behavior or scripting abstraction. Pickup recipes reuse the original initializer;
the fuel compatibility rule returns the resulting sprite as the scan continuation.
Normal authored pickups keep the map offset.

Canonical fixtures now use version 6 for map drop data and explicit recipe drops. Version-1/2/3/4
definitions retain their earlier scopes, so an older explicit empty/partial list
does not disable actions that were procedural when that definition was written.

## Next boundaries to prove

1. The loose version 10 loader still requires graphics banks/plaque, terrain
   attributes, special paths and leader paths, map-spawn recipes/parameters, map-group-drop
   policy, departure, encounter, marching formation and boss data to match an
   original behavior profile.
2. Palette/HUD identity, level resource selection, chooser/progression behavior,
   unchecked seventh-level reads and remaining enemy parameters still need evidence
   and equivalence coverage.

Loose v10 is a narrow runtime slice, not a fully independent level or episode format.
Continue extracting one boundary at a time, retaining unique procedures and the
canonical live-data path for comparison.

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
complete independent definitions are not yet loaded. The loose-content test path
loads map, restart, music and ordinary waypoints at startup without adding a seventh original slot.

Remaining work toward this endpoint:

1. Remaining independent resource and gameplay sections, profile-equality
   boundaries and level-dependent presentation data.
2. Separate level identity from episode position and introduce episode selection
   and progression without changing the DOS/oracle coordinator.
3. Extend validated runtime loading from the v9 subset to complete level and
   episode files, including custom resource references. Shared original data must
   not make an edit to one custom level alter another.
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
