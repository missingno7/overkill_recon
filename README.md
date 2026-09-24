# Overkill reconstruction

A self-contained, verifiable assembly reconstruction of the supplied DOS release.
This is an **exact but incomplete bootstrap**, not a finished source recovery or a C port.

The maintained TASM source currently rebuilds all **143,088 bytes** of the normalized
pre-startup game image, with **123 ordered relocation sites** and entry `0000:95C9`.
Instruction, reviewed-data and opaque-byte counts are maintained in
[docs/status.md](docs/status.md). Raw bytes are not counted as reconstructed code.
The original packed file is not yet rebuilt. See [current status](docs/status.md).

From this directory, on Windows with Python 3.10 or later:

```powershell
python tools/verify.py
python tools/verify.py --full
```

The first command checks asset/tool hashes, assembles the maintained source with
TASM 1.0 using the **nmlgc MS-DOS Player**, extracts a fresh oracle from the local
original asset, compares every image byte plus relocation/entry metadata, and
regenerates reports. `--full` additionally executes the original unpackers at two
load addresses for both executables, runs linker topology experiments, and tests
reviewed leaf behavior. Native Win64 Python is needed for the vendored emulator
and decoder libraries; the installed MSYS2 Python also passed these checks here.
No network or sibling project is used at build/verification time.

Useful entry points:

- [Wrapping and address conventions](docs/executable-wrapping.md)
- [Original-project reconstruction evidence](docs/original-project-reconstruction.md)
- [Reviewed function contracts](docs/symbols.md)
- [Bottom-up work queue](docs/bottom-up.md)
- [Offline searchable function browser](docs/functions.html)
- [Build and acceptance details](docs/build-model.md)
- [Next work and known limits](docs/next-work.md)
- `metadata/inputs.json`: original asset sizes and SHA-256 hashes
- `metadata/source-map.json`: exclusive byte ownership and raw-byte accounting
- `metadata/functions.json`, `analysis.json`, `xrefs.json`, `call-graph.json`: evidence
- `metadata/project-model.json`: historical versus inferred project structure

To inspect a routine and its callers/callees/register/memory access inventory:

```powershell
python tools/report.py 0000:C7FE
python tools/report.py ReadBufferedWordLE
```

`src/R00.ASM` through `R17.ASM` are modern physical chunks of roughly 8 KiB,
with cuts moved to instruction boundaries. They are **not proposed original modules**.
Semantic names retain an address suffix. The original names and filenames are unknown.

`tools/bootstrap_source.py` is an explicitly gated one-time transcription helper.
A normal build never invokes it or regenerates assembly from the oracle. Re-running
it with `--replace-bootstrap` will overwrite maintained source: use only for a
reviewed bootstrap expansion and then inspect/reverify the resulting batch.

Original assets are private local inputs. The local historical tool binaries were
copied for this task; the project does not claim redistribution rights for them.
`overkill_forged`, `legacy/overkill_port`, and `D:/prog/empires_reconstruction` were
used read-only. Production remains exact ASM. A bounded, non-production C/matching research sample is documented in
[the match-diff study](docs/c-match-diff-language.md); it is not a game conversion.

Runtime investigation: [docs/runtime-materialization.md](docs/runtime-materialization.md).
`python tools/materialize_runtime.py --video tandy --sound adlib --input keyboard`
reproduces the candidate post-initialization oracle directly from original assets.
`verify.py --full` now checks one bounded startup execution as
well as Oracle A and the two separately assembled optional sound modules.
A global all-path ESMR proof remains open; the executable watch reports state
exactly which paths and byte ranges were tested.

Current policy: static bottom-up work first; original execution only for a specific
question and never beyond first gameplay entry. Prior long-run evidence is retained,
but exhaustive gameplay coverage is not an acceptance requirement.

One native DOS swap-unit experiment is now available: [report](docs/swap-unit-experiment.md),
[reproduction](research/swap_unit/README.md). It replaces only the reviewed position-history
advance in an opt-in research executable; the production exact ASM build is unchanged.

A second [history-transfer cluster](docs/history-transfer-swap.md) now composes with
the first in four opt-in ASM/C research packages. Its larger ABI cost is measured;
production remains unchanged. See [reproduction](research/history_transfer/README.md).

The current architecture separates the exact ASM oracle from an experimental
[clean C world](docs/clean-c-reconstruction-experiment.md). Four history leaves
compose into two reverified C clusters without historical ABI adapters. Its native
DOS demonstration is source-only; it is not yet a reconstructed whole game.
The earlier swap labs remain verification research, not the target runtime.
