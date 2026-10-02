"""Bounded native-vs-ASM checks for player, frame, weapon, and life leaves.

The suite calls only original single routines through the oracle harness. It does not
enter UpdatePlayerFrame, UpdateAllRecords, map scrolling, or a gameplay loop. Renderer-
dependent cases are intentionally left to tests/host/rendering.py.

Run ``python tests/host/player_frame.py`` to build the host core and run the checks, or
pass ``--no-build`` to reuse the generated host artifacts.
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
HOST_IMAGE = HOST_DIR / "HOST_IMAGE.BIN"
ORACLE_EXE = ROOT / "build/oracle-sym/OVERKILL.EXE"
DOS_MEMORY_BYTES = 0x100000
STATE_BYTES = 0x10000
NO_RECORD = 0xFFFF

sys.path.insert(0, str(TOOLS))
from world import K  # noqa: E402
from emu import LOAD, REG  # noqa: E402


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


class MainArena:
    """The CS-resident MAIN objects used by host C, alongside borrowed DS state."""

    def __init__(self, h) -> None:
        if not HOST_IMAGE.is_file():
            raise FileNotFoundError(f"generated host image is missing: {HOST_IMAGE}")
        image = HOST_IMAGE.read_bytes()
        if len(image) != DOS_MEMORY_BYTES:
            raise AssertionError(f"HOST_IMAGE.BIN must be {DOS_MEMORY_BYTES:#x} bytes")
        self.image = image
        self.storage = (ctypes.c_ubyte * DOS_MEMORY_BYTES).from_buffer_copy(image)
        self.base = ctypes.addressof(self.storage)
        h.lib.overkill_bind_real_memory.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
        h.lib.overkill_bind_real_memory.restype = ctypes.c_int
        if not h.lib.overkill_bind_real_memory(self.base, DOS_MEMORY_BYTES):
            raise AssertionError("native core rejected its 1 MiB physical-memory arena")

        # These are the only mutable CS objects touched by this suite. Restore the
        # oracle's initial bytes between cases, then let a case explicitly set inputs.
        self.oracle_cs = {
            name: bytes(h.m.u.mem_read(h.m.linear(name), 2))
            for name in ("VideoAdapter", "SaveBufferCursor")
        }
        self.oracle = h

    def reset(self) -> None:
        ctypes.memmove(self.base, self.image, DOS_MEMORY_BYTES)
        for name, data in self.oracle_cs.items():
            self.oracle.m.u.mem_write(self.oracle.m.linear(name), data)

    def sync_oracle_symbol(self, name: str, size: int = 2) -> None:
        address = self.oracle.m.linear(name)
        data = bytes(self.oracle.m.u.mem_read(address, size))
        ctypes.memmove(self.base + address, data, size)

    def compare_symbol(self, name: str, size: int = 2) -> None:
        address = self.oracle.m.linear(name)
        got = ctypes.string_at(self.base + address, size)
        expected = bytes(self.oracle.m.u.mem_read(address, size))
        if got != expected:
            raise AssertionError(
                f"CS:{name}: native={got.hex()} ASM={expected.hex()}")


def _bind_signatures(lib) -> None:
    pointer = ctypes.c_void_p
    word = ctypes.c_uint16
    for name in (
        "init_position_history", "apply_position_history_to_records",
        "advance_position_history_if_requested", "pickup_fuel", "reset_invader_formation",
        "init_stars", "move_stars",
    ):
        fn = getattr(lib, name)
        fn.argtypes = ()
        fn.restype = None

    for name in ("store_position_history", "update_exhaust", "fire_single_shot",
                 "fire_heavy_shot", "update_beam"):
        fn = getattr(lib, name)
        fn.argtypes = (pointer,)
        fn.restype = None

    lib.steer_input_to_waypoint.argtypes = (pointer,)
    lib.steer_input_to_waypoint.restype = None
    lib.place_at_player_offset.argtypes = (pointer, pointer)
    lib.place_at_player_offset.restype = None
    lib.step_hatch_ramp_frame.argtypes = (pointer, word)
    lib.step_hatch_ramp_frame.restype = None
    lib.place_shot_at_muzzle.argtypes = (pointer, pointer)
    lib.place_shot_at_muzzle.restype = None
    lib.copy_position_plus10.argtypes = (pointer, pointer)
    lib.copy_position_plus10.restype = None
    lib.find_missile_target.argtypes = ()
    lib.find_missile_target.restype = pointer
    lib.reset_records_for_life.argtypes = ()
    lib.reset_records_for_life.restype = None


def _ptr(h, offset: int) -> ctypes.c_void_p:
    if not 0 <= offset < STATE_BYTES:
        raise ValueError(f"DS offset outside 64 KiB: {offset:04X}")
    return ctypes.c_void_p(h.state_addr + offset)


def _begin(h, arena: MainArena) -> None:
    h.reset()
    arena.reset()


def _put8(h, name: str, value: int) -> None:
    h.write_symbol(name, bytes((value & 0xFF,)))


def _put16(h, name: str, value: int) -> None:
    h.write_symbol(name, struct.pack("<H", value & 0xFFFF))


def _record(h, offset: int, **fields: int) -> None:
    names = {
        "status": K.REC_STATUS, "y": K.REC_Y, "x": K.REC_X,
        "direction": K.REC_DIRECTION, "sprite": K.REC_SPRITE,
        "draw_pass": K.REC_DRAW_PASS, "size_class": K.REC_SIZE_CLASS,
        "kind": K.REC_KIND, "type": K.REC_TYPE,
        "step_error": K.REC_STEP_ERROR, "flash_timer": K.REC_FLASH_TIMER,
        "save_buffer": K.REC_SAVE_BUFFER,
    }
    for name, value in fields.items():
        try:
            field = names[name]
        except KeyError as exc:
            raise ValueError(f"unknown record field {name}") from exc
        h.write(offset + field, struct.pack("<H", value & 0xFFFF))


def _run_void(h, arena: MainArena, native_name: str, oracle_name: str,
              label: str, *, registers: dict[str, int] | None = None,
              arguments: tuple = (), cs_outputs: tuple[str, ...] = ()) -> None:
    h.m.call(oracle_name, registers or {})
    getattr(h.lib, native_name)(*arguments)
    h.compare(label)
    h.check_canaries()
    for symbol in cs_outputs:
        arena.compare_symbol(symbol)


def _call_far(machine, name: str, registers: dict[str, int] | None = None,
              limit: int = 5_000_000) -> dict[str, int]:
    """Enter one retf routine with its real two-word return frame.

    Machine.call is intentionally a near-call helper; MoveStars belongs to FAR0F7F and
    returns with RETF, so it must receive both the sentinel IP and CS words.
    """
    from unicorn import UC_HOOK_CODE, UcError

    seg, off = machine.symbols[name.upper()]
    cs = LOAD + seg
    sentinel_ip = 0xFFFE
    sentinel = cs * 16 + sentinel_ip
    sp = machine.stack_top - 0x40 - 4
    machine.set_word(sp, sentinel_ip)
    machine.set_word(sp + 2, cs)
    values = dict(AX=0, BX=0, CX=0, DX=0, SI=0, DI=0, BP=0, ES=machine.data_frame)
    values.update(registers or {})
    for register, value in values.items():
        machine.u.reg_write(REG[register], value & 0xFFFF)
    for register in ("DS", "SS"):
        machine.u.reg_write(REG[register], machine.data_frame)
    machine.u.reg_write(REG["CS"], cs)
    machine.u.reg_write(REG["SP"], sp)
    machine.u.reg_write(REG["FLAGS"], 0x0202)
    machine.fault = None
    machine.ports = []
    returned = False

    def stop_at_far_sentinel(u, _address, _size, _):
        nonlocal returned
        if (u.reg_read(REG["CS"]) == cs and
                u.reg_read(REG["IP"]) == sentinel_ip and
                u.reg_read(REG["SP"]) == sp + 4):
            returned = True
            u.emu_stop()

    hook = machine.u.hook_add(UC_HOOK_CODE, stop_at_far_sentinel, None,
                              sentinel, sentinel)
    try:
        machine.u.emu_start(cs * 16 + off, 0, count=limit)
    except UcError as exc:
        raise AssertionError(
            f"{name}: CPU fault {exc} at "
            f"{machine.u.reg_read(REG['CS']):04X}:{machine.u.reg_read(REG['IP']):04X}") from exc
    finally:
        machine.u.hook_del(hook)
    if machine.fault:
        raise AssertionError(f"{name}: {machine.fault}")
    if not returned:
        raise AssertionError(f"{name}: far routine did not return within {limit} instructions")
    return {register: machine.u.reg_read(REG[register])
            for register in ("AX", "BX", "CX", "DX", "SI", "DI", "BP", "ES",
                             "SP", "DS", "SS", "FLAGS")}


def _init_history_cases(h, arena: MainArena) -> int:
    count = 0
    for y, x in ((0, 0), (0xFFF8, 0xFFF7), (0xFFFF, 0xFFFF),
                 (0x7FFF, 0x8000), (0x0100, 0xFFFC)):
        _begin(h, arena)
        _record(h, h.offset("PrimaryRecord"), y=y, x=x)
        _run_void(h, arena, "init_position_history", "InitPositionHistory",
                  f"InitPositionHistory Y/X={y:04X}/{x:04X}")
        count += 1

    write_at = h.offset("HistoryPairs") + 0x2C * 4
    values = (0, 1, 0x7FFF, 0x8000, 0xFFF8, 0xFFFF)
    for i, (y, x) in enumerate(zip(values, reversed(values))):
        _begin(h, arena)
        _record(h, h.offset("PrimaryRecord"), y=0x5555, x=0xAAAA)
        _record(h, h.offset("PoolA"), y=y, x=x)
        _put16(h, "HistoryWriteCursor", write_at)
        _run_void(h, arena, "store_position_history", "StorePositionHistory",
                  f"StorePositionHistory edge {i}",
                  registers={"BP": h.offset("PoolA")},
                  arguments=(_ptr(h, h.offset("PoolA")),))
        count += 1

    # The production ring wraps at HistoryEnd, while the raw word cursor arithmetic is
    # also checked at FFFFh to expose any host promotion/truncation drift safely.
    for trigger, cursor in ((0, h.offset("HistoryEnd") - 4),
                            (1, h.offset("HistoryEnd") - 4),
                            (0, 0xFFFE), (0, 0xFFFF)):
        _begin(h, arena)
        _put8(h, "InputBits", trigger)
        _put16(h, "XAdjustPathTaken", 0xFFFF if trigger == 0 else 0)
        for name in ("HistoryWriteCursor", "HistoryReadCursor15",
                     "HistoryReadCursor31", "HistoryCursor47"):
            _put16(h, name, cursor)
        _run_void(h, arena, "advance_position_history_if_requested",
                  "AdvancePositionHistoryIfRequested",
                  f"AdvancePositionHistoryIfRequested trigger={trigger:02X} cursor={cursor:04X}")
        count += 1

    for index, (near_empty, far_empty) in enumerate(
            ((True, True), (False, True), (True, False), (False, False), (False, False))):
        _begin(h, arena)
        pool = h.offset("PoolA")
        near = pool + 4 * K.RECORD_SIZE
        far = pool + 9 * K.RECORD_SIZE
        h.write_symbol("HistoryPairs", struct.pack("<4H", 0xFFFF, 0xFFF8, 0x8000, 0x0001))
        h.write(h.offset("HistoryPairs") + 0x80, struct.pack("<4H", 0x0100, 0x7FFF, 0xFFFF, 0xFFFF))
        _put16(h, "HistoryReadCursor15", h.offset("HistoryPairs"))
        _put16(h, "HistoryReadCursor31", h.offset("HistoryPairs") + 0x80)
        _put16(h, "TrailingPodNear", NO_RECORD if near_empty else near)
        _put16(h, "TrailingPodFar", NO_RECORD if far_empty else (near if index == 4 else far))
        if not near_empty:
            _record(h, near, y=0xAAAA, x=0x5555)
        if not far_empty and index != 4:
            _record(h, far, y=0xCCCC, x=0x3333)
        _run_void(h, arena, "apply_position_history_to_records",
                  "ApplyPositionHistoryToRecords", f"ApplyPositionHistory aliases #{index}")
        count += 1
    return count


def _pickup_and_steering_cases(h, arena: MainArena) -> int:
    count = 0
    primary = h.offset("PrimaryRecord")
    for fuel, active, sprite, demo, sfx in (
            (0x57, 0, 0, 0, 1), (0x58, 0, 0, 0, 1), (0x59, 1, 0, 0, 1),
            (0xFFFF, 2, 2, 1, 1), (0, 0, 3, 0, 1), (0, 0, 0xFFFF, 2, 0)):
        _begin(h, arena)
        _put16(h, "Fuel", fuel)
        _put16(h, "RefuelActive", active)
        _put16(h, "DemoActive", demo)
        _put8(h, "SfxEnabled", sfx)
        _put8(h, "SfxRequest", 0xA5)
        _record(h, primary, sprite=sprite)
        _run_void(h, arena, "pickup_fuel", "PickupFuel",
                  f"PickupFuel fuel/active/sprite={fuel:04X}/{active:04X}/{sprite:04X}")
        count += 1

    waypoint = h.offset("AutopilotWaypointA")
    for py, px, ty, tx, initial in (
            (0, 0, 0, 0, 0xA5), (0, 0xFFFF, 0xFFFF, 0, 0),
            (0xFFFF, 0, 0, 0xFFFF, 0xFF), (0x8000, 0x7FFF, 0x7FFF, 0x8000, 0x55),
            (0x0100, 0xFFFE, 0x00FF, 0xFFFF, 0xAA)):
        _begin(h, arena)
        _record(h, primary, y=py, x=px)
        _put8(h, "InputBits", initial)
        h.write(waypoint, struct.pack("<2H", ty, tx))
        _run_void(h, arena, "steer_input_to_waypoint", "SteerInputToWaypoint",
                  f"SteerInputToWaypoint {py:04X}/{px:04X}->{ty:04X}/{tx:04X}",
                  registers={"SI": waypoint}, arguments=(_ptr(h, waypoint),))
        count += 1

    return count


def _placement_and_exhaust_cases(h, arena: MainArena) -> int:
    count = 0
    primary = h.offset("PrimaryRecord")
    exhaust = h.offset("PoolA")
    table = h.offset("ExhaustOffsets")
    for sprite, y, x in ((0, 0xFFFF, 0xFFFC), (1, 0x8000, 0x7FFF),
                         (2, 0xFFF8, 0x0001), (0x4000, 0x0100, 0xFFFF)):
        _begin(h, arena)
        _record(h, primary, y=y, x=x, sprite=sprite)
        _record(h, exhaust, y=0xAAAA, x=0x5555)
        _run_void(h, arena, "place_at_player_offset", "PlaceAtPlayerOffset",
                  f"PlaceAtPlayerOffset sprite={sprite:04X}",
                  registers={"BP": exhaust, "DX": table},
                  arguments=(_ptr(h, exhaust), _ptr(h, table)))
        count += 1

    # sprite=1 makes (FFFC + sprite*4) wrap to DS:0000; the subsequent word loads
    # remain within the mapped state window, so this exercises the 16-bit offset math
    # without intentionally reading outside the borrowed segment.
    _begin(h, arena)
    _record(h, primary, y=0xFFF8, x=0xFFFF, sprite=1)
    _record(h, exhaust, y=0xAAAA, x=0x5555)
    h.write(0xFFFC, struct.pack("<2H", 9, 0x8001))
    _run_void(h, arena, "place_at_player_offset", "PlaceAtPlayerOffset",
              "PlaceAtPlayerOffset word-offset wrap", registers={"BP": exhaust, "DX": 0xFFFC},
              arguments=(_ptr(h, exhaust), _ptr(h, 0xFFFC)))
    count += 1

    for primary_sprite in (0, 1, 2, 3, 0xFFFF):
        for phase, slow in ((0, 0), (1, 7), (2, 0x0100), (2, 0x0107), (3, 3)):
            _begin(h, arena)
            _record(h, primary, y=0xFFF8, x=0xFFFE, sprite=primary_sprite)
            _record(h, exhaust, status=1, sprite=0xAAAA, y=0x5555, x=0xCCCC)
            _put16(h, "LevelEndPhase", phase)
            _put16(h, "SlowCount8", slow)
            _run_void(h, arena, "update_exhaust", "UpdateExhaust",
                      f"UpdateExhaust ship={primary_sprite:04X} phase={phase} slow={slow:04X}",
                      registers={"BP": exhaust}, arguments=(_ptr(h, exhaust),))
            count += 1
    return count


def _frame_cases(h, arena: MainArena) -> int:
    count = 0
    # InitStars consumes VideoAdapter from MAIN CS and mutates only the original DS
    # star table and (for Tandy) the dimming counter/masks.
    star_data = bytearray(40 * 6)
    for i in range(40):
        struct.pack_into("<3H", star_data, i * 6,
                         (0xBF + i) & 0xFFFF, (0x0101 + i * 29) & 0xFFFF,
                         (0x5555 ^ i) & 0xFFFF)
    for adapter, bright in ((K.VIDEO_CGA, 0), (K.VIDEO_EGA, 0),
                            (K.VIDEO_TANDY, 0), (K.VIDEO_TANDY, 1),
                            (K.VIDEO_TANDY, 40), (K.VIDEO_TANDY, 0xFFFF)):
        _begin(h, arena)
        h.write_symbol("Stars", bytes(star_data))
        _put16(h, "StarBrightCount", bright)
        h.m.poke("VideoAdapter", adapter)
        arena.sync_oracle_symbol("VideoAdapter")
        _run_void(h, arena, "init_stars", "InitStars",
                  f"InitStars adapter={adapter} bright={bright:04X}")
        count += 1

    reset_at = h.offset("InvaderFormation")
    for cursor, left, drop in ((0, 0, 0), (0xFFFF, 0xFFFF, 0xFFFF),
                               (reset_at - 4, 0x100, 0x8000)):
        _begin(h, arena)
        _put16(h, "InvaderSlotCursor", cursor)
        _put16(h, "InvaderNextMarchLeft", left)
        _put16(h, "InvaderNextDropStep", drop)
        _run_void(h, arena, "reset_invader_formation", "ResetInvaderFormation",
                  "ResetInvaderFormation")
        count += 1

    stars = bytearray(40 * 6)
    ys = (0, 0xBE, 0xBF, 0xFFFF, 0x00C0, 0x7FFF)
    for i in range(40):
        struct.pack_into("<3H", stars, i * 6, ys[i % len(ys)], (i * 19) & 0xFFFF, i)
    for energy, ticks in ((0, (0, 0, 0)), (3, (0, 0, 0)), (0xFFFF, (0, 0, 0)),
                          (1, (1, 0, 0)), (1, (0xFFFF, 0xFFFF, 0xFFFF)),
                          (1, (1, 1, 1)), (1, (0, 1, 0)), (1, (0, 0, 1))):
        _begin(h, arena)
        h.write_symbol("Stars", bytes(stars))
        _put16(h, "EnergyTanks", energy)
        for name, value in zip(("StarLayerTick1", "StarLayerTick2", "StarLayerTick3"), ticks):
            _put16(h, name, value)
        _call_far(h.m, "MoveStars")
        h.lib.move_stars()
        h.compare(f"MoveStars tanks={energy:04X} ticks={ticks}")
        h.check_canaries()
        count += 1

    ramp_record = h.offset("PoolA")
    for divider in (0, 1, 0xFFFF):
        for direction in (0, 1, 0x17, 0x18, 0xFF, 0x100, 0x0117, 0xFFFE, 0xFFFF):
            for base in (0, 0x7FFF, 0xFFFF):
                _begin(h, arena)
                _record(h, ramp_record, direction=direction, sprite=0xAAAA)
                _put16(h, "FrameDivider4", divider)
                _run_void(h, arena, "step_hatch_ramp_frame", "StepHatchRampFrame",
                          f"StepHatchRampFrame div={divider:04X} dir={direction:04X} base={base:04X}",
                          registers={"BP": ramp_record, "CX": base},
                          arguments=(_ptr(h, ramp_record), base))
                count += 1
    return count


def _weapon_cases(h, arena: MainArena) -> int:
    count = 0
    primary = h.offset("PrimaryRecord")
    shot = h.offset("PoolB")
    # Growth inspects the record offset stored in the previous-tail list entry.
    # A C8h tail permits one append; another X permits the second append.
    for tail_x in (0xC8, 0xB8):
        _begin(h, arena)
        h.write_symbol("PoolB", bytes(K.POOL_B_COUNT * K.RECORD_SIZE))
        _record(h, primary, y=0xA0, x=0x58, sprite=0)
        _record(h, shot, status=1, kind=K.KIND_TYPED, type=9, x=0x10, y=0x80, sprite=0x6A)
        _record(h, shot + K.RECORD_SIZE, status=1, kind=K.KIND_TYPED, type=9,
                x=tail_x, y=0x80, sprite=0x6C)
        beam = h.offset("BeamList")
        h.write(beam, b"\xff" * (h.offset("BeamListTerminator") + 2 - beam))
        h.write(beam, struct.pack("<2H", shot, shot + K.RECORD_SIZE))
        _put16(h, "BeamListEnd", beam + 4)
        _put16(h, "PoolBCursor", shot + 2 * K.RECORD_SIZE)
        _put16(h, "ShotsLiveType9", 2)
        _put16(h, "FrameParity", 1)
        _put8(h, "SfxEnabled", 0)
        _run_void(h, arena, "update_beam", "UpdateBeam",
                  f"UpdateBeam growth previous tail X={tail_x:04X}",
                  registers={"BP": primary}, arguments=(_ptr(h, primary),))
        count += 1
    for y, x, sprite, sfx, native_name, oracle_name in (
            (0xFFFF, 0xFFFC, 0, 0, "fire_single_shot", "FireSingleShot"),
            (0xFFF8, 0x8001, 1, 1, "fire_single_shot", "FireSingleShot"),
            (0x7FFF, 0xFFFF, 2, 1, "fire_heavy_shot", "FireHeavyShot"),
            (0x0001, 0xFFFE, 0xFFFF, 0, "fire_heavy_shot", "FireHeavyShot")):
        _begin(h, arena)
        h.write_symbol("PoolB", bytes(K.POOL_B_COUNT * K.RECORD_SIZE))
        _put16(h, "PoolBCursor", shot)
        _put8(h, "SfxEnabled", sfx)
        _put8(h, "SfxRequest", 0xA5)
        _record(h, primary, y=y, x=x, sprite=sprite)
        _run_void(h, arena, native_name, oracle_name,
                  f"{oracle_name} Y/X/sprite={y:04X}/{x:04X}/{sprite:04X}",
                  registers={"BP": primary}, arguments=(_ptr(h, primary),))
        count += 1

    for ship_sprite in (0, 1, 2, 0x4000, 0xFFFF):
        _begin(h, arena)
        _record(h, primary, y=0xFFFF, x=0xFFF8, sprite=ship_sprite)
        _record(h, shot, y=0xAAAA, x=0x5555)
        _run_void(h, arena, "place_shot_at_muzzle", "PlaceShotAtMuzzle",
                  f"PlaceShotAtMuzzle sprite={ship_sprite:04X}",
                  registers={"BP": primary, "BX": shot},
                  arguments=(_ptr(h, shot), _ptr(h, primary)))
        count += 1

    source, dest = h.offset("PoolA"), h.offset("PoolA") + K.RECORD_SIZE
    for y, x in ((0, 0), (0xFFFF, 0xFFF8), (0x7FFF, 0x8000), (0xFFFE, 0xFFFF)):
        _begin(h, arena)
        _record(h, source, y=y, x=x)
        _record(h, dest, y=0xAAAA, x=0x5555)
        _run_void(h, arena, "copy_position_plus10", "CopyRecordPositionPlus10",
                  f"CopyRecordPositionPlus10 {y:04X}/{x:04X}",
                  registers={"BP": source, "BX": dest},
                  arguments=(_ptr(h, dest), _ptr(h, source)))
        count += 1

    pool = h.offset("PoolA")
    pool_image = bytearray(K.POOL_A_COUNT * K.RECORD_SIZE)
    fixtures = (
        (pool, (1, 2, 0, K.KIND_ENEMY)),
        (pool + K.RECORD_SIZE, (1, 3, 0xE1, K.KIND_ENEMY)),
        (pool + 2 * K.RECORD_SIZE, (1, 0x21, 0x20, K.KIND_ENEMY)),
        (pool + 3 * K.RECORD_SIZE, (1, 0x14, 0xE0, K.KIND_ENEMY)),
    )
    for start in (pool, pool + 2 * K.RECORD_SIZE, h.offset("PoolAEnd"), 0xFFFF):
        _begin(h, arena)
        h.write_symbol("PoolA", bytes(pool_image))
        for offset, (status, typ, y, kind) in fixtures:
            _record(h, offset, status=status, type=typ, y=y, kind=kind)
        _put16(h, "TargetSearchCursor", start)
        oracle = h.m.call("FindMissileTarget")
        native = h.lib.find_missile_target()
        native_pointer = 0 if native is None else int(native)
        if h.state_addr <= native_pointer < h.state_addr + STATE_BYTES:
            native_result = native_pointer - h.state_addr
        elif native_pointer == NO_RECORD:
            native_result = NO_RECORD
        else:
            raise AssertionError(f"FindMissileTarget returned unmapped pointer {native_pointer:#x}")
        if native_result != oracle["BX"]:
            raise AssertionError(
                f"FindMissileTarget cursor={start:04X}: native={native_result:04X}, "
                f"ASM BX={oracle['BX']:04X}")
        h.compare(f"FindMissileTarget cursor={start:04X}")
        count += 1
    return count


def _life_cases(h, arena: MainArena) -> int:
    count = 0
    for i in range(3):
        _begin(h, arena)
        # Keep one pool-A slot available for the exhaust claim after the reset. The
        # record states otherwise vary so the pod-preservation path is observable.
        pool = h.offset("PoolA")
        for slot in range(K.POOL_A_COUNT):
            _record(h, pool + slot * K.RECORD_SIZE,
                    status=1, kind=K.KIND_POD if slot == i else K.KIND_ENEMY,
                    type=0x40 + slot, direction=slot, sprite=slot,
                    save_buffer=0xA000 + slot, step_error=0x100 + slot,
                    flash_timer=0x200 + slot, draw_pass=0)
        _put16(h, "PoolACursor", pool + K.RECORD_SIZE * (i + 1))
        _put16(h, "Fuel", (0, 0x58, 0xFFFF)[i])
        _put16(h, "RefuelActive", 0)
        _put16(h, "DemoActive", i)
        _put8(h, "SfxEnabled", i & 1)
        _put8(h, "SfxRequest", 0xCC)
        # A dedicated pool slot after the cursor must be free for the unchecked exhaust
        # allocation. ResetRecordsForLife keeps PoolACursor unchanged.
        free_at = pool + K.RECORD_SIZE * (i + 1)
        _record(h, free_at, status=0, kind=K.KIND_ENEMY, type=0x55)
        h.m.call("ResetRecordsForLife")
        h.lib.reset_records_for_life()
        h.compare(f"ResetRecordsForLife case {i}")
        arena.compare_symbol("SaveBufferCursor")
        count += 1
    return count


def run(no_build: bool = False) -> int:
    if no_build:
        required = (HOST_CORE, HOST_IMAGE, ORACLE_EXE)
        missing = [path for path in required if not path.is_file()]
        if missing:
            raise FileNotFoundError("--no-build missing: " + ", ".join(map(str, missing)))
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    harness = _load_module("host_input_harness_player_frame", ROOT / "tests/host/input.py")
    h = harness.HostHarness()
    _bind_signatures(h.lib)
    arena = MainArena(h)
    started = time.perf_counter()
    checks = 0
    checks += _init_history_cases(h, arena)
    checks += _pickup_and_steering_cases(h, arena)
    checks += _placement_and_exhaust_cases(h, arena)
    checks += _frame_cases(h, arena)
    checks += _weapon_cases(h, arena)
    checks += _life_cases(h, arena)
    h.check_canaries()
    elapsed = time.perf_counter() - started
    print(f"PASS host player/frame/weapons/life: {checks} bounded native-vs-ASM checks "
          f"in {elapsed:.1f}s")
    return checks


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="reuse build/host and build/oracle-sym artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
