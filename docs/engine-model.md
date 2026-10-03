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

The native `LevelDef` skeleton is a resource view: map, sprite bank, block bank and
plaque. Its binding references point at the original DS table slots, not copied
resource pointers. Reading each slot at the original use point preserves mutations
and the ordering of loader callbacks. No gameplay state is shadowed. Out-of-range
word indices retain the original, independently wrapped table arithmetic.

Canonical resource-only `.lvl` fixtures are generated from a freshly built, exact
oracle and checked against the native view. They are regression evidence for this
slice, not a claim that six complete levels already load from external files.
The DOS resource coordinator remains unchanged. A later extraction can replace
native bindings with external definition data after proving its initialization
and lifetime rules.

## Next boundaries to prove

1. Ordered tile-attribute patches, including duplicate writes and shared lists.
2. Checkpoints with script positions expressed as event boundaries, preserving
   unsigned threshold selection and the unused fourth-word overread.
3. Formation events and member definitions, with cursor advance before allocation,
   ordered members, optional marker clear and equality-only event triggering.
4. Distinct path and leader formats, preserving transition timing and signedness.
5. Map recipes, compared directly against every original cell handler before
   switching dispatch. Recipes must express mutation before allocation, retained
   cells, 2x2 writes, conditional groups and exceptional scan-cursor results.
6. Encounter descriptors retaining unique procedural implementations initially.

Only after those boundaries pass should the native game load full external levels
by default. Resource fixtures version the implemented slice; future sections must
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
