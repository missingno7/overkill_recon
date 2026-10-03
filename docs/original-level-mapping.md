# Original-level inventory and extraction status

Initial audit baseline: commit `9377201`, native SDL3 and shared DOS C. The inventory
below identifies sources and semantic boundaries; the ASM/C source remains the
authority for numeric values. Re-run `rg -n LevelIndex c host -g '*.c'` when extending
this inventory. No complete external gameplay representation is claimed yet.

## Inventory

| Concept | Classification | Original evidence and current consumer | Status |
|---|---|---|---|
| Terrain map | Pure data / resource metadata | `DATA.ASM: LevelMapFiles`; `levels.c: load_level_map`; map consumed by terrain, spawning, scrolling and checkpoint reset | Resource binding extracted; map contents unchanged |
| Sprite/block banks | Resource metadata | `LevelBankFiles`; `load_level_graphics` | Native resource view; blocks load before sprites despite opposite table order |
| Plaque | Resource metadata | `PlaqueFiles`; `load_level_graphics` | Native resource view; plaque numbering does not equal level numbering |
| Common graphics | Resource metadata shared by all levels | `load_common_graphics`, adapter decoders in `host/graphics_decode.c` | Remains shared; not duplicated in level fixtures |
| Tile collision properties | Pure data | `AttributePatchPointers`, `AttributePatches*`, `ByteAttributeTable`; `levels.c`, `terrain.c`, shots/pods | Extracted to semantic ordered patches in `.lvl`; native build binds them into existing storage; levels 1/4 remain shared |
| Fixed start/end map rows | Pure shared data / mutation rule | `LevelEndMapRows`, `initialize_level_byte_attributes` | Last five rows extracted into departure data; first two forced rows/placement positions remain shared rules |
| Opening ambush | Shared encounter behavior + per-level leader/event/path data | First `LevelScript0..5` event at clock 272, `Formation39..44`, `start_leader_script`, `type13_formation_leader` | Opening events/formations/routes extracted; shared scroll-hold, release delay and early-stage weapon/pod/render policies remain implicit |
| Mothership departure | Shared sequence data + procedural state machine | `LevelEndMapRows`, `Type53SpawnTable`, `AutopilotWaypointA/B`, `scroll_forward_and_check_level_end`, `run_level_end_sequence` | Five rows, four animated parts and both waypoints extracted with independent authored data; trigger/extra-record/refill/music rules remain; distinct from combat bosses |
| Map spawning | Pure recipe choices + parameterized behavior + quirks | `LevelMapCellHandlers`; six handlers and common helpers in `spawn.c` | Level 1 and fixed-field/clear-only/group-hole choices in 0/3/4/5 extracted; conditional/positional and level-2 cases pending |
| Event timeline | Pure data / legacy timing | `LevelScript0..5`; `run_level_script_events` | Extracted: 138 ordered events; LevelDef binds live cursor slots; equality triggers and marker framing retained |
| Formation members | Pure data / parameterized initialization | `Formation00..52`; script spawning in `spawn.c` | Extracted: 52 referenced layouts with semantic presets, size/layer and ordered offsets; unused Formation48 retained in DS |
| Group/drop choice | Pure shared data + legacy indexing | `GroupDropKinds`; `start_map_cell_group`, script events, group slots | Event drops extracted; map preparation/membership phases represented as compatibility data; complete map drop rules pending |
| Enemy archetype binding | Parameterized or unique behavior | `REC_TYPE`, `run_type_handler` in `enemies.c`; `RECORDS.INC` | Existing implementations retained; formation presets bind public names through `level_presets.py` |
| Waypoint paths | Pure data with distinct behavior contracts | `SteerPath10/11`, `Type41/43/44/45/4A/51Path`, `PathType66/67`, `SweepPath*`; `paths.c`, `enemies.c` | Extracted used routes as playfield points with explicit fly-off/jump/continue endings; existing readers retained |
| Leader paths/actions | Pure stream data + procedural behavior | `LeaderScript*`, `Type21Path`; leader starters in `spawn.c`, handlers in `enemies.c` | Extracted targets/follower positions and encounter restart route; reader-specific marker semantics retained |
| Leader-child slots | Pure layout + runtime cursor | `FormationSlots`, `FormationSlotCursor`; leader children/type20 | Extracted ordered slots; allocation failure still advances cursor |
| Invader layout | Pure layout + unique encounter behavior | `InvaderFormation`, invader cursors; `enemies.c`, `life.c` | Extracted level-3 director's 24 ordered slot targets; live cursor/end and post-allocation read order retained |
| Opening march timing | Pure parameter tiers + shared latch behavior | `UpdateAllRecords`, `StepMarchFireDelay`, type80; `frame.c`, `reset_march_state` in `spawn.c` | Extracted enabled flag and separate step/fire delay tiers; initial state, edges/drop distance and member behavior remain procedural defaults; distinct from invader slots |
| Boss | Pure geometry/path + unique behavior | `BossPartOffsets`, `BossPath`, boss globals; segmented boss routines | Anchor route extracted with restart ending; parts/geometry/damage coupling pending |
| Encounter selection | Unique behavior selection + parameters | `type21_encounter_director`; level 0 boss, 3 invaders, 4 leader path, others fallers/burster | Extracted four semantic kinds, phase thresholds, explicit burster health/sprite/X, faller policies and director damage eligibility; existing procedures retained |
| Checkpoints | Pure data + legacy selection/overread | `LevelCheckpointPtrs`, `LevelCheckpoints*`, `CheckpointCursorPtrs`; `frame.c` restart | Extracted to map rows, clocks and next-event indices; native LevelDef selects live bindings with ASM read/write ordering |
| Map reset actions | Pure dispatch data + procedural mutations | `MapResetLists` in DATA and `MapResetList*` in code; restart scan | Pending; cleared/restored cells may differ from normal spawning |
| Music | Resource metadata + timeline policy | `LevelMusicTable`; `life.c`, `frame.c` | Pending; low-byte index, start/end/late-level overrides remain |
| Palette/HUD level identity | Resource metadata / presentation | `display.c`, CS `LevelCgaPaletteCases`, `DacColor6*`, `LevelDigitChars`, native presentation dispatch | Pending; adapter-specific choice, original digit and chooser order retained |
| Difficulty | Shared runtime setting + behavior parameters | `DifficultySetting`, child throttle, damage/fuel/fire gates | Remains engine policy; not automatically a per-level override section |
| Mutable execution state | Runtime state | Pools A/B, allocation cursors, RNG, scripts, scroll, groups, encounters, checkpoint state | Always in existing memory model; never copied into definitions |

`firers.c`, `flyers.c`, `terrain.c`, `pods.c` and `weapons.c` have no direct
`LevelIndex` selection. Their runtime dependencies still matter for equivalence.
`combat.c` now reads director damage eligibility from the encounter descriptor;
descendant speed remains level-dependent. `shots.c`
also changes projectile speed on level 0. The absence of a level branch is not a
proof that a routine is independent of selected banks, tile properties or state.

## Cross-level evidence for map recipe primitives

| Level | Observed recipe families and exceptional actions |
|---|---|
| 0 | Side-gated runners; grouped/ordinary crawlers, shooters, climbers and turrets; center-facing sprites; cell-only clear; large 2x2 spawns; fuel pickup changes row-scan return cursor |
| 1 | Walkers; retained-cell small/volley turrets; hatch writing a 2x2 graphic before allocation |
| 2 | Retained-cell hatch with stale group field; center-facing enemy; plunger Y offset |
| 3 | Ordinary/grouped patrols, crawlers, climbers, fallers, bouncers, turrets, bursters and risers; group-range holes still allocate groups |
| 4 | Shares turret/hatch recipes with level 1 and crawler/shooter families with other levels; crawler sprite override; group-range holes |
| 5 | Retained-cell hatch and directional turrets/lurkers; 2x2 creeper; ordinary/grouped families shared with levels 0/3/4; clear-without-spawn cells; conditional RNG-based jitter-shooter grouping |

This supports a small recipe vocabulary: spawn normal/grouped/large/pickup,
keep/clear/rewrite cells, 2x2 mutation, direction/center-facing initialization,
coordinate offsets, sprite/type selection and conditional overrides. It does not
yet justify an interpreter or a public instruction sequence. Recipes must preserve
the original statement order rather than merely produce similar final records.

Important boundary cases to encode in future comparisons:

- Clear-before-allocation is observable even when the pool is full. Hatch graphics
  are also written before allocation; retained-cell hatches differ in stale fields.
- Group setup precedes switches for several ranges, including holes. Full group
  tables, zero drops, member joining and pool exhaustion are different outcomes.
- Level 5 jitter grouping draws RNG conditionally; other levels consume no word
  through that condition. Drops depend on positions/timing, not enemy identity.
- Level 0 fuel pickup returns an initializer-modified scan cursor. The row scanner
  resumes from it, rather than simply advancing one cell.
- Event cursors advance before spawning members; allocation failure truncates a
  formation. A zero member count retains the original 16-bit LOOP behavior.
- Map loads reset all six script cursors, including during checkpoint restart.

## Remaining level selections in gameplay

Keep these grouped unresolved items visible until a targeted extraction closes them:

| Source | Selections to classify further |
|---|---|
| `enemies.c` | Volley/descender/turret sprite bases; hatch child behavior; type34 early-Y fire gates; level5 jitter motion/cadence; selected path/steering rules; shooter exceptions; fall speed; child hit points; slot-hopper speed; jitter-shooter preset; boss geometry |
| `paths.c` | Level/demo steering speed; path exit behavior at the final spawn row; sprite banks including level5 fall-through |
| `spawn.c` | Map recipes; crawler sprite override; jitter group RNG; event HP initialization; type21's unusual initial leader-script pointer |
| `combat.c`, `shots.c` | Descendant extra Y step; level0 projectile speed |
| `frame.c` | March initial step/edges/drop/member defaults; boss offsets; music selection; checkpoint/reset table bindings |
| `life.c`, `display.c`, native presentation | Music number, palette and displayed digit selections |
| `session.c`, `presentation.c` | Chooser mapping, six-level progression, completion screen policy; these may be campaign rules rather than level definitions |

Resources and terrain now enter native initialization through `level_bindings.py`.
Canonical import is byte-identical to the original DS image. Public terrain values
are `open`, `wall`, and `shot_permeable_wall`; tests also preserve raw legacy values
in mutated DS streams. Source ordering, duplicate entries, the tile-only terminator
and original storage identity remain intact. The adapter rejects longer streams and
divergent definitions sharing a stream until separate native storage is supported.

Checkpoints now bind into the same native initialization. Event indices are decoded
from variable-length original script records and resolved back to cursor identities;
all 24 checkpoint cursors are event boundaries. Three thresholds derive from the
following checkpoint row, and the final fallback's neighboring word stays untouched.
The native selection retains provisional cursor writes before threshold reads;
direct comparisons cover the two alias cases the previous C selection omitted.
Level 2's final clock/event mismatch and level 5's repeated resume event are retained.

Timeline and formation payloads now enter that initialization too. Preset identities
are in `tools/level_presets.py`, directly consumed by export, validation and binding;
the enemy dispatcher remains authoritative for behavior. The layout adapter retains
shared formation identities and trigger-indexed group drops, rejects conflicting
definitions and preserves ignored trailing bytes. Checkpoint indices follow edited
event framing rather than retaining stale source byte offsets.

`tools/level_paths.py` now derives route and leader payloads from source labels.
The codecs preserve public playfield coordinates, distinct stream endings, shared
route identities, leader end synchronization and lead-in adjacency. Six level
fixtures contain their formation/director dependencies. All ten ordinary follower
bindings, six leaders, sweep routes, encounter and boss routes are exercised against
ASM. The demo's Type51 path is deliberately outside original level content; Type4A
has no demonstrated original level reference yet and remains untouched in DS.
Neither its existence nor a supported binding is evidence of level reachability.

`tools/level_map_recipes.py` curates map recipe slices from the maintained cell
handlers. It is consumed by
export, validation and native table generation. The generic evaluator applies
ordered relative writes, then reuses ordinary/large map initialization and existing
behavior presets. Original level-1 selection is entirely data-driven; the level-4/5
turret and hatch entries share the same model. Fixed-field and clear-only cases
across 0/3/4/5 now use it too. Native retained C switches and ASM remain independent
comparison references.

Group preparation/membership order now has three importer-generated compatibility
phases. Allocation-only applies to both ungrouped enemies within admitted ranges
and no-record cells; ordinary members join before field overrides, large members
afterward. The real level-3 hole retains its allocation attempt without touching
map, pool or group bytes. Level-5 walker cells retain their early nongroup return.
The shared live drop cycle remains authoritative, including aliases with timeline
events and map writes that alter the drop word after preparation. RNG-dependent
jitter grouping, center-facing/offset placement and stale-group hatches remain open.
Expanded grouped coverage is version 2. The version-1 map scope remains a consumed
compatibility binding, tested with an older empty list; it is not silently widened.

Direct tests cover every safe map byte in all six levels, pool exhaustion, stale
fields, caller/allocated-record aliases, wrapped offsets, physical DS aliases and
row integration. Forbidden past-table bytes remain an ASM precondition, as in the
DOS suite. The initial high-offset fixture mismatch was a setup error: the normal
map segment aliases DS there. Populating both sides through the same physical alias
resolved it without changing gameplay or adding a compatibility property.
Group comparisons cover zero/nonzero/raw drops, full/partial group tables, failed
record allocation, every original drop-cycle offset and live drop-word alias order.

`tools/level_encounter.py` curates the small scalar choices in the director, faller
spawner/movement and director destruction gate. It exports and validates the six
descriptors and generates native immutable content; it does not patch runtime DS.
The reference remains `Type21EncounterDirector`, `EncounterSpawnFaller`,
`Type23ColumnFaller` and `DestroyRecord` in MODULE3.ASM and their DOS C bodies.
Canonical data retains the entire initial DS image. Bounded tests cover every
director kind, phase boundaries, free/partial/full allocation, column wrap,
variant-counter wrap, arrival/motion and destruction. Permutation tests swap boss
and invader descriptors and move burster HP/animation policies between slots.
Authored tests independently change phase thresholds, HP, variant preservation,
motion, sprite/X and damage eligibility. Live identity aliases verify the original
read after type/sprite writes; no cached level selection replaces that read.
Boss assembly/part offsets and remaining enemy/member parameters remain unresolved data.

`tools/level_invaders.py` extracts the 24 targets from `InvaderFormation` and
curates the two march delay tier lists from maintained scalar decisions. The slot
list belongs to level 3's director; level 5's opening uses a different leader/member
stream and only its separate march clock is enabled. Native code captures the
slot cursor before allocation, reads Y and writes saved Y before reading X, then
increments the live cursor only on success. End detection remains equality-only.
Authored slot storage never patches another level's DS table. Canonical live table
and cursor aliases are compared in full, including the case where writing saved Y
changes the following X or the cursor itself. Authored comparisons change only
the oracle's static source table, require it unchanged by the call, and remove
those fixture input differences from the final comparison.

The new FFFF-cursor fixture exposed a native borrowed-window boundary read:
its high byte came from the harness canary rather than the next physical arena
byte. ASM's LODSW reads that adjacent physical byte; only the subsequent starting
offset wraps. The native slot reader now resolves this straddling byte explicitly,
with different sentinel values proving it does not wrap the high byte into low DS.
Odd offsets and authored-table seams retain the same word/read-offset contract.
No DOS body or oracle bytes changed.

March tests cover count-tier boundaries, delay zero/expiry, byte pulse wrap,
edge latches, reverse-pass fire consumption, enabled-policy permutations and
authored reload tiers. Both clocks run before records, not in TickFrameTimers.
The new descriptor selects data; it does not move latch updates, reset march state
on level selection, or alter type80's leader-end gate.

Level-6 branches and extra map/bank entries are retained. Normal selection reaches
six levels, but unchecked/wrapped accesses are tested rather than normalized.

## Open evidence work

Correlate decoded map-cell occurrences with recipes and every mutation path; build
a behavior-name registry from actual uses; identify remaining boss/invader parameters
without changing implementation order; compare complete affected state for every
new extraction. No enemy-family abstraction is locked by these data extractions.
