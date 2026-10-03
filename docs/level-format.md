# Overkill level format: resource slice

Version 1 currently implements only the `resource-bindings` profile. It is an
inspectable JSON `.lvl` file describing four existing asset choices. It is not
yet a standalone playable-level format. Full terrain, object, path, formation,
event, encounter and checkpoint sections await extraction and equivalence tests.

Each file has exactly these fields:

```json
{
  "format": "overkill-level",
  "version": 1,
  "profile": "resource-bindings",
  "id": "original-level-0",
  "resources": {
    "map": "LEV0MAP.BIC",
    "sprites": "G0.BIC",
    "blocks": "LEV0BLX.BIC",
    "plaque": "plaq5.enc"
  }
}
```

`id` is a lowercase semantic identifier. Resource names preserve source spelling
and are asset basenames; path separators and relative traversal are rejected.
Map/sprites/blocks use BIC resources, plaques use ENC. Unknown fields and profiles
are rejected so partially implemented gameplay sections cannot silently be ignored.
Validation establishes structure only; canonical checking additionally establishes
equivalence to the original resource bindings. It does not validate custom asset
contents or gameplay equivalence.

## Export and validation

```powershell
python tools/export_original_levels.py
python tools/export_original_levels.py --check
python tools/level_format.py
python tests/host/level_def.py --no-build
```

The exporter builds the exact source oracle, verifies its pinned program hash and
reads the named DS tables and ASCIIZ filenames without executing original code.
`--no-build` reuses an existing exact source-built oracle. `--output DIRECTORY`
exports elsewhere. `--check` compares existing files without overwriting them.
Serialization is deterministic. The six fixtures in `levels/original/` are consumed
by validation and the native resource-view regression.

The runtime currently obtains this resource slice through `host/level_def.*`, a
view over the original state. It does not read `.lvl` JSON at runtime yet. Native
bindings are DS filename-table slot references: only the adapter knows offsets.
The public fixture contains names and exposes no raw REC_TYPE or DS addresses.
Future external loading must preserve cache filename identity, per-file flags and
state initialization, rather than storing host pointers in original records.

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
legacy bindings, not a proposed public editing API. A modern resource definition
must eventually compile/bind to equivalent filename identities without changing
the cache and callback contracts.

## Regression gates

```powershell
python tools/verify.py
python tools/hybrid.py
python tools/difftest.py
python tools/host.py
python tests/host/level_def.py --no-build
python tests/host/checkpoints.py --no-build
python tests/host/runtime.py
```

The LevelDef test checks every word index and live resource reads, canonical
fixtures, rejected malformed definitions, and native-vs-ASM coordinator state,
ordered resource/decoder requests, map writes and meaningful registers. Service
substitutions match at the native and ASM boundaries; they do not establish decoder
pixel parity. Existing graphics/native suites remain responsible for that.
