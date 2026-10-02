# Native SDL3 platform phase

The DOS C baseline is complete. The native target compiles every `c/*.c` region and
replaces DOS hardware services with `host/` implementations. It now runs startup,
title, menus, level selection and gameplay through SDL3. The frozen ASM oracle and
DOS hybrid remain separate targets.

```powershell
python tools/host.py
.\build\host\OVERKILL_SDL3.exe
```

The default is Tandy video with AdLib music and the original keyboard controls.
`--video cga|ega|tandy` selects another original raster path. `--sound adlib|roland|off`
selects the music module; `off` leaves the original speaker effects setting intact.
Roland output uses Windows MIDI and needs a compatible synthesizer. The supplied
archive contains no Tandy music module. SDL gamepads supply the original calibration
and joystick policy rather than replacing the game's input decisions.

The executable, native core DLL, SDL3 DLL, source-generated initial image, original
assets and dependency licenses are placed together in `build/host`. Settings and
high scores go to `build/host/saves/HISCORE.DAT`; `--assets` and `--saves` override those
directories. The original assets are hash checked and remain unchanged.

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
python tests/host/adlib_sequence.py
python tests/host/roland_sequence.py
```

Other `tests/host` suites cover memory aliases, movement, pools, terrain, combat, pods,
enemy paths, player/frame/weapon logic, file services and timer deadlines. Oracle
comparisons are bounded routine calls, not a boot of the original beyond gameplay
entry. CGA/Tandy pixel fixtures compare the arena against ASM; EGA plane fixtures use
independent plane expectations because the flat oracle emulator does not model EGA
hardware. Both optional music sequencers compare state and ordered chip/MIDI writes.

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
AdLib and Roland startup, and Alt+X save/exit. These do not establish exhaustive native
parity for every boss, checkpoint, ending and interactive high-score path. A separate
audio-backend regression suite is pending explicit approval after automatic approval
review rejected its creation. Full native parity remains the completion bar.

The tested build uses Windows x86-64 MinGW GCC and the official SDL3 SDK pinned in
`metadata/sdl3.json`, downloaded only into ignored `build/deps`. A pkg-config compiler
branch exists for other hosts, but regenerating the oracle still needs the bundled
Windows DOS runners; an independent non-Windows build is not yet verified.
