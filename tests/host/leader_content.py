"""Owned leader paths and formation slots against the frozen ASM behavior.

Run this after the host core is built with ``python tests/host/leader_content.py``.
The test itself never builds shared artifacts.
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
from level_format import load, original_paths  # noqa: E402
from level_paths import LEADER_BINDINGS, source_leaders  # noqa: E402
from world import K  # noqa: E402


class _LeaderStep(ctypes.Structure):
    _fields_ = [("y", ctypes.c_uint16), ("x", ctypes.c_uint16),
                ("follower_y", ctypes.c_uint16), ("follower_x", ctypes.c_uint16),
                ("spawn_follower", ctypes.c_uint8), ("terminal", ctypes.c_uint8)]


class _LeaderSlot(ctypes.Structure):
    _fields_ = [("y", ctypes.c_uint16), ("x", ctypes.c_uint16)]


class _LeaderPaths(ctypes.Structure):
    _fields_ = [("step_count", ctypes.c_uint16),
                ("starts", ctypes.c_uint16 * 6), ("ends", ctypes.c_uint16 * 6),
                ("slot_count", ctypes.c_uint16),
                ("steps", ctypes.POINTER(_LeaderStep)),
                ("slots", ctypes.POINTER(_LeaderSlot))]


def _module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    result = importlib.util.module_from_spec(spec)
    sys.modules[name] = result
    spec.loader.exec_module(result)
    return result


input_harness = _module("leader_content_input", HOST_TESTS / "input.py")
checkpoints = _module("leader_content_checkpoints", HOST_TESTS / "checkpoints.py")
far_calls = _module("leader_content_far_calls", HOST_TESTS / "player_frame.py")

_LEADER_TYPES = {
    "sway_leader": 0x13,
    "sweep_leader": 0x15,
    "bob_chase_leader": 0x1C,
    "slot_hopper_leader": 0x1F,
    "sweeper_leader": 0x7D,
    "march_leader": 0x7E,
}
_END_LABELS = {
    "sway_leader": "LeaderScript13End",
    "sweep_leader": "LeaderScript15End",
    "bob_chase_leader": "LeaderScript1CEnd",
    "slot_hopper_leader": "LeaderScript1FEnd",
    "sweeper_leader": "LeaderScript7DEnd",
    "march_leader": "LeaderScript7EEnd",
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
    lib.overkill_level_leaders_current.argtypes = ()
    lib.overkill_level_leaders_current.restype = ctypes.POINTER(_LeaderPaths)
    lib.overkill_leader_start.argtypes = (ctypes.c_uint16,)
    lib.overkill_leader_start.restype = ctypes.c_uint16
    lib.overkill_leader_end.argtypes = (ctypes.c_uint16,)
    lib.overkill_leader_end.restype = ctypes.c_uint16
    lib.overkill_leader_current_step.argtypes = (ctypes.c_uint16,)
    lib.overkill_leader_current_step.restype = ctypes.POINTER(_LeaderStep)
    lib.overkill_leader_slot.argtypes = (ctypes.c_uint16,)
    lib.overkill_leader_slot.restype = ctypes.POINTER(_LeaderSlot)
    lib.overkill_leader_slot_start.argtypes = ()
    lib.overkill_leader_slot_start.restype = ctypes.c_uint16
    lib.overkill_leader_slot_next.argtypes = (ctypes.c_uint16,)
    lib.overkill_leader_slot_next.restype = ctypes.c_uint16
    lib.overkill_leader_slot_limit.argtypes = ()
    lib.overkill_leader_slot_limit.restype = ctypes.c_uint16
    lib.run_type_handler.argtypes = (ctypes.c_void_p,)
    lib.run_type_handler.restype = None
    lib.type13_formation_leader.argtypes = (ctypes.c_void_p,)
    lib.type13_formation_leader.restype = None
    lib.start_leader_script.argtypes = (ctypes.c_void_p, ctypes.c_uint16)
    lib.start_leader_script.restype = None
    lib.release_encounter_member.argtypes = (ctypes.c_void_p,)
    lib.release_encounter_member.restype = None


def _load(h, directory: Path, profile: int) -> None:
    error = ctypes.create_string_buffer(512)
    if not h.lib.overkill_level_content_load(
        str(directory).encode(), str(ROOT / "levels/original").encode(), error, len(error)
    ):
        raise AssertionError(f"native loader rejected {directory.name}: "
                             f"{error.value.decode(errors='replace')}")
    identity = h.lib.overkill_level_content_id()
    if not identity or h.lib.overkill_level_content_behavior_profile() != profile:
        raise AssertionError("native loose leader identity/profile was not activated")


def _default_leader(document: dict, name: str, sources: dict) -> dict:
    return document.get("leader_paths", {}).get(name, sources[name][2])


def _view_case(h, document: dict, sources: dict) -> tuple[list[int], list[int], list[int], int]:
    pointer = h.lib.overkill_level_leaders_current()
    if not pointer:
        raise AssertionError("version-11 level did not bind an owned leader provider")
    view = pointer.contents
    cursor = 0
    starts, ends, counts = [], [], []
    expected_steps = []
    for index, name in enumerate(LEADER_BINDINGS):
        definition = _default_leader(document, name, sources)
        starts.append(cursor)
        if view.starts[index] != cursor:
            raise AssertionError(f"{name}: flattened start {view.starts[index]} != {cursor}")
        for step in definition["steps"]:
            target = step["target"]
            follower = step.get("follower")
            spawn = follower is not None
            if spawn:
                follower_y = (follower["y"] - 32) & 0xFFFF
                follower_x = follower["x"] & 0xFFFF
            elif LEADER_BINDINGS[name][1] == 8:
                follower_y = follower_x = 0xFFFF
            else:
                follower_y = follower_x = 0xFFFF
            expected_steps.append(((target["y"] - 32) & 0xFFFF,
                                   target["x"] & 0xFFFF,
                                   follower_y, follower_x, int(spawn), 0))
        end_x = definition["end"]["x"] & 0xFFFF
        expected_steps.append((K.LEADER_END_Y, end_x, 0, 0, 0, 1))
        cursor += len(definition["steps"]) + 1
        ends.append(cursor - 1)
        counts.append(len(definition["steps"]) + 1)
        start_label = LEADER_BINDINGS[name][0]
        end_label = _END_LABELS[name]
        if h.lib.overkill_leader_start(h.offset(start_label)) != starts[index]:
            raise AssertionError(f"{name}: legacy start did not map to its ordinal")
        if h.lib.overkill_leader_end(h.offset(end_label)) != ends[index]:
            raise AssertionError(f"{name}: legacy end did not map to its terminal ordinal")
    if view.step_count != cursor:
        raise AssertionError(f"flattened step count {view.step_count} != {cursor}")
    for ordinal, expected in enumerate(expected_steps):
        step_ptr = h.lib.overkill_leader_current_step(ordinal)
        if not step_ptr:
            raise AssertionError(f"provider omitted step ordinal {ordinal}")
        step = step_ptr.contents
        actual = (step.y, step.x, step.follower_y, step.follower_x,
                  step.spawn_follower, step.terminal)
        comparable = actual if expected[4] else (actual[0], actual[1],
                                                  expected[2], expected[3],
                                                  actual[4], actual[5])
        if comparable != expected:
            raise AssertionError(f"leader step {ordinal}: {actual} != {expected}")
    invalid = h.lib.overkill_leader_current_step(cursor).contents
    if not invalid.terminal or invalid.y != K.LEADER_END_Y:
        raise AssertionError("out-of-range leader cursor did not use the safe terminal")

    slots = _default_leader(document, "slot_hopper_leader", sources)["slots"]
    if view.slot_count != len(slots):
        raise AssertionError(f"slot count {view.slot_count} != {len(slots)}")
    for ordinal, slot in enumerate(slots):
        actual_slot = h.lib.overkill_leader_slot(ordinal).contents
        expected_slot = ((slot["y"] - 32) & 0xFFFF, slot["x"] & 0xFFFF)
        if (actual_slot.y, actual_slot.x) != expected_slot:
            raise AssertionError(f"formation slot {ordinal} differs from source data")
        if h.lib.overkill_leader_slot_next(ordinal) != (ordinal + 1) % len(slots):
            raise AssertionError(f"formation slot cursor did not wrap after ordinal {ordinal}")
    if h.lib.overkill_leader_slot_start() != 0 or h.lib.overkill_leader_slot_limit() != len(slots):
        raise AssertionError("owned formation slot cursor bounds are inconsistent")
    return starts, ends, counts, len(slots)


def _write_native(h, offset: int, data: bytes) -> None:
    ctypes.memmove(h.state_addr + offset, bytes(data), len(data))


def _record(x: int, y: int, enemy_type: int, path: int = 0) -> bytes:
    record = bytearray([0xA5]) * K.RECORD_SIZE
    values = {
        "status": 1, "x": x, "y": y, "direction": K.DIR_DOWN,
        "sprite": 0, "draw_pass": 1, "size_class": 1,
        "kind": K.KIND_ENEMY, "type": enemy_type, "hit_points": 7,
        "slot_index": 0xFFFF, "flash_timer": 0, "path": path,
        "saved_x": x, "saved_y": 0, "entry_delay": 0,
    }
    for name, value in values.items():
        struct.pack_into("<H", record, getattr(K, "REC_" + name.upper()), value & 0xFFFF)
    return bytes(record)


def _memory(arena) -> bytes:
    result = bytearray(arena.image)
    start = arena.map_segment << 4
    result[start:start + 0x10000] = bytes([1]) * 0x10000
    return bytes(result)


def _state_word(state: bytes, offset: int) -> int:
    return struct.unpack_from("<H", state, offset)[0]


def _leader_case(h, arena, *, profile: int, directory: Path, name: str,
                 step_index: int, definition: dict, ordinal: int, source_offset: int,
                 arrival: bool, free: int, slot_index: int, label: str) -> bytes:
    """Run one leader call on both implementations, translating only cursors."""
    target = definition["steps"][step_index]["target"]
    if arrival:
        x, y = target["x"], target["y"]
    else:
        x, y = (target["x"] + 64) & 0xFFFF, (target["y"] + 64) & 0xFFFF
    memory = _memory(arena)
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    pool = h.offset("PoolA")
    pool_b = h.offset("PoolB")
    h.write(pool, _record(x, y, _LEADER_TYPES[name]))
    for index in range(1, K.POOL_A_COUNT):
        record = bytearray([0xA5]) * K.RECORD_SIZE
        struct.pack_into("<H", record, K.REC_STATUS, int(index > free))
        h.write(pool + index * K.RECORD_SIZE, record)
    for index in range(K.POOL_B_COUNT):
        record = bytearray([0xA5]) * K.RECORD_SIZE
        struct.pack_into("<H", record, K.REC_STATUS, 0)
        h.write(pool_b + index * K.RECORD_SIZE, record)
    slot_start = h.lib.overkill_leader_slot_start()
    slot_limit = h.lib.overkill_leader_slot_limit()
    legacy_slot_start = h.offset("FormationSlots")
    slot_native = slot_index if name == "slot_hopper_leader" else slot_start
    slot_oracle = legacy_slot_start + (slot_index * 4 if name == "slot_hopper_leader" else 0)
    for field, value in (
        ("LevelIndex", profile), ("DemoActive", 0),
        ("PoolACursor", pool + K.RECORD_SIZE),
        ("PoolBCursor", pool_b + K.RECORD_SIZE),
        ("MapScrollPos", 100 * K.MAP_ROW_BYTES),
        ("LeaderScriptCursor", source_offset),
        ("FormationSlotCursor", slot_oracle),
        ("EncounterLiveCount", 1), ("EncounterEndDelay", 0x64),
        ("SfxEnabled", 0), ("RecordTickCounter", 0x11),
        ("DifficultySetting", 0), ("ByteAttributeTable", 0),
    ):
        data = bytes(256) if field == "ByteAttributeTable" else struct.pack("<H", value & 0xFFFF)
        h.write(h.offset(field), data)
    _write_native(h, h.offset("LeaderScriptCursor"), struct.pack("<H", ordinal))
    _write_native(h, h.offset("FormationSlotCursor"), struct.pack("<H", slot_native))
    before = bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES))
    arena.load(before)

    h.lib.run_type_handler(ctypes.c_void_p(h.state_addr + pool))
    native_state = h.state_storage.snapshot()
    cursor_offset = h.offset("LeaderScriptCursor")
    slot_offset = h.offset("FormationSlotCursor")
    expected_cursor = ordinal + int(arrival)
    if _state_word(native_state, cursor_offset) != expected_cursor:
        raise AssertionError(f"{label}: owned cursor did not consume exactly one arrival")
    expected_slot = slot_native
    if name == "slot_hopper_leader" and arrival:
        for _ in range(5):
            expected_slot = h.lib.overkill_leader_slot_next(expected_slot)
    if _state_word(native_state, slot_offset) != expected_slot:
        raise AssertionError(f"{label}: owned formation slot cursor is incorrect")
    ctypes.memmove(arena.base + h.m.data_frame * 16, native_state, 0x10000)
    native_memory = arena.snapshot()

    h.m.call("RunTypeHandler", {"BP": pool})
    oracle_cursor = h.m.word(cursor_offset)
    expected_oracle_cursor = source_offset + (LEADER_BINDINGS[name][1] if arrival else 0)
    if oracle_cursor != expected_oracle_cursor:
        raise AssertionError(f"{label}: ASM source cursor {oracle_cursor:04X} != "
                             f"{expected_oracle_cursor:04X}")
    oracle_slot = h.m.word(slot_offset)
    if name == "slot_hopper_leader" and arrival:
        expected_oracle_slot = legacy_slot_start + (slot_index + 5) * 4
    else:
        expected_oracle_slot = slot_oracle
    if oracle_slot != expected_oracle_slot:
        raise AssertionError(f"{label}: ASM formation slot cursor {oracle_slot:04X} != "
                             f"{expected_oracle_slot:04X}")
    # Ordinals and original DS byte offsets are the only expected DS difference.
    h.m.write(cursor_offset, struct.pack("<H", expected_cursor))
    h.m.write(slot_offset, struct.pack("<H", expected_slot))
    h.compare(label)
    checkpoints._compare_arena(
        native_memory, bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)),
        h.m.data_frame * 16 + h.stack_lo,
        h.m.data_frame * 16 + h.m.stack_top,
        label,
    )
    return native_state


def _canonical_documents(h, arena, work: Path):
    sources = source_leaders(h.m)
    directories = []
    views = []
    documents = []
    for profile in range(6):
        directory = work / f"canonical-leaders-{profile}"
        document = duplicate_original(profile, directory, f"leader_profile_{profile}")
        write_json(directory / "level.json", document)
        validate_directory(directory)
        _load(h, directory, profile)
        views.append(_view_case(h, document, sources))
        documents.append(document)
        directories.append(directory)
    if any(view != views[0] for view in views[1:]):
        raise AssertionError("canonical levels produced inconsistent leader ordinal layouts")
    return documents, sources, directories, views[0]


def _canonical_execution_cases(h, arena, documents, sources, directories, view) -> int:
    starts, ends, _counts, slot_count = view
    cases = 0
    for profile, document in enumerate(documents):
        directory = directories[profile]
        _load(h, directory, profile)
        for leader_index, name in enumerate(LEADER_BINDINGS):
            definition = _default_leader(document, name, sources)
            legacy_start = h.offset(LEADER_BINDINGS[name][0])
            start = starts[leader_index]
            for step_index, _step in enumerate(definition["steps"]):
                ordinal = start + step_index
                source_offset = legacy_start + step_index * LEADER_BINDINGS[name][1]
                _leader_case(
                    h, arena, profile=profile, directory=directory, name=name,
                    step_index=step_index, definition=definition, ordinal=ordinal,
                    source_offset=source_offset, arrival=False, free=0,
                    slot_index=0,
                    label=f"{name} profile={profile} step={step_index} nonarrival/fullpool",
                )
                cases += 1
                for free in (0, 3, K.POOL_A_COUNT - 1):
                    state = _leader_case(
                        h, arena, profile=profile, directory=directory, name=name,
                        step_index=step_index, definition=definition, ordinal=ordinal,
                        source_offset=source_offset, arrival=True, free=free,
                        slot_index=0,
                        label=f"{name} profile={profile} step={step_index} arrival/free={free}",
                    )
                    if (free > 0 and LEADER_BINDINGS[name][1] == 8 and
                            definition["steps"][step_index].get("follower") is None):
                        child = h.offset("PoolA") + K.RECORD_SIZE
                        if _state_word(state, child + K.REC_STATUS):
                            raise AssertionError(f"{name} null follower allocated a child at step {step_index}")
                    cases += 1
    return cases


def _owned_step_call(h, arena, *, profile: int, level_index: int, enemy_type: int,
                     ordinal: int, x: int, y: int, free: int,
                     slot_cursor: int = 0, mutate_sources: tuple[int, bytes] | None = None,
                     direct: bool = False, saved_position: tuple[int, int] | None = None,
                     overrides: dict[str, int] | None = None) -> bytes:
    memory = _memory(arena)
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    pool = h.offset("PoolA")
    pool_b = h.offset("PoolB")
    actor = bytearray(_record(x, y, enemy_type))
    if saved_position is not None:
        struct.pack_into("<H", actor, K.REC_SAVED_X, saved_position[0] & 0xFFFF)
        struct.pack_into("<H", actor, K.REC_SAVED_Y, saved_position[1] & 0xFFFF)
    if enemy_type == 0x20:
        struct.pack_into("<H", actor, K.REC_DIVE_PHASE, 0xFFFF)
    h.write(pool, actor)
    for index in range(1, K.POOL_A_COUNT):
        record = bytearray([0xA5]) * K.RECORD_SIZE
        struct.pack_into("<H", record, K.REC_STATUS, int(index > free))
        h.write(pool + index * K.RECORD_SIZE, record)
    for index in range(K.POOL_B_COUNT):
        record = bytearray([0xA5]) * K.RECORD_SIZE
        struct.pack_into("<H", record, K.REC_STATUS, 0)
        h.write(pool_b + index * K.RECORD_SIZE, record)
    for name, value in (
        ("LevelIndex", level_index), ("DemoActive", 0),
        ("PoolACursor", pool + K.RECORD_SIZE),
        ("PoolBCursor", pool_b + K.RECORD_SIZE),
        ("MapScrollPos", 100 * K.MAP_ROW_BYTES),
        ("LeaderScriptCursor", ordinal), ("FormationSlotCursor", slot_cursor),
        ("EncounterLiveCount", 1), ("EncounterEndDelay", 0x64),
        ("SfxEnabled", 0), ("RecordTickCounter", 0x11),
        ("DifficultySetting", 0), ("ByteAttributeTable", 0),
    ):
        data = bytes(256) if name == "ByteAttributeTable" else struct.pack("<H", value & 0xFFFF)
        h.write(h.offset(name), data)
    for name, value in (overrides or {}).items():
        h.write(h.offset(name), struct.pack("<H", value & 0xFFFF))
    if mutate_sources:
        offset, payload = mutate_sources
        _write_native(h, offset, payload)
    before = bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES))
    arena.load(before)
    if direct:
        h.lib.type13_formation_leader(ctypes.c_void_p(h.state_addr + pool))
    else:
        h.lib.run_type_handler(ctypes.c_void_p(h.state_addr + pool))
    return h.state_storage.snapshot()


def _leader_death_case(h, arena, profile: int, name: str,
                       start_ordinal: int, end_ordinal: int) -> None:
    memory = _memory(arena)
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    pool, pool_b = h.offset("PoolA"), h.offset("PoolB")
    actor = pool + 4 * K.RECORD_SIZE
    h.write(actor, _record(0x58, 0x60, _LEADER_TYPES[name]))
    for index in range(K.POOL_A_COUNT):
        at = pool + index * K.RECORD_SIZE
        h.write(at + K.REC_STATUS, struct.pack("<H", int(index == 4)))
    for index in range(K.POOL_B_COUNT):
        h.write(pool_b + index * K.RECORD_SIZE + K.REC_STATUS, struct.pack("<H", 0))
    start_label, _stride = LEADER_BINDINGS[name]
    end_label = _END_LABELS[name]
    legacy_end = h.offset(end_label)
    legacy_start = h.offset(start_label)
    for field, value in (
        ("LevelIndex", profile), ("LeaderScriptCursor", legacy_start),
        ("FormationSlotCursor", h.offset("FormationSlots") + 12),
        ("PoolACursor", pool), ("PoolBCursor", pool_b),
        ("DropX", 0x58), ("DropY", 0x60), ("DropKind", 2),
        ("EncounterLiveCount", 2), ("SfxEnabled", 0),
    ):
        h.write(h.offset(field), struct.pack("<H", value & 0xFFFF))
    _write_native(h, h.offset("LeaderScriptCursor"), struct.pack("<H", start_ordinal))
    _write_native(h, h.offset("FormationSlotCursor"), struct.pack("<H", 3))
    before = bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES))
    arena.load(before)
    h.lib.release_encounter_member(ctypes.c_void_p(h.state_addr + actor))
    native = h.state_storage.snapshot()
    if _state_word(native, h.offset("LeaderScriptCursor")) != end_ordinal:
        raise AssertionError(f"{name}: death did not select the owned terminal ordinal")
    if _state_word(native, h.offset("FormationSlotCursor")) != 0:
        raise AssertionError(f"{name}: death did not reset the owned formation-slot cycle")
    ctypes.memmove(arena.base + h.m.data_frame * 16, native, 0x10000)
    native_memory = arena.snapshot()
    h.m.call("ReleaseEncounterMember", {"BP": actor})
    if h.m.word(h.offset("LeaderScriptCursor")) != legacy_end:
        raise AssertionError(f"{name}: ASM death fixture did not select the legacy end address")
    if h.m.word(h.offset("FormationSlotCursor")) != h.offset("FormationSlots"):
        raise AssertionError(f"{name}: ASM death fixture did not reset source slots")
    h.m.write(h.offset("LeaderScriptCursor"), struct.pack("<H", end_ordinal))
    h.m.write(h.offset("FormationSlotCursor"), struct.pack("<H", 0))
    label = f"owned leader death {name}"
    h.compare(label)
    checkpoints._compare_arena(
        native_memory, bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)),
        h.m.data_frame * 16 + h.stack_lo,
        h.m.data_frame * 16 + h.m.stack_top,
        label,
    )


def _leader_start_case(h, arena, profile: int, name: str | None,
                       ordinal: int, script_value: int) -> None:
    memory = _memory(arena)
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    actor = h.offset("PoolA")
    h.write(actor, _record(0x55, 0x66, _LEADER_TYPES[name] if name else 0x21))
    for field, value in (
        ("LevelIndex", profile), ("LeaderScriptCursor", script_value),
        ("FormationSlotCursor", h.offset("FormationSlots") + 28),
        ("EncounterLiveCount", 0x1234), ("EncounterEndDelay", 0x4321),
        ("SwayDirX", 0xFFFF), ("SwayPhase", 2), ("SwayDropY", 0x1234),
        ("SwayReversals", 0xABCD), ("EncounterTicks", 0x9876),
        ("MarchEdgeHit", 1), ("MarchStepNow", 1),
    ):
        h.write(h.offset(field), struct.pack("<H", value & 0xFFFF))
    native_script = ordinal if name else 0xFFFF
    _write_native(h, h.offset("LeaderScriptCursor"), struct.pack("<H", native_script))
    _write_native(h, h.offset("FormationSlotCursor"), struct.pack("<H", 0))
    before = bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES))
    arena.load(before)
    h.lib.start_leader_script(ctypes.c_void_p(h.state_addr + actor), script_value)
    native = h.state_storage.snapshot()
    if _state_word(native, h.offset("LeaderScriptCursor")) != native_script:
        raise AssertionError("owned StartLeaderScript selected the wrong ordinal")
    if _state_word(native, h.offset("FormationSlotCursor")) != 0:
        raise AssertionError("owned StartLeaderScript did not reset formation slots")
    if _state_word(native, actor + K.REC_HIT_POINTS) != 0x14:
        raise AssertionError("StartLeaderScript did not initialize leader hit points")
    ctypes.memmove(arena.base + h.m.data_frame * 16, native, 0x10000)
    native_memory = arena.snapshot()
    far_calls._call_far(h.m, "StartLeaderScript", {"AX": script_value, "BX": actor})
    expected_asm = script_value
    if h.m.word(h.offset("LeaderScriptCursor")) != expected_asm:
        raise AssertionError("ASM StartLeaderScript changed its passed source cursor")
    if h.m.word(h.offset("FormationSlotCursor")) != h.offset("FormationSlots"):
        raise AssertionError("ASM StartLeaderScript did not reset original slot pointer")
    h.m.write(h.offset("LeaderScriptCursor"), struct.pack("<H", native_script))
    h.m.write(h.offset("FormationSlotCursor"), struct.pack("<H", 0))
    label = f"owned StartLeaderScript {name or 'Type21 numeric seed'} profile={profile}"
    h.compare(label)
    checkpoints._compare_arena(
        native_memory, bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)),
        h.m.data_frame * 16 + h.stack_lo,
        h.m.data_frame * 16 + h.m.stack_top,
        label,
    )


def _cursor_gate_case(h, arena, profile: int, leader_name: str,
                      member_type: int, end_ordinal: int, label: str) -> None:
    memory = _memory(arena)
    h.reset()
    h.m.u.mem_write(0, memory)
    h.m.set_state(h.baseline)
    h.state_storage.load(h.baseline)
    arena.load(memory)
    pool, pool_b = h.offset("PoolA"), h.offset("PoolB")
    actor = _record(0x50, 0x50, member_type)
    actor_data = bytearray(actor)
    struct.pack_into("<H", actor_data, K.REC_SAVED_X, 0x50)
    struct.pack_into("<H", actor_data, K.REC_SAVED_Y, 0x50)
    h.write(pool, actor_data)
    for index in range(1, K.POOL_A_COUNT):
        record = bytearray([0xA5]) * K.RECORD_SIZE
        struct.pack_into("<H", record, K.REC_STATUS, 0)
        h.write(pool + index * K.RECORD_SIZE, record)
    for index in range(K.POOL_B_COUNT):
        record = bytearray([0xA5]) * K.RECORD_SIZE
        struct.pack_into("<H", record, K.REC_STATUS, 0)
        h.write(pool_b + index * K.RECORD_SIZE, record)
    legacy_end = h.offset(_END_LABELS[leader_name])
    for field, value in (
        ("LevelIndex", profile), ("LeaderScriptCursor", legacy_end),
        ("FormationSlotCursor", h.offset("FormationSlots")),
        ("PoolACursor", pool + K.RECORD_SIZE), ("PoolBCursor", pool_b),
        ("PrimaryRecord", 0), ("SfxEnabled", 0),
        ("EncounterLiveCount", 1), ("EncounterTicks", 0x23),
        ("RecordTickCounter", 0x2EF), ("FrameCount64", 0x3F),
        ("FrameParity", 1), ("MarchStepNow", 1), ("MarchStepX", 2),
        ("MarchDelay", 0), ("MarchDropNow", 0),
    ):
        h.write(h.offset(field), struct.pack("<H", value & 0xFFFF))
    h.write(h.offset("PrimaryRecord"), checkpoints._record(status=1, x=0x80, y=0x40))
    _write_native(h, h.offset("LeaderScriptCursor"), struct.pack("<H", end_ordinal))
    _write_native(h, h.offset("FormationSlotCursor"), struct.pack("<H", 0))
    before = bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES))
    arena.load(before)
    h.lib.run_type_handler(ctypes.c_void_p(h.state_addr + pool))
    native = h.state_storage.snapshot()
    if _state_word(native, h.offset("LeaderScriptCursor")) != end_ordinal:
        raise AssertionError(f"{label}: owned terminal comparison changed the shared cursor")
    if member_type == 0x80 and _state_word(native, pool + K.REC_SAVED_X) != 0x52:
        raise AssertionError("type 80 did not pass its owned march-end gate")
    ctypes.memmove(arena.base + h.m.data_frame * 16, native, 0x10000)
    native_memory = arena.snapshot()
    h.m.call("RunTypeHandler", {"BP": pool})
    if h.m.word(h.offset("LeaderScriptCursor")) != legacy_end:
        raise AssertionError(f"{label}: ASM terminal gate cursor changed unexpectedly")
    h.m.write(h.offset("LeaderScriptCursor"), struct.pack("<H", end_ordinal))
    h.m.write(h.offset("FormationSlotCursor"), struct.pack("<H", 0))
    h.compare(label)
    checkpoints._compare_arena(
        native_memory, bytes(h.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)),
        h.m.data_frame * 16 + h.stack_lo,
        h.m.data_frame * 16 + h.m.stack_top,
        label,
    )


def _start_and_death_cases(h, arena, documents, sources, directories, view) -> int:
    starts, ends, _counts, _slot_count = view
    cases = 0
    for profile, (document, directory) in enumerate(zip(documents, directories)):
        _load(h, directory, profile)
        for index, name in enumerate(LEADER_BINDINGS):
            script_value = h.offset(LEADER_BINDINGS[name][0])
            _leader_start_case(h, arena, profile, name, starts[index], script_value)
            _leader_death_case(h, arena, profile, name, starts[index], ends[index])
            cases += 2
        # Type 21 uses a numeric legacy seed. Owned leader paths do not claim it;
        # the engine's unknown-seed sentinel must remain explicit and safe.
        _leader_start_case(h, arena, profile, None, 0xFFFF, profile + 1)
        cases += 1
    # REC_TYPE terminal checks share the same cursor but keep their distinct
    # post-terminal behavior, including the marcher's saved-coordinate update.
    _load(h, directories[0], 0)
    for leader_name, member_type, index in (
        ("sway_leader", 0x14, 0),
        ("sweeper_leader", 0x93, 4),
        ("march_leader", 0x80, 5),
    ):
        _cursor_gate_case(h, arena, 0, leader_name, member_type, ends[index],
                          f"owned terminal gate {member_type:02X}")
        cases += 1
    return cases


def _authored_and_compatibility_cases(h, arena, work: Path, sources: dict) -> int:
    cases = 0
    directory = work / "authored-leader-profile"
    document = duplicate_original(0, directory, "authored_leader_profile")
    leaders = document.setdefault("leader_paths", {})
    sweep = copy.deepcopy(sources["sweep_leader"][2])
    # Y=31 encodes to FFFF in the legacy word stream. Owned descriptors carry an
    # explicit spawn bit, so this remains a real follower coordinate.
    sweep["steps"][0]["target"] = {"x": 80, "y": 31}
    sweep["steps"][0]["follower"] = {"x": 42, "y": 31}
    sweep["steps"].extend([
        {"target": {"x": 90, "y": 70}, "follower": {"x": -12, "y": 75}},
        {"target": {"x": -30, "y": 80}, "follower": None},
    ])
    leaders["sweep_leader"] = sweep
    slots = copy.deepcopy(sources["slot_hopper_leader"][2])
    slots["slots"] = [{"x": 10, "y": 40}, {"x": 30, "y": 50}, {"x": 50, "y": 60}]
    leaders["slot_hopper_leader"] = slots
    write_json(directory / "level.json", document)
    validate_directory(directory)
    _load(h, directory, 0)
    authored_sources = source_leaders(h.m)
    start_ordinals = []
    cursor = 0
    for name in LEADER_BINDINGS:
        start_ordinals.append(cursor)
        definition = _default_leader(document, name, authored_sources)
        cursor += len(definition["steps"]) + 1
    view = h.lib.overkill_level_leaders_current().contents
    if view.slot_count != 3:
        raise AssertionError("authored formation slot list did not reach the runtime")

    legacy_start = authored_sources["sweep_leader"][0]
    poison = bytes([0xCC]) * 8
    sweep_call = dict(profile=0, level_index=5, enemy_type=0x15,
                      ordinal=start_ordinals[1], x=80, y=31, free=3)
    baseline = _owned_step_call(h, arena, **sweep_call)
    native = _owned_step_call(
        h, arena, **sweep_call, mutate_sources=(legacy_start, poison),
    )
    normalized = bytearray(native)
    normalized[legacy_start:legacy_start + len(poison)] = baseline[legacy_start:legacy_start + len(poison)]
    if normalized != baseline:
        raise AssertionError("owned sweep leader consulted poisoned legacy script bytes")
    cases += 1
    child = h.offset("PoolA") + K.RECORD_SIZE
    if (_state_word(native, child + K.REC_STATUS) == 0 or
            _state_word(native, child + K.REC_SAVED_X) != 42 or
            _state_word(native, child + K.REC_SAVED_Y) != 31 or
            _state_word(native, child + K.REC_TYPE) != 0x17):
        raise AssertionError("authored target/follower data did not drive owned sweep-leader spawn")
    if _state_word(native, h.offset("LeaderScriptCursor")) != start_ordinals[1] + 1:
        raise AssertionError("authored leader did not advance its ordinal after exact arrival")
    cases += 1

    # The owned runtime accepts a route longer than its original byte table.
    longer_ordinal = start_ordinals[1] + len(sweep["steps"]) - 1
    longer_target = sweep["steps"][-1]["target"]
    native = _owned_step_call(
        h, arena, profile=0, level_index=2, enemy_type=0x15,
        ordinal=longer_ordinal, x=longer_target["x"], y=longer_target["y"], free=3,
    )
    if (_state_word(native, h.offset("LeaderScriptCursor")) != longer_ordinal + 1 or
            _state_word(native, h.offset("PoolA") + K.RECORD_SIZE + K.REC_STATUS)):
        raise AssertionError("extended authored route did not advance its no-follower step")
    cases += 1

    # Five members consume a three-slot authored cycle; then the next leader
    # arrival begins from the current ordinal, not the original DS table.
    slot_ordinal = start_ordinals[3]
    expected_slot = 0
    for iteration in range(2):
        first_slot = expected_slot
        slot_definition = slots["slots"]
        slot_call = dict(
            profile=0, level_index=4, enemy_type=0x1F, ordinal=slot_ordinal,
            x=sources["slot_hopper_leader"][2]["steps"][0]["target"]["x"],
            y=sources["slot_hopper_leader"][2]["steps"][0]["target"]["y"],
            free=5, slot_cursor=first_slot,
        )
        baseline = _owned_step_call(h, arena, **slot_call)
        poison_slots = bytes([0xCC]) * 80
        native = _owned_step_call(
            h, arena, **slot_call,
            mutate_sources=(h.offset("FormationSlots"), poison_slots),
        )
        source_slots = h.offset("FormationSlots")
        normalized = bytearray(native)
        normalized[source_slots:source_slots + len(poison_slots)] = \
            baseline[source_slots:source_slots + len(poison_slots)]
        if normalized != baseline:
            raise AssertionError("owned slot cycle consulted poisoned legacy slot bytes")
        cases += 1
        for child_index in range(1, 6):
            child = h.offset("PoolA") + child_index * K.RECORD_SIZE
            expected = slot_definition[(first_slot + child_index - 1) % 3]
            if (_state_word(native, child + K.REC_SAVED_X) != expected["x"] or
                    _state_word(native, child + K.REC_SAVED_Y) != expected["y"]):
                raise AssertionError(f"authored slot sequence iteration={iteration} child={child_index}: "
                                     f"got ({_state_word(native, child + K.REC_SAVED_X)}, "
                                     f"{_state_word(native, child + K.REC_SAVED_Y)}) expected "
                                     f"({expected['x']}, {expected['y']})")
        expected_slot = (first_slot + 5) % 3
        if _state_word(native, h.offset("FormationSlotCursor")) != expected_slot:
            raise AssertionError("authored slot cycle retained a noncanonical cursor")
        cases += 1

    # Type 20 retains its skip-current slot-hop rule with the authored cycle.
    for current, expected_next, slot_cursor in ((0, 1, 0), (2, 0, 2)):
        point = slots["slots"][current]
        native = _owned_step_call(
            h, arena, profile=0, level_index=4, enemy_type=0x20,
            ordinal=0, x=point["x"], y=point["y"], free=0,
            slot_cursor=slot_cursor, saved_position=(point["x"], point["y"]),
            overrides={"EncounterTicks": 0x23, "EncounterLiveCount": 4,
                       "FrameCount64": 0x3F, "RecordTickCounter": 0x100},
        )
        target = slots["slots"][expected_next]
        actor = h.offset("PoolA")
        if (_state_word(native, actor + K.REC_SAVED_X) != target["x"] or
                _state_word(native, actor + K.REC_SAVED_Y) != target["y"] or
                _state_word(native, h.offset("FormationSlotCursor")) != (expected_next + 1) % 3):
            raise AssertionError(f"authored slot-hop current={current}: got saved "
                                 f"({_state_word(native, actor + K.REC_SAVED_X)}, "
                                 f"{_state_word(native, actor + K.REC_SAVED_Y)}) cursor "
                                 f"{_state_word(native, h.offset('FormationSlotCursor'))}; "
                                 f"expected ({target['x']}, {target['y']}) cursor "
                                 f"{(expected_next + 1) % 3}")
        cases += 1

    # An authored terminal descriptor is a safe clamp: even exact arrival does
    # not read a following route and cannot allocate a follower. The out-of-range
    # sentinel path is safe for the same reason.
    sweep_start = start_ordinals[1]
    sweep_terminal = sweep_start + len(sweep["steps"])
    end_x = sweep["end"]["x"]
    terminal_state = _owned_step_call(
        h, arena, profile=0, level_index=5, enemy_type=0x15,
        ordinal=sweep_terminal, x=end_x, y=K.LEADER_END_Y + 32, free=3, direct=True,
    )
    if (_state_word(terminal_state, h.offset("LeaderScriptCursor")) != sweep_terminal or
            _state_word(terminal_state, h.offset("PoolA") + K.RECORD_SIZE + K.REC_TYPE) == 0x17):
        raise AssertionError(f"authored terminal arrival advanced or allocated a follower: "
                             f"cursor={_state_word(terminal_state, h.offset('LeaderScriptCursor'))} "
                             f"expected={sweep_terminal} child="
                             f"type={_state_word(terminal_state, h.offset('PoolA') + K.RECORD_SIZE + K.REC_TYPE)} "
                             f"live={_state_word(terminal_state, h.offset('EncounterLiveCount'))}")
    cases += 1
    invalid_cursor = _owned_step_call(
        h, arena, profile=0, level_index=5, enemy_type=0x15,
        ordinal=0xFFFF, x=0, y=K.LEADER_END_Y + 32, free=3, direct=True,
    )
    if (_state_word(invalid_cursor, h.offset("LeaderScriptCursor")) != 0xFFFF or
            _state_word(invalid_cursor, h.offset("PoolA") + K.RECORD_SIZE + K.REC_TYPE) == 0x17):
        raise AssertionError("reserved leader ordinal was not a safe terminal")
    cases += 1

    # A v10 loose level retains original leader byte cursors and has no owned
    # leader provider. Loading it after v11 must release the earlier provider.
    legacy_dir = work / "legacy-v10-leader-profile"
    legacy_dir.mkdir()
    legacy = duplicate_original(0, legacy_dir, "authored_leader_profile")
    legacy["version"] = 10
    write_json(legacy_dir / "level.json", legacy)
    validate_directory(legacy_dir)
    _load(h, legacy_dir, 0)
    if h.lib.overkill_level_leaders_current():
        raise AssertionError("version 10 unexpectedly retained an owned leader provider")
    if h.lib.overkill_leader_start(h.offset("LeaderScript15")) != h.offset("LeaderScript15"):
        raise AssertionError("version 10 did not restore original leader byte cursors")
    cases += 1

    # Failed replacement must leave an active v11 provider and identity intact.
    _load(h, directory, 0)
    active_pointer = ctypes.cast(h.lib.overkill_level_leaders_current(), ctypes.c_void_p).value
    malformed = []
    case = copy.deepcopy(document)
    case["leader_paths"]["unknown_leader"] = {}
    malformed.append(("unknown leader", case))
    case = copy.deepcopy(document)
    case["leader_paths"]["bob_chase_leader"] = copy.deepcopy(sources["bob_chase_leader"][2])
    case["leader_paths"]["bob_chase_leader"]["steps"][0]["follower"] = None
    malformed.append(("required bob follower", case))
    case = copy.deepcopy(document)
    case["leader_paths"]["slot_hopper_leader"]["slots"] = [
        {"x": 4, "y": 8}, {"x": 4, "y": 8}
    ]
    malformed.append(("duplicate-only slots", case))
    case = copy.deepcopy(document)
    case["leader_paths"]["sweep_leader"]["steps"][0]["target"]["x"] = True
    malformed.append(("boolean coordinate", case))
    case = copy.deepcopy(document)
    case["leader_paths"]["sweep_leader"]["end"]["kind"] = "restart"
    malformed.append(("unknown ending", case))
    case = copy.deepcopy(document)
    case.pop("leader_paths")
    case["unknown_leader_section"] = {}
    malformed.append(("missing required leader_paths", case))
    for index, (label, invalid) in enumerate(malformed):
        invalid_dir = work / f"invalid-leader-profile-{index}"
        invalid_dir.mkdir()
        # Keep the map valid so rejection exercises the edited schema field,
        # rather than stopping earlier on a missing asset.
        (invalid_dir / "map.bin").write_bytes((directory / "map.bin").read_bytes())
        write_json(invalid_dir / "level.json", invalid)
        try:
            validate_directory(invalid_dir)
        except ValueError:
            pass
        else:
            raise AssertionError(f"Python validator accepted {label}")
        error = ctypes.create_string_buffer(512)
        if h.lib.overkill_level_content_load(
            str(invalid_dir).encode(), str(ROOT / "levels/original").encode(), error, len(error)
        ):
            raise AssertionError(f"native loader accepted {label}")
        if not error.value:
            raise AssertionError(f"native loader omitted a diagnostic for {label}")
        if h.lib.overkill_level_content_id().decode() != "authored_leader_profile":
            raise AssertionError(f"failed load replaced active identity after {label}")
        current = h.lib.overkill_level_leaders_current()
        if ctypes.cast(current, ctypes.c_void_p).value != active_pointer:
            raise AssertionError(f"failed load replaced active provider after {label}")
        cases += 1
    return cases


def run() -> int:
    h = input_harness.HostHarness()
    checkpoints._bind_native(h.lib)
    _bind_api(h.lib)
    arena = checkpoints.Arena(h)
    try:
        with tempfile.TemporaryDirectory(prefix="overkill-leader-content-") as temporary:
            work = Path(temporary)
            documents, sources, directories, view = _canonical_documents(h, arena, work)
            cases = _canonical_execution_cases(h, arena, documents, sources,
                                               directories, view)
            cases += _start_and_death_cases(h, arena, documents, sources,
                                            directories, view)
            _load(h, directories[0], 0)
            cases += _authored_and_compatibility_cases(h, arena, work, sources)
        h.lib.overkill_level_content_unload()
    finally:
        h.check_canaries()
    print(f"PASS owned leader descriptors and ASM execution; {cases} cases")
    return cases


if __name__ == "__main__":
    run()
