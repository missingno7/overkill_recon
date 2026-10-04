"""Owned ordinary-waypoint content vs the original path-following oracle.

Run against an already-built host core with ``python tests/host/waypoint_content.py``.
The test does not build or mutate shared generated artifacts.
"""
from __future__ import annotations

import copy
import ctypes
import importlib.util
from pathlib import Path
import random
import struct
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
HOST_TESTS = ROOT / "tests/host"
sys.path.insert(0, str(TOOLS))

from common import write_json  # noqa: E402
from export_original_levels import script_event_boundaries  # noqa: E402,F401
from level_content import duplicate_original as _duplicate_latest, validate_directory  # noqa: E402
from level_format import load, original_paths  # noqa: E402
from level_paths import PATH_BINDINGS, source_paths  # noqa: E402
from level_presets import ARCHETYPES  # noqa: E402
from level_waypoints import ORDINARY_WAYPOINT_NAMES  # noqa: E402
from world import K  # noqa: E402


def duplicate_original(profile, directory, identity, music=None):
    """Keep this suite pinned to v10 ordinary-route semantics."""
    document = _duplicate_latest(profile, directory, identity, music)
    document['version'] = 10
    write_json(Path(directory) / 'level.json', document)
    validate_directory(directory)
    return document


class _Waypoint(ctypes.Structure):
    _fields_ = [("y", ctypes.c_uint16), ("x", ctypes.c_uint16),
                ("terminal", ctypes.c_uint8)]


class _Waypoints(ctypes.Structure):
    _fields_ = [("point_count", ctypes.c_uint16),
                ("starts", ctypes.c_uint16 * 10),
                ("points", ctypes.POINTER(_Waypoint))]


def _module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    result = importlib.util.module_from_spec(spec)
    sys.modules[name] = result
    spec.loader.exec_module(result)
    return result


input_harness = _module("waypoint_content_input", HOST_TESTS / "input.py")
checkpoints = _module("waypoint_content_checkpoints", HOST_TESTS / "checkpoints.py")

_STARTER_TYPES = {
    "path_follower_a": 0x10,
    "path_follower_b": 0x11,
    "path_follower_c": 0x41,
    "path_follower_d": 0x43,
    "path_follower_e": 0x44,
    "path_follower_f": 0x45,
    "path_follower_g": 0x4A,
    "demo_path_follower": 0x51,
    "path_follower_left": 0x66,
    "path_follower_right": 0x67,
}


def _bind_api(lib) -> None:
    lib.overkill_level_content_load.argtypes = (
        ctypes.c_char_p, ctypes.c_char_p, ctypes.c_char_p, ctypes.c_size_t,
    )
    lib.overkill_level_content_load.restype = ctypes.c_int
    lib.overkill_level_content_unload.argtypes = ()
    lib.overkill_level_content_unload.restype = None
    lib.overkill_level_content_id.argtypes = ()
    lib.overkill_level_content_id.restype = ctypes.c_char_p
    lib.overkill_level_content_behavior_profile.argtypes = ()
    lib.overkill_level_content_behavior_profile.restype = ctypes.c_uint16
    lib.overkill_level_waypoints_current.argtypes = ()
    lib.overkill_level_waypoints_current.restype = ctypes.POINTER(_Waypoints)
    lib.overkill_level_timeline_current.argtypes = ()
    lib.overkill_level_timeline_current.restype = ctypes.c_void_p
    lib.overkill_waypoint_start.argtypes = (ctypes.c_uint16,)
    lib.overkill_waypoint_start.restype = ctypes.c_uint16
    lib.overkill_waypoint_current_point.argtypes = (ctypes.c_uint16,)
    lib.overkill_waypoint_current_point.restype = ctypes.POINTER(_Waypoint)
    lib.run_type_handler.argtypes = (ctypes.c_void_p,)
    lib.run_type_handler.restype = None


def _load(h, directory: Path, profile: int) -> None:
    error = ctypes.create_string_buffer(512)
    if not h.lib.overkill_level_content_load(
        str(directory).encode(), str(ROOT / "levels/original").encode(), error, len(error)
    ):
        raise AssertionError(f"native loader rejected {directory.name}: "
                             f"{error.value.decode(errors='replace')}")
    identity = h.lib.overkill_level_content_id()
    if not identity or h.lib.overkill_level_content_behavior_profile() != profile:
        raise AssertionError("native loose waypoint identity/profile was not activated")


def _load_owned_waypoints(h, directory: Path, profile: int, identity: str) -> dict:
    document = duplicate_original(profile, directory, identity)
    write_json(directory / "level.json", document)
    validate_directory(directory)
    _load(h, directory, profile)
    return document


def _bind_waypoint_view(h, document: dict) -> tuple[list[int], int]:
    view_ptr = h.lib.overkill_level_waypoints_current()
    if not view_ptr:
        raise AssertionError("version-10 content did not bind an owned waypoint provider")
    view = view_ptr.contents
    starts = []
    cursor = 0
    expected_points = []
    defaults = source_paths(h.m)
    for index, name in enumerate(ORDINARY_WAYPOINT_NAMES):
        definition = document["paths"].get(name, defaults[name][2])
        starts.append(cursor)
        if view.starts[index] != cursor:
            raise AssertionError(f"{name}: provider start {view.starts[index]} != ordinal {cursor}")
        for point in definition["points"]:
            expected_points.append(((point["y"] - 32) & 0xFFFF,
                                    point["x"] & 0xFFFF, 0))
        expected_points.append((K.LEADER_END_Y, definition["end"]["x"] & 0xFFFF, 1))
        cursor += len(definition["points"]) + 1
    if view.point_count != cursor:
        raise AssertionError(f"provider point count {view.point_count} != {cursor}")
    for ordinal, expected in enumerate(expected_points):
        point_ptr = h.lib.overkill_waypoint_current_point(ordinal)
        if not point_ptr:
            raise AssertionError(f"provider omitted waypoint ordinal {ordinal}")
        point = point_ptr.contents
        actual = (point.y, point.x, point.terminal)
        if actual != expected:
            raise AssertionError(f"waypoint ordinal {ordinal}: {actual} != {expected}")
    out_of_range = h.lib.overkill_waypoint_current_point(cursor)
    if not out_of_range or (out_of_range.contents.y, out_of_range.contents.x,
                            out_of_range.contents.terminal) != (K.LEADER_END_Y, 0, 1):
        raise AssertionError("out-of-range waypoint did not return the safe terminal sentinel")
    source = source_paths(h.m)
    for index, name in enumerate(ORDINARY_WAYPOINT_NAMES):
        legacy_start = source[name][0]
        if h.lib.overkill_waypoint_start(legacy_start) != starts[index]:
            raise AssertionError(f"{name}: legacy starter did not map to its owned ordinal")
    return starts, cursor


def _baseline_memory(arena) -> bytes:
    memory = bytearray(arena.image)
    start = arena.map_segment << 4
    memory[start:start + 0x10000] = bytes([1]) * 0x10000
    return bytes(memory)


def _record_bytes(x: int, y: int, enemy_type: int, path: int) -> bytes:
    record = bytearray([0xA5]) * K.RECORD_SIZE
    values = {
        "status": 1, "x": x, "y": y, "direction": K.DIR_DOWN,
        "sprite": 0, "draw_pass": 1, "size_class": 1,
        "kind": K.KIND_ENEMY, "type": enemy_type, "hit_points": 7,
        "slot_index": 0xFFFF, "flash_timer": 0, "path": path,
        "saved_x": x, "saved_y": y, "entry_delay": 0,
    }
    for name, value in values.items():
        struct.pack_into("<H", record, getattr(K, "REC_" + name.upper()), value & 0xFFFF)
    return bytes(record)


def _write_ds_only(h, offset: int, data: bytes) -> None:
    ctypes.memmove(h.state_addr + offset, bytes(data), len(data))


def _run_handler(h, arena, *, content: Path, profile: int, level_index: int,
                 enemy_type: int, native_path: int, oracle_path: int,
                 x: int, y: int, demo: int = 0, last_row: bool = False,
                 compare_oracle: bool = True, source_writes=(), label: str) -> bytes:
    memory = _baseline_memory(arena)
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    pool = h.offset("PoolA")
    pool_b = h.offset("PoolB")
    h.write(pool, _record_bytes(x, y, enemy_type, native_path))
    for index in range(1, K.POOL_A_COUNT):
        record = bytearray([0xA5]) * K.RECORD_SIZE
        struct.pack_into("<H", record, K.REC_STATUS, 0)
        h.write(pool + index * K.RECORD_SIZE, record)
    for index in range(K.POOL_B_COUNT):
        record = bytearray([0xA5]) * K.RECORD_SIZE
        struct.pack_into("<H", record, K.REC_STATUS, 0)
        h.write(pool_b + index * K.RECORD_SIZE, record)
    for name, value in (
        ("LevelIndex", level_index), ("DemoActive", demo),
        ("PoolACursor", pool + K.RECORD_SIZE),
        ("PoolBCursor", pool_b + K.RECORD_SIZE),
        ("MapScrollPos", K.MAP_LAST_SPAWN_POS if last_row else 100 * K.MAP_ROW_BYTES),
        ("RecordTickCounter", 0x11), ("EncounterLiveCount", 1),
        ("DifficultySetting", 0),
    ):
        h.write(h.offset(name), struct.pack("<H", value & 0xFFFF))
    # A route ordinal belongs only to the native owned provider. The ASM oracle
    # retains the original DS byte offset for the same logical waypoint.
    _write_ds_only(h, pool + K.REC_PATH, struct.pack("<H", native_path))
    h.m.write(pool + K.REC_PATH, struct.pack("<H", oracle_path))
    for offset, data in source_writes:
        h.write(offset, data)
    before = bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES))
    arena.load(before)

    h.lib.run_type_handler(ctypes.c_void_p(h.state_addr + pool))
    native_state = h.state_storage.snapshot()
    ctypes.memmove(arena.base + h.m.data_frame * 16, native_state, 0x10000)
    native_memory = arena.snapshot()
    native_path_after = struct.unpack_from("<H", native_state, pool + K.REC_PATH)[0]

    if compare_oracle:
        h.m.call("RunTypeHandler", {"BP": pool})
        oracle_path_after = h.m.word(pool + K.REC_PATH)
        source = source_paths(h.m)
        view = h.lib.overkill_level_waypoints_current().contents
        for index, name in enumerate(ORDINARY_WAYPOINT_NAMES):
            start, capacity, _definition = source[name]
            if start <= oracle_path_after < start + capacity and (oracle_path_after - start) % 4 == 0:
                expected = view.starts[index] + (oracle_path_after - start) // 4
                if native_path_after != expected:
                    raise AssertionError(f"{label}: ordinal {native_path_after} does not match "
                                         f"ASM waypoint {name}/{(oracle_path_after - start) // 4}")
                break
        else:
            raise AssertionError(f"{label}: ASM cursor {oracle_path_after:04X} is not a waypoint")
        h.m.write(pool + K.REC_PATH, struct.pack("<H", native_path_after))
        h.compare(label)
        checkpoints._compare_arena(
            native_memory, bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)),
            h.m.data_frame * 16 + h.stack_lo,
            h.m.data_frame * 16 + h.m.stack_top,
            label,
        )
    return native_state


def _canonical_provider_cases(h, arena, work: Path) -> tuple[int, list[dict], list[list[int]]]:
    documents = [load(path) for path in original_paths()]
    counts = 0
    canonical_directories = []
    all_starts = []
    for profile, _ in enumerate(documents):
        directory = work / f"canonical-waypoints-{profile}"
        document = _load_owned_waypoints(
            h, directory, profile, f"waypoint_profile_{profile}"
        )
        starts, point_count = _bind_waypoint_view(h, document)
        canonical_directories.append(directory)
        all_starts.append(starts)
        counts += 1
    # The public preset order must be stable across profiles; original runtime
    # offsets select a preset, while the descriptor's behavior profile is metadata.
    if any(starts != all_starts[0] for starts in all_starts[1:]):
        raise AssertionError("original profiles produced inconsistent waypoint ordinals")
    return counts, documents, all_starts


def _execution_cases(h, arena, work: Path, documents: list[dict],
                     starts: list[int]) -> int:
    source = source_paths(h.m)
    cases = 0
    for profile in range(6):
        directory = work / f"canonical-waypoints-{profile}"
        _load(h, directory, profile)
        for preset_index, name in enumerate(ORDINARY_WAYPOINT_NAMES):
            legacy_start, _capacity, definition = source[name]
            points = definition["points"]
            first = points[0]
            demo = int((profile + preset_index) % 4 == 0)
            last_row = bool((profile + preset_index) % 3 == 0)
            state = _run_handler(
                h, arena, content=directory, profile=profile, level_index=profile,
                enemy_type=_STARTER_TYPES[name], native_path=0xBEEF,
                oracle_path=0xBEEF, x=(first["x"] + 64) & 0xFFFF,
                y=(first["y"] + 64) & 0xFFFF, demo=demo, last_row=last_row,
                label=f"owned {name} starter level={profile} demo={demo} lastrow={last_row}",
            )
            record = h.offset("PoolA")
            ordinal = struct.unpack_from("<H", state, record + K.REC_PATH)[0]
            if ordinal != starts[preset_index]:
                raise AssertionError(f"{name}: starter produced ordinal {ordinal}, expected {starts[preset_index]}")
            cases += 1

    # Visit every ordinary point from both sides of exact arrival. The terminal
    # fly-off point is encoded in the provider but canonical runtime never arrives
    # there; its cursor is reached when the preceding ordinary point is consumed.
    profile = 2
    directory = work / f"canonical-waypoints-{profile}"
    _load(h, directory, profile)
    for preset_index, name in enumerate(ORDINARY_WAYPOINT_NAMES):
        definition = source[name][2]
        for point_index, target in enumerate(definition["points"]):
            ordinal = starts[preset_index] + point_index
            offset = source[name][0] + 4 * point_index
            for arrival in (False, True):
                x, y = target["x"], target["y"]
                if not arrival:
                    x, y = (x + 64) & 0xFFFF, (y + 64) & 0xFFFF
                state = _run_handler(
                    h, arena, content=directory, profile=profile, level_index=profile,
                    enemy_type=0x12, native_path=ordinal, oracle_path=offset,
                    x=x, y=y, demo=(point_index + preset_index) % 2,
                    last_row=bool(point_index % 2),
                    label=f"owned {name} point={point_index} arrival={arrival}",
                )
                next_ordinal = struct.unpack_from(
                    "<H", state, h.offset("PoolA") + K.REC_PATH
                )[0]
                expected = ordinal + int(arrival)
                if next_ordinal != expected:
                    raise AssertionError(f"{name} point {point_index}: cursor {next_ordinal}, expected {expected}")
                cases += 1
    return cases


def _concurrent_cursors(h, arena, work: Path, starts: list[int]) -> int:
    """Several actors keep independent flattened cursors in one frame."""
    profile = 3
    directory = work / f"canonical-waypoints-{profile}"
    _load(h, directory, profile)
    memory = _baseline_memory(arena)
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    pool = h.offset("PoolA")
    names = ORDINARY_WAYPOINT_NAMES[:5]
    routes = [source_paths(h.m)[name] for name in names]
    for index, (name, route) in enumerate(zip(names, routes)):
        target = route[2]["points"][0]
        cursor = pool + index * K.RECORD_SIZE
        h.write(cursor, _record_bytes(target["x"] + 64, target["y"] + 64,
                                     0x12, starts[index]))
        _write_ds_only(h, cursor + K.REC_PATH, struct.pack("<H", starts[index]))
        h.m.write(cursor + K.REC_PATH, struct.pack("<H", route[0]))
    h.write(h.offset("LevelIndex"), struct.pack("<H", profile))
    h.write(h.offset("DemoActive"), struct.pack("<H", 0))
    before = bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES))
    arena.load(before)
    for index in range(len(names)):
        h.lib.run_type_handler(ctypes.c_void_p(h.state_addr + pool + index * K.RECORD_SIZE))
    native_state = h.state_storage.snapshot()
    ctypes.memmove(arena.base + h.m.data_frame * 16, native_state, 0x10000)
    native_memory = arena.snapshot()
    for index in range(len(names)):
        h.m.call("RunTypeHandler", {"BP": pool + index * K.RECORD_SIZE})
    for index in range(len(names)):
        native_path = struct.unpack_from("<H", native_state,
                                         pool + index * K.RECORD_SIZE + K.REC_PATH)[0]
        h.m.write(pool + index * K.RECORD_SIZE + K.REC_PATH,
                  struct.pack("<H", native_path))
    h.compare("five concurrent owned path cursors")
    checkpoints._compare_arena(
        native_memory, bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)),
        h.m.data_frame * 16 + h.stack_lo,
        h.m.data_frame * 16 + h.m.stack_top,
        "five concurrent owned path cursors",
    )
    for index in range(len(names)):
        got = struct.unpack_from("<H", native_state,
                                 pool + index * K.RECORD_SIZE + K.REC_PATH)[0]
        if got != starts[index]:
            raise AssertionError(f"concurrent {names[index]} cursor was cross-contaminated: {got}")
    return 1


def _authored_route_cases(h, arena, work: Path, starts: list[int]) -> int:
    profile = 1
    baseline_dir = work / "authored-route-baseline"
    original = duplicate_original(profile, baseline_dir, "route_baseline")
    write_json(baseline_dir / "level.json", original)
    validate_directory(baseline_dir)
    _load(h, baseline_dir, profile)
    baseline_view, _ = _bind_waypoint_view(h, original)
    defaults = source_paths(h.m)
    baseline_route = copy.deepcopy(original["paths"].get(
        "path_follower_a", defaults["path_follower_a"][2]
    ))
    base_point = baseline_route["points"][0]
    baseline_state = _run_handler(
        h, arena, content=baseline_dir, profile=profile, level_index=4,
        enemy_type=0x10, native_path=0, oracle_path=0,
        x=0, y=0, compare_oracle=False, label="baseline authored-route probe",
    )
    base_xy = struct.unpack_from("<2H", baseline_state,
                                 h.offset("PoolA") + K.REC_X)

    changed_dir = work / "authored-route-edited"
    edited = duplicate_original(profile, changed_dir, "route_edited")
    edited_route = copy.deepcopy(edited["paths"].get(
        "path_follower_a", defaults["path_follower_a"][2]
    ))
    edited["paths"]["path_follower_a"] = edited_route
    changed = edited_route["points"][0]
    changed.update(x=0, y=31)
    write_json(changed_dir / "level.json", edited)
    validate_directory(changed_dir)
    _load(h, changed_dir, profile)
    changed_starts, _ = _bind_waypoint_view(h, edited)
    if changed_starts != baseline_view:
        raise AssertionError("editing one route shifted unrelated flattened path starts")
    expected_encoded = ((31 - 32) & 0xFFFF, changed["x"] & 0xFFFF, 0)
    point = h.lib.overkill_waypoint_current_point(changed_starts[0]).contents
    if (point.y, point.x, point.terminal) != expected_encoded:
        raise AssertionError("authored Y=31 control-marker coordinate did not remain ordinary data")
    edited_state = _run_handler(
        h, arena, content=changed_dir, profile=profile, level_index=4,
        enemy_type=0x10, native_path=0, oracle_path=0,
        x=0, y=0, compare_oracle=False, label="edited route moves native actor",
    )
    edited_xy = struct.unpack_from("<2H", edited_state, h.offset("PoolA") + K.REC_X)
    if edited_xy == base_xy:
        raise AssertionError(f"authored ordinary path edit did not change movement: "
                             f"baseline={base_xy}, edited={edited_xy}, "
                             f"target={base_point}->{changed}")
    if _state_word(edited_state, h.offset("LevelIndex")) != 4:
        raise AssertionError("route lookup unexpectedly changed the gameplay behavior profile")
    legacy_start, legacy_capacity, _ = defaults["path_follower_a"]
    if (edited_state[legacy_start:legacy_start + legacy_capacity] !=
            h.baseline[legacy_start:legacy_start + legacy_capacity]):
        raise AssertionError("authored movement mutated the canonical DS path table")
    changed_source = struct.pack("<2H", 368, 200)
    mutated = _run_handler(
        h, arena, content=changed_dir, profile=profile, level_index=4,
        enemy_type=0x10, native_path=0, oracle_path=0, x=0, y=0,
        source_writes=((legacy_start, changed_source),), compare_oracle=False,
        label="authored movement ignores a mutated original path table",
    )
    expected = bytearray(edited_state)
    expected[legacy_start:legacy_start + 4] = changed_source
    if mutated != expected:
        raise AssertionError("a live DS path edit changed owned-path gameplay state")
    return 2


def _owned_terminal_and_long_route_cases(h, arena, work: Path) -> int:
    profile = 2
    defaults = source_paths(h.m)
    directory = work / "authored-long-route"
    document = duplicate_original(profile, directory, "authored_long_route")
    route = copy.deepcopy(document["paths"].get(
        "path_follower_a", defaults["path_follower_a"][2]
    ))
    original_count = len(defaults["path_follower_a"][2]["points"])
    while len(route["points"]) <= original_count + 4:
        route["points"].append({"x": -120, "y": 31})
    document["paths"]["path_follower_a"] = route
    write_json(directory / "level.json", document)
    validate_directory(directory)
    _load(h, directory, profile)
    starts, _ = _bind_waypoint_view(h, document)
    if len(route["points"]) <= original_count:
        raise AssertionError("authored route did not exceed its legacy source capacity")

    terminal_ordinal = starts[0] + len(route["points"])
    terminal = h.lib.overkill_waypoint_current_point(terminal_ordinal).contents
    if not terminal.terminal or (terminal.y, terminal.x) != (
        K.LEADER_END_Y, route["end"]["x"] & 0xFFFF
    ):
        raise AssertionError("authored fly-off terminal was not appended after the long route")
    terminal_state = _run_handler(
        h, arena, content=directory, profile=profile, level_index=5,
        enemy_type=0x12, native_path=terminal_ordinal,
        oracle_path=defaults["path_follower_a"][0] + 4 * len(route["points"]),
        x=route["end"]["x"], y=K.LEADER_END_Y + 32,
        compare_oracle=False, label="authored exact terminal arrival clamps route cursor",
    )
    got = _state_word(terminal_state, h.offset("PoolA") + K.REC_PATH)
    if got != terminal_ordinal:
        raise AssertionError(f"exact authored terminal arrival advanced to {got}, expected clamp {terminal_ordinal}")

    invalid_state = _run_handler(
        h, arena, content=directory, profile=profile, level_index=5,
        enemy_type=0x12, native_path=0xFFFF, oracle_path=0xFFFF,
        x=0, y=K.LEADER_END_Y + 32, compare_oracle=False,
        label="reserved invalid path ordinal clamps to safe terminal",
    )
    got = _state_word(invalid_state, h.offset("PoolA") + K.REC_PATH)
    if got != 0xFFFF:
        raise AssertionError(f"invalid ordinal read through another route; cursor became {got:04X}")

    long_ordinal = starts[0] + len(route["points"]) - 1
    extended = h.lib.overkill_waypoint_current_point(long_ordinal).contents
    if extended.terminal or extended.y != 0xFFFF or extended.x != ((-120) & 0xFFFF):
        raise AssertionError("long authored point after source capacity was not preserved")
    long_state = _run_handler(
        h, arena, content=directory, profile=profile, level_index=5,
        enemy_type=0x12, native_path=long_ordinal,
        oracle_path=defaults["path_follower_a"][0] + 4 * (len(route["points"]) - 1),
        x=-120, y=31, compare_oracle=False,
        label="long authored point exact arrival",
    )
    got = _state_word(long_state, h.offset("PoolA") + K.REC_PATH)
    if got != terminal_ordinal:
        raise AssertionError(f"long authored point did not advance to terminal: {got} != {terminal_ordinal}")
    return 3


def _state_word(state: bytes, offset: int) -> int:
    return struct.unpack_from("<H", state, offset)[0]


def _version_compatibility_cases(h, work: Path) -> int:
    # A v9 loose timeline stays loadable without activating the v10 waypoint
    # provider. Version 8 remains accepted through the same runtime loader.
    for version in (9, 8):
        profile = 5
        directory = work / f"waypoint-backward-v{version}"
        document = duplicate_original(profile, directory, f"waypoint_backward_v{version}")
        document["version"] = version
        if version == 8:
            document.pop("formation_spawn_parameters")
        write_json(directory / "level.json", document)
        validate_directory(directory)
        _load(h, directory, profile)
        if h.lib.overkill_level_waypoints_current():
            raise AssertionError(f"version {version} unexpectedly retained an owned waypoint provider")
        timeline = h.lib.overkill_level_timeline_current()
        if version == 9 and not timeline:
            raise AssertionError("version-9 downgrade lost its owned original timeline")
        if version == 8 and timeline:
            raise AssertionError("version-8 content unexpectedly activated version-9 timeline data")
        for name in ORDINARY_WAYPOINT_NAMES:
            legacy_start = source_paths(h.m)[name][0]
            if h.lib.overkill_waypoint_start(legacy_start) != legacy_start:
                raise AssertionError(f"version {version} did not preserve legacy DS path offsets")
    h.lib.overkill_level_content_unload()
    if h.lib.overkill_level_waypoints_current():
        raise AssertionError("unloading v10 content retained the waypoint provider")
    for name in ORDINARY_WAYPOINT_NAMES:
        legacy_start = source_paths(h.m)[name][0]
        if h.lib.overkill_waypoint_start(legacy_start) != legacy_start:
            raise AssertionError("unloaded content did not restore legacy DS path offsets")
    return 2


def _strict_rejections(h, work: Path) -> int:
    cases = []
    for suffix, edit in (
        ("empty", lambda path: path.update(points=[])),
        ("bool-coordinate", lambda path: path["points"][0].update(y=True)),
        ("bad-coordinate", lambda path: path["points"][0].update(x=32768)),
        ("bad-terminal", lambda path: path["end"].update(kind="restart")),
        ("removed-end", lambda path: path.pop("end")),
        ("special-edit", lambda path: path["points"][0].update(y=31)),
        ("unknown-name", lambda paths: paths.update(unknown_route={
            "points": [{"x": 0, "y": 32}], "end": {"kind": "fly_off", "x": 0}})),
        ("missing-special", lambda paths: paths.pop("boss_anchor")),
    ):
        cases.append((suffix, edit))
    successful = work / "waypoint-rejection-keeper"
    duplicate_original(0, successful, "waypoint_rejection_keeper")
    validate_directory(successful)
    _load(h, successful, 0)
    keeper_id = h.lib.overkill_level_content_id()
    keeper_provider = ctypes.cast(h.lib.overkill_level_waypoints_current(), ctypes.c_void_p).value
    count = 0
    for suffix, edit in cases:
        directory = work / f"waypoint-invalid-{suffix}"
        document = duplicate_original(0, directory, f"waypoint_invalid_{suffix}")
        path = (document["paths"] if suffix in ("unknown-name", "missing-special") else
                document["paths"]["path_follower_a" if suffix != "special-edit" else "sweep_loop"])
        edit(path)
        write_json(directory / "level.json", document)
        try:
            validate_directory(directory)
        except (ValueError, KeyError) as error:
            if isinstance(error, KeyError):
                raise AssertionError(f"Python validator leaked KeyError for {suffix}") from error
        else:
            raise AssertionError(f"Python validator accepted malformed waypoint edit {suffix}")
        error = ctypes.create_string_buffer(512)
        accepted = h.lib.overkill_level_content_load(
            str(directory).encode(), str(ROOT / "levels/original").encode(), error, len(error)
        )
        if accepted:
            raise AssertionError(f"native loader accepted malformed waypoint edit {suffix}")
        if not error.value:
            raise AssertionError(f"native loader omitted a diagnostic for {suffix}")
        if h.lib.overkill_level_content_id() != keeper_id:
            raise AssertionError(f"failed waypoint load {suffix} replaced live content")
        if ctypes.cast(h.lib.overkill_level_waypoints_current(), ctypes.c_void_p).value != keeper_provider:
            raise AssertionError(f"failed waypoint load {suffix} released the previous provider")
        count += 1
    return count


def run() -> int:
    h = input_harness.HostHarness()
    checkpoints._bind_native(h.lib)
    _bind_api(h.lib)
    arena = checkpoints.Arena(h)
    try:
        with tempfile.TemporaryDirectory(prefix="overkill-waypoint-content-") as temporary:
            work = Path(temporary)
            cases, documents, starts_by_profile = _canonical_provider_cases(h, arena, work)
            starts = starts_by_profile[0]
            cases += _execution_cases(h, arena, work, documents, starts)
            cases += _concurrent_cursors(h, arena, work, starts)
            cases += _authored_route_cases(h, arena, work, starts)
            cases += _owned_terminal_and_long_route_cases(h, arena, work)
            cases += _version_compatibility_cases(h, work)
            cases += _strict_rejections(h, work)
        h.lib.overkill_level_content_unload()
    finally:
        h.check_canaries()
    print(f"PASS owned waypoints: ten original presets, pointwise ASM comparisons, "
          f"authored route movement and version/rejection coverage; {cases} checks")
    return cases


if __name__ == "__main__":
    run()
