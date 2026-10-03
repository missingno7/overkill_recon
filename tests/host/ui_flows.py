"""Bounded native UI-flow checks over live SDL input and DOS-shaped services.

Run ``python tests/host/ui_flows.py --no-build`` to reuse the current native DLL
and exact oracle. The test drives the real high-score editor and session quit
prompt with SDL events, and runs the shared calibration region through actual
archive, page, panel, timer, and injected game-port services. Tiny test-only
bridges bound the non-returning session/calibration loops. Audio synthesis and
backend timing are not asserted; timer checks verify cooperative delivery.
"""
from __future__ import annotations

import argparse
import ctypes
import importlib.util
import os
from pathlib import Path
import struct
import subprocess
import sys
import tempfile
from types import SimpleNamespace

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
TESTS = ROOT / "tests"
HOST_DIR = ROOT / "build/host"
HOST_CORE = HOST_DIR / ("OVERKILL_CORE.dll" if os.name == "nt"
                        else "liboverkill_core.so")
HOST_IMPORT = HOST_DIR / "liboverkill_core.dll.a"
HOST_IMAGE = HOST_DIR / "HOST_IMAGE.BIN"
HOST_HEADER = HOST_DIR / "HOST_GEN.H"
ORACLE_EXE = ROOT / "build/oracle-sym/OVERKILL.EXE"
DOS_MEMORY_BYTES = 0x100000
PANEL_SEGMENT = 0x6000
PANEL_IMAGE_OFFSET = 0x0200
SCREEN_SEGMENT = 0xB800

sys.path.insert(0, str(TOOLS))
sys.path.insert(0, str(TESTS))
from extract import mz  # noqa: E402
from common import read_json, sha  # noqa: E402


class HostRegisters(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in
                ("ax", "bx", "cx", "dx", "si", "di", "bp", "es")]


class DosRegisters(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in ("bp", "es")]


IdleCallback = ctypes.CFUNCTYPE(None)
TraceCallback = ctypes.CFUNCTYPE(None, ctypes.c_uint16,
                                 ctypes.POINTER(HostRegisters))


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _token(name: str) -> int:
    import re

    text = HOST_HEADER.read_text(encoding="ascii")
    match = re.search(
        rf"^\s*#define\s+HOST_(?:TOKEN|SERVICE)_{name}\s+\(\(word\)0x([0-9A-Fa-f]+)\)",
        text, re.MULTILINE)
    if match is None:
        raise AssertionError(f"generated HOST_GEN.H is missing a service token for {name}")
    return int(match.group(1), 16)


def _verify_inputs() -> None:
    if not HOST_CORE.is_file() or not HOST_IMAGE.is_file() or not HOST_HEADER.is_file():
        raise FileNotFoundError("--no-build requires the current host DLL, image, and generated header")
    if not ORACLE_EXE.is_file():
        raise FileNotFoundError(f"exact oracle is missing: {ORACLE_EXE}")
    _, image, _, _ = mz(ORACLE_EXE.read_bytes())
    oracle = read_json(ROOT / "metadata/oracle.json")
    if len(image) != oracle["program_bytes"] or sha(image) != oracle["program_sha256"]:
        raise AssertionError("build/oracle-sym is not the source-built exact oracle")


def _compile_probe(directory: Path) -> Path:
    sys.path.insert(0, str(TOOLS))
    import host as host_build  # pylint: disable=import-outside-toplevel

    source = directory / "ui_probe.c"
    output = HOST_DIR / ("ui_probe.dll" if os.name == "nt" else "libui_probe.so")
    source.write_text(r'''#include <SDL3/SDL.h>
#include <setjmp.h>
#include "platform_services.h"
#include "session.h"
#include "calibration.h"

enum UiKey {
    UI_A = 1, UI_B, UI_C, UI_D, UI_E, UI_F, UI_G, UI_H, UI_I, UI_J, UI_K, UI_L,
    UI_BACKSPACE, UI_ENTER, UI_ESCAPE, UI_F9, UI_N, UI_Y,
    UI_KP_0, UI_KP_1, UI_KP_2, UI_KP_3, UI_KP_4, UI_KP_5, UI_KP_6, UI_KP_7,
    UI_KP_8, UI_KP_9, UI_KP_PERIOD, UI_KP_COMMA, UI_KP_PLUS, UI_KP_MINUS,
    UI_KP_MULTIPLY, UI_KP_DIVIDE, UI_KP_ENTER
};

static jmp_buf session_return;
static jmp_buf calibration_return;
static void (*external_idle)(void);
static void (*calibration_external_idle)(void);
static unsigned idle_count;
static unsigned calibration_idle_count;
static int prompt_seen;
static int route;

static void limited_idle(void)
{
    if (external_idle != NULL) external_idle();
    if (++idle_count > 512) longjmp(session_return, 3);
}

static void limited_calibration_idle(void)
{
    if (calibration_external_idle != NULL) calibration_external_idle();
    if (++calibration_idle_count > 5000) longjmp(calibration_return, 2);
}

static void session_trace(word token, const HostRegisters *registers)
{
    (void)registers;
    if (token == HOST_SERVICE_SESSIONDRAWQUITPROMPT) {
        prompt_seen = 1;
    } else if (prompt_seen && route == 'N' && token == HOST_TOKEN_WAITTIMERTICK) {
        longjmp(session_return, 1);
    } else if (prompt_seen && route == 'Y' && token == HOST_TOKEN_RESETEGAPAGES) {
        longjmp(session_return, 2);
    }
}

static SDL_Scancode ui_scancode(int key)
{
    switch (key) {
    case UI_A: return SDL_SCANCODE_A; case UI_B: return SDL_SCANCODE_B;
    case UI_C: return SDL_SCANCODE_C; case UI_D: return SDL_SCANCODE_D;
    case UI_E: return SDL_SCANCODE_E; case UI_F: return SDL_SCANCODE_F;
    case UI_G: return SDL_SCANCODE_G; case UI_H: return SDL_SCANCODE_H;
    case UI_I: return SDL_SCANCODE_I; case UI_J: return SDL_SCANCODE_J;
    case UI_K: return SDL_SCANCODE_K; case UI_L: return SDL_SCANCODE_L;
    case UI_BACKSPACE: return SDL_SCANCODE_BACKSPACE;
    case UI_ENTER: return SDL_SCANCODE_RETURN;
    case UI_ESCAPE: return SDL_SCANCODE_ESCAPE; case UI_F9: return SDL_SCANCODE_F9;
    case UI_N: return SDL_SCANCODE_N; case UI_Y: return SDL_SCANCODE_Y;
    case UI_KP_0: return SDL_SCANCODE_KP_0; case UI_KP_1: return SDL_SCANCODE_KP_1;
    case UI_KP_2: return SDL_SCANCODE_KP_2; case UI_KP_3: return SDL_SCANCODE_KP_3;
    case UI_KP_4: return SDL_SCANCODE_KP_4; case UI_KP_5: return SDL_SCANCODE_KP_5;
    case UI_KP_6: return SDL_SCANCODE_KP_6; case UI_KP_7: return SDL_SCANCODE_KP_7;
    case UI_KP_8: return SDL_SCANCODE_KP_8; case UI_KP_9: return SDL_SCANCODE_KP_9;
    case UI_KP_PERIOD: return SDL_SCANCODE_KP_PERIOD;
    case UI_KP_COMMA: return SDL_SCANCODE_KP_COMMA;
    case UI_KP_PLUS: return SDL_SCANCODE_KP_PLUS;
    case UI_KP_MINUS: return SDL_SCANCODE_KP_MINUS;
    case UI_KP_MULTIPLY: return SDL_SCANCODE_KP_MULTIPLY;
    case UI_KP_DIVIDE: return SDL_SCANCODE_KP_DIVIDE;
    case UI_KP_ENTER: return SDL_SCANCODE_KP_ENTER;
    default: return SDL_SCANCODE_UNKNOWN;
    }
}

int ui_init(void)
{
    SDL_SetHint(SDL_HINT_VIDEO_DRIVER, "dummy");
    return SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS) ? 1 : 0;
}

void ui_quit(void) { SDL_Quit(); }
void ui_flush(void) { SDL_Event event; while (SDL_PollEvent(&event)) { } }
int ui_mod_num(void) { return SDL_KMOD_NUM; }
int ui_mod_shift(void) { return SDL_KMOD_SHIFT; }

int ui_push_key(int key, int down, int modifiers)
{
    SDL_Event event = {0};
    SDL_Scancode scan = ui_scancode(key);
    event.type = down ? SDL_EVENT_KEY_DOWN : SDL_EVENT_KEY_UP;
    event.key.type = event.type;
    event.key.scancode = scan;
    event.key.key = SDL_GetKeyFromScancode(scan, (SDL_Keymod)modifiers, false);
    event.key.mod = (SDL_Keymod)modifiers;
    event.key.down = down != 0;
    return SDL_PushEvent(&event) ? 1 : 0;
}

int ui_run_quit_prompt(int answer, void (*idle)(void))
{
    int result;
    if (answer != 'N' && answer != 'Y') return 4;
    external_idle = idle;
    idle_count = 0;
    prompt_seen = 0;
    route = answer;
    overkill_platform_bind_idle(limited_idle);
    overkill_platform_bind_trace(session_trace);
    result = setjmp(session_return);
    if (result == 0) {
        run_game_session(SESSION_QUIT_PROMPT, 0);
        result = 4;
    }
    overkill_platform_bind_trace(NULL);
    overkill_platform_bind_idle(NULL);
    external_idle = NULL;
    return prompt_seen ? result : 4;
}

int ui_run_boss_key(void (*idle)(void))
{
    HostRegisters registers = {0};
    int result;
    external_idle = idle;
    idle_count = 0;
    overkill_platform_bind_idle(limited_idle);
    result = setjmp(session_return);
    if (result == 0) {
        overkill_platform_call(HOST_TOKEN_SHOWBOSSKEYSCREEN, &registers);
        result = 1;
    }
    overkill_platform_bind_idle(NULL);
    external_idle = NULL;
    return result;
}

int ui_run_calibration(DosRegisters *registers, void (*idle)(void))
{
    int result;
    calibration_external_idle = idle;
    calibration_idle_count = 0;
    overkill_platform_bind_idle(limited_calibration_idle);
    result = setjmp(calibration_return);
    if (result == 0) {
        calibrate_joystick_with_abort(registers);
        result = 0;
    }
    overkill_platform_bind_idle(NULL);
    calibration_external_idle = NULL;
    return result;
}
''', encoding="ascii")

    flags = host_build.sdl_flags()
    command = [os.environ.get("CC", "gcc"), "-std=c11", "-O2", "-Wall", "-Wextra",
               "-Werror", "-Wno-unknown-pragmas", "-DOVERKILL_HOST", "-shared",
               "-I" + str(HOST_DIR), "-I" + str(ROOT / "c"),
               "-I" + str(ROOT / "host")]
    if os.name == "nt":
        sdl_flags, _sdk = flags
        command += [str(source), str(HOST_IMPORT), *sdl_flags, "-static-libgcc", "-o", str(output)]
    else:
        command += ["-fPIC", str(source), str(HOST_CORE), *flags, "-Wl,-rpath," + str(HOST_DIR),
                    "-o", str(output)]
    subprocess.run(command, check=True, cwd=ROOT)
    return output


class NativeFixture:
    def __init__(self) -> None:
        harness = _load_module("host_input_harness_ui_flows", ROOT / "tests/host/input.py")
        self.h = harness.HostHarness()
        self.lib = self.h.lib
        self.machine = self.h.m
        self._bind_signatures()
        self.raw_arena = ctypes.create_string_buffer(DOS_MEMORY_BYTES + 15)
        self.arena_base = (ctypes.addressof(self.raw_arena) + 15) & ~15
        image = HOST_IMAGE.read_bytes()
        if len(image) != DOS_MEMORY_BYTES:
            raise AssertionError("native DOS arena image is not 1 MiB")
        ctypes.memmove(self.arena_base, image, DOS_MEMORY_BYTES)
        if not self.lib.overkill_bind_real_memory(self.arena_base, DOS_MEMORY_BYTES):
            raise AssertionError("native core rejected the 1 MiB test arena")

    def _bind_signatures(self) -> None:
        self.lib.overkill_bind_real_memory.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
        self.lib.overkill_bind_real_memory.restype = ctypes.c_int
        self.lib.overkill_bind_level_map.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
        self.lib.overkill_bind_level_map.restype = ctypes.c_int
        self.lib.overkill_platform_call.argtypes = (
            ctypes.c_uint16, ctypes.POINTER(HostRegisters))
        self.lib.overkill_platform_call.restype = None
        self.lib.overkill_platform_bind_idle.argtypes = (ctypes.c_void_p,)
        self.lib.overkill_platform_bind_idle.restype = None
        self.lib.overkill_platform_bind_trace.argtypes = (ctypes.c_void_p,)
        self.lib.overkill_platform_bind_trace.restype = None
        self.lib.overkill_platform_last_es.argtypes = ()
        self.lib.overkill_platform_last_es.restype = ctypes.c_uint16
        self.lib.overkill_sdl_apply_event.argtypes = (ctypes.c_void_p,)
        self.lib.overkill_sdl_pump_input.argtypes = ()
        self.lib.overkill_sdl_pump_input.restype = ctypes.c_int
        self.lib.overkill_sdl_character_mode.argtypes = (ctypes.c_int,)
        self.lib.overkill_sdl_flush_characters.argtypes = ()
        self.lib.overkill_sdl_read_character.argtypes = ()
        self.lib.overkill_sdl_read_character.restype = ctypes.c_int
        self.lib.overkill_sdl_video_open.argtypes = ()
        self.lib.overkill_sdl_video_open.restype = ctypes.c_int
        self.lib.overkill_sdl_video_close.argtypes = ()
        self.lib.overkill_resource_mount_drive.argtypes = (ctypes.c_char, ctypes.c_char_p)
        self.lib.overkill_resource_mount_drive.restype = ctypes.c_int
        self.lib.overkill_resource_set_current_drive.argtypes = (ctypes.c_char,)
        self.lib.overkill_resource_set_current_drive.restype = ctypes.c_int
        self.lib.overkill_resource_services_bind_arena.argtypes = (
            ctypes.c_uint16, ctypes.c_uint16)
        self.lib.overkill_resource_services_bind_arena.restype = ctypes.c_int
        self.lib.overkill_dos_set_allocation_strategy.argtypes = (ctypes.c_uint16,)
        self.lib.overkill_dos_set_allocation_strategy.restype = ctypes.c_int
        self.lib.overkill_video_services_shutdown.argtypes = ()
        self.lib.overkill_video_services_shutdown.restype = None
        self.lib.load_graphics_record_images.argtypes = (ctypes.POINTER(DosRegisters),)
        self.lib.load_graphics_record_images.restype = None
        self.lib.calibrate_joystick_with_abort.argtypes = (ctypes.POINTER(DosRegisters),)
        self.lib.calibrate_joystick_with_abort.restype = None
        self.lib.overkill_clear_input_sample.argtypes = ()
        self.lib.overkill_clear_input_sample.restype = None
        self.lib.presentation_text_mode_active.argtypes = ()
        self.lib.presentation_text_mode_active.restype = ctypes.c_int
        self.lib.presentation_text_get_cursor.argtypes = (
            ctypes.POINTER(ctypes.c_uint16), ctypes.POINTER(ctypes.c_uint16))
        self.lib.presentation_text_get_cursor.restype = None
        self.lib.overkill_ega_plane_address.argtypes = (
            ctypes.c_uint16, ctypes.c_uint16, ctypes.c_uint16)
        self.lib.overkill_ega_plane_address.restype = ctypes.c_void_p
        self.lib.overkill_clock_bind.argtypes = (ctypes.c_void_p, ctypes.c_void_p)
        self.lib.overkill_clock_reset.argtypes = (ctypes.c_uint64,)
        self.lib.overkill_clock_advance.argtypes = (ctypes.c_uint64,)
        self.lib.overkill_clock_frame_ready.argtypes = ()
        self.lib.overkill_clock_frame_ready.restype = ctypes.c_int
        self.lib.overkill_clock_now_ns.argtypes = ()
        self.lib.overkill_clock_now_ns.restype = ctypes.c_uint64
        self.lib.overkill_set_input_sample.argtypes = (
            ctypes.c_uint16, ctypes.c_uint16, ctypes.c_uint8)
        self.lib.overkill_clear_input_sample.argtypes = ()
        self.lib.edit_hiscore_name.argtypes = (ctypes.POINTER(DosRegisters),)
        self.lib.edit_hiscore_name.restype = None

    def reset(self) -> None:
        self.h.reset()
        ctypes.memmove(self.arena_base, HOST_IMAGE.read_bytes(), DOS_MEMORY_BYTES)

    def set_symbol(self, name: str, data: bytes) -> None:
        linear = self.machine.linear(name) & 0xFFFFF
        data_linear = _header_word("HOST_DATA_LINEAR")
        if ((linear - data_linear) & 0xFFFFF) < 0x10000:
            self.h.write_symbol(name, data)
        else:
            ctypes.memmove(self.arena_base + linear, data, len(data))

    def get_symbol(self, name: str, length: int) -> bytes:
        linear = self.machine.linear(name) & 0xFFFFF
        data_linear = _header_word("HOST_DATA_LINEAR")
        if ((linear - data_linear) & 0xFFFFF) < 0x10000:
            start = self.h.offset(name)
            return ctypes.string_at(self.h.state_addr + start, length)
        return ctypes.string_at(self.arena_base + linear, length)

    def physical_write(self, address: int, data: bytes) -> None:
        ctypes.memmove(self.arena_base + (address & 0xFFFFF), data, len(data))

    def physical_read(self, address: int, length: int) -> bytes:
        return ctypes.string_at(self.arena_base + (address & 0xFFFFF), length)


def _install_probe(native: NativeFixture, probe_path: Path):
    dll_directory = os.add_dll_directory(str(HOST_DIR)) if os.name == "nt" else None
    probe = ctypes.CDLL(str(probe_path))
    probe.ui_init.argtypes = ()
    probe.ui_init.restype = ctypes.c_int
    probe.ui_quit.argtypes = ()
    probe.ui_quit.restype = None
    probe.ui_flush.argtypes = ()
    probe.ui_flush.restype = None
    probe.ui_mod_num.argtypes = ()
    probe.ui_mod_num.restype = ctypes.c_int
    probe.ui_mod_shift.argtypes = ()
    probe.ui_mod_shift.restype = ctypes.c_int
    probe.ui_push_key.argtypes = (ctypes.c_int, ctypes.c_int, ctypes.c_int)
    probe.ui_push_key.restype = ctypes.c_int
    probe.ui_run_quit_prompt.argtypes = (ctypes.c_int, IdleCallback)
    probe.ui_run_quit_prompt.restype = ctypes.c_int
    probe.ui_run_boss_key.argtypes = (IdleCallback,)
    probe.ui_run_boss_key.restype = ctypes.c_int
    probe.ui_run_calibration.argtypes = (ctypes.POINTER(DosRegisters), IdleCallback)
    probe.ui_run_calibration.restype = ctypes.c_int
    if not probe.ui_init():
        raise AssertionError("SDL dummy video/event initialization failed")
    if not native.lib.overkill_sdl_video_open():
        raise AssertionError("native SDL presenter failed to open in dummy mode")
    return probe, dll_directory


def _bind_idle(native: NativeFixture, callback) -> None:
    native.lib.overkill_platform_bind_idle(
        None if callback is None else ctypes.cast(callback, ctypes.c_void_p))


def _pump_event(native: NativeFixture, probe, key: int, *, down: bool = True,
                modifiers: int = 0, release: bool = True) -> None:
    if down and not probe.ui_push_key(key, 1, modifiers):
        raise AssertionError(f"SDL rejected key-down event {key}")
    if release and not probe.ui_push_key(key, 0, modifiers):
        raise AssertionError(f"SDL rejected key-up event {key}")
    if native.lib.overkill_sdl_pump_input() != 0:
        raise AssertionError("ordinary UI key was interpreted as a process quit")


def _idle_script(native: NativeFixture, probe, events: list[tuple[int, int, bool, int]],
                 *, step_ns: int = 1_000_000):
    state = SimpleNamespace(events=list(events), now=0, calls=0, errors=[])

    @ctypes.CFUNCTYPE(None)
    def idle() -> None:
        state.calls += 1
        try:
            if state.events:
                key, down, release, modifiers = state.events.pop(0)
                _pump_event(native, probe, key, down=bool(down),
                            modifiers=modifiers, release=release)
            state.now += step_ns
            native.lib.overkill_clock_advance(state.now)
        except BaseException as error:  # keep Python exceptions out of native frames
            state.errors.append(error)

    return idle, state


def _key_call(native: NativeFixture, probe, event: tuple[int, int, int],
              read_key_token: int) -> tuple[int, bytes]:
    native.lib.overkill_sdl_flush_characters()
    native.lib.overkill_sdl_character_mode(1)
    key, modifiers, expected = event
    idle, state = _idle_script(native, probe, [(key, 1, True, modifiers)])
    native.lib.overkill_clock_reset(0)
    _bind_idle(native, idle)
    registers = HostRegisters()
    try:
        native.lib.overkill_platform_call(read_key_token, ctypes.byref(registers))
    finally:
        _bind_idle(native, None)
    if state.errors:
        raise AssertionError(f"SDL key delivery failed: {state.errors[0]}")
    return registers.ax, native.get_symbol("LastKeyExtended", 1)


def _test_highscore_editor(native: NativeFixture, probe) -> int:
    h = native.h
    native.reset()
    native.set_symbol("VideoAdapter", struct.pack("<H", 2))
    native.set_symbol("MainDataSegment", struct.pack("<H", _header_word("HOST_DATA_SEGMENT")))
    native.set_symbol("TextInGraphics", b"\0")
    name_at = h.offset("HiscoreNameBuffer")
    h.write_symbol("HiscoreNameCursor", struct.pack("<H", name_at))
    h.write_symbol("HiscoreNameBuffer", b" " * 10 + b"\0")
    regs = HostRegisters()
    native.lib.overkill_platform_call(_token("SHUTDOWNSETTEXTMODE3"), ctypes.byref(regs))

    key_ids = {letter: index for index, letter in enumerate("abcdefghijkl", start=1)}
    backspace, enter = 13, 14
    sequence = [key_ids["a"], key_ids["b"], backspace,
                *[key_ids[letter] for letter in "cdefghijkl"],
                enter]
    events = [(key, 1, True, 0) for key in sequence]
    idle, state = _idle_script(native, probe, events)
    _bind_idle(native, idle)
    edit_registers = DosRegisters(0, _header_word("HOST_DATA_SEGMENT"))
    try:
        native.lib.edit_hiscore_name(ctypes.byref(edit_registers))
    finally:
        _bind_idle(native, None)
        native.lib.overkill_sdl_flush_characters()
    if state.errors:
        raise AssertionError(f"high-score editor SDL pump failed: {state.errors[0]}")
    got = h.state_storage.snapshot()[name_at:name_at + 10]
    if got != b"acdefghijk":
        raise AssertionError(f"native high-score editor stored {got!r}, expected b'acdefghijk'")
    if struct.unpack_from("<H", h.state_storage.snapshot(), h.offset("HiscoreNameCursor"))[0] != name_at + 10:
        raise AssertionError("high-score editor did not leave its cursor at the ten-byte limit")
    if native.get_symbol("QuitAnswer", 1) != b"\r":
        raise AssertionError("Enter did not reach DOS character service as carriage return: "
                             f"QuitAnswer={native.get_symbol('QuitAnswer', 1).hex()}")
    if native.get_symbol("LastKeyExtended", 1) != b"\0":
        raise AssertionError("ordinary Enter was marked as an extended key")
    if state.calls < len(sequence):
        raise AssertionError("high-score editor bypassed the cooperative input idle hook")
    return len(sequence)


def _test_keypad_character_service(native: NativeFixture, probe) -> int:
    read_key = _token("READKEYTHROUGHDOS")
    num = probe.ui_mod_num()
    shift = probe.ui_mod_shift()
    cases = (
        (20, num, ord("1"), 0),   # keypad 1 with Num Lock
        (20, 0, 0x4F, 1),          # keypad 1 as End
        (20, num | shift, 0x4F, 1),
        (21, num, ord("2"), 0),
        (19, num, ord("0"), 0),
        (29, num, ord("."), 0),
        (30, num, ord(","), 0),
        (29, 0, 0x53, 1),          # keypad period as Delete
        (31, 0, ord("+"), 0),
        (32, 0, ord("-"), 0),
        (33, 0, ord("*"), 0),
        (34, 0, ord("/"), 0),
        (35, 0, 13, 0),
    )
    for key, modifiers, expected_al, extended in cases:
        native.reset()
        ax, actual_extended = _key_call(native, probe,
                                         (key, modifiers, expected_al), read_key)
        if ax != 0x0800 | (expected_al & 0xFF):
            raise AssertionError(f"keypad service key={key} mods={modifiers:#x}: AX={ax:04X}")
        if actual_extended != bytes((extended,)):
            raise AssertionError(f"keypad service key={key} mods={modifiers:#x}: extended={actual_extended!r}")
        if native.get_symbol("QuitAnswer", 1) != bytes((expected_al & 0xFF,)):
            raise AssertionError(f"keypad service key={key}: QuitAnswer did not match AL")
    return len(cases)


def _virtual_idle(native: NativeFixture, probe, event: tuple[int, bool] | None = None,
                  *, state: SimpleNamespace | None = None):
    if state is None:
        state = SimpleNamespace(now=0, calls=0, event=event, error=None)

    @ctypes.CFUNCTYPE(None)
    def idle() -> None:
        state.calls += 1
        try:
            if state.event is not None:
                key, down = state.event
                state.event = None
                _pump_event(native, probe, key, down=bool(down), release=not down)
            state.now += 1_000_000
            native.lib.overkill_clock_advance(state.now)
        except BaseException as error:
            state.error = error

    return idle, state


def _prepare_quit_panel(native: NativeFixture) -> None:
    h = native.h
    native.set_symbol("VideoAdapter", struct.pack("<H", 2))
    native.set_symbol("MainDataSegment", struct.pack("<H", _header_word("HOST_DATA_SEGMENT")))
    native.set_symbol("ScreenSegment", struct.pack("<H", SCREEN_SEGMENT))
    native.set_symbol("PanelSegment", struct.pack("<H", PANEL_SEGMENT))
    native.set_symbol("SfxEnabled", b"\0")
    native.set_symbol("ModuleSoundEnabled", b"\0")
    native.set_symbol("SoundModuleLoaded", b"\0")
    h.write_symbol("ScreenRowOffsets" , bytes(2 * 0x5D))
    # PanelImageOffsets is a CS table. A one-row, one-unit Tandy panel is enough
    # to exercise the real session prompt service and screen blitter safely.
    table = (native.machine.linear("PanelImageOffsets") + 2 * 0x28) & 0xFFFFF
    native.physical_write(table, struct.pack("<H", PANEL_IMAGE_OFFSET))
    native.physical_write((PANEL_SEGMENT << 4) + PANEL_IMAGE_OFFSET,
                          struct.pack("<HH4B", 1, 1, 0x12, 0x34, 0x56, 0x78))


def _test_quit_prompt_branches(native: NativeFixture, probe, bridge) -> int:
    h = native.h
    expected = (("N", 17, 1), ("Y", 18, 2))
    for answer, key, route in expected:
        native.reset()
        _prepare_quit_panel(native)
        keys = bytearray(h.state_storage.snapshot()[h.offset("KeyDownTable"):
                                                    h.offset("KeyDownTable") + 0x60])
        keys[0x01] = 1  # SCAN_ESC is the original set-1 Escape make code.
        h.write_symbol("KeyDownTable", bytes(keys))
        native.lib.overkill_clock_bind(None, None)
        native.lib.overkill_clock_reset(0)
        idle_state = SimpleNamespace(now=0, calls=0, events=[(15, 0), (key, 1)], error=None)

        @ctypes.CFUNCTYPE(None)
        def idle() -> None:
            idle_state.calls += 1
            try:
                if idle_state.events:
                    scan, down = idle_state.events.pop(0)
                    _pump_event(native, probe, scan, down=bool(down), release=not down)
                idle_state.now += 1_000_000
                native.lib.overkill_clock_advance(idle_state.now)
            except BaseException as error:
                idle_state.error = error

        result = bridge.ui_run_quit_prompt(ord(answer), idle)
        if idle_state.error:
            raise AssertionError(f"quit prompt {answer} SDL event failed: {idle_state.error}")
        if result != route:
            raise AssertionError(f"quit prompt {answer} stopped at route {result}, expected {route}")
        if not idle_state.events == [] or idle_state.calls < 2:
            raise AssertionError(f"quit prompt {answer} did not pump both input phases")
        if native.get_symbol("QuitAnswer", 1) != answer.encode("ascii"):
            raise AssertionError(f"quit prompt did not retain the {answer} answer")
        prompt_bytes = native.physical_read((SCREEN_SEGMENT << 4) + 16, 4)
        if prompt_bytes != bytes((0x12, 0x34, 0x56, 0x78)):
            raise AssertionError(f"quit prompt panel did not reach the Tandy screen: {prompt_bytes.hex()}")
    return len(expected)


def _test_boss_key_restore(native: NativeFixture, probe) -> int:
    h = native.h
    native.reset()
    native.set_symbol("VideoAdapter", struct.pack("<H", 2))
    native.set_symbol("MainDataSegment", struct.pack("<H", _header_word("HOST_DATA_SEGMENT")))
    native.set_symbol("ScreenSegment", struct.pack("<H", SCREEN_SEGMENT))
    native.set_symbol("SfxEnabled", b"\0")
    native.set_symbol("ModuleSoundEnabled", b"\0")
    native.set_symbol("SoundModuleLoaded", b"\0")
    # INT 10h mode restoration clears the selected graphics aperture. Seed it
    # before the boss-key mode-3 detour so stale text cells cannot survive as
    # Tandy pixels when normal gameplay resumes.
    native.physical_write(SCREEN_SEGMENT << 4, b"\xA5" * 0x8000)
    keys = bytearray(h.state_storage.snapshot()[h.offset("KeyDownTable"):
                                                h.offset("KeyDownTable") + 0x60])
    keys[0x43] = 1  # SCAN_F9 remains held until the live SDL key-up.
    h.write_symbol("KeyDownTable", bytes(keys))
    events = [(16, 0, True, 0), (2, 1, True, 0)]
    idle, state = _idle_script(native, probe, events)
    route = probe.ui_run_boss_key(idle)
    if state.errors:
        raise AssertionError(f"boss-key SDL pump failed: {state.errors[0]}")
    if route != 1:
        raise AssertionError(f"boss-key service timed out or returned route {route}")
    if native.lib.presentation_text_mode_active() != 0:
        raise AssertionError("boss-key restore left the native presenter in text mode")
    if state.calls < 2:
        raise AssertionError("boss-key flow skipped release or resume key pumping")
    if native.get_symbol("KeyLastMakeCode", 1) != b"\x30":
        raise AssertionError("boss-key resume key did not reach the DOS make-code mailbox")
    restored = native.physical_read(SCREEN_SEGMENT << 4, 0x8000)
    if any(restored):
        raise AssertionError("boss-key BIOS mode restore did not clear the Tandy framebuffer")
    return 1


def _snapshot_graphics(native: NativeFixture, adapter: int):
    if adapter == 1:
        return tuple(ctypes.string_at(
            native.lib.overkill_ega_plane_address(0xA000, plane, 0), 0x10000)
            for plane in range(4))
    return native.physical_read(SCREEN_SEGMENT << 4, 0x8000)


def _fill_graphics(native: NativeFixture, adapter: int, value: int) -> None:
    if adapter == 1:
        for plane in range(4):
            ctypes.memset(native.lib.overkill_ega_plane_address(0xA000, plane, 0),
                          value, 0x10000)
    else:
        native.physical_write(SCREEN_SEGMENT << 4, bytes((value,)) * 0x8000)


def _apply_blank_glyph_footprint(snapshot, adapter: int, row: int):
    """Clear the ten 8x8 CP437 space glyphs at BIOS row, column zero."""
    if adapter == 1:
        expected = [bytearray(plane) for plane in snapshot]
        for y in range(row * 8, row * 8 + 8):
            for x in range(80):
                offset = y * 40 + x // 8
                mask = 0x80 >> (x & 7)
                for plane in expected:
                    plane[offset] &= ~mask
        return tuple(bytes(plane) for plane in expected)

    expected = bytearray(snapshot)
    for y in range(row * 8, row * 8 + 8):
        for x in range(80):
            if adapter == 2:
                offset = (y & 3) * 0x2000 + (y >> 2) * 160 + x // 2
                shift = 4 - (x & 1) * 4
                mask = 0x0F << shift
            else:
                offset = (y & 1) * 0x2000 + (y >> 1) * 80 + x // 4
                shift = 6 - (x & 3) * 2
                mask = 3 << shift
            expected[offset] &= ~mask
    return bytes(expected)


def _prepare_calibration_assets(native: NativeFixture, adapter: int = 2) -> None:
    native.lib.overkill_video_services_shutdown()
    native.reset()
    heap_start = _header_word("HOST_SEGMENT_IMAGEEND")
    if not native.lib.overkill_resource_services_bind_arena(
            heap_start, 0xA000 - heap_start):
        raise AssertionError("native calibration heap initialization failed")
    if not native.lib.overkill_dos_set_allocation_strategy(1):
        raise AssertionError("native calibration allocation strategy setup failed")
    asset_root = os.fsencode(HOST_DIR / "assets")
    if not native.lib.overkill_resource_mount_drive(b"C", asset_root):
        raise AssertionError(f"cannot mount real game archive directory: {asset_root!r}")
    if not native.lib.overkill_resource_set_current_drive(b"C"):
        raise AssertionError("cannot select the C: game asset drive")

    native.set_symbol("MainDataSegment", struct.pack("<H", _header_word("HOST_DATA_SEGMENT")))
    native.set_symbol("VideoAdapter", struct.pack("<H", adapter))
    native.lib.overkill_platform_call(_token("SETUPRESOURCEARCHIVE"),
                                      ctypes.byref(HostRegisters()))
    native.lib.overkill_platform_call(_token("ALLOCATEBUFFERS"),
                                      ctypes.byref(HostRegisters()))
    native.lib.overkill_platform_call(_token("BUILDROWTABLES"),
                                      ctypes.byref(HostRegisters()))

    panel_segment = struct.unpack("<H", native.get_symbol("PanelSegment", 2))[0]
    if panel_segment == 0:
        raise AssertionError("native startup buffer service did not allocate PanelSegment")
    native.set_symbol("LoadNamePtr", struct.pack(
        "<H", native.machine.offset("File_PANEL_ENC")))
    native.set_symbol("LoadDestSegment", struct.pack("<H", panel_segment))
    native.set_symbol("LoadDestOffset", b"\0\0")
    native.set_symbol("LoadImageSlot", struct.pack(
        "<H", native.machine.symbols["PANELIMAGEOFFSETS"][1]))
    native.set_symbol("LoadIsEnc", b"\1")
    registers = DosRegisters(0, _header_word("HOST_DATA_SEGMENT"))
    native.lib.load_graphics_record_images(ctypes.byref(registers))
    native.set_symbol("LoadIsEnc", b"\0")
    if native.get_symbol("FileStatus", 2) != b"\0\0":
        raise AssertionError("PANEL.ENC did not load from the mounted packaged archive")

    panel_offsets = native.physical_read(
        native.machine.linear("PanelImageOffsets") + 2 * 0x4E, 4)
    image_4e, image_4f = struct.unpack("<HH", panel_offsets)
    if image_4e == 0xFFFF or image_4f == 0xFFFF:
        raise AssertionError("PANEL.ENC omitted calibration overlay images 4E/4F")
    for image_offset in (image_4e, image_4f):
        rows, width = struct.unpack("<HH", native.physical_read(
            (panel_segment << 4) + image_offset, 4))
        if rows == 0 or width == 0:
            raise AssertionError(f"PANEL.ENC image at {image_offset:04X} is empty")


def _test_hiscore_hardware_graphics_mode(native: NativeFixture) -> int:
    row = 6
    native.lib.presentation_text_set_cursor.argtypes = (ctypes.c_uint16, ctypes.c_uint16)
    native.lib.presentation_text_set_cursor.restype = None
    native.lib.presentation_print_dos_string_at_bp.argtypes = (ctypes.c_uint16,)
    native.lib.presentation_print_dos_string_at_bp.restype = None

    for adapter in (0, 1, 2):
        _prepare_calibration_assets(native, adapter)
        native.set_symbol("HiscoreEntryRow", bytes((row,)))
        native.set_symbol("TextInGraphics", b"\1")
        mode_regs = HostRegisters()
        native.lib.overkill_platform_call(
            _token("STARTUPSETSELECTEDVIDEOMODE"), ctypes.byref(mode_regs))
        if native.lib.presentation_text_mode_active() != 0:
            raise AssertionError("graphics mode setup left the text presenter active")
        _fill_graphics(native, adapter, 0xFF)

        # DOS AH=09 emits the ten-space string in the current graphics mode.
        # Isolate that native leaf first to check its exact 80x8 pixel footprint.
        native.lib.presentation_text_set_cursor(row, 0)
        before = _snapshot_graphics(native, adapter)
        expected = _apply_blank_glyph_footprint(before, adapter, row)
        native.lib.presentation_print_dos_string_at_bp(
            _header_word("HOST_OFFSET_HISCOREBLANKLINE"))
        actual = _snapshot_graphics(native, adapter)
        if actual != expected:
            first = next((index for index, (left, right) in enumerate(zip(actual, expected))
                          if left != right), None)
            raise AssertionError(
                f"adapter {adapter} high-score blankline framebuffer mismatch at {first}")
        if native.lib.presentation_text_mode_active() != 0:
            raise AssertionError(
                f"adapter {adapter} graphics-mode DOS output switched to text mode")
        actual_row, actual_column = ctypes.c_uint16(), ctypes.c_uint16()
        native.lib.presentation_text_get_cursor(ctypes.byref(actual_row),
                                                ctypes.byref(actual_column))
        if (actual_row.value, actual_column.value) != (row, 10):
            raise AssertionError(
                f"adapter {adapter} DOS blankline cursor ended at "
                f"{actual_row.value},{actual_column.value}, expected {row},10")

        # Exercise the complete real C/DOS service path with PANEL.ENC loaded.
        registers = HostRegisters()
        native.lib.overkill_platform_call(
            _token("HISCOREENTRYHARDWARE"), ctypes.byref(registers))
        if native.lib.presentation_text_mode_active() != 0:
            raise AssertionError(
                f"adapter {adapter} high-score hardware service switched to text mode")

    native.lib.overkill_video_services_shutdown()
    native.lib.overkill_resource_mount_drive(b"C", None)
    return 3 * 3


def _calibration_idle_script(native: NativeFixture, probe, *, abort: bool = False):
    low = (1000, 1200)
    high = (3000, 3200)
    center = (2000, 2200)
    state = SimpleNamespace(
        now=int(native.lib.overkill_clock_now_ns()), calls=0, stage=0,
        retraces=0, button_down=False, samples=[], panels=[], page_frames=[],
        panel_frames=[], errors=[], escape_sent=False)
    state.axes = (low, high, center)
    native.lib.overkill_clock_reset(state.now)
    native.lib.overkill_set_input_sample(*low, 0xFF)

    wait_token = _token("WAITVERTICALRETRACE")
    axis_token = _token("READGAMEPORTAAXISCOUNTS")
    blit_token = _token("BLITPACKEDTOSCREEN")
    panel_token = _token("DRAWPANELATPOSITION")

    @TraceCallback
    def trace(token: int, registers) -> None:
        try:
            if token == wait_token:
                state.retraces += 1
            elif token == axis_token:
                state.samples.append((registers.contents.bx, registers.contents.cx))
            elif token == blit_token:
                screen = struct.unpack("<H", native.get_symbol("ScreenSegment", 2))[0]
                state.page_frames.append(native.physical_read(screen << 4, 0x8000))
            elif token == panel_token:
                regs = registers.contents
                state.panels.append((regs.dx, regs.si))
                screen = struct.unpack("<H", native.get_symbol("ScreenSegment", 2))[0]
                state.panel_frames.append(native.physical_read(screen << 4, 0x8000))
                state.stage = 1 if regs.si == 0x4E else 2
        except BaseException as error:
            state.errors.append(error)

    @IdleCallback
    def idle() -> None:
        state.calls += 1
        try:
            if abort:
                if not state.escape_sent and state.retraces >= 25:
                    _pump_event(native, probe, 15, down=True, release=False)
                    state.escape_sent = True
            else:
                # The next primary press starts only after the initial release
                # and each 25-retrace release wait. Its sample remains live until
                # the following cooperative poll observes the button release.
                next_press = (state.stage + 1) * 25
                axis = state.axes[state.stage]
                if state.button_down:
                    native.lib.overkill_set_input_sample(*axis, 0xFF)
                    state.button_down = False
                elif state.retraces >= next_press:
                    native.lib.overkill_set_input_sample(*axis, 0xEF)
                    state.button_down = True
            state.now += 1_000_000
            native.lib.overkill_clock_advance(state.now)
        except BaseException as error:
            state.errors.append(error)

    return idle, trace, state


def _test_calibration_services(native: NativeFixture, probe) -> int:
    _prepare_calibration_assets(native)
    screen_segment = struct.unpack("<H", native.get_symbol("ScreenSegment", 2))[0]
    native.physical_write(screen_segment << 4, bytes(0x8000))
    sentinel_words = (
        ("JoyCalLowX", 0xEEEE), ("JoyCalLowY", 0xEEEE),
        ("JoyCalHighX", 0xEEEE), ("JoyCalHighY", 0xEEEE),
        ("JoyCalCenterX", 0xEEEE), ("JoyCalCenterY", 0xEEEE),
        ("JoyXLowThreshold", 0xEEEE), ("JoyXHighThreshold", 0xEEEE),
        ("JoyYLowThreshold", 0xEEEE), ("JoyYHighThreshold", 0xEEEE),
    )
    for name, value in sentinel_words:
        native.set_symbol(name, struct.pack("<H", value))
    native.set_symbol("JoyCalibratingFlag", b"\0\0")
    native.set_symbol("JoyCalUnusedByte", b"\xff")
    native.set_symbol("InputDeviceMode", b"\0\0")

    idle, trace, state = _calibration_idle_script(native, probe)
    _bind_idle(native, idle)
    native.lib.overkill_platform_bind_trace(ctypes.cast(trace, ctypes.c_void_p))
    registers = DosRegisters(0, _header_word("HOST_DATA_SEGMENT"))
    try:
        result = probe.ui_run_calibration(ctypes.byref(registers), idle)
    finally:
        _bind_idle(native, None)
        native.lib.overkill_platform_bind_trace(None)
        native.lib.overkill_clear_input_sample()
    if state.errors:
        raise AssertionError(f"calibration native service callback failed: {state.errors[0]}")
    if result != 0:
        raise AssertionError(f"successful calibration did not return normally (bridge result {result})")
    expected_words = {
        "JoyCalLowX": 1000, "JoyCalLowY": 1200,
        "JoyCalHighX": 3000, "JoyCalHighY": 3200,
        "JoyCalCenterX": 2000, "JoyCalCenterY": 2200,
        "JoyXLowThreshold": 1500, "JoyXHighThreshold": 2500,
        "JoyYLowThreshold": 1700, "JoyYHighThreshold": 2700,
    }
    for name, expected in expected_words.items():
        actual = struct.unpack("<H", native.get_symbol(name, 2))[0]
        if actual != expected:
            raise AssertionError(f"calibration stored {name}={actual}, expected {expected}")
    if native.get_symbol("InputDeviceMode", 2) != b"\1\0":
        raise AssertionError("successful calibration did not retain joystick input mode")
    if native.get_symbol("JoyCalibratingFlag", 2) != b"\1\0" or \
            native.get_symbol("JoyCalUnusedByte", 1) != b"\0":
        raise AssertionError("successful calibration did not retain its original flag bytes")
    if state.samples != [(1000, 1200), (3000, 3200), (2000, 2200)]:
        raise AssertionError(f"calibration axis service sequence was {state.samples!r}")
    if state.panels != [(0x5501, 0x4E), (0x7D01, 0x4F)]:
        raise AssertionError(f"calibration overlays were {state.panels!r}")
    if state.retraces != 75:
        raise AssertionError(f"calibration delivered {state.retraces} retraces; expected 3 * 25")
    if len(state.page_frames) != 1 or not any(state.page_frames[0]):
        raise AssertionError("CALIB.ENC did not produce a nonblank native framebuffer page")
    final_frame = native.physical_read(screen_segment << 4, 0x8000)
    if (len(state.panel_frames) != 2 or
            state.panel_frames[0] == state.page_frames[0] or
            state.panel_frames[1] == state.panel_frames[0] or
            final_frame != state.panel_frames[1]):
        raise AssertionError("calibration 4E/4F overlays did not update the native framebuffer in order")

    success_sample_count = len(state.samples)
    success_panel_count = len(state.panels)
    success_retrace_count = state.retraces

    # Reinitialize the same real archive and native buffers for the abort case.
    # This keeps the archive cursor and DS game state canonical between flows.
    _prepare_calibration_assets(native)
    screen_segment = struct.unpack("<H", native.get_symbol("ScreenSegment", 2))[0]
    for name, value in sentinel_words:
        native.set_symbol(name, struct.pack("<H", value))
    native.set_symbol("JoyCalibratingFlag", b"\0\0")
    native.set_symbol("JoyCalUnusedByte", b"\xff")
    native.set_symbol("InputDeviceMode", b"\0\0")
    native.set_symbol("KeyDownTable", bytes(0x60))
    native.physical_write(screen_segment << 4, bytes(0x8000))
    idle, trace, state = _calibration_idle_script(native, probe, abort=True)
    _bind_idle(native, idle)
    native.lib.overkill_platform_bind_trace(ctypes.cast(trace, ctypes.c_void_p))
    try:
        result = probe.ui_run_calibration(ctypes.byref(registers), idle)
    finally:
        _bind_idle(native, None)
        native.lib.overkill_platform_bind_trace(None)
        native.lib.overkill_clear_input_sample()
    if state.errors:
        raise AssertionError(f"calibration Esc callback failed: {state.errors[0]}")
    if result != 0 or not state.escape_sent:
        raise AssertionError(f"Escape did not abort calibration normally (result {result})")
    if native.get_symbol("InputDeviceMode", 2) != b"\0\0":
        raise AssertionError("Escape did not restore keyboard input mode")
    if native.get_symbol("JoyCalibratingFlag", 2) != b"\1\0" or \
            native.get_symbol("JoyCalUnusedByte", 1) != b"\0":
        raise AssertionError("Escape path changed calibration flag bytes unexpectedly")
    for name, _value in sentinel_words:
        if native.get_symbol(name, 2) != b"\xee\xee":
            raise AssertionError(f"Escape before the first sample changed {name}")
    if state.samples or state.panels or state.retraces != 25:
        raise AssertionError("Escape abort crossed an initial sample/panel/retrace boundary")
    if len(state.page_frames) != 1 or not any(state.page_frames[0]):
        raise AssertionError("Escape calibration did not load/render CALIB.ENC first")

    # WaitTimerTick exercises cooperative timer delivery without binding or
    # asserting module/SFX callbacks.
    native.lib.overkill_clock_bind(None, None)
    native.lib.overkill_clock_reset(state.now)
    regs = HostRegisters()
    native.lib.overkill_platform_call(_token("CLEARTIMERTICK"), ctypes.byref(regs))
    idle, timer_state = _virtual_idle(native, probe)
    _bind_idle(native, idle)
    try:
        native.lib.overkill_platform_call(_token("WAITTIMERTICK"), ctypes.byref(regs))
    finally:
        _bind_idle(native, None)
    if timer_state.error:
        raise AssertionError(f"timer idle pump failed: {timer_state.error}")
    if not native.lib.overkill_clock_frame_ready() or timer_state.calls == 0:
        raise AssertionError("WaitTimerTick returned without a cooperatively delivered timer frame")

    native.lib.overkill_video_services_shutdown()
    native.lib.overkill_resource_mount_drive(b"C", None)
    return (len(expected_words) * 2 + success_sample_count + success_panel_count +
            success_retrace_count + state.retraces + 2)


def _header_word(name: str) -> int:
    import re

    text = HOST_HEADER.read_text(encoding="ascii")
    match = re.search(rf"^#define\s+{name}\s+.*?0x([0-9A-Fa-f]+)", text, re.MULTILINE)
    if match is None:
        raise AssertionError(f"generated HOST_GEN.H is missing {name}")
    return int(match.group(1), 16)


def run(no_build: bool = False) -> int:
    if not no_build:
        raise ValueError("UI flow tests only use --no-build; rebuild the shared core separately")
    _verify_inputs()
    native = NativeFixture()
    with tempfile.TemporaryDirectory(prefix="overkill-ui-") as temp_name:
        probe_path = _compile_probe(Path(temp_name))
        probe, dll_directory = _install_probe(native, probe_path)
        try:
            checks = 0
            checks += _test_highscore_editor(native, probe)
            print("PASS high-score editor", flush=True)
            checks += _test_keypad_character_service(native, probe)
            print("PASS keypad character input", flush=True)
            checks += _test_quit_prompt_branches(native, probe, probe)
            print("PASS quit-prompt N/Y branches", flush=True)
            checks += _test_boss_key_restore(native, probe)
            print("PASS boss-key restore", flush=True)
            checks += _test_hiscore_hardware_graphics_mode(native)
            print("PASS high-score graphics-mode DOS output", flush=True)
            checks += _test_calibration_services(native, probe)
            print("PASS page-driven calibration success/Escape and timer services", flush=True)
            print(f"PASS host UI flows: {checks} live character, quit, boss-key, "
                  "native calibration-page, calibration-abort, and timer checks")
            return checks
        finally:
            _bind_idle(native, None)
            native.lib.overkill_platform_bind_trace(None)
            native.lib.overkill_sdl_flush_characters()
            native.lib.overkill_sdl_video_close()
            probe.ui_quit()
            _ = dll_directory


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="reuse the current native DLL and exact oracle")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
