"""Native host-clock checks against the bounded original INT 08h handler.

Run ``python tests/host/clock.py`` to build the native core and exercise timer state,
callback order, and nanosecond accumulation. Pass ``--no-build`` to reuse build/host.
"""
from __future__ import annotations

import argparse
import ctypes
import importlib.util
from pathlib import Path
import re
import struct
import sys

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
TESTS = ROOT / "tests"
HOST_DIR = ROOT / "build/host"
HOST_CORE = HOST_DIR / ("OVERKILL_CORE.dll" if sys.platform == "win32"
                        else "liboverkill_core.so")
HOST_IMAGE = HOST_DIR / "HOST_IMAGE.BIN"
HOST_HEADER = HOST_DIR / "HOST_GEN.H"
GAME_HEADER = HOST_DIR / "GAME_GEN.H"
ORACLE_EXE = ROOT / "build/oracle-sym/OVERKILL.EXE"
DOS_MEMORY_BYTES = 0x100000
NS_PER_SECOND = 1_000_000_000
PIT_HZ = 1_193_182
SHIM_SEGMENT = 0xF000
SHIM_LINEAR = SHIM_SEGMENT << 4
SHIM_RETURN_IP = 7

sys.path.insert(0, str(TOOLS))
sys.path.insert(0, str(TESTS))
from emu import LOAD, REG  # noqa: E402
from unicorn import UcError  # noqa: E402


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _macro(path: Path, name: str) -> int:
    text = path.read_text(encoding="ascii")
    match = re.search(
        rf"^\s*#define\s+{re.escape(name)}\s+\(?\s*(0[xX][0-9A-Fa-f]+|[0-9]+)",
        text, re.MULTILINE)
    if match is None:
        raise AssertionError(f"{path} is missing numeric macro {name}")
    return int(match.group(1), 0)


def _bind_signatures(lib) -> None:
    callback = ctypes.CFUNCTYPE(None)
    lib.overkill_bind_real_memory.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_bind_real_memory.restype = ctypes.c_int
    lib.overkill_segment_address.argtypes = (ctypes.c_uint16, ctypes.c_uint16)
    lib.overkill_segment_address.restype = ctypes.c_void_p
    lib.overkill_clock_bind.argtypes = (callback, callback)
    lib.overkill_clock_bind.restype = None
    lib.overkill_clock_reset.argtypes = (ctypes.c_uint64,)
    lib.overkill_clock_reset.restype = None
    lib.overkill_clock_advance.argtypes = (ctypes.c_uint64,)
    lib.overkill_clock_advance.restype = None
    lib.overkill_clock_now_ns.argtypes = ()
    lib.overkill_clock_now_ns.restype = ctypes.c_uint64
    lib.overkill_clock_tick.argtypes = ()
    lib.overkill_clock_tick.restype = None
    lib.overkill_clock_clear_frame_tick.argtypes = ()
    lib.overkill_clock_clear_frame_tick.restype = None
    lib.overkill_clock_frame_ready.argtypes = ()
    lib.overkill_clock_frame_ready.restype = ctypes.c_int


def _byte(h, name: str) -> int:
    return h.state_storage.snapshot()[h.offset(name)]


def _put_byte(h, name: str, value: int) -> None:
    h.write_symbol(name, bytes((value & 0xFF,)))


def _set_native_byte(h, name: str, value: int) -> None:
    ctypes.c_ubyte.from_address(h.state_addr + h.offset(name)).value = value & 0xFF


def _timer_pointer(h, lib, arena_base: int, load_segment: int) -> int:
    frame, offset = h.m.symbols["TIMERTICKCOUNT"]
    pointer = lib.overkill_segment_address(load_segment + frame, offset)
    expected = arena_base + h.m.linear("TimerTickCount")
    if pointer != expected:
        raise AssertionError(
            f"native CS timer address {pointer!r} != loaded image {expected:#x} "
            f"(arena={arena_base:#x}, segment={load_segment + frame:04X}, offset={offset:04X})")
    return int(pointer)


def _invoke_original_irq(machine) -> None:
    """Call the exact handler with a hardware-shaped stack frame and bounded BIOS tail."""
    frame, offset = machine.symbols["INTERRUPT08HANDLER"]
    target_cs = LOAD + frame
    shim = (bytes((0x9C, 0xFA, 0x9A)) + struct.pack("<HH", offset, target_cs) +
            b"\xEB\xFE")
    machine.u.mem_write(SHIM_LINEAR, shim)

    start_sp = machine.stack_top - 0x40
    values = {"AX": 0, "BX": 0, "CX": 0, "DX": 0, "SI": 0,
              "DI": 0, "BP": 0, "ES": machine.data_frame}
    for register, value in values.items():
        machine.u.reg_write(REG[register], value)
    machine.u.reg_write(REG["DS"], machine.data_frame)
    machine.u.reg_write(REG["SS"], machine.data_frame)
    machine.u.reg_write(REG["CS"], SHIM_SEGMENT)
    machine.u.reg_write(REG["IP"], 0)
    machine.u.reg_write(REG["SP"], start_sp)
    machine.u.reg_write(REG["FLAGS"], 0x0202)
    machine.fault = None
    machine.ports = []
    try:
        machine.u.emu_start(SHIM_LINEAR, SHIM_LINEAR + SHIM_RETURN_IP, count=100_000)
    except UcError as error:
        raise AssertionError(f"INT 08h emulation fault: {error}") from error
    if machine.fault:
        raise AssertionError(f"INT 08h raised unexpected {machine.fault}")
    actual = (machine.u.reg_read(REG["CS"]), machine.u.reg_read(REG["IP"]))
    expected = (SHIM_SEGMENT, SHIM_RETURN_IP)
    if actual != expected:
        raise AssertionError(f"INT 08h did not return to its shim: {actual!r}")


def _install_bounded_bios_tail(machine) -> None:
    # Phase values 3, 7, ... chain to the saved BIOS timer vector. An IRET stub
    # consumes the original interrupt frame so no BIOS clock or game loop runs.
    bios_segment, bios_offset = 0xF000, 0x1000
    machine.u.mem_write((bios_segment << 4) + bios_offset, b"\xCF")
    machine.u.mem_write(machine.linear("SavedInt08"),
                        struct.pack("<HH", bios_offset, bios_segment))


def _bind_fixture(h):
    if not HOST_IMAGE.is_file():
        raise FileNotFoundError(f"generated host image is missing: {HOST_IMAGE}")
    if not HOST_HEADER.is_file() or not GAME_HEADER.is_file():
        raise FileNotFoundError("generated host headers are missing; run tools/host.py first")
    image = HOST_IMAGE.read_bytes()
    if len(image) != DOS_MEMORY_BYTES:
        raise AssertionError(f"generated host image must be {DOS_MEMORY_BYTES:#x} bytes")

    arena = (ctypes.c_ubyte * DOS_MEMORY_BYTES).from_buffer_copy(image)
    arena_base = ctypes.addressof(arena)
    load_segment = _macro(HOST_HEADER, "HOST_LOAD_SEGMENT")
    data_segment = _macro(HOST_HEADER, "HOST_DATA_SEGMENT")
    data_linear = _macro(HOST_HEADER, "HOST_DATA_LINEAR")
    if data_linear != data_segment << 4:
        raise AssertionError("HOST_DATA_LINEAR does not match the generated DATA segment")

    callback_type = ctypes.CFUNCTYPE(None)
    events: list[tuple[str, int]] = []
    callback_times: list[tuple[str, int]] = []

    def module_callback() -> None:
        phase = ctypes.c_ubyte.from_address(h.state_addr + h.offset("SfxTickPhase")).value
        events.append(("module", phase))
        callback_times.append(("module", int(h.lib.overkill_clock_now_ns())))

    def sfx_callback() -> None:
        phase_address = h.state_addr + h.offset("SfxTickPhase")
        phase = ctypes.c_ubyte.from_address(phase_address).value
        events.append(("sfx", phase))
        callback_times.append(("sfx", int(h.lib.overkill_clock_now_ns())))
        _set_native_byte(h, "SfxTickPhase", (phase + 1) & 3)

    module_tick = callback_type(module_callback)
    sfx_tick = callback_type(sfx_callback)
    if not h.lib.overkill_bind_real_memory(ctypes.c_void_p(arena_base), len(image)):
        raise AssertionError("native clock rejected its complete physical memory arena")
    timer = _timer_pointer(h, h.lib, arena_base, load_segment)
    h.lib.overkill_clock_bind(module_tick, sfx_tick)

    # The exact oracle and native adapter use the same loaded DATA frame. Confirm the
    # generated location agrees with the oracle's DS map before exercising aliases.
    oracle_data_linear = h.m.data_frame << 4
    if data_linear != oracle_data_linear:
        raise AssertionError(
            f"generated DATA frame {data_linear:05X} != oracle {oracle_data_linear:05X}")
    return (arena, arena_base, timer, load_segment, events, callback_times,
            (module_tick, sfx_tick))


def _seed_quiet_sfx(h, phase: int, loaded: int = 0) -> None:
    _put_byte(h, "SoundModuleLoaded", loaded)
    _put_byte(h, "SfxRequest", 0)
    _put_byte(h, "SfxActive", 0)
    _put_byte(h, "SfxTickPhase", phase)


def _phase_and_order_sweep(h, timer: int, events: list[tuple[str, int]]) -> int:
    checks = 0
    for phase in range(256):
        h.reset()
        events.clear()
        _seed_quiet_sfx(h, phase=2)
        _put_byte(h, "TimerTickPhase", phase)
        initial_frame = 0xFE
        ctypes.c_ubyte.from_address(timer).value = initial_frame
        h.m.u.mem_write(h.m.linear("TimerTickCount"), bytes((initial_frame,)))

        h.lib.overkill_clock_tick()
        native_frame = ctypes.c_ubyte.from_address(timer).value
        _invoke_original_irq(h.m)
        h.compare(f"Interrupt08Handler phase {phase:02X}")

        expected_frame = (initial_frame + (1 if phase & 1 == 0 else 0)) & 0xFF
        if native_frame != expected_frame:
            raise AssertionError(
                f"phase {phase:02X}: native frame byte {native_frame:02X}, "
                f"expected {expected_frame:02X}")
        oracle_frame = h.m.u.mem_read(h.m.linear("TimerTickCount"), 1)[0]
        if native_frame != oracle_frame:
            raise AssertionError(
                f"phase {phase:02X}: native timer byte {native_frame:02X}, "
                f"ASM {oracle_frame:02X}")
        if events != [("sfx", 2)]:
            raise AssertionError(f"phase {phase:02X}: unexpected native callback order {events!r}")
        checks += 1
    return checks


def _loaded_module_condition(h, timer: int, events: list[tuple[str, int]]) -> int:
    checks = 0
    for loaded, expected_events in (
            (0, [("sfx", 3)]),
            (1, [("module", 3), ("sfx", 3)]),
            (2, [("sfx", 3)]),
            (0xFF, [("sfx", 3)])):
        h.reset()
        events.clear()
        _seed_quiet_sfx(h, phase=3, loaded=loaded)
        _put_byte(h, "TimerTickPhase", 1)
        ctypes.c_ubyte.from_address(timer).value = 0x39
        h.lib.overkill_clock_tick()
        if events != expected_events:
            raise AssertionError(
                f"SoundModuleLoaded={loaded:02X}: callbacks {events!r}, "
                f"expected {expected_events!r}")
        if _byte(h, "TimerTickPhase") != 2:
            raise AssertionError("native clock did not advance the timer phase after callbacks")
        if _byte(h, "SfxTickPhase") != 0:
            raise AssertionError("SFX callback did not run once after the module condition")
        if ctypes.c_ubyte.from_address(timer).value != 0x39:
            raise AssertionError("odd timer phase incorrectly advanced the frame byte")
        checks += 1
    return checks


def _frame_byte_contract(h, timer: int) -> int:
    checks = 0
    for phase in (0, 2):
        h.reset()
        _seed_quiet_sfx(h, phase=0)
        _put_byte(h, "TimerTickPhase", phase)
        ctypes.c_ubyte.from_address(timer).value = 0xFF
        h.m.u.mem_write(h.m.linear("TimerTickCount"), b"\xFF")
        h.lib.overkill_clock_tick()
        _invoke_original_irq(h.m)
        h.compare(f"Interrupt08Handler frame-byte wrap phase {phase}")
        if ctypes.c_ubyte.from_address(timer).value != 0:
            raise AssertionError(f"even timer phase {phase} did not wrap the frame byte")
        if h.lib.overkill_clock_frame_ready():
            raise AssertionError("wrapped zero frame byte reported a ready frame")
        checks += 1

    ctypes.c_ubyte.from_address(timer).value = 0xA7
    if not h.lib.overkill_clock_frame_ready():
        raise AssertionError("nonzero frame byte did not report a ready frame")
    h.lib.overkill_clock_clear_frame_tick()
    if ctypes.c_ubyte.from_address(timer).value != 0:
        raise AssertionError("clear-frame service did not clear the CS frame byte")
    if h.lib.overkill_clock_frame_ready():
        raise AssertionError("cleared frame byte still reported a ready frame")
    return checks + 3


def _timing_case(h, timer: int, events: list[tuple[str, int]],
                 timestamps: list[int], *, start_phase: int = 0) -> int:
    h.reset()
    events.clear()
    _seed_quiet_sfx(h, phase=start_phase)
    _put_byte(h, "TimerTickPhase", start_phase)
    initial_frame = 0x29
    ctypes.c_ubyte.from_address(timer).value = initial_frame
    first = timestamps[0]
    h.lib.overkill_clock_reset(first)

    previous = first
    remainder = 0
    total_ticks = 0
    checks = 0
    expected_event_history: list[tuple[str, int]] = []
    period = _macro(GAME_HEADER, "TIMER_DIVISOR") * NS_PER_SECOND
    for now in timestamps[1:]:
        before_ticks = total_ticks
        if now < previous:
            remainder = 0
        else:
            remainder += (now - previous) * PIT_HZ
            new_ticks, remainder = divmod(remainder, period)
            total_ticks += new_ticks
        previous = now

        h.lib.overkill_clock_advance(now)
        frame_ticks = sum(
            1 for tick in range(total_ticks)
            if ((start_phase + tick) & 3) in (0, 2))
        expected_phase = (start_phase + total_ticks) & 3
        expected_frame = (initial_frame + frame_ticks) & 0xFF
        expected_sfx_phase = (start_phase + total_ticks) & 3
        actual_timer = ctypes.c_ubyte.from_address(timer).value
        actual_phase = _byte(h, "TimerTickPhase")
        actual_sfx_phase = _byte(h, "SfxTickPhase")
        if (actual_timer, actual_phase, actual_sfx_phase) != (
                expected_frame, expected_phase, expected_sfx_phase):
            raise AssertionError(
                f"clock at {now}: frame/phase/SFX="
                f"{actual_timer:02X}/{actual_phase:02X}/{actual_sfx_phase:02X}, "
                f"expected {expected_frame:02X}/{expected_phase:02X}/"
                f"{expected_sfx_phase:02X} after {total_ticks} ticks")
        expected_events = [("sfx", (start_phase + before_ticks + i) & 3)
                           for i in range(total_ticks - before_ticks)]
        expected_event_history.extend(expected_events)
        if events != expected_event_history:
            raise AssertionError(
                f"clock callback sequence at {now}: {events!r} != "
                f"{expected_event_history!r}")
        if h.lib.overkill_clock_frame_ready() != int(expected_frame != 0):
            raise AssertionError(f"frame-ready latch disagrees at {now}")
        checks += 1
    return checks


def _exact_accumulation_and_backwards_time(h, timer: int,
                                           events: list[tuple[str, int]]) -> int:
    divisor = _macro(GAME_HEADER, "TIMER_DIVISOR")
    period = divisor * NS_PER_SECOND
    first_tick_ns = (period + PIT_HZ - 1) // PIT_HZ
    timestamps = [
        0,
        first_tick_ns - 1,
        first_tick_ns,
        first_tick_ns + 1,
        250_000_003,
        999_999_999,
        1 * NS_PER_SECOND,
        2 * NS_PER_SECOND,
        2 * NS_PER_SECOND + first_tick_ns - 1,
        2 * NS_PER_SECOND + first_tick_ns,
        5 * NS_PER_SECOND + 123_456_789,
        8 * NS_PER_SECOND,
    ]
    checks = _timing_case(h, timer, events, timestamps)

    # The adapter processes long pauses in bounded chunks while retaining the exact
    # fractional PIT numerator across updates of different sizes.
    split_times = [0, 17, 17_000_019, 1_000_000_017, 3_000_000_011,
                   3_000_000_012, 9_876_543_210]
    checks += _timing_case(h, timer, events, split_times)

    # A backward monotonic-clock correction resets fractional time without advancing
    # the game phase or frame latch. The next threshold is measured from the new origin.
    h.reset()
    events.clear()
    _seed_quiet_sfx(h, phase=0)
    _put_byte(h, "TimerTickPhase", 0)
    ctypes.c_ubyte.from_address(timer).value = 0x29
    start = 5 * NS_PER_SECOND
    h.lib.overkill_clock_reset(start)
    h.lib.overkill_clock_advance(start + first_tick_ns - 1)
    if events or _byte(h, "TimerTickPhase") != 0:
        raise AssertionError("clock advanced before its first exact PIT threshold")
    h.lib.overkill_clock_advance(2 * NS_PER_SECOND)
    if events or _byte(h, "TimerTickPhase") != 0:
        raise AssertionError("backward time created a timer tick")
    h.lib.overkill_clock_advance(2 * NS_PER_SECOND + first_tick_ns - 1)
    if events or _byte(h, "TimerTickPhase") != 0:
        raise AssertionError("backward-time reset retained an old fractional remainder")
    h.lib.overkill_clock_advance(2 * NS_PER_SECOND + first_tick_ns)
    if len(events) != 1 or _byte(h, "TimerTickPhase") != 1:
        raise AssertionError("timer did not tick at the exact threshold after backward reset")
    if ctypes.c_ubyte.from_address(timer).value != 0x2A:
        raise AssertionError("backward-time recovery advanced the wrong number of frame ticks")
    checks += 4
    return checks


def _expected_deadlines(origin: int, tick_count: int, period: int) -> list[int]:
    return [origin + (tick * period + PIT_HZ - 1) // PIT_HZ
            for tick in range(1, tick_count + 1)]


def _timestamp_run(h, timer: int, events: list[tuple[str, int]],
                   callback_times: list[tuple[str, int]], origin: int,
                   updates: list[int]) -> tuple[list[int], int]:
    h.reset()
    events.clear()
    callback_times.clear()
    _seed_quiet_sfx(h, phase=0)
    _put_byte(h, "TimerTickPhase", 0)
    ctypes.c_ubyte.from_address(timer).value = 0
    h.lib.overkill_clock_reset(origin)
    if int(h.lib.overkill_clock_now_ns()) != origin:
        raise AssertionError("clock reset did not publish its new time origin")

    for now in updates:
        h.lib.overkill_clock_advance(now)
        if int(h.lib.overkill_clock_now_ns()) != now:
            raise AssertionError(f"clock getter after advance returned the wrong poll time at {now}")

    if len(callback_times) != len(events) or any(kind != "sfx" for kind, _ in callback_times):
        raise AssertionError("disabled module produced a timestamped module callback")
    return [stamp for _kind, stamp in callback_times], int(h.lib.overkill_clock_now_ns())


def _timestamp_deadlines_and_no_drift(h, timer: int,
                                      events: list[tuple[str, int]],
                                      callback_times: list[tuple[str, int]]) -> int:
    period = _macro(GAME_HEADER, "TIMER_DIVISOR") * NS_PER_SECOND
    origin = 12_345_678_901_234
    duration = 60 * NS_PER_SECOND

    # A single 200 ms update delivers fourteen PIT ticks at their distinct ideal
    # nanosecond deadlines; the public clock getter returns the poll's actual time.
    short_updates = [origin + 200_000_000]
    short_stamps, short_now = _timestamp_run(
        h, timer, events, callback_times, origin, short_updates)
    short_ticks = 200_000_000 * PIT_HZ // period
    expected_short = _expected_deadlines(origin, short_ticks, period)
    if short_ticks != 14 or short_stamps != expected_short:
        raise AssertionError(
            f"200 ms update produced {len(short_stamps)} deadlines; expected "
            f"{short_ticks} distinct exact timestamps")
    if len(set(short_stamps)) != len(short_stamps):
        raise AssertionError("multiple PIT ticks received the same callback timestamp")
    if short_now != origin + 200_000_000:
        raise AssertionError("clock getter did not report the end of the 200 ms poll")

    # Deliver the same 60-second interval as one pause and as uneven monotonic polls.
    # Every callback deadline must be identical, with no per-tick rounding drift.
    long_updates = [origin + duration]
    single_stamps, single_now = _timestamp_run(
        h, timer, events, callback_times, origin, long_updates)

    steps = (17_000_003, 43_210_987, 123_456_789, 1_000_000_019,
             777_777_777, 2_345_678_901, 5_000_000_033)
    split_updates = []
    relative = 0
    step_index = 0
    while relative < duration:
        relative += min(steps[step_index % len(steps)], duration - relative)
        split_updates.append(origin + relative)
        step_index += 1
    split_stamps, split_now = _timestamp_run(
        h, timer, events, callback_times, origin, split_updates)

    long_ticks = duration * PIT_HZ // period
    expected_long = _expected_deadlines(origin, long_ticks, period)
    if single_stamps != expected_long:
        mismatch = next((i for i, (got, want) in enumerate(zip(single_stamps, expected_long))
                         if got != want), min(len(single_stamps), len(expected_long)))
        raise AssertionError(
            f"single long advance deadline #{mismatch + 1} differs from exact PIT time")
    if split_stamps != expected_long or split_stamps != single_stamps:
        mismatch = next((i for i, (got, want) in enumerate(zip(split_stamps, expected_long))
                         if got != want), min(len(split_stamps), len(expected_long)))
        raise AssertionError(
            f"split advance deadline #{mismatch + 1} differs from the single-advance timeline")
    if single_now != origin + duration or split_now != origin + duration:
        raise AssertionError("clock getter did not report the final poll time")

    # Resetting to a new epoch publishes the origin immediately and discards all old
    # fractional PIT progress. The next callback uses the new origin exactly.
    reset_origin = origin + 9 * duration + 987_654_321
    h.reset()
    events.clear()
    callback_times.clear()
    _seed_quiet_sfx(h, phase=0)
    _put_byte(h, "TimerTickPhase", 0)
    ctypes.c_ubyte.from_address(timer).value = 0
    h.lib.overkill_clock_reset(origin)
    h.lib.overkill_clock_advance(origin + ((period - 1) // PIT_HZ))
    if callback_times:
        raise AssertionError("clock ticked before the first exact PIT deadline")
    h.lib.overkill_clock_reset(reset_origin)
    if int(h.lib.overkill_clock_now_ns()) != reset_origin:
        raise AssertionError("reset did not replace the reported time origin")
    h.lib.overkill_clock_advance(reset_origin + ((period + PIT_HZ - 1) // PIT_HZ) - 1)
    if callback_times:
        raise AssertionError("clock retained fractional time from its previous origin")
    h.lib.overkill_clock_advance(reset_origin + ((period + PIT_HZ - 1) // PIT_HZ))
    reset_stamps = [stamp for _kind, stamp in callback_times]
    expected_reset = [reset_origin + (period + PIT_HZ - 1) // PIT_HZ]
    if reset_stamps != expected_reset:
        raise AssertionError(
            f"reset-origin callback time {reset_stamps!r} != {expected_reset!r}")
    if int(h.lib.overkill_clock_now_ns()) != expected_reset[0]:
        raise AssertionError("clock getter after reset-origin tick is incorrect")

    return len(short_updates) + len(long_updates) + len(split_updates) + 6


def run(no_build: bool = False) -> int:
    if no_build:
        required = (HOST_CORE, HOST_IMAGE, HOST_HEADER, GAME_HEADER, ORACLE_EXE)
        missing = [path for path in required if not path.is_file()]
        if missing:
            raise FileNotFoundError("--no-build missing: " + ", ".join(map(str, missing)))
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    harness_module = _load_module("host_input_harness_clock", ROOT / "tests/host/input.py")
    h = harness_module.HostHarness()
    _bind_signatures(h.lib)
    (arena, arena_base, timer, load_segment, events, callback_times,
     callbacks) = _bind_fixture(h)
    _install_bounded_bios_tail(h.m)

    phase_sweep = _phase_and_order_sweep(h, timer, events)
    loaded_cases = _loaded_module_condition(h, timer, events)
    frame_cases = _frame_byte_contract(h, timer)
    timing_cases = _exact_accumulation_and_backwards_time(h, timer, events)
    timestamp_cases = _timestamp_deadlines_and_no_drift(
        h, timer, events, callback_times)

    # Retain storage and callbacks for the lifetime of the bound C pointers.
    _ = (arena, arena_base, load_segment, callbacks)
    total = phase_sweep + loaded_cases + frame_cases + timing_cases + timestamp_cases
    print(f"PASS host clock: {phase_sweep} bounded IRQ phase cases, {loaded_cases} "
          f"module callback cases, {frame_cases} frame-byte cases, "
          f"{timing_cases} elapsed-time cases, {timestamp_cases} timestamp checks "
          f"({total} checks)")
    return total


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="reuse the current core, generated image, and oracle")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
