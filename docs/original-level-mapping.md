# Original-level inventory and extraction status

Initial audit baseline: commit `9377201`, native SDL3 and shared DOS C. The inventory
below identifies sources and semantic boundaries; the ASM/C source remains the
authority for numeric values. Re-run `rg -n LevelIndex c host -g '*.c'` when extending
this inventory. Version 9 supports only a partial loose runtime representation;
complete independent levels and episodes are not claimed.

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
| Map spawning | Pure recipe choices + parameterized behavior + quirks | `LevelMapCellHandlers`; six handlers and common helpers in `spawn.c` | Canonical recipes cover all defined cases, including sprite/random parameters and fuel continuation. Loose maps use the selected profile's recipes; editing the recipe set/parameters remains an equality boundary |
| Event timeline | Pure data / legacy timing | `LevelScript0..5`; `run_level_script_events` | Canonical bindings retain live byte-offset cursors and event/drop reads. Loose v9 owns immutable ordered events and stores the next event ordinal in `LevelScriptCursors[behavior_profile]`; equality triggers, marker effects and consume-before-allocation remain |
| Formation members | Pure data / parameterized initialization | `Formation00..52`; script spawning in `spawn.c` | Canonical build bindings retain 52 referenced layouts and shared storage; loose v9 owns named formations and ordered members. `formation_spawn_parameters` exposes the two existing member HP choices; unused Formation48 remains in canonical DS |
| Group/drop choice | Pure shared data + legacy indexing | `GroupDropKinds`; `start_map_cell_group`, script events, group slots | Full map cycles and explicit recipe drops extracted; live preparation/membership phases retained. Canonical timeline drops still share DS bindings; loose v9 event drops are owned per event |
| Enemy archetype binding | Parameterized or unique behavior | `REC_TYPE`, `run_type_handler` in `enemies.c`; `RECORDS.INC` | Existing implementations retained; formation presets bind public names through `level_presets.py`. Procedures and their global DS path/resource tables still come from the selected behavior profile |
| Waypoint paths | Pure data with distinct behavior contracts | `SteerPath10/11`, `Type41/43/44/45/4A/51Path`, `PathType66/67`, `SweepPath*`; `paths.c`, `enemies.c` | Extracted used routes as playfield points with explicit fly-off/jump/continue endings; existing readers retained |
| Leader paths/actions | Pure stream data + procedural behavior | `LeaderScript*`, `Type21Path`; leader starters in `spawn.c`, handlers in `enemies.c` | Extracted targets/follower positions and encounter restart route; reader-specific marker semantics retained |
| Leader-child slots | Pure layout + runtime cursor | `FormationSlots`, `FormationSlotCursor`; leader children/type20 | Extracted ordered slots; allocation failure still advances cursor |
| Invader layout | Pure layout + unique encounter behavior | `InvaderFormation`, invader cursors; `enemies.c`, `life.c` | Extracted level-3 director's 24 ordered slot targets; live cursor/end and post-allocation read order retained |
| Opening march timing | Pure parameter tiers + shared latch behavior | `UpdateAllRecords`, `StepMarchFireDelay`, type80; `frame.c`, `reset_march_state` in `spawn.c` | Extracted enabled flag and separate step/fire delay tiers; initial state, edges/drop distance and member behavior remain procedural defaults; distinct from invader slots |
| Boss | Pure geometry/path + unique behavior | `BossPartOffsets`, `BossPath`, boss globals; segmented boss routines | Anchor route, health, sprites, initial positions and placement offsets extracted; unique construction/damage/destruction remain procedural |
| Encounter selection | Unique behavior selection + parameters | `type21_encounter_director`; level 0 boss, 3 invaders, 4 leader path, others fallers/burster | Extracted four semantic kinds, phase thresholds, explicit burster health/sprite/X, faller policies and director damage eligibility; existing procedures retained |
| Checkpoints | Pure data + legacy selection/overread | `LevelCheckpointPtrs`, `LevelCheckpoints*`, `CheckpointCursorPtrs`; `frame.c` restart | Canonical four-row bindings retain live provisional cursor writes and the ignored fourth-word read. Loose v9 owns 1..65535 semantic rows `{map_row, script_clock, resume_event}` and restores an ordinal without that read |
| Map reset actions | Level-specific restoration data + legacy scan policy | `MapResetLists` in DATA and `MapResetList*` in code; restart scan in `frame.c` | Extracted: `checkpoint_restart` with `lookback_rows: 12` and ordered `{tile, replacement}` restorations; preserve first match, scan/mutation order and level-specific rows |
| Music | Level resource metadata + shared trigger policy | `LevelMusicTable`; `life.c`, `frame.c`, `session.c` | Extracted `music.level`; six module tune indices are `8, 1, 3, 7, 9, 10`. Exact start/end overrides and delayed late-level restore remain shared engine policy |
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
- Map loads reset all six canonical script cursor words, including during checkpoint
  restart; an active loose v9 timeline sets only its behavior-profile slot to ordinal
  zero after those six legacy writes. The map rewind may consume that stream; restart
  restores the selected checkpoint ordinal at the original final cursor-write point.

## Remaining level selections in gameplay

Keep these grouped unresolved items visible until a targeted extraction closes them:

| Source | Selections to classify further |
|---|---|
| `enemies.c` | Volley/descender/turret sprite bases; hatch child behavior; type34 early-Y fire gates; level5 jitter motion/cadence; selected path/steering rules; shooter exceptions; fall speed; child hit points; slot-hopper speed; jitter-shooter preset |
| `paths.c` | Level/demo steering speed; path exit behavior at the final spawn row; sprite banks including level5 fall-through |
| `spawn.c` | Other formation-member initialization fields; type21's unusual initial leader-script pointer; canonical shared event-drop binding (map helpers remain comparison references) |
| `combat.c`, `shots.c` | Descendant extra Y step; level0 projectile speed |
| `frame.c` | March initial step/edges/drop/member defaults (checkpoint restoration and music are extracted) |
| `display.c`, native presentation | Palette and displayed digit selections |
| `session.c`, `presentation.c` | Chooser mapping, six-level progression, completion screen policy; these may be campaign rules rather than level definitions |

The checkpoint-restart data is `checkpoint_restart:{lookback_rows:12,
tile_restorations:[{tile,replacement}]}`. The original scan walks the preceding
0x9C map bytes backward and replaces the first matching tile in that level's
ordered replacement stream. Restoration is distinct from spawn mutation; hatch
restoration differs between levels. Tests compare the entire map, each restoration tile and both
sides of the lookback boundary, plus live DS pointer and CS entry changes.

Music ownership has two layers. `LevelMusicTable` supplies the level's sound-module
tune index. At life start, exact `MAP_START_POS` and `MAP_END_POS` use shared tunes
4 and 5; otherwise the unchecked low byte of `LevelIndex` selects the table entry.
The row-entry path also requests shared tune 5 when `LevelScriptClock` decrements
to 4. After an encounter, only the transition of `EncounterEndDelay` from one to
zero with no live encounter requests music: it selects the level tune below the
unsigned `MAP_MUSIC_CHANGE_POS` threshold and shared tune 6 at or beyond it. These
request points and their ordering remain procedural. The ASM reads the table tune
before applying the late-level override. Version 7 exposes `music:{level:8}` (an original module index); canonical fixtures retain
live DS table reads while authored values remain independent even when equal.

Both restart rules and level music should travel with level identity when episode
order changes. Resource identity is not fully audited yet: in particular the
chooser's `choose.enc` six-slot boundary and unchecked/seventh-level behavior
remain unresolved. Enemy/path differences above still require individual evidence
and equivalence checks before becoming parameter data.

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

Canonical timeline and formation payloads enter build-time initialization through
that adapter. Preset identities are in `tools/level_presets.py`, directly consumed
by export, validation and binding; the enemy dispatcher remains authoritative for
behavior. The canonical layout adapter retains shared formation identities and
trigger-indexed group drops, rejects conflicting definitions and preserves ignored
trailing bytes. Loose version 9 runtime content instead owns immutable timelines,
formations, checkpoints and formation spawn HP; its existing DS cursor word stores
the next ordinal. Authored checkpoint rows select by the following map row with an
unsigned threshold and have no neighboring fourth-word read. Map reload first
performs the original six cursor resets, then sets the active profile cursor to zero;
checkpoint restart restores the selected ordinal after the rewind. Version 8 loose
content remains accepted with canonical timeline/checkpoint equality.

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
behavior presets. All defined original cases in all six levels are data-driven; the level-4/5
turret and hatch entries share the same model. Fixed-field and clear-only cases
across 0/3/4/5 now use it too. Native retained C switches and ASM remain independent
comparison references.

Group preparation/membership order now has three importer-generated compatibility
phases. Allocation-only applies to both ungrouped enemies within admitted ranges
and no-record cells; ordinary members join before field overrides, large members
afterward. The real level-3 hole retains its allocation attempt without touching
map, pool or group bytes. Level-5 walker cells retain their early nongroup return.
The shared live drop cycle remains authoritative for map recipes and canonical
timeline bindings, including aliases with map writes that alter the drop word after
preparation. Loose v9 timeline events own their drop values. Live crawler
sprite choices, jitter grouping and fuel continuation are now represented.
Grouped coverage arrived in version 2; center-facing and pixel-offset coverage uses
version 3; runner/cruiser, retained-slot hatch and lurker coverage uses version 4;
live sprite/random choices and pickup initialization/continuation use version 5.
All older map scopes remain consumed compatibility bindings, tested
with older empty lists; none is silently widened.

`tools/level_groups.py` extracts the entire 64-byte `GroupDropKinds` table from
the oracle, validates semantic map drop cycles and selects immutable overrides.
All six original definitions retain live DS reads. Authored cycles belong to the
map level only; explicit recipe drops supersede the cycle before allocation.
The allocator and joiner remain the original procedures. A zero drop retains the
old slot index; a full-table scan sets it to 16 (the earlier C comment was stale).
Every selector, membership phase, exhausted pool/table and late drop alias is
compared against ASM. Canonical timeline drop bindings preserve shared-table
conflicts; loose v9 event drops are separate from map drop edits and DS storage.

The center-facing data corresponds to inline ASM spawn cases and the shared C
`face_centre` helper, plus the sprite-less `SpawnCellCrawler5F`. These recipes read
the record's post-initialization X, compare unsigned, and take the alternate values
at equality. The sprite-less crawler retains its direction-before-type compatibility
and leaves sprite untouched. `SpawnCellPlunger2E` sets type then subtracts six from Y,
without changing saved Y. Full-memory tests cover center neighbors/high words,
map-clear aliases crossing sides, authored field/offset values and every defined
level-3 case; the latter no longer needs procedural selection in the native path.

`SpawnCellRunnerRight73/Left74`, `SpawnCellCruiser6F`, `SpawnCellHatch2A` and the
four lurker cases now use the same evaluator. Runner gates read map-column X before
clear/allocation; early offsets then copy shifted X to saved X before behavior
fields. Cruiser joining precedes fields and subtract/test/add placement. Hatch2A
shares the large initializer's ordered writes while omitting its final slot reset;
no save-and-restore workaround is used. Allocation aliases that write kind into
`MapCellX` demonstrate why that X cannot be cached before initialization.
Tests compare all slot values, pool/group exhaustion, unsigned boundaries/wrap,
wrong-side no-mutation and authored gate/distance/slot/sprite changes.

The final eight cells (level 0 E3/F9, level 4 D2/D3/DD and level 5 DC/DD/EB)
now use the shared evaluator. `SpawnCellCrawler54UpRight/Left` writes direction,
type and base sprite, then reads the live level's sprite offset. `SpawnCellJitterShooter68`
reads its live random-test parameters after group preparation, before map clear or
allocation; an enabled test consumes even for full pools. The match controls
membership only. `SpawnCellFuelPickup` reuses ordinary initialization then the
pickup initializer, retaining the original success-only sprite continuation.
Canonical fixtures contain 119 recipes. Every RNG-cycle position and live/dispatch
level permutation is checked; edited parameters remain local to their definition.

A newly minimized native pickup mismatch was a repeated global read, not bad data:
an unaligned record/global alias produced native sprite 0046 versus ASM SI=1246.
`InitPickupRecord` reads DropKind once after its first six field writes, then uses
that saved word for item and sprite. Native C now keeps that value through both
writes and return. Twelve full-state alias tests prove the rule; the DOS body and
frozen ASM are unchanged.

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
Boss setup/member offsets now use the descriptor below; remaining enemy/member
parameters are still unresolved data.

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

`tools/level_boss.py` derives the four geometry pairs from `BossPartOffsets` and
curates the small setup immediates in `EncounterSegBossLevel` and
`InitSegBossPartRecord`. Public roles map privately to types 76h..79h; core conversion
precedes allocation of anchor, upper-right and lower-right. Initial Y is zero for
every part, whereas later geometry places the core/lower-right at Y + 32.
Canonical placement retains live DS reads after core fire and Y-before-X mutation;
edited geometry is separate immutable content. Existing movement, combat and linked
destruction remain procedural. Full-memory comparisons cover allocation failure,
stale/zero/repeated links, release, signed clamps, wrap and geometry/global aliases.
Edited builds also exercise a moved director/boss descriptor and independently
authored HP, sprites, spawn positions and geometry, without changing source tables.

Failed-setup comparisons establish that reverse scanning zeroes the newest part,
whose release explodes the other linked parts. Later visits skip their explosion
types, preserving their initialized HP. Explicit authored-output expectations encode
that observed order; the runtime retains the original cleanup procedure.

Level-6 branches and extra map/bank entries are retained. Normal selection reaches
six levels, but unchecked/wrapped accesses are tested rather than normalized.

## Open evidence work

Correlate decoded map-cell occurrences with recipes and every mutation path; build
a behavior-name registry from actual uses; identify remaining enemy/member parameters
without changing implementation order; compare complete affected state for every
new extraction. No enemy-family abstraction is locked by these data extractions.
