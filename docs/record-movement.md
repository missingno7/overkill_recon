# Record searches and coordinate adjustment

This batch follows Tandy address facts back into generic record updates. It does
not name the controlled record as a player, enemy or projectile. All names and EQU
constants are modern reconstruction choices. Evidence is in
`metadata/record-movement.json`; original-code tests are in `tests/test_records.py`.

## Two searches, not allocators

| Routine | Pool | Count | Stride | Cursor |
|---|---|---:|---:|---|
| FindFreeRecordPoolA (7524) | DS:23B4..2B5B | 35 | 38h | DS:95D8 |
| FindFreeRecordPoolB (7573) | DS:2B5C..32CB | 34 | 38h | DS:95DA |

Both return the first record whose word at offset0 is zero. Success updates the
cursor to that record and leaves its contents unchanged. BX is the record offset;
CX is count minus skipped records. Failure returns BX=FFFF and CX=0, leaving the
cursor unchanged. Subsequent callers perform activation, for example7429/A6D3.

The wrap order differs. Pool A reads its incoming cursor before advancing and
wrapping. Pool B normalizes an exact end pointer before reading. Neither validates
arbitrary pointers. Tests cover every valid starting cursor and single free slot,
full pools, untouched record bytes, and this end-pointer difference.

Most known call sites compare BX withFFFF immediately, so the search's flags are
dead at those sites. C450 andD1AE instead use BX without checking failure. Their
capacity/lifetime preconditions remain unresolved. CX is modified; no global
claim is made that it is dead. The search ABI must not be weakened on that basis.

## Field meaning supported by another subsystem

Tandy30D2 uses record+2 as an index into a row-offset table, then adds record+4/2.
The table initializer0F15 includes a16-row bias. This supports REC_Y at+2 and
REC_X at+4, rather than choosing coordinate names solely from movement limits.
The coordinate frame and signed domain outside these callers remain open.
REC_STATUS at+0 means only that zero qualifies as free in these searches; the
complete set of nonzero states has not been recovered. Record type/owner names
remain unknown.

The maintained ASM now uses these offsets in reviewed movement, search, spawn-like
initialization and Tandy address contexts. It also uses explicit pool constants,
input-bit names and address-qualified state-cell names. Numeric provenance remains
on each instruction. No original STRUCT, include name or module boundary is claimed.

## Guarded double steps

A5EA, A5F9 andA607 contain a CALL with displacement zero: the call target is also
the pushed return IP. After the inner helper returns, execution enters that same
helper again and eventually returns to the outer caller. These apply two one-step
operations, not one unguarded two-unit update. For example Y=BFh advances toC0h
and stays there on the second guarded increment; X=1 decrements to0 and stays0.
A5D1 follows this pattern only when DS:A47C is zero; otherwise it decrements Y once
without checking the lower guard. This can wrap0 toFFFF.

These wrappers remain ASM_COUPLED. Their whole normal-entry behavior is testable,
but their physical CALL/fallthrough structure and stack behavior are retained.
General registers and segments survive; arithmetic flags change. At the reviewed
9B2E/9C01 callers, a TEST/CMP/XOR overwrites those flags before observation. That is
caller-specific liveness evidence, not flag preservation.

## Closing the nine-way dispatch

Starting at9C01, optional input/state conditions first apply two-step X changes.
Then AX is cleared. Two independent sentinel tests may increment AH, and two may
increment AL. Each count is therefore0..2, including when the underlying word is
zero (onlyFFFF means absent). The index is AL+3*AH, giving exactly nine table entries
at9C70..9C81. The analyzer recognizes this exact reviewed instruction sequence and
follows all targets; it no longer lists9C6B as unresolved under normal entry.

Equal counts return through the shared RET at44AF. A one-count difference causes
a guarded one-step adjustment unless DS:2324 equals1. A two-count difference causes
a guarded one-step adjustment regardless of that gate. AH>AL increments X; AH<AL
decrements X. The flag DS:A360 records taking an adjustment path even when a bound
prevents the coordinate from changing. The downstream9CF1 tests that flag.

Tests cover all16 sentinel combinations, gates0/1/2, automatic adjustment ordering,
coordinate limits and separate DS/SS. The proof assumes normal entry through9C01
and preserved registers across interrupts; it is not a guarantee for arbitrary
mid-block jumps or memory corruption. Internal branch entries9C82/9C93/9C9C/9CAD
stay internal, rather than being counted as four invented independent functions.

52 previously opaque bytes now have instruction source. The18-byte pointer table
is explicit DW source with named CS-relative targets, counted as reviewed data,
not code. Original main and audio-module byte identities remain unchanged.

## Concern classification and next questions

The searches and coordinate adjustments are GAME_LOGIC for this local classification:
they operate on game records without hardware access or video-selector branches.
The broader9B2E caller is MIXED: it calls platform input polling before record/state
updates and has substantial unreviewed behavior. The Tandy address/copy leaves and
reviewed AdLib routines remain PLATFORM_LOGIC. Other unreviewed roles stay UNKNOWN.

The next useful bridge is9CF1's position-history consumer, plus BD0D's pool-reuse
path and the unchecked search callers. These can clarify record lifetime and
coordinate relationships without further gameplay replay or backend archaeology.
No C, port interface or future engine design has been introduced.
