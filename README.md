# Overkill reconstruction

A readable TASM source reconstruction of the DOS game Overkill that assembles to the
exact original program. It is incomplete: about a quarter of the image is decoded
code; the rest is still marked `; UNKNOWN` bytes.

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
- `src/R00.ASM` .. `R07.ASM` - the MAIN code segment in physical chunks of about 8 KiB
  (not original modules); code moves into semantic files as understanding grows.
- `src/FAR0F7F.ASM`, `SLOT1022.ASM`, `SEG1534.ASM`, `SEG153A.ASM`, `DATA.ASM` - one file
  per remaining address frame: far code, the sound-module slot, the critical-error and
  resource-file code, and the game's data segment.
- `src/drivers/` - the optional AdLib and Roland sound modules.
- `include/` - shared constants: `HARDWARE.INC`, `SYSTEM.INC` (startup, DOS, video,
  files), `SOUND.INC`, `INPUT.INC`, `GAME.INC` (level, lives, score), `RECORDS.INC` (the
  38h-byte object records), `MOVEMENT.INC` (movement and position history).
- `tools/` - `build.py`, `verify.py`, `where.py` (address to source line), `define.py`
  (name a variable at an address), `externs.py` (recompute extrn/public after moving or
  naming) and the extraction helpers.
- `build/` - generated: `program.bin`, objects, `.LST` listings, `OVERKILL.EXE/.MAP`.
- `docs/executable-wrapping.md` - how the program image is packed in the EXE.
- `docs/next-work.md` - open questions and the current work queue.
- `AGENTS.md` - the working rules and the reconstruction loop.

Names, labels and files are modern reconstructions; original identifiers are unknown.
Original assets and historical tool binaries are private local inputs.
