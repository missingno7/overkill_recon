"""Native Tandy/CGA pixel-service checks against the exact DOS oracle.

Run ``python tests/host/rendering.py`` to build the host core and run the fixtures;
``--no-build`` reuses the host DLL. EGA page selection is compared for its CS state,
while the four-plane framebuffer is verified independently because the 16-bit emulator
does not emulate EGA latches or planar VRAM.
"""
from __future__ import annotations

import argparse
import ctypes
import importlib.util
import os
from pathlib import Path
import re
import struct
import sys

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
HOST_DIR = ROOT / "build/host"
HOST_CORE = HOST_DIR / ("OVERKILL_CORE.dll" if os.name == "nt"
                        else "liboverkill_core.so")
HOST_HEADER = HOST_DIR / "HOST_GEN.H"
ORACLE_EXE = ROOT / "build/oracle-sym/OVERKILL.EXE"
DOS_MEMORY_BYTES = 0x100000
WORKSPACE_SOURCE_SEGMENT = 0x7000
SCREEN_SEGMENT = 0xB800
SCREEN_OFFSET = 0x1800
MASK16 = 0xFFFF

sys.path.insert(0, str(TOOLS))
from emu import Machine  # noqa: E402


class CopyRequest(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in (
        "workspace_segment", "state_segment", "workspace_offset", "save_offset",
        "bytes_per_plane", "workspace_row_bytes", "rows", "planes", "to_workspace")]


class SpriteRequest(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in (
        "blitter", "source_segment", "source_offset", "workspace_segment",
        "workspace_offset", "rows")]


class PanelRequest(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in (
        "image_offset", "screen_offset", "source_segment", "state_segment")]


class FuelRequest(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in (
        "screen_segment", "screen_offset", "adapter", "full_bars", "empty_bars")]


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _bind_signatures(lib) -> None:
    lib.overkill_bind_real_memory.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_bind_real_memory.restype = ctypes.c_int
    lib.overkill_bind_state.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_bind_state.restype = ctypes.c_int
    lib.render_platform_copy_rows.argtypes = (ctypes.POINTER(CopyRequest),)
    lib.render_platform_copy_rows.restype = None
    lib.render_platform_draw_sprite.argtypes = (ctypes.POINTER(SpriteRequest),)
    lib.render_platform_draw_sprite.restype = ctypes.c_uint16
    lib.render_platform_blit_panel.argtypes = (ctypes.POINTER(PanelRequest),)
    lib.render_platform_blit_panel.restype = ctypes.c_uint32
    lib.render_platform_draw_fuel_bars.argtypes = (ctypes.POINTER(FuelRequest),)
    lib.render_platform_draw_fuel_bars.restype = ctypes.c_uint32
    lib.render_draw_stars.argtypes = ()
    lib.render_draw_stars.restype = None
    lib.render_erase_stars.argtypes = ()
    lib.render_erase_stars.restype = None
    lib.render_draw_fuel_gauge.argtypes = ()
    lib.render_draw_fuel_gauge.restype = ctypes.c_uint32
    lib.render_call_main.argtypes = (ctypes.c_uint16,)
    lib.render_call_main.restype = None
    lib.overkill_ega_plane_address.argtypes = (
        ctypes.c_uint16, ctypes.c_uint16, ctypes.c_uint16)
    lib.overkill_ega_plane_address.restype = ctypes.c_void_p
    lib.overkill_ega_copy_indexed_page.argtypes = (
        ctypes.c_uint16, ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_ega_copy_indexed_page.restype = None


def _host_layout() -> tuple[int, int]:
    header = HOST_HEADER.read_text(encoding="ascii")
    values = []
    for name in ("HOST_LOAD_SEGMENT", "HOST_DATA_LINEAR"):
        match = re.search(rf"^\s*#define\s+{name}\s+0x([0-9A-Fa-f]+)",
                          header, re.MULTILINE)
        if match is None:
            raise AssertionError(f"{HOST_HEADER} has no {name}")
        values.append(int(match.group(1), 16))
    return values[0], values[1]


def _token(name: str) -> int:
    header = HOST_HEADER.read_text(encoding="ascii")
    match = re.search(
        rf"^\s*#define\s+HOST_TOKEN_{re.escape(name)}\s+\(\(word\)0x([0-9A-Fa-f]+)\)",
        header, re.MULTILINE)
    if match is None:
        raise AssertionError(f"generated HOST_GEN.H is missing HOST_TOKEN_{name}")
    return int(match.group(1), 16)


class NativeArena:
    def __init__(self, lib) -> None:
        self.raw = ctypes.create_string_buffer(DOS_MEMORY_BYTES + 15)
        self.base = (ctypes.addressof(self.raw) + 15) & ~15
        self.lib = lib
        if not lib.overkill_bind_real_memory(self.base, DOS_MEMORY_BYTES):
            raise AssertionError("native core rejected the 1 MiB DOS arena")
        _load_segment, data_linear = _host_layout()
        if not lib.overkill_bind_state(self.base + data_linear, 0x10000):
            raise AssertionError("native core rejected DS placed in the DOS arena")

    def load(self, image: bytes) -> None:
        if len(image) != DOS_MEMORY_BYTES:
            raise ValueError("oracle memory snapshot must be exactly 1 MiB")
        ctypes.memmove(self.base, image, len(image))

    def snapshot(self) -> bytes:
        return ctypes.string_at(self.base, DOS_MEMORY_BYTES)


class RenderFixture:
    def __init__(self, lib, adapter: int) -> None:
        self.lib = lib
        self.m = Machine(ORACLE_EXE)
        self.m.start_runtime(adapter)
        self.arena = NativeArena(lib)
        self.stack_begin = self.m.data_frame * 16 + self.m.offset("StackArea")
        self.stack_end = self.m.data_frame * 16 + self.m.stack_top

    def cs_word(self, name: str, value: int) -> None:
        self.m.poke(name, value)

    def ds_word(self, name: str, value: int) -> None:
        self.m.set_word(self.m.offset(name), value)

    def segment_write(self, segment: int, offset: int, data: bytes) -> None:
        address = ((segment << 4) + offset) & 0xFFFFF
        ctypes.memmove(self.arena.base + address, data, len(data))
        self.m.u.mem_write(address, bytes(data))

    def physical_write(self, address: int, data: bytes) -> None:
        address &= 0xFFFFF
        ctypes.memmove(self.arena.base + address, data, len(data))
        self.m.u.mem_write(address, bytes(data))

    def _compare_memory(self, native: bytes, oracle: bytes, label: str,
                        ignored_ranges: tuple[tuple[int, int], ...] = ()) -> None:
        if len(native) != len(oracle):
            raise AssertionError(f"{label}: arena lengths differ")
        if native == oracle:
            return
        for address, (got, want) in enumerate(zip(native, oracle)):
            if (self.stack_begin <= address < self.stack_end or
                    any(begin <= address < end for begin, end in ignored_ranges)):
                continue
            if got != want:
                raise AssertionError(
                    f"{label}: physical {address:05X} native={got:02X}, ASM={want:02X}")

    def compare_native_to_oracle(self, label: str, native_call, oracle_call,
                                 expected_result: int | None = None,
                                 ignored_ranges: tuple[tuple[int, int], ...] = ()) -> None:
        before = bytes(self.m.u.mem_read(0, DOS_MEMORY_BYTES))
        self.arena.load(before)
        native_result = native_call()
        native_after = self.arena.snapshot()
        if expected_result is not None and native_result != expected_result:
            raise AssertionError(
                f"{label}: native result {native_result:08X} != {expected_result:08X}")

        self.m.u.mem_write(0, before)
        oracle_registers = oracle_call()
        oracle_after = bytes(self.m.u.mem_read(0, DOS_MEMORY_BYTES))
        self._compare_memory(native_after, oracle_after, label, ignored_ranges)
        return oracle_registers


def _request_copy(fx: RenderFixture, adapter: int) -> int:
    workspace = fx.m.peek("WorkspaceSegment")
    widths = {0: (3, 52), 2: (4, 104)}
    bytes_per_row, row_bytes = widths[adapter]
    save_offset = 0x6F00
    workspace_offset = 0x2F31
    source = bytes((i * 31 + adapter * 19 + 7) & 0xFF for i in range(bytes_per_row * 8))
    state_segment = fx.m.data_frame
    fx.m.write(save_offset, source)
    initial_workspace = bytes((i * 13 + 0x5B) & 0xFF for i in range(0x10000))
    fx.segment_write(workspace, 0, initial_workspace)
    request = CopyRequest(workspace, state_segment, workspace_offset,
                          save_offset, bytes_per_row, row_bytes, 8, 1, 1)

    def native():
        fx.lib.render_platform_copy_rows(ctypes.byref(request))
        return 0

    label = "RestoreBackground8Cga" if adapter == 0 else "RestoreBackground8Tandy"

    def oracle():
        return fx.m.call(label, {
            "SI": save_offset, "DI": workspace_offset,
            "ES": workspace,
        })

    regs = fx.compare_native_to_oracle(f"copy rows adapter {adapter}", native, oracle, 0)
    if regs["DS"] != state_segment or regs["ES"] != workspace:
        raise AssertionError(f"{label}: unexpected DS/ES {regs['DS']:04X}/{regs['ES']:04X}")
    return 1


def _request_sprite(fx: RenderFixture, adapter: int) -> int:
    workspace = fx.m.peek("WorkspaceSegment")
    source_segment = fx.m.data_frame
    cases = []
    for width in (8, 16, 32):
        for phase in (range(4) if adapter == 0 else (0,)):
            cases.append((width, phase, False))
            if width != 8:
                cases.append((width, phase, True))

    for index, (width, phase, flash) in enumerate(cases):
        rows = 8 if width == 8 else 16
        stride = width // 2 if adapter == 0 else width
        source_offset = 0x4200 + index * 0x100
        dest_offset = 0x3217
        sprite = bytes((i * 43 + 0x93 + adapter * 17 + index * 29) & 0xFF
                       for i in range(stride * rows))
        fx.m.write(source_offset, sprite)
        fx.segment_write(workspace, 0,
                         bytes((i * 17 + 0x2D + index * 7) & 0xFF
                               for i in range(0x10000)))
        prefix = "FLASH" if flash else "DRAW"
        if adapter == 0:
            token_name = f"{prefix}SPRITE{width}SHIFT{phase}CGA"
            label = f"{prefix.title()}Sprite{width}Shift{phase}Cga"
        else:
            token_name = f"{prefix}SPRITE{width}TANDY"
            label = f"{prefix.title()}Sprite{width}Tandy"
        request = SpriteRequest(_token(token_name), source_segment, source_offset,
                                workspace, dest_offset, rows)

        def native():
            return int(fx.lib.render_platform_draw_sprite(ctypes.byref(request)))

        def oracle():
            return fx.m.call(label, {
                "SI": source_offset, "DI": dest_offset, "CX": rows, "BP": rows,
                "ES": workspace,
            })

        name = f"sprite adapter {adapter} width {width} phase {phase} flash {flash}"
        ignored = ()
        if adapter == 0 and width == 32 and phase != 0:
            # The original shift kernels use this private carry-spill scratch byte;
            # the native per-pixel path has no need to touch it.
            spill = fx.m.linear("SpriteShiftSpill")
            ignored = ((spill, spill + 1),)
        regs = fx.compare_native_to_oracle(name, native, oracle, rows, ignored)
        if regs["DS"] != fx.m.peek("MainDataSegment") or regs["ES"] != workspace:
            raise AssertionError(f"{label}: unexpected exit DS/ES {regs['DS']:04X}/{regs['ES']:04X}")
    return len(cases)


def _request_panel(fx: RenderFixture, adapter: int) -> int:
    rows = 3
    width_units = 3
    stride = width_units * (2 if adapter == 0 else 4)
    image_offset = 0x3500
    payload = struct.pack("<HH", rows, width_units) + bytes(
        (i * 53 + adapter * 7 + 0x21) & 0xFF for i in range(rows * stride))
    fx.cs_word("VideoAdapter", adapter)
    fx.cs_word("ScreenSegment", SCREEN_SEGMENT)
    source_segment = fx.m.data_frame
    fx.m.write(image_offset, payload)
    screen_start = (SCREEN_SEGMENT << 4)
    fx.physical_write(screen_start, bytes((i * 11 + 0x69) & 0xFF for i in range(0x10000)))
    screen_offset = SCREEN_OFFSET
    request = PanelRequest(image_offset, screen_offset,
                           source_segment, fx.m.peek("MainDataSegment"))

    def native():
        return int(fx.lib.render_platform_blit_panel(ctypes.byref(request)))

    def oracle():
        return fx.m.call("BlitPackedToScreen", {
            "SI": image_offset, "DI": screen_offset,
        })

    regs = fx.compare_native_to_oracle(f"packed panel adapter {adapter}", native, oracle)
    expected = ((regs["ES"] << 16) | regs["SI"]) & 0xFFFFFFFF
    # Read the C result a second time from an identical starting snapshot so that the
    # return pair is checked alongside the exact memory image above.
    before = bytes(fx.m.u.mem_read(0, DOS_MEMORY_BYTES))
    fx.arena.load(before)
    native_result = int(fx.lib.render_platform_blit_panel(ctypes.byref(request)))
    if native_result != expected:
        raise AssertionError(
            f"packed panel adapter {adapter}: DX:AX={native_result:08X}, ES:SI={expected:08X}")
    return 1


def _fuel_case(fx: RenderFixture, adapter: int) -> int:
    fx.cs_word("ScreenSegment", SCREEN_SEGMENT)
    fx.ds_word("Fuel", 0x16)
    fx.ds_word("RefuelActive", 0)
    fx.m.write(fx.m.offset("SfxEnabled"), b"\x01")
    fx.m.write(fx.m.offset("SfxRequest"), b"\x55")
    step = 2 if adapter == 0 else 4
    row_table = fx.m.offset("ScreenRowOffsets")
    base = (0x2000 if adapter == 0 else 0x3000)
    fx.m.set_word(row_table + 2 * 0x5F, base)
    start = (base + 0x1D * step) & MASK16
    fx.physical_write(SCREEN_SEGMENT << 4,
                      bytes((i * 23 + adapter * 41 + 3) & 0xFF for i in range(0x10000)))

    def native():
        return int(fx.lib.render_draw_fuel_gauge())

    def oracle():
        return fx.m.call("DrawFuelGauge")

    regs = fx.compare_native_to_oracle(f"fuel gauge adapter {adapter}", native, oracle)
    expected = ((regs["ES"] << 16) | regs["DI"]) & 0xFFFFFFFF
    if regs["DI"] == start:
        raise AssertionError("fuel fixture did not advance through any bars")
    before = bytes(fx.m.u.mem_read(0, DOS_MEMORY_BYTES))
    fx.arena.load(before)
    native_result = int(fx.lib.render_draw_fuel_gauge())
    if native_result != expected:
        raise AssertionError(
            f"fuel gauge adapter {adapter}: DX:AX={native_result:08X}, ES:DI={expected:08X}")
    return 1


def _stars_case(fx: RenderFixture, adapter: int) -> int:
    workspace = fx.m.peek("WorkspaceSegment")
    fx.segment_write(workspace, 0, bytes(0x10000))
    stars = fx.m.offset("Stars")
    for index in range(40):
        base = stars + index * 6
        fx.m.set_word(base, 0)
        fx.m.set_word(base + 2, 0x100 + index * 0x80)
        fx.m.set_word(base + 4, (0x81 + index * 13) & 0xFF)

    def draw_native():
        fx.lib.render_draw_stars()
        return 0

    fx.compare_native_to_oracle(
        f"stars draw adapter {adapter}", draw_native,
        lambda: fx.m.call("DrawStars"), 0)

    def erase_native():
        fx.lib.render_erase_stars()
        return 0

    fx.compare_native_to_oracle(
        f"stars erase adapter {adapter}", erase_native,
        lambda: fx.m.call("EraseStars"), 0)
    return 2


def _flip_case(lib) -> int:
    fx = RenderFixture(lib, 1)
    fx.cs_word("VideoAdapter", 1)
    fx.cs_word("ScreenSegment", 0xA000)
    fx.cs_word("EgaPageToggle", 0)
    token = _token("FLIPEGADRAWPAGE")
    fx.compare_native_to_oracle(
        "EGA page flip CS state", lambda: (lib.render_call_main(token), 0)[1],
        lambda: fx.m.call("FlipEgaDrawPage"), 0)
    if fx.m.peek("EgaPageToggle") != 1 or fx.m.peek("ScreenSegment") != 0xA200:
        raise AssertionError("first EGA page flip did not select A200h")

    before = bytes(fx.m.u.mem_read(0, DOS_MEMORY_BYTES))
    fx.arena.load(before)
    lib.render_call_main(token)
    native_after = fx.arena.snapshot()
    fx.m.u.mem_write(0, before)
    fx.m.call("FlipEgaDrawPage")
    fx._compare_memory(native_after, bytes(fx.m.u.mem_read(0, DOS_MEMORY_BYTES)),
                       "second EGA page flip CS state")
    if fx.m.peek("EgaPageToggle") != 0 or fx.m.peek("ScreenSegment") != 0xA000:
        raise AssertionError("second EGA page flip did not select A000h")
    return 2


def _ega_plane_case(lib) -> int:
    width = 320
    height = 200
    pitch = 337
    checks = 0
    for page_index, segment in enumerate((0xA000, 0xA200)):
        planes = []
        for plane in range(4):
            pointer = lib.overkill_ega_plane_address(segment, plane, 0)
            if pointer is None:
                raise AssertionError("EGA plane accessor returned null")
            plane_view = (ctypes.c_uint8 * 8000).from_address(pointer)
            planes.append(plane_view)
            for offset in range(8000):
                plane_view[offset] = (page_index * 37 + plane * 61 + offset * 17) & 0xFF
            checks += 1

        output = (ctypes.c_uint8 * (pitch * height))()
        ctypes.memset(ctypes.addressof(output), 0xD6, ctypes.sizeof(output))
        lib.overkill_ega_copy_indexed_page(segment, output, pitch)
        for y in range(height):
            for x in range(width):
                byte_offset = y * 40 + x // 8
                bit = 0x80 >> (x & 7)
                expected = 0
                for plane, plane_view in enumerate(planes):
                    if plane_view[byte_offset] & bit:
                        expected |= 1 << plane
                if output[y * pitch + x] != expected:
                    raise AssertionError(
                        f"EGA plane composition page {page_index} pixel {x},{y}: "
                        f"{output[y * pitch + x]} != {expected}")
                checks += 1
            if bytes(output[y * pitch + width:y * pitch + pitch]) != bytes([0xD6]) * (pitch - width):
                raise AssertionError("EGA composition wrote into row padding")
            checks += 1
    return checks


def run(no_build: bool = False) -> int:
    if no_build:
        if not HOST_CORE.is_file() or not HOST_HEADER.is_file():
            raise FileNotFoundError("--no-build requires the current host DLL and HOST_GEN.H")
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    if not ORACLE_EXE.is_file():
        raise FileNotFoundError(f"exact oracle is missing: {ORACLE_EXE}")
    harness = _load_module("host_input_rendering_harness", ROOT / "tests/host/input.py")
    harness._verify_exact_oracle()
    dll_directory = os.add_dll_directory(str(HOST_DIR)) if os.name == "nt" else None
    try:
        lib = ctypes.CDLL(str(HOST_CORE))
        _bind_signatures(lib)
        checks = 0
        for adapter in (0, 2):
            fx = RenderFixture(lib, adapter)
            checks += _request_copy(fx, adapter)
            checks += _request_sprite(fx, adapter)
            checks += _request_panel(fx, adapter)
            checks += _stars_case(fx, adapter)
            checks += _fuel_case(fx, adapter)
        checks += _flip_case(lib)
        ega_checks = _ega_plane_case(lib)
    finally:
        if dll_directory is not None:
            dll_directory.close()

    print(f"PASS host rendering: {checks} CGA/Tandy oracle fixtures, "
          f"{ega_checks} independent EGA plane/page checks")
    return checks + ega_checks


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="reuse the current build/host and exact oracle")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
