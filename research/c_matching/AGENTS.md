# Research scope

The user explicitly authorized this bounded C/matching investigation. It is an
exception to the current production ASM-only phase, not permission for broad C
conversion. Keep canonical C, observable ABI adaptation, and non-semantic matching
choices separate. Preserve the production exact ASM and do not import this area
from its build. Stop after the sampled evidence; do not build a generic backend.

Run `python research/c_matching/run.py` after experiment implementation changes.
Do not present a semantic projection as full ABI or physical hardware equivalence.
Exact variants must assemble from compiler/IR-derived operations, never oracle-byte
fallbacks. Unknown recipe keys must fail; recipes cannot alter constants, conditions,
fields, store/call effects, iteration bounds, or the algorithm.
