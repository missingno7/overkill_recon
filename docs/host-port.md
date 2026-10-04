# Native SDL3 platform phase

The DOS C baseline is complete. The native target compiles every `c/*.c` region and
replaces DOS hardware services with `host/` implementations. It now runs startup,
title, menus, level selection and gameplay through SDL3. The frozen ASM oracle and
DOS hybrid remain separate targets.

The `data-driven-levels` branch starts incremental level-data extraction with a
native level-binding `LevelDef`. See [engine-model.md](engine-model.md),
[original-level-mapping.md](original-level-mapping.md) and
[level-format.md](level-format.md) for the audited boundaries and remaining work.
The native build consumes six canonical `.lvl` definitions for resources and ordered
tile attributes, checkpoints, timelines, formations and paths in the original
initialization layout. Loose version 11 runtime content can independently own a
decoded map, timeline, formations, semantic checkpoint rows, formation spawn HP,
checkpoint-restoration rules, music, ordinary fly-off routes, six leader presets and
slot-hopper geometry. Run
`python tests/host/level_def.py --no-build` for their native-vs-oracle binding and
loader/terrain regression; the canonical six-level path retains its original DS
bindings.
`python tests/host/timeline.py --no-build` compares every original event/formation
against ASM with pool/group exhaustion and edited definition cases.
`python tests/host/timeline_content.py` compares owned v9 event ordinals,
formation HP/drop behavior and checkpoint restarts against an equivalent legacy
stream, normalizing only the two cursor-token words whose representations differ.
`python tests/host/path_data.py --no-build` compares original waypoint/leader streams,
arrivals/endings, allocation failures and edited route/slot definitions against ASM.
`python tests/host/waypoint_content.py` compares authored ordinary-route behavior
while preserving the existing `REC_PATH` cursor. Only the ten ordinary fly-off
presets are owned at v10; v11 adds six leader presets and slot-hopper geometry.
Special sweep/encounter/boss routes remain canonical-profile constrained. Authored
leader steps use the existing global cursor ordinal and matching end gates, with no
private leader cursor. Canonical execution retains the live DS pointer/strides and
unchecked reads. `python tests/host/leader_content.py` checks all six generated leader
layouts and compares original arrival/nonarrival behavior with ASM cursor and pool state.
It also covers start/death resets and follower release gates, longer authored routes,
slot cycling, independence from poisoned legacy tables, and transactional rejection.
Map recipe slices compile from `.lvl` definitions into native immutable tables:
all defined original actions across the six levels now use one evaluator, including
live crawler sprite offsets, jitter group tests and fuel scan continuation.
Version-1/2/3/4 definitions retain their original conversion scopes. Group compatibility retains preparation and
membership order. Full semantic map drop cycles and explicit recipe drops now
compile as level data; canonical cycles retain the original live table and aliases.
Authored map cycles are independent of other levels and timeline DS bindings.
`python tests/host/map_recipes.py --no-build` checks all safe cells, converted-action
boundaries, row integration and authored edits. Retained C handlers remain comparison
references and older-version fallbacks. Native pickup initialization also preserves
the proven single DropKind read; combat tests cover unaligned global/record aliases.
Segmented-boss health, sprites, spawn positions and placement offsets now come from
per-level data. Unique construction/combat/destruction procedures retain their
allocation and stale-pointer semantics; `tests/host/boss_data.py` compares them
against bounded ASM calls and separately authored definitions.

The current content boundary distinguishes engine/runtime state and procedures,
shared game content, level-specific choices and legacy storage compatibility; see
`engine-model.md`. Versions 8 through 11 can be loaded from a loose directory with
`--level`; v9 additionally owns events, formations, checkpoint rows and the two
formation-member HP parameters. Version 10 additionally owns ordinary fly-off
waypoint routes; version 11 owns six leader presets and slot-hopper geometry as well.
Their defaults come from shared generated catalogs, and omitted routes bind those
immutable presets rather than runtime DS. The event ordinal remains in
`LevelScriptCursors[behavior_profile]`; the leader ordinal and slot ordinal occupy
the existing `LeaderScriptCursor` and `FormationSlotCursor` words. Canonical execution
keeps their live DS byte offsets. Map reload performs the original six cursor resets before
setting that authored slot to zero; checkpoint restart restores the selected ordinal
after its backward scroll. Authored Type21 uses a no-active-leader sentinel for the
otherwise unused `original_level + 1` cursor seed; versions 8 through 10 and canonical
play retain their existing seed. Special routes and other sections still match an explicit original behavior profile, so complete independent gameplay levels
and episodes remain pending. Shared
start/end/late-level music triggers and the ordered checkpoint map-restoration scan
remain engine policy. Canonical definitions retain live DS/CS bindings; authored
fields are independently owned, even when their values equal the original. Resource
identity work, including the chooser's `choose.enc` six-slot boundary and unchecked
seventh-level behavior, is still open.

An executable test package is available at `levels/examples/copied-planet`:

```powershell
build/host/OVERKILL_SDL3.exe --level levels/examples/copied-planet
python tests/host/level_content_runtime.py
python tests/host/level_policies.py --no-build
python tests/level_map_import.py
```

This copied level has a new content ID, a decoded local map and tune 9, while
explicitly reusing level 2's original behavior and graphics. Its v9 timeline,
formations, checkpoints and formation HP are independently owned, even where a
value matches the source profile; its v10 ordinary routes and v11 leader presets are
also independently owned and can be edited without introducing private cursors. The
sample moves `bob_chase_leader`'s first target from X 192 to X 176; tune 9 and the
`path_follower_c` route edit remain in the same headless-launchable package.
No new source slot or
archive entry is registered. The loader validates unsupported sections against
the selected compatibility profile and fails before gameplay when they differ.
The loose test path repeats one level; ordered episodes remain a separate milestone.

```powershell
python tools/host.py
.\build\host\OVERKILL_SDL3.exe
```

The first-run default is Tandy video with AdLib music and the original keyboard controls.
Later runs restore saved settings; explicit video or sound flags override their
respective saved choices using the original launcher policy.
`--video cga|ega|tandy` selects another original raster path. `--sound adlib|roland|off`
selects the music module; `off` leaves the original speaker effects setting intact.
Roland output uses Windows MIDI and needs a compatible synthesizer. The supplied
archive contains no Tandy music module. SDL gamepads supply the original calibration
and joystick policy rather than replacing the game's input decisions.

The executable, native core DLL, SDL3 DLL, source-generated initial image, original
assets and dependency licenses are placed together in `build/host`. Settings and
high scores go to `build/host/saves/HISCORE.DAT`; `--assets` and `--saves` override those
directories. The original assets are hash checked and remain unchanged.
Interactive runs append native stderr diagnostics to saves/OVERKILL.log (under
the selected save directory). Headless runs retain stderr for their test runner.

## State and oracle boundary

The native game executes C exclusively. It uses no CPU emulator, DOS executable
runner or ASM routine at runtime. `HOST_IMAGE.BIN` is inert, relocated initialization
and adjacent-data bytes derived from the source-built, hash-verified oracle. Offset
identities in original dispatch tables are routed to C functions and native services.
Unknown service identities fail explicitly.

`GAME_GEN.H`, `HOST_GEN.H` and sound-driver offset headers are generated from the
maintained ASM and its listings. One borrowed DS window and the same segment arena
retain the original records, links, CS variables, wrapped offsets and unchecked
sentinel accesses. No converted game records or synchronization copies are maintained.
EGA video planes are hardware state outside the conventional-memory arena.

Platform services provide archive/filesystem access, paragraph allocation and EMS,
CGA/Tandy/EGA raster operations, palette and text modes, keyboard events and character
reads, gamepad samples, and PIT timing. AdLib and Roland sequencers are C translations
of the optional source-built sound modules. Timestamped writes drive pinned Nuked OPL3,
speaker/PSG synthesis or MIDI output. Analog output levels and the compatible CP437
font are host presentation choices, not claims of identical historical hardware.

## Verification and deterministic runs

```powershell
python tools/hybrid.py
python tools/difftest.py
python tools/verify.py
python tests/host/input.py --no-build
python tests/host/rendering.py --no-build
python tests/host/video_services.py --no-build
python tests/host/graphics_decode.py
python tests/host/checkpoints.py --no-build
python tests/host/departure.py --no-build
python tests/host/encounter_data.py --no-build
python tests/host/invader_data.py --no-build
python tests/host/boss_data.py --no-build
python tests/host/ui_flows.py --no-build
python tests/host/runtime.py
python tests/host/adlib_sequence.py
python tests/host/roland_sequence.py
```

Other `tests/host` suites cover memory aliases, movement, pools, terrain, combat, pods,
enemy paths, player/frame/weapon logic, file services and timer deadlines. Oracle
comparisons are bounded routine calls, not a boot of the original beyond gameplay
entry. CGA/Tandy pixel fixtures compare the arena against ASM; EGA plane fixtures use
independent plane expectations because the flat oracle emulator does not model EGA
hardware. Graphics decoding compares 50 shipped image assets across all three
adapters, including screen pages, panels and every level's sprite/block banks.
Both optional music sequencers compare state and ordered chip/MIDI writes.

Headless runs advance virtual time through the game's waits and input loops:

```powershell
.\build\host\OVERKILL_SDL3.exe --headless --milliseconds 48000 `
  --input-script controls.input --trace run.csv --screenshot frame.bmp
```

Input scripts contain sorted `milliseconds SDL_scancode pressed` rows, where pressed
is 0 or 1. Traces report service identities, selected state, quantized PCM and MIDI
hashes, and dropped audio events. The time budget stops the observation without
writing a save; normal quit and Alt+X use the game's shutdown/save policy.

Integration checks have exercised all six level selections and gameplay, all three
video adapters, pause/cheat-driven traversal of all six level-completion transitions,
AdLib and Roland startup, and Alt+X save/exit. The maintained runtime suite also
verifies Esc/Y returning through game over to the options menu, all six redefined
keys and SoundOption surviving save/reload, and one-sided launcher overrides.
Bounded native comparisons
cover all 24 actual checkpoint entries and segmented-boss placement, fire phases
and path wrapping. A ten-minute virtual gameplay soak completed without a runtime
failure and advanced to level two without F4 skips, with cheat flags enabled.
Live UI checks cover high-score name editing and keypad input, both quit answers,
boss-key restoration and cooperative timer delivery. Controller calibration uses
the shipped page and panel images with injected low/high/center gamepad samples;
the tests check its thresholds, overlay frames, release waits and Escape abort.
These checks do not establish exhaustive parity for every gameplay state. A dedicated
audio-backend regression gate remains to be added and validated. Full native parity
remains the completion bar.

The tested build uses Windows x86-64 MinGW GCC and the official SDL3 SDK pinned in
`metadata/sdl3.json`, downloaded only into ignored `build/deps`. A pkg-config compiler
branch exists for other hosts, but regenerating the oracle still needs the bundled
Windows DOS runners; an independent non-Windows build is not yet verified.
