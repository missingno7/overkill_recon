# Native SDL3 platform phase

The DOS C baseline is complete. The native target compiles every `c/*.c` region and
replaces DOS hardware services with `host/` implementations. It now runs startup,
title, menus, level selection and gameplay through SDL3. The frozen ASM oracle and
DOS hybrid remain separate targets.

The `data-driven-levels` branch starts incremental level-data extraction with a
native level-binding `LevelDef`. See [engine-model.md](engine-model.md),
[original-level-mapping.md](original-level-mapping.md) and
[level-format.md](level-format.md) for the audited boundaries and remaining work.
The native build consumes six `.lvl` definitions for resources and ordered tile
attributes, checkpoints, timelines, formations and paths in the original initialization
layout. Run
`python tests/host/level_def.py --no-build` for their native-vs-oracle binding and
loader/terrain regression; complete external gameplay-level loading is still pending.
`python tests/host/timeline.py --no-build` compares every original event/formation
against ASM with pool/group exhaustion and edited definition cases.
`python tests/host/path_data.py --no-build` compares original waypoint/leader streams,
arrivals/endings, allocation failures and edited route/slot definitions against ASM.
Map recipe slices compile from `.lvl` definitions into native immutable tables:
all level-1 actions plus fixed-field/grouped choices and clear-only cells in
levels 0/3/4/5 now use one evaluator. Group compatibility retains preparation and
membership order while sharing the original live drop table.
`python tests/host/map_recipes.py --no-build` checks all safe cells, converted-action
boundaries, row integration and authored edits; remaining recipes retain their handlers.

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
