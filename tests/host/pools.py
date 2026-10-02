"""Native pool and fixed-word-cycle checks against the exact DOS ASM oracle.

Run ``python tests/host/pools.py`` to build the host core and run the suite, or pass
``--no-build`` to reuse ``build/host`` and the exact oracle artifacts. The pool routines
return native pointers into the borrowed DS window; every result is mapped back to its
16-bit DOS offset before comparison with the ASM BX result.
"""
from __future__ import annotations

import argparse
import ctypes
import importlib.util
from pathlib import Path
import random
import struct
import sys
import time

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
HOST_DIR = ROOT / "build/host"
HOST_CORE = HOST_DIR / ("OVERKILL_CORE.dll" if sys.platform == "win32"
                        else "liboverkill_core.so")
HOST_STATE = HOST_DIR / "STATE.BIN"
STATE_BYTES = 0x10000
SEED = 0x504F4F4C
NO_RECORD = 0xFFFF

sys.path.insert(0, str(TOOLS))
from world import K  # noqa: E402


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _bind_pool_signatures(h) -> None:
    h.lib.next_random_word.argtypes = ()
    h.lib.next_random_word.restype = ctypes.c_uint16
    for name in ("find_free_record_pool_a", "find_free_record_pool_b"):
        fn = getattr(h.lib, name)
        fn.argtypes = ()
        fn.restype = ctypes.c_void_p

    h.lib.overkill_ds_address.argtypes = (ctypes.c_uint16,)
    h.lib.overkill_ds_address.restype = ctypes.c_void_p
    h.lib.overkill_ds_offset.argtypes = (ctypes.c_void_p,)
    h.lib.overkill_ds_offset.restype = ctypes.c_uint16


def _read_word(h, name: str) -> int:
    return struct.unpack_from("<H", h.state_storage.snapshot(), h.offset(name))[0]


def _write_word(h, name: str, value: int) -> None:
    h.write_symbol(name, struct.pack("<H", value & 0xFFFF))


def _check_ds_pointer_mapping(h) -> int:
    """Exercise every offset and the production one-past-end conversion rule."""
    checks = 0
    for offset in range(STATE_BYTES):
        pointer = h.lib.overkill_ds_address(offset)
        expected_pointer = h.state_addr + offset
        if pointer != expected_pointer:
            raise AssertionError(
                f"DS address {offset:04X}: native={pointer!r}, expected={expected_pointer:#x}")
        actual_offset = int(h.lib.overkill_ds_offset(ctypes.c_void_p(pointer)))
        if actual_offset != offset:
            raise AssertionError(
                f"DS round-trip {offset:04X}: native offset={actual_offset:04X}")
        checks += 1

    # This is the sole address outside the byte range accepted by GAME_OFFSET: a pool
    # end marker may be one-past the borrowed window and DOS word conversion wraps it.
    one_past = ctypes.c_void_p(h.state_addr + STATE_BYTES)
    if h.lib.overkill_ds_offset(one_past) != 0:
        raise AssertionError("one-past DS address did not wrap to DOS offset 0000")
    h.compare("GAME address/offset adapter")
    return checks + 1


def _run_random_word(h, cursor: int, name: str) -> None:
    base = h.offset("CreditRandomWords")
    byte_count = h.offset("CheckpointScriptCursor") - base
    if byte_count <= 0 or byte_count & 1:
        raise AssertionError(f"unexpected CreditRandomWords span: {byte_count}")

    h.reset()
    _write_word(h, "RandomWordCursor", cursor)
    before = h.state_storage.snapshot()

    # Mirror only the documented add-by-two/equality-boundary calculation to assert
    # that each fixture reached the intended word, then differential-check all DS.
    next_cursor = (cursor + 2) & 0xFFFF
    if next_cursor >= base + byte_count - 1:
        next_cursor = base
    if next_cursor >= STATE_BYTES - 1:
        raise AssertionError(f"{name}: fixture would read beyond DS: {next_cursor:04X}")
    expected_word = struct.unpack_from("<H", before, next_cursor)[0]

    native_word = int(h.lib.next_random_word())
    oracle = h.m.call("NextRandomWord")
    if native_word != oracle["BX"] or native_word != expected_word:
        raise AssertionError(
            f"NextRandomWord {name}: native={native_word:04X}, "
            f"ASM BX={oracle['BX']:04X}, expected={expected_word:04X}")
    if _read_word(h, "RandomWordCursor") != next_cursor:
        raise AssertionError(f"NextRandomWord {name}: wrong final cursor")
    h.compare(f"NextRandomWord {name}")


def _run_random_cycle(h) -> int:
    base = h.offset("CreditRandomWords")
    byte_count = h.offset("CheckpointScriptCursor") - base
    count = byte_count // 2
    cursors = [(base + 2 * index, f"cycle word {index}") for index in range(count)]
    cursors += [
        (base - 2, "stale before table"),
        (base - 1, "stale odd before table"),
        (base + byte_count - 1, "last byte boundary"),
        (base + byte_count, "past table boundary"),
        (0xFFFD, "high stale wraps to boundary"),
        (0xFFFE, "high stale arithmetic wrap"),
        (0xFFFF, "odd high stale arithmetic wrap"),
        (0, "low stale DS offset"),
    ]
    for cursor, name in cursors:
        _run_random_word(h, cursor, name)
    return len(cursors)


def _pool_info(h, pool: str) -> tuple[str, str, int]:
    if pool == "A":
        return "PoolA", "PoolACursor", K.POOL_A_COUNT
    if pool == "B":
        return "PoolB", "PoolBCursor", K.POOL_B_COUNT
    raise ValueError(pool)


def _seed_statuses(h, pool: str, statuses: list[int]) -> int:
    start_name, _cursor_name, count = _pool_info(h, pool)
    if len(statuses) != count:
        raise ValueError(f"pool {pool} expects {count} status words")
    start = h.offset(start_name)
    for index, status in enumerate(statuses):
        h.write(start + index * K.RECORD_SIZE + K.REC_STATUS,
                struct.pack("<H", status & 0xFFFF))
    return start


def _native_pool_offset(h, native_pointer) -> int:
    if native_pointer is None:
        raise AssertionError("pool routine returned a null pointer instead of DS:FFFF sentinel")
    return int(h.lib.overkill_ds_offset(ctypes.c_void_p(native_pointer)))


def _run_pool(h, pool: str, name: str, *, expected_cursor: int | None = None,
              expected_result: int | None = None) -> None:
    start_name, cursor_name, _count = _pool_info(h, pool)
    entry = f"find_free_record_pool_{pool.lower()}"
    label = f"FindFreeRecordPool{pool}"
    native_result = _native_pool_offset(h, getattr(h.lib, entry)())
    oracle = h.m.call(label)
    if native_result != oracle["BX"]:
        raise AssertionError(
            f"{label} {name}: native DS offset={native_result:04X}, "
            f"ASM BX={oracle['BX']:04X}")
    if expected_result is not None and native_result != expected_result:
        raise AssertionError(
            f"{label} {name}: returned {native_result:04X}, expected {expected_result:04X}")
    if expected_cursor is not None and _read_word(h, cursor_name) != expected_cursor:
        raise AssertionError(
            f"{label} {name}: cursor={_read_word(h, cursor_name):04X}, "
            f"expected {expected_cursor:04X}")
    h.compare(f"{label} {name}")


def _run_each_free_position(h, pool: str) -> int:
    start_name, cursor_name, count = _pool_info(h, pool)
    start = h.offset(start_name)
    checks = 0
    for free_index in range(count):
        h.reset()
        statuses = [1] * count
        statuses[free_index] = 0
        _seed_statuses(h, pool, statuses)
        cursor_index = (free_index - 1) % count
        cursor = start + cursor_index * K.RECORD_SIZE
        _write_word(h, cursor_name, cursor)
        expected = start + free_index * K.RECORD_SIZE
        _run_pool(h, pool, f"only free slot {free_index} from preceding cursor",
                  expected_cursor=expected, expected_result=expected)
        checks += 1
    return checks


def _run_full_pool_cursor_sweep(h, pool: str) -> int:
    start_name, cursor_name, count = _pool_info(h, pool)
    start = h.offset(start_name)
    checks = 0
    for cursor_index in range(count):
        h.reset()
        _seed_statuses(h, pool, [1] * count)
        cursor = start + cursor_index * K.RECORD_SIZE
        _write_word(h, cursor_name, cursor)
        _run_pool(h, pool, f"full pool from cursor {cursor_index}",
                  expected_cursor=cursor, expected_result=NO_RECORD)
        checks += 1
    return checks


def _run_random_pool_patterns(h, pool: str, rng: random.Random, trials: int = 64) -> int:
    start_name, cursor_name, count = _pool_info(h, pool)
    start = h.offset(start_name)
    checks = 0
    for trial in range(trials):
        h.reset()
        statuses = [rng.choice((0, 1, 0x00FF, 0xFFFF)) for _ in range(count)]
        _seed_statuses(h, pool, statuses)
        cursor_index = rng.randrange(count)
        cursor = start + cursor_index * K.RECORD_SIZE
        _write_word(h, cursor_name, cursor)
        _run_pool(h, pool, f"seeded status pattern {trial}")
        checks += 1
    return checks


def _run_pool_boundaries(h) -> int:
    checks = 0

    # Pool B normalizes the end marker before its first status read. A free first slot
    # is returned from the one-past cursor; a full pool leaves that marker untouched.
    b_start = h.offset("PoolB")
    b_end = h.offset("PoolBEnd")
    for statuses, expected_result, expected_cursor, name in (
            ([0] + [1] * (K.POOL_B_COUNT - 1), b_start, b_start, "PoolBEnd wraps to free first"),
            ([1] * K.POOL_B_COUNT, NO_RECORD, b_end, "PoolBEnd full cursor preserved")):
        h.reset()
        _seed_statuses(h, "B", statuses)
        _write_word(h, "PoolBCursor", b_end)
        _run_pool(h, "B", name, expected_cursor=expected_cursor,
                  expected_result=expected_result)
        checks += 1

    # Pool A tests its end only after advancing. PoolAEnd aliases PoolB's first record,
    # so this valid but stale cursor observes that slot before any wrap.
    h.reset()
    _seed_statuses(h, "A", [1] * K.POOL_A_COUNT)
    _seed_statuses(h, "B", [0] + [1] * (K.POOL_B_COUNT - 1))
    a_end = h.offset("PoolAEnd")
    _write_word(h, "PoolACursor", a_end)
    _run_pool(h, "A", "stale PoolA cursor at valid PoolAEnd/PoolB address",
              expected_cursor=b_start, expected_result=b_start)
    return checks + 1


def run(no_build: bool = False) -> int:
    if no_build:
        if not HOST_CORE.is_file() or not HOST_STATE.is_file():
            raise FileNotFoundError("--no-build requires the current build/host core and STATE.BIN")
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    harness = _load_module("host_input_harness_pools", ROOT / "tests/host/input.py")
    h = harness.HostHarness()
    _bind_pool_signatures(h)

    started = time.perf_counter()
    mapping = _check_ds_pointer_mapping(h)
    random_cycle = _run_random_cycle(h)
    rng = random.Random(SEED)
    pool_checks = 0
    for pool in ("A", "B"):
        pool_checks += _run_each_free_position(h, pool)
        pool_checks += _run_full_pool_cursor_sweep(h, pool)
        pool_checks += _run_random_pool_patterns(h, pool, rng)
    pool_checks += _run_pool_boundaries(h)
    h.check_canaries()

    total = mapping + random_cycle + pool_checks
    elapsed = time.perf_counter() - started
    print(f"PASS host pools: {mapping} DS pointer conversions, {random_cycle} random-cycle cases, "
          f"{pool_checks} pool cases ({total} checks) in {elapsed:.1f}s")
    return total


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="require and reuse build/host and build/oracle-sym artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
