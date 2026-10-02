"""Native movement policy checks against the exact DOS ASM oracle.

Run ``python tests/host/movement.py --no-build`` to reuse build/host and the pinned
oracle artifacts. Every operation shares one borrowed 64 KiB DS window with the native
core; the emulator gets the same starting bytes and the full state windows are compared,
apart from the oracle's stack scratch area.
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
from types import SimpleNamespace

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
TESTS = ROOT / "tests"
sys.path.insert(0, str(TOOLS))
sys.path.insert(0, str(TESTS))

from emu import FLAG  # noqa: E402
from world import K  # noqa: E402


RECORD_BYTES = K.RECORD_SIZE
ORACLE_SEED = 0x0F67C9B


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _bind_movement_signatures(h) -> None:
    for name in ("steer_toward_target", "aim_at_player", "step_along_delta"):
        fn = getattr(h.lib, name)
        fn.argtypes = (ctypes.c_void_p,)
        fn.restype = None
    h.lib.steer_to_saved.argtypes = (ctypes.c_void_p,)
    h.lib.steer_to_saved.restype = ctypes.c_uint16
    h.lib.move_in_direction.argtypes = (ctypes.c_void_p, ctypes.c_uint16)
    h.lib.move_in_direction.restype = None
    h.lib.set_delta_toward.argtypes = (ctypes.c_void_p, ctypes.c_void_p)
    h.lib.set_delta_toward.restype = None


def _native_record(h, offset: int) -> ctypes.c_void_p:
    if not 0 <= offset <= 0x10000 - RECORD_BYTES:
        raise ValueError(f"record pointer is outside borrowed DS: {offset:04X}")
    return ctypes.c_void_p(h.state_addr + offset)


def _run_owned_entries(h) -> int:
    """Run every existing DOS movement case against its matching host C entry."""
    suite = _load_module("dos_movement_cases", TESTS / "movement.py")
    pair = SimpleNamespace(sym=h.offset)
    rng = random.Random(ORACLE_SEED)
    native = {
        "SteerTowardTarget": h.lib.steer_toward_target,
        "SteerToSaved": h.lib.steer_to_saved,
        "AimAtPlayer": h.lib.aim_at_player,
        "StepAlongDelta": h.lib.step_along_delta,
    }
    count = 0
    for case in suite.cases(rng, 1, pair):
        h.reset()
        for offset, data in case.writes:
            h.write(offset, data)

        # The oracle uses its real register ABI; C receives the same record address in
        # the borrowed state window and reads/writes all globals through that same window.
        oracle_regs = h.m.call(case.label, case.regs)
        bp = case.regs.get("BP", 0) & 0xFFFF
        bx = case.regs.get("BX", 0) & 0xFFFF
        record = _native_record(h, bx if case.label == "AimAtPlayer" else bp)
        if case.label == "SteerToSaved":
            result = int(native[case.label](record))
            oracle_result = 0 if oracle_regs["FLAGS"] & FLAG["ZF"] else 1
            if result != oracle_result:
                raise AssertionError(
                    f"{case.label} {case.name}: native result {result} disagrees with "
                    f"oracle ZF-derived result {oracle_result}")
            arrived = ctypes.c_uint16.from_address(
                h.state_addr + h.offset("SteerArrived")).value
            if result != arrived:
                raise AssertionError(
                    f"{case.label} {case.name}: native result {result} != SteerArrived {arrived}")
        else:
            native[case.label](record)
        h.compare(f"{case.label} {case.name}")
        count += 1
    return count


def _write_record(h, offset: int, *, x: int, y: int, direction: int,
                  size_class: int | None = None) -> None:
    data = bytearray(h.baseline[offset:offset + RECORD_BYTES])
    struct.pack_into("<H", data, K.REC_Y, y & 0xFFFF)
    struct.pack_into("<H", data, K.REC_X, x & 0xFFFF)
    struct.pack_into("<H", data, K.REC_DIRECTION, direction & 0xFFFF)
    if size_class is not None:
        struct.pack_into("<H", data, K.REC_SIZE_CLASS, size_class & 0xFFFF)
    h.write(offset, data)


def _run_direction_steps(h) -> int:
    """Compare C's generic n-pixel step with each original fixed-stride ASM entry."""
    at = h.offset("PrimaryRecord")
    values = (0, 1, 2, 0x7FFF, 0x8000, 0xFFFE, 0xFFFF)
    entries = (("MoveInDirection1", 1), ("MoveInDirection2", 2),
               ("MoveInDirection3", 3), ("MoveInDirection4", 4),
               ("MoveInDirection8", 8))
    count = 0
    for label, pixels in entries:
        for direction in range(8):
            for x in values:
                for y in values:
                    h.reset()
                    _write_record(h, at, x=x, y=y, direction=direction)
                    h.m.call(label, {"BP": at})
                    h.lib.move_in_direction(_native_record(h, at), pixels)
                    h.compare(f"{label} direction={direction} x={x:04X} y={y:04X}")
                    count += 1
    return count


def _run_set_delta_toward(h) -> int:
    """Compare the former BP/BX helper with C pointers on wrap and class boundaries."""
    self_at = h.offset("PrimaryRecord")
    target_at = h.offset("PoolA")
    positions = (0, 1, 0x0B, 0x7FFF, 0x8000, 0xFFF0, 0xFFFC, 0xFFFF)
    classes = (1, 0, 2, 0xFFFF)
    count = 0
    for size_class in classes:
        for self_x in positions:
            for self_y in positions:
                for target_x in positions:
                    for target_y in positions:
                        h.reset()
                        _write_record(h, self_at, x=self_x, y=self_y, direction=0)
                        _write_record(h, target_at, x=target_x, y=target_y,
                                      direction=0, size_class=size_class)
                        h.m.call("SetDeltaToward", {"BP": self_at, "BX": target_at})
                        h.lib.set_delta_toward(_native_record(h, self_at),
                                               _native_record(h, target_at))
                        h.compare(
                            f"SetDeltaToward class={size_class:04X} "
                            f"self={self_x:04X},{self_y:04X} "
                            f"target={target_x:04X},{target_y:04X}")
                        count += 1
    return count


def run(no_build: bool = False) -> int:
    if not no_build:
        import host as host_build
        host_build.build()

    harness_module = _load_module("host_input_harness", ROOT / "tests/host/input.py")
    h = harness_module.HostHarness()
    _bind_movement_signatures(h)
    start = time.perf_counter()
    owned = _run_owned_entries(h)
    directions = _run_direction_steps(h)
    delta = _run_set_delta_toward(h)
    h.check_canaries()
    elapsed = time.perf_counter() - start
    total = owned + directions + delta
    print(f"PASS host movement: {owned} bridged cases, {directions} direction steps, "
          f"{delta} delta-target cases ({total} checks) in {elapsed:.1f}s")
    return total


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="require and reuse build/host and build/oracle-sym artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
