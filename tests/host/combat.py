"""Native combat leaves against the exact DOS ASM oracle.

Run ``python tests/host/combat.py`` to build and run the checks, or pass
``--no-build`` to reuse ``build/host``. Every case starts from the oracle's 64 KiB DS
image, applies the same fixture to the native window and emulator, then compares the full
state after the native leaf and exact ASM entry have run (excluding stack scratch).
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
SEED = 0x434F4D42
NO_RECORD = 0xFFFF

sys.path.insert(0, str(TOOLS))
from emu import FLAG, LOAD, REG  # noqa: E402
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
    for name in ("init_pickup_record", "clamp_record_x", "explode_record",
                 "release_encounter_member", "destroy_record", "damage_one",
                 "damage_two", "destroy_unless_seg_boss",
                 "smart_bomb_record", "set_sway_sprite", "spawn_eight_way_burst",
                 "descend_burst_tail", "type36_fall_then_burst",
                 "type22_descend_then_burst", "record_near_player_hit_point",
                 "small_record_hits_player", "large_record_hits_player"):
        fn = getattr(h.lib, name)
        fn.argtypes = (pointer,)
        fn.restype = ctypes.c_uint16 if name in (
            "init_pickup_record", "record_near_player_hit_point",
            "small_record_hits_player", "large_record_hits_player") else None
    h.lib.spawn_item_drop.argtypes = ()
    h.lib.spawn_item_drop.restype = None
    h.lib.pods_add_bcd_byte.argtypes = (ctypes.c_uint16, ctypes.c_uint16,
                                        ctypes.c_uint16)
    h.lib.pods_add_bcd_byte.restype = ctypes.c_uint16
    h.lib.add_score_bcd.argtypes = (ctypes.c_uint16,)
    h.lib.add_score_bcd.restype = None


FIELD_OFFSETS = {
    "status": K.REC_STATUS, "y": K.REC_Y, "x": K.REC_X,
    "direction": K.REC_DIRECTION, "sprite": K.REC_SPRITE,
    "draw_pass": K.REC_DRAW_PASS, "size_class": K.REC_SIZE_CLASS,
    "kind": K.REC_KIND, "type": K.REC_TYPE, "prev_type": K.REC_PREV_TYPE,
    "player_shot": K.REC_PLAYER_SHOT, "hit_points": K.REC_HIT_POINTS,
    "anim_counter": K.REC_ANIM_COUNTER, "flash_timer": K.REC_FLASH_TIMER,
    "item_index": K.REC_ITEM_INDEX, "slot_index": K.REC_SLOT_INDEX,
    "target": K.REC_TARGET, "missile_locked": K.REC_MISSILE_LOCKED,
}


def _record(rng: random.Random | None = None, **fields: int) -> bytes:
    """A safe record image; optional random bytes test which fields a leaf owns."""
    if rng is None:
        data = bytearray(K.RECORD_SIZE)
    else:
        data = bytearray(rng.randrange(256) for _ in range(K.RECORD_SIZE))
        # Give unmentioned words valid defaults before applying selected fields.
        for name, value in {
            "status": 1, "y": 0x50, "x": 0x40, "direction": 0, "sprite": 0,
            "draw_pass": 0, "size_class": 1, "kind": K.KIND_ENEMY, "type": 0x14,
            "prev_type": 0, "player_shot": 0, "hit_points": 4, "anim_counter": 0,
            "flash_timer": 0, "item_index": 0, "slot_index": NO_RECORD,
            "target": 0, "missile_locked": 0,
        }.items():
            struct.pack_into("<H", data, FIELD_OFFSETS[name], value)
    for name, value in fields.items():
        try:
            offset = FIELD_OFFSETS[name]
        except KeyError as exc:
            raise ValueError(f"unknown record field: {name}") from exc
        struct.pack_into("<H", data, offset, value & 0xFFFF)
    return bytes(data)


def _pointer(h, offset: int) -> ctypes.c_void_p:
    if not 0 <= offset <= STATE_BYTES - K.RECORD_SIZE:
        raise ValueError(f"record pointer is outside borrowed DS: {offset:04X}")
    return ctypes.c_void_p(h.state_addr + offset)


def _word(name: str, value: int, h) -> tuple[int, bytes]:
    return h.offset(name), struct.pack("<H", value & 0xFFFF)


def _byte(name: str, value: int, h) -> tuple[int, bytes]:
    return h.offset(name), bytes((value & 0xFF,))


def _write(h, writes: list[tuple[int, bytes]]) -> None:
    for offset, data in writes:
        h.write(offset, data)


def _pool_image(h, live: set[int] | None = None) -> bytes:
    live = live or set()
    data = bytearray(K.POOL_A_COUNT * K.RECORD_SIZE)
    for index in live:
        struct.pack_into("<H", data, index * K.RECORD_SIZE + K.REC_STATUS, 1)
    return bytes(data)


def _base_writes(h, *, live: set[int] | None = None, cursor: int | None = None,
                 score: bytes = bytes(4), difficulty: int = 2, level: int = 1,
                 seg_boss: int = 0, sfx: int = 1, scroll: int = 0,
                 encounter: int = 3, drop_x: int = 0x40, drop_y: int = 0x50,
                 drop_kind: int = 2, group_table: bytes = bytes(32)) -> list[tuple[int, bytes]]:
    pool = h.offset("PoolA")
    if cursor is None:
        cursor = pool
    writes = [
        (pool, _pool_image(h, live)),
        _word("PoolACursor", cursor, h),
        _word("DifficultySetting", difficulty, h),
        _word("LevelIndex", level, h),
        _word("SegBossActive", seg_boss, h),
        _word("EncounterLiveCount", encounter, h),
        _word("ScrollDeltaY", scroll, h),
        _word("DropX", drop_x, h), _word("DropY", drop_y, h),
        _word("DropKind", drop_kind, h),
        _word("SwayDirX", 1, h),
        _byte("SfxEnabled", sfx, h), _byte("SfxRequest", 0x55, h),
        _byte("Type93KilledLatch", 0, h),
        _word("FormationSlotCursor", h.offset("FormationSlots"), h),
        (h.offset("GroupTable"), group_table),
        (h.offset("ScoreBcd"), bytes(score)),
    ]
    part_offsets = [pool + i * K.RECORD_SIZE for i in range(4)]
    for name, offset in zip(("SegBossAnchor", "SegBossPart77", "SegBossCore",
                             "SegBossPart79"), part_offsets):
        writes.append(_word(name, offset, h))
    return writes


def _run_pointer(h, native_name: str, oracle_name: str, record_at: int,
                 writes: list[tuple[int, bytes]], label: str,
                 oracle_register: str = "BP", result: str | None = None) -> None:
    h.reset()
    _write(h, writes)
    oracle = h.m.call(oracle_name, {oracle_register: record_at})
    native_value = getattr(h.lib, native_name)(_pointer(h, record_at))
    if result == "CF":
        expected = 1 if oracle["FLAGS"] & FLAG["CF"] else 0
        if int(native_value) != expected:
            raise AssertionError(
                f"{label}: native {native_name}={int(native_value)}, ASM CF={expected}")
    elif result is not None:
        if int(native_value) != oracle[result]:
            raise AssertionError(
                f"{label}: native {native_name}={int(native_value):04X}, "
                f"ASM {result}={oracle[result]:04X}")
    h.compare(label)


def _run_void(h, native_name: str, oracle_name: str,
              writes: list[tuple[int, bytes]], label: str) -> None:
    h.reset()
    _write(h, writes)
    h.m.call(oracle_name)
    getattr(h.lib, native_name)()
    h.compare(label)


def _oracle_until(h, oracle_name: str, registers: dict[str, int], stop_name: str) -> None:
    """Enter an exact ASM leaf and stop immediately before its shared finish tail."""
    from unicorn import UC_HOOK_CODE, UcError

    m = h.m
    seg, offset = m.symbols[oracle_name.upper()]
    cs = LOAD + seg
    stop_at = m.linear(stop_name)
    sp = m.stack_top - 0x40 - 2
    m.set_word(sp, m.sentinel(cs) - cs * 16)
    values = dict(AX=0, BX=0, CX=0, DX=0, SI=0, DI=0, BP=0, ES=m.data_frame)
    values.update(registers)
    for name, value in values.items():
        m.u.reg_write(REG[name], value & 0xFFFF)
    for name in ("DS", "SS"):
        m.u.reg_write(REG[name], m.data_frame)
    m.u.reg_write(REG["CS"], cs)
    m.u.reg_write(REG["SP"], sp)
    m.u.reg_write(REG["FLAGS"], 0x0202)
    m.fault = None
    m.ports = []
    stopped = False

    def before_tail(u, address, _size, _):
        nonlocal stopped
        if address == stop_at:
            stopped = True
            u.emu_stop()

    hook = m.u.hook_add(UC_HOOK_CODE, before_tail, None, stop_at, stop_at)
    try:
        m.u.emu_start(cs * 16 + offset, 0, count=5_000_000)
    except UcError as exc:
        raise AssertionError(
            f"{oracle_name}: CPU fault before {stop_name}: {exc} at "
            f"{m.u.reg_read(REG['CS']):04X}:{m.u.reg_read(REG['IP']):04X}") from exc
    finally:
        m.u.hook_del(hook)
    if m.fault:
        raise AssertionError(f"{oracle_name}: {m.fault} before {stop_name}")
    if not stopped:
        raise AssertionError(f"{oracle_name}: did not reach {stop_name}")


def _run_pointer_until(h, native_name: str, oracle_name: str, record_at: int,
                       writes: list[tuple[int, bytes]], label: str,
                       stop_name: str = "ScrollRecordThenFinish") -> None:
    h.reset()
    _write(h, writes)
    _oracle_until(h, oracle_name, {"BP": record_at}, stop_name)
    getattr(h.lib, native_name)(_pointer(h, record_at))
    h.compare(label)


def _init_pickup_cases(h, rng: random.Random) -> int:
    count = 0
    pool = h.offset("PoolA")
    targets = [h.offset("PrimaryRecord"), pool,
               pool + (K.POOL_A_COUNT - 1) * K.RECORD_SIZE]
    kinds = (0, 1, 2, 3, 4, 0xFF, 0x100, 0x7FFF, 0x8000, 0xFFBA, 0xFFFF)
    for index, kind in enumerate(kinds):
        at = targets[index % len(targets)]
        writes = _base_writes(h) + [
            (at, _record(rng, status=1, item_index=0x2222, sprite=0x3333,
                         kind=0x4444, type=0x5555, size_class=0x6666,
                         anim_counter=0x7777, slot_index=0x8888,
                         flash_timer=0x9999, draw_pass=0xAAAA)),
            _word("DropKind", kind, h),
        ]
        _run_pointer(h, "init_pickup_record", "InitPickupRecord", at,
                     writes, f"InitPickupRecord DropKind={kind:04X}",
                     oracle_register="BX", result="SI")
        count += 1

    for index in range(64):
        at = targets[index % len(targets)]
        kind = rng.randrange(0x10000)
        writes = _base_writes(h) + [(at, _record(rng)), _word("DropKind", kind, h)]
        _run_pointer(h, "init_pickup_record", "InitPickupRecord", at,
                     writes, f"InitPickupRecord seeded #{index}",
                     oracle_register="BX", result="SI")
        count += 1
    # The original loads DropKind once after its first six field writes. An
    # unaligned item-index alias must not cause a second read for the sprite.
    for field in (K.REC_ITEM_INDEX, K.REC_KIND, K.REC_FLASH_TIMER, K.REC_SPRITE):
        at = h.offset('DropKind') + 1 - field
        for kind in (4, 0x1234, 0xFFFF):
            writes = _base_writes(h) + [(at, _record(rng)), _word('DropKind', kind, h)]
            _run_pointer(h, 'init_pickup_record', 'InitPickupRecord', at, writes,
                         f'InitPickupRecord alias field {field} kind {kind:04X}',
                         oracle_register='BX', result='SI')
            count += 1
    return count


def _drop_pool_cases(h, rng: random.Random) -> int:
    count = 0
    pool = h.offset("PoolA")
    edge_values = (0, 1, 0xBF, 0xC0, 0xC1, 0xFFFF, 0x8000, 0x7FFF)
    for free in range(K.POOL_A_COUNT):
        # The allocator starts at PoolACursor, so every case begins on the one free slot.
        live = set(range(K.POOL_A_COUNT)) - {free}
        x = edge_values[free % len(edge_values)]
        y = (0xFFF0 + free * 3) & 0xFFFF
        scroll = (0xFFF0, 0, 1, 2, 0x10)[free % 5]
        writes = _base_writes(h, live=live, cursor=pool + free * K.RECORD_SIZE,
                              drop_x=x, drop_y=y, drop_kind=free % 5,
                              scroll=scroll)
        _run_void(h, "spawn_item_drop", "SpawnItemDrop", writes,
                  f"SpawnItemDrop only free slot {free}")
        count += 1

    # Full-pool searches, including the oracle's unchecked cursor at PoolAEnd.
    for cursor in (pool, pool + K.POOL_A_COUNT * K.RECORD_SIZE,
                   pool + (K.POOL_A_COUNT - 1) * K.RECORD_SIZE):
        writes = _base_writes(h, live=set(range(K.POOL_A_COUNT)), cursor=cursor,
                              drop_x=0xFFFF, drop_y=0xFFFF, scroll=1, drop_kind=4)
        _run_void(h, "spawn_item_drop", "SpawnItemDrop", writes,
                  f"SpawnItemDrop full pool cursor={cursor:04X}")
        count += 1

    # Seeded sparse pools exercise wraparound searches with varied drop arithmetic.
    for index in range(160):
        free_count = rng.choice((0, 1, 1, 2, 5, K.POOL_A_COUNT))
        free_slots = set(rng.sample(range(K.POOL_A_COUNT), free_count))
        live = set(range(K.POOL_A_COUNT)) - free_slots
        cursor_index = rng.randrange(K.POOL_A_COUNT)
        writes = _base_writes(
            h, live=live, cursor=pool + cursor_index * K.RECORD_SIZE,
            drop_x=rng.choice(edge_values + tuple(rng.randrange(0x10000) for _ in range(2))),
            drop_y=rng.randrange(0x10000), scroll=rng.choice((0, 1, 2, 0xFFFF)),
            drop_kind=rng.randrange(0x10000))
        _run_void(h, "spawn_item_drop", "SpawnItemDrop", writes,
                  f"SpawnItemDrop seeded #{index}")
        count += 1
    return count


def _clamp_cases(h, rng: random.Random) -> int:
    count = 0
    pool = h.offset("PoolA")
    values = (0, 1, K.PLAYFIELD_MAX_X - 1, K.PLAYFIELD_MAX_X,
              K.PLAYFIELD_MAX_X + 1, 0x00FF, 0x0100, 0x7FFF,
              0x8000, 0xFF40, 0xFFFF)
    for index, x in enumerate(values):
        at = pool + (index % K.POOL_A_COUNT) * K.RECORD_SIZE
        writes = _base_writes(h) + [(at, _record(rng, x=x, y=rng.randrange(0x10000)))]
        _run_pointer(h, "clamp_record_x", "ClampRecordX", at, writes,
                     f"ClampRecordX x={x:04X}")
        count += 1
    for index in range(96):
        at = pool + rng.randrange(K.POOL_A_COUNT) * K.RECORD_SIZE
        x = rng.randrange(0x10000)
        writes = _base_writes(h) + [(at, _record(rng, x=x))]
        _run_pointer(h, "clamp_record_x", "ClampRecordX", at, writes,
                     f"ClampRecordX seeded #{index}")
        count += 1
    return count


def _explode_cases(h, rng: random.Random) -> int:
    count = 0
    pool = h.offset("PoolA")
    for index in range(48):
        at = pool + (index % K.POOL_A_COUNT) * K.RECORD_SIZE
        rtype = (0x76, 0x77, 0x78, 0x79, 0x14, 1, 0xFFFF)[index % 7]
        sfx = index & 1
        writes = _base_writes(h, sfx=sfx) + [(at, _record(
            rng, status=1, type=rtype, prev_type=rng.randrange(0x10000),
            anim_counter=rng.randrange(0x10000), sprite=rng.randrange(0x10000)))]
        _run_pointer(h, "explode_record", "ExplodeRecordAtBX", at, writes,
                     f"ExplodeRecordAtBX #{index}", oracle_register="BX")
        count += 1
    return count


LEADER_TYPES = (0x13, 0x15, 0x1C, 0x1F, 0x7D, 0x7E)
COUNTED_TYPES = (0x61, 0x62, 0x65, 0x14, 0x16, 0x17, 0x18, 0x7F,
                 0x80, 0x81, 0x1D, 0x1E, 0x20, 0x21, 0x22)


def _leader_drop_cases(h) -> int:
    count = 0
    pool = h.offset("PoolA")
    actor = pool
    other_free = pool + 6 * K.RECORD_SIZE
    for rtype in LEADER_TYPES:
        for mode in ("same freed slot", "other free slot", "full pool"):
            if mode == "same freed slot":
                live = set(range(K.POOL_A_COUNT)) - {0}
                status = 0
                cursor = actor
            elif mode == "other free slot":
                live = set(range(K.POOL_A_COUNT)) - {6}
                status = 1
                cursor = other_free
            else:
                live = set(range(K.POOL_A_COUNT))
                status = 1
                cursor = pool
            writes = _base_writes(h, live=live, cursor=cursor,
                                  drop_x=0xC8, drop_y=0xFFF8, scroll=0x10,
                                  drop_kind=4, sfx=1)
            writes.append((actor, _record(status=status, x=0xC8, y=0xFFF8,
                                          kind=K.KIND_ENEMY, type=rtype,
                                          slot_index=NO_RECORD, size_class=1)))
            _run_pointer(h, "release_encounter_member", "ReleaseEncounterMember",
                         actor, writes, f"ReleaseEncounterMember leader {rtype:02X} {mode}")
            count += 1
    return count


def _release_cases(h, rng: random.Random) -> int:
    count = _leader_drop_cases(h)
    pool = h.offset("PoolA")
    for index, rtype in enumerate(COUNTED_TYPES + (0x93, 1, 0, 0x30, 0x76, 0x77, 0x78, 0x79)):
        actor_index = 4
        at = pool + actor_index * K.RECORD_SIZE
        boss = 1 if rtype in (0x76, 0x77, 0x78, 0x79) else 0
        live = {0, 1, 2, 3, actor_index} if boss else {actor_index}
        writes = _base_writes(h, live=live, seg_boss=boss,
                              encounter=(0, 1, 0xFFFF, rng.randrange(0x10000))[index % 4],
                              sfx=index & 1)
        if boss:
            for i, part_type in enumerate((0x76, 0x77, 0x78, 0x79)):
                part_at = pool + i * K.RECORD_SIZE
                writes.append((part_at, _record(status=1, type=part_type, sprite=0x90 + i,
                                                anim_counter=7 + i, size_class=2)))
            writes.append((at, _record(status=1, kind=K.KIND_ENEMY, type=rtype,
                                       size_class=2, slot_index=NO_RECORD)))
        else:
            writes.append((at, _record(status=1, kind=K.KIND_ENEMY, type=rtype,
                                       size_class=1, slot_index=NO_RECORD)))
        _run_pointer(h, "release_encounter_member", "ReleaseEncounterMember", at,
                     writes, f"ReleaseEncounterMember type={rtype:02X}")
        count += 1

    # Each pointer may identify the part being removed; the other three explode in place.
    for removed in range(4):
        live = {0, 1, 2, 3}
        writes = _base_writes(h, live=live, seg_boss=1, sfx=1)
        for i, rtype in enumerate((0x76, 0x77, 0x78, 0x79)):
            at = pool + i * K.RECORD_SIZE
            writes.append((at, _record(status=1, kind=K.KIND_ENEMY, type=rtype,
                                       sprite=0x90 + i, anim_counter=0x12 + i)))
        at = pool + removed * K.RECORD_SIZE
        _run_pointer(h, "release_encounter_member", "ReleaseEncounterMember", at,
                     writes, f"ReleaseEncounterMember boss part {removed}")
        count += 1

    # Seeded ordinary records include unknown types and values around the counter wrap.
    ordinary = COUNTED_TYPES + LEADER_TYPES + (0x93, 1, 0, 0x26, 0x35, 0xFFFF)
    for index in range(96):
        at = pool + 4 * K.RECORD_SIZE
        rtype = rng.choice(ordinary)
        status = rng.choice((0, 1))
        free_index = rng.randrange(7, K.POOL_A_COUNT)
        live = {4} | (set(range(K.POOL_A_COUNT)) - {free_index})
        if not status:
            live.discard(4)
        writes = _base_writes(h, live=live,
                              cursor=pool + free_index * K.RECORD_SIZE,
                              encounter=rng.choice((0, 1, 2, 0xFFFF)),
                              drop_x=rng.randrange(0x10000), drop_y=rng.randrange(0x10000),
                              scroll=rng.choice((0, 1, 2, 0xFFFF)), sfx=rng.randrange(2))
        writes.append((at, _record(status=status, kind=K.KIND_ENEMY, type=rtype,
                                   size_class=1, slot_index=NO_RECORD,
                                   x=rng.randrange(0x10000), y=rng.randrange(0x10000))))
        _run_pointer(h, "release_encounter_member", "ReleaseEncounterMember", at,
                     writes, f"ReleaseEncounterMember seeded #{index}")
        count += 1
    return count


def _destroy_cases(h, rng: random.Random) -> int:
    count = 0
    pool = h.offset("PoolA")
    group_types = (0x14, 0x61, 0x93, 0x13, 0x21, 0x30, 1, 0x76, 0x77, 0x78, 0x79)
    for index in range(192):
        actor_index = 4
        at = pool + actor_index * K.RECORD_SIZE
        rtype = group_types[index % len(group_types)] if index < 88 else rng.choice(group_types)
        size = index % 3 if index < 88 else rng.randrange(3)
        slot = (index // 3) % 16 if index % 4 else NO_RECORD
        group = bytearray(32)
        group_index = 0 if slot == NO_RECORD else slot
        live_before = (1, 2, 0, 0xFF)[index % 4]
        drop_kind = (0, 1, 2, 4, 0xFF)[index % 5]
        if slot != NO_RECORD:
            group[group_index * 2] = live_before
            group[group_index * 2 + 1] = drop_kind
        live = {0, 1, 2, 3, actor_index, 5}
        writes = _base_writes(h, live=live, cursor=pool + 5 * K.RECORD_SIZE,
                              group_table=bytes(group), score=bytes((0x99, 0x99, 0x99, 0x99)),
                              level=4 if rtype == 0x21 and index & 1 else 1,
                              seg_boss=1 if rtype in (0x76, 0x77, 0x78, 0x79) else 0,
                              sfx=index & 1)
        for i, part_type in enumerate((0x76, 0x77, 0x78, 0x79)):
            part_at = pool + i * K.RECORD_SIZE
            writes.append((part_at, _record(status=1, kind=K.KIND_ENEMY,
                                            type=part_type, size_class=2)))
        writes.append((at, _record(status=1, kind=K.KIND_ENEMY, type=rtype,
                                   size_class=size, slot_index=slot,
                                   hit_points=rng.choice((0, 1, 4, 0xFFFF)),
                                   x=rng.choice((0, 0xBF, 0xC0, 0xC1, 0xFFFF, 0x8000)),
                                   y=rng.randrange(0x10000))))
        _run_pointer(h, "destroy_record", "DestroyRecord", at, writes,
                     f"DestroyRecord seeded #{index}")
        count += 1
    # Explicit indestructible type 21h at both levels: level 4 starts its explosion;
    # other levels preserve the live record and its score/group bytes.
    for level in (0, 1, 4, 5):
        for hp in (0, 1):
            at = pool + 4 * K.RECORD_SIZE
            writes = _base_writes(h, live={4, 5}, cursor=pool + 5 * K.RECORD_SIZE,
                                  level=level, score=bytes((0x11, 0x22, 0x33, 0x44)))
            writes.append((at, _record(status=1, kind=K.KIND_ENEMY, type=0x21,
                                       size_class=1, hit_points=hp,
                                       slot_index=NO_RECORD, x=0x80)))
            _run_pointer(h, "destroy_record", "DestroyRecord", at, writes,
                         f"DestroyRecord type21 level={level} hp={hp}")
            count += 1
    return count


def _damage_fixture(h, *, actor_index: int, rtype: int, hp: int, size: int,
                    difficulty: int, level: int, seg_boss: int, slot: int,
                    group_live: int, sfx: int, free_slot: int = 5) -> list[tuple[int, bytes]]:
    pool = h.offset("PoolA")
    group = bytearray(32)
    if slot != NO_RECORD:
        group[slot * 2] = group_live & 0xFF
        group[slot * 2 + 1] = 3
    live = {actor_index}
    if seg_boss:
        live.update((0, 1, 2, 3))
    live.update(set(range(K.POOL_A_COUNT)) - {free_slot})
    actor_at = pool + actor_index * K.RECORD_SIZE
    writes = _base_writes(h, live=live, cursor=pool + free_slot * K.RECORD_SIZE,
                          difficulty=difficulty, level=level, seg_boss=seg_boss,
                          sfx=sfx, encounter=7, group_table=bytes(group),
                          score=bytes((0x99, 0x99, 0x99, 0x99)))
    if seg_boss:
        for i, part_type in enumerate((0x76, 0x77, 0x78, 0x79)):
            part_at = pool + i * K.RECORD_SIZE
            writes.append((part_at, _record(status=1, kind=K.KIND_ENEMY,
                                            type=part_type, size_class=2,
                                            flash_timer=0x1234)))
    writes.append((actor_at, _record(status=1, kind=K.KIND_ENEMY, type=rtype,
                                     hit_points=hp, size_class=size, slot_index=slot,
                                     x=0x40, y=0x50)))
    return writes


def _damage_cases(h, rng: random.Random) -> int:
    count = 0
    actor_index = 4
    actor_at = h.offset("PoolA") + actor_index * K.RECORD_SIZE
    difficulties = (0, 1, 2, 3, 0xFFFF)
    hp_values = (0, 1, 2, 3, 4, 5, 8, 0xFFFF)
    for native_name, oracle_name in (("damage_one", "DamageOne"),
                                     ("damage_two", "DamageTwo")):
        for difficulty in difficulties:
            for hp in hp_values:
                writes = _damage_fixture(h, actor_index=actor_index, rtype=0x14,
                                         hp=hp, size=(hp >> 1) % 3,
                                         difficulty=difficulty, level=1,
                                         seg_boss=0, slot=NO_RECORD,
                                         group_live=0, sfx=difficulty & 1)
                _run_pointer(h, native_name, oracle_name, actor_at, writes,
                             f"{oracle_name} difficulty={difficulty:04X} hp={hp:04X}")
                count += 1

        # Type 21h reaching exactly zero is indestructible outside level 4; a later
        # decrement wraps that zero to FFFFh. At level 4 it starts an ordinary explosion.
        for difficulty in (0, 2):
            for level in (1, 4):
                for hp in (0, 1, 2, 4):
                    writes = _damage_fixture(h, actor_index=actor_index, rtype=0x21,
                                             hp=hp, size=2, difficulty=difficulty,
                                             level=level, seg_boss=0, slot=NO_RECORD,
                                             group_live=0, sfx=1)
                    _run_pointer(h, native_name, oracle_name, actor_at, writes,
                                 f"{oracle_name} type21 level={level} hp={hp:04X}")
                    count += 1

        # Surviving hits exercise flash timers and, with a segmented boss, all four
        # pointer-selected parts plus SFX request 0Eh.
        for index in range(128):
            difficulty = rng.choice(difficulties)
            hp = rng.choice((3, 4, 5, 8, 0xFFFF, rng.randrange(0x10000)))
            boss = index % 3 == 0
            writes = _damage_fixture(
                h, actor_index=actor_index, rtype=rng.choice((0x14, 0x21, 0x61)),
                hp=hp, size=rng.randrange(3), difficulty=difficulty,
                level=rng.choice((1, 4)), seg_boss=int(boss), slot=NO_RECORD,
                group_live=0, sfx=index & 1)
            _run_pointer(h, native_name, oracle_name, actor_at, writes,
                         f"{oracle_name} seeded #{index}")
            count += 1
    return count


def _destroy_unless_boss_cases(h, rng: random.Random) -> int:
    count = 0
    actor_index = 4
    actor_at = h.offset("PoolA") + actor_index * K.RECORD_SIZE
    for active in (0, 1, 2, 0xFFFF):
        for hp in (0, 1, 2, 3, 8, 0xFFFF):
            writes = _damage_fixture(h, actor_index=actor_index, rtype=0x14,
                                     hp=hp, size=1, difficulty=2, level=1,
                                     seg_boss=active, slot=NO_RECORD,
                                     group_live=0, sfx=1)
            # SegBossActive is word-valued; this exact value distinguishes only 1.
            for i, (offset, data) in enumerate(writes):
                if offset == h.offset("SegBossActive"):
                    writes[i] = (offset, struct.pack("<H", active))
                    break
            _run_pointer(h, "destroy_unless_seg_boss", "BeamHit", actor_at,
                         writes, f"DestroyUnlessSegBoss active={active:04X} hp={hp:04X}")
            count += 1
    for index in range(96):
        active = rng.choice((0, 1, 2))
        writes = _damage_fixture(h, actor_index=actor_index, rtype=0x14,
                                 hp=rng.randrange(0x10000), size=rng.randrange(3),
                                 difficulty=rng.randrange(4), level=rng.choice((1, 4)),
                                 seg_boss=active, slot=NO_RECORD, group_live=0,
                                 sfx=rng.randrange(2))
        _run_pointer(h, "destroy_unless_seg_boss", "BeamHit", actor_at, writes,
                     f"DestroyUnlessSegBoss seeded #{index}")
        count += 1
    return count


def _smart_bomb_cases(h, rng: random.Random) -> int:
    count = 0
    pool = h.offset("PoolA")
    actor_index = 4
    at = pool + actor_index * K.RECORD_SIZE
    for y in (0, 1, 0xDF, 0xE0, 0xE1, 0xFFFF):
        for kind in (K.KIND_ENEMY, K.KIND_TYPED, K.KIND_PICKUP, K.KIND_SCENERY):
            for rtype in (0, 1, 0x14, 0x21):
                level = 4 if rtype == 0x21 and (kind + y) & 1 else 1
                live = {actor_index, 5}
                writes = _base_writes(h, live=live, cursor=pool + 5 * K.RECORD_SIZE,
                                      level=level, score=bytes((0x99, 0x99, 0x99, 0x99)))
                writes.append((at, _record(status=1, kind=kind, type=rtype,
                                           size_class=1, hit_points=3, x=0xC1, y=y,
                                           slot_index=NO_RECORD)))
                _run_pointer(h, "smart_bomb_record", "SmartBombRecord", at,
                             writes, f"SmartBombRecord y={y:04X} kind={kind} type={rtype:02X}")
                count += 1
    for index in range(128):
        rtype = rng.choice((0, 1, 0x14, 0x21, 0x93, 0xFFFF))
        y = rng.choice((0xDF, 0xE0, 0xE1, 0xFFFF, rng.randrange(0x10000)))
        kind = rng.choice((K.KIND_ENEMY, K.KIND_TYPED, K.KIND_PICKUP, K.KIND_SCENERY))
        level = 4 if rtype == 0x21 and index & 1 else rng.choice((1, 4))
        writes = _base_writes(h, live={actor_index, 5}, cursor=pool + 5 * K.RECORD_SIZE,
                              level=level, sfx=index & 1,
                              score=bytes((rng.randrange(256) for _ in range(4))))
        writes.append((at, _record(rng, status=1, kind=kind, type=rtype,
                                   size_class=rng.randrange(3), hit_points=rng.randrange(0x10000),
                                   x=rng.randrange(0x10000), y=y, slot_index=NO_RECORD)))
        _run_pointer(h, "smart_bomb_record", "SmartBombRecord", at, writes,
                     f"SmartBombRecord seeded #{index}")
        count += 1
    return count


def _score_cases(h, rng: random.Random) -> int:
    count = 0
    edge_bytes = (0, 1, 9, 0x09, 0x0F, 0x10, 0x19, 0x90, 0x99, 0x9A, 0xFA, 0xFF)
    fixtures: list[tuple[bytes, int, str]] = []
    for i, score_byte in enumerate(edge_bytes):
        score = bytes((score_byte, edge_bytes[(i + 3) % len(edge_bytes)],
                       edge_bytes[(i + 6) % len(edge_bytes)], edge_bytes[(i + 9) % len(edge_bytes)]))
        for points in (0, 1, 0x09, 0x10, 0x19, 0x99, 0x100, 0x9999, 0xFFFF):
            fixtures.append((score, points, f"edges {score.hex()} + {points:04X}"))
    fixtures.extend((bytes((0x99,)) * 4, points, f"top overflow {points:04X}")
                    for points in (1, 0x99, 0x100, 0x9999, 0xFFFF))
    for index in range(256):
        score = bytes(rng.randrange(256) for _ in range(4))
        points = rng.randrange(0x10000)
        fixtures.append((score, points, f"seeded #{index}"))

    add = h.lib.add_score_bcd
    helper = h.lib.pods_add_bcd_byte
    for score, points, name in fixtures:
        h.reset()
        h.write_symbol("ScoreBcd", score)
        h.m.call("AddScoreBcd", {"BX": points})
        # The helper's result carries in bit 8; feeding each byte's carry into the next
        # helper call must reproduce the four score bytes, including the lost top carry.
        carry = 0
        results = []
        for index in range(4):
            addend = (points >> (8 * index)) & 0xFF if index < 2 else 0
            result = int(helper(score[index], addend, carry))
            results.append(result)
            carry = result >> 8
        add(points)
        final_score = h.state_storage.snapshot()[h.offset("ScoreBcd"):h.offset("ScoreBcd") + 4]
        for index, result in enumerate(results):
            if (result & 0xFF) != final_score[index]:
                raise AssertionError(
                    f"pods_add_bcd_byte {name} byte {index}: {result & 0xFF:02X} "
                    f"!= AddScoreBcd byte {final_score[index]:02X}")
        h.compare(f"AddScoreBcd {name}")
        count += 1
    return count


def _pool_b_image(rng: random.Random, free_slots: set[int]) -> bytes:
    """Pool B records retain old bytes when a burst claims a slot."""
    data = bytearray(rng.randrange(256) for _ in range(K.POOL_B_COUNT * K.RECORD_SIZE))
    for index in range(K.POOL_B_COUNT):
        status = 0 if index in free_slots else 1
        struct.pack_into("<H", data, index * K.RECORD_SIZE + K.REC_STATUS, status)
    return bytes(data)


def _burst_writes(h, rng: random.Random, *, x: int = 0x40, y: int = 0x50,
                  size: int = 1, free_slots: set[int] | None = None,
                  cursor_b: int | None = None, rtype: int = 0x36,
                  slot: int = NO_RECORD, group_live: int = 0,
                  level: int = 1, scroll: int = 0, sway: int = 1,
                  sfx: int = 1) -> list[tuple[int, bytes]]:
    pool_a = h.offset("PoolA")
    pool_b = h.offset("PoolB")
    if free_slots is None:
        free_slots = set(range(K.POOL_B_COUNT))
    if cursor_b is None:
        cursor_b = pool_b
    group = bytearray(32)
    if slot != NO_RECORD:
        group[slot * 2] = group_live & 0xFF
        group[slot * 2 + 1] = 4
    writes = _base_writes(h, live={0}, cursor=pool_a, level=level, scroll=scroll,
                          sfx=sfx, drop_x=x, drop_y=y, drop_kind=2,
                          group_table=bytes(group))
    writes.extend((
        (pool_b, _pool_b_image(rng, free_slots)),
        _word("PoolBCursor", cursor_b, h),
        _word("BurstOriginX", 0x1357, h),
        _word("BurstOriginY", 0x2468, h),
        _word("SwayDirX", sway, h),
        (pool_a, _record(rng, status=1, kind=K.KIND_ENEMY, type=rtype,
                         size_class=size, slot_index=slot, x=x, y=y,
                         hit_points=5, anim_counter=0x1234, sprite=0x5678)),
    ))
    return writes


def _run_burst_spawn(h, rng: random.Random, *, x: int, y: int, size: int,
                     free_slots: set[int], cursor_b: int, label: str) -> None:
    pool_b = h.offset("PoolB")
    end_b = h.offset("PoolBEnd")
    writes = _burst_writes(h, rng, x=x, y=y, size=size, free_slots=free_slots,
                           cursor_b=cursor_b)
    initial_pool = next(data for offset, data in writes if offset == pool_b)
    h.reset()
    _write(h, writes)
    h.m.call("SpawnEightWayBurst", {"BP": h.offset("PoolA")})
    h.lib.spawn_eight_way_burst(_pointer(h, h.offset("PoolA")))
    h.compare(label)

    start = 0 if cursor_b == end_b else (cursor_b - pool_b) // K.RECORD_SIZE
    order = []
    for step in range(K.POOL_B_COUNT):
        index = (start + step) % K.POOL_B_COUNT
        if index in free_slots:
            order.append(index)
            if len(order) == 8:
                break
    post = h.state_storage.snapshot()
    origin = ((x + (0x0C if size == 2 else 4)) & 0xFFFF,
              (y + (0x0C if size == 2 else 4)) & 0xFFFF)
    changed = {K.REC_STATUS, K.REC_DIRECTION, K.REC_SPRITE, K.REC_X, K.REC_Y,
               K.REC_PLAYER_SHOT, K.REC_DRAW_PASS, K.REC_SIZE_CLASS, K.REC_KIND,
               K.REC_TYPE, K.REC_SHOT_TIMER}
    for ordinal, index in enumerate(order):
        at = pool_b + index * K.RECORD_SIZE
        direction = 7 - ordinal
        # Verify each written semantic field; untouched bytes below retain the old slot.
        for offset, value in ((K.REC_STATUS, 1), (K.REC_Y, origin[1]),
                              (K.REC_X, origin[0]), (K.REC_DIRECTION, direction),
                              (K.REC_SPRITE, direction + 8),
                              (K.REC_PLAYER_SHOT, 0), (K.REC_DRAW_PASS, 1),
                              (K.REC_SIZE_CLASS, 0), (K.REC_KIND, K.KIND_TYPED),
                              (K.REC_TYPE, 3), (K.REC_SHOT_TIMER, 0xFFFF)):
            got = struct.unpack_from("<H", post, at + offset)[0]
            if got != value:
                raise AssertionError(
                    f"{label}: PoolB[{index}] field {offset:02X}={got:04X}, expected {value:04X}")
        before = initial_pool[index * K.RECORD_SIZE:(index + 1) * K.RECORD_SIZE]
        after = post[at:at + K.RECORD_SIZE]
        for byte in range(K.RECORD_SIZE):
            if any(field <= byte < field + 2 for field in changed):
                continue
            if before[byte] != after[byte]:
                raise AssertionError(
                    f"{label}: PoolB[{index}] stale byte {byte:02X} changed")


def _sway_sprite_cases(h, rng: random.Random) -> int:
    count = 0
    at = h.offset("PoolA")
    for sway in (0, 1, 0xFFFF, 2, 0x7FFF, 0x8000, 0xFFFE, 0xFFFD):
        writes = _base_writes(h) + [
            (at, _record(rng, sprite=rng.randrange(0x10000))),
            _word("SwayDirX", sway, h),
        ]
        _run_pointer(h, "set_sway_sprite", "SetSwaySprite", at, writes,
                     f"SetSwaySprite SwayDirX={sway:04X}")
        count += 1
    for index in range(24):
        sway = rng.randrange(0x10000)
        writes = _base_writes(h) + [(at, _record(rng)), _word("SwayDirX", sway, h)]
        _run_pointer(h, "set_sway_sprite", "SetSwaySprite", at, writes,
                     f"SetSwaySprite seeded #{index}")
        count += 1
    return count


def _spawn_burst_cases(h, rng: random.Random) -> int:
    count = 0
    pool_b = h.offset("PoolB")
    end_b = h.offset("PoolBEnd")
    cursors = (pool_b, pool_b + (K.POOL_B_COUNT - 1) * K.RECORD_SIZE, end_b)
    for available in range(11):
        for cursor_index, cursor in enumerate(cursors):
            start = 0 if cursor == end_b else (cursor - pool_b) // K.RECORD_SIZE
            free = {(start + i * 5) % K.POOL_B_COUNT for i in range(available)}
            x, y = ((0xFFFF, 0xFFF8), (0xB0, 0x9F), (0xC0, 0xA0))[cursor_index]
            size = (0, 1, 2)[(available + cursor_index) % 3]
            _run_burst_spawn(h, rng, x=x, y=y, size=size, free_slots=free,
                             cursor_b=cursor,
                             label=f"SpawnEightWayBurst available={available} cursor={cursor:04X}")
            count += 1
    for index in range(96):
        available = rng.randrange(K.POOL_B_COUNT + 1)
        free = set(rng.sample(range(K.POOL_B_COUNT), available))
        cursor_index = rng.randrange(K.POOL_B_COUNT)
        cursor = pool_b + cursor_index * K.RECORD_SIZE
        _run_burst_spawn(h, rng, x=rng.randrange(0x10000), y=rng.randrange(0x10000),
                         size=rng.randrange(3), free_slots=free, cursor_b=cursor,
                         label=f"SpawnEightWayBurst seeded #{index}")
        count += 1
    return count


def _descend_burst_cases(h, rng: random.Random) -> int:
    count = 0
    pool_b = h.offset("PoolB")
    for index in range(48):
        available = (0, 1, 8, 9)[index % 4]
        free = set(range(available))
        cursor = (h.offset("PoolBEnd") if index % 3 == 0
                  else pool_b + ((K.POOL_B_COUNT - 1) * K.RECORD_SIZE
                                 if index % 3 == 1 else 0))
        actor = h.offset("PoolA")
        group_slot = index % 16 if index % 2 else NO_RECORD
        group_live = 1 if group_slot != NO_RECORD else 0
        rtype = (0x36, 0x14, 0x21, 0x22)[index % 4]
        level = 4 if rtype == 0x21 and index & 1 else 1
        writes = _burst_writes(
            h, rng, x=(0xBF, 0xC1, 0xFFFF, 0x40)[index % 4],
            y=(0x9F, 0xA0, 0xFFF0, 0x20)[index % 4],
            size=index % 3, free_slots=free, cursor_b=cursor, rtype=rtype,
            slot=group_slot, group_live=group_live, level=level,
            scroll=(0, 1, 2, 0xFFFF)[index % 4], sfx=index & 1)
        _run_pointer_until(h, "descend_burst_tail", "DescendBurstTail", actor, writes,
                           f"DescendBurstTail seeded #{index}")
        count += 1
    return count


def _type_burst_cases(h, rng: random.Random) -> int:
    count = 0
    actor = h.offset("PoolA")
    pool_b = h.offset("PoolB")
    sway_values = (0, 1, 0xFFFF, 0x7FFF)
    y_values = (0x9C, 0x9D, 0x9E, 0x9F, 0xA0, 0xFFFE, 0xFFFF)
    for sway in sway_values:
        for y in y_values:
            for size in (1, 2):
                available = (y + sway + size) % 10
                free = set(range(available))
                cursor = h.offset("PoolBEnd") if sway & 1 else pool_b + (K.POOL_B_COUNT - 1) * K.RECORD_SIZE
                writes = _burst_writes(h, rng, x=(0x40, 0xC1, 0xFFFF)[size % 3],
                                       y=y, size=size, free_slots=free,
                                       cursor_b=cursor, sway=sway)
                _run_pointer_until(h, "type36_fall_then_burst", "Type36FallThenBurst",
                                   actor, writes,
                                   f"Type36FallThenBurst Y={y:04X} sway={sway:04X} size={size}")
                count += 1

    # Type 22h falls by two only on level zero. The exact A0h edge and unsigned wrap
    # separate the two paths; the common scroll tail is stopped before it mutates DS.
    for level in (0, 1, 4, 0xFFFF):
        for sway in (0, 1, 0xFFFF):
            for y in y_values:
                size = ((level + sway + y) & 1) + 1
                available = (level + sway + y) % 10
                free = set(range(available))
                cursor = (pool_b + ((K.POOL_B_COUNT - 1) * K.RECORD_SIZE)
                          if (level + sway) & 1 else h.offset("PoolBEnd"))
                writes = _burst_writes(h, rng, x=0x40, y=y, size=size,
                                       free_slots=free, cursor_b=cursor,
                                       rtype=0x22, level=level, sway=sway)
                _run_pointer_until(h, "type22_descend_then_burst", "Type22DescendThenBurst",
                                   actor, writes,
                                   f"Type22DescendThenBurst level={level:04X} Y={y:04X} sway={sway:04X}")
                count += 1

    for native_name, oracle_name, rtype in (
            ("type36_fall_then_burst", "Type36FallThenBurst", 0x36),
            ("type22_descend_then_burst", "Type22DescendThenBurst", 0x22)):
        for index in range(48):
            level = rng.choice((0, 1, 4, 0xFFFF))
            available = rng.randrange(11)
            free = set(rng.sample(range(K.POOL_B_COUNT), available))
            cursor = (h.offset("PoolBEnd") if index & 1 else
                      pool_b + rng.randrange(K.POOL_B_COUNT) * K.RECORD_SIZE)
            writes = _burst_writes(
                h, rng, x=rng.randrange(0x10000), y=rng.randrange(0x10000),
                size=rng.randrange(3), free_slots=free, cursor_b=cursor,
                rtype=rtype, level=level, sway=rng.randrange(0x10000),
                scroll=rng.choice((0, 1, 2, 0xFFFF)), sfx=index & 1)
            _run_pointer_until(h, native_name, oracle_name, actor, writes,
                               f"{oracle_name} seeded #{index}")
            count += 1
    return count


def _near_point_cases(h, rng: random.Random) -> int:
    count = 0
    pool = h.offset("PoolA")
    bases = ((0x40, 0x50), (0, 0), (0x7FF0, 0x8000), (0xFFF0, 0x0008),
             (0x8000, 0x7FF0))
    deltas = (-17, -16, -15, 0, 15, 16, 17)
    for base_x, base_y in bases:
        for dx in deltas:
            for dy in deltas:
                at = pool
                hit_x, hit_y = base_x & 0xFFFF, base_y & 0xFFFF
                writes = _base_writes(h) + [
                    (at, _record(x=hit_x + dx, y=hit_y + dy)),
                    _word("PlayerHitX", hit_x, h), _word("PlayerHitY", hit_y, h),
                ]
                _run_pointer(h, "record_near_player_hit_point", "RecordNearPlayerHitPoint",
                             at, writes, f"RecordNearPlayerHitPoint dx={dx} dy={dy}",
                             result="CF")
                count += 1
    for index in range(96):
        hit_x, hit_y = rng.randrange(0x10000), rng.randrange(0x10000)
        at = pool
        writes = _base_writes(h) + [
            (at, _record(rng, x=rng.randrange(0x10000), y=rng.randrange(0x10000))),
            _word("PlayerHitX", hit_x, h), _word("PlayerHitY", hit_y, h),
        ]
        _run_pointer(h, "record_near_player_hit_point", "RecordNearPlayerHitPoint",
                     at, writes, f"RecordNearPlayerHitPoint seeded #{index}", result="CF")
        count += 1
    return count


def _small_hit_cases(h, rng: random.Random) -> int:
    count = 0
    pool = h.offset("PoolA")
    ship_at = h.offset("PrimaryRecord")
    offsets = struct.unpack_from("<6H", h.baseline, h.offset("PlayerHitOffsets"))
    deltas = (-17, -16, -15, 0, 15, 16, 17)
    ship_positions = ((0x40, 0x50), (0, 0), (0xB0, 0xC0),
                      (0x7FF0, 0x8000), (0xFFF0, 0xFFF8))
    for form in (0, 1, 2, 3, 4, 0xFFFF):
        for ship_x, ship_y in ship_positions:
            hit_x = (ship_x + offsets[min(form, 2) * 2 + 1]) & 0xFFFF if form < 3 else ship_x
            hit_y = (ship_y + offsets[min(form, 2) * 2]) & 0xFFFF if form < 3 else ship_y
            candidates = deltas if form < 3 else (0,)
            for delta in candidates:
                at = pool
                writes = _base_writes(h) + [
                    (ship_at, _record(status=1, kind=K.KIND_PLAYER, sprite=form,
                                      x=ship_x, y=ship_y, size_class=1)),
                    (at, _record(status=1, kind=K.KIND_ENEMY,
                                 x=(hit_x + delta) & 0xFFFF,
                                 y=(hit_y + delta) & 0xFFFF, size_class=1)),
                ]
                _run_pointer(h, "small_record_hits_player", "SmallRecordHitsPlayer",
                             at, writes,
                             f"SmallRecordHitsPlayer form={form:04X} pos={ship_x:04X},{ship_y:04X} d={delta}",
                             result="CF")
                count += 1
    for index in range(160):
        form = rng.choice((0, 1, 2, 3, 4, 0xFFFF))
        x, y = rng.randrange(0x10000), rng.randrange(0x10000)
        at = pool
        writes = _base_writes(h) + [
            (ship_at, _record(status=1, kind=K.KIND_PLAYER, sprite=form, x=x, y=y)),
            (at, _record(rng, status=1, x=rng.randrange(0x10000),
                         y=rng.randrange(0x10000), size_class=1)),
        ]
        _run_pointer(h, "small_record_hits_player", "SmallRecordHitsPlayer", at, writes,
                     f"SmallRecordHitsPlayer seeded #{index}", result="CF")
        count += 1
    return count


def _large_hit_cases(h, rng: random.Random) -> int:
    count = 0
    pool = h.offset("PoolA")
    ship_at = h.offset("PrimaryRecord")
    forms = (0, 2, 3)
    positions = (0x40, 0x7FF0, 0x8000, 0xFFF0)
    x_deltas = (-0x15, -0x14, -0x13, 0, 0x17, 0x18, 0x19)
    normal_y = x_deltas
    boss_y = (-5, -4, -3, 0, 7, 8, 9)
    for form in forms:
        for active in (0, 1):
            for rx in positions:
                for delta in x_deltas:
                    ry = 0x50
                    player_x = (rx + delta) & 0xFFFF
                    player_y = (ry + (4 if active == 1 else 0)) & 0xFFFF
                    writes = _base_writes(h, seg_boss=active) + [
                        (ship_at, _record(status=1, kind=K.KIND_PLAYER, sprite=form,
                                          x=player_x, y=player_y)),
                        (pool, _record(status=1, kind=K.KIND_ENEMY, size_class=2,
                                       x=rx, y=ry)),
                    ]
                    _run_pointer(h, "large_record_hits_player", "LargeRecordHitsPlayer",
                                 pool, writes,
                                 f"LargeRecordHitsPlayer form={form:04X} active={active} X={rx:04X} d={delta}",
                                 result="CF")
                    count += 1
            for ry in positions:
                for delta in (boss_y if active == 1 else normal_y):
                    rx = 0x40
                    player_x = rx + 4
                    player_y = (ry + delta) & 0xFFFF
                    writes = _base_writes(h, seg_boss=active) + [
                        (ship_at, _record(status=1, kind=K.KIND_PLAYER, sprite=form,
                                          x=player_x, y=player_y)),
                        (pool, _record(status=1, kind=K.KIND_ENEMY, size_class=2,
                                       x=rx, y=ry)),
                    ]
                    _run_pointer(h, "large_record_hits_player", "LargeRecordHitsPlayer",
                                 pool, writes,
                                 f"LargeRecordHitsPlayer form={form:04X} active={active} Y={ry:04X} d={delta}",
                                 result="CF")
                    count += 1
    for index in range(128):
        form = rng.choice(forms)
        active = rng.choice((0, 1, 2, 0xFFFF))
        rx, ry = rng.randrange(0x10000), rng.randrange(0x10000)
        writes = _base_writes(h, seg_boss=active) + [
            (ship_at, _record(rng, status=1, kind=K.KIND_PLAYER, sprite=form,
                              x=rng.randrange(0x10000), y=rng.randrange(0x10000))),
            (pool, _record(rng, status=1, kind=K.KIND_ENEMY, size_class=2,
                           x=rx, y=ry)),
        ]
        _run_pointer(h, "large_record_hits_player", "LargeRecordHitsPlayer", pool, writes,
                     f"LargeRecordHitsPlayer seeded #{index}", result="CF")
        count += 1
    return count


def run(no_build: bool = False) -> int:
    if no_build:
        if not HOST_CORE.is_file() or not HOST_STATE.is_file():
            raise FileNotFoundError("--no-build requires the current build/host core and STATE.BIN")
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    harness = _load_module("host_input_harness_combat", ROOT / "tests/host/input.py")
    h = harness.HostHarness()
    _bind_signatures(h)
    started = time.perf_counter()
    rng = random.Random(SEED)

    counts = {
        "pickup init": _init_pickup_cases(h, rng),
        "item drop": _drop_pool_cases(h, rng),
        "X clamp": _clamp_cases(h, rng),
        "explosion": _explode_cases(h, rng),
        "encounter release": _release_cases(h, rng),
        "destroy": _destroy_cases(h, rng),
        "damage": _damage_cases(h, rng),
        "boss damage": _destroy_unless_boss_cases(h, rng),
        "smart bomb": _smart_bomb_cases(h, rng),
        "BCD score": _score_cases(h, rng),
        "near-point collision": _near_point_cases(h, rng),
        "small collision": _small_hit_cases(h, rng),
        "large collision": _large_hit_cases(h, rng),
        "sway sprite": _sway_sprite_cases(h, rng),
        "eight-way burst": _spawn_burst_cases(h, rng),
        "descend burst tail": _descend_burst_cases(h, rng),
        "falling bursts": _type_burst_cases(h, rng),
    }
    h.check_canaries()
    total = sum(counts.values())
    detail = ", ".join(f"{name}: {value}" for name, value in counts.items())
    print(f"PASS host combat: {total} full-DS oracle cases ({detail}) "
          f"in {time.perf_counter() - started:.1f}s")
    return total


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="require and reuse build/host and build/oracle-sym artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
