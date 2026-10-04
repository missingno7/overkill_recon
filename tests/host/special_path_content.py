"""Owned special-route content compared with the frozen ASM behavior.

Run against an already-built host core with
``python tests/host/special_path_content.py``. This test never builds shared
artifacts or runs a gameplay loop.
"""
from __future__ import annotations

import copy
import ctypes
import importlib.util
from pathlib import Path
import struct
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
HOST_TESTS = ROOT / "tests/host"
sys.path.insert(0, str(TOOLS))

from common import write_json  # noqa: E402
from level_content import duplicate_original, validate_directory  # noqa: E402
from level_paths import LEADER_BINDINGS, PATH_BINDINGS, source_paths  # noqa: E402
from world import K  # noqa: E402


class _SpecialPoint(ctypes.Structure):
    _fields_ = [("y", ctypes.c_uint16), ("x", ctypes.c_uint16),
                ("next", ctypes.c_uint16), ("control", ctypes.c_uint8)]


class _SpecialPaths(ctypes.Structure):
    _fields_ = [("point_count", ctypes.c_uint16),
                ("starts", ctypes.c_uint16 * 4),
                ("points", ctypes.POINTER(_SpecialPoint))]


def _module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    result = importlib.util.module_from_spec(spec)
    sys.modules[name] = result
    spec.loader.exec_module(result)
    return result


input_harness = _module("special_path_content_input", HOST_TESTS / "input.py")
checkpoints = _module("special_path_content_checkpoints", HOST_TESTS / "checkpoints.py")

SPECIAL_NAMES = ("sweep_lead_in", "sweep_loop", "encounter_leader", "boss_anchor")
SPECIAL_TYPES = {
    "sweep_lead_in": 0x18,
    "sweep_loop": 0x18,
    "encounter_leader": 0x21,
    "boss_anchor": 0x76,
}
SPECIAL_CS_CURSORS = {"encounter_leader": "Type21PathCursor"}


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
    lib.overkill_level_special_paths_current.argtypes = ()
    lib.overkill_level_special_paths_current.restype = ctypes.POINTER(_SpecialPaths)
    lib.overkill_special_path_start.argtypes = (ctypes.c_uint16,)
    lib.overkill_special_path_start.restype = ctypes.c_uint16
    lib.overkill_special_path_point.argtypes = (ctypes.c_uint16,)
    lib.overkill_special_path_point.restype = ctypes.POINTER(_SpecialPoint)
    lib.overkill_leader_start.argtypes = (ctypes.c_uint16,)
    lib.overkill_leader_start.restype = ctypes.c_uint16
    lib.overkill_leader_slot_start.argtypes = ()
    lib.overkill_leader_slot_start.restype = ctypes.c_uint16
    lib.run_type_handler.argtypes = (ctypes.c_void_p,)
    lib.run_type_handler.restype = None
    lib.steer_seg_boss_along_path.argtypes = ()
    lib.steer_seg_boss_along_path.restype = None
    lib.start_leader_script.argtypes = (ctypes.c_void_p, ctypes.c_uint16)
    lib.start_leader_script.restype = None
    lib.type13_formation_leader.argtypes = (ctypes.c_void_p,)
    lib.type13_formation_leader.restype = None
    lib.overkill_leader_start.argtypes = (ctypes.c_uint16,)
    lib.overkill_leader_start.restype = ctypes.c_uint16


def _load(h, directory: Path, profile: int) -> None:
    error = ctypes.create_string_buffer(512)
    if not h.lib.overkill_level_content_load(
        str(directory).encode(), str(ROOT / "levels/original").encode(), error, len(error)
    ):
        raise AssertionError(f"native loader rejected {directory.name}: "
                             f"{error.value.decode(errors='replace')}")
    identity = h.lib.overkill_level_content_id()
    if not identity or h.lib.overkill_level_content_behavior_profile() != profile:
        raise AssertionError("native loose special-path identity/profile was not activated")


def _definition(document: dict, name: str, sources: dict) -> dict:
    return document.get("paths", {}).get(name, sources[name][2])


def _expected_catalog(document: dict, sources: dict):
    cursor = 0
    starts = []
    expected = []
    for index, name in enumerate(SPECIAL_NAMES):
        definition = _definition(document, name, sources)
        starts.append(cursor)
        points = definition["points"]
        for point_index, point in enumerate(points):
            next_ordinal = cursor + point_index + 1
            control = 0
            if point_index + 1 == len(points) and name == "sweep_lead_in":
                next_ordinal = cursor + len(points)
            expected.append(((point["y"] - 32) & 0xFFFF,
                             point["x"] & 0xFFFF, next_ordinal, control))
        cursor += len(points)
        if name != "sweep_lead_in":
            expected.append((0xFFFF, 0, cursor - len(points), 1))
            cursor += 1
    return starts, expected


def _catalog_case(h, document: dict, sources: dict) -> tuple[list[int], int]:
    pointer = h.lib.overkill_level_special_paths_current()
    if not pointer:
        raise AssertionError("version-12 content did not bind special routes")
    view = pointer.contents
    starts, expected = _expected_catalog(document, sources)
    for index, name in enumerate(SPECIAL_NAMES):
        if view.starts[index] != starts[index]:
            raise AssertionError(f"{name}: flattened start {view.starts[index]} != {starts[index]}")
        legacy_start = sources[name][0]
        if h.lib.overkill_special_path_start(legacy_start) != starts[index]:
            raise AssertionError(f"{name}: legacy source start did not map to its ordinal")
    if view.point_count != len(expected):
        raise AssertionError(f"special point count {view.point_count} != {len(expected)}")
    for ordinal, wanted in enumerate(expected):
        point_ptr = h.lib.overkill_special_path_point(ordinal)
        if not point_ptr:
            raise AssertionError(f"special provider omitted ordinal {ordinal}")
        point = point_ptr.contents
        actual = (point.y, point.x, point.next, point.control)
        if actual != wanted:
            raise AssertionError(f"special point {ordinal}: {actual} != {wanted}")
    safe = h.lib.overkill_special_path_point(len(expected))
    if not safe or safe.contents.control != 2:
        raise AssertionError("out-of-range special cursor did not use the safe control point")
    return starts, len(expected)


def _memory(arena) -> bytes:
    image = bytearray(arena.image)
    start = arena.map_segment << 4
    image[start:start + 0x10000] = bytes([1]) * 0x10000
    return bytes(image)


def _record(x: int, y: int, enemy_type: int, path: int) -> bytes:
    record = bytearray([0xA5]) * K.RECORD_SIZE
    values = {
        "status": 1, "x": x, "y": y, "direction": K.DIR_DOWN,
        "sprite": 0, "draw_pass": 1, "size_class": 1,
        "kind": K.KIND_ENEMY, "type": enemy_type, "hit_points": 20,
        "slot_index": 0xFFFF, "flash_timer": 0, "path": path,
        "saved_x": x, "saved_y": y, "entry_delay": 0,
    }
    for name, value in values.items():
        struct.pack_into("<H", record, getattr(K, "REC_" + name.upper()), value & 0xFFFF)
    return bytes(record)


def _special_run(h, arena, *, profile: int, level_index: int, name: str,
                 ordinal: int, oracle_offset: int, x: int, y: int,
                 arrival: bool, free: int, label: str,
                 source_writes=(), rng_cursor: int | None = None,
                 encounter_ticks: int = 0x20, record_tick: int = 0x11,
                 direct_boss: bool = False,
                 compare_oracle: bool = True) -> tuple[bytes, int]:
    """Run one path step with owned ordinals vs original source byte cursors."""
    memory = _memory(arena)
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    pool, pool_b = h.offset("PoolA"), h.offset("PoolB")
    actual_x, actual_y = (x, y) if arrival else ((x + 64) & 0xFFFF, (y + 64) & 0xFFFF)
    h.write(pool, _record(actual_x, actual_y, SPECIAL_TYPES[name], ordinal))
    for index in range(1, K.POOL_A_COUNT):
        record = bytearray([0xA5]) * K.RECORD_SIZE
        struct.pack_into("<H", record, K.REC_STATUS, int(index > free))
        h.write(pool + index * K.RECORD_SIZE, record)
    for index in range(K.POOL_B_COUNT):
        record = bytearray([0xA5]) * K.RECORD_SIZE
        struct.pack_into("<H", record, K.REC_STATUS, 0)
        h.write(pool_b + index * K.RECORD_SIZE, record)
    words = (
        ("LevelIndex", level_index), ("DemoActive", 0),
        ("PoolACursor", pool + K.RECORD_SIZE),
        ("PoolBCursor", pool_b + K.RECORD_SIZE),
        ("MapScrollPos", 100 * K.MAP_ROW_BYTES),
        ("RecordTickCounter", record_tick), ("EncounterTicks", encounter_ticks),
        ("EncounterLiveCount", 1), ("EncounterEndDelay", 0x64),
        ("DifficultySetting", 0), ("SfxEnabled", 0),
        ("RandomWordCursor", rng_cursor if rng_cursor is not None else h.offset("CreditRandomWords")),
    )
    for field, value in words:
        h.write(h.offset(field), struct.pack("<H", value & 0xFFFF))
    h.write(h.offset("ByteAttributeTable"), bytes(256))
    h.write(h.offset("ChildSpawnThrottle"), b"\x00")
    record_path = ordinal if name in ("sweep_lead_in", "sweep_loop") else 0x1234
    h.write(pool + K.REC_PATH, struct.pack("<H", record_path))
    if name in ("sweep_lead_in", "sweep_loop"):
        h.m.write(pool + K.REC_PATH, struct.pack("<H", oracle_offset))
    for address, payload in source_writes:
        h.write(address, payload)

    cursor_address = None
    if name == "encounter_leader":
        cursor_address = h.m.linear("Type21PathCursor")
        # ASM starts from the byte address; both live in the same CS window.
        h.m.u.mem_write(cursor_address, struct.pack("<H", oracle_offset))
        ctypes.memmove(arena.base + cursor_address, struct.pack("<H", oracle_offset), 2)
    elif name == "boss_anchor":
        for field, value in (("SegBossAnchor", pool), ("SegBossPathCursor", ordinal),
                             ("SegBossX", actual_x), ("SegBossY", actual_y),
                             ("SegBossActive", 1)):
            h.write(h.offset(field), struct.pack("<H", value & 0xFFFF))
        h.m.write(h.offset("SegBossPathCursor"), struct.pack("<H", oracle_offset))

    before = bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES))
    arena.load(before)
    if cursor_address is not None:
        ctypes.memmove(arena.base + cursor_address, struct.pack("<H", ordinal), 2)
    if direct_boss:
        h.lib.steer_seg_boss_along_path()
    else:
        h.lib.run_type_handler(ctypes.c_void_p(h.state_addr + pool))
    native_state = h.state_storage.snapshot()
    if cursor_address is not None:
        native_cursor = struct.unpack("<H", ctypes.string_at(arena.base + cursor_address, 2))[0]
    elif name == "boss_anchor":
        native_cursor = struct.unpack_from("<H", native_state, h.offset("SegBossPathCursor"))[0]
    else:
        native_cursor = struct.unpack_from("<H", native_state, pool + K.REC_PATH)[0]
    ctypes.memmove(arena.base + h.m.data_frame * 16, native_state, 0x10000)
    native_memory = arena.snapshot()

    if not compare_oracle:
        h.check_canaries()
        return native_state, native_cursor

    if direct_boss:
        h.m.call("SteerSegBossAlongPath")
    else:
        h.m.call("RunTypeHandler", {"BP": pool})
    if cursor_address is not None:
        oracle_cursor = struct.unpack("<H", bytes(h.m.u.mem_read(cursor_address, 2)))[0]
        # Assert and normalize the CS cursor only after proving the original byte
        # stream advanced to the expected address.
        mapped = _ordinal_for_legacy(h, name, oracle_cursor)
        if native_cursor != mapped:
            raise AssertionError(f"{label}: owned Type21 ordinal {native_cursor} != {mapped}")
        h.m.u.mem_write(cursor_address, struct.pack("<H", native_cursor))
        ctypes.memmove(arena.base + cursor_address, struct.pack("<H", native_cursor), 2)
    elif name == "boss_anchor":
        oracle_cursor = h.m.word(h.offset("SegBossPathCursor"))
        mapped = _ordinal_for_legacy(h, name, oracle_cursor)
        if native_cursor != mapped:
            raise AssertionError(f"{label}: owned boss ordinal {native_cursor} != {mapped}")
        h.m.write(h.offset("SegBossPathCursor"), struct.pack("<H", native_cursor))
    else:
        oracle_cursor = h.m.word(pool + K.REC_PATH)
        mapped = _ordinal_for_legacy(h, name, oracle_cursor)
        if native_cursor != mapped:
            raise AssertionError(f"{label}: owned route cursor {native_cursor} != {mapped}")
        h.m.write(pool + K.REC_PATH, struct.pack("<H", native_cursor))
    h.compare(label)
    checkpoints._compare_arena(
        native_memory, bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)),
        h.m.data_frame * 16 + h.stack_lo,
        h.m.data_frame * 16 + h.m.stack_top,
        label,
    )
    return native_state, native_cursor


def _ordinal_for_legacy(h, name: str, legacy_cursor: int) -> int:
    # Special paths are flattened in the fixed order. A cursor can cross the
    # lead-in's adjacency boundary or a route's legacy control marker in the
    # same call; derive its owned ordinal by the route-local byte displacement.
    sources = source_paths(h.m)
    for index, route in enumerate(SPECIAL_NAMES):
        start, _capacity, definition = sources[route]
        points = definition["points"]
        if route == name:
            if legacy_cursor == start + len(points) * 4:
                if route == "sweep_lead_in":
                    target_start = sources[definition["end"]["path"]][0]
                    return _ordinal_for_legacy(h, definition["end"]["path"], target_start)
                return _special_start(h, route) + len(points)
            if route != "sweep_lead_in" and legacy_cursor == start + (len(points) + 1) * 4:
                return _special_start(h, route)
            delta = legacy_cursor - start
            if delta >= 0 and delta % 4 == 0:
                if delta // 4 < len(points):
                    return _special_start(h, route) + delta // 4
        elif route == "sweep_lead_in" and definition["end"].get("path") == name:
            pass
    # The caller may point at a different one of the four route entries.
    starts = [_special_start(h, route) for route in SPECIAL_NAMES]
    for route, (start, _capacity, definition) in sources.items():
        if route not in SPECIAL_NAMES:
            continue
        point_bytes = (len(definition["points"]) +
                       int(route != "sweep_lead_in")) * 4
        if start <= legacy_cursor < start + point_bytes and (legacy_cursor - start) % 4 == 0:
            idx = (legacy_cursor - start) // 4
            return starts[SPECIAL_NAMES.index(route)] + min(idx, len(definition["points"]))
    raise AssertionError(f"legacy cursor {legacy_cursor:04X} is not in {name} special route")


def _special_start(h, name: str) -> int:
    return h.lib.overkill_special_path_start(h.offset(PATH_BINDINGS[name][0]))


def _canonical_documents(h, arena, work: Path):
    sources = source_paths(h.m)
    documents, directories = [], []
    catalog_cases = 0
    for profile in range(6):
        directory = work / f"canonical-special-{profile}"
        document = duplicate_original(profile, directory, f"special_profile_{profile}")
        write_json(directory / "level.json", document)
        validate_directory(directory)
        _load(h, directory, profile)
        starts, point_count = _catalog_case(h, document, sources)
        if point_count == 0 or len(starts) != 4:
            raise AssertionError("canonical special route catalog is incomplete")
        documents.append(document)
        directories.append(directory)
        catalog_cases += 1
    return documents, directories, sources, catalog_cases


def _execution_cases(h, arena, documents, directories, sources) -> int:
    cases = 0
    selected_profiles = {
        "sweep_lead_in": 0,
        "sweep_loop": 0,
        "encounter_leader": 4,
        "boss_anchor": 0,
    }
    for name in SPECIAL_NAMES:
        profile = selected_profiles[name]
        document, directory = documents[profile], directories[profile]
        _load(h, directory, profile)
        starts, _ = _catalog_case(h, document, sources)
        source_start, _capacity, definition = sources[name]
        for index, point in enumerate(definition["points"]):
            for arrival in (False, True):
                for free in (0, 3, K.POOL_A_COUNT - 1):
                    _special_run(
                        h, arena, profile=profile, level_index=profile,
                        name=name, ordinal=starts[SPECIAL_NAMES.index(name)] + index,
                        oracle_offset=source_start + index * 4,
                        x=point["x"], y=point["y"], arrival=arrival, free=free,
                        label=f"{name} source step={index} arrival={arrival} free={free}",
                        direct_boss=name == "boss_anchor",
                    )
                    cases += 1

        if name != "sweep_lead_in":
            control_offset = source_start + len(definition["points"]) * 4
            control_ordinal = starts[SPECIAL_NAMES.index(name)] + len(definition["points"])
            target = definition["points"][0]
            _special_run(
                h, arena, profile=profile, level_index=profile,
                name=name, ordinal=control_ordinal, oracle_offset=control_offset,
                x=target["x"], y=target["y"], arrival=False, free=3,
                label=f"{name} control transition", direct_boss=name == "boss_anchor",
            )
            cases += 1

    # Exercise the sweep loop's same-call restart/lead-in continuation with a
    # range of original RNG words, an aimed-shot tick, empty/full pools, and the
    # legacy stale DS:8 side write. The full DS/arena comparison includes RNG,
    # shot records, and stale bytes.
    name = "sweep_loop"
    profile = 0
    document, directory = documents[profile], directories[profile]
    _load(h, directory, profile)
    starts, _ = _catalog_case(h, document, sources)
    path_start, _capacity, loop = sources[name]
    lead_start, _lead_capacity, lead = sources["sweep_lead_in"]
    final_lead = lead["points"][-1]
    first_loop = loop["points"][0]
    _special_run(
        h, arena, profile=profile, level_index=profile,
        name="sweep_lead_in", ordinal=starts[0] + len(lead["points"]) - 1,
        oracle_offset=lead_start + (len(lead["points"]) - 1) * 4,
        x=final_lead["x"], y=final_lead["y"], arrival=True, free=5,
        label="lead-in continues directly into sweep loop",
    )
    cases += 1
    for index in range(16):
        rng = h.offset("CreditRandomWords") + index * 2
        for free in (0, 5):
            _special_run(
                h, arena, profile=profile, level_index=profile,
                name=name, ordinal=starts[1] + len(loop["points"]) - 1,
                oracle_offset=path_start + (len(loop["points"]) - 1) * 4,
                x=loop["points"][-1]["x"], y=loop["points"][-1]["y"],
                arrival=True, free=free, rng_cursor=rng, record_tick=0x0C,
                label=f"sweep wrap rng={index} free={free}",
            )
            cases += 1
    return cases


def _authored_cases(h, arena, work: Path, sources: dict) -> tuple[int, Path, dict]:
    directory = work / "authored-special-paths"
    document = duplicate_original(0, directory, "authored_special_paths")
    paths = document["paths"]
    for name in SPECIAL_NAMES:
        paths.setdefault(name, copy.deepcopy(sources[name][2]))
    # One owned route encodes y=31 as FFFFh but remains a point because its
    # control tag is separate. Extend two independent routes past original length.
    paths["sweep_lead_in"]["points"].append({"x": 70, "y": 90})
    loop = paths["sweep_loop"]
    loop["points"][0] = {"x": 80, "y": 31}
    loop["points"].append({"x": -25, "y": 90})
    encounter = paths["encounter_leader"]
    encounter["points"] = [{"x": 80, "y": 72}]
    boss = paths["boss_anchor"]
    boss["points"].append({"x": 70, "y": 115})
    write_json(directory / "level.json", document)
    validate_directory(directory)
    _load(h, directory, 0)
    starts, _ = _catalog_case(h, document, sources)

    # Confirm authored targets (including raw FFFF Y) reach real Type18 target
    # registers while another LevelIndex is active.
    source_start = sources["sweep_loop"][0]
    targets = ((0, loop["points"][0]), (len(loop["points"]) - 1, loop["points"][-1]))
    for index, target in targets:
        ordinal = starts[1] + index
        native, _ = _special_run(
            h, arena, profile=0, level_index=5, name="sweep_loop",
            ordinal=ordinal, oracle_offset=source_start + min(index, len(sources["sweep_loop"][2]["points"]) - 1) * 4,
            x=target["x"], y=target["y"], arrival=False, free=0,
            label=f"authored special target {index}", compare_oracle=False,
        )
        expected_y = target["y"] & 0xFFFF
        if (struct.unpack_from("<H", native, h.offset("SteerTargetY"))[0] != expected_y or
                struct.unpack_from("<H", native, h.offset("SteerTargetX"))[0] != (target["x"] & 0xFFFF)):
            raise AssertionError(f"authored special point {index} did not reach Type18 target")

    lead = paths["sweep_lead_in"]
    native, _ = _special_run(
        h, arena, profile=0, level_index=5, name="sweep_lead_in",
        ordinal=starts[0] + len(lead["points"]) - 1,
        oracle_offset=sources["sweep_lead_in"][0] +
                      (len(sources["sweep_lead_in"][2]["points"]) - 1) * 4,
        x=lead["points"][-1]["x"], y=lead["points"][-1]["y"],
        arrival=False, free=0, label="authored extended lead-in target",
        compare_oracle=False,
    )
    if struct.unpack_from("<H", native, h.offset("SteerTargetY"))[0] != 90:
        raise AssertionError("extended lead-in point did not reach Type18")

    # The shorter encounter route restarts at its authored first point after
    # reading the explicit control node. Boss route restart follows the same
    # authored-data path through its distinct DS cursor.
    encounter_ordinal = starts[2] + len(encounter["points"])
    native, cursor = _special_run(
        h, arena, profile=0, level_index=4, name="encounter_leader",
        ordinal=encounter_ordinal,
        oracle_offset=sources["encounter_leader"][0] +
                      len(sources["encounter_leader"][2]["points"]) * 4,
        x=80, y=72, arrival=False, free=0,
        label="authored one-point encounter restart", compare_oracle=False,
    )
    if cursor != starts[2]:
        raise AssertionError("authored encounter control did not restart at its first point")
    native, cursor = _special_run(
        h, arena, profile=0, level_index=4, name="encounter_leader",
        ordinal=starts[2], oracle_offset=sources["encounter_leader"][0],
        x=80, y=72, arrival=True, free=0,
        label="authored one-point encounter arrival", compare_oracle=False,
    )
    if (cursor != starts[2] + 1 or
            struct.unpack_from("<H", native, h.offset("PoolA") + K.REC_HIT_POINTS)[0] != 2):
        raise AssertionError("one-point encounter did not stop at its marker after one arrival")
    native, _ = _special_run(
        h, arena, profile=0, level_index=4, name="boss_anchor",
        ordinal=starts[3] + len(boss["points"]) - 1,
        oracle_offset=sources["boss_anchor"][0], x=70, y=115,
        arrival=False, free=0, label="authored extended boss target",
        direct_boss=True, compare_oracle=False,
    )
    if (struct.unpack_from("<H", native, h.offset("SteerTargetX"))[0] != 70 or
            struct.unpack_from("<H", native, h.offset("SteerTargetY"))[0] != 115):
        raise AssertionError("extended boss point did not reach the boss steering target")
    boss_ordinal = starts[3] + len(boss["points"])
    native, cursor = _special_run(
        h, arena, profile=0, level_index=4, name="boss_anchor",
        ordinal=boss_ordinal,
        oracle_offset=sources["boss_anchor"][0] +
                      len(sources["boss_anchor"][2]["points"]) * 4,
        x=70, y=115, arrival=False, free=0,
        label="authored boss restart", direct_boss=True, compare_oracle=False,
    )
    if cursor != starts[3]:
        raise AssertionError("authored boss control did not restart at its first point")

    # Poisoning the original route bytes cannot affect the owned descriptor.
    # Compare every DS byte after normalizing only the deliberately poisoned
    # source range; this includes RNG, allocation fields and stale writes.
    point_index = 0
    ordinal = starts[1] + point_index
    target = loop["points"][point_index]
    base, _ = _special_run(
        h, arena, profile=0, level_index=4, name="sweep_loop",
        ordinal=ordinal, oracle_offset=source_start,
        x=target["x"], y=target["y"], arrival=True, free=3,
        label="authored route unpoisoned", compare_oracle=False,
    )
    poison = bytes([0xCC]) * 8
    poisoned, _ = _special_run(
        h, arena, profile=0, level_index=4, name="sweep_loop",
        ordinal=ordinal, oracle_offset=source_start,
        x=target["x"], y=target["y"], arrival=True, free=3,
        label="authored route with poisoned source", source_writes=((source_start, poison),),
        compare_oracle=False,
    )
    normalized = bytearray(poisoned)
    normalized[source_start:source_start + len(poison)] = base[source_start:source_start + len(poison)]
    if normalized != base:
        raise AssertionError("authored special route consulted poisoned original DS bytes")
    child_cases = 0
    for authored_y, route_name in ((64, "sweep_loop"), (63, "sweep_lead_in")):
        child_dir = work / f"leader-child-{authored_y}"
        child_doc = duplicate_original(0, child_dir, f"leader_child_{authored_y}")
        child_doc["leader_paths"]["sweep_leader"]["steps"][0]["target"]["y"] = authored_y
        write_json(child_dir / "level.json", child_doc)
        validate_directory(child_dir)
        _load(h, child_dir, 0)
        target = child_doc["leader_paths"]["sweep_leader"]["steps"][0]["target"]
        memory = _memory(arena)
        h.reset()
        h.m.u.mem_write(0, memory)
        h.m.set_state(h.baseline)
        h.state_storage.load(h.baseline)
        arena.load(memory)
        pool, pool_b = h.offset("PoolA"), h.offset("PoolB")
        h.write(pool, _record(target["x"], target["y"], 0x15, 0))
        for index in range(1, K.POOL_A_COUNT):
            slot = bytearray([0xA5]) * K.RECORD_SIZE
            struct.pack_into("<H", slot, K.REC_STATUS, int(index > 2))
            h.write(pool + index * K.RECORD_SIZE, slot)
        for index in range(K.POOL_B_COUNT):
            slot = bytearray([0xA5]) * K.RECORD_SIZE
            struct.pack_into("<H", slot, K.REC_STATUS, 0)
            h.write(pool_b + index * K.RECORD_SIZE, slot)
        script = h.offset("LeaderScript15")
        owned_script = h.lib.overkill_leader_start(script)
        for field, value in (("LevelIndex", 5), ("LeaderScriptCursor", script),
                             ("FormationSlotCursor", h.offset("FormationSlots")),
                             ("PoolACursor", pool + K.RECORD_SIZE),
                             ("PoolBCursor", pool_b + K.RECORD_SIZE),
                             ("EncounterLiveCount", 1), ("EncounterTicks", 0),
                             ("SfxEnabled", 0), ("RecordTickCounter", 0x11)):
            h.write(h.offset(field), struct.pack("<H", value & 0xFFFF))
        ctypes.memmove(h.state_addr + h.offset("LeaderScriptCursor"),
                       struct.pack("<H", owned_script), 2)
        h.lib.type13_formation_leader(ctypes.c_void_p(h.state_addr + pool))
        state = h.state_storage.snapshot()
        child = pool + K.RECORD_SIZE
        expected_path = _special_start(h, route_name)
        if (struct.unpack_from("<H", state, child + K.REC_STATUS)[0] == 0 or
                struct.unpack_from("<H", state, child + K.REC_PATH)[0] != expected_path):
            raise AssertionError(f"authored sweep follower did not start at {route_name}")
        child_cases += 1
    return 9 + child_cases, directory, document


def _boss_initialization_case(h, arena, directory: Path) -> int:
    profile = 0
    _load(h, directory, profile)
    special_start = _special_start(h, "boss_anchor")
    memory = _memory(arena)
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    pool, pool_b = h.offset("PoolA"), h.offset("PoolB")
    h.write(pool, _record(0x60, 0x40, 0x21, 0))
    for index in range(1, K.POOL_A_COUNT):
        record = bytearray([0xA5]) * K.RECORD_SIZE
        struct.pack_into("<H", record, K.REC_STATUS, int(index > 3))
        h.write(pool + index * K.RECORD_SIZE, record)
    for index in range(K.POOL_B_COUNT):
        record = bytearray([0xA5]) * K.RECORD_SIZE
        struct.pack_into("<H", record, K.REC_STATUS, 0)
        h.write(pool_b + index * K.RECORD_SIZE, record)
    for field, value in (
        ("LevelIndex", profile), ("PoolACursor", pool + K.RECORD_SIZE),
        ("PoolBCursor", pool_b + K.RECORD_SIZE), ("EncounterLiveCount", 1),
        ("EncounterTicks", 0x60), ("RecordTickCounter", 0x11),
        ("MapScrollPos", 100 * K.MAP_ROW_BYTES), ("SfxEnabled", 0),
        ("SegBossActive", 0), ("SegBossPathCursor", 0x2222),
    ):
        h.write(h.offset(field), struct.pack("<H", value & 0xFFFF))
    h.write(h.offset("ByteAttributeTable"), bytes(256))
    h.write(h.offset("ChildSpawnThrottle"), b"\x00")
    h.m.write(h.offset("SegBossPathCursor"), struct.pack("<H", h.offset("BossPath")))
    before = bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES))
    arena.load(before)
    h.lib.run_type_handler(ctypes.c_void_p(h.state_addr + pool))
    native = h.state_storage.snapshot()
    if struct.unpack_from("<H", native, h.offset("SegBossPathCursor"))[0] != special_start:
        raise AssertionError("owned segmented-boss setup did not select the boss route ordinal")
    ctypes.memmove(arena.base + h.m.data_frame * 16, native, 0x10000)
    native_memory = arena.snapshot()
    h.m.call("RunTypeHandler", {"BP": pool})
    source_cursor = h.m.word(h.offset("SegBossPathCursor"))
    if source_cursor != h.offset("BossPath"):
        raise AssertionError("ASM segmented-boss setup did not select BossPath")
    h.m.write(h.offset("SegBossPathCursor"), struct.pack("<H", special_start))
    h.compare("owned segmented-boss route initialization")
    checkpoints._compare_arena(
        native_memory, bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)),
        h.m.data_frame * 16 + h.stack_lo, h.m.data_frame * 16 + h.m.stack_top,
        "owned segmented-boss route initialization",
    )
    return 1


def _starter_cases(h, arena, directories) -> int:
    """Compare StartLeaderScript's Type21 path reset through all six leaders."""
    far_calls = _module("special_path_content_far_calls", HOST_TESTS / "player_frame.py")
    cases = 0
    profile = 0
    _load(h, directories[profile], profile)
    leader_types = (0x13, 0x15, 0x1C, 0x1F, 0x7D, 0x7E)
    entries = [(name, LEADER_BINDINGS[name][0], leader_types[index],
                h.offset(LEADER_BINDINGS[name][0]))
               for index, name in enumerate(LEADER_BINDINGS)]
    entries.append(("Type21 numeric seed", None, 0x21, profile + 1))
    for name, label, enemy_type, script in entries:
        actor = h.offset("PoolA")
        h.reset()
        h.m.set_state(h.baseline)
        h.state_storage.load(h.baseline)
        arena.load(_memory(arena))
        h.write(actor, _record(0x55, 0x66, enemy_type, 0))
        h.write(h.offset("LeaderScriptCursor"), struct.pack("<H", script))
        h.write(h.offset("FormationSlotCursor"), struct.pack("<H", h.offset("FormationSlots") + 28))
        cs_cursor = h.m.linear("Type21PathCursor")
        special_start = _special_start(h, "encounter_leader")
        h.m.u.mem_write(cs_cursor, struct.pack("<H", h.offset("Type21Path")))
        ctypes.memmove(arena.base + cs_cursor, struct.pack("<H", h.offset("Type21Path")), 2)
        h.lib.start_leader_script(ctypes.c_void_p(h.state_addr + actor), script)
        native = h.state_storage.snapshot()
        native_script = struct.unpack_from("<H", native, h.offset("LeaderScriptCursor"))[0]
        native_slots = struct.unpack_from("<H", native, h.offset("FormationSlotCursor"))[0]
        native_cs = struct.unpack("<H", ctypes.string_at(arena.base + cs_cursor, 2))[0]
        expected_script = h.lib.overkill_leader_start(script)
        expected_slots = h.lib.overkill_leader_slot_start()
        if native_script != expected_script or native_slots != expected_slots:
            raise AssertionError(f"{name}: native leader/slot starts are not valid ordinals")
        if native_cs != special_start:
            raise AssertionError(f"{name}: StartLeaderScript did not reset to owned Type21 path")
        ctypes.memmove(arena.base + h.m.data_frame * 16, native, 0x10000)
        native_memory = arena.snapshot()
        far_calls._call_far(h.m, "StartLeaderScript", {"AX": script, "BX": actor})
        if h.m.word(h.offset("LeaderScriptCursor")) != script:
            raise AssertionError(f"{name}: ASM start did not retain its passed leader address")
        if h.m.word(h.offset("FormationSlotCursor")) != h.offset("FormationSlots"):
            raise AssertionError(f"{name}: ASM start did not reset the original slot pointer")
        oracle_cs = struct.unpack("<H", bytes(h.m.u.mem_read(cs_cursor, 2)))[0]
        if oracle_cs != h.offset("Type21Path"):
            raise AssertionError(f"{name}: ASM StartLeaderScript did not reset source cursor")
        h.m.write(h.offset("LeaderScriptCursor"), struct.pack("<H", native_script))
        h.m.write(h.offset("FormationSlotCursor"), struct.pack("<H", native_slots))
        h.m.u.mem_write(cs_cursor, struct.pack("<H", native_cs))
        h.compare(f"StartLeaderScript special reset {name}")
        checkpoints._compare_arena(
            native_memory, bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)),
            h.m.data_frame * 16 + h.stack_lo, h.m.data_frame * 16 + h.m.stack_top,
            f"StartLeaderScript special reset {name}",
        )
        cases += 1
    return cases


def _schema_cases(h, work: Path, document: dict, sources: dict,
                  active_directory: Path, profile: int) -> int:
    cases = 0
    _load(h, active_directory, profile)
    active_pointer = ctypes.cast(h.lib.overkill_level_special_paths_current(),
                                 ctypes.c_void_p).value
    active_id = h.lib.overkill_level_content_id().decode()
    document = copy.deepcopy(document)
    for name in SPECIAL_NAMES:
        document["paths"].setdefault(name, copy.deepcopy(sources[name][2]))
    malformed = []
    case = copy.deepcopy(document)
    case["paths"]["sweep_lead_in"]["end"] = {"kind": "restart"}
    malformed.append(("lead-in adjacency", case))
    case = copy.deepcopy(document)
    case["paths"]["sweep_loop"]["end"] = {"kind": "jump", "path": "boss_anchor"}
    malformed.append(("loop target", case))
    case = copy.deepcopy(document)
    case["paths"]["encounter_leader"]["points"] = []
    malformed.append(("empty encounter path", case))
    case = copy.deepcopy(document)
    case["paths"]["sweep_loop"]["points"] = [
        copy.deepcopy(case["paths"]["sweep_loop"]["points"][0])
    ]
    malformed.append(("one point in cyclic loop", case))
    case = copy.deepcopy(document)
    case["paths"]["boss_anchor"]["points"] = [
        copy.deepcopy(case["paths"]["boss_anchor"]["points"][0])
    ]
    malformed.append(("one point in boss cycle", case))
    case = copy.deepcopy(document)
    case["paths"]["encounter_leader"]["points"][0]["x"] = True
    malformed.append(("boolean coordinate", case))
    for index, (label, bad) in enumerate(malformed):
        directory = work / f"malformed-special-{index}"
        # Use a complete loose copy so failures reach route validation only.
        directory.mkdir()
        bad["id"] = f"bad_special_{index}"
        write_json(directory / "level.json", bad)
        (directory / "map.bin").write_bytes((active_directory / "map.bin").read_bytes())
        try:
            validate_directory(directory)
        except ValueError:
            pass
        else:
            raise AssertionError(f"Python validator accepted {label}")
        error = ctypes.create_string_buffer(512)
        if h.lib.overkill_level_content_load(
            str(directory).encode(), str(ROOT / "levels/original").encode(), error, len(error)
        ):
            raise AssertionError(f"native loader accepted {label}")
        if h.lib.overkill_level_content_id().decode() != active_id:
            raise AssertionError(f"failed {label} replaced active level identity")
        current = ctypes.cast(h.lib.overkill_level_special_paths_current(),
                              ctypes.c_void_p).value
        if current != active_pointer:
            raise AssertionError(f"failed {label} replaced active special provider")
        cases += 1

    older_dir = work / "older-v11-special"
    older = duplicate_original(profile, older_dir, "older_v11_special")
    older["version"] = 11
    write_json(older_dir / "level.json", older)
    validate_directory(older_dir)
    _load(h, older_dir, profile)
    if h.lib.overkill_level_special_paths_current():
        raise AssertionError("version 11 unexpectedly retained owned special routes")
    cases += 1
    return cases


def run() -> int:
    h = input_harness.HostHarness()
    checkpoints._bind_native(h.lib)
    _bind_api(h.lib)
    arena = checkpoints.Arena(h)
    try:
        with tempfile.TemporaryDirectory(prefix="overkill-special-path-content-") as temporary:
            work = Path(temporary)
            documents, directories, sources, cases = _canonical_documents(h, arena, work)
            cases += _execution_cases(h, arena, documents, directories, sources)
            authored_cases, _authored_dir, _authored_doc = _authored_cases(
                h, arena, work, sources)
            cases += authored_cases
            cases += _starter_cases(h, arena, directories)
            cases += _boss_initialization_case(h, arena, directories[0])
            cases += _schema_cases(h, work, documents[0], sources, directories[0], 0)
        h.lib.overkill_level_content_unload()
    finally:
        h.check_canaries()
    print(f"PASS owned special paths and ASM execution; {cases} cases")
    return cases


if __name__ == "__main__":
    run()
