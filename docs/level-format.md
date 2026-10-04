# Overkill level format: current structured bindings

Version 4 has two partial profiles. `level-bindings` describes resources, tile
attributes and optional checkpoints, timelines, formations, paths, map recipes and
mothership departure data, encounter descriptors, marching-formation timing and
segmented-boss member data;
the earlier `resource-bindings` profile remains accepted and retains original
terrain/checkpoints. Neither describes a complete
playable level yet. Independent map storage, remaining spawn recipes and enemy/member parameters
await extraction.
Versions 1, 2 and 3 remain accepted with their original map-recipe scopes. Version 2
adds grouped/no-spawn recipes; version 3 adds center-facing choices and pixel offsets.
Version 4 adds side gates, runner/cruiser placement and retained-slot large initialization.
Each version boundary keeps an older explicit recipe list from silently disabling newly converted cells.
Omitting map recipes still retains originals under either version.

An earlier partial `level-bindings` definition remains valid (the patch list below
is abbreviated). Canonical files also contain the timeline/formation sections
described below:

```json
{
  "format": "overkill-level",
  "version": 1,
  "profile": "level-bindings",
  "id": "original-level-0",
  "resources": {
    "map": "LEV0MAP.BIC",
    "sprites": "G0.BIC",
    "blocks": "LEV0BLX.BIC",
    "plaque": "plaq5.enc"
  },
  "terrain": {
    "default": "wall",
    "attribute_patches": [
      { "tile": 1, "attribute": "open" }
    ]
  },
  "checkpoints": [
    { "map_row": 12, "script_clock": 273, "resume_event": 0 },
    { "map_row": 75, "script_clock": 210, "resume_event": 1 },
    { "map_row": 144, "script_clock": 141, "resume_event": 4 },
    { "map_row": 208, "script_clock": 77, "resume_event": 10 }
  ]
}
```

`id` is a lowercase semantic identifier. Resource names preserve source spelling
and are asset basenames; path separators and relative traversal are rejected.
Map/sprites/blocks use BIC resources, plaques use ENC. Unknown fields and profiles
are rejected so partially implemented gameplay sections cannot silently be ignored.
The resource-only profile has no `terrain` or `checkpoints` field. Earlier
`level-bindings` files without checkpoints retain their original checkpoint tables.
Schema validation checks structure
and property names; native binding additionally checks storage and asset identities.
Canonical checking establishes equivalence to the original definitions. None of
these alone establishes gameplay parity for edits.

## Tile attributes

| Public name | Observed meaning | Internal legacy value |
|---|---|---|
| `open` | Movement and player shots pass | 0 |
| `wall` | Blocks movement and player shots | 1 |
| `shot_permeable_wall` | Blocks movement and spawn-column scanning; player-shot terrain checks pass | 2 |

Initialization fills all 256 entries with `wall`, then applies patches in list
order. Duplicate tile IDs are retained; the last applied value wins. Tile IDs are
0..254 in this profile: tile 255 terminates the legacy stream before a value is read,
so it stays `wall`. Demo initialization clears attributes separately as runtime
policy. These are gameplay attributes, not drawing properties or enemy kinds.

Native live streams retain unchecked raw attributes and DS alias effects as
compatibility behavior. The initializer resets output before reading its binding,
then reads each pair before writing it. Prebuffering or reordering live patches
can change later reads. Arbitrary raw values are not public property names.

## Checkpoints

Each canonical definition has four ordered checkpoints. `map_row` names a row of
the 13-cell map, starting at zero; the adapter converts it to `MapScrollPos` bytes.
`script_clock` is the unsigned 16-bit countdown restored after scrolling back.
`resume_event` is a zero-based index of the next timeline event, not a byte offset.
The terminating event boundary is also a valid resume point. Import rejects indices
outside the existing script. Optional marker words make event byte lengths variable;
the adapter discovers boundaries from the source-built scripts rather than guessing
an eight-byte stride. When a timeline edit changes framing, checkpoint indices
resolve to the new event boundaries automatically.

The current binding requires four strictly increasing rows whose byte positions
fit a word; clock and event indices also fit unsigned words. This validates binding
structure, not arbitrary edited restart/encounter behavior. Clocks remain explicit
and independent of resume events. In particular, level 2's last checkpoint restores
clock 77 and resumes at event 42, whose trigger is 80. Equality-only script triggering
retains that original mismatch. Level 5's last two checkpoints resume at the same
event 7. Neither case is normalized.

Selection uses an unsigned comparison against the following checkpoint's row;
equality advances to the following checkpoint. The final checkpoint is unconditional.
The legacy reader writes each candidate's script cursor before reading its threshold,
and always reads four words. Its final record stores only three words: the fourth
read reaches neighboring data, and its result is ignored. The adapter preserves
those neighboring bytes; the native reader preserves the write/read order, including
live alias effects. These are internal compatibility semantics, not public fields.

## Timelines and formations

`timeline` and `formations` are optional together; omitting both retains original
definitions. A timeline is an ordered list of events; formations are a named object.
This excerpt shows one original event and its formation (the complete level has
more events):

```json
{
  "formations": {
    "sweep_leader_single_1": {
      "enemy": "sweep_leader",
      "size": "16x16",
      "layer": "over_terrain",
      "members": [{ "dx": 0, "dy": 0 }]
    }
  },
  "timeline": [
    {
      "clock": 272,
      "formation": "sweep_leader_single_1",
      "x": 192,
      "y": -16,
      "group": { "drop": "none" }
    }
  ]
}
```

Clock values are unsigned words below 65535, in non-increasing order. Origins and
member offsets are signed words; runtime addition wraps as before. Members are
ordered, with X then Y. Presets are semantic names mapped to the existing REC_TYPE
dispatcher in `tools/level_presets.py`; they do not replace or merge behaviors.
Letter suffixes distinguish existing behavior/path presets. Sizes are `8x8`,
`16x16` or `32x32`; layers are `under_terrain`
or `over_terrain`. Group drops are `none`, `upgrade`, `energy`, `smart_bomb` or `fuel`.
Member lists are nonempty: the original zero-count LOOP bug remains supported in
live compatibility streams, but is not a normal empty formation in public JSON.

An importer-generated `"compatibility": {"clear_event_marker": true}` on an event
retains its optional marker word. That word clears an otherwise-unused runtime
byte; it also changes event length and checkpoint cursor identities. It is not a
new gameplay action or scripting language.

Every consecutive event whose clock equals the current countdown executes in
source order. A missed trigger is not caught up. Each event advances its cursor
before allocation. A full pool consumes events without retry; partial formations
retain the members that fit. Drop `none` skips group allocation, and unavailable
groups retain the original ungrouped/stale-index behavior. Initialization, column
snapping, saved coordinates, hit points, leader setup and RNG use remain procedural
in the existing spawner. They are deliberately not configurable fields yet.

The adapter currently binds semantic formation names to original shared storage;
names are generated from the preset and observed member layout. An edit can change
that definition while retaining its binding name. Longer formations/timelines,
unknown binding names and inconsistent edits to shared formations fail explicitly.
Unused Formation48 is not exported as level content and remains untouched in DS.
Event drops still bind to the shared legacy drop table, also used by map spawning;
inconsistent drops for an aliased table cell fail. A consistent change affects all
uses of that cell, including map drops. These restrictions belong to the temporary
native layout adapter, not the future level/editor model.

## Paths and leader paths

`paths` and `leader_paths` are optional named objects. Omitted bindings retain the
original payloads, including shared-definition constraints. Canonical files contain
the dependencies of their formation presets and encounter director. Points use
signed 16-bit playfield coordinates, X then Y; the adapter subtracts 32 from Y
with word wrapping to match the existing readers. Formation offsets remain offsets.

```json
{
  "paths": {
    "path_follower_b": {
      "points": [{ "x": 96, "y": 64 }],
      "end": { "kind": "fly_off", "x": 96 }
    },
    "sweep_loop": {
      "points": [{ "x": 96, "y": 64 }],
      "end": { "kind": "jump", "path": "sweep_loop" }
    }
  },
  "leader_paths": {
    "sweep_leader": {
      "steps": [{ "target": { "x": 96, "y": 64 }, "follower": null }],
      "end": { "kind": "fly_off", "x": 96 }
    }
  }
}
```

This illustrates field shapes, not a complete original definition. `points` and
`steps` are nonempty ordered lists. Routes end with one of:

| Ending | Observed reader contract |
|---|---|
| `fly_off`, with signed `x` | Ordinary followers steer toward Y 30032; no terminator check or instant removal |
| `restart` | Boss/encounter readers reset their own cursor to the start |
| `jump`, with named `path` | Sweep reader follows an encoded target and resumes in the same call |
| `continue`, with named `path` | Sweep lead-in flows directly into adjacent sweep-loop storage |

Each original binding retains its reader's ending kind. Jump/continue targets must
exist in the same `paths` object and retain their original target binding. Restart/jump/
continue points cannot use Y 31: its encoding collides with the reader's control
marker. Ordinary fly-off paths have no such control-marker restriction, but retain
their original point count: a far target is not a checked terminator. Shortened
restart/jump routes preserve trailing bytes beyond their control marker. Longer
routes fail the current layout adapter.
The continued lead-in retains its original point count and adjacency.

Leader `steps` contain `target` only for `sway_leader` and `slot_hopper_leader`.
The other four leaders also require `follower`, a position or null. Null suppresses
spawning for `sweep_leader`, `sweeper_leader` and `march_leader`; those follower
positions cannot use Y 31. `bob_chase_leader` requires a position even when the source
pair is FFFF/FFFF: its unchecked reader spawns at that encoded position. The slot
hopper additionally requires an ordered `slots` list of positions. Five slot entries
are consumed per arrival even when all allocations fail.

The current adapter requires unchanged leader step/slot counts because their end
addresses synchronize existing follower handlers. These limits, original binding
names and shared storage restrictions are adapter constraints. Movement, arrival
timing, child types/HP/delays, RNG calls, allocation order and stale-field behavior
remain in the proven implementations. Public definitions expose no byte cursors.

Canonical level paths include the boss anchor and level-4 encounter route. The
demo and currently unreferenced Type4A route retain original DS data outside level
fixtures; their supported codecs do not assert original level reachability.

## Map spawn recipes

`map_spawns` is an optional list of unique tile-triggered recipes. It currently
represents all defined original level-1/level-2/level-3 actions, center-facing choices,
gated runners and cruiser placement, retained-cell hatches and directional lurkers,
plus fixed-field, clear-only and group-hole cases in levels 0/4/5.
Eight conditional-sprite, RNG-dependent and fuel-pickup cases retain their
existing handlers during migration. An empty list in a partially converted level
does not disable its unconverted spawns. Native binding rejects recipes outside
that level's converted scope; level 1 supports all byte-valued triggers.

```json
{
  "map_spawns": [
    {
      "tile": 4,
      "spawn": "enemy",
      "enemy": "climbing_walker_a",
      "map_writes": [{ "dx": 0, "dy": 0, "tile": 1 }]
    },
    {
      "tile": 172,
      "spawn": "enemy",
      "enemy": "volley_turret_left",
      "sprite": 137,
      "direction": "left",
      "map_writes": []
    }
  ]
}
```

`tile` is the input map byte (0..255), not an enemy type. `enemy` uses the semantic
preset registry. `spawn` selects one of two proven map initializers: `enemy` or
`large_enemy`. Both allocate in the original Pool A order and preserve unspecified
record fields. Ordinary enemies have 4 HP at `(MapCellX, 16)` and saved coordinates
copied from the caller; large enemies have 10 HP at `(MapCellX, 0)` and retain stale
saved coordinates. Both use draw pass 0. Large
initialization is distinct from changing an ordinary enemy's size.
`spawn: "none"` allocates no record and omits `enemy`, `sprite` and `direction`.
Its ordered map writes still occur; this represents clear-only cells and the real
level-3 hole that only prepares a group slot.

`map_writes` is an ordered list of relative cell positions, with signed word `dx`
and `dy` and byte `tile`. Offsets compile as `dy * 13 + dx`, with word wrapping.
An empty list keeps the cell; a write of tile 1 at `(0, 0)` clears it. Every write
occurs before record allocation, including when the pool is full. The original hatch
writes `(0,1)=38`, `(1,1)=39`, `(0,0)=40`, `(1,0)=41` in that order. Repeated writes
are preserved, and the native resolver keeps physical aliases into DS.

Optional `sprite` is an unsigned word index within the selected bank; optional
`direction` is one of the eight compass directions (`up`, `up_right`, `right`,
`down_right`, `down`, `down_left`, `left`, `up_left`). The evaluator writes type,
then sprite if specified, then direction if specified. Omission does not zero a
field: ordinary initialization leaves sprite stale and sets direction down;
large initialization leaves both stale before these overrides.

### Center-facing choices and pixel offsets

Version 3 adds `facing`, replacing the top-level sprite/direction overrides:

```json
{
  "tile": 196,
  "spawn": "enemy",
  "enemy": "animated_fire_burst_c",
  "map_writes": [{"dx": 0, "dy": 0, "tile": 1}],
  "facing": {
    "kind": "center",
    "right": {"sprite": 191, "direction": "left"},
    "at_or_left": {"sprite": 194, "direction": "right"}
  }
}
```

Each side requires a compass direction and optionally a sprite-bank index. The
evaluator writes the right-side defaults after initialization, then compares the
live record X to the fixed playfield center (96 pixels) as an unsigned word.
Equality takes `at_or_left`. Its supplied fields overwrite the defaults; omitted
sprite fields retain the actual previous sprite. This preserves the sprite-less
crawler and the crawler with the same sprite on both sides. The choice occurs
after map writes and allocation, so a map/DS alias changing `MapCellX` affects it.
It is a demonstrated spawn-placement rule, not a reusable enemy movement family.

Optional version-3 `position_offset` is a nonempty object with signed pixel `dx`
and/or `dy`. It adds X then Y after type/sprite/direction and facing, before any
`join_after_fields` membership, using word wrapping. It does not update saved
coordinates by default. The original level-2 plunger uses `{"dy": -6}` after
setting its type. Version-4 runner compatibility moves this stage earlier and
copies shifted X, as described below.

The importer-generated `compatibility.direction_before_type: true` retains the
sprite-less crawler's direction-before-type writes. It requires version-3 facing
and can accompany group preparation. This is an internal historical ordering
property; ordinary authored facing definitions use the shared field order above.

### Side gates, runner placement and retained-cell hatches

Version-4 `spawn_region` accepts `at_or_left_of_center` or `right_of_center`.
It tests the live map-column X as an unsigned word before group preparation,
map writes or allocation. Equality belongs to `at_or_left_of_center`; a rejected
recipe changes nothing. This is distinct from `facing`, which selects fields using
the initialized record X after map writes and allocation.

The two level-0 runners use signed `position_offset.dx` values -12/+12 and the
importer-generated compatibility flags `offset_before_fields: true` and
`save_spawn_x: true`. The first applies the offset after initialization/group join
but before behavior fields. The second copies shifted X into the legacy saved-X
field at that point; saved Y remains inherited from the caller. `save_spawn_x`
requires an ordinary enemy, an early offset and an explicit `dx`. Both flags are
version-4 properties with only `true` accepted. A map clear alias can change the
later spawn X without changing the side which already admitted the runner.

The cruiser uses the distinct placement rule:

```json
{
  "placement": {
    "kind": "outward_from_center",
    "distance": 16,
    "right_direction": "down_left"
  }
}
```

It requires a top-level default direction (`down_right` in the original), and
excludes `facing` and `position_offset`. Distance is an integer 0..32767 pixels.
After behavior fields, subtract distance from record X with word wrapping. Compare
that shifted X unsigned to 96: at or above center, write `right_direction`, then
add twice the distance with word wrapping. Saved coordinates stay unchanged.
This preserves the original boundary at input X=112 and its unusual wrap at X=0;
comparing the original coordinate or using signed arithmetic would change it.
The cruiser joins its group before these fields/position changes.

The retained-cell hatch uses `spawn: "large_enemy"`, empty `map_writes` and
`compatibility.preserve_slot_index: true`. Unlike ordinary large initialization,
it skips the final write of FFFF to the group-slot field. It neither restores a
previously overwritten value nor copies a record: the original field remains
stale throughout. Kind is written before reading live `MapCellX`; saved positions
and other unspecified fields remain stale. The flag requires version 4 and large
initialization. Both original levels 2 and 5 have this recipe, with no group setup.
Joining a group would overwrite the retained slot and is rejected with this flag;
preparation without joining remains allowed.
The four level-5 lurkers need only the existing ordinary initializer and fixed
sprite/direction fields; their directions select their later alignment behaviors.

### Original group compatibility

Original grouped ranges prepare a group slot even for cells that produce no
members. The importer-generated property
`"compatibility": {"map_group": "allocate_only"}` preserves that preparation
without joining. `join_before_fields` prepares and joins after record initialization
but before type/sprite/direction overrides; `join_after_fields` joins after those
overrides. Ordinary grouped spawns use the former; the two large grouped spawns use
the latter. These phases are source-supported ordering, not arbitrary instructions.
Non-spawning recipes permit only `allocate_only`.
Grouped compatibility and `spawn: "none"` require version 2 or later. Version 1 retains only
level 1's complete basic recipe model and the original shared turret/hatch scope
in levels 4/5; all its other cells continue through their established handlers.

Preparation reads the live `GroupDropKinds[map_offset & 63]` and calls the existing
allocator before map writes. This temporary adapter retains the shared original
drop table and its aliases with timeline drops; it does not expose the masked index
as a normal editing property. Extracting complete map drop rules is still pending.
Without a drop or available slot, the existing globals retain their original stale
or exhausted values. Record exhaustion prevents joining, but still consumes map
writes and preparation. Allocation-only recipes do not claim or rewrite group bytes.
Joining reads live group/drop globals after initialization and map mutation; a DS
alias can change them, so the evaluator must not cache them during preparation.

For example, the level-3 no-spawn hole is represented by:

```json
{
  "tile": 223,
  "spawn": "none",
  "map_writes": [],
  "compatibility": { "map_group": "allocate_only" }
}
```

Level 5's walker cells return before the original grouped range, despite falling
within its numeric bounds; their recipes have no group compatibility property.
The past-table bytes excluded by the ASM test precondition retain their existing
native handling and are not exported as playable recipes.

Omitting `map_spawns` keeps original recipes. An explicit list replaces the covered
slice; removing an entry disables that trigger rather than falling back to its old
switch case. Coverage is internal migration metadata, not a permanent original-game
path. The exporter derives this small slice from curated equivalents of maintained
C handlers; canonical execution is independently checked against ASM. Full map drop
rules, live level-dependent sprite selection, RNG-dependent grouping and fuel
pickup continuation remain pending.

## Mothership departure

The optional `departure` section describes the geometry used by the existing
mothership sequence. Every canonical original contains it. Its fields are:

| Field | Meaning and current binding limits |
|---|---|
| `kind` | `mothership`, the original docking/refill behavior |
| `terrain_rows` | Five ordered rows of thirteen byte-valued tiles, installed at the original map-tail position |
| `animated_parts` | Four ordered objects with signed playfield `x`, `y` and unsigned sprite-bank `sprite` |
| `waypoints.approach` | Signed playfield `x`, `y` for the first autopilot target |
| `waypoints.dock` | Signed playfield `x`, `y` for the second autopilot target |

These are actual playfield positions: unlike follower path encoding, departure
coordinates have no added 32-pixel Y offset. The fixed counts come from the shared
original sequence and are explicit adapter limits, not an arbitrary object schema.
Sprite values remain bank indices; no public REC_TYPE values are needed.

`tools/level_departure.py` derives the canonical values directly from
`LevelEndMapRows`, `Type53SpawnTable` and `AutopilotWaypointA/B`. The native build
generates component references consumed by `host/level_departure.c` at the existing
map-load, terminal-spawn and autopilot use points. Canonical components retain
their live DS table references, so ordered map aliases and waypoint/table mutations
still behave like the oracle. Changed components use independent immutable data
for that level; editing one departure does not patch a shared table or another
level. This source-reference distinction is internal migration metadata.
Omitting the section preserves original departure data in earlier partial profiles.

The terminal spawner advances its part cursor only after successful allocation.
Draw pass, flash timer and hit points remain stale. The player state machine still
redispatches phases in the same call, and its extra ship-record allocation still
has the original unchecked full-pool write. Phase counters and records stay in DS.
Terminal/intro map positions, the extra record's preset, refill rules, common ship
resources and music policy remain shared procedural/default content pending further
extraction. This section alone does not make the whole level self-contained.

## Combat encounter director

The optional `encounter` section selects existing combat director procedures.
Every canonical original contains one. It is distinct from the first timeline
event's opening ambush and the mothership departure. For example, level 1 has:

```json
{
  "encounter": {
    "kind": "fallers_then_burster",
    "director_destructible": false,
    "fallers": {
      "hit_points": "invulnerable",
      "variant": "record_tick",
      "motion": "animated"
    },
    "fallers_until_tick": 200,
    "burster_at_tick": 240,
    "burster": { "hit_points": 20, "sprite": 113, "x": 96 }
  }
}
```

All kinds require `director_destructible` and the three `fallers` policies. The
choice describes this director even if a particular procedure never spawns fallers:
faller updates and the spawning helper independently consult the current level's
policies. No runtime counter or cursor is stored here.

| `kind` | Additional fields | Existing procedure |
|---|---|---|
| `segmented_boss` | None | Wait for the director to be the only enemy, then assemble the segmented boss |
| `invader_formation` | `fallers_until_tick`, `invaders_at_tick`, optional `slots` | Fallers, pause, then invader slots |
| `leader_path` | None | The existing encounter-leader path reader |
| `fallers_then_burster` | `fallers_until_tick`, `burster_at_tick`, `burster` | Fallers, pause, then convert the director into the burster |

Thresholds are unsigned words in `EncounterTicks` units (one increment every four
frame-counter updates). Fallers run while the clock is strictly below their end;
the next phase starts at or above its threshold. Followup cannot precede the
faller end. `burster.hit_points` and `sprite` are unsigned words, and `x` is a
signed playfield word. Sprite is a bank index. The original HP calculation is
performed by the exporter; runtime content has the explicit result.

Faller `hit_points` is an integer 0..65534, `invulnerable` (the original FFFF word),
or `spawn_default` (leave the quiet spawner's HP). `variant` is `preserve` (leave
the record field, including stale state) or `record_tick` (assign the old counter's
low two bits and increment it). `motion` is `animated`, `alternate_animated`, or
`aimed_drift`. These name the existing two animation/movement table readers and
aimed conversion, respectively; they do not merge their behaviors.

| Original level | Kind | Faller HP / variant / motion | Phase thresholds | Burster HP |
|---|---|---|---|---|
| 0 | `segmented_boss` | default / preserve / animated | Existing boss condition | — |
| 1 | `fallers_then_burster` | invulnerable / record_tick / animated | 200, 240 | 20 |
| 2 | `fallers_then_burster` | 1 / preserve / aimed_drift | 200, 240 | 30 |
| 3 | `invader_formation` | invulnerable / record_tick / alternate_animated | 50, 90 | — |
| 4 | `leader_path` | default / preserve / animated | Existing path | — |
| 5 | `fallers_then_burster` | invulnerable / record_tick / alternate_animated | 200, 240 | 60 |

Only level 4's original director is destructible. Faller allocation and column
assignment precede HP/variant policy evaluation; failed allocation changes neither
column nor variant counter. Director conversion writes type and sprite before
rereading live identity for HP. That order matters when records alias state.
Unchecked animation indices, shared live tables, boss failure cleanup, invader
cursor advancement and RNG order remain the original engine behavior.

`tools/level_encounter.py` contains small curated equivalents of maintained C/ASM
choices, consumed by export, validation and native generation. Omitting this section
retains the original slot's rules in older partial profiles. Native selection for
out-of-range word identities also retains original fallback arithmetic, an internal
migration contract rather than a public level identity. These descriptors currently
refer to the existing boss, invader and leader implementations/stream bindings;
complete dependency validation and independent path storage remain pending.

`invader_formation` may include `slots`, an ordered list of 24 signed playfield
`{"x": ..., "y": ...}` points. Level 3 exports its actual three-row target list
from `InvaderFormation`; its first target is `{"x": 168, "y": 112}`. The adapter
subtracts 32 from Y, just like the existing path codecs. These are target positions;
enemies still spawn at the director and steer to them using the existing behavior.
This list is distinct from opening-leader follower positions and slot-hopper slots.
Omission retains the original table. The fixed count preserves existing cursor,
reset and exact end identities during migration.

Canonical coordinates use live DS; edited lists use independent immutable level
data. The saved cursor is captured before allocation, but Y and X are read only
after it succeeds, with the saved-Y write in between. Only success advances the
live cursor. Failed allocation still resets the frames-since-spawn clock. Odd or
out-of-range compatibility cursors are not clamped: authored-table bytes are used
within its original span, and reads beyond it retain neighboring DS/physical bytes.
A word starting at FFFF reads the next physical byte before the next offset wraps.

## Opening march clock

The optional `marching_formation` section describes the level-5 opening's shared
march clock, separate from the level-3 invader director and its slots:

```json
{
  "marching_formation": {
    "enabled": true,
    "step_delays": [
      { "minimum_members": 17, "frames": 10 },
      { "minimum_members": 9, "frames": 6 },
      { "minimum_members": 5, "frames": 4 },
      { "minimum_members": 0, "frames": 1 }
    ],
    "fire_delays": [
      { "minimum_members": 17, "frames": 120 },
      { "minimum_members": 9, "frames": 100 },
      { "minimum_members": 5, "frames": 80 },
      { "minimum_members": 3, "frames": 60 },
      { "minimum_members": 0, "frames": 40 }
    ]
  }
}
```

All six canonical definitions explicitly supply these tiers; only level 5 enables
the clock. Each nonempty tier list has strictly descending unsigned-word minimum
member counts, ending at zero. `frames` is a byte, including zero. The first tier
whose minimum is at or below the live unsigned encounter count supplies the reload.
Step and fire lists stay separate because the demonstrated thresholds differ.
Omission retains original partial-profile behavior. Unknown word identities retain
disabled marching and original tiers, independently of edits to any authored slot.

`UpdateAllRecords` runs these clocks before its reverse record pass; ordinary
frame-counter updates do not drive them. A zero step delay stays zero and increments
the byte step pulse every pass; a zero fire delay decrements to 255. Expiry increments
the respective byte pulse, including wrap to zero. A non-expiring clock clears its
pulse. Any pending edge count reverses the horizontal step once and enables that
pass's drop. The first eligible marcher consumes the fire pulse, so record order
still matters. These are engine semantics, not additional JSON switches.
Leader setup still initializes state for all leader kinds. Initial step magnitude,
edge coordinates, drop distance and member/dive behavior remain procedural defaults.
Type80 still uses the march-leader end cursor; enabling this clock alone does not
make another opening a complete march encounter.

## Segmented boss

The optional `boss` section describes the original unique four-part boss. It does
not replace its setup, movement, combat or linked destruction procedures.
Canonical level 0 includes this section; omission retains the original parameters
for older partial definitions. Validation requires its `segmented_boss` director;
the existing `boss_anchor` path binding remains a gameplay dependency.

```json
{
  "boss": {
    "kind": "segmented",
    "hit_points": 200,
    "parts": {
      "anchor": {"sprite": 32, "spawn_position": {"x": 0, "y": 0}, "offset": {"dx": 0, "dy": 0}},
      "upper_right": {"sprite": 33, "spawn_position": {"x": 32, "y": 0}, "offset": {"dx": 32, "dy": 0}},
      "core": {"sprite": 34, "spawn_position": {"x": 0, "y": 0}, "offset": {"dx": 0, "dy": 32}},
      "lower_right": {"sprite": 35, "spawn_position": {"x": 32, "y": 0}, "offset": {"dx": 32, "dy": 32}}
    }
  }
}
```

All four roles are required. Health and sprite indices are unsigned words;
spawn coordinates and offsets are signed words. Spawn positions are the initial
record values, before scrolling. Offsets describe later placement relative to the
moving boss anchor; they are not interchangeable with those initial values. Each
placement adds Y, clamps negative signed Y to zero, then adds X without clamping.
The core fires before these placement reads. Word arithmetic and mutation order
remain engine semantics.

Construction converts the director to the core, then allocates anchor, upper-right
and lower-right records in that order. Side-part X is initially zero and written
again after type/sprite assignment. Other stale fields retain their existing rules.
Allocation failure runs the original reverse smart-bomb pass and linked explosion
sequence, including zero, repeated or stale pointers; it is not rollback. The first
destroyed initialized part loses its HP, while linked parts already converted to
explosions retain theirs. Damage sharing, flash propagation, firing, movement speed,
path resets and destruction stay procedural because this is one unique behavior.

`tools/level_boss.py` extracts geometry from `BossPartOffsets` and curates the small
setup constants from `EncounterSegBossLevel`/`InitSegBossPartRecord`. Canonical
geometry stays live in DS, preserving aliases and writes between reads. Authored
geometry has independent immutable per-level storage and never patches that table.
Setup parameters use per-level descriptors; unknown identities retain original
parameters independently of edits to level 0. Role-to-handler IDs remain private.

## Export and validation

```powershell
python tools/export_original_levels.py
python tools/export_original_levels.py --check
python tools/level_format.py
python tools/level_bindings.py --no-build
python tools/host.py
python tests/host/level_def.py --no-build
```

The exporter builds the exact source oracle, verifies its pinned program hash and
reads named DS tables and filenames without executing original code. It exports
terrain patches in source order, including duplicates, and resolves checkpoint
cursors to event indices. It rejects unmodeled independent selection thresholds or
checkpoint positions/cursors that are not row/event boundaries.
It also reads all used formations and timeline events, including semantic presets,
member ordering, explicit group drops and marker compatibility properties. It derives
used path/leader streams, including their distinct endings and follower suppression.
Map recipe slices and encounter scalar policies are generated from explicitly curated equivalent data;
large opaque tables are not transcribed.
`--no-build` reuses an existing exact source-built oracle. `--output DIRECTORY`
exports elsewhere. `--check` compares existing files without overwriting them.
Serialization is deterministic. The six fixtures in `levels/original/` are consumed
by validation, native initialization and the binding/terrain/checkpoint regression.

The native build loads all six `levels/original/level*.lvl` files. A generic adapter
binds asset names to original DS filename identities, encodes semantic patches and
encodes formation/timeline/path/leader records and resolves checkpoint rows/event indices into
original storage. It writes only native
initialization; the oracle and DOS
hybrid stay independent. Canonical originals reproduce the entire initial DS image,
including ignored neighboring bytes. Native `host/level_def.*` reads live bindings.
Map recipes have no original DS table: the native build generates immutable C data
from their JSON, consumed by `host/map_recipes.c`. The same evaluator handles edited
recipes without rewriting enemy behavior or introducing copied runtime records.

This is build-time structured loading. Runtime JSON loading and arbitrary custom
asset/storage allocation remain pending. The adapter derives capacities and shared
storage from the exact oracle; it rejects unbound filenames, oversized streams and
conflicting definitions for a shared stream (original levels 1 and 4). Shortened
streams retain ignored trailing bytes. These limits belong to the current legacy
layout adapter, not the eventual editor model. `level_bindings.py --levels DIRECTORY`
checks alternate definitions against them. Public JSON exposes no REC_TYPE or DS
addresses or host pointers; game records remain in the existing runtime state.

## Behavioral invariants of the binding

Map selection occurs after resetting all six script cursors. Retries retain the
selected filename; attribute initialization reads the current level index after
I/O completes. Graphics capture the
sprite filename into `PendingSpriteFile`, load blocks first, then read that pending
word for sprites. Plaque selection rereads both `LevelIndex` and its table entry
after these decodes. ENC/mask/record-image flags, retry loops, destination segments,
loader mailboxes and key-clear ES results are unchanged.

The resource view deliberately preserves independently wrapped 16-bit table
indices, live entry mutations and adjacent-table accesses. These are internal
legacy bindings, not a proposed public editing API. The structured resource
adapter retains filename identities and the cache and callback contracts; future
runtime loading must preserve them too.

## Regression gates

```powershell
python tools/verify.py
python tools/hybrid.py
python tools/difftest.py
python tools/host.py
python tests/host/level_def.py --no-build
python tests/host/terrain.py --no-build
python tests/host/checkpoints.py --no-build
python tests/host/timeline.py --no-build
python tests/host/path_data.py --no-build
python tests/host/map_recipes.py --no-build
python tests/host/departure.py --no-build
python tests/host/encounter_data.py --no-build
python tests/host/invader_data.py --no-build
python tests/host/boss_data.py --no-build
python tests/host/runtime.py
```

`python tools/difftest.py levels` is the focused DOS coordinator check during
this extraction; the complete suite remains the DOS behavioral gate.

The LevelDef test checks canonical import against the whole initial DS image,
edited binding boundaries, rejected imports, all word-index binding arithmetic,
complete tile initialization and checkpoint selection against ASM (including
wrapping/aliases), and coordinator state,
ordered resource/decoder requests, map writes and meaningful registers. Service
substitutions match at the native and ASM boundaries; they do not establish decoder
pixel parity. Existing graphics/native suites remain responsible for that.
The checkpoint suite compares full physical memory after restart for all original
entries, wrapped level aliases and a structured checkpoint edit, including restored
clocks/cursors, map reload/reset and scroll-to-row behavior.
The timeline suite exercises all 138 original events and 52 referenced formations
with free, partial and full pools. It compares complete DS/physical memory, group
state, saved/stale record fields and cursor order, and tests edited definitions,
marker-driven checkpoint relocation, equality boundaries and zero-count streams.
The path-data suite compares every original waypoint and leader step, arrivals,
endings and full/partial allocation outcomes. Full physical memory comparisons
include CS encounter cursors, RNG and stale record fields. Edited shared routes,
leader targets/follower slots and boss points also run through the existing readers.
The map-recipe suite checks all safe cell bytes across six levels against ASM and
the retained C handlers, then stresses the converted actions with full/free pools,
stale fields, record/physical aliases and wrapped writes. Mixed rows run through the
real scanner. A separately generated edited table uses the same evaluator and shared
core initializers to test recipe replacement/removal, authored fields and write order.
Grouped cases additionally test all original drop-cycle offsets, zero/nonzero/raw
drops, exhausted/partially free groups, allocation-only holes and clear-only cells,
and a live drop-word alias mutated between preparation and joining.
Center-facing comparisons exercise unsigned equality/neighbor/high-word boundaries,
stale sprites, full pools, caller aliases and a map clear changing X from the right
to the left side. Authored choices and signed offsets use explicitly checked oracle
output words while every other DS/physical byte, saved coordinate and RNG state
must agree. Version-1/2/3 coverage remains fixed; older empty lists do not intercept
later triggers. Runner comparisons include wrong-side no-mutation checks, pre-clear
selection with post-clear X aliases, saved-X copies and wrap. Cruiser tests exercise
the shifted equality boundary, group exhaustion and authored distance changes.
Hatch tests check retained slot values and an allocation whose kind write aliases
the subsequent MapCellX read. Authored changes remain local to their level.
Mixed rows exercise all six handlers.
The departure suite compares terminal map writes, animated-part allocation and
autopilot/refill transitions for all six originals against ASM. An alternate build
of the production coordinators proves that authored departure components reach
gameplay independently for each level, without changing shared DS tables.
For authored cases, only the oracle's source tables are edited to supply equivalent
content. Native DS retains the canonical tables. Comparisons remove those test-only
source edits from the oracle snapshot while retaining all gameplay effects; map
and record results must agree. Canonical alias cases retain the complete live-table
comparison. The suite also checks malformed data, omitted-section compatibility,
stale fields, full/partial allocation and same-call approach-to-dock transitions.
The encounter suite compares complete DS and physical memory for all four original
director procedures, faller spawn/movement and destruction, including phase
boundaries, allocation failure, column/variant wrap and live identity aliases.
An alternate descriptor build verifies permutations without changing DS source
tables. Authored scalar tests use the equivalent original clock/procedure and
declare only the changed input clock and expected authored output words; all other
bytes must agree. This checks edited timing, health, variant/motion, sprite/X and
damage policies without claiming parity for complete level permutations yet.
The invader-data suite compares all slots, allocation exhaustion, exact ending,
live table/cursor aliases, odd/unchecked cursor reads and authored slot isolation.
March comparisons cover all tier boundaries, zero/expiry and byte wrap, edge/drop
latches, ordered member fire consumption and march policy permutations. Authored
tiers use explicit expected reload bytes while every other state/memory byte must
match the equivalent original pass. Canonical initialization remains byte-identical.
The boss-data suite compares full DS/physical memory for construction, partial/full
allocation, stale and repeated links, release, placement, core firing, signed/word
boundaries and live geometry aliases. Alternate builds move boss content between
slots and edit health, sprites, initial positions and offsets. Authored setup uses
explicit expected output words, including failed-setup HP preservation; placement
uses equivalent oracle source geometry with only those static fixture inputs removed
from the final comparison. Other identities retain original data.
