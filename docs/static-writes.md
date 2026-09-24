# Static executable-write audit

This inventory is derived from recovered instruction operands. It runs no game code.
Direct CS targets are compared with identified instructions; other segments and
effective addresses remain unresolved. Disjointness is not proof that unknown bytes
can never execute. Implicit stack effects are counted separately.

## main

Explicit memory-write operands: 2065; direct CS targets: 204; unresolved address/segment: 1861; direct CS overlaps with identified code: 0.

## adlib

Explicit memory-write operands: 51; direct CS targets: 0; unresolved address/segment: 51; direct CS overlaps with identified code: 0.

## roland

Explicit memory-write operands: 38; direct CS targets: 0; unresolved address/segment: 38; direct CS overlaps with identified code: 0.
