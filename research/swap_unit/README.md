# One native DOS swap unit

This is a bounded research build, separate from the accepted exact ASM build.
The unit is `0000:9CF1..9D4C`, AdvancePositionHistoryIfRequested: 22 instructions,
92 bytes, four state cursors and six conditional branches. No matching recipe or
new compiler backend is involved. See [the report](../../docs/swap-unit-experiment.md).

From the repository root:

```powershell
python research/swap_unit/run.py
```

This freshly verifies/assembles the production main image, compiles the one C
body with pinned Turbo C 2.0 through nmlgc MS-DOS Player, assembles its mechanical
bridge, links with the established TLINK runner, creates both real MZ packages,
executes the differential cases through the original caller, then runs both
packages to the bounded `9690` startup frontier. It never enters gameplay.

Build selection alone:

```powershell
python research/swap_unit/build_swap.py --implementation ASM
python research/swap_unit/build_swap.py --implementation C
```

Outputs: `build/swap_unit/asm/PLAY.EXE` and `build/swap_unit/c/PLAY.EXE`.
Each folder also contains `OVERKILL` (the same rebuilt MZ under the original
resource-container filename) and the pinned original `OVERKILL.EXE` launcher,
which startup reads for integrity/registration data. Run `PLAY` from that folder
in a DOS environment supporting the Tandy/PCjr + AdLib profile. Physical hardware,
rendering/audio fidelity and whole-game replay are not certified by this study.

The 512-byte prefix is identical in both variants and contains the C body even
in ASM mode; it is unreachable in ASM mode except for the common launch entry.
Only C mode routes the original unit entry to the bridge. The original main
image is always independently assembled; no original packed game code is used
as an executable fallback. Unknown DB bytes retain the production accounting.

`HISTORY.C` owns the complete cursor operation. `BRIDGE.ASM` owns only ABI
marshalling/preservation and the separate launch entry. `results/residual.json`
is diagnostic output; deleting it cannot change C compilation or behavior.
Results and scripts are checked in. Generated EXEs, objects, listings and memory
artifacts remain under ignored `build/`. Local compiler binaries remain in the
prior research area's ignored toolchain directory, pinned by its lock file.
