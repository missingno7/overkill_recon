"""Checkpoint map-restoration and music policy checks against the DOS oracle.

Run ``python tests/host/level_policies.py`` to build the native core and run the
fixtures. ``--no-build`` uses the current host core and oracle artifacts.
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
DOS_MEMORY_BYTES = 0x100000
STATE_BYTES = 0x10000
MAP_CACHE_SEGMENT = 0x9000
TEST_MAP_SEGMENT = 0x6000
NO_RECORD = 0xFFFF
LOOKBACK_BYTES = 0x9C

sys.path.insert(0, str(TOOLS))
from world import K  # noqa: E402


class TileRestoration(ctypes.Structure):
    _fields_ = (("tile", ctypes.c_uint8), ("replacement", ctypes.c_uint8))


class CheckpointRestart(ctypes.Structure):
    _fields_ = (("lookback_rows", ctypes.c_uint16),
                ("rule_count", ctypes.c_uint16),
                ("rules", ctypes.POINTER(TileRestoration)))


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _word_at(machine, offset: int) -> int:
    return struct.unpack("<H", machine.read(offset, 2))[0]


def _byte_at(machine, offset: int) -> int:
    return machine.read(offset, 1)[0]


def _native_byte(h, name: str) -> int:
    return h.state_storage.snapshot()[h.offset(name)]


def _word(h, name: str, value: int) -> tuple[int, bytes]:
    return h.offset(name), struct.pack("<H", value & 0xFFFF)


def _read_reset_rules(machine, level: int) -> list[tuple[int, int]]:
    cursor = machine.linear(f"MapResetList{level}")
    set_tile_1 = machine.symbols["SETMAPTILE1"][1]
    set_tile_28 = machine.symbols["SETMAPTILE28"][1]
    result = []
    for _ in range(0x4000):
        tile, handler = struct.unpack("<2H", bytes(machine.u.mem_read(cursor, 4)))
        if tile == 0xFFFF:
            return result
        if tile > 0xFF:
            raise AssertionError(f"level {level}: reset rule compares a word tile {tile:04X}")
        if handler == set_tile_1:
            replacement = 1
        elif handler == set_tile_28:
            replacement = 0x28
        else:
            raise AssertionError(f"level {level}: unknown reset handler {handler:04X}")
        result.append((tile, replacement))
        cursor += 4
    raise AssertionError(f"level {level}: unterminated MapResetList")


def _bind_policy_api(h) -> None:
    h.lib.reset_map_before_view.argtypes = ()
    h.lib.reset_map_before_view.restype = None
    h.lib.overkill_level_checkpoint_restart.argtypes = (ctypes.c_uint16,)
    h.lib.overkill_level_checkpoint_restart.restype = ctypes.POINTER(CheckpointRestart)
    h.lib.overkill_level_music.argtypes = (ctypes.c_uint16,)
    h.lib.overkill_level_music.restype = ctypes.c_uint8
    h.lib.overkill_level_policy_bind.argtypes = (
        ctypes.c_uint16, ctypes.POINTER(CheckpointRestart), ctypes.POINTER(ctypes.c_uint8))
    h.lib.overkill_level_policy_bind.restype = None
    h.lib.request_life_start_music.argtypes = (ctypes.c_uint16,)
    h.lib.request_life_start_music.restype = ctypes.c_uint16
    h.lib.tick_frame_timers.argtypes = ()
    h.lib.tick_frame_timers.restype = None


def _reset_bindings(h) -> None:
    # The API borrows pointers. NULL restores the generated policy for that level.
    for level in range(K.LEVEL_COUNT):
        h.lib.overkill_level_policy_bind(level, None, None)


def _physical_compare(h, checkpoints, arena, native: bytes, label: str) -> None:
    oracle = bytes(h.m.u.mem_read(0, DOS_MEMORY_BYTES))
    h.compare(label)
    checkpoints._compare_arena(
        native, oracle,
        h.m.data_frame * 16 + h.offset("StackArea"),
        h.m.data_frame * 16 + h.m.stack_top,
        label)


def _call_reset_pair(h, checkpoints, arena, label: str) -> None:
    h.lib.reset_map_before_view()
    ctypes.memmove(arena.base + h.m.data_frame * 16,
                   h.state_storage.snapshot(), STATE_BYTES)
    native = arena.snapshot()
    h.m.call("ResetMapBeforeView")
    _physical_compare(h, checkpoints, arena, native, label)


def _install_map(h, arena, physical: bytes) -> None:
    if len(physical) != DOS_MEMORY_BYTES:
        raise ValueError("map fixture must be a full physical-memory image")
    h.m.u.mem_write(0, physical)
    arena.load(physical)


def _reset_map_case(h, checkpoints, arena, baseline_state: bytes,
                    baseline_memory: bytes, *, level_index: int,
                    position: int, label: str, mutate_list: bool = False) -> None:
    """Compare the exact reset loop with each tile rule and both edge guards."""
    h.m.set_state(baseline_state)
    h.state_storage.load(baseline_state)
    _install_map(h, arena, baseline_memory)
    rules = _read_reset_rules(h.m, level_index & 0x7FFF)
    if not rules:
        raise AssertionError(f"level {level_index:04X}: expected reset rules")

    # Also exercise a live DS pointer-table redirect to modified CS data. No source
    # table is copied into the native policy for canonical bindings.
    if mutate_list:
        level = level_index & 0x7FFF
        alternate_level = (level + 1) % K.LEVEL_COUNT
        alternate = _read_reset_rules(h.m, alternate_level)
        tile = 0x50 + level
        handler_name = "SETMAPTILE28" if level & 1 else "SETMAPTILE1"
        replacement = 0x28 if level & 1 else 1
        list_offset = h.m.symbols[f"MAPRESETLIST{alternate_level}"][1]
        handler_offset = h.m.symbols[handler_name][1]
        custom = struct.pack("<4H", tile, handler_offset, 0xFFFF, 0)
        custom_linear = h.m.linear(f"MapResetList{alternate_level}")
        h.m.u.mem_write(custom_linear, custom)
        h.write(h.offset("MapResetLists") + 2 * level, struct.pack("<H", list_offset))
        rules = [(tile, replacement)]

    h.write_symbol("LevelIndex", struct.pack("<H", level_index & 0xFFFF))
    h.write_symbol("MapScrollPos", struct.pack("<H", position & 0xFFFF))

    map_base = (arena.map_segment << 4) & 0xFFFFF
    # Put every rule into the lookback window. Position arithmetic is deliberately
    # word-sized, matching SI in ResetMapBeforeView.
    for index, (tile, _replacement) in enumerate(rules):
        offset = (position - 1 - index) & 0xFFFF
        h.m.u.mem_write(map_base + offset, bytes((tile,)))
    low_edge = (position - LOOKBACK_BYTES) & 0xFFFF
    high_guard = position & 0xFFFF
    low_guard = (position - LOOKBACK_BYTES - 1) & 0xFFFF
    guard_tile = rules[0][0]
    h.m.u.mem_write(map_base + low_edge, bytes((guard_tile,)))
    h.m.u.mem_write(map_base + high_guard, bytes((guard_tile,)))
    h.m.u.mem_write(map_base + low_guard, bytes((guard_tile,)))
    # A wrapped position must scan across FFFFh without widening its offsets.
    if position < LOOKBACK_BYTES and not mutate_list:
        h.m.u.mem_write(map_base + 0x0001, bytes((rules[-1][0],)))
        h.m.u.mem_write(map_base + 0xFFFF, bytes((rules[0][0],)))

    before = bytes(h.m.u.mem_read(0, DOS_MEMORY_BYTES))
    arena.load(before)
    _call_reset_pair(h, checkpoints, arena, label)

    # Verify exact boundaries in the map window after the pair of calls. A direct
    # run is used here so the scan's byte offsets have not been scrolled afterward.
    after = arena.snapshot()
    for offset, expected in ((low_edge, rules[0][1]),
                             (high_guard, guard_tile), (low_guard, guard_tile)):
        actual = after[(map_base + offset) & 0xFFFFF]
        if actual != expected:
            raise AssertionError(
                f"{label}: map[{offset:04X}]={actual:02X}, expected {expected:02X}")


def _authored_reset_case(h, arena, baseline_state: bytes,
                         baseline_memory: bytes) -> int:
    """An explicit rule array remains independent and preserves first-match order."""
    h.m.set_state(baseline_state)
    h.state_storage.load(baseline_state)
    arena.load(baseline_memory)
    level = 1
    duplicate_tile = 0x44
    authored_rules = (TileRestoration * 2)(
        TileRestoration(duplicate_tile, 0x31),
        TileRestoration(duplicate_tile, 0x42))
    descriptor = CheckpointRestart(12, 2, authored_rules)
    h.lib.overkill_level_policy_bind(level, ctypes.byref(descriptor), None)
    selected = h.lib.overkill_level_checkpoint_restart(level)
    if not selected or selected.contents.rule_count != 2:
        raise AssertionError("authored checkpoint reset descriptor was not selected")

    h.write_symbol("LevelIndex", struct.pack("<H", level))
    position = 0x0300
    h.write_symbol("MapScrollPos", struct.pack("<H", position))
    legacy_list = _read_reset_rules(h.m, level)
    map_base = (arena.map_segment << 4) & 0xFFFFF
    h.m.u.mem_write(map_base, bytes((0x55,)) * STATE_BYTES)
    inside = (position - 7) & 0xFFFF
    outside = (position - LOOKBACK_BYTES - 1) & 0xFFFF
    h.m.u.mem_write(map_base + inside, bytes((duplicate_tile,)))
    h.m.u.mem_write(map_base + outside, bytes((duplicate_tile,)))
    legacy_tile = legacy_list[0][0]
    h.m.u.mem_write(map_base + ((position - 8) & 0xFFFF), bytes((legacy_tile,)))
    before = bytes(h.m.u.mem_read(0, DOS_MEMORY_BYTES))
    arena.load(before)
    h.lib.reset_map_before_view()
    ctypes.memmove(arena.base + h.m.data_frame * 16,
                   h.state_storage.snapshot(), STATE_BYTES)
    after = arena.snapshot()
    if after[(map_base + inside) & 0xFFFFF] != 0x31:
        raise AssertionError("duplicate authored reset rules did not use the first match")
    if after[(map_base + outside) & 0xFFFFF] != duplicate_tile:
        raise AssertionError("authored reset changed the byte below its lookback window")
    if after[(map_base + ((position - 8) & 0xFFFF)) & 0xFFFFF] != legacy_tile:
        raise AssertionError("authored reset also applied the legacy CS list")
    h.lib.overkill_level_policy_bind(level, None, None)
    return 1


def _full_restart_cases(h, checkpoints, arena, baseline_state: bytes,
                        baseline_memory: bytes) -> int:
    """Restart each level after loading map data containing every reset tile."""
    player = h.offset("PrimaryRecord")
    count = 0
    for level in range(K.LEVEL_COUNT):
        h.m.set_state(baseline_state)
        rules = _read_reset_rules(h.m, level)
        checkpoints_pointer = _word_at(h.m, h.offset("LevelCheckpointPtrs") + 2 * level)
        entries = [tuple(_word_at(h.m, (checkpoints_pointer + 8 * index + 2 * field) & 0xFFFF)
                         for field in range(4)) for index in range(4)]
        target, target_clock, target_cursor, _ = entries[1]
        initial_scroll = entries[0][3]
        if target < LOOKBACK_BYTES + len(rules):
            raise AssertionError(f"level {level}: checkpoint does not fit reset fixture")
        map_data = bytearray([0x55]) * K.MAP_END_POS
        lower = target - LOOKBACK_BYTES
        for index, (tile, _replacement) in enumerate(rules):
            map_data[target - 1 - index] = tile
        # The immediately excluded bytes carry a reset value but must not be
        # changed by ResetMapBeforeView. Scroll-back still gets the normal map.
        map_data[target] = rules[0][0]
        map_data[lower - 1] = rules[-1][0]
        end_rows = h.m.read(h.offset("LevelEndMapRows"), 5 * K.MAP_ROW_BYTES)
        map_data[K.MAP_END_ROWS_POS:K.MAP_END_ROWS_POS + len(end_rows)] = end_rows

        h.m.set_state(baseline_state)
        h.state_storage.load(baseline_state)
        arena.load(baseline_memory)
        filename = _word_at(h.m, h.offset("LevelMapFiles") + 2 * level)
        cache = struct.pack("<5H", filename, MAP_CACHE_SEGMENT,
                            len(map_data), 0, 0)
        cache += struct.pack("<5H", NO_RECORD, 0, 0, 0, 0)
        writes = [
            (player, checkpoints._record(kind=K.KIND_PLAYER, type=0)),
            _word(h, "LevelIndex", level),
            _word(h, "MapScrollPos", initial_scroll),
            _word(h, "LevelScriptClock", 0x6A5B),
            _word(h, "ScrollSubRow", 3),
            _word(h, "ScrollWindowOffset", checkpoints._main_word(h.m, "ScrollStartOffset")),
            _word(h, "ScrollDeltaY", 0xFFF0),
            _word(h, "LastTileStepBackward", level & 1),
            _word(h, "ScrollingBackward", 0),
            (h.offset("FileCache"), cache),
        ]
        for offset, data in writes:
            h.write(offset, data)
        h.m.u.mem_write(MAP_CACHE_SEGMENT << 4, bytes(map_data))
        before = bytes(h.m.u.mem_read(0, DOS_MEMORY_BYTES))
        arena.load(before)
        ctypes.memmove(arena.base + h.m.data_frame * 16,
                       h.state_storage.snapshot(), STATE_BYTES)
        h.lib.restart_at_checkpoint(ctypes.c_void_p(h.state_addr + player))
        ctypes.memmove(arena.base + h.m.data_frame * 16,
                       h.state_storage.snapshot(), STATE_BYTES)
        native = arena.snapshot()
        h.m.call("RestartAtCheckpoint", {"BP": player})
        label = f"RestartAtCheckpoint reset-policy level={level} checkpoint=1"
        _physical_compare(h, checkpoints, arena, native, label)
        if _word_at(h.m, h.offset("MapScrollPos")) != target:
            raise AssertionError(f"{label}: restart ended at the wrong map position")
        if _word_at(h.m, h.offset("LevelScriptClock")) != target_clock:
            raise AssertionError(f"{label}: checkpoint clock was not restored")
        if _word_at(h.m, h.offset("CheckpointScriptCursor")) != target_cursor:
            raise AssertionError(f"{label}: checkpoint script cursor differs")
        # Retain the last byte in the reset interval as a boundary check; direct
        # cases above cover all rules before this scroll-back phase.
        last = ((arena.map_segment << 4) + target - 1) & 0xFFFFF
        expected = rules[0][1]
        if native[last] != expected:
            raise AssertionError(f"{label}: final reset-window byte differs")
        count += 1
    return count


def _music_consumer_cases(h, baseline_state: bytes) -> int:
    """Exercise the real life-start and encounter-end consumers with both bindings."""
    count = 0
    h.lib.overkill_level_policy_bind(2, None, None)
    for level in range(K.LEVEL_COUNT):
        tune = baseline_state[h.offset("LevelMusicTable") + level]
        for position in (K.MAP_START_POS - 1, K.MAP_START_POS,
                         K.MAP_MUSIC_CHANGE_POS, K.MAP_END_POS,
                         K.MAP_END_POS + 1, 0xFFFF):
            h.m.set_state(baseline_state)
            h.state_storage.load(baseline_state)
            h.write_symbol("LevelIndex", struct.pack("<H", level))
            h.write_symbol("MapScrollPos", struct.pack("<H", position))
            h.write_symbol("ModuleSoundEnabled", b"\x00")
            h.write_symbol("ModuleSoundRequest", b"\x55")
            returned = h.lib.request_life_start_music(0xB800)
            if returned != 0xB800:
                raise AssertionError("host life-start music changed the inherited ES value")
            h.m.call("RequestLifeStartMusic", {
                "BP": h.offset("PoolA"), "SI": 0xB800, "ES": 0xB800})
            label = f"RequestLifeStartMusic level={level} position={position:04X}"
            h.compare(label)
            expected = (K.MUSIC_LEVEL_START if position == K.MAP_START_POS else
                        K.MUSIC_LEVEL_END if position == K.MAP_END_POS else tune)
            if _byte_at(h.m, h.offset("ModuleSoundRequest")) != expected:
                raise AssertionError(
                    f"{label}: wrong requested tune "
                    f"got {_byte_at(h.m, h.offset('ModuleSoundRequest')):02X}, "
                    f"expected {expected:02X}, table {tune:02X}")
            count += 1

        # Encounter-end restoration reads the tune only when its delay reaches
        # zero and uses the late tune at equality with MAP_MUSIC_CHANGE_POS.
        for position in (K.MAP_MUSIC_CHANGE_POS - 1, K.MAP_MUSIC_CHANGE_POS):
            h.m.set_state(baseline_state)
            h.state_storage.load(baseline_state)
            for name, value in (("LevelIndex", level), ("MapScrollPos", position),
                                ("EncounterLiveCount", 0), ("EncounterEndDelay", 1)):
                h.write_symbol(name, struct.pack("<H", value & 0xFFFF))
            h.write_symbol("ModuleSoundEnabled", b"\x00")
            h.write_symbol("ModuleSoundRequest", b"\x55")
            h.lib.tick_frame_timers()
            h.m.call("TickFrameTimers")
            label = f"TickFrameTimers music level={level} position={position:04X}"
            h.compare(label)
            expected = tune if position < K.MAP_MUSIC_CHANGE_POS else K.MUSIC_LATE_LEVEL
            if _byte_at(h.m, h.offset("ModuleSoundRequest")) != expected:
                raise AssertionError(f"{label}: wrong requested tune")
            count += 1

    # Encounter music is requested only on the exact nonzero-to-zero delay edge,
    # after checking that no encounter member is still alive. The word decrement
    # must not be attempted for delay zero (including its underflow case).
    level = 0
    tune = baseline_state[h.offset("LevelMusicTable") + level]
    for live, delay, expected_delay in ((1, 1, 1), (0, 2, 1), (0, 0, 0),
                                        (0, 0xFFFF, 0xFFFE)):
        h.m.set_state(baseline_state)
        h.state_storage.load(baseline_state)
        for name, value in (("LevelIndex", level),
                            ("MapScrollPos", K.MAP_MUSIC_CHANGE_POS - 1),
                            ("EncounterLiveCount", live),
                            ("EncounterEndDelay", delay)):
            h.write_symbol(name, struct.pack("<H", value))
        h.write_symbol("ModuleSoundEnabled", b"\x00")
        h.write_symbol("ModuleSoundRequest", b"\x55")
        h.lib.tick_frame_timers()
        h.m.call("TickFrameTimers")
        label = f"TickFrameTimers music gate live={live} delay={delay:04X}"
        h.compare(label)
        if _word_at(h.m, h.offset("EncounterEndDelay")) != expected_delay:
            raise AssertionError(f"{label}: wrong delay transition")
        if _byte_at(h.m, h.offset("ModuleSoundRequest")) != 0x55:
            raise AssertionError(f"{label}: requested music without a delay edge")
        count += 1

    # The tune is read when the delay expires, not when the delay is first armed.
    h.m.set_state(baseline_state)
    h.state_storage.load(baseline_state)
    for name, value in (("LevelIndex", 0),
                        ("MapScrollPos", K.MAP_MUSIC_CHANGE_POS - 1),
                        ("EncounterLiveCount", 0), ("EncounterEndDelay", 2)):
        h.write_symbol(name, struct.pack("<H", value))
    h.write_symbol("ModuleSoundEnabled", b"\x00")
    h.write_symbol("ModuleSoundRequest", b"\x55")
    h.lib.tick_frame_timers()
    h.m.call("TickFrameTimers")
    h.compare("TickFrameTimers music delay armed")
    if _byte_at(h.m, h.offset("ModuleSoundRequest")) != 0x55:
        raise AssertionError("music was requested before the delay expired")
    changed_tune = 0x0C
    h.write(h.offset("LevelMusicTable"), bytes((changed_tune,)))
    h.lib.tick_frame_timers()
    h.m.call("TickFrameTimers")
    h.compare("TickFrameTimers music reads live tune at expiry")
    if _byte_at(h.m, h.offset("ModuleSoundRequest")) != changed_tune:
        raise AssertionError("encounter-end music did not read the mutated live tune")
    count += 2

    # Explicit music is independent per level and is consumed by both procedures.
    authored_tune = ctypes.c_uint8(0x0A)
    h.lib.overkill_level_policy_bind(2, None, ctypes.byref(authored_tune))
    h.m.set_state(baseline_state)
    h.state_storage.load(baseline_state)
    for name, value in (("LevelIndex", 2), ("MapScrollPos", K.MAP_START_POS - 1)):
        h.write_symbol(name, struct.pack("<H", value & 0xFFFF))
    h.write_symbol("ModuleSoundEnabled", b"\x00")
    h.write_symbol("ModuleSoundRequest", b"\x55")
    h.lib.request_life_start_music(0xB800)
    if _native_byte(h, "ModuleSoundRequest") != authored_tune.value:
        raise AssertionError(
            "life-start consumer ignored authored music: "
            f"got {_native_byte(h, 'ModuleSoundRequest'):02X}, "
            f"lookup {h.lib.overkill_level_music(2):02X}")

    # Authored music is bypassed at the exact start/end positions, where the
    # original requests their transition tunes. These branches remain comparable
    # byte-for-byte with the DOS oracle despite the authored override.
    for position, expected in ((K.MAP_START_POS, K.MUSIC_LEVEL_START),
                               (K.MAP_END_POS, K.MUSIC_LEVEL_END)):
        h.m.set_state(baseline_state)
        h.state_storage.load(baseline_state)
        for name, value in (("LevelIndex", 2), ("MapScrollPos", position)):
            h.write_symbol(name, struct.pack("<H", value))
        h.write_symbol("ModuleSoundEnabled", b"\x00")
        h.write_symbol("ModuleSoundRequest", b"\x55")
        h.lib.request_life_start_music(0xB800)
        h.m.call("RequestLifeStartMusic", {
            "BP": h.offset("PoolA"), "SI": 0xB800, "ES": 0xB800})
        label = f"RequestLifeStartMusic authored boundary {position:04X}"
        h.compare(label)
        if _byte_at(h.m, h.offset("ModuleSoundRequest")) != expected:
            raise AssertionError(f"{label}: transition tune was overridden")
        count += 1

    h.m.set_state(baseline_state)
    h.state_storage.load(baseline_state)
    for name, value in (("LevelIndex", 2), ("MapScrollPos", K.MAP_MUSIC_CHANGE_POS - 1),
                        ("EncounterLiveCount", 0), ("EncounterEndDelay", 1)):
        h.write_symbol(name, struct.pack("<H", value & 0xFFFF))
    h.write_symbol("ModuleSoundEnabled", b"\x00")
    h.write_symbol("ModuleSoundRequest", b"\x55")
    h.lib.tick_frame_timers()
    if _native_byte(h, "ModuleSoundRequest") != authored_tune.value:
        raise AssertionError("encounter-end consumer ignored authored music")

    # Late-level music likewise takes precedence at the threshold, even while an
    # authored ordinary level tune is bound.
    h.m.set_state(baseline_state)
    h.state_storage.load(baseline_state)
    for name, value in (("LevelIndex", 2),
                        ("MapScrollPos", K.MAP_MUSIC_CHANGE_POS),
                        ("EncounterLiveCount", 0), ("EncounterEndDelay", 1)):
        h.write_symbol(name, struct.pack("<H", value))
    h.write_symbol("ModuleSoundEnabled", b"\x00")
    h.write_symbol("ModuleSoundRequest", b"\x55")
    h.lib.tick_frame_timers()
    h.m.call("TickFrameTimers")
    h.compare("TickFrameTimers authored late-level override")
    if _byte_at(h.m, h.offset("ModuleSoundRequest")) != K.MUSIC_LATE_LEVEL:
        raise AssertionError("authored music overrode late-level transition tune")
    count += 1
    h.lib.overkill_level_policy_bind(2, None, None)
    return count + 2


def _music_lookup_cases(h, baseline_state: bytes) -> int:
    """Legacy music stays a live low-byte lookup outside authored indices."""
    h.m.set_state(baseline_state)
    h.state_storage.load(baseline_state)
    table = h.offset("LevelMusicTable")
    for index, value in enumerate((0x0A, 0x09, 0x08, 0x07, 0x06, 0x05,
                                   0x04, 0x03, 0x02, 0x01)):
        h.write(table + index, bytes((value,)))
    count = 0
    for index in (0, 5, 0x0100, 0x0105, 0x0106, 0x01FF, 0xFFFF):
        expected = _byte_at(h.m, table + (index & 0xFF))
        actual = h.lib.overkill_level_music(index)
        if actual != expected:
            raise AssertionError(
                f"legacy music lookup {index:04X}: got {actual:02X}, expected {expected:02X}")
        count += 1
    authored = ctypes.c_uint8(0x0A)
    h.lib.overkill_level_policy_bind(2, None, ctypes.byref(authored))
    if h.lib.overkill_level_music(2) != authored.value:
        raise AssertionError("authored music lookup ignored its independent binding")
    if h.lib.overkill_level_music(0x0102) != _byte_at(h.m, table + 2):
        raise AssertionError("out-of-range music lookup incorrectly selected level 2 override")
    h.lib.overkill_level_policy_bind(2, None, None)
    return count + 2


def run(no_build: bool = False) -> int:
    if no_build:
        host_dir = ROOT / "build/host"
        host_core = host_dir / ("OVERKILL_CORE.dll" if sys.platform == "win32"
                                else "liboverkill_core.so")
        host_image, host_state = host_dir / "HOST_IMAGE.BIN", host_dir / "STATE.BIN"
        if not host_core.is_file() or not host_image.is_file() or not host_state.is_file():
            raise FileNotFoundError("--no-build requires the current host and oracle artifacts")
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build
        host_build.build()

    input_harness = _load_module("level_policy_input", ROOT / "tests/host/input.py")
    checkpoints = _load_module("level_policy_checkpoints", ROOT / "tests/host/checkpoints.py")
    h = input_harness.HostHarness()
    checkpoints._bind_native(h.lib)
    _bind_policy_api(h)
    _reset_bindings(h)
    arena = checkpoints.Arena(h)
    h.m.start_runtime(adapter=2)
    # The game's default map segment nearly adjoins DS; a wrapped 16-bit map offset
    # can therefore alias DS bytes. Keep the policy fixture's map in a separate
    # physical window so state synchronization does not overwrite map mutations.
    h.m.u.mem_write(h.m.linear("LevelMapSegment"), struct.pack("<H", TEST_MAP_SEGMENT))
    arena.map_segment = TEST_MAP_SEGMENT
    if not h.lib.overkill_bind_level_map(arena.base + (TEST_MAP_SEGMENT << 4), STATE_BYTES):
        raise AssertionError("native core rejected isolated policy map window")
    baseline_state = h.m.state()
    baseline_memory = bytes(h.m.u.mem_read(0, DOS_MEMORY_BYTES))
    h.state_storage.load(baseline_state)
    arena.load(baseline_memory)

    reset_count = 0
    for level in range(K.LEVEL_COUNT):
        rules = _read_reset_rules(h.m, level)
        # Each entry fires once; the low/high boundary bytes are inclusive and the
        # bytes immediately outside remain unchanged. LevelIndex bit-15 aliasing is
        # also checked in the direct test for each definition.
        position = 0x0300
        _reset_map_case(h, checkpoints, arena, baseline_state, baseline_memory,
                        level_index=level, position=position,
                        label=f"ResetMapBeforeView all rules level={level}")
        _reset_map_case(h, checkpoints, arena, baseline_state, baseline_memory,
                        level_index=0x8000 + level, position=0x0050,
                        label=f"ResetMapBeforeView wrapped level={level}")
        reset_count += 2
    # One canonical binding follows both the live DS table slot and its live CS list.
    _reset_map_case(h, checkpoints, arena, baseline_state, baseline_memory,
                    level_index=0, position=0x0300,
                    label="ResetMapBeforeView live DS pointer and CS list", mutate_list=True)
    reset_count += 1
    reset_count += _authored_reset_case(h, arena, baseline_state, baseline_memory)
    restart_count = _full_restart_cases(h, checkpoints, arena, baseline_state, baseline_memory)
    music_count = _music_lookup_cases(h, baseline_state)
    music_count += _music_consumer_cases(h, baseline_state)
    h.check_canaries()
    total = reset_count + restart_count + music_count
    print(f"PASS host level policies: {total} checks "
          f"({reset_count} reset rules/aliases, {restart_count} full restarts, "
          f"{music_count} music consumer cases)")
    return total


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="reuse build/host and build/oracle-sym artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
