# C matching research (not production)

The primary study is ten already-reviewed routines. Six additional routines remain
as transparent pilot evidence from the earlier requested16-routine sweep. This is
not a C conversion or a new production architecture.

Read `../../docs/c-match-diff-language.md` for the conclusions and limits.

```
python research/c_matching/run.py
python research/c_matching/run.py --clean-only
python research/c_matching/check_delete.py
python tools/verify.py --full
```

The first command builds fresh native16-bit C with two compilers/eight bounded
configurations, executes isolated differential tests, assembles/checks matching
variants, tests two real ABI wrappers and two semantic-firewall forms, and updates
research results. The second never imports/reads match recipes, matching ASM or
ABI-specialized bodies. It tests the deletion property. Neither command starts
whole-game execution. The normal production verifier does not import this area.

Files are intentionally separate:

- `clean/SAMPLE.C`, `clean/TYPES.H`: canonical research C, including alias order,
  widths, signedness, explicit cursor results and original hardware protocol.
- `clean/IO.ASM`: two C-ABI byte-port primitives, part of the platform environment;
  never counted as a matching delta or as pure C.
- `abi/bindings.json`: reviewed original argument/global locations. These are not
  legal matching-diff capabilities. `abi/SHIMS.ASM` contains two actual bridges to
  ordinary compiled C; these bridges contain no game algorithm.
- `matching/recipes.json`: return-layout choices only. Its compiler-text anchors
  are a disposable probe, not a proposed stable language syntax.
- `firewall.py`, `abi/firewall.json`, `matching/firewall.json`: two-form C-to-IR
  experiment with a restricted lowering vocabulary and forbidden-key tests.
- `results/`: measurements, emitted instruction listings, cases, limitations and
  human-reviewed classifications. These are reports, not build inputs.
- `../../build/c_matching/`: freshly generated DOS C objects, linker maps,
  standalone matching bodies and test artifacts. Never canonical sources.

Historical executables are local ignored inputs, pinned by `toolchain-lock.json`.
Turbo C2.0 TCC.EXE was copied read-only from empires_reconstruction; MSC5.10 passes
and error/help files from stunts_recon. Tools are not redistributed. The already
pinned local nmlgc MS-DOS Player runs compilers/TASM; the measured local i86 player
runs TLINK. No research build reads neighboring projects or uses network access.
No library/CRT startup is required: linked code is entered only by the test oracle
at public routine addresses, with explicitly constructed C arguments and segments.
The test executables are not standalone games.

All C inputs are copied as ASCII CRLF for the historical compiler. A LF-only probe
produced an empty Turbo C object; builds therefore also require every expected
public symbol. Failed/missing functions cannot count as small or matching output.

The clean-C tests cover stated semantic projections and selected conditions,
not an exhaustive full-machine proof. Full register/flag boundary equivalence is
additionally tested for the two actual wrappers and all claimed exact/alternate
matching bodies. PIT I/O-order agreement is explicitly not physical-timing proof.
Other routine-specific ABI shims remain unimplemented, not implicitly zero cost.

`check_delete.py` additionally removes the matching directory from its normal path
while fresh clean builds/tests execute, and restores it byte-for-byte in finally.
The checked receipt is `results/deletion.json`. Flag comparisons use the vendored
CPU model; architecturally undefined flag values are not new hardware guarantees.
