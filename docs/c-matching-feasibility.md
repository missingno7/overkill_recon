# C-matching feasibility: research result

The primary language study is documented in
[c-match-diff-language.md](c-match-diff-language.md). Reproduction commands and
artifact separation are in `research/c_matching/README.md`.

Conclusion **B: useful for a subset**, with behavioral verification preferred for
the harder ordinary helpers and ASM retained for current hardware islands. This
is not evidence for broadly converting OVERKILL to matching C.

The initial16-routine pilot used Turbo C2.0 and Microsoft C5.10, size/speed settings
plus bounded reshaping/register-hint probes. No normal or shaped C function matched
the original custom-ABI bytes. Eight pilot bodies matched after explicit ABI
specialization and return-layout adjustments; four belong to the narrowed ten-
routine primary sample. Only two primary cases currently have the stronger narrow
C-to-semantic-IR firewall, and both are small operations. The other exact results
remain compiler-pattern-dependent evidence, not a mature language.

The initial outcome labels map conservatively: two MATCH_DIFF_GOOD examples are
small-delta demonstrations, two MATCH_DIFF_BORDERLINE examples are not promoted to
unqualified DELTA_MATCHED_C successes; four primary routines favor future VERIFIED_C,
and two favor ASM. None is a production MATCHED_C/VERIFIED_C function.

One semantic defect was discovered and fixed independently of matching: AdLib0579
writes1FFFh only initially, then reuses the previous counter read on repeats.
The exact ASM bytes were always correct; only the reviewed description and its
insufficient regression input needed correcting. This is an example of why clean-C
verification must precede any matching recipe.
