# Overkill level format: resource and terrain slice

Version 1 has two partial profiles. `level-bindings` describes resources and tile
attributes; the earlier `resource-bindings` profile remains accepted and retains
original terrain. Neither describes a complete playable level yet. Map contents,
objects, paths, formations, events, encounters and checkpoints await extraction.

The implemented `level-bindings` fields are (the example patch list is abbreviated):

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
  }
}
```

`id` is a lowercase semantic identifier. Resource names preserve source spelling
and are asset basenames; path separators and relative traversal are rejected.
Map/sprites/blocks use BIC resources, plaques use ENC. Unknown fields and profiles
are rejected so partially implemented gameplay sections cannot silently be ignored.
The resource-only profile has no `terrain` field. Schema validation checks structure
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
terrain patches in source order, including duplicates.
`--no-build` reuses an existing exact source-built oracle. `--output DIRECTORY`
exports elsewhere. `--check` compares existing files without overwriting them.
Serialization is deterministic. The six fixtures in `levels/original/` are consumed
by validation, native initialization and the binding/terrain regression.

The native build loads all six `levels/original/level*.lvl` files. A generic adapter
binds asset names to original DS filename identities and encodes semantic patches
into original storage. It writes only native initialization; the oracle and DOS
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
python tests/host/runtime.py
```

`python tools/difftest.py levels` is the focused DOS coordinator check during
this extraction; the complete suite remains the DOS behavioral gate.

The LevelDef test checks canonical import against the whole initial DS image,
edited binding boundaries, rejected imports, all word-index binding arithmetic,
complete tile initialization against ASM (including wrapping/aliases), and coordinator state,
ordered resource/decoder requests, map writes and meaningful registers. Service
substitutions match at the native and ASM boundaries; they do not establish decoder
pixel parity. Existing graphics/native suites remain responsible for that.
