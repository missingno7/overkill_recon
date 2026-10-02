# Native platform phase

The DOS C baseline is committed at `5c475b7`. The SDL3 phase now builds the shared
keyboard/joystick input policy, record movement, allocation, random-word cycle and
terrain probes as a native library. This is a core integration milestone; a native
game executable, graphics, timing, files and audio are still to come. The DOS hybrid and exact ASM
oracle remain independent build targets.

```powershell
python tools/host.py
python tests/host/input.py --no-build
python tests/host/movement.py --no-build
python tests/host/pools.py --no-build
python tests/host/terrain.py --no-build
python tools/hybrid.py
python tools/difftest.py
python tools/verify.py
```

The Windows native build uses x86-64 MinGW GCC and the official SDL3 development SDK
pinned by `metadata/sdl3.json`. The SDK is downloaded into ignored `build/deps` and its
SHA256 is checked before extraction. Nothing is installed globally. The complete
build is currently tested on Windows and requires the bundled Windows DOS-tool
runners to regenerate the oracle. The native compiler branch also accepts
GCC-compatible compilers with `pkg-config sdl3` on other hosts; the oracle-generation
step still needs adaptation there.

`tools/host.py` builds a fresh symbol-complete oracle, checks its image against the
pinned original hash, and derives native `GAME_GEN.H` and `STATE.BIN`. Types, record
layout, constants and DS labels share the DOS generator. Native scalars have fixed
widths and permit the unaligned word locations the original state contains.

The platform lends one little-endian 64-KiB DS window to `overkill_bind_state`. Generated
names are views into that window; there are no globals per label or synchronized
records. The caller owns its lifetime. `GAME_PTR` and `GAME_OFFSET` convert stored DS
offsets at the point of access; allocation cursors and record links retain their
original word representation, including the FFFFh no-record sentinel. These conversions
are used by the shared pool and random-cycle helpers. Remaining DOS pointer casts,
CS data, code-pointer dispatch, far addresses and C16 integer promotions in other
regions need explicit adaptation and validation before they can be compiled for a
host. Movement accepts native pointers into the same DS window and keeps its
original 16-bit record fields.

The level loader lends a mutable 64-KiB map window through `overkill_bind_level_map`.
`c/terrain.c` reads that buffer directly on the host; its DOS build still reads through
the original CS `LevelMapSegment` word. The platform owns the map storage and its
lifetime. Map offsets remain words, so lookup arithmetic keeps the original wrap.
Grid probes, terrain steps, ship collision and climbing walkers share one C body across
both targets. Map loading itself is still pending in the native backend.

`host/sdl_input.c` translates physical SDL scancodes into the game's existing set-1 key
state, including make/release events and typematic repeats. The shared C poll applies
configured bindings and fixed controls. Focus loss releases held keys; Alt+X and SDL
quit events request exit. This operates on SDL events, not PPI/PIC interrupt traffic.
Compound Pause and transient PrintScreen fake-shift sequences are outside this first
adapter. Raw joystick samples have an injection boundary; native gamepad sampling and
calibration are not implemented yet.

Native tests compare complete DS snapshots against bounded original ASM input,
movement, pool and terrain calls, excluding only the DOS stack scratch. SDL event
checks use the real SDK event queue.
No whole-game replay or native gameplay claim is implied by this gate.
