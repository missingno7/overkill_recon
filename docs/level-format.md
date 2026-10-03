# Overkill level format: resources, terrain, checkpoints and timelines

Version 1 has two partial profiles. `level-bindings` describes resources, tile
attributes and optional checkpoints, timelines and formations; the earlier `resource-bindings` profile remains
accepted and retains original terrain/checkpoints. Neither describes a complete
playable level yet. Map contents, map spawn recipes, paths and encounters
await extraction.

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
Letter suffixes distinguish existing presets whose parameter/path data is still
pending extraction. Sizes are `8x8`, `16x16` or `32x32`; layers are `under_terrain`
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
member ordering, explicit group drops and marker compatibility properties.
`--no-build` reuses an existing exact source-built oracle. `--output DIRECTORY`
exports elsewhere. `--check` compares existing files without overwriting them.
Serialization is deterministic. The six fixtures in `levels/original/` are consumed
by validation, native initialization and the binding/terrain/checkpoint regression.

The native build loads all six `levels/original/level*.lvl` files. A generic adapter
binds asset names to original DS filename identities, encodes semantic patches and
encodes formation/timeline records and resolves checkpoint rows/event indices into
original storage. It writes only native
initialization; the oracle and DOS
hybrid stay independent. Canonical originals reproduce the entire initial DS image,
including ignored neighboring bytes. Native `host/level_def.*` reads live bindings.

This is build-time structured loading. Runtime JSON loading and arbitrary custom
asset/storage allocation remain pending. The adapter derives capacities and shared
storage from the exact oracle; it rejects unbound filenames, oversized streams and
conflicting definitions for a shared stream (original levels 1 and 4). Shortened
streams retain ignored trailing bytes. These limits belong to the current legacy
layout adapter, not the eventual editor model. `level_bindings.py --levels DIRECTORY`
checks alternate definitions against them. Public JSON exposes no REC_TYPE or DS
addresses; no host pointers or copied game records are introduced.

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
