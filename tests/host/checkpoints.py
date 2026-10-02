"""Bounded native-vs-oracle checks for the segmented boss and checkpoint restart.

The restart fixture supplies a decoded level-map cache entry, as the DOS loader would
after a prior resource read. It calls only RestartAtCheckpoint; startup buffer setup is
limited to AllocateBuffers, BuildRowTables, and InitStars so scrolling has its ordinary
Tandy memory geometry. No gameplay loop is entered.

Run ``python tests/host/checkpoints.py --no-build`` to reuse the current DLL and oracle.
"""
from __future__ import annotations

import argparse
import ctypes
import importlib.util
from pathlib import Path
import struct
import sys

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
HOST_DIR = ROOT / "build/host"
HOST_CORE = HOST_DIR / ("OVERKILL_CORE.dll" if sys.platform == "win32"
                        else "liboverkill_core.so")
HOST_IMAGE = HOST_DIR / "HOST_IMAGE.BIN"
HOST_STATE = HOST_DIR / "STATE.BIN"
DOS_MEMORY_BYTES = 0x100000
STATE_BYTES = 0x10000
MAP_CACHE_SEGMENT = 0x9000
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


def _record(**fields: int) -> bytes:
    offsets = {
        "status": K.REC_STATUS, "y": K.REC_Y, "x": K.REC_X,
        "direction": K.REC_DIRECTION, "sprite": K.REC_SPRITE,
        "draw_pass": K.REC_DRAW_PASS, "size_class": K.REC_SIZE_CLASS,
        "kind": K.REC_KIND, "type": K.REC_TYPE, "hit_points": K.REC_HIT_POINTS,
        "slot_index": K.REC_SLOT_INDEX,
    }
    values = {
        "status": 1, "y": 0x60, "x": 0x50, "direction": 0,
        "sprite": 0, "draw_pass": 0, "size_class": 2,
        "kind": K.KIND_ENEMY, "type": 0x76, "hit_points": 0xC8,
        "slot_index": NO_RECORD,
    }
    values.update(fields)
    result = bytearray(K.RECORD_SIZE)
    for name, value in values.items():
        struct.pack_into("<H", result, offsets[name], value & 0xFFFF)
    return bytes(result)


def _word(h, name: str, value: int) -> tuple[int, bytes]:
    return h.offset(name), struct.pack("<H", value & 0xFFFF)


def _put(h, writes: list[tuple[int, bytes]]) -> None:
    for offset, data in writes:
        h.write(offset, data)


def _bind_native(lib) -> None:
    pointer = ctypes.c_void_p
    word = ctypes.c_uint16
    for name in ("run_type_handler",):
        fn = getattr(lib, name)
        fn.argtypes = (pointer,)
        fn.restype = None
    lib.steer_seg_boss_along_path.argtypes = ()
    lib.steer_seg_boss_along_path.restype = None
    lib.restart_at_checkpoint.argtypes = (pointer,)
    lib.restart_at_checkpoint.restype = None
    lib.overkill_bind_real_memory.argtypes = (pointer, ctypes.c_size_t)
    lib.overkill_bind_real_memory.restype = ctypes.c_int
    lib.overkill_bind_level_map.argtypes = (pointer, ctypes.c_size_t)
    lib.overkill_bind_level_map.restype = ctypes.c_int


class Arena:
    def __init__(self, h) -> None:
        image = HOST_IMAGE.read_bytes()
        if len(image) != DOS_MEMORY_BYTES:
            raise AssertionError("HOST_IMAGE.BIN must be exactly 1 MiB")
        self.raw = (ctypes.c_ubyte * (DOS_MEMORY_BYTES + 15))()
        self.base = (ctypes.addressof(self.raw) + 15) & ~15
        self.image = image
        if not h.lib.overkill_bind_real_memory(self.base, DOS_MEMORY_BYTES):
            raise AssertionError("native core rejected the 1 MiB DOS arena")
        # Read the frozen CS word from the oracle, then bind C's map view to that exact
        # physical alias. The real-mode machine loads the same linked MAIN image.
        self.map_segment = h.m.peek("LevelMapSegment")
        map_address = (self.map_segment << 4) & 0xFFFFF
        if not h.lib.overkill_bind_level_map(self.base + map_address, STATE_BYTES):
            raise AssertionError("native core rejected the level-map arena window")

    def load(self, image: bytes) -> None:
        if len(image) != DOS_MEMORY_BYTES:
            raise ValueError("physical memory snapshot must be exactly 1 MiB")
        ctypes.memmove(self.base, image, DOS_MEMORY_BYTES)

    def snapshot(self) -> bytes:
        return ctypes.string_at(self.base, DOS_MEMORY_BYTES)


def _word_at(machine, offset: int) -> int:
    return struct.unpack("<H", machine.read(offset, 2))[0]


def _main_word(machine, name: str) -> int:
    return struct.unpack("<H", bytes(machine.u.mem_read(machine.linear(name), 2)))[0]


def _compare_arena(native: bytes, oracle: bytes, stack_begin: int,
                   stack_end: int, label: str) -> None:
    if len(native) != DOS_MEMORY_BYTES or len(oracle) != DOS_MEMORY_BYTES:
        raise AssertionError(f"{label}: physical arena has wrong size")
    if native == oracle:
        return
    actual, expected = bytearray(native), bytearray(oracle)
    actual[stack_begin:stack_end] = bytes(stack_end - stack_begin)
    expected[stack_begin:stack_end] = bytes(stack_end - stack_begin)
    if actual == expected:
        return
    mismatch = next(i for i, (got, want) in enumerate(zip(actual, expected))
                    if got != want)
    raise AssertionError(
        f"{label}: physical {mismatch:05X} native={actual[mismatch]:02X}, "
        f"ASM={expected[mismatch]:02X}")


def _reset_runtime(h, arena: Arena, baseline_state: bytes,
                   baseline_memory: bytes) -> None:
    h.m.u.mem_write(0, baseline_memory)
    h.m.set_state(baseline_state)
    h.state_storage.load(baseline_state)
    arena.load(baseline_memory)


def _restart_cases(h, arena: Arena, baseline_state: bytes,
                   baseline_memory: bytes) -> int:
    if arena.map_segment == MAP_CACHE_SEGMENT:
        raise AssertionError("cache source segment collides with the level-map window")
    stack_begin = h.m.data_frame * 16 + h.offset("StackArea")
    stack_end = h.m.data_frame * 16 + h.m.stack_top
    player = h.offset("PrimaryRecord")
    count = 0

    # Cover all four checkpoints for every actual level table. Equality at each next
    # position selects the following checkpoint because ReadCheckpoint uses unsigned JB.
    for level in range(K.LEVEL_COUNT):
        checkpoints = _word_at(h.m, h.offset("LevelCheckpointPtrs") + 2 * level)
        entries = [tuple(_word_at(h.m, (checkpoints + 8 * index + 2 * field) & 0xFFFF)
                         for field in range(4)) for index in range(4)]
        reset_entry = h.m.linear(f"MapResetList{level}")
        reset_tile, reset_handler = struct.unpack(
            "<2H", bytes(h.m.u.mem_read(reset_entry, 4)))
        reset_tile &= 0xFF
        set_tile_28 = h.m.symbols["SETMAPTILE28"][1]
        expected_reset_tile = 0x28 if reset_handler == set_tile_28 else 1
        for checkpoint_index, entry in enumerate(entries):
            target_position, target_clock, target_cursor, _ = entry
            initial_scroll = 0 if checkpoint_index == 0 else entries[checkpoint_index - 1][3]
            map_data = bytearray([reset_tile]) * K.MAP_END_POS
            for index, value in enumerate(
                    h.m.read(h.offset("LevelEndMapRows"), 5 * K.MAP_ROW_BYTES)):
                map_data[K.MAP_END_ROWS_POS + index] = value

            _reset_runtime(h, arena, baseline_state, baseline_memory)
            filename = _word_at(h.m, h.offset("LevelMapFiles") + level * 2)
            cache = struct.pack("<5H", filename, MAP_CACHE_SEGMENT,
                                len(map_data), 0, 0)
            cache += struct.pack("<5H", NO_RECORD, 0, 0, 0, 0)
            writes = [
                (player, _record(kind=K.KIND_PLAYER, type=0)),
                _word(h, "LevelIndex", level),
                _word(h, "MapScrollPos", initial_scroll),
                _word(h, "LevelScriptClock", 0x6A5B),
                _word(h, "ScrollSubRow", (level + checkpoint_index * 5) & 0x0F),
                _word(h, "ScrollWindowOffset", _main_word(h.m, "ScrollStartOffset")),
                _word(h, "ScrollDeltaY", 0xFFF0 + checkpoint_index),
                _word(h, "LastTileStepBackward", (level + checkpoint_index) & 1),
                _word(h, "ScrollingBackward", 0),
                (h.offset("FileCache"), cache),
            ]
            _put(h, writes)
            h.m.u.mem_write((MAP_CACHE_SEGMENT << 4), bytes(map_data))
            before = bytes(h.m.u.mem_read(0, DOS_MEMORY_BYTES))
            arena.load(before)

            getattr(h.lib, "restart_at_checkpoint")(
                ctypes.c_void_p(h.state_addr + player))
            ctypes.memmove(arena.base + h.m.data_frame * 16,
                           h.state_storage.snapshot(), STATE_BYTES)
            native_after = arena.snapshot()

            h.m.call("RestartAtCheckpoint", {"BP": player})
            oracle_after = bytes(h.m.u.mem_read(0, DOS_MEMORY_BYTES))
            label = f"RestartAtCheckpoint level {level} checkpoint {checkpoint_index}"
            h.compare(label)
            _compare_arena(native_after, oracle_after, stack_begin, stack_end, label)
            # The last byte in the reset scan is in its range for every checkpoint,
            # including the first one at 9Ch.
            map_byte = ((arena.map_segment << 4) + target_position - 1) & 0xFFFFF
            if native_after[map_byte] != expected_reset_tile:
                raise AssertionError(
                    f"{label}: last reset-window tile is "
                    f"{native_after[map_byte]:02X}, expected {expected_reset_tile:02X}")

            final_position = _word_at(h.m, h.offset("MapScrollPos"))
            if final_position != target_position:
                raise AssertionError(
                    f"{label}: final map position {final_position:04X}, "
                    f"expected checkpoint {target_position:04X}")
            if _word_at(h.m, h.offset("LevelScriptClock")) != target_clock:
                raise AssertionError(f"{label}: checkpoint clock was not restored")
            if _word_at(h.m, h.offset("CheckpointScriptCursor")) != target_cursor:
                raise AssertionError(f"{label}: selected checkpoint script cursor differs")
            cursor_pointer = _word_at(
                h.m, h.offset("CheckpointCursorPtrs") + 2 * level)
            if _word_at(h.m, cursor_pointer) != target_cursor:
                raise AssertionError(f"{label}: selected level cursor was not restored")
            if _word_at(h.m, h.offset("ScrollSubRow")) != 0:
                raise AssertionError(f"{label}: scroll-back did not stop at a row boundary")
            count += 1
    return count


def _boss_cases(h, arena: Arena, baseline_state: bytes,
                baseline_memory: bytes) -> int:
    actor = h.offset("PoolA")
    cases = (
        (0x76, 0x0050, 0xFFF0, 0x40, 0x20),
        (0x77, 0xFFEC, 0xFFF0, 0x40, 0x20),
        (0x78, 0x0050, 0xFFF0, 0x0F, 0x20),
        (0x78, 0x0050, 0xFFF0, 0x10, 0x20),
        (0x79, 0xFFE0, 0xFFF0, 0x40, 0x20),
    )
    stack_begin = h.m.data_frame * 16 + h.offset("StackArea")
    stack_end = h.m.data_frame * 16 + h.m.stack_top
    count = 0
    for enemy_type, boss_x, boss_y, phase, scroll in cases:
        _reset_runtime(h, arena, baseline_state, baseline_memory)
        writes = [
            (actor, _record(type=enemy_type)),
            _word(h, "LevelEndPhase", 1),
            _word(h, "SegBossX", boss_x),
            _word(h, "SegBossY", boss_y),
            _word(h, "ScrollDeltaY", scroll),
            _word(h, "FrameCount128", phase),
            _word(h, "PoolBCursor", h.offset("PoolBEnd")),
        ]
        for index in range(K.POOL_B_COUNT):
            status = 0 if index == 2 else 1
            writes.append((h.offset("PoolB") + index * K.RECORD_SIZE + K.REC_STATUS,
                           struct.pack("<H", status)))
        _put(h, writes)
        before = bytes(h.m.u.mem_read(0, DOS_MEMORY_BYTES))
        arena.load(before)

        h.lib.run_type_handler(ctypes.c_void_p(h.state_addr + actor))
        ctypes.memmove(arena.base + h.m.data_frame * 16,
                       h.state_storage.snapshot(), STATE_BYTES)
        native_after = arena.snapshot()

        h.m.call("RunTypeHandler", {"BP": actor})
        oracle_after = bytes(h.m.u.mem_read(0, DOS_MEMORY_BYTES))
        label = f"RunTypeHandler type={enemy_type:02X} phase={phase:02X} scroll={scroll:04X}"
        h.compare(label)
        _compare_arena(native_after, oracle_after, stack_begin, stack_end, label)
        part = enemy_type - 0x76
        y_offset, x_offset = struct.unpack_from(
            "<2H", h.state_storage.snapshot(), h.offset("BossPartOffsets") + 4 * part)
        expected_y = (y_offset + boss_y) & 0xFFFF
        if expected_y & 0x8000:
            expected_y = 0
        expected_y = (expected_y + scroll) & 0xFFFF
        expected_x = (x_offset + boss_x) & 0xFFFF
        if _word_at(h.m, actor + K.REC_Y) != expected_y:
            raise AssertionError(f"{label}: part Y does not match wrapped/clamped offset")
        if _word_at(h.m, actor + K.REC_X) != expected_x:
            raise AssertionError(f"{label}: part X does not match wrapped offset")
        if enemy_type == 0x78:
            shot_status = _word_at(h.m, h.offset("PoolB") +
                                   2 * K.RECORD_SIZE + K.REC_STATUS)
            expected_shot = int(phase <= 0x0F)
            if shot_status != expected_shot:
                raise AssertionError(
                    f"{label}: core phase shot status {shot_status}, expected {expected_shot}")
        count += 1
    return count


def _boss_path_cases(h, arena: Arena, baseline_state: bytes,
                     baseline_memory: bytes) -> int:
    anchor = h.offset("PoolA")
    boss_path = h.offset("BossPath")
    cases = (
        # The reached FFFCh point advances to DS:0000 and the same call steers toward
        # the next point; this checks wrapped cursor storage with two bounded waypoints.
        (0xFFFC, 0x0050, 0x0040,
         struct.pack("<4H", 0x0020, 0x0050, 0x0050, 0x0080),
         "arrival cursor wraps FFFC to 0000"),
        # An FFFF sentinel at the end of DS restarts on the real BossPath table.
        (0xFFFE, 0x0000, 0x0000,
         struct.pack("<H", NO_RECORD), "FFFF sentinel resets to BossPath"),
        # First production waypoint steers from the origin without arrival.
        (boss_path, 0x0000, 0x0000, b"", "production path first waypoint"),
    )
    stack_begin = h.m.data_frame * 16 + h.offset("StackArea")
    stack_end = h.m.data_frame * 16 + h.m.stack_top
    for cursor, x, y, path_bytes, label_tail in cases:
        _reset_runtime(h, arena, baseline_state, baseline_memory)
        writes = [
            (anchor, _record(x=0xAAAA, y=0xBBBB)),
            _word(h, "SegBossAnchor", anchor),
            _word(h, "SegBossPathCursor", cursor),
            _word(h, "SegBossX", x),
            _word(h, "SegBossY", y),
            _word(h, "LevelEndPhase", 1),
        ]
        if path_bytes:
            if cursor == 0xFFFC:
                writes.append((cursor, path_bytes[:4]))
                writes.append((0, path_bytes[4:]))
            else:
                writes.append((cursor, path_bytes))
        _put(h, writes)
        before = bytes(h.m.u.mem_read(0, DOS_MEMORY_BYTES))
        arena.load(before)

        h.lib.steer_seg_boss_along_path()
        ctypes.memmove(arena.base + h.m.data_frame * 16,
                       h.state_storage.snapshot(), STATE_BYTES)
        native_after = arena.snapshot()

        h.m.call("SteerSegBossAlongPath")
        oracle_after = bytes(h.m.u.mem_read(0, DOS_MEMORY_BYTES))
        label = f"SteerSegBossAlongPath {label_tail}"
        h.compare(label)
        _compare_arena(native_after, oracle_after, stack_begin, stack_end, label)
        if cursor == 0xFFFC and _word_at(h.m, h.offset("SegBossPathCursor")) != 0:
            raise AssertionError(f"{label}: reached waypoint did not wrap cursor to DS:0000")
        if cursor == 0xFFFE and _word_at(h.m, h.offset("SegBossPathCursor")) != boss_path:
            raise AssertionError(f"{label}: FFFF marker did not reset to BossPath")
    return len(cases)


def run(no_build: bool = False) -> int:
    if no_build:
        if not HOST_CORE.is_file() or not HOST_STATE.is_file() or not HOST_IMAGE.is_file():
            raise FileNotFoundError("--no-build requires the current host core and generated arena")
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    input_harness = _load_module("host_input_harness_checkpoints", ROOT / "tests/host/input.py")
    h = input_harness.HostHarness()
    _bind_native(h.lib)
    arena = Arena(h)

    # These bounded startup helpers establish the same allocated buffers and Tandy scroll
    # geometry that the restart routine's retained map-row renderer expects.
    h.m.start_runtime(adapter=2)
    baseline_state = h.m.state()
    baseline_memory = bytes(h.m.u.mem_read(0, DOS_MEMORY_BYTES))
    h.state_storage.load(baseline_state)
    arena.load(baseline_memory)
    h.check_canaries()

    restart_count = _restart_cases(h, arena, baseline_state, baseline_memory)
    boss_count = _boss_cases(h, arena, baseline_state, baseline_memory)
    path_count = _boss_path_cases(h, arena, baseline_state, baseline_memory)
    h.check_canaries()
    total = restart_count + boss_count + path_count
    print(f"PASS host checkpoints/boss: {total} bounded oracle cases "
          f"({restart_count} actual checkpoint restarts, {boss_count} segmented parts/core "
          f"placement and fire phases, {path_count} boss path/wrap cases)")
    return total


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="reuse build/host and build/oracle-sym artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
