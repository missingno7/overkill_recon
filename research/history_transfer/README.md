# Second bounded native DOS swap cluster

See [the report](../../docs/history-transfer-swap.md) for the boundary, aliasing,
ABI cost and limitations. Production remains exact ASM.

Run from the repository root:

```powershell
python research/history_transfer/run.py
```

This builds the production main and four real research game packages, runs local
ASM/C differential tests and bounded Tandy+AdLib startup, and checks that default
packaging still reproduces both first-experiment binaries. Local binaries listed
in the existing input/toolchain locks are required, as for the first experiment.

For separate steps:

```powershell
python research/history_transfer/build_transfer.py
python research/history_transfer/verify_transfer.py
python research/history_transfer/integration.py
```

Packages are `build/history_transfer/{aa,ac,ca,cc}/PLAY.EXE`:
first letter selects history advance; second selects history transfer (`a` ASM,
`c` C). Source builds always compile clean C normally, with no matching recipe.
The compiler and TASM use the pinned nmlgc player; TLINK uses the measured i86
runner. No compiler runtime or interpreter is linked into the game.

`results/` contains boundary, build, compiler listing, differential, integration,
residual and source-hash receipts. Generated binaries remain under `build/`.
The startup check stops at9690 and does not establish natural gameplay execution
of either unit. Synthetic tests execute the real packaged gates and continuations.
