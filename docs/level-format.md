# Overkill level format: current structured bindings

Version 2 has two partial profiles. `level-bindings` describes resources, tile
attributes and optional checkpoints, timelines, formations, paths, map recipes and
mothership departure data;
the earlier `resource-bindings` profile remains accepted and retains original
terrain/checkpoints. Neither describes a complete
playable level yet. Map contents, remaining spawn recipes and encounter definitions
await extraction.
Version 1 remains accepted with its original narrower map-recipe scope. Version 2
adds grouped/no-spawn recipes and expands the converted cells. This version boundary
keeps an older explicit recipe list from silently disabling newly converted cells.
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
represents all original level-1 actions and fixed-field, clear-only and group-hole
cases in levels 0/3/4/5. Center-facing, conditional-sprite, RNG-dependent, positional
and pickup cases, plus level 2's actions, retain their
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

### Original group compatibility

Original grouped ranges prepare a group slot even for cells that produce no
members. The importer-generated property
`"compatibility": {"map_group": "allocate_only"}` preserves that preparation
without joining. `join_before_fields` prepares and joins after record initialization
but before type/sprite/direction overrides; `join_after_fields` joins after those
overrides. Ordinary grouped spawns use the former; the two large grouped spawns use
the latter. These phases are source-supported ordering, not arbitrary instructions.
Non-spawning recipes permit only `allocate_only`.
Grouped compatibility and `spawn: "none"` require version 2. Version 1 retains only
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
rules, center-facing, RNG-dependent, pickup and other recipe primitives remain pending.

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
Map recipe slices are generated from explicitly curated equivalent data;
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
