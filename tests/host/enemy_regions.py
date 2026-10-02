"""Native enemy, path, flyer, firer, and patrol leaves against the DOS oracle.

Run ``python tests/host/enemy_regions.py`` to build and compare the native core, or
pass ``--no-build`` to reuse ``build/host``. Each fixture calls one original ASM
entry and its native C counterpart against the same borrowed DS image.
"""
from __future__ import annotations

import argparse
import ctypes
import importlib.util
from pathlib import Path
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


def _bind_signatures(h) -> None:
    pointer = ctypes.c_void_p
    word = ctypes.c_uint16
    for name in (
            "fly_along_aim_line",
            "update_path_follower", "enter_sweeper_slot", "enter_march_slot",
            "type18_sweep_path_looper",
            "type29_emerge_then_dart", "type3e_drop_then_dash",
            "type7b_drop_then_aim", "animated_aim_line_flyer",
            "hover_fire_plunge", "type32_descend_then_bounce",
            "type84_lurk_until_aligned", "type5b_scroll_then_rise",
            "type5c_rise_fast4"):
        fn = getattr(h.lib, name)
        fn.argtypes = (pointer,)
        fn.restype = None
    h.lib.run_level_end_sequence.argtypes = ()
    h.lib.run_level_end_sequence.restype = None
    h.lib.demo_step_spawn_path_enemy51.argtypes = (pointer,)
    h.lib.demo_step_spawn_path_enemy51.restype = None
    h.lib.demo_step_launch_front_pod.argtypes = ()
    h.lib.demo_step_launch_front_pod.restype = pointer
    for name in ("spawn_throttled_child", "spawn_shot_down"):
        fn = getattr(h.lib, name)
        fn.argtypes = (pointer, word)
        fn.restype = word
    for name in ("animated_fire_burst", "jitter_fall_shooter",
                 "patrol_shoot_down32"):
        fn = getattr(h.lib, name)
        fn.argtypes = (pointer, word)
        fn.restype = None


FIELD_OFFSETS = {
    "status": K.REC_STATUS,
    "y": K.REC_Y,
    "x": K.REC_X,
    "direction": K.REC_DIRECTION,
    "sprite": K.REC_SPRITE,
    "draw_pass": K.REC_DRAW_PASS,
    "size_class": K.REC_SIZE_CLASS,
    "kind": K.REC_KIND,
    "type": K.REC_TYPE,
    "hit_points": K.REC_HIT_POINTS,
    "path": K.REC_PATH,
    "delta_y": K.REC_DELTA_Y,
    "delta_x": K.REC_DELTA_X,
    "saved_x": K.REC_SAVED_X,
    "saved_y": K.REC_SAVED_Y,
    "entry_delay": K.REC_ENTRY_DELAY,
    "step_error": K.REC_STEP_ERROR,
}


def _record(**fields: int) -> bytes:
    values = {
        "status": 1,
        "y": 0x50,
        "x": 0x40,
        "direction": K.DIR_RIGHT,
        "sprite": 0,
        "draw_pass": 0,
        "size_class": 1,
        "kind": K.KIND_ENEMY,
        "type": 0x40,
        "hit_points": 4,
        "path": 0,
        "delta_y": 0,
        "delta_x": 0,
        "saved_x": 0x40,
        "saved_y": 0x50,
        "entry_delay": 0,
    }
    values.update(fields)
    data = bytearray(K.RECORD_SIZE)
    for name, value in values.items():
        try:
            offset = FIELD_OFFSETS[name]
        except KeyError as exc:
            raise ValueError(f"unknown record field: {name}") from exc
        struct.pack_into("<H", data, offset, value & 0xFFFF)
    return bytes(data)


def _word(name: str, value: int, h) -> tuple[int, bytes]:
    return h.offset(name), struct.pack("<H", value & 0xFFFF)


def _byte(name: str, value: int, h) -> tuple[int, bytes]:
    return h.offset(name), bytes((value & 0xFF,))


def _environment(h, actor: int, *, actor_fields: dict[str, int] | None = None,
                 player_fields: dict[str, int] | None = None,
                 words: dict[str, int] | None = None,
                 bytes_: dict[str, int] | None = None) -> list[tuple[int, bytes]]:
    writes = [
        (actor, _record(**(actor_fields or {}))),
        (h.offset("PrimaryRecord"), _record(
            status=1, x=0x80, y=0x40, direction=K.DIR_UP,
            sprite=0, size_class=1, kind=K.KIND_PLAYER, type=0)),
        _word("LevelEndPhase", 1, h),
        _word("LevelIndex", 1, h),
        _word("DifficultySetting", 2, h),
        _word("DemoActive", 0, h),
        _word("FrameCount8", 0, h),
        _word("FrameCount32", 0, h),
        _word("FrameCount64", 0, h),
        _word("RecordTickCounter", 0, h),
        _word("ScrollDeltaY", 0, h),
        _word("PoolBCursor", h.offset("PoolB"), h),
        _byte("ChildSpawnThrottle", 0, h),
        _byte("SfxEnabled", 0, h),
        _byte("SfxRequest", 0x55, h),
    ]
    if player_fields:
        player = {
            "status": 1, "x": 0x80, "y": 0x40, "direction": K.DIR_UP,
            "sprite": 0, "size_class": 1, "kind": K.KIND_PLAYER, "type": 0,
        }
        player.update(player_fields)
        writes.append((h.offset("PrimaryRecord"), _record(**player)))
    for name, value in (words or {}).items():
        writes.append(_word(name, value, h))
    for name, value in (bytes_ or {}).items():
        writes.append(_byte(name, value, h))
    return writes


def _pool_b_statuses(h, free_slots: set[int], cursor: int | None = None
                     ) -> list[tuple[int, bytes]]:
    pool = h.offset("PoolB")
    writes = []
    for index in range(K.POOL_B_COUNT):
        status = 0 if index in free_slots else 1
        writes.append((pool + index * K.RECORD_SIZE + K.REC_STATUS,
                       struct.pack("<H", status)))
    writes.append(_word("PoolBCursor", pool if cursor is None else cursor, h))
    return writes


def _pool_a_full(h) -> list[tuple[int, bytes]]:
    pool = h.offset("PoolA")
    writes = [
        (pool + index * K.RECORD_SIZE + K.REC_STATUS, struct.pack("<H", 1))
        for index in range(K.POOL_A_COUNT)
    ]
    writes.append(_word("PoolACursor", pool, h))
    return writes


def _pointer(h, offset: int) -> ctypes.c_void_p:
    if not 0 <= offset <= STATE_BYTES - K.RECORD_SIZE:
        raise ValueError(f"record pointer is outside borrowed DS: {offset:04X}")
    return ctypes.c_void_p(h.state_addr + offset)


def _write(h, writes: list[tuple[int, bytes]]) -> None:
    for offset, data in writes:
        h.write(offset, data)


def _run_case(h, native_name: str, oracle_name: str, actor: int,
              writes: list[tuple[int, bytes]], label: str, *,
              native_args: tuple[int, ...] = (),
              oracle_regs: dict[str, int] | None = None,
              result_register: str | None = None) -> None:
    h.reset()
    _write(h, writes)
    regs = {"BP": actor}
    regs.update(oracle_regs or {})
    oracle = h.m.call(oracle_name, regs)
    native_result = getattr(h.lib, native_name)(_pointer(h, actor), *native_args)
    if result_register is not None and int(native_result) != oracle[result_register]:
        raise AssertionError(
            f"{label}: native {native_name}={int(native_result):04X}, "
            f"ASM {result_register}={oracle[result_register]:04X}")
    h.compare(label)


def _spawn_cases(h) -> int:
    actor = h.offset("PoolA")
    pool_b = h.offset("PoolB")
    pool_b_end = h.offset("PoolBEnd")
    cases = (
        # Difficulty 0/1 throttle leaves the caller's BX unchanged.
        ("spawn_throttled_child", "SpawnThrottledChild", 0, 0, 0x2345,
         {0}, pool_b, 0xFFFC, 0xFFFC),
        ("spawn_throttled_child", "SpawnThrottledChild", 1, 1, 0x4567,
         {0}, pool_b, 0x40, 0x50),
        # A permitted spawn wraps the parent's coordinates before child initialization.
        ("spawn_throttled_child", "SpawnThrottledChild", 1, 0, 0x6789,
         {0}, pool_b, 0xFFFC, 0xFFFC),
        ("spawn_throttled_child", "SpawnThrottledChild", 2, 0, 0x789A,
         set(), pool_b, 0x40, 0x50),
        # Pool B accepts its one-past cursor and wraps to the first eligible record.
        ("spawn_throttled_child", "SpawnThrottledChild", 2, 0, 0x89AB,
         {0, 5}, pool_b_end, 0x40, 0x50),
        ("spawn_shot_down", "SpawnShotDown", 1, 0, 0x9ABC,
         {3}, pool_b, 0xFFFC, 0x50),
        ("spawn_shot_down", "SpawnShotDown", 2, 0, 0xABCD,
         set(), pool_b, 0x40, 0x50),
    )
    for index, (native_name, oracle_name, difficulty, throttle, incoming,
                free_slots, cursor, x, y) in enumerate(cases):
        writes = _environment(h, actor, actor_fields={
            "type": 0x34, "x": x, "y": y, "direction": K.DIR_LEFT,
        }, words={"DifficultySetting": difficulty})
        writes.append(_byte("ChildSpawnThrottle", throttle, h))
        writes.extend(_pool_b_statuses(h, free_slots, cursor))
        _run_case(h, native_name, oracle_name, actor, writes,
                  f"{oracle_name} state case {index}",
                  native_args=(incoming,), oracle_regs={"BX": incoming},
                  result_register="BX")
    return len(cases)


def _fire_burst_cases(h) -> int:
    actor = h.offset("PoolA")
    cases = (
        ("Type87AnimFireBurstA", 0xDD, 0x5F),
        ("Type87AnimFireBurstA", 0xDD, 0x60),
        ("Type8FAnimFireBurstB", 0xBF, 0x60),
        ("Type8FAnimFireBurstB", 0xBF, 0x5F),
    )
    for oracle_name, base, x in cases:
        writes = _environment(h, actor, actor_fields={"x": x, "type": 0x87},
                              words={"FrameCount64": 24, "DifficultySetting": 1},
                              bytes_={"ChildSpawnThrottle": 1})
        h.reset()
        _write(h, writes)
        h.m.call(oracle_name, {"BP": actor})
        stale_write = 0xE7 if base == 0xDD else 0xC9
        if h.m.word(stale_write) != 0x44:
            raise AssertionError(f"{oracle_name} did not write sprite 44h through stale BX")
        h.lib.animated_fire_burst(_pointer(h, actor), base)
        h.compare(f"{oracle_name} throttled BX write X={x:02X}")
    return len(cases)


def _random_cursor_for_mask(h, mask: int, wanted: int) -> int:
    start = h.offset("CreditRandomWords")
    end = h.offset("CheckpointScriptCursor")
    for cursor in range(start, end, 2):
        h.reset()
        h.write(h.offset("RandomWordCursor"), struct.pack("<H", cursor))
        if h.m.call("NextRandomWord")["BX"] & mask == wanted:
            return cursor
    raise AssertionError(f"the oracle random table has no word matching {mask:#x}={wanted:#x}")


def _type18_stale_bx_case(h) -> int:
    actor = h.offset("PoolA")
    path = h.offset("PoolB")
    random_cursor = _random_cursor_for_mask(h, 7, 2)
    writes = _environment(h, actor, actor_fields={
        "type": 0x18, "x": 0x40, "y": 0x50, "path": path,
    }, words={
        "DifficultySetting": 1,
        "RecordTickCounter": 0,
        "RandomWordCursor": random_cursor,
        "PoolBCursor": h.offset("PoolBEnd"),
    }, bytes_={"ChildSpawnThrottle": 1})
    writes.append((path, struct.pack("<4H", 0x30, 0x40, 0xFFF0, 0x90)))
    h.reset()
    _write(h, writes)
    h.m.call("Type18SweepPathLooper", {"BP": actor})
    if h.m.word(8) != K.DIR_DOWN:
        raise AssertionError("Type18 fixture did not take the stale-BX write through DS:0002")
    h.lib.type18_sweep_path_looper(_pointer(h, actor))
    h.compare("Type18SweepPathLooper stale BX=2")
    if h.m.word(h.offset("PoolA") + K.REC_PATH) != path + 4:
        raise AssertionError("Type18 fixture did not consume its first waypoint")
    return 1


def _type18_path_wrap_case(h) -> int:
    actor = h.offset("PoolA")
    path = h.offset("PoolB")
    random_cursor = _random_cursor_for_mask(h, 7, 2)
    writes = _environment(h, actor, actor_fields={
        "type": 0x18, "x": 0x40, "y": 0x50, "path": 0xFFFE,
    }, words={
        "DifficultySetting": 1,
        "RecordTickCounter": 0,
        "RandomWordCursor": random_cursor,
        "PoolBCursor": h.offset("PoolBEnd"),
    }, bytes_={"ChildSpawnThrottle": 1})
    writes.extend((
        (0xFFFE, struct.pack("<H", NO_RECORD)),
        (0x0000, struct.pack("<H", path)),
        (path, struct.pack("<4H", 0x30, 0x40, 0xFFF0, 0x90)),
        # If native pointer indexing misses DOS's FFFEh-to-0000h wrap, steer to a
        # safe, deliberately non-arriving point so this remains a bounded one-call test.
        (0x5C5C, struct.pack("<2H", 0, 0)),
    ))
    h.reset()
    _write(h, writes)
    h.m.call("Type18SweepPathLooper", {"BP": actor})
    if h.m.word(8) != K.DIR_DOWN:
        raise AssertionError("Type18 wrap fixture missed its stale-BX direction write")
    h.lib.type18_sweep_path_looper(_pointer(h, actor))
    h.compare("Type18 path jump wraps from DS:FFFE to DS:0000")
    return 1


def _path_wrap_cases(h) -> int:
    actor = h.offset("PoolA")

    # The first LODSW starts at FFFEh and its following X word is DS:0000. Advancing
    # past that pair lands at DS:0002, where the second waypoint keeps this call finite.
    writes = _environment(h, actor, actor_fields={
        "type": 0x12, "x": 0x40, "y": 0x50, "path": 0xFFFE,
    }, words={"DemoActive": 1})
    writes.extend((
        (0xFFFE, struct.pack("<H", 0x30)),
        (0x0000, struct.pack("<3H", 0x40, 0xFFF0, 0x90)),
    ))
    _run_case(h, "update_path_follower", "Type12WaypointPathFollower", actor,
              writes, "Type12 path words and cursor wrap at DS:FFFF")

    for native_name, oracle_name, enemy_type in (
            ("enter_sweeper_slot", "Type81SweeperEnterSteer", 0x81),
            ("enter_march_slot", "Type7FMarchEnterSteer", 0x7F)):
        writes = _environment(h, actor, actor_fields={
            "type": enemy_type, "x": 0x40, "y": 0x50,
            "saved_x": 0x40, "saved_y": 0x50, "direction": K.DIR_LEFT,
        })
        _run_case(h, native_name, oracle_name, actor, writes,
                  f"{oracle_name} exact saved-position transition")
    return 3


def _flyer_cases(h) -> int:
    actor = h.offset("PoolA")
    cases = (
        ("type3e_drop_then_dash", "Type3EDropThenAimedDash", 0x9F, 0xA3),
        ("type3e_drop_then_dash", "Type3EDropThenAimedDash", 0xA0, 0xA3),
        ("type29_emerge_then_dart", "Type29EmergeThenDart", 0x50, 0xA3),
    )
    for native_name, oracle_name, y, sprite in cases:
        words = {"FrameCount8": 7}
        player = {"x": 0x90, "y": 0x40, "sprite": 1}
        writes = _environment(h, actor, actor_fields={
            "type": 0x29 if native_name == "type29_emerge_then_dart" else 0x3E,
            "x": 0x40, "y": y, "sprite": sprite,
        }, player_fields=player, words=words)
        _run_case(h, native_name, oracle_name, actor, writes,
                  f"{oracle_name} Y={y:04X} sprite={sprite:04X}")

    writes = _environment(h, actor, actor_fields={
        "type": 0x7B, "x": 0x40, "y": 0x90, "sprite": 0x55,
    }, player_fields={"x": 0xA0, "y": 0x60, "sprite": 0})
    _run_case(h, "type7b_drop_then_aim", "Type7BDropThenAim", actor, writes,
              "Type7BDropThenAim threshold and type transition")

    for oracle_name, sprite_base in (
            ("Type7AAimLineFlyer", 0x20),
            ("Type7CAimLineFlyerAlt", 0x15C)):
        frame = 2
        writes = _environment(h, actor, actor_fields={
            "type": 0x7A, "x": 0x40, "y": 0x50,
            "delta_x": 4, "delta_y": 0,
        }, words={"FrameCount4": frame})
        _run_case(h, "animated_aim_line_flyer", oracle_name, actor, writes,
                  f"{oracle_name} animated sprite and flight",
                  native_args=(sprite_base + frame,))
    return len(cases) + 3


def _aim_line_cases(h) -> int:
    actor = h.offset("PoolA")
    cases = (
        # The signed X bound is checked after a 16-bit underflowing step.
        (0, 0x20, 0xFFFF, 0, 0xFFFF, "left underflow destroys after stepping"),
        # Y wraps as a word while X stays in bounds; inherited step error is retained.
        (0x40, 0xFFFF, 0, 1, 0xFFFE, "downward Y wrap with inherited error"),
        (0x40, 0x50, 5, 3, 0xFFFE, "minor-axis accumulator wraps"),
    )
    for x, y, dx, dy, error, label in cases:
        writes = _environment(h, actor, actor_fields={
            "type": 0x3F, "x": x, "y": y,
            "delta_x": dx, "delta_y": dy, "step_error": error,
        })
        _run_case(h, "fly_along_aim_line", "Type3FFlyAlongAimLine", actor,
                  writes, f"Type60FlyAlongAimLine {label}")
    return len(cases)


def _hover_fire_cases(h) -> int:
    actor = h.offset("PoolA")
    cases = (
        (0x60, 0x7F, {1}, "spawn down at the firing threshold"),
        (0x61, 0, set(), "plunge above the firing threshold"),
    )
    for y, fire_phase, free_slots, label in cases:
        writes = _environment(h, actor, actor_fields={
            "type": 0x2D, "x": 0x40, "y": y, "direction": K.DIR_LEFT,
        }, words={
            "SlowCount4": 3,
            "FrameCount128": fire_phase,
            "DifficultySetting": 2,
        })
        writes.extend(_pool_b_statuses(h, free_slots, h.offset("PoolBEnd")))
        _run_case(h, "hover_fire_plunge", "Type2DHoverFireThenPlunge",
                  actor, writes, f"Type2DHoverFireThenPlunge {label}",
                  native_args=(0x96,))
    return len(cases)


def _jitter_cases(h) -> int:
    actor = h.offset("PoolA")
    writes = _environment(h, actor, actor_fields={
        "type": 0x40, "x": 0xFFFC, "y": 0x90, "direction": K.DIR_LEFT,
    }, words={
        "FrameCount64": 1,
        "FrameCount32": 0x1F,
        "DifficultySetting": 1,
        "RandomWordCursor": h.offset("CreditRandomWords"),
    }, bytes_={"ChildSpawnThrottle": 0, "SfxEnabled": 1})
    writes.extend(_pool_b_statuses(h, {0}, h.offset("PoolBEnd")))
    _run_case(h, "jitter_fall_shooter", "Type40JitterFallShooter", actor,
              writes, "Type40JitterFallShooter fire after jitter and wrap",
              native_args=(0xCF,))
    return 1


def _patrol_cases(h) -> int:
    actor = h.offset("PoolA")
    writes = _environment(h, actor, actor_fields={"type": 0x32, "y": 0x8F})
    _run_case(h, "type32_descend_then_bounce", "Type32DescendThenBounce",
              actor, writes, "Type32DescendThenBounce one pixel before bounce row")

    cases = (
        ("row alignment wraps Y", {"x": 0, "y": 0xFFEC, "direction": K.DIR_RIGHT},
         {"x": 0xFFF8, "y": 0x0003, "sprite": 1}),
        ("column alignment wraps X", {"x": 0, "y": 0xFFF0, "direction": K.DIR_DOWN},
         {"x": 0, "y": 0xFFF4, "sprite": 1}),
    )
    for label, actor_fields, player_fields in cases:
        writes = _environment(h, actor, actor_fields={"type": 0x84, **actor_fields},
                              player_fields=player_fields)
        _run_case(h, "type84_lurk_until_aligned", "Type84LurkUntilAligned",
                  actor, writes, f"Type84LurkUntilAligned {label}")

    for y in (0xB0, 0xB1, 0xFFFF):
        writes = _environment(h, actor, actor_fields={"type": 0x5B, "y": y})
        _run_case(h, "type5b_scroll_then_rise",
                  "Type5BScrollPastY_B0ThenType5C", actor, writes,
                  f"Type5B scroll/rise signed threshold Y={y:04X}")

    writes = _environment(h, actor, actor_fields={"type": 0x5C, "y": 1})
    _run_case(h, "type5c_rise_fast4", "Type5CRiseFast4", actor, writes,
              "Type5CRiseFast4 subtract wraps Y")
    return len(cases) + 5


def _patrol_fire_cases(h) -> int:
    actor = h.offset("PoolA")
    pool_b_end = h.offset("PoolBEnd")
    cases = (
        (0x1E, set(), "no fire before phase"),
        (0x1F, {3}, "down shot at phase with BX-independent sprite"),
    )
    for phase, free_slots, label in cases:
        writes = _environment(h, actor, actor_fields={
            "type": 0x89, "x": 0, "y": 0x50, "direction": K.DIR_LEFT,
        }, words={"FrameCount32": phase})
        # X=0 takes the patrol's boundary turn and avoids an unrelated map probe.
        writes.extend(_pool_b_statuses(h, free_slots, pool_b_end))
        _run_case(h, "patrol_shoot_down32", "PatrolSpriteShootDown32",
                  actor, writes, f"PatrolSpriteShootDown32 {label}",
                  native_args=(0x5A,), oracle_regs={"AX": 0x5A})
    return len(cases)


def _full_pool_wrap_cases(h) -> int:
    actor = h.offset("PoolA")
    primary = h.offset("PrimaryRecord")
    cases = 0

    # Level-end waypoint A arrival allocates the one-off record without checking the
    # exhausted pool result, then redispatches to B before returning.
    waypoint_a = h.offset("AutopilotWaypointA")
    waypoint_b = h.offset("AutopilotWaypointB")
    a_y, a_x = h.m.word(waypoint_a), h.m.word(waypoint_a + 2)
    writes = _environment(h, actor, player_fields={"x": a_x, "y": a_y},
                          words={"LevelEndPhase": 1})
    b_y, b_x = (a_y + 2) & 0xFFFF, (a_x + 2) & 0xFFFF
    writes.append((waypoint_b, struct.pack("<2H", b_y, b_x)))
    writes.extend(_pool_a_full(h))
    h.reset()
    _write(h, writes)
    h.m.call("RunLevelEndSequence")
    h.lib.run_level_end_sequence()
    _compare_fullpool_wrap(h, "RunLevelEndSequence FFFF allocation", status_spill=True)
    cases += 1

    writes = _environment(h, actor)
    writes.extend(_pool_a_full(h))
    h.reset()
    _write(h, writes)
    h.m.call("DemoStepSpawnPathEnemy51", {"BP": primary})
    h.lib.demo_step_spawn_path_enemy51(_pointer(h, primary))
    _compare_fullpool_wrap(h, "DemoStepSpawnPathEnemy51 FFFF allocation")
    cases += 1

    writes = _environment(h, actor)
    writes.extend(_pool_a_full(h))
    h.reset()
    _write(h, writes)
    oracle = h.m.call("DemoStepLaunchFrontPod")
    native_result = h.lib.demo_step_launch_front_pod()
    if int(native_result) != h.state_addr + NO_RECORD or oracle["BP"] != NO_RECORD:
        raise AssertionError("DemoStepLaunchFrontPod did not retain its FFFF record result")
    _compare_fullpool_wrap(h, "DemoStepLaunchFrontPod FFFF allocation", status_spill=True)
    cases += 1
    return cases


def _compare_fullpool_wrap(h, label: str, *, status_spill: bool = False) -> None:
    """Compare DS and permit only the expected high byte at DS+10000 from [FFFF]."""
    native = h.state_storage.snapshot()
    oracle = h.m.state()
    if native[:h.stack_lo] != oracle[:h.stack_lo] or native[h.stack_hi:] != oracle[h.stack_hi:]:
        for off, (got, want) in enumerate(zip(native, oracle)):
            if h.stack_lo <= off < h.stack_hi:
                continue
            if got != want:
                owner = next(((name, base) for base, name in reversed(h._state_names)
                              if base <= off), ("<before-first-symbol>", 0))[0]
                raise AssertionError(
                    f"{label}: DS:{off:04X} ({owner}) native={got:02X}, ASM={want:02X}")
        raise AssertionError(f"{label}: DS mismatch")
    before = ctypes.string_at(*h.state_storage.before)
    after = ctypes.string_at(*h.state_storage.after)
    if before != bytes([0xA7]) * len(before):
        raise AssertionError(f"{label}: write before the DS window")
    expected_after = bytes([0x00 if status_spill else 0x5C]) + bytes([0x5C]) * (len(after) - 1)
    if after != expected_after:
        raise AssertionError(f"{label}: unexpected native write beyond the DS window: {after.hex()}")
    # Restore the harness guard after validating the one intentional word straddle so the
    # next fixture can use HostHarness.reset's normal canary check.
    ctypes.memset(h.state_storage.after[0], 0x5C, len(after))


def run(no_build: bool = False) -> int:
    if no_build:
        if not HOST_CORE.is_file() or not HOST_STATE.is_file():
            raise FileNotFoundError("--no-build requires the current build/host core and STATE.BIN")
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    harness = _load_module("host_input_harness_enemy_regions", ROOT / "tests/host/input.py")
    h = harness.HostHarness()
    _bind_signatures(h)
    started = time.perf_counter()
    counts = {
        "spawn BX and child state": _spawn_cases(h),
        "throttled fire burst writes": _fire_burst_cases(h),
        "Type 18 stale BX": _type18_stale_bx_case(h),
        "Type 18 path pointer wrap": _type18_path_wrap_case(h),
        "waypoint DS wrap": _path_wrap_cases(h),
        "flyer state transitions": _flyer_cases(h),
        "aim-line movement and wrap": _aim_line_cases(h),
        "hover and downward fire": _hover_fire_cases(h),
        "jitter and child spawn": _jitter_cases(h),
        "patrol alignment and rise": _patrol_cases(h),
        "patrol down-shot phase": _patrol_fire_cases(h),
        "full-pool wrapped writes": _full_pool_wrap_cases(h),
    }
    h.check_canaries()
    total = sum(counts.values())
    detail = ", ".join(f"{name}: {count}" for name, count in counts.items())
    print(f"PASS host enemy regions: {total} single-entry oracle cases ({detail}) "
          f"in {time.perf_counter() - started:.1f}s")
    return total


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="require and reuse build/host and exact oracle artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
