# Overkill reconstruction

A readable TASM source reconstruction of the DOS game Overkill that assembles to the
exact original program. Its purpose is to make the program's state, structures,
routine contracts and platform/game boundaries explicit enough that it can later be
translated to C (and then ported) without guessing. It is incomplete: bytes whose
basic class (code or which kind of data) is not yet proven stay visible as `db` rows
under `; UNKNOWN` markers; `python tools/verify.py` reports how many remain.

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
- `src/MODULE1.ASM` .. `MODULE3.ASM` - the main and far (0F7F) code, split where the
  original relocation order proves link-module boundaries. The evidence shows at least
  three modules and leaves some boundaries non-unique; these files are not claimed to
  be the historical object modules (see docs/executable-wrapping.md).
- `src/SLOT1022.ASM`, `SEG1534.ASM`, `SEG153A.ASM`, `DATA.ASM` - one file per remaining
  address frame: the sound-module slot, the critical-error and resource-file code, and
  the game's data segment.
- `src/drivers/` - the optional AdLib and Roland sound modules.
- `include/` - shared constants (masks, field offsets, sizes, state values): `HARDWARE.INC`, `SYSTEM.INC` (startup, DOS, video,
  files), `SOUND.INC`, `INPUT.INC`, `GAME.INC` (level, lives, score), `RECORDS.INC` (the
  38h-byte object records), `MOVEMENT.INC` (movement and position history).
- `tools/` - `build.py`, `verify.py`, `where.py` (address to source line), `define.py`
  (name a variable at an address), `externs.py` (recompute extrn/public after moving or
  naming) and the extraction helpers.
- `build/` - generated: `program.bin`, objects, `.LST` listings, `OVERKILL.EXE/.MAP`.
- `docs/executable-wrapping.md` - how the program image is packed in the EXE, the link
  module evidence and the relocation invariant.
- `docs/next-work.md` - open questions and the current work queue.
- `AGENTS.md` - the working rules and the reconstruction loop.

Names, labels and files are modern reconstructions; original identifiers are unknown.
Original assets and historical tool binaries are private local inputs.
