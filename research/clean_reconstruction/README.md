# Clean reconstruction world: position history

This is a separate source experiment, not the production game or a frozen-image
patch. See [the report](../../docs/clean-c-reconstruction-experiment.md).

```powershell
python tools/verify.py
python research/clean_reconstruction/run.py
```

The first target independently builds the exact ASM oracle. The second builds
ordinary C/OMF executables, verifies four leaves and two C clusters against the
oracle, runs the standalone native DOS demonstrator in two link orders, and records
source-hash receipts. It does not run the original game.

Individual steps:

```powershell
python research/clean_reconstruction/build.py
python research/clean_reconstruction/verify.py
python research/clean_reconstruction/demo.py
```

The clean build requires only `src/` and the pinned compiler/assembler/linker tools;
`build/program.bin` is read only by verification. Outputs are
`build/clean_reconstruction/base/CLEAN.EXE` and `moved/CLEAN.EXE`.

- `src/HISTORY.C`: four normal C leaves.
- `src/UPDATE.C`: two normal C callers; no historical ABI adapters.
- `src/HISTORY.H`: typed state, indices and explicit domain.
- `src/DEMO.C`: standalone chronological checks, not a substitute game.
- `src/START.ASM`: minimal DOS process entry/exit.
- `src/SHIFT.ASM`: optional link-placement witness only.
- `verify.py`: original-machine setup, semantic object mapping and comparisons.
- `results/`: compiler/linker, region, residual, differential and DOS-run evidence.

The proof is memory-effects refinement over valid typed initialized state, not
historical register-ABI equivalence. Malformed offsets, partial-word overlaps,
metadata corruption and unresolved outer caller liveness remain explicit limits.
No original bytes or emulation runtime are linked into the clean executable.
