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
attribute patches. References point at original DS pointer-table slots, not cached
targets. Reading each slot at the original use point preserves mutations and loader
callback ordering. No gameplay state is shadowed. Out-of-range word indices retain
the original, independently wrapped table arithmetic.

Canonical `.lvl` fixtures are generated from a freshly built exact oracle. The
native build consumes their resource and terrain definitions through a generic
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

## Next boundaries to prove

1. Checkpoints with script positions expressed as event boundaries, preserving
   unsigned threshold selection and the unused fourth-word overread.
2. Formation events and member definitions, with cursor advance before allocation,
   ordered members, optional marker clear and equality-only event triggering.
3. Distinct path and leader formats, preserving transition timing and signedness.
4. Map recipes, compared directly against every original cell handler before
   switching dispatch. Recipes must express mutation before allocation, retained
   cells, 2x2 writes, conditional groups and exceptional scan-cursor results.
5. Encounter descriptors retaining unique procedural implementations initially.

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
