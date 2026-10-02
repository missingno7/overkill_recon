# Overkill reconstruction

A readable TASM source reconstruction of the DOS game Overkill that assembles to the
exact original program: the main image, its entry point and relocation set, and the
optional AdLib and Roland sound modules. Every byte is classified (code or a named data
class, with deliberately unused bytes named as such), and the program's state,
structures, routine contracts, data formats, platform/game boundaries and the original
quirks a faithful port must keep are written into the source.

## Role: the semantic oracle

```
original binary
      | byte exact (tools/verify.py)
semantic ASM oracle (this source)
      | behavioural equivalence (tools/difftest.py)
DOS C implementation
```

The ASM is the permanent executable specification of the original DOS game. The DOS C
translation is validated against it, one region at a time, on the original DOS
platform model; the ASM is not reshaped to make that translation easier. It stays
useful after the C version is complete, as the reference for any behavioural question.

The reusable game and resource logic now lives in `c/`, including presentation and
startup configuration. The runnable DOS hybrid keeps the original hardware backend;
the next phase replaces that boundary and the DOS address representation for SDL3.
See [docs/dos-hybrid.md](docs/dos-hybrid.md) for building, running and verification limits.

```powershell
python tools/verify.py
```

This checks the pinned original assets and tools, extracts the normalized program
image from `assets/OVERKILL`, assembles `src/` with TASM 1.0 and links it with TLINK 2.0
(both under local MS-DOS Players), then compares every byte of the EXE load module, the
entry point and the relocations TLINK emits, plus both optional sound modules
(`ADLIB.ENC`, `ROLAND.ENC`). Python 3.10+ on Windows is the only prerequisite.

```powershell
python tools/where.py 9C01        # source line for an image address (after a build)
```

## Layout

- `src/sources.txt` - main-program sources in link order.
- `src/MODULE1.ASM` .. `MODULE4.ASM` - the main and far (0F7F) code, split where the
  original relocation order or linker padding shows link-module boundaries. The
  relocation order proves at least three modules, alignment padding suggests more, and
  some boundaries are non-unique; these files are not claimed to be the historical
  object modules (see docs/executable-wrapping.md).
- `src/SLOT1022.ASM`, `SEG1534.ASM`, `SEG153A.ASM`, `DATA.ASM` - one file per remaining
  address frame: the sound-module slot, the critical-error and resource-file code, and
  the game's data segment.
- `src/drivers/` - the optional AdLib and Roland sound modules.
- `include/` - shared constants (masks, field offsets, sizes, state values):
  `HARDWARE.INC`, `SYSTEM.INC` (startup, DOS, video, files), `SOUND.INC`, `INPUT.INC`,
  `GAME.INC` (level, lives, score), `RECORDS.INC` (the 38h-byte object records),
  `MOVEMENT.INC` (movement and position history).
- `tools/` - `build.py`, `verify.py`, `where.py` (address to source line), `define.py`
  (name a variable at an address), `externs.py` (recompute extrn/public after moving or
  naming), `hybrid.py` (build the DOS hybrid), `difftest.py` + `emu.py` (ASM-vs-C
  differential tests), `package.py` (make a linked EXE runnable) and the extraction helpers.
- `build/` - generated: `program.bin`, objects, `.LST` listings, `OVERKILL.EXE/.MAP`.
- `docs/executable-wrapping.md` - how the program image is packed in the EXE, the link
  module evidence and the relocation invariant.
- `docs/next-work.md` - the freeze bar and what is deliberately left open.
- `docs/dos-hybrid.md` - the DOS C translation: compiler, ABI, hybrid build, differential tests.
- `c/` - C that replaces oracle routines in the DOS hybrid, with its ASM entry bridge.
- `tests/` - differential test suites and the original-quirk regression corpus.
- `AGENTS.md` - the working rules and the maintenance loop.

Names, labels and files are modern reconstructions; original identifiers are unknown.
Original assets and historical tool binaries are private local inputs.
