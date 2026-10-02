"""Native pod-positioning and pod-motion leaves against the exact DOS oracle.

Run ``python tests/host/pod_motion.py`` to build the host core and compare the pod
helpers with their original ASM entries. ``--no-build`` reuses the current host core.
Each call starts with the same 64 KiB DS image and compares the complete state window,
apart from the oracle's physical stack scratch area.
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
MAP_SEGMENT = 0x9000
MAP_LINEAR = MAP_SEGMENT << 4
SEED = 0x504F444D
NO_SLOT = 0xFFFF

sys.path.insert(0, str(TOOLS))
from emu import FLAG  # noqa: E402
from world import K  # noqa: E402


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


class BorrowedMap:
    """Guarded 64 KiB map window borrowed by the native terrain adapter."""

    def __init__(self) -> None:
        guard = 16
        self.raw = (ctypes.c_ubyte * (STATE_BYTES + 2 * guard + 2))()
        self.address = ctypes.addressof(self.raw) + guard + 1
        self.before = (self.address - guard, guard)
        self.after = (self.address + STATE_BYTES, guard)
        ctypes.memset(self.before[0], 0xA7, guard)
        ctypes.memset(self.after[0], 0x5C, guard)
        self.expected = bytes(STATE_BYTES)
        self.load(self.expected)

    def load(self, data: bytes) -> None:
        if len(data) != STATE_BYTES:
            raise ValueError("level map must be exactly 64 KiB")
        ctypes.memmove(self.address, data, STATE_BYTES)
        self.expected = bytes(data)

    def check(self, label: str) -> None:
        if ctypes.string_at(*self.before) != bytes([0xA7]) * self.before[1]:
            raise AssertionError(f"{label}: native code wrote before the borrowed map")
        if ctypes.string_at(*self.after) != bytes([0x5C]) * self.after[1]:
            raise AssertionError(f"{label}: native code wrote after the borrowed map")
        actual = ctypes.string_at(self.address, STATE_BYTES)
        if actual != self.expected:
            mismatch = next(i for i, (got, want) in enumerate(zip(actual, self.expected))
                            if got != want)
            raise AssertionError(
                f"{label}: native code changed map byte {mismatch:04X}: "
                f"{actual[mismatch]:02X} != {self.expected[mismatch]:02X}")


def _record_pointer(h, offset: int) -> ctypes.c_void_p:
    if not 0 <= offset <= STATE_BYTES - K.RECORD_SIZE:
        raise ValueError(f"record pointer is outside borrowed DS: {offset:04X}")
    return ctypes.c_void_p(h.state_addr + offset)


def _wrapped_record_pointer(h) -> ctypes.c_void_p:
    """The DOS word pointer FFFFh, used only by leaves with documented wrapped fields."""
    return ctypes.c_void_p(h.state_addr + NO_SLOT)


def _write_record(h, offset: int, rng: random.Random, **fields: int) -> None:
    """Give all unowned words distinct stale values, then set the named record fields."""
    data = bytearray(rng.randrange(256) for _ in range(K.RECORD_SIZE))
    for name, value in fields.items():
        field = getattr(K, "REC_" + name.upper())
        struct.pack_into("<H", data, field, value & 0xFFFF)
    h.write(offset, data)


def _put_word(h, name: str, value: int) -> None:
    h.write_symbol(name, struct.pack("<H", value & 0xFFFF))


def _put_byte(h, name: str, value: int) -> None:
    h.write_symbol(name, bytes((value & 0xFF,)))


def _bind_signatures(h) -> None:
    pointer = ctypes.c_void_p
    for name in ("init_pod_record", "place_side_pods", "dec_record_x_unless_zero",
                 "inc_record_x_below_max", "dec_record_x_twice", "inc_record_x_twice",
                 "adjust_record_x_from_counts", "pod_take_hit", "pod_terrain_hit",
                 "store_record_saved_position", "demo_launch_pod",
                 "demo_launch_trailing_pod"):
        fn = getattr(h.lib, name)
        fn.argtypes = (pointer,)
        fn.restype = ctypes.c_uint16 if name in ("pod_take_hit", "pod_terrain_hit") else None
    h.lib.place_record_from_offset_pair.argtypes = (pointer, pointer, pointer)
    h.lib.place_record_from_offset_pair.restype = None
    h.lib.demo_step_next_ship_form.argtypes = ()
    h.lib.demo_step_next_ship_form.restype = None


def _compare_leaf(h, label: str, native_name: str, regs: dict[str, int],
                  args: tuple = (), *, carry_result: bool = False) -> None:
    oracle = h.m.call(label, regs)
    native_result = getattr(h.lib, native_name)(*args)
    if carry_result:
        native_cf = int(native_result) & 1
        oracle_cf = 1 if oracle["FLAGS"] & FLAG["CF"] else 0
        if native_cf != oracle_cf:
            raise AssertionError(
                f"{label}: native CF={native_cf}, oracle CF={oracle_cf}")
    h.compare(label)


def _pair_cases(h, rng: random.Random) -> int:
    """Cover table forms, signed clamps, wrapped arithmetic and the FFFFh no-op."""
    anchor_at = h.offset("PrimaryRecord")
    pod_at = h.offset("PoolA")
    tables = ("SidePodOffsetsRightOuter", "SidePodOffsetsRightInner",
              "SidePodOffsetsLeftOuter", "SidePodOffsetsLeftInner")
    anchor_xs = (0, 1, 0x0F, 0x10, 0x20, 0x7F, 0x80, 0xA8,
                 0xB0, 0xB8, 0xC0, 0xD0, 0x7FFF, 0x8000, 0xFFF8, 0xFFFF)
    spreads = (0, 1, 8, 0xFFF8)
    checks = 0
    for table_index, table in enumerate(tables):
        table_at = h.offset(table)
        table_pointer = ctypes.c_void_p(h.state_addr + table_at)
        for sprite in range(4):
            for x_index, x in enumerate(anchor_xs):
                h.reset()
                _write_record(h, anchor_at, rng, sprite=sprite, x=x,
                              y=(0xFFF0 + x_index * 7) & 0xFFFF)
                _write_record(h, pod_at, rng, x=0x7777, y=0x8888)
                spread = spreads[(table_index + sprite + x_index) % len(spreads)]
                _put_word(h, "OffsetXWork", spread)
                _put_byte(h, "ClampXLowSeen", 1)
                _put_byte(h, "ClampXHighSeen", 1)
                _compare_leaf(
                    h, "PlaceRecordFromOffsetPair", "place_record_from_offset_pair",
                    {"BP": anchor_at, "BX": pod_at, "SI": table_at},
                    (_record_pointer(h, pod_at), table_pointer,
                     _record_pointer(h, anchor_at)))
                checks += 1

    # A missing slot is tested by the actual FFFFh DOS token. It must return before
    # attempting to convert or dereference the corresponding native address.
    h.reset()
    _write_record(h, anchor_at, rng, sprite=3, x=0xB0, y=0x80)
    _put_word(h, "OffsetXWork", 8)
    before = h.state_storage.snapshot()
    h.m.call("PlaceRecordFromOffsetPair", {"BP": anchor_at, "BX": NO_SLOT,
                                           "SI": h.offset(tables[0])})
    h.lib.place_record_from_offset_pair(
        ctypes.c_void_p(h.state_addr + NO_SLOT),
        ctypes.c_void_p(h.state_addr + h.offset(tables[0])),
        _record_pointer(h, anchor_at))
    if h.state_storage.snapshot() != before:
        raise AssertionError("PlaceRecordFromOffsetPair FFFFh slot was not a no-op")
    h.compare("PlaceRecordFromOffsetPair FFFFh slot")
    return checks + 1


def _side_placement_cases(h, rng: random.Random) -> int:
    anchor_at = h.offset("PrimaryRecord")
    slot_names = ("SidePodLeftInner", "SidePodRightInner",
                  "SidePodLeftOuter", "SidePodRightOuter")
    pod_offsets = tuple(h.offset("PoolA") + i * K.RECORD_SIZE for i in range(4))
    masks = (0, 0xF, 0x5, 0xA, 0x3, 0xC, 0x9, 0x6, 0x7, 0xB, 0xD, 0xE)
    xs = (0, 1, 0x10, 0xA8, 0xB0, 0xC0, 0xFFF8, 0x8000)
    checks = 0
    for index in range(128):
        h.reset()
        sprite = index % 4
        x = xs[(index // 4) % len(xs)]
        _write_record(h, anchor_at, rng, sprite=sprite, x=x,
                      y=(0xFFF0 + index * 13) & 0xFFFF)
        mask = masks[index % len(masks)]
        for slot_index, name in enumerate(slot_names):
            if mask & (1 << slot_index):
                _write_record(h, pod_offsets[slot_index], rng, x=0x7777, y=0x8888)
                _put_word(h, name, pod_offsets[slot_index])
            else:
                _put_word(h, name, NO_SLOT)
        _put_word(h, "SidePodSpreadRight", (0, 1, 8, 0xFFF8)[index % 4])
        _put_word(h, "SidePodSpreadLeft", (0, 0xFFFF, 4, 0xFFF0)[index % 4])
        _compare_leaf(h, "PlaceSidePods", "place_side_pods", {"BP": anchor_at},
                      (_record_pointer(h, anchor_at),))
        checks += 1
    return checks


def _x_step_cases(h, rng: random.Random) -> int:
    at = h.offset("PrimaryRecord")
    operations = (("DecRecordXUnlessZero", "dec_record_x_unless_zero"),
                  ("IncRecordXBelowMax", "inc_record_x_below_max"),
                  ("DecRecordXTwice", "dec_record_x_twice"),
                  ("IncRecordXTwice", "inc_record_x_twice"))
    edge = (0, 1, 2, 0xAE, 0xAF, 0xB0, 0xB1, 0xC0, 0x7FFF, 0x8000, 0xFFFF)
    checks = 0
    for label, native in operations:
        for x in edge:
            h.reset()
            _write_record(h, at, rng, x=x)
            _compare_leaf(h, label, native, {"BP": at}, (_record_pointer(h, at),))
            checks += 1
        for _ in range(15):
            h.reset()
            x = rng.randrange(0x10000)
            _write_record(h, at, rng, x=x)
            _compare_leaf(h, label, native, {"BP": at}, (_record_pointer(h, at),))
            checks += 1
    return checks


def _adjust_cases(h, rng: random.Random) -> int:
    at = h.offset("PrimaryRecord")
    slots = ("SidePodLeftInner", "SidePodRightInner",
             "SidePodLeftOuter", "SidePodRightOuter")
    xs = (0, 1, 0xAF, 0xB0, 0xB1, 0xC0, 0xFFFF, 0x8000)
    checks = 0
    # Every side-pod count balance and both parities, with input/clamp combinations
    # rotating through the full four control-bit states.
    for mask in range(16):
        for parity in range(2):
            index = mask * 2 + parity
            h.reset()
            _write_record(h, at, rng, x=xs[index % len(xs)])
            for bit, name in enumerate(slots):
                _put_word(h, name, h.offset("PoolA") + bit * K.RECORD_SIZE
                          if mask & (1 << bit) else NO_SLOT)
            _put_word(h, "FrameParity", parity)
            _put_byte(h, "InputBits", (0, K.IN_XMINUS, K.IN_XPLUS,
                                        K.IN_XMINUS | K.IN_XPLUS)[index % 4])
            _put_byte(h, "ClampXLowSeen", (index >> 1) & 1)
            _put_byte(h, "ClampXHighSeen", (index >> 2) & 1)
            _compare_leaf(h, "AdjustRecordXFromCounts", "adjust_record_x_from_counts",
                          {"BP": at}, (_record_pointer(h, at),))
            checks += 1
    # Random cross-products catch combined edge correction plus balance nudges.
    for index in range(150):
        h.reset()
        _write_record(h, at, rng, x=rng.choice(xs) if index & 1 else rng.randrange(0x10000))
        mask = rng.randrange(16)
        for bit, name in enumerate(slots):
            _put_word(h, name, h.offset("PoolA") + bit * K.RECORD_SIZE
                      if mask & (1 << bit) else NO_SLOT)
        _put_word(h, "FrameParity", rng.randrange(2))
        _put_byte(h, "InputBits", rng.randrange(4))
        _put_byte(h, "ClampXLowSeen", rng.randrange(2))
        _put_byte(h, "ClampXHighSeen", rng.randrange(2))
        _compare_leaf(h, "AdjustRecordXFromCounts", "adjust_record_x_from_counts",
                      {"BP": at}, (_record_pointer(h, at),))
        checks += 1
    return checks


def _pod_hit_cases(h, rng: random.Random) -> int:
    at = h.offset("PoolA")
    checks = 0
    for difficulty in (0, 1, 2, 0xFFFF):
        for parity in (0, 1, 2):
            for hp in (0, 1, 2, 0xFFFF):
                for sfx in (0, 1):
                    h.reset()
                    _write_record(h, at, rng, hit_points=hp,
                                  flash_timer=rng.randrange(0x10000))
                    _put_word(h, "DifficultySetting", difficulty)
                    _put_word(h, "FrameParity", parity)
                    _put_byte(h, "SfxEnabled", sfx)
                    _put_byte(h, "SfxRequest", 0x55)
                    _compare_leaf(h, "PodTakeHit", "pod_take_hit", {"BP": at},
                                  (_record_pointer(h, at),), carry_result=True)
                    checks += 1
    return checks


def _grid_cell(x: int, y: int, scroll_sub: int, map_scroll: int) -> int:
    total = (y + scroll_sub) & 0xFFFF
    if total & 0x8000:
        return 0xFFFF
    return (map_scroll - (total >> 4) * K.MAP_ROW_BYTES + (x >> 4)) & 0xFFFF


def _terrain_cases(h, view: BorrowedMap) -> int:
    at = h.offset("PoolA")
    x_values = (0x20, 0x21, 0x2F, 0xC0, 0xC1, 0xFFFF)
    y_values = (0x50, 0x5F, 0xFFF0, 0x8000)
    scroll_values = (0, 1, 15, 0xFFFF)
    # 128 fixtures cover open/solid lower cells, the conditional right neighbor,
    # negative-grid wrap, and the two early-return gates.
    for index in range(128):
        h.reset()
        x = x_values[index % len(x_values)]
        y = y_values[(index // 3) % len(y_values)]
        sub = scroll_values[(index // 2) % len(scroll_values)]
        map_scroll = (0, K.MAP_ROW_BYTES, 0x8000, 0xFFFF)[(index // 5) % 4]
        cell = (_grid_cell(x, y, sub, map_scroll) + K.MAP_ROW_BYTES) & 0xFFFF
        neighbor = (cell + 1) & 0xFFFF
        mode = index % 8
        map_data = bytearray(STATE_BYTES)
        attributes = bytearray(256)
        if mode in (1, 2, 3, 4, 5, 6, 7):
            attributes[1] = 1 if mode != 6 else 0x80
        if mode in (1, 4, 6, 7):
            map_data[cell] = 1
        if mode in (2, 3, 5, 6, 7):
            map_data[neighbor] = 1
        if mode == 3:
            # An aligned X ignores a solid right-hand cell.
            x = 0x20
            cell = (_grid_cell(x, y, sub, map_scroll) + K.MAP_ROW_BYTES) & 0xFFFF
            neighbor = (cell + 1) & 0xFFFF
            map_data[neighbor] = 1
        if mode == 6:
            # ComputeRecordGridOffset returns FFFFh on signed-negative Y; +13 wraps
            # to 000Ch, a specific table/map boundary worth preserving.
            y = 0xFFF0
            sub = 0
            x = 0x21
            cell = (0xFFFF + K.MAP_ROW_BYTES) & 0xFFFF
            neighbor = (cell + 1) & 0xFFFF
            map_data[cell] = 1
            map_data[neighbor] = 0
        _write_record(h, at, random.Random(SEED + index), x=x, y=y,
                      hit_points=(1, 0, 2)[index % 3], flash_timer=0x1234)
        _put_word(h, "ScrollSubRow", sub)
        _put_word(h, "MapScrollPos", map_scroll)
        _put_word(h, "LevelEndPhase", 1 if mode == 4 else 0)
        _put_word(h, "DemoActive", 1 if mode == 7 else 0)
        _put_word(h, "DifficultySetting", 2)
        _put_word(h, "FrameParity", index & 1)
        _put_byte(h, "SfxEnabled", index & 1)
        _put_byte(h, "SfxRequest", 0x55)
        h.write_symbol("ByteAttributeTable", bytes(attributes))
        view.load(bytes(map_data))
        h.m.u.mem_write(MAP_LINEAR, bytes(map_data))
        oracle = h.m.call("PodTerrainHit", {"BP": at})
        native = int(h.lib.pod_terrain_hit(_record_pointer(h, at))) & 1
        oracle_cf = 1 if oracle["FLAGS"] & FLAG["CF"] else 0
        if native != oracle_cf:
            raise AssertionError(
                f"PodTerrainHit #{index}: native CF={native}, oracle CF={oracle_cf}; "
                f"cell={cell:04X} neighbor={neighbor:04X} mode={mode}")
        h.compare(f"PodTerrainHit #{index}")
        view.check(f"PodTerrainHit #{index}")
    return 128


def _saved_position_cases(h, rng: random.Random) -> int:
    at = h.offset("PoolA")
    values = (0, 1, 0xB0, 0xC0, 0x7FFF, 0x8000, 0xFFF8, 0xFFFF)
    for index in range(16):
        h.reset()
        x, y = values[index % len(values)], values[(index * 3) % len(values)]
        _write_record(h, at, rng, x=x, y=y, saved_x=0xAAAA, saved_y=0x5555)
        _compare_leaf(h, "StoreRecordSavedPosition", "store_record_saved_position",
                      {"BP": at}, (_record_pointer(h, at),))
    h.reset()
    h.m.call("StoreRecordSavedPosition", {"BP": NO_SLOT})
    h.lib.store_record_saved_position(_wrapped_record_pointer(h))
    h.compare("StoreRecordSavedPosition FFFFh pointer")
    return 17


def _demo_launch_cases(h, rng: random.Random) -> int:
    pod_at = h.offset("PoolA")
    primary_at = h.offset("PrimaryRecord")
    values = (0, 1, 0xB0, 0xC0, 0x7FFF, 0x8000, 0xFFF8, 0xFFFF)
    checks = 0
    for index in range(32):
        h.reset()
        _write_record(h, pod_at, rng, x=values[index % len(values)],
                      y=values[(index * 3) % len(values)], type=0x14,
                      kind=K.KIND_POD)
        _compare_leaf(h, "DemoLaunchPod", "demo_launch_pod", {"BP": pod_at},
                      (_record_pointer(h, pod_at),))
        checks += 1

    # The original stores through FFFFh with word-wrapped DS field offsets. Keep this
    # bounded to the documented demo-launch leaves; other record routines require a
    # normal pool pointer.
    h.reset()
    h.m.call("DemoLaunchPod", {"BP": NO_SLOT})
    h.lib.demo_launch_pod(_wrapped_record_pointer(h))
    h.compare("DemoLaunchPod FFFFh pointer")
    checks += 1

    for index in range(32):
        h.reset()
        _write_record(h, primary_at, rng, x=values[(index * 3) % len(values)],
                      y=values[(index * 5) % len(values)], sprite=index % 4)
        _write_record(h, pod_at, rng, x=values[(index * 5 + 1) % len(values)],
                      y=values[(index + 3) % len(values)], type=0x14,
                      kind=K.KIND_POD)
        _compare_leaf(h, "DemoLaunchTrailingPod", "demo_launch_trailing_pod",
                      {"BP": pod_at}, (_record_pointer(h, pod_at),))
        checks += 1
    h.reset()
    primary_at = h.offset("PrimaryRecord")
    _write_record(h, primary_at, rng, x=0xFFFC, y=0xFFF0)
    h.m.call("DemoLaunchTrailingPod", {"BP": NO_SLOT})
    h.lib.demo_launch_trailing_pod(_wrapped_record_pointer(h))
    h.compare("DemoLaunchTrailingPod FFFFh pointer")
    checks += 1
    return checks


def _init_pod_cases(h, rng: random.Random) -> int:
    at = h.offset("PoolA")
    for index in range(16):
        h.reset()
        _write_record(h, at, rng, status=index, size_class=index ^ 0x55,
                      kind=K.KIND_TYPED, sprite=index, hit_points=index * 0x1111,
                      draw_pass=index ^ 0xFF)
        _compare_leaf(h, "InitPodRecord", "init_pod_record", {"BX": at},
                      (_record_pointer(h, at),))
    return 16


def _demo_next_form_cases(h, rng: random.Random) -> int:
    primary_at = h.offset("PrimaryRecord")
    slot_names = ("SidePodLeftInner", "SidePodRightInner",
                  "SidePodLeftOuter", "SidePodRightOuter")
    pod_offsets = tuple(h.offset("PoolA") + i * K.RECORD_SIZE for i in range(4))
    xs = (0, 1, 0xA8, 0xB0, 0xC0, 0x8000, 0xFFFF)
    for index in range(32):
        h.reset()
        _write_record(h, primary_at, rng, sprite=index % 4,
                      x=xs[index % len(xs)], y=(0x40 + index * 7) & 0xFFFF)
        mask = (index * 13) & 0xF
        for bit, name in enumerate(slot_names):
            if mask & (1 << bit):
                _write_record(h, pod_offsets[bit], rng, x=0x5555, y=0xAAAA)
                _put_word(h, name, pod_offsets[bit])
            else:
                _put_word(h, name, NO_SLOT)
        _put_word(h, "SidePodSpreadRight", (0, 1, 8, 0xFFF8)[index % 4])
        _put_word(h, "SidePodSpreadLeft", (0, 0xFFFF, 4, 0xFFF0)[index % 4])
        _put_byte(h, "SfxEnabled", index & 1)
        _put_byte(h, "SfxRequest", 0x55)
        _put_word(h, "DemoStepTimer", index * 7)
        h.m.call("DemoStepNextShipForm")
        h.lib.demo_step_next_ship_form()
        h.compare(f"DemoStepNextShipForm #{index}")
    return 32


def _bind_map(h, view: BorrowedMap) -> None:
    h.lib.overkill_bind_level_map.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    h.lib.overkill_bind_level_map.restype = ctypes.c_int
    if not h.lib.overkill_bind_level_map(ctypes.c_void_p(view.address), STATE_BYTES):
        raise AssertionError("native core rejected the borrowed 64 KiB level map")
    h.m.poke("LevelMapSegment", MAP_SEGMENT)


def run(no_build: bool = False) -> int:
    if no_build:
        if not HOST_CORE.is_file() or not HOST_STATE.is_file():
            raise FileNotFoundError("--no-build requires the current host core and STATE.BIN")
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    harness = _load_module("host_input_harness_pod_motion", ROOT / "tests/host/input.py")
    h = harness.HostHarness()
    _bind_signatures(h)
    rng = random.Random(SEED)
    view = BorrowedMap()
    _bind_map(h, view)

    started = time.perf_counter()
    checks = 0
    checks += _pair_cases(h, rng)
    checks += _side_placement_cases(h, rng)
    checks += _x_step_cases(h, rng)
    checks += _adjust_cases(h, rng)
    checks += _pod_hit_cases(h, rng)
    checks += _terrain_cases(h, view)
    checks += _saved_position_cases(h, rng)
    checks += _demo_launch_cases(h, rng)
    checks += _init_pod_cases(h, rng)
    checks += _demo_next_form_cases(h, rng)
    view.check("final pod-motion map check")
    h.check_canaries()
    elapsed = time.perf_counter() - started
    print(f"PASS host pod motion: {checks} native-vs-ASM checks in {elapsed:.1f}s")
    return checks


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="reuse build/host and build/oracle-sym artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
