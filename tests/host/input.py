"""Native input-policy checks against the exact DOS ASM oracle.

Run ``python tests/host/input.py`` to build the native core if needed and exercise
keyboard, joystick, clear-table, and real SDL event-queue behavior. ``--no-build``
reuses the current host DLL and oracle artifacts (useful while the DOS hybrid builds).

The reusable HostHarness is also importable by the other native region suites. It
borrows one aligned 64 KiB state window and compares the full DS window, excluding
only the oracle's physical stack scratch area.
"""
from __future__ import annotations

import argparse
import ctypes
import importlib.util
import os
from pathlib import Path
import random
import struct
import subprocess
import sys
import time
from types import SimpleNamespace

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
TESTS = ROOT / "tests"
sys.path.insert(0, str(TOOLS))
sys.path.insert(0, str(TESTS))

from common import read_json, sha  # noqa: E402
from emu import Machine, REG  # noqa: E402
from extract import mz  # noqa: E402
from world import K  # noqa: E402

STATE_BYTES = 0x10000
GUARD_BYTES = 16
CANARY_BEFORE = 0xA7
CANARY_AFTER = 0x5C
ORACLE_EXE = ROOT / "build/oracle-sym/OVERKILL.EXE"
HOST_DIR = ROOT / "build/host"
HOST_STATE = HOST_DIR / "STATE.BIN"


class BorrowedState:
    """Aligned ctypes storage with visible guard bytes before and after one DS view."""

    def __init__(self) -> None:
        self.raw = (ctypes.c_ubyte * (STATE_BYTES + 2 * GUARD_BYTES + 2))()
        raw_address = ctypes.addressof(self.raw)
        self.address = (raw_address + GUARD_BYTES + 1) & ~1
        self.before = (self.address - GUARD_BYTES, GUARD_BYTES)
        self.after = (self.address + STATE_BYTES, GUARD_BYTES)
        ctypes.memset(self.before[0], CANARY_BEFORE, self.before[1])
        ctypes.memset(self.after[0], CANARY_AFTER, self.after[1])
        self.view = (ctypes.c_ubyte * STATE_BYTES).from_address(self.address)

    def load(self, data: bytes) -> None:
        if len(data) != STATE_BYTES:
            raise ValueError(f"state must be exactly {STATE_BYTES:#x} bytes")
        ctypes.memmove(self.address, data, STATE_BYTES)

    def snapshot(self) -> bytes:
        return ctypes.string_at(self.address, STATE_BYTES)

    def check_canaries(self) -> None:
        before = ctypes.string_at(*self.before)
        after = ctypes.string_at(*self.after)
        if before != bytes([CANARY_BEFORE]) * GUARD_BYTES:
            raise AssertionError("native input wrote before the borrowed state window")
        if after != bytes([CANARY_AFTER]) * GUARD_BYTES:
            raise AssertionError("native input wrote after the borrowed state window")


def _core_path() -> Path:
    name = "OVERKILL_CORE.dll" if os.name == "nt" else "liboverkill_core.so"
    return HOST_DIR / name


class HostHarness:
    """Shared native-vs-oracle fixture for tests/host region suites."""

    def __init__(self, core_path: Path | None = None) -> None:
        core_path = Path(core_path or _core_path())
        if not ORACLE_EXE.is_file():
            raise FileNotFoundError(f"exact oracle is missing: {ORACLE_EXE}")
        if not core_path.is_file():
            raise FileNotFoundError(f"native core is missing: {core_path}")
        _verify_exact_oracle()

        self._dll_directory = os.add_dll_directory(str(HOST_DIR)) if os.name == "nt" else None
        self.lib = ctypes.CDLL(str(core_path))
        self._set_signatures()
        self.m = Machine(ORACLE_EXE)
        self.baseline = self.m.state()
        if len(self.baseline) != STATE_BYTES:
            raise AssertionError("emulator did not expose a 64 KiB DS window")

        # The native state image and the DOS emulator must begin with the same bytes.
        if HOST_STATE.is_file():
            generated = HOST_STATE.read_bytes()
            if generated != self.baseline:
                raise AssertionError("host STATE.BIN differs from the exact oracle's DS window")

        self.state_storage = BorrowedState()
        self.state = self.state_storage.view
        self.state_addr = self.state_storage.address
        if self.state_addr & 1:
            raise AssertionError("ctypes state window is not word-aligned")
        if not self.lib.overkill_bind_state(self.state_addr, STATE_BYTES):
            raise AssertionError("native core rejected the aligned 64 KiB state window")

        self.stack_lo = self.offset("StackArea")
        self.stack_hi = self.m.stack_top
        self._state_names = sorted(
            (off, name)
            for name, (seg, off) in self.m.symbols.items()
            if seg == self.m.symbols["STACKTOP"][0]
        )
        self.reset()

    def _set_signatures(self) -> None:
        self.lib.overkill_bind_state.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
        self.lib.overkill_bind_state.restype = ctypes.c_int
        for name in ("poll_input_bits", "poll_joystick_input_bits", "clear_key_down_table",
                     "overkill_sdl_pump_input"):
            fn = getattr(self.lib, name)
            fn.argtypes = ()
            fn.restype = ctypes.c_int if name == "overkill_sdl_pump_input" else None
        self.lib.overkill_set_input_sample.argtypes = (
            ctypes.c_uint16, ctypes.c_uint16, ctypes.c_uint8)
        self.lib.overkill_set_input_sample.restype = None
        self.lib.overkill_input_flush_count.argtypes = ()
        self.lib.overkill_input_flush_count.restype = ctypes.c_uint
        self.lib.overkill_sdl_apply_event.argtypes = (ctypes.c_void_p,)
        self.lib.overkill_sdl_apply_event.restype = ctypes.c_int

    def offset(self, name: str) -> int:
        return self.m.offset(name)

    def reset(self) -> None:
        self.m.set_state(self.baseline)
        self.state_storage.load(self.baseline)
        self.m.ports = []
        self.check_canaries()

    def write(self, offset: int, data: bytes) -> None:
        data = bytes(data)
        if not 0 <= offset <= STATE_BYTES or offset + len(data) > STATE_BYTES:
            raise ValueError(f"DS write outside the 64 KiB window: {offset:04X}+{len(data)}")
        self.m.write(offset, data)
        ctypes.memmove(self.state_addr + offset, data, len(data))

    def write_symbol(self, name: str, data: bytes) -> None:
        self.write(self.offset(name), data)

    def check_canaries(self) -> None:
        self.state_storage.check_canaries()

    def compare(self, label: str, *, ignore_stack: bool = True) -> None:
        self.check_canaries()
        native = self.state_storage.snapshot()
        oracle = self.m.state()
        if len(oracle) != STATE_BYTES:
            raise AssertionError(f"{label}: oracle DS window has the wrong size")
        if ignore_stack:
            differs = (native[:self.stack_lo] != oracle[:self.stack_lo] or
                       native[self.stack_hi:] != oracle[self.stack_hi:])
        else:
            differs = native != oracle
        if not differs:
            return
        for off, (got, want) in enumerate(zip(native, oracle)):
            if ignore_stack and self.stack_lo <= off < self.stack_hi:
                continue
            if got != want:
                owner = next(((name, base) for base, name in reversed(self._state_names)
                              if base <= off), ("<before-first-symbol>", 0))[0]
                raise AssertionError(
                    f"{label}: DS:{off:04X} ({owner}) native={got:02X}, ASM={want:02X}")

    def sync_oracle_from_native(self) -> None:
        """Use after an SDL event has changed the borrowed state, before comparing a DOS leaf."""
        self.m.set_state(self.state_storage.snapshot())


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def _verify_exact_oracle() -> None:
    if not ORACLE_EXE.is_file():
        raise FileNotFoundError(f"exact oracle is missing: {ORACLE_EXE}")
    _, image, _, _ = mz(ORACLE_EXE.read_bytes())
    oracle = read_json(ROOT / "metadata/oracle.json")
    if len(image) != oracle["program_bytes"] or sha(image) != oracle["program_sha256"]:
        raise AssertionError("build/oracle-sym is not the source-built exact oracle")


def _build_probe() -> Path:
    """Compile the tiny SDL-header probe; event layout stays owned by SDL's C headers."""
    sys.path.insert(0, str(TOOLS))
    import host as host_build  # pylint: disable=import-outside-toplevel

    compiler = os.environ.get("CC", "gcc")
    flags = host_build.sdl_flags()
    if os.name == "nt":
        flags, _sdk = flags
    output = HOST_DIR / ("input_probe.dll" if os.name == "nt" else "libinput_probe.so")
    output.parent.mkdir(parents=True, exist_ok=True)
    command = [compiler, "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror", "-shared"]
    if os.name != "nt":
        command.append("-fPIC")
    command += [str(ROOT / "tests/host/probe.c"), *flags, "-o", str(output)]
    subprocess.run(command, check=True)
    return output


def _load_probe(path: Path):
    dll_dir = os.add_dll_directory(str(HOST_DIR)) if os.name == "nt" else None
    probe = ctypes.CDLL(str(path))
    probe.host_sdl_init_events.argtypes = ()
    probe.host_sdl_init_events.restype = ctypes.c_int
    probe.host_sdl_quit.argtypes = ()
    probe.host_sdl_quit.restype = None
    probe.host_sdl_flush.argtypes = ()
    probe.host_sdl_flush.restype = None
    probe.host_sdl_push_key.argtypes = (ctypes.c_int, ctypes.c_int, ctypes.c_int)
    probe.host_sdl_push_key.restype = ctypes.c_int
    probe.host_sdl_push_focus_lost.argtypes = ()
    probe.host_sdl_push_focus_lost.restype = ctypes.c_int
    probe.host_sdl_push_quit.argtypes = ()
    probe.host_sdl_push_quit.restype = ctypes.c_int
    probe.host_sdl_key_w.argtypes = ()
    probe.host_sdl_key_w.restype = ctypes.c_int
    probe.host_sdl_key_b.argtypes = ()
    probe.host_sdl_key_b.restype = ctypes.c_int
    probe.host_sdl_key_c.argtypes = ()
    probe.host_sdl_key_c.restype = ctypes.c_int
    probe.host_sdl_key_left_alt.argtypes = ()
    probe.host_sdl_key_left_alt.restype = ctypes.c_int
    probe.host_sdl_key_x.argtypes = ()
    probe.host_sdl_key_x.restype = ctypes.c_int
    probe.host_sdl_key_keypad8.argtypes = ()
    probe.host_sdl_key_keypad8.restype = ctypes.c_int
    probe.host_sdl_key_f13.argtypes = ()
    probe.host_sdl_key_f13.restype = ctypes.c_int
    return probe, dll_dir


def _u8(h: HostHarness, name: str) -> int:
    return h.state_storage.snapshot()[h.offset(name)]


def _u16(h: HostHarness, name: str) -> int:
    return struct.unpack_from("<H", h.state_storage.snapshot(), h.offset(name))[0]


def _assert_state_patch(h: HostHarness, before: bytes, changes: dict[int, bytes], label: str) -> None:
    expected = bytearray(before)
    for offset, data in changes.items():
        expected[offset:offset + len(data)] = data
    actual = h.state_storage.snapshot()
    if actual == expected:
        h.check_canaries()
        return
    mismatch = next(i for i, (got, want) in enumerate(zip(actual, expected)) if got != want)
    raise AssertionError(
        f"{label}: unexpected DS write at {mismatch:04X}; "
        f"native={actual[mismatch]:02X}, expected={expected[mismatch]:02X}")


def _put8(h: HostHarness, name: str, value: int) -> None:
    h.write_symbol(name, bytes((value & 0xFF,)))


def _put16(h: HostHarness, name: str, value: int) -> None:
    h.write_symbol(name, struct.pack("<H", value & 0xFFFF))


def _write_keyboard_fixture(h: HostHarness, mode: int, codes_a: bytes,
                            codes_b: bytes, keys: bytes, old_bits: int = 0xA5) -> None:
    _put16(h, "InputDeviceMode", mode)
    _put8(h, "InputBits", old_bits)
    h.write_symbol("KeyBitScancodesA", codes_a)
    h.write_symbol("KeyBitScancodesB", codes_b)
    h.write_symbol("KeyDownTable", keys)


def _run_keyboard(h: HostHarness, name: str) -> None:
    h.lib.poll_input_bits()
    h.m.call("PollInputBits")
    h.compare(name)


def _keyboard_sweep(h: HostHarness) -> int:
    count = 0
    codes_a = bytes(range(0x60, 0x68))
    codes_b = bytes(range(0x68, 0x70))
    for mode, codes in ((K.INPUT_MODE_KEYS_A, codes_a), (K.INPUT_MODE_KEYS_B, codes_b)):
        for mask in range(256):
            keys = bytearray(K.KEY_DOWN_COUNT)
            for slot, scan in enumerate(codes):
                keys[scan] = (mask >> (7 - slot)) & 1
            h.reset()
            _write_keyboard_fixture(h, mode, codes_a, codes_b, bytes(keys))
            _run_keyboard(h, f"keyboard mode {mode} bits {mask:02X}")
            count += 1

    # All six fixed controls are ORed after the configurable eight-key table.
    fixed = (K.SCAN_TAB, K.SCAN_SPACE, K.SCAN_UP, K.SCAN_DOWN, K.SCAN_LEFT, K.SCAN_RIGHT)
    for mode in (K.INPUT_MODE_KEYS_A, K.INPUT_MODE_KEYS_B):
        for mask in range(64):
            keys = bytearray(K.KEY_DOWN_COUNT)
            for bit, scan in enumerate(fixed):
                if mask & (1 << bit):
                    keys[scan] = K.KEY_STATE_DOWN
            h.reset()
            _write_keyboard_fixture(h, mode, codes_a, codes_b, bytes(keys))
            _run_keyboard(h, f"fixed keys mode {mode} mask {mask:02X}")
            count += 1

    # Configured bindings use only bit 0, whereas fixed controls use any nonzero byte.
    for mode, codes in ((K.INPUT_MODE_KEYS_A, codes_a), (K.INPUT_MODE_KEYS_B, codes_b)):
        for slot, scan in enumerate(codes):
            for value, active in ((0x02, False), (0x80, False), (0x03, True), (0x81, True)):
                keys = bytearray(K.KEY_DOWN_COUNT)
                keys[scan] = value
                h.reset()
                _write_keyboard_fixture(h, mode, codes_a, codes_b, bytes(keys))
                _run_keyboard(h, f"binding mode {mode} slot {slot} byte {value:02X}")
                got = _u8(h, "InputBits")
                expected = (1 << (7 - slot)) if active else 0
                if got != expected:
                    raise AssertionError(f"configured key low-bit case: got {got:02X}, expected {expected:02X}")
                count += 1

    for mode in (K.INPUT_MODE_KEYS_A, K.INPUT_MODE_KEYS_B):
        for scan in (K.SCAN_TAB, K.SCAN_SPACE, K.SCAN_UP, K.SCAN_DOWN, K.SCAN_LEFT, K.SCAN_RIGHT):
            for value in (0x02, 0x80):
                keys = bytearray(K.KEY_DOWN_COUNT)
                keys[scan] = value
                h.reset()
                _write_keyboard_fixture(h, mode, codes_a, codes_b, bytes(keys))
                _run_keyboard(h, f"fixed key mode {mode} scan {scan:02X} byte {value:02X}")
                if _u8(h, "InputBits") == 0:
                    raise AssertionError("fixed key must treat any nonzero state byte as held")
                count += 1

    # Unknown word modes fall back to key table A, not joystick or table B.
    for mode in (0x0003, 0x0100, 0xFFFF):
        keys = bytearray(K.KEY_DOWN_COUNT)
        keys[codes_a[0]] = 1
        h.reset()
        _write_keyboard_fixture(h, mode, codes_a, codes_b, bytes(keys))
        _run_keyboard(h, f"fallback word mode {mode:04X}")
        if _u8(h, "InputBits") != 0x80:
            raise AssertionError(f"word mode {mode:04X} did not use key table A")
        count += 1

    return count


class OracleJoystickHooks:
    """Bound the original port leaves and inline AL read with independent samples."""

    def __init__(self, h: HostHarness) -> None:
        from unicorn import UC_HOOK_CODE
        from input_normalize import button_sample_site

        self.h = h
        self.m = h.m
        self.current = None
        self.error = None
        self.axes_calls = 0
        self.button_calls = 0
        self.axis_values = None

        def return_near(u) -> None:
            sp = u.reg_read(REG["SP"])
            ss = u.reg_read(REG["SS"])
            target = struct.unpack("<H", bytes(u.mem_read(ss * 16 + sp, 2)))[0]
            u.reg_write(REG["IP"], target)
            u.reg_write(REG["SP"], (sp + 2) & 0xFFFF)

        def axes(u, address, size, _):
            if self.current is None:
                self.error = "unexpected axis-service entry"
                return
            index = self.axes_calls
            if index >= 2:
                self.error = "oracle read joystick axes more than twice"
                return
            x, y, decoy_x, decoy_y = self.axis_values
            if index == 0:
                u.reg_write(REG["BX"], x)
                u.reg_write(REG["CX"], decoy_y)
            else:
                u.reg_write(REG["BX"], decoy_x)
                u.reg_write(REG["CX"], y)
            self.axes_calls += 1
            return_near(u)

        kind, button_at = button_sample_site(SimpleNamespace(m=self.m))

        def buttons(u, address, size, _):
            if self.current is None:
                self.error = "unexpected joystick-button read"
                return
            _, port = self.current
            self.button_calls += 1
            self.m.ports.append(("in", K.GAME_PORT))
            if kind == "service":
                u.reg_write(REG["AX"], port)
                return_near(u)
            else:
                ax = u.reg_read(REG["AX"])
                u.reg_write(REG["AX"], (ax & 0xFF00) | port)
                u.reg_write(REG["IP"], (u.reg_read(REG["IP"]) + size) & 0xFFFF)

        axis_at = self.m.linear("ReadGamePortAAxisCounts")
        self.m.u.hook_add(UC_HOOK_CODE, axes, None, axis_at, axis_at)
        self.m.u.hook_add(UC_HOOK_CODE, buttons, None, button_at, button_at)

    def call(self, label: str, x: int, y: int, port: int) -> None:
        self.current = (x, port)
        self.axis_values = (x, y, 0x5CE1, 0xA37C)
        self.axes_calls = 0
        self.button_calls = 0
        self.error = None
        try:
            self.m.call(label)
        finally:
            self.current = None
        if self.error:
            raise AssertionError(self.error)
        if self.axes_calls != 2 or self.button_calls != 1:
            raise AssertionError(
                f"{label}: expected two axis reads and one button sample; "
                f"got {self.axes_calls}/{self.button_calls}")


def _put_joystick_fixture(h: HostHarness, thresholds: tuple[int, int, int, int],
                          held_keys: bytes | None = None) -> None:
    for name, value in zip(("JoyXLowThreshold", "JoyXHighThreshold",
                            "JoyYLowThreshold", "JoyYHighThreshold"), thresholds):
        _put16(h, name, value)
    _put16(h, "JoyButtonSelect", 0xA553)
    _put8(h, "InputBits", 0xFF)
    if held_keys is not None:
        h.write_symbol("KeyDownTable", held_keys)


def _run_joystick(h: HostHarness, hooks: OracleJoystickHooks, *, x: int, y: int,
                  thresholds: tuple[int, int, int, int], port: int,
                  through_dispatch: bool = False, held_keys: bytes | None = None,
                  name: str = "joystick") -> None:
    h.reset()
    _put16(h, "InputDeviceMode", K.INPUT_MODE_JOYSTICK)
    _put_joystick_fixture(h, thresholds, held_keys)
    h.lib.overkill_set_input_sample(x, y, port)
    if through_dispatch:
        h.lib.poll_input_bits()
        hooks.call("PollInputBits", x, y, port)
    else:
        h.lib.poll_joystick_input_bits()
        hooks.call("PollJoystickInputBits", x, y, port)
    h.compare(name)
    if _u16(h, "JoyButtonSelect") != K.JOY_BUTTONS_PORT_A:
        raise AssertionError(f"{name}: joystick path did not select port A")


def _joystick_sweep(h: HostHarness) -> int:
    hooks = OracleJoystickHooks(h)
    count = 0
    fixed_thresholds = (0x1234, 0xABCD, 0xFEDC, 0x0102)
    for port in range(256):
        _run_joystick(h, hooks, x=0x1233, y=0x0103,
                      thresholds=fixed_thresholds, port=port,
                      name=f"button byte {port:02X}")
        count += 1

    # Equality, strict neighbors, endpoints, and reversed/corrupt ranges on both axes.
    edge_values = (0, 1, 2, 0x7FFF, 0x8000, 0xFFFE, 0xFFFF)
    for index, (low, high) in enumerate((a, b) for a in edge_values for b in edge_values):
        candidates = sorted({0, 0xFFFF, (low - 1) & 0xFFFF, low,
                             (low + 1) & 0xFFFF, (high - 1) & 0xFFFF,
                             high, (high + 1) & 0xFFFF})
        for n, x in enumerate(candidates):
            y = candidates[(n * 3 + index + 1) % len(candidates)]
            thresholds = (low, high, high, low)
            _run_joystick(h, hooks, x=x, y=y, thresholds=thresholds,
                          port=(0xCF ^ index) & 0xFF,
                          name=f"threshold edge {low:04X}/{high:04X} x={x:04X} y={y:04X}")
            count += 1

    rng = random.Random(0x0F67C9)
    for index in range(192):
        thresholds = tuple(rng.randrange(0x10000) for _ in range(4))
        x, y, port = rng.randrange(0x10000), rng.randrange(0x10000), rng.randrange(256)
        _run_joystick(h, hooks, x=x, y=y, thresholds=thresholds, port=port,
                      through_dispatch=index % 8 == 0,
                      name=f"random joystick #{index}")
        count += 1

    # Held keyboard inputs must not be ORed into the joystick result.
    held = bytes([0x81, 0x02, 0xFF, 0x80]) * (K.KEY_DOWN_COUNT // 4)
    _run_joystick(h, hooks, x=0x6000, y=0x5000,
                  thresholds=(0x5000, 0x7000, 0x4000, 0x6000),
                  port=0xFF, through_dispatch=True, held_keys=held,
                  name="joystick ignores held keyboard keys")
    count += 1
    return count


def _clear_key_table(h: HostHarness) -> int:
    before = int(h.lib.overkill_input_flush_count())
    patterns = (bytes(range(K.KEY_DOWN_COUNT)), bytes([0xFF]) * K.KEY_DOWN_COUNT,
                bytes((i * 37 + 1) & 0xFF for i in range(K.KEY_DOWN_COUNT)))
    for index, pattern in enumerate(patterns):
        h.reset()
        h.write_symbol("KeyDownTable", pattern)
        head = (0x46 + index * 0x31) & 0xFFFF
        h.m.u.mem_write(0x041A, struct.pack("<HH", head, 0xBEEF))
        h.lib.clear_key_down_table()
        h.m.call("ClearKeyDownTable")
        h.compare(f"clear key table #{index}")
        if h.state_storage.snapshot()[h.offset("KeyDownTable"):h.offset("KeyDownTable") + K.KEY_DOWN_COUNT] != bytes(K.KEY_DOWN_COUNT):
            raise AssertionError("native clear left a key-table byte set")
        tail_low = bytes(h.m.u.mem_read(0x041C, 1))[0]
        if tail_low != (head & 0xFF):
            raise AssertionError("oracle BIOS keyboard tail low byte was not advanced to its head")
        if int(h.lib.overkill_input_flush_count()) != before + index + 1:
            raise AssertionError("native clear did not call the BIOS-buffer flush service once")
    return len(patterns)


def _test_bind_contract(h: HostHarness) -> None:
    bind = h.lib.overkill_bind_state
    if bind(h.state_addr + 1, STATE_BYTES) != 0:
        raise AssertionError("native core accepted an unaligned state pointer")
    if bind(h.state_addr, STATE_BYTES - 1) != 0:
        raise AssertionError("native core accepted an undersized state window")
    if bind(None, STATE_BYTES) != 0:
        raise AssertionError("native core accepted a null state pointer")
    # Failed rebinds must leave the original buffer installed.
    h.reset()
    h.write_symbol("InputDeviceMode", struct.pack("<H", K.INPUT_MODE_KEYS_A))
    h.write_symbol("KeyBitScancodesA", bytes(range(0x60, 0x68)))
    keys = bytearray(K.KEY_DOWN_COUNT)
    keys[0x60] = 1
    h.write_symbol("KeyDownTable", bytes(keys))
    h.lib.poll_input_bits()
    h.m.call("PollInputBits")
    h.compare("state binding survives rejected rebinds")
    h.check_canaries()


def _test_sdl(h: HostHarness, probe) -> int:
    if not probe.host_sdl_init_events():
        raise AssertionError("SDL_Init(SDL_INIT_EVENTS) failed")
    count = 0
    try:
        flush = probe.host_sdl_flush
        push = probe.host_sdl_push_key
        pump = h.lib.overkill_sdl_pump_input
        flush()

        # SDL physical scancodes map to IBM set-1 positions; repeats update the make code.
        h.reset()
        scan_w = 0x11
        before = h.state_storage.snapshot()
        if not push(probe.host_sdl_key_w(), 1, 0) or pump() != 0:
            raise AssertionError("SDL W key-down was not queued and consumed")
        _assert_state_patch(h, before,
                            {h.offset("KeyLastMakeCode"): bytes((scan_w,)),
                             h.offset("KeyDownTable") + scan_w: bytes((K.KEY_STATE_DOWN,))},
                            "SDL W make")
        if h.state_storage.snapshot()[h.offset("KeyDownTable") + scan_w] != K.KEY_STATE_DOWN:
            raise AssertionError("SDL W did not map to DOS set-1 scan code 11h")
        if _u8(h, "KeyLastMakeCode") != scan_w:
            raise AssertionError("SDL key-down did not update KeyLastMakeCode")
        h.write_symbol("KeyLastMakeCode", bytes((0xE1,)))
        before = h.state_storage.snapshot()
        if not push(probe.host_sdl_key_w(), 1, 1) or pump() != 0:
            raise AssertionError("SDL repeated W key-down was not consumed")
        _assert_state_patch(h, before,
                            {h.offset("KeyLastMakeCode"): bytes((scan_w,))},
                            "SDL repeated W make")
        if h.state_storage.snapshot()[h.offset("KeyDownTable") + scan_w] != K.KEY_STATE_DOWN:
            raise AssertionError("SDL repeat cleared a held key")
        before = h.state_storage.snapshot()
        if not push(probe.host_sdl_key_w(), 0, 0) or pump() != 0:
            raise AssertionError("SDL W key-up was not consumed")
        _assert_state_patch(h, before,
                            {h.offset("KeyDownTable") + scan_w: bytes((K.KEY_STATE_UP,))},
                            "SDL W release")
        if h.state_storage.snapshot()[h.offset("KeyDownTable") + scan_w] != K.KEY_STATE_UP:
            raise AssertionError("SDL key-up did not clear the held state")
        if _u8(h, "KeyLastMakeCode") != scan_w:
            raise AssertionError("SDL key-up incorrectly changed KeyLastMakeCode")
        before = h.state_storage.snapshot()
        if not push(probe.host_sdl_key_f13(), 1, 0) or pump() != 0:
            raise AssertionError("unmapped SDL key event was not consumed")
        _assert_state_patch(h, before, {}, "unmapped SDL F13")
        if _u8(h, "KeyLastMakeCode") != scan_w:
            raise AssertionError("unmapped SDL key changed KeyLastMakeCode")
        count += 1

        # The remappable DOS binding table consumes the SDL-produced set-1 byte.
        h.reset()
        flush()
        before = h.state_storage.snapshot()
        if not push(probe.host_sdl_key_w(), 1, 0) or pump() != 0:
            raise AssertionError("SDL W make for remap test failed")
        _assert_state_patch(h, before,
                            {h.offset("KeyLastMakeCode"): bytes((scan_w,)),
                             h.offset("KeyDownTable") + scan_w: bytes((K.KEY_STATE_DOWN,))},
                            "SDL W remap make")
        codes_a = bytes((scan_w, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67))
        codes_b = bytes((0x68, 0x69, 0x6A, 0x6B, 0x6C, 0x6D, 0x6E, 0x6F))
        _put16(h, "InputDeviceMode", K.INPUT_MODE_KEYS_A)
        h.write_symbol("KeyBitScancodesA", codes_a)
        h.write_symbol("KeyBitScancodesB", codes_b)
        h.sync_oracle_from_native()
        h.lib.poll_input_bits()
        h.m.call("PollInputBits")
        h.compare("SDL W through default binding table")
        if _u8(h, "InputBits") != 0x80:
            raise AssertionError("SDL W did not set the first configurable input bit")

        # Remap that same held set-1 code to the final binding slot.
        codes_a = bytes((0x60, 0x61, 0x62, 0x63, 0x64, 0x65, 0x66, scan_w))
        h.write_symbol("KeyBitScancodesA", codes_a)
        h.sync_oracle_from_native()
        h.lib.poll_input_bits()
        h.m.call("PollInputBits")
        h.compare("SDL W through remapped binding table")
        if _u8(h, "InputBits") != 0x01:
            raise AssertionError("remapped SDL W did not set the last configurable input bit")
        count += 1

        # Keypad 8 aliases the up-arrow slot; both target the DOS navigation scan.
        h.reset()
        flush()
        before = h.state_storage.snapshot()
        if not push(probe.host_sdl_key_keypad8(), 1, 0) or pump() != 0:
            raise AssertionError("SDL keypad-8 event failed")
        _assert_state_patch(h, before,
                            {h.offset("KeyLastMakeCode"): bytes((K.SCAN_UP,)),
                             h.offset("KeyDownTable") + K.SCAN_UP: bytes((K.KEY_STATE_DOWN,))},
                            "SDL keypad 8 alias")
        if h.state_storage.snapshot()[h.offset("KeyDownTable") + K.SCAN_UP] != K.KEY_STATE_DOWN:
            raise AssertionError("SDL keypad 8 did not alias the up-arrow DOS scan")
        count += 1

        # Focus loss clears the whole DOS key table and invokes the flush adapter.
        h.reset()
        flush()
        h.write_symbol("KeyDownTable", bytes([0xFF]) * K.KEY_DOWN_COUNT)
        before = h.state_storage.snapshot()
        flush_count = int(h.lib.overkill_input_flush_count())
        if not probe.host_sdl_push_focus_lost() or pump() != 0:
            raise AssertionError("SDL focus-loss event failed")
        table_at = h.offset("KeyDownTable")
        _assert_state_patch(h, before,
                            {table_at: bytes(K.KEY_DOWN_COUNT)},
                            "SDL focus loss")
        h.m.call("ClearKeyDownTable")
        h.compare("SDL focus loss clears keys like the oracle")
        if h.state_storage.snapshot()[h.offset("KeyDownTable"):h.offset("KeyDownTable") + K.KEY_DOWN_COUNT] != bytes(K.KEY_DOWN_COUNT):
            raise AssertionError("focus loss did not clear every key state")
        if int(h.lib.overkill_input_flush_count()) != flush_count + 1:
            raise AssertionError("focus loss did not invoke the input flush adapter")
        count += 1

        # Alt+X exits on the X make and leaves later queued events untouched.
        h.reset()
        flush()
        before = h.state_storage.snapshot()
        if not push(probe.host_sdl_key_left_alt(), 1, 0):
            raise AssertionError("could not queue Alt make")
        if not push(probe.host_sdl_key_x(), 1, 0):
            raise AssertionError("could not queue X make")
        if not push(probe.host_sdl_key_b(), 1, 0):
            raise AssertionError("could not queue event after Alt+X")
        if pump() != 1:
            raise AssertionError("Alt+X did not request exit")
        _assert_state_patch(h, before,
                            {h.offset("KeyLastMakeCode"): bytes((K.SCAN_X,)),
                             h.offset("KeyDownTable") + K.SCAN_ALT: bytes((K.KEY_STATE_DOWN,)),
                             h.offset("KeyDownTable") + K.SCAN_X: bytes((K.KEY_STATE_DOWN,))},
                            "SDL Alt+X")
        keys = h.state_storage.snapshot()[h.offset("KeyDownTable"):h.offset("KeyDownTable") + K.KEY_DOWN_COUNT]
        if keys[K.SCAN_ALT] != K.KEY_STATE_DOWN or keys[K.SCAN_X] != K.KEY_STATE_DOWN:
            raise AssertionError("Alt+X make states were not retained")
        if keys[K.SCAN_B] != K.KEY_STATE_UP:
            raise AssertionError("event pump did not stop at Alt+X")
        count += 1

        # A quit event also requests exit; an ordinary focus event does not.
        h.reset()
        flush()
        before = h.state_storage.snapshot()
        if not probe.host_sdl_push_quit() or pump() != 1:
            raise AssertionError("SDL_QUIT did not request exit")
        _assert_state_patch(h, before, {}, "SDL_QUIT")
        count += 1
    finally:
        probe.host_sdl_quit()
        probe.host_sdl_flush()
    h.check_canaries()
    return count


def run(no_build: bool = False) -> int:
    if no_build:
        if not _core_path().is_file() or not HOST_STATE.is_file():
            raise FileNotFoundError("--no-build requires the current build/host core and STATE.BIN")
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    h = HostHarness()
    _test_bind_contract(h)

    start = time.perf_counter()
    keyboard = _keyboard_sweep(h)
    joystick = _joystick_sweep(h)
    cleared = _clear_key_table(h)

    probe_path = _build_probe()
    probe, probe_dll_dir = _load_probe(probe_path)
    sdl = _test_sdl(h, probe)
    if probe_dll_dir is not None:
        probe_dll_dir.close()
    total = keyboard + joystick + cleared + sdl
    print(f"PASS host input: {keyboard} keyboard, {joystick} joystick, {cleared} clear, "
          f"{sdl} SDL scenarios ({total} checks) in {time.perf_counter() - start:.1f}s")
    return total


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="reuse build/host and build/oracle-sym artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
