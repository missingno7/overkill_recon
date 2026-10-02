"""Native terrain helpers against the exact DOS ASM oracle.

Run ``python tests/host/terrain.py`` to build the host core and run the suite, or pass
``--no-build`` to reuse the host core and exact oracle. The level map is a separately
borrowed 64 KiB native window with the same bytes as the emulator's map segment.
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
HOST_DIR = ROOT / "build/host"
HOST_CORE = HOST_DIR / ("OVERKILL_CORE.dll" if sys.platform == "win32"
                        else "liboverkill_core.so")
HOST_STATE = HOST_DIR / "STATE.BIN"
STATE_BYTES = 0x10000
GUARD_BYTES = 16
MAP_SEGMENT = 0x9000
MAP_LINEAR = MAP_SEGMENT << 4
MAP_SEED = 0x54455252
GRID_SEED = 0x47524944
OVERLAP_SEED = 0x4F564C50
CLIMB_SEED = 0x434C494D

sys.path.insert(0, str(TOOLS))
from emu import FLAG  # noqa: E402
from world import K, World  # noqa: E402


class BorrowedMap:
    """A guarded 64 KiB map view; the deliberately unaligned base tests byte access."""

    def __init__(self) -> None:
        self.raw = (ctypes.c_ubyte * (STATE_BYTES + 2 * GUARD_BYTES + 2))()
        self.address = ctypes.addressof(self.raw) + GUARD_BYTES + 1
        self.before = (self.address - GUARD_BYTES, GUARD_BYTES)
        self.after = (self.address + STATE_BYTES, GUARD_BYTES)
        ctypes.memset(self.before[0], 0xA7, GUARD_BYTES)
        ctypes.memset(self.after[0], 0x5C, GUARD_BYTES)
        self.expected = bytes(STATE_BYTES)
        self.load(self.expected)

    def load(self, data: bytes) -> None:
        data = bytes(data)
        if len(data) != STATE_BYTES:
            raise ValueError(f"level map must be exactly {STATE_BYTES:#x} bytes")
        ctypes.memmove(self.address, data, STATE_BYTES)
        self.expected = data

    def snapshot(self) -> bytes:
        return ctypes.string_at(self.address, STATE_BYTES)

    def check_canaries(self) -> None:
        if ctypes.string_at(*self.before) != bytes([0xA7]) * GUARD_BYTES:
            raise AssertionError("terrain code wrote before the borrowed level map")
        if ctypes.string_at(*self.after) != bytes([0x5C]) * GUARD_BYTES:
            raise AssertionError("terrain code wrote after the borrowed level map")

    def check_unchanged(self, label: str) -> None:
        actual = self.snapshot()
        self.check_canaries()
        if actual != self.expected:
            mismatch = next(i for i, (got, want) in enumerate(zip(actual, self.expected))
                            if got != want)
            raise AssertionError(
                f"{label}: map changed at {mismatch:04X}: "
                f"native={actual[mismatch]:02X}, expected={self.expected[mismatch]:02X}")


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _bind_signatures(h) -> None:
    h.lib.overkill_bind_level_map.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    h.lib.overkill_bind_level_map.restype = ctypes.c_int
    h.lib.overkill_level_map_address.argtypes = (ctypes.c_uint16,)
    h.lib.overkill_level_map_address.restype = ctypes.c_void_p

    h.lib.map_attribute.argtypes = (ctypes.c_uint16,)
    h.lib.map_attribute.restype = ctypes.c_uint16
    h.lib.grid_offset_at.argtypes = (ctypes.c_uint16, ctypes.c_uint16)
    h.lib.grid_offset_at.restype = ctypes.c_uint16
    h.lib.compute_record_grid_offset.argtypes = (ctypes.c_void_p,)
    h.lib.compute_record_grid_offset.restype = ctypes.c_uint16
    h.lib.probe_ship_terrain_collision.argtypes = (ctypes.c_void_p,)
    h.lib.probe_ship_terrain_collision.restype = ctypes.c_uint16
    h.lib.probe_overlaps_walker.argtypes = (ctypes.c_void_p,)
    h.lib.probe_overlaps_walker.restype = ctypes.c_uint16
    h.lib.terrain_step_in_direction.argtypes = (ctypes.c_void_p,)
    h.lib.terrain_step_in_direction.restype = None
    h.lib.try_terrain_step.argtypes = (ctypes.c_void_p,)
    h.lib.try_terrain_step.restype = ctypes.c_uint16
    h.lib.climb_walker_step.argtypes = (ctypes.c_void_p,)
    h.lib.climb_walker_step.restype = ctypes.c_uint16


def _record_pointer(h, offset: int) -> ctypes.c_void_p:
    if not 0 <= offset <= STATE_BYTES - K.RECORD_SIZE:
        raise ValueError(f"record pointer is outside borrowed DS: {offset:04X}")
    return ctypes.c_void_p(h.state_addr + offset)


def _word(h, name: str) -> int:
    return struct.unpack_from("<H", h.state_storage.snapshot(), h.offset(name))[0]


def _write_word(h, name: str, value: int) -> None:
    h.write_symbol(name, struct.pack("<H", value & 0xFFFF))


def _world(h, rng: random.Random) -> World:
    return World(SimpleNamespace(sym=h.offset), rng)


def _apply_world(h, world: World) -> None:
    for offset, data in world.writes():
        h.write(offset, data)


def _bind_map(h, view: BorrowedMap) -> None:
    if not h.lib.overkill_bind_level_map(ctypes.c_void_p(view.address), STATE_BYTES):
        raise AssertionError("native core rejected the 64 KiB level map")


def _set_map(h, view: BorrowedMap, data: bytes) -> None:
    view.load(data)
    h.m.u.mem_write(MAP_LINEAR, data)
    h.m.poke("LevelMapSegment", MAP_SEGMENT)


def _map_address(h, offset: int) -> int:
    address = h.lib.overkill_level_map_address(offset)
    if address is None:
        raise AssertionError(f"level map address {offset:04X} is null")
    return int(address)


def _map_adapter_and_exhaustive_lookup(h, first: BorrowedMap, second: BorrowedMap) -> int:
    table = bytes((index * 37 + 11) & 0xFF for index in range(256))
    h.write_symbol("ByteAttributeTable", table)

    map_data = bytes(index & 0xFF for index in range(STATE_BYTES))
    second_data = bytes((0xFF - index) & 0xFF for index in range(STATE_BYTES))
    _set_map(h, first, map_data)
    _bind_map(h, first)
    h.m.poke("LevelMapSegment", MAP_SEGMENT)

    if h.lib.overkill_bind_level_map(None, STATE_BYTES) != 0:
        raise AssertionError("null level-map binding was accepted")
    if h.lib.overkill_bind_level_map(ctypes.c_void_p(second.address), STATE_BYTES - 1) != 0:
        raise AssertionError("short level-map binding was accepted")
    if _map_address(h, 0) != first.address:
        raise AssertionError("failed map bind did not retain the previous map")

    _set_map(h, second, second_data)
    _bind_map(h, second)
    if _map_address(h, 0) != second.address or _map_address(h, 0xFFFF) != second.address + 0xFFFF:
        raise AssertionError("level-map rebinding did not select the new window")
    h.m.u.mem_write(MAP_LINEAR, second_data)
    for offset in (0, 1, K.MAP_ROW_BYTES, 0x7FFF, 0xFFFF):
        native = int(h.lib.map_attribute(offset))
        oracle = h.m.call("ReadIndexedByteAttribute", {"BX": offset})
        if native != oracle["AX"] or native != table[second_data[offset]]:
            raise AssertionError(f"map rebind lookup {offset:04X} disagrees")
        if oracle["ES"] != MAP_SEGMENT or bool(oracle["FLAGS"] & FLAG["ZF"]) != (native == 0):
            raise AssertionError(f"map rebind register contract at {offset:04X} disagrees")
    h.compare("level-map rebind probe")

    _set_map(h, first, map_data)
    _bind_map(h, first)
    if _map_address(h, 0xFFFF) != first.address + 0xFFFF:
        raise AssertionError("level-map final-byte address is wrong")

    # Every 16-bit map offset is a valid cell address. The pattern reaches each possible
    # tile byte 256 times; the attribute table is a permutation, including zero and sign.
    checks = 8
    for cell in range(STATE_BYTES):
        address = _map_address(h, cell)
        if address != first.address + cell:
            raise AssertionError(f"level-map address {cell:04X}: {address:#x}")
        native = int(h.lib.map_attribute(cell))
        oracle = h.m.call("ReadIndexedByteAttribute", {"BX": cell})
        expected = table[map_data[cell]]
        if native != expected or oracle["AX"] != expected:
            raise AssertionError(
                f"map cell {cell:04X}: native={native:02X}, ASM={oracle['AX']:02X}, "
                f"expected={expected:02X}")
        if oracle["ES"] != MAP_SEGMENT:
            raise AssertionError(f"ReadIndexedByteAttribute ES={oracle['ES']:04X}, expected map segment")
        flags = oracle["FLAGS"]
        if bool(flags & FLAG["ZF"]) != (expected == 0):
            raise AssertionError(f"ReadIndexedByteAttribute ZF mismatch at {cell:04X}")
        if bool(flags & FLAG["SF"]) != bool(expected & 0x80):
            raise AssertionError(f"ReadIndexedByteAttribute SF mismatch at {cell:04X}")
        checks += 1

    h.compare("all 16-bit level-map lookups")
    first.check_unchanged("exhaustive level-map lookup")
    second.check_unchanged("rebound level-map lookup")
    return checks


def _grid_word(x: int, y: int, scroll_sub: int, map_scroll: int) -> tuple[int, int]:
    total = (scroll_sub + y) & 0xFFFF
    if total & 0x8000:
        return total, 0xFFFF
    row = total >> 4
    return total, (map_scroll - row * K.MAP_ROW_BYTES + (x >> 4)) & 0xFFFF


def _grid_case(h, rng: random.Random, x: int, y: int, scroll_sub: int,
               map_scroll: int, index: int) -> None:
    h.reset()
    world = _world(h, rng)
    record = world.record("PoolA", 0).live(kind=K.KIND_ENEMY, type=0x33, size=1)
    record.set(x=x, y=y, direction=K.DIR_RIGHT)
    world.word("ScrollSubRow", scroll_sub).word("MapScrollPos", map_scroll)
    _apply_world(h, world)

    pointer = _record_pointer(h, record.at)
    direct = int(h.lib.grid_offset_at(x, y))
    native = int(h.lib.compute_record_grid_offset(pointer))
    oracle = h.m.call("ComputeRecordGridOffset", {"BP": record.at})
    expected_sum, expected_offset = _grid_word(x, y, scroll_sub, map_scroll)
    if direct != expected_offset or native != oracle["BX"] or native != expected_offset:
        raise AssertionError(
            f"grid #{index}: native grid/record={direct:04X}/{native:04X}, "
            f"ASM BX={oracle['BX']:04X}, expected={expected_offset:04X}")
    if _word(h, "GridYSum") != expected_sum:
        raise AssertionError(f"grid #{index}: GridYSum={_word(h, 'GridYSum'):04X}")
    h.compare(f"grid offset #{index}")


def _grid_cases(h) -> int:
    edge = (0, 1, 0x0F, 0x10, 0x11, 0x7FFF, 0x8000, 0xFFF0, 0xFFFF)
    scroll_rows = (0, 1, 0x0F, 0x7FFF, 0x8000, 0xFFFF)
    map_scrolls = (0, K.MAP_ROW_BYTES, 0x1000, 0x8000, 0xFFF0, 0xFFFF)
    rng = random.Random(GRID_SEED)
    count = 0

    for sub_index, scroll_sub in enumerate(scroll_rows):
        map_scroll = map_scrolls[sub_index]
        for x in edge:
            for y in edge:
                _grid_case(h, rng, x, y, scroll_sub, map_scroll, count)
                count += 1
    for _ in range(128):
        x = rng.choice(edge) if rng.randrange(2) else rng.randrange(0x10000)
        y = rng.choice(edge) if rng.randrange(2) else rng.randrange(0x10000)
        scroll_sub = rng.choice(edge) if rng.randrange(2) else rng.randrange(0x10000)
        map_scroll = rng.choice(map_scrolls) if rng.randrange(2) else rng.randrange(0x10000)
        _grid_case(h, rng, x, y, scroll_sub, map_scroll, count)
        count += 1
    return count


def _terrain_table() -> bytes:
    table = bytearray(256)
    table[1] = 1
    return bytes(table)


def _terrain_world(h, rng: random.Random, *, x: int = 0x40, y: int = 0x50,
                   direction: int = 0, map_scroll: int | None = None,
                   scroll_sub: int = 0, scroll_delta: int = 0,
                   draw_pass: int = 1) -> tuple[World, object]:
    world = _world(h, rng)
    record = world.record("PoolA", 0).live(kind=K.KIND_ENEMY, type=0x33, size=1)
    record.set(x=x, y=y, direction=direction, draw_pass=draw_pass, save_buffer=1)
    world.word("MapScrollPos", K.MAP_ROW_BYTES * 64 if map_scroll is None else map_scroll)
    world.word("ScrollSubRow", scroll_sub).word("ScrollDeltaY", scroll_delta)
    world.put("ByteAttributeTable", _terrain_table())
    world.word("TerrainProbeX", x).word("TerrainProbeY", y)
    return world, record


def _run_ship_probe(h, view: BorrowedMap, world: World, ship, map_data: bytes,
                    name: str, expected: int) -> None:
    h.reset()
    _apply_world(h, world)
    _set_map(h, view, map_data)
    native = int(h.lib.probe_ship_terrain_collision(_record_pointer(h, ship.at)))
    oracle = h.m.call("ProbeShipTerrainCollision", {"BP": ship.at})
    asm_hit = 1 if oracle["FLAGS"] & FLAG["CF"] else 0
    if native != asm_hit or native != expected:
        raise AssertionError(
            f"ship terrain {name}: native={native}, ASM CF={asm_hit}, expected={expected}")
    h.compare(f"ship terrain {name}")
    view.check_unchanged(f"ship terrain {name}")


def _ship_probe_offsets(h, sprite: int, x: int, y: int, scroll_sub: int,
                        map_scroll: int) -> list[int]:
    if sprite >= 3:
        return []
    table = h.offset("PlayerHitOffsets") + sprite * 4
    base = h.state_storage.snapshot()
    hit_y, hit_x = struct.unpack_from("<HH", base, table)
    probe_x = (x + hit_x) & 0xFFFF
    probe_y = (y + hit_y) & 0xFFFF
    total, grid = _grid_word(probe_x, probe_y, scroll_sub, map_scroll)
    cell = (grid + K.MAP_ROW_BYTES) & 0xFFFF
    rows = 2 if (total & 0x0F) > 0x0A else 1
    offsets = []
    for _ in range(rows):
        offsets.append(cell)
        if probe_x & 0x0F:
            offsets.append((cell + 1) & 0xFFFF)
        cell = (cell - K.MAP_ROW_BYTES) & 0xFFFF
    return offsets


def _ship_cases(h, view: BorrowedMap) -> int:
    rng = random.Random(MAP_SEED)
    checks = 0
    attrs = _terrain_table()
    map_scroll = K.MAP_ROW_BYTES * 64

    # All ship forms exercise aligned/partial columns and the inclusive 0Ah versus
    # greater-than-0Ah second-row threshold. Put a wall in every individually probed
    # cell, then beside the probe set to prove unused cells do not collide.
    for sprite in range(3):
        hit_table = h.state_storage.snapshot()
        hit_y, _hit_x = struct.unpack_from(
            "<HH", hit_table, h.offset("PlayerHitOffsets") + sprite * 4)
        for y_phase in (0x0A, 0x0B):
            y = (0x40 + y_phase - hit_y) & 0xFFFF
            for x_phase in (8, 9):
                x = 0x40 + x_phase
                world, ship = _terrain_world(h, rng, x=x, y=y, map_scroll=map_scroll)
                ship.set(sprite=sprite)
                offsets = _ship_probe_offsets(h, sprite, x, y, 0, map_scroll)
                for probe_index, cell in enumerate(offsets):
                    data = bytearray(STATE_BYTES)
                    data[cell] = 1
                    _run_ship_probe(h, view, world, ship, bytes(data),
                                    f"form {sprite} threshold {y_phase:02X} column {x_phase} "
                                    f"cell {probe_index}", 1)
                    checks += 1
                unused = next((cell for cell in range(STATE_BYTES)
                               if cell not in offsets), None)
                if unused is None:
                    raise AssertionError("ship probe unexpectedly covered the whole map")
                data = bytearray(STATE_BYTES)
                data[unused] = 1
                _run_ship_probe(h, view, world, ship, bytes(data),
                                f"form {sprite} misses non-probe cell", 0)
                checks += 1

    # Destroyed ship forms return CF without reading terrain. The negative-grid case
    # retains the original FFFFh + MAP_ROW_BYTES wrap to map cell 000Ch.
    for sprite in (3, 4, 0xFFFF):
        world, ship = _terrain_world(h, rng, x=0x40, y=0x50, map_scroll=map_scroll)
        ship.set(sprite=sprite)
        _run_ship_probe(h, view, world, ship, bytes(STATE_BYTES), f"destroyed form {sprite:04X}", 1)
        checks += 1

    world, ship = _terrain_world(h, rng, x=0x40, y=0xFFE0, map_scroll=map_scroll)
    ship.set(sprite=0)
    data = bytearray(STATE_BYTES)
    data[0x0C] = 1
    _run_ship_probe(h, view, world, ship, bytes(data), "negative grid wraps to cell 000C", 1)
    checks += 1
    data[0x0C] = 0
    _run_ship_probe(h, view, world, ship, bytes(data), "negative grid open wrapped cells", 0)
    checks += 1
    return checks


def _overlap_case(h, name: str, *, probe_x: int, probe_y: int,
                  walker_x: int = 0x40, walker_y: int = 0x40,
                  status: int = 1, draw_pass: int = 0, size: int = 1,
                  kind: int = K.KIND_ENEMY, rtype: int = 0x8B,
                  same_buffer: bool = False, self_pass: int = 0,
                  second_match: bool = False, expected: int | None = None) -> None:
    h.reset()
    world = _world(h, random.Random(OVERLAP_SEED))
    candidate = world.record("PoolA", 0).live(kind=kind, type=rtype, size=size,
                                                draw_pass=draw_pass)
    candidate.set(x=walker_x, y=walker_y, save_buffer=1 if same_buffer else 2)
    if status == 0:
        candidate.free()
    actor_x = probe_x ^ 0x8000
    actor_y = probe_y ^ 0x8000
    actor = world.record("PoolA", 1).live(kind=K.KIND_ENEMY, type=0x8B, size=1,
                                            draw_pass=self_pass)
    actor.set(x=actor_x, y=actor_y, save_buffer=1)
    if second_match:
        other = world.record("PoolA", 2).live(kind=K.KIND_ENEMY, type=0x82, size=1,
                                                draw_pass=0)
        other.set(x=walker_x, y=walker_y, save_buffer=3)
    world.word("TerrainProbeX", probe_x).word("TerrainProbeY", probe_y)
    _apply_world(h, world)

    native = int(h.lib.probe_overlaps_walker(_record_pointer(h, actor.at)))
    oracle = h.m.call("ProbeOverlapsWalker", {"BP": actor.at})
    asm_overlap = 1 if oracle["FLAGS"] & FLAG["CF"] else 0
    if native != asm_overlap:
        raise AssertionError(
            f"ProbeOverlapsWalker {name}: native={native}, ASM CF={asm_overlap}")
    if expected is not None and native != expected:
        raise AssertionError(f"ProbeOverlapsWalker {name}: {native}, expected {expected}")
    h.compare(f"ProbeOverlapsWalker {name}")


def _overlap_cases(h) -> int:
    cases = [
        ("interior", 0x48, 0x48, {}, 1),
        ("interior lower-end strict", 0x30, 0x48, {}, 0),
        ("interior upper-end strict", 0x50, 0x48, {}, 0),
        ("vertical lower-end strict", 0x48, 0x30, {}, 0),
        ("vertical upper-end strict", 0x48, 0x50, {}, 0),
        ("free record", 0x48, 0x48, {"status": 0}, 0),
        ("draw pass one", 0x48, 0x48, {"draw_pass": 1}, 0),
        ("size zero", 0x48, 0x48, {"size": 0}, 0),
        ("size two", 0x48, 0x48, {"size": 2}, 0),
        ("non-enemy kind", 0x48, 0x48, {"kind": K.KIND_TYPED}, 0),
        ("type below range", 0x48, 0x48, {"rtype": 0x81}, 0),
        ("type first in range", 0x48, 0x48, {"rtype": 0x82}, 1),
        ("type last in range", 0x48, 0x48, {"rtype": 0x94}, 1),
        ("type past range", 0x48, 0x48, {"rtype": 0x95}, 0),
        ("same save-buffer identity", 0x48, 0x48, {"same_buffer": True}, 0),
        ("pass-one probe skips pool", 0x48, 0x48, {"self_pass": 1}, 0),
        ("later qualifying walker", 0x48, 0x48, {"status": 0, "second_match": True}, 1),
    ]
    checks = 0
    for name, x, y, options, expected in cases:
        _overlap_case(h, name, probe_x=x, probe_y=y, expected=expected, **options)
        checks += 1
    # Signed edges exercise the original signed interval comparisons around 8000h.
    for index, value in enumerate((0x7FF0, 0x7FFF, 0x8000, 0x8008, 0xFFF8, 0x0008)):
        _overlap_case(h, f"signed edge {index}", probe_x=value, probe_y=value,
                      walker_x=value, walker_y=value)
        checks += 1
    return checks


def _run_terrain_body(h, view: BorrowedMap, world: World, record, map_data: bytes,
                      name: str) -> None:
    h.reset()
    _apply_world(h, world)
    _set_map(h, view, map_data)
    h.lib.terrain_step_in_direction(_record_pointer(h, record.at))
    h.m.call("TerrainStepInDirection", {"BP": record.at})
    h.compare(f"TerrainStepInDirection {name}")
    view.check_unchanged(f"TerrainStepInDirection {name}")


def _run_try_step(h, view: BorrowedMap, world: World, record, map_data: bytes,
                  name: str, *, expected_blocked: int | None = None,
                  expected_xy: tuple[int, int] | None = None) -> None:
    h.reset()
    _apply_world(h, world)
    _set_map(h, view, map_data)
    native_blocked = int(h.lib.try_terrain_step(_record_pointer(h, record.at)))
    oracle = h.m.call("TryTerrainStep", {"BP": record.at})
    asm_blocked = 0 if oracle["FLAGS"] & FLAG["ZF"] else 1
    if native_blocked != asm_blocked:
        raise AssertionError(
            f"TryTerrainStep {name}: native blocked={native_blocked}, ASM ZF gives {asm_blocked}")
    if expected_blocked is not None and native_blocked != expected_blocked:
        raise AssertionError(
            f"TryTerrainStep {name}: native blocked={native_blocked}, expected {expected_blocked}")
    if expected_xy is not None:
        state = h.state_storage.snapshot()
        actual_xy = (struct.unpack_from("<H", state, record.at + K.REC_X)[0],
                     struct.unpack_from("<H", state, record.at + K.REC_Y)[0])
        if actual_xy != expected_xy:
            raise AssertionError(f"TryTerrainStep {name}: XY={actual_xy}, expected {expected_xy}")
    h.compare(f"TryTerrainStep {name}")
    view.check_unchanged(f"TryTerrainStep {name}")


def _terrain_step_cases(h, view: BorrowedMap) -> int:
    rng = random.Random(MAP_SEED)
    checks = 0
    open_map = bytes(STATE_BYTES)
    directions = {
        K.DIR_UP: (0, -1), K.DIR_UP_RIGHT: (1, -1), K.DIR_RIGHT: (1, 0),
        K.DIR_DOWN_RIGHT: (1, 1), K.DIR_DOWN: (0, 1), K.DIR_DOWN_LEFT: (-1, 1),
        K.DIR_LEFT: (-1, 0), K.DIR_UP_LEFT: (-1, -1),
    }

    # The internal direction body is compared directly for every switch arm.
    for direction in range(8):
        world, record = _terrain_world(h, rng, x=0x40, y=0x40, direction=direction)
        record.set(y=0x40)
        world.word("TerrainProbeX", 0x40).word("TerrainProbeY", 0x50)
        _run_terrain_body(h, view, world, record, open_map, f"open direction {direction}")
        checks += 1

    for direction, (dx, dy) in directions.items():
        for x in (0x40, 0x4F, 0x50):
            for y in (0x50, 0x5F, 0x60):
                world, record = _terrain_world(h, rng, x=x, y=y, direction=direction)
                _run_try_step(h, view, world, record, open_map,
                              f"open dir {direction} corner {x:02X},{y:02X}",
                              expected_blocked=0,
                              expected_xy=((x + dx) & 0xFFFF, (y + dy) & 0xFFFF))
                checks += 1

    # At a cell corner all four probes hit the wall; diagonal movement still tries its
    # second axis after the first reports blocked.
    wall_map = bytes([1]) * STATE_BYTES
    for direction in range(8):
        world, record = _terrain_world(h, rng, x=0x40, y=0x50, direction=direction)
        _run_try_step(h, view, world, record, wall_map,
                      f"solid wall direction {direction}", expected_blocked=1,
                      expected_xy=(0x40, 0x50))
        checks += 1

    # Exact diagonal order: up then right, right then down, down then left, left then up.
    start_cell = (K.MAP_ROW_BYTES * 64 - 4 * K.MAP_ROW_BYTES + 4) & 0xFFFF
    diagonal_walls = (
        (K.DIR_UP_RIGHT, (start_cell + K.MAP_ROW_BYTES) & 0xFFFF, (1, 0)),
        (K.DIR_DOWN_RIGHT, (start_cell + 1) & 0xFFFF, (0, 1)),
        (K.DIR_DOWN_LEFT, (start_cell - K.MAP_ROW_BYTES) & 0xFFFF, (-1, 0)),
        (K.DIR_UP_LEFT, (start_cell - 1) & 0xFFFF, (0, -1)),
    )
    for direction, wall_cell, delta in diagonal_walls:
        data = bytearray(STATE_BYTES)
        data[wall_cell] = 1
        world, record = _terrain_world(h, rng, x=0x40, y=0x50, direction=direction)
        _run_try_step(h, view, world, record, bytes(data),
                      f"diagonal half blocked direction {direction}", expected_blocked=1,
                      expected_xy=((0x40 + delta[0]) & 0xFFFF,
                                   (0x50 + delta[1]) & 0xFFFF))
        checks += 1

    # Negative GridYSum blocks before probing; positive grid coordinates can wrap the
    # 16-bit map offset and still read the last bytes of the borrowed window.
    world, record = _terrain_world(h, rng, x=0, y=8, direction=K.DIR_DOWN)
    _run_try_step(h, view, world, record, open_map, "negative GridYSum", expected_blocked=1,
                  expected_xy=(0, 8))
    checks += 1
    wrapped_wall = bytearray(STATE_BYTES)
    wrapped_cell = (0 - K.MAP_ROW_BYTES - K.MAP_ROW_BYTES) & 0xFFFF
    wrapped_wall[wrapped_cell] = 1
    world, record = _terrain_world(h, rng, x=0, y=0x20, direction=K.DIR_DOWN,
                                   map_scroll=0)
    _run_try_step(h, view, world, record, bytes(wrapped_wall), "wrapped map probe at FFE6h",
                  expected_blocked=1, expected_xy=(0, 0x20))
    checks += 1

    # With pass 0, a qualifying walker blocks the moved probe and the axis step rolls
    # back. Place the walker at the strict 15-pixel boundary so the same test also pins
    # ProbeOverlapsWalker's open interval while reached through TryTerrainStep.
    cardinal_targets = (
        (K.DIR_UP, (0x40, 0x4F)),
        (K.DIR_RIGHT, (0x41, 0x50)),
        (K.DIR_DOWN, (0x40, 0x51)),
        (K.DIR_LEFT, (0x3F, 0x50)),
    )
    for direction, (probe_x, probe_y) in cardinal_targets:
        world, record = _terrain_world(h, rng, direction=direction, draw_pass=0)
        obstacle = world.record("PoolA", 1).live(kind=K.KIND_ENEMY, type=0x8B, size=1,
                                                    draw_pass=0)
        obstacle.set(x=(probe_x + 15) & 0xFFFF,
                     y=(probe_y - 15) & 0xFFFF, save_buffer=2)
        _run_try_step(h, view, world, record, open_map,
                      f"walker rolls back cardinal {direction} at strict 15-pixel boundary",
                      expected_blocked=1, expected_xy=(0x40, 0x50))
        checks += 1

    # Diagonals retain the axis that was free. These cases separately block the first
    # and second move in each original order: up/right, right/down, down/left, left/up.
    diagonal_collision_cases = (
        # Direction, blocked axis, target probe, obstacle center, final record X/Y.
        (K.DIR_UP_RIGHT, "first up", (0x40, 0x4F), (0x31, 0x4F), (0x41, 0x50)),
        (K.DIR_UP_RIGHT, "second right", (0x41, 0x4F), (0x50, 0x4F), (0x40, 0x4F)),
        (K.DIR_DOWN_RIGHT, "first right", (0x41, 0x50), (0x41, 0x41), (0x40, 0x51)),
        (K.DIR_DOWN_RIGHT, "second down", (0x41, 0x51), (0x41, 0x60), (0x41, 0x50)),
        (K.DIR_DOWN_LEFT, "first down", (0x40, 0x51), (0x4F, 0x51), (0x3F, 0x50)),
        (K.DIR_DOWN_LEFT, "second left", (0x3F, 0x51), (0x30, 0x51), (0x40, 0x51)),
        (K.DIR_UP_LEFT, "first left", (0x3F, 0x50), (0x3F, 0x5F), (0x40, 0x4F)),
        (K.DIR_UP_LEFT, "second up", (0x3F, 0x4F), (0x3F, 0x40), (0x3F, 0x50)),
    )
    for direction, blocked_axis, (probe_x, probe_y), (walker_x, walker_y), final_xy in diagonal_collision_cases:
        world, record = _terrain_world(h, rng, direction=direction, draw_pass=0)
        obstacle = world.record("PoolA", 1).live(kind=K.KIND_ENEMY, type=0x8B, size=1,
                                                    draw_pass=0)
        obstacle.set(x=walker_x, y=walker_y, save_buffer=2)
        _run_try_step(h, view, world, record, open_map,
                      f"walker blocks {blocked_axis} in diagonal {direction}",
                      expected_blocked=1, expected_xy=final_xy)
        checks += 1

    # Coordinate additions are 16-bit. These open steps wrap X and Y while scroll
    # arithmetic keeps the grid nonnegative, exercising both map-cell and record edges.
    wrap_cases = (
        (K.DIR_RIGHT, 0xFFFF, 0x50, 0, 0, K.MAP_ROW_BYTES * 64, (0, 0x50)),
        (K.DIR_LEFT, 0, 0x50, 0, 0, K.MAP_ROW_BYTES * 4, (0xFFFF, 0x50)),
        (K.DIR_DOWN, 0x40, 0xFFFF, 0x20, 0, 0, (0x40, 0)),
        (K.DIR_UP, 0x40, 0, 0, 0x10, K.MAP_ROW_BYTES * 2, (0x40, 0xFFFF)),
    )
    for direction, x, y, scroll_sub, scroll_delta, map_scroll, expected_xy in wrap_cases:
        world, record = _terrain_world(h, rng, x=x, y=y, direction=direction,
                                       map_scroll=map_scroll, scroll_sub=scroll_sub,
                                       scroll_delta=scroll_delta)
        _run_try_step(h, view, world, record, open_map,
                      f"open coordinate wrap direction {direction} at {x:04X},{y:04X}",
                      expected_blocked=0, expected_xy=expected_xy)
        checks += 1
    return checks


def _climb_grid(x: int, y: int, scroll_sub: int, map_scroll: int) -> int:
    total, cell = _grid_word(x, y, scroll_sub, map_scroll)
    return 0xFFFF if total & 0x8000 else cell


def _run_climb(h, view: BorrowedMap, *, name: str, x: int, y: int,
               player_y: int, facing: int, wall: bool, map_scroll: int,
               scroll_sub: int = 0, scroll_delta: int = 0,
               expected_blocked: int) -> None:
    h.reset()
    rng = random.Random(CLIMB_SEED)
    world = _world(h, rng)
    walker = world.record("PoolA", 0).live(kind=K.KIND_ENEMY, type=0x8B, size=1,
                                             draw_pass=1)
    walker.set(x=x, y=y, save_buffer=1)
    primary = world.record("PrimaryRecord", 0).live(kind=K.KIND_PLAYER, size=1)
    primary.set(y=player_y, x=0x80)
    world.word("WalkerFacingStep", facing).word("MapScrollPos", map_scroll)
    world.word("ScrollSubRow", scroll_sub).word("ScrollDeltaY", scroll_delta)
    world.put("ByteAttributeTable", _terrain_table())
    world.word("TerrainProbeX", x).word("TerrainProbeY", y)

    data = bytearray(STATE_BYTES)
    initial_y = (y + scroll_delta - 0x10) & 0xFFFF
    cell = _climb_grid(x, initial_y, scroll_sub, map_scroll)
    signed_y = y if y < 0x8000 else y - 0x10000
    signed_player_y = player_y if player_y < 0x8000 else player_y - 0x10000
    going_down = signed_y < signed_player_y
    wall_cell = (cell + facing - (K.MAP_ROW_BYTES if going_down else 0)) & 0xFFFF
    if wall and cell != 0xFFFF:
        data[wall_cell] = 1

    _apply_world(h, world)
    _set_map(h, view, bytes(data))
    native_blocked = int(h.lib.climb_walker_step(_record_pointer(h, walker.at)))
    oracle = h.m.call("ClimbWalkerStep", {"BP": walker.at})
    asm_blocked = 1 if oracle["FLAGS"] & FLAG["ZF"] else 0
    if native_blocked != asm_blocked or native_blocked != expected_blocked:
        raise AssertionError(
            f"ClimbWalkerStep {name}: native={native_blocked}, ASM={asm_blocked}, "
            f"expected={expected_blocked}")
    h.compare(f"ClimbWalkerStep {name}")
    view.check_unchanged(f"ClimbWalkerStep {name}")


def _climb_cases(h, view: BorrowedMap) -> int:
    checks = 0
    map_scroll = K.MAP_ROW_BYTES * 64
    cases = (
        ("below player, facing +1", 0x40, 0x50, 0x60, 1, map_scroll, 0, 0),
        ("equal player Y chooses up, facing +1", 0x40, 0x50, 0x50, 1, map_scroll, 0, 0),
        ("above player, facing -1", 0x40, 0x50, 0x40, 0xFFFF, map_scroll, 0, 0),
        ("below player, facing -1", 0x40, 0x50, 0x60, 0xFFFF, map_scroll, 0, 1),
        ("wrapped map wall and facing +1", 0, 0x20, 0x40, 1, 0, 0, 0),
        ("scroll-adjusted wall", 0x40, 0x51, 0x60, 1, map_scroll, 0, 1),
        ("negative initial grid", 0x40, 8, 0x10, 1, map_scroll, 0, 0),
        ("signed player comparison", 0x40, 0x8000, 0x7FFF, 1, map_scroll, 0, 0),
    )
    for label, x, y, player_y, facing, map_pos, sub, scroll in cases:
        for wall, expected in ((False, 1), (True, 0)):
            if label == "negative initial grid" and wall:
                expected = 1
            _run_climb(h, view, name=label + (" with wall" if wall else " no wall"),
                       x=x, y=y, player_y=player_y, facing=facing, wall=wall,
                       map_scroll=map_pos, scroll_sub=sub, scroll_delta=scroll,
                       expected_blocked=expected)
            checks += 1
    return checks


def run(no_build: bool = False) -> int:
    if no_build:
        if not HOST_CORE.is_file() or not HOST_STATE.is_file():
            raise FileNotFoundError("--no-build requires the current build/host core and STATE.BIN")
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    harness = _load_module("host_input_harness_terrain", ROOT / "tests/host/input.py")
    h = harness.HostHarness()
    _bind_signatures(h)
    h.m.poke("LevelMapSegment", MAP_SEGMENT)

    started = time.perf_counter()
    first_map = BorrowedMap()
    second_map = BorrowedMap()
    map_checks = _map_adapter_and_exhaustive_lookup(h, first_map, second_map)
    grid_checks = _grid_cases(h)
    ship_checks = _ship_cases(h, first_map)
    overlap_checks = _overlap_cases(h)
    terrain_checks = _terrain_step_cases(h, first_map)
    climb_checks = _climb_cases(h, first_map)

    first_map.check_unchanged("final first-map check")
    second_map.check_unchanged("final second-map check")
    h.check_canaries()
    total = map_checks + grid_checks + ship_checks + overlap_checks + terrain_checks + climb_checks
    elapsed = time.perf_counter() - started
    print(f"PASS host terrain: {map_checks} map lookups/bind checks, {grid_checks} grid cases, "
          f"{ship_checks} ship probes, {overlap_checks} walker-overlap cases, "
          f"{terrain_checks} terrain steps, {climb_checks} climb cases "
          f"({total} checks) in {elapsed:.1f}s")
    return total


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="require and reuse build/host and build/oracle-sym artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
