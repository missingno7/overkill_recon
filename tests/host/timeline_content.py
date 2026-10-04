"""Version-9 timeline/formation content against the exact ASM event executor.

Run ``python tests/host/timeline_content.py`` against an existing host build. This
suite never builds the shared core. The canonical cases compare every original
event with the original ASM state and segmented memory, normalizing only the
native ordinal versus the oracle's serialized DS cursor token.
"""
from __future__ import annotations

import copy
import ctypes
import importlib.util
import random
from pathlib import Path
import struct
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
TESTS = ROOT / "tests"
HOST_TESTS = ROOT / "tests/host"
sys.path.insert(0, str(TOOLS))
sys.path.append(str(TESTS))

from common import write_json  # noqa: E402
from export_original_levels import script_event_boundaries  # noqa: E402
from level_content import duplicate_original as _duplicate_latest, validate_directory  # noqa: E402
from level_format import load, original_paths  # noqa: E402
from level_presets import ARCHETYPES, DROPS  # noqa: E402
from world import K  # noqa: E402


def duplicate_original(profile, directory, identity, music=None):
    """Keep this suite pinned to its v9 timeline/formation contract."""
    document = _duplicate_latest(profile, directory, identity, music)
    document['version'] = 9
    write_json(Path(directory) / 'level.json', document)
    validate_directory(directory)
    return document


def _module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    result = importlib.util.module_from_spec(spec)
    sys.modules[name] = result
    spec.loader.exec_module(result)
    return result


input_harness = _module("timeline_content_input", HOST_TESTS / "input.py")
checkpoints = _module("timeline_content_checkpoints", HOST_TESTS / "checkpoints.py")


def _bind_content_api(lib) -> None:
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
    lib.run_level_script_events.argtypes = ()
    lib.run_level_script_events.restype = None


def _load_content(h, directory: Path, profile: int) -> None:
    error = ctypes.create_string_buffer(512)
    ok = h.lib.overkill_level_content_load(
        str(directory).encode(), str(ROOT / "levels/original").encode(), error, len(error)
    )
    if not ok:
        raise AssertionError(f"native loader rejected timeline {directory.name}: "
                             f"{error.value.decode(errors='replace')}")
    identity = h.lib.overkill_level_content_id()
    if not identity or h.lib.overkill_level_content_behavior_profile() != profile:
        raise AssertionError("native loose timeline identity/profile was not activated")


def _cursor_offset(h, profile: int) -> int:
    return h.offset("LevelScriptCursors") + 2 * profile


def _event_after(document, index: int, clock: int) -> int:
    if index >= len(document["timeline"]) or document["timeline"][index]["clock"] != clock:
        return index
    index += 1
    while index < len(document["timeline"]) and document["timeline"][index]["clock"] == clock:
        index += 1
    return index


def _state_word(state: bytes, offset: int) -> int:
    return struct.unpack_from("<H", state, offset)[0]


def _timeline_case(h, arena, profile: int, document: dict, boundaries: list[int],
                   memory: bytes, pool_seed: bytes, event_index: int,
                   clock: int, free: int, label: str, groups_full: bool = False) -> None:
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    pool = h.offset("PoolA")
    cursor_offset = _cursor_offset(h, profile)
    writes = [
        (pool, pool_seed),
        (h.offset("GroupTable"), bytes((1 if groups_full else 0, 0xA5)) * 16),
        (h.offset("ByteAttributeTable"), bytes(256)),
        (h.offset("EventMarkerFlag"), b"\xa5"),
        (h.offset("LevelIndex"), struct.pack("<H", profile)),
        (h.offset("LevelScriptClock"), struct.pack("<H", clock)),
        (h.offset("PoolACursor"), struct.pack("<H", pool + (K.POOL_A_COUNT - 2) * K.RECORD_SIZE)),
        (h.offset("GroupSlotIndex"), struct.pack("<H", 0xBEEF)),
        (h.offset("GroupSlotPtr"), struct.pack("<H", 0xFFFF)),
        (h.offset("MapScrollPos"), struct.pack("<H", 100 * K.MAP_ROW_BYTES)),
        (cursor_offset, struct.pack("<H", event_index)),
    ]
    for index in range(K.POOL_A_COUNT):
        status = 0 if (index - (K.POOL_A_COUNT - 2)) % K.POOL_A_COUNT < free else 1
        writes.append((pool + index * K.RECORD_SIZE, struct.pack("<H", status)))
    group_drop_offset = h.offset("GroupDropKinds")
    group_drop_before = h.state_storage.snapshot()[group_drop_offset:group_drop_offset + 64]
    for offset, data in writes:
        h.write(offset, data)

    h.lib.run_level_script_events()
    native_state = h.state_storage.snapshot()
    native_cursor = _state_word(native_state, cursor_offset)
    expected_ordinal = _event_after(document, event_index, clock)
    if native_cursor != expected_ordinal:
        raise AssertionError(f"{label}: ordinal cursor {native_cursor}, expected {expected_ordinal}")
    if native_state[group_drop_offset:group_drop_offset + 64] != group_drop_before:
        raise AssertionError(f"{label}: external timeline modified legacy GroupDropKinds")

    # Restore the oracle's actual byte pointer token, run the exact ASM routine,
    # then validate the pointer/ordinal relationship before normalizing that one
    # state word for complete DS and physical-arena comparison.
    h.m.write(cursor_offset, struct.pack("<H", boundaries[event_index]))
    h.m.call("RunLevelScriptEvents")
    oracle_pointer = h.m.word(cursor_offset)
    if expected_ordinal >= len(boundaries) or oracle_pointer != boundaries[expected_ordinal]:
        raise AssertionError(
            f"{label}: ASM cursor {oracle_pointer:04X} does not mark event {expected_ordinal}; "
            f"bounds={[f'{value:04X}' for value in boundaries[:3]]}, "
            f"level={h.m.word(h.offset('LevelIndex'))}, clock={h.m.word(h.offset('LevelScriptClock'))}"
        )
    h.m.write(cursor_offset, struct.pack("<H", native_cursor))
    h.compare(label)
    ctypes.memmove(arena.base + h.m.data_frame * 16, native_state, 0x10000)
    checkpoints._compare_arena(
        arena.snapshot(), bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)),
        h.m.data_frame * 16 + h.stack_lo,
        h.m.data_frame * 16 + h.m.stack_top,
        label,
    )


def _canonical_event_cases(h, arena, work: Path) -> int:
    documents = [load(path) for path in original_paths()]
    base_memory = bytearray(arena.image)
    map_base = arena.map_segment << 4
    base_memory[map_base:map_base + 0x10000] = bytes([1]) * 0x10000
    memory = bytes(base_memory)
    pool_seed = random.Random(0x53444C).randbytes(K.POOL_A_COUNT * K.RECORD_SIZE)
    cases = 0
    event_count = 0
    for profile, document in enumerate(documents):
        directory = work / f"canonical-{profile}"
        duplicate_original(profile, directory, f"timeline_fixture_{profile}")
        validate_directory(directory)
        _load_content(h, directory, profile)
        boundaries = script_event_boundaries(h.m, profile)
        if len(boundaries) != len(document["timeline"]) + 1:
            raise AssertionError(f"profile {profile}: source boundary count differs from JSON")
        for event_index, event in enumerate(document["timeline"]):
            event_count += 1
            for free in (K.POOL_A_COUNT, 3, 0):
                _timeline_case(
                    h, arena, profile, document, boundaries, memory, pool_seed,
                    event_index, event["clock"], free,
                    f"external level {profile} event {event_index} free {free}",
                    groups_full=(event_index % 3 == 0),
                )
                cases += 1

        # Equality only: a mismatch and an exhausted terminal cursor remain pending.
        _timeline_case(h, arena, profile, document, boundaries, memory, pool_seed,
                       0, (document["timeline"][0]["clock"] + 1) & 0xFFFF,
                       K.POOL_A_COUNT, f"profile {profile} mismatched event clock")
        _timeline_case(h, arena, profile, document, boundaries, memory, pool_seed,
                       len(document["timeline"]), 0xFFFF, K.POOL_A_COUNT,
                       f"profile {profile} terminal ordinal")
        cases += 2
    if event_count != 138:
        raise AssertionError(f"expected 138 original timeline events, found {event_count}")
    return cases


def _version8_backward_load(h, work: Path) -> int:
    """Keep the pre-owned-timeline loose format readable after v9 was added."""
    profile = 4
    directory = work / "version8-backward-compatible"
    document = duplicate_original(profile, directory, "version8_backward_compatible")
    document["version"] = 8
    document.pop("formation_spawn_parameters")
    write_json(directory / "level.json", document)
    validated = validate_directory(directory)
    if validated["version"] != 8:
        raise AssertionError("version-8 fixture did not remain version 8")
    _load_content(h, directory, profile)
    return 1


def _empty_timeline_terminal_case(h, arena, work: Path) -> int:
    """An empty authored timeline is a valid terminal event stream."""
    profile = 0
    directory = work / "empty-timeline"
    document = duplicate_original(profile, directory, "empty_timeline")
    document["timeline"] = []
    document["formations"] = {}
    for checkpoint in document["checkpoints"]:
        checkpoint["resume_event"] = 0
    write_json(directory / "level.json", document)
    validate_directory(directory)
    _load_content(h, directory, profile)

    memory = bytearray(arena.image)
    map_base = arena.map_segment << 4
    memory[map_base:map_base + 0x10000] = bytes([1]) * 0x10000
    memory = bytes(memory)
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    cursor_slot = _cursor_offset(h, profile)
    scratch = 0x0500
    h.write(scratch, struct.pack("<H", 0xFFFF))
    for offset, value in (
        (h.offset("LevelIndex"), struct.pack("<H", profile)),
        (h.offset("LevelScriptClock"), struct.pack("<H", 0)),
        (cursor_slot, struct.pack("<H", 0)),
    ):
        h.write(offset, value)

    h.lib.run_level_script_events()
    native_state = h.state_storage.snapshot()
    if _state_word(native_state, cursor_slot) != 0:
        raise AssertionError("empty timeline changed its terminal ordinal")
    if _state_word(native_state, h.offset("EventTrigger")) != 0xFFFF:
        raise AssertionError("empty timeline did not expose its terminal event trigger")
    ctypes.memmove(arena.base + h.m.data_frame * 16, native_state, 0x10000)
    native_memory = arena.snapshot()

    # The oracle represents the same terminal state with a byte-stream pointer.
    h.m.write(cursor_slot, struct.pack("<H", scratch))
    h.m.call("RunLevelScriptEvents")
    if h.m.word(h.offset("EventTrigger")) != 0xFFFF:
        raise AssertionError("ASM terminal event did not set EventTrigger to FFFF")
    h.m.write(cursor_slot, struct.pack("<H", 0))
    h.compare("empty authored timeline terminal")
    checkpoints._compare_arena(
        native_memory, bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)),
        h.m.data_frame * 16 + h.stack_lo,
        h.m.data_frame * 16 + h.m.stack_top,
        "empty authored timeline terminal",
    )
    return 1


def _record_views(state: bytes, pool: int):
    for index in range(K.POOL_A_COUNT):
        start = pool + index * K.RECORD_SIZE
        yield index, {
            "status": _state_word(state, start + K.REC_STATUS),
            "type": _state_word(state, start + K.REC_TYPE),
            "hp": _state_word(state, start + K.REC_HIT_POINTS),
            "slot": _state_word(state, start + K.REC_SLOT_INDEX),
            "x": _state_word(state, start + K.REC_X),
            "y": _state_word(state, start + K.REC_Y),
        }


def _authored_drop_and_long_formation(h, arena, work: Path) -> int:
    profile = 0
    directory = work / "authored-long-formation"
    document = duplicate_original(profile, directory, "authored_long_formation")
    long_name = "authored_formation_beyond_original_capacity"
    tile_name = "authored_tile_member"
    document["formations"][long_name] = {
        "enemy": "slow_descender", "size": "32x32", "layer": "over_terrain",
        "members": [{"dx": i * 2, "dy": i * 3} for i in range(17)],
    }
    document["formations"][tile_name] = {
        "enemy": "slow_descender", "size": "16x16", "layer": "under_terrain",
        "members": [{"dx": 0, "dy": 0}],
    }
    document["timeline"] = [
        {"clock": 64, "formation": long_name, "x": 48, "y": 64,
         "group": {"drop": "energy"}},
        {"clock": 64, "formation": tile_name, "x": 96, "y": 80,
         "group": {"drop": "fuel"}},
    ]
    for checkpoint in document["checkpoints"]:
        checkpoint["resume_event"] = 0
    document["formation_spawn_parameters"] = {
        "tile_member_hit_points": 37,
        "other_member_hit_points": 23,
    }
    write_json(directory / "level.json", document)
    validate_directory(directory)
    _load_content(h, directory, profile)

    base_memory = bytearray(arena.image)
    map_base = arena.map_segment << 4
    base_memory[map_base:map_base + 0x10000] = bytes([1]) * 0x10000
    memory = bytes(base_memory)
    pool_seed = random.Random(0x4C4F4E47).randbytes(K.POOL_A_COUNT * K.RECORD_SIZE)
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    pool = h.offset("PoolA")
    cursor = _cursor_offset(h, profile)
    writes = [
        (pool, pool_seed),
        (h.offset("GroupTable"), bytes(32)),
        (h.offset("ByteAttributeTable"), bytes(256)),
        (h.offset("EventMarkerFlag"), b"\xA5"),
        # Deliberately unrelated compatibility slot: authored parameters and
        # event drops follow the loaded LevelTimeline descriptor.
        (h.offset("LevelIndex"), struct.pack("<H", 0x8004)),
        (h.offset("LevelScriptClock"), struct.pack("<H", 64)),
        (h.offset("PoolACursor"), struct.pack("<H", pool + (K.POOL_A_COUNT - 2) * K.RECORD_SIZE)),
        (h.offset("GroupSlotIndex"), struct.pack("<H", 0xBEEF)),
        (h.offset("GroupSlotPtr"), struct.pack("<H", 0xFFFF)),
        (h.offset("MapScrollPos"), struct.pack("<H", 100 * K.MAP_ROW_BYTES)),
        (cursor, struct.pack("<H", 0)),
        (h.offset("GroupDropKinds") + (64 & 0x3F), bytes((DROPS["smart_bomb"],))),
    ]
    for index in range(K.POOL_A_COUNT):
        writes.append((pool + index * K.RECORD_SIZE, struct.pack("<H", 0)))
    for offset, data in writes:
        h.write(offset, data)
    group_drop_before = h.m.read(h.offset("GroupDropKinds"), 64)
    h.lib.run_level_script_events()
    state = h.state_storage.snapshot()
    if _state_word(state, cursor) != 2:
        raise AssertionError("same-clock authored events were not both consumed")
    if state[h.offset("GroupDropKinds"):h.offset("GroupDropKinds") + 64] != group_drop_before:
        raise AssertionError("authored event drop values were written into GroupDropKinds")

    records = list(_record_views(state, pool))
    grouped = {slot: [record for _, record in records
                      if record["status"] and record["slot"] == slot]
               for slot in (0, 1)}
    if len(grouped[0]) != 17 or len(grouped[1]) != 1:
        raise AssertionError(f"authored formations spawned unexpected members: "
                             f"{len(grouped[0])}, {len(grouped[1])}")
    if any(record["hp"] != 23 for record in grouped[0]) or grouped[1][0]["hp"] != 37:
        raise AssertionError("authored tile/other-member HP parameters were not applied")
    if any(record["type"] != ARCHETYPES["slow_descender"] for group in grouped.values()
           for record in group):
        raise AssertionError("new semantic formation name did not select its behavior preset")
    group_table = state[h.offset("GroupTable"):h.offset("GroupTable") + 4]
    if group_table != bytes((17, DROPS["energy"], 1, DROPS["fuel"])):
        raise AssertionError(f"same-clock drops were not independent per event: {group_table!r}")
    return 1


def _exhausted_same_clock_case(h, arena, work: Path) -> int:
    profile = 1
    directory = work / "authored-exhausted"
    document = duplicate_original(profile, directory, "authored_exhausted")
    document["timeline"] = copy.deepcopy(document["timeline"][:2])
    clock = 64
    for event in document["timeline"]:
        event["clock"] = clock
    for checkpoint in document["checkpoints"]:
        checkpoint["resume_event"] = 0
    write_json(directory / "level.json", document)
    validate_directory(directory)
    _load_content(h, directory, profile)
    memory = bytearray(arena.image)
    map_base = arena.map_segment << 4
    memory[map_base:map_base + 0x10000] = bytes([1]) * 0x10000
    memory = bytes(memory)
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    pool = h.offset("PoolA")
    pool_seed = random.Random(123).randbytes(K.POOL_A_COUNT * K.RECORD_SIZE)
    for offset, value in (
        (pool, pool_seed),
        (h.offset("GroupTable"), bytes(32)),
        (h.offset("LevelIndex"), struct.pack("<H", profile)),
        (h.offset("LevelScriptClock"), struct.pack("<H", clock)),
        (h.offset("PoolACursor"), struct.pack("<H", pool + (K.POOL_A_COUNT - 2) * K.RECORD_SIZE)),
        (h.offset("GroupSlotPtr"), struct.pack("<H", 0xFFFF)),
        (_cursor_offset(h, profile), struct.pack("<H", 0)),
    ):
        h.write(offset, value)
    for index in range(K.POOL_A_COUNT):
        h.write(pool + index * K.RECORD_SIZE, struct.pack("<H", 1))
    pool_before = h.state_storage.snapshot()[pool:pool + K.POOL_A_COUNT * K.RECORD_SIZE]
    h.lib.run_level_script_events()
    state = h.state_storage.snapshot()
    if _state_word(state, _cursor_offset(h, profile)) != 2:
        raise AssertionError("exhausted Pool A prevented same-clock event consumption")
    if state[pool:pool + K.POOL_A_COUNT * K.RECORD_SIZE] != pool_before:
        raise AssertionError("exhausted Pool A mutated records while consuming timeline events")
    if state[h.offset("EventMarkerFlag")] != 1:
        raise AssertionError("exhausted same-clock timeline did not retain marker state")
    return 1


def _checkpoint_restart_case(h, arena, work: Path, *, owned_terrain=False) -> int:
    profile = 2
    directory = work / "authored-checkpoint"
    document = duplicate_original(profile, directory, "authored_checkpoint")
    if owned_terrain:
        document['version'] = 13
        document['terrain']['attribute_patches'].append(
            {'tile': 12, 'attribute': 'shot_permeable_wall'})
    resume_event = min(7, len(document["timeline"]))
    checkpoint_index = 1
    authored_checkpoint = document["checkpoints"][checkpoint_index]
    authored_checkpoint["resume_event"] = resume_event
    authored_checkpoint["script_clock"] = 0xBEEF
    map_data = bytearray((directory / "map.bin").read_bytes())
    authored_map_offset = 500
    map_data[authored_map_offset] = 2
    (directory / "map.bin").write_bytes(map_data)
    write_json(directory / "level.json", document)
    validate_directory(directory)
    _load_content(h, directory, profile)
    boundaries = script_event_boundaries(h.m, profile)

    base_memory = bytearray(arena.image)
    map_base = arena.map_segment << 4
    base_memory[map_base:map_base + 0x10000] = bytes([1]) * 0x10000
    initial_memory = bytes(base_memory)
    h.reset()
    h.m.u.mem_write(0, initial_memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(initial_memory)

    # Give the ASM oracle a one-entry decoded-map cache containing the authored
    # grid. The native restart reads the same bytes from the loose level object.
    cache_segment = checkpoints.MAP_CACHE_SEGMENT
    filename = h.m.word(h.offset("LevelMapFiles") + 2 * profile)
    cache = struct.pack("<5H", filename, cache_segment, len(map_data), 0, 0)
    cache += struct.pack("<5H", 0xFFFF, 0, 0, 0, 0)
    physical = bytearray(initial_memory)
    physical[cache_segment << 4:(cache_segment << 4) + len(map_data)] = map_data
    h.m.u.mem_write(0, bytes(physical))
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(bytes(physical))
    h.write(h.offset("FileCache"), cache)
    h.m.u.mem_write(cache_segment << 4, bytes(map_data))

    # Use a scratch copy of the checkpoint table in both executions. The host
    # descriptor carries resume_event as an ordinal; the oracle table carries the
    # corresponding original script byte pointer.
    scratch = 0x0500
    checkpoint_bytes = bytearray()
    for index, checkpoint in enumerate(document["checkpoints"]):
        resume = checkpoint["resume_event"]
        target = boundaries[resume]
        threshold = (document["checkpoints"][index + 1]["map_row"] * K.MAP_ROW_BYTES
                     if index < 3 else 0xFFFF)
        checkpoint_bytes += struct.pack(
            "<4H", checkpoint["map_row"] * K.MAP_ROW_BYTES,
            checkpoint["script_clock"], target, threshold,
        )
    h.write(h.offset("LevelCheckpointPtrs") + 2 * profile, struct.pack("<H", scratch))
    h.write(scratch, checkpoint_bytes)
    cursor_token = boundaries[resume_event]
    # This table points at the DS runtime cursor slot. The checkpoint table's
    # third word is the ASM boundary token; it is not the pointer-table value.
    cursor_slot = _cursor_offset(h, profile)
    if h.m.word(h.offset("CheckpointCursorPtrs") + 2 * profile) != cursor_slot:
        raise AssertionError("oracle checkpoint cursor pointer does not target the level cursor slot")
    h.write(h.offset("PrimaryRecord"), checkpoints._record(kind=K.KIND_PLAYER, type=0))
    h.write(h.offset("LevelIndex"), struct.pack("<H", profile))
    h.write(h.offset("MapScrollPos"), struct.pack(
        "<H", authored_checkpoint["map_row"] * K.MAP_ROW_BYTES
    ))
    h.write(h.offset("LevelScriptClock"), struct.pack("<H", 0x6A5B))
    h.write(h.offset("ScrollSubRow"), struct.pack("<H", 3))
    h.write(h.offset("ScrollWindowOffset"), struct.pack("<H", checkpoints._main_word(h.m, "ScrollStartOffset")))
    h.write(h.offset("ScrollDeltaY"), struct.pack("<H", 0xFFF0))
    h.write(h.offset("LastTileStepBackward"), struct.pack("<H", 0))
    h.write(h.offset("ScrollingBackward"), struct.pack("<H", 0))
    h.write(h.offset("LevelScriptCursors") + 2 * profile, struct.pack("<H", 0))

    if owned_terrain:
        from level_format import encode_attribute_patches
        # The oracle reloads equivalent semantic properties from a separate
        # source stream; native v13 reloads its immutable terrain content.
        terrain_source = 0x0600
        h.write(h.offset('AttributePatchPointers') + 2 * profile,
                struct.pack('<H', terrain_source))
        h.write(terrain_source, encode_attribute_patches(document['terrain']))
        h.write(h.offset('ByteAttributeTable') + 12, b'\xa5')

    # Re-seed the oracle's physical memory after state writes and run both restart
    # implementations from the same DOS bytes and primary record.
    before = bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES))
    arena.load(before)
    h.lib.restart_at_checkpoint.argtypes = (ctypes.c_void_p,)
    h.lib.restart_at_checkpoint.restype = None
    h.lib.restart_at_checkpoint(ctypes.c_void_p(h.state_addr + h.offset("PrimaryRecord")))
    native_state = h.state_storage.snapshot()
    if owned_terrain and native_state[h.offset('ByteAttributeTable') + 12] != 2:
        raise AssertionError('checkpoint restart did not restore owned terrain properties')
    native_cursor_offset = _cursor_offset(h, profile)
    if _state_word(native_state, native_cursor_offset) != resume_event:
        raise AssertionError("checkpoint restart did not restore authored event ordinal")
    if _state_word(native_state, h.offset("LevelScriptClock")) != authored_checkpoint["script_clock"]:
        raise AssertionError("checkpoint restart did not restore authored script clock")
    ctypes.memmove(arena.base + h.m.data_frame * 16, native_state, 0x10000)
    native_memory = arena.snapshot()

    h.m.call("RestartAtCheckpoint", {"BP": h.offset("PrimaryRecord")})
    oracle_cursor = h.m.word(native_cursor_offset)
    if oracle_cursor != cursor_token:
        raise AssertionError("ASM checkpoint fixture did not restore the authored source boundary")
    h.m.write(native_cursor_offset, struct.pack("<H", resume_event))
    h.m.write(h.offset("CheckpointScriptCursor"), struct.pack("<H", resume_event))
    h.compare("authored timeline checkpoint restart")
    checkpoints._compare_arena(
        native_memory, bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)),
        h.m.data_frame * 16 + h.stack_lo,
        h.m.data_frame * 16 + h.m.stack_top,
        "authored timeline checkpoint restart",
    )
    if native_memory[map_base + authored_map_offset] != 2:
        raise AssertionError("checkpoint map reload did not restore the authored grid")
    if _state_word(native_state, h.offset("CheckpointScriptCursor")) != resume_event:
        raise AssertionError("checkpoint script cursor was not kept as a semantic ordinal")
    return 1


def run() -> int:
    h = input_harness.HostHarness()
    checkpoints._bind_native(h.lib)
    _bind_content_api(h.lib)
    arena = checkpoints.Arena(h)
    baseline_memory = bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES))
    arena.load(baseline_memory)
    try:
        with tempfile.TemporaryDirectory(prefix="overkill-timeline-content-") as temporary:
            work = Path(temporary)
            cases = _canonical_event_cases(h, arena, work)
            cases += _version8_backward_load(h, work)
            cases += _authored_drop_and_long_formation(h, arena, work)
            cases += _exhausted_same_clock_case(h, arena, work)
            cases += _checkpoint_restart_case(h, arena, work)
            cases += _empty_timeline_terminal_case(h, arena, work)
        h.lib.overkill_level_content_unload()
    finally:
        h.check_canaries()
    print(f"PASS loose timelines: 138 original events compared at full, partial and "
          f"empty Pool A; authored formation/drop/HP and checkpoint/reload cases; "
          f"{cases} native/oracle cases")
    return cases


if __name__ == "__main__":
    run()
