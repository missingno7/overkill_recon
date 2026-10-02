"""Bounded differential checks for native DOS video services.

The oracle runs the exact 16-bit routines in Unicorn. The host DLL reuses the same
1 MiB physical arena and a paragraph allocator bound to the oracle's heap. EGA planes
are checked through the native plane accessor because Unicorn's flat A000 aperture
does not model planar VRAM.

Run ``python tests/host/video_services.py --no-build`` to use the current host DLL.
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
HEAP_FIRST_SEGMENT = 0x4000
HEAP_PARAGRAPHS = 0x6000
MAP_SEGMENT = 0x7000
MASK16 = 0xFFFF
EGA_ARENA = (0xA0000, 0xB0000)

sys.path.insert(0, str(TOOLS))
import emu  # noqa: E402
from emu import Machine  # noqa: E402


class HostRegisters(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in
                ("ax", "bx", "cx", "dx", "si", "di", "bp", "es")]


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def _token(name: str) -> int:
    header = HOST_HEADER.read_text(encoding="ascii")
    match = re.search(
        rf"^\s*#define\s+HOST_TOKEN_{re.escape(name)}\s+\(\(word\)0x([0-9A-Fa-f]+)\)",
        header, re.MULTILINE)
    if match is None:
        raise AssertionError(f"generated HOST_GEN.H is missing HOST_TOKEN_{name}")
    return int(match.group(1), 16)


def _host_layout() -> int:
    header = HOST_HEADER.read_text(encoding="ascii")
    match = re.search(r"^\s*#define\s+HOST_DATA_LINEAR\s+0x([0-9A-Fa-f]+)",
                      header, re.MULTILINE)
    if match is None:
        raise AssertionError(f"{HOST_HEADER} has no HOST_DATA_LINEAR")
    return int(match.group(1), 16)


def _bind_signatures(lib) -> None:
    lib.overkill_bind_real_memory.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_bind_real_memory.restype = ctypes.c_int
    lib.overkill_bind_state.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_bind_state.restype = ctypes.c_int
    lib.overkill_bind_level_map.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_bind_level_map.restype = ctypes.c_int
    lib.overkill_segment_address.argtypes = (ctypes.c_uint16, ctypes.c_uint16)
    lib.overkill_segment_address.restype = ctypes.c_void_p
    lib.overkill_resource_services_bind_arena.argtypes = (
        ctypes.c_uint16, ctypes.c_uint16)
    lib.overkill_resource_services_bind_arena.restype = ctypes.c_int
    lib.overkill_dos_set_allocation_strategy.argtypes = (ctypes.c_uint16,)
    lib.overkill_dos_set_allocation_strategy.restype = ctypes.c_int
    lib.overkill_video_service.argtypes = (
        ctypes.c_uint16, ctypes.POINTER(HostRegisters))
    lib.overkill_video_service.restype = ctypes.c_int
    lib.overkill_video_services_shutdown.argtypes = ()
    lib.overkill_video_services_shutdown.restype = None
    lib.host_draw_map_row_into_scroll_band.argtypes = (ctypes.c_uint16,)
    lib.host_draw_map_row_into_scroll_band.restype = None
    lib.overkill_ega_plane_address.argtypes = (
        ctypes.c_uint16, ctypes.c_uint16, ctypes.c_uint16)
    lib.overkill_ega_plane_address.restype = ctypes.c_void_p


class NativeArena:
    def __init__(self, lib) -> None:
        self.raw = ctypes.create_string_buffer(DOS_MEMORY_BYTES + 15)
        self.base = (ctypes.addressof(self.raw) + 15) & ~15
        if not lib.overkill_bind_real_memory(self.base, DOS_MEMORY_BYTES):
            raise AssertionError("native core rejected the 1 MiB DOS arena")
        if not lib.overkill_bind_state(self.base + _host_layout(), 0x10000):
            raise AssertionError("native core rejected the DS window")
        map_address = (MAP_SEGMENT << 4) & 0xFFFFF
        if not lib.overkill_bind_level_map(self.base + map_address, 0x10000):
            raise AssertionError("native core rejected the level-map window")

    def load(self, image: bytes) -> None:
        if len(image) != DOS_MEMORY_BYTES:
            raise ValueError("oracle memory snapshot must be exactly 1 MiB")
        ctypes.memmove(self.base, image, DOS_MEMORY_BYTES)

    def snapshot(self) -> bytes:
        return ctypes.string_at(self.base, DOS_MEMORY_BYTES)


class VideoMachine(Machine):
    def __init__(self, exe: Path) -> None:
        self.alloc_requests: list[int] = []
        self.port_script: list[int] = []
        self.script_reads = 0
        super().__init__(exe)

    def _interrupt(self, u, number, user_data):
        ax = u.reg_read(emu.REG["AX"])
        if number == 0x21 and ax >> 8 == 0x48:
            self.alloc_requests.append(u.reg_read(emu.REG["BX"]))
        return super()._interrupt(u, number, user_data)

    def _port_in(self, u, port, size, user_data):
        self.ports.append(("in", port))
        if port == 0x3DA and self.port_script:
            self.script_reads += 1
            return self.port_script.pop(0)
        return 0


class VideoFixture:
    def __init__(self, lib, adapter: int) -> None:
        self.lib = lib
        self.m = VideoMachine(ORACLE_EXE)
        self.m.poke("VideoAdapter", adapter)
        self.arena = NativeArena(lib)
        self.stack_begin = self.m.data_frame * 16 + self.m.offset("StackArea")
        self.stack_end = self.m.data_frame * 16 + self.m.stack_top

    def ds_word(self, name: str, value: int) -> None:
        self.m.set_word(self.m.offset(name), value)

    def cs_word(self, name: str, value: int) -> None:
        self.m.poke(name, value)

    def segment_write(self, segment: int, offset: int, data: bytes) -> None:
        address = ((segment << 4) + offset) & 0xFFFFF
        self.m.u.mem_write(address, data)

    def physical_write(self, address: int, data: bytes) -> None:
        self.m.u.mem_write(address & 0xFFFFF, data)

    def segment_read(self, image: bytes, segment: int, offset: int, count: int) -> bytes:
        first = (segment << 4) & 0xFFFFF
        return bytes(image[(first + ((offset + i) & MASK16)) & 0xFFFFF]
                     for i in range(count))

    def _compare_memory(self, native: bytes, oracle: bytes, label: str,
                        ignored_ranges: tuple[tuple[int, int], ...] = ()) -> None:
        if len(native) != len(oracle):
            raise AssertionError(f"{label}: arena lengths differ")
        if native == oracle:
            return
        actual = bytearray(native)
        expected = bytearray(oracle)
        for start, end in ((self.stack_begin, self.stack_end),) + ignored_ranges:
            actual[start:end] = bytes(end - start)
            expected[start:end] = bytes(end - start)
        if actual == expected:
            return
        for address, (got, want) in enumerate(zip(actual, expected)):
            if got != want:
                raise AssertionError(
                    f"{label}: physical {address:05X} native={got:02X}, ASM={want:02X}")

    def call_service(self, label: str, token_name: str,
                     es: int = 0x4567,
                     ignored_ranges: tuple[tuple[int, int], ...] = ()):
        context = f"{label} adapter {self.m.peek('VideoAdapter')}"
        before = bytes(self.m.u.mem_read(0, DOS_MEMORY_BYTES))
        self.arena.load(before)
        regs = HostRegisters(0x1357, 0x2468, 0x369C, 0x48AD,
                             0x5BCE, 0x6DEF, 0x7123, es)
        if not self.lib.overkill_video_service(_token(token_name), ctypes.byref(regs)):
            raise AssertionError(f"native video service did not handle {token_name}")
        native_after = self.arena.snapshot()
        native_es = regs.es

        self.m.u.mem_write(0, before)
        oracle_regs = self.m.call(label, {"ES": es})
        oracle_after = bytes(self.m.u.mem_read(0, DOS_MEMORY_BYTES))
        self._compare_memory(native_after, oracle_after, context, ignored_ranges)
        if native_es != oracle_regs["ES"]:
            raise AssertionError(
                f"{context}: native ES={native_es:04X}, ASM ES={oracle_regs['ES']:04X}")
        return native_after, oracle_after, native_es, oracle_regs

    def call_direct_map_hook(self, label: str, row_offset: int) -> None:
        before = bytes(self.m.u.mem_read(0, DOS_MEMORY_BYTES))
        self.arena.load(before)
        self.lib.host_draw_map_row_into_scroll_band(row_offset & MASK16)
        native_after = self.arena.snapshot()
        self.m.u.mem_write(0, before)
        oracle_regs = self.m.call("DrawMapRowIntoScrollBand")
        oracle_after = bytes(self.m.u.mem_read(0, DOS_MEMORY_BYTES))
        self._compare_memory(native_after, oracle_after, label)
        if oracle_regs["ES"] != self.m.peek("WorkspaceSegment"):
            raise AssertionError(f"{label}: oracle did not leave ES at WorkspaceSegment")

    def close(self) -> None:
        self.lib.overkill_video_services_shutdown()


def _fill_pattern(length: int, seed: int, multiplier: int = 37) -> bytes:
    return bytes((i * multiplier + seed) & 0xFF for i in range(length))


def _start_native_heap(fx: VideoFixture) -> None:
    if not fx.lib.overkill_resource_services_bind_arena(
            HEAP_FIRST_SEGMENT, HEAP_PARAGRAPHS):
        raise AssertionError("native resource allocator rejected the DOS heap")
    if not fx.lib.overkill_dos_set_allocation_strategy(0):
        raise AssertionError("native resource allocator rejected first-fit mode")


def _allocate_and_build_tables(fx: VideoFixture, adapter: int) -> int:
    _start_native_heap(fx)
    fx.m.alloc_requests.clear()
    native_after, _, _, regs = fx.call_service("AllocateBuffers", "ALLOCATEBUFFERS")
    requests = tuple(fx.m.alloc_requests)
    if len(requests) != 12:
        raise AssertionError(f"AllocateBuffers made {len(requests)} DOS allocations, expected 12")

    segment_names = (
        "WorkspaceSegment", "Sprites1x1Segment", "Sprites2x2Segment",
        "Sprites2x2CSegment", "LevelSpritesSegment", "ManExplSegment",
        "TheEndSegment", "PanelSegment", "PlaqueSegment", "BlueBitsSegment",
        "LevelBlocksSegment", "ShipSegment",
    )
    previous_end = HEAP_FIRST_SEGMENT
    for name, paragraphs in zip(segment_names, requests):
        segment = fx.m.peek(name)
        native_address = fx.m.linear(name)
        native_segment = struct.unpack_from("<H", native_after, native_address)[0]
        if segment != previous_end:
            raise AssertionError(
                f"{name}: oracle allocation {segment:04X}h is not first-fit after {previous_end:04X}h")
        if native_segment != previous_end:
            raise AssertionError(
                f"{name}: native allocation {native_segment:04X}h is not first-fit after {previous_end:04X}h")
        previous_end = (previous_end + paragraphs) & MASK16
    total = sum(requests) & MASK16
    if fx.m.peek("AllocatedParagraphs") != total:
        raise AssertionError(
            f"AllocateBuffers total {fx.m.peek('AllocatedParagraphs'):04X}h != DOS groups {total:04X}h")
    if regs["ES"] != fx.m.peek("MainDataSegment"):
        raise AssertionError("AllocateBuffers did not leave ES at MainDataSegment")

    fx.call_service("BuildRowTables", "BUILDROWTABLES")
    checks = 2
    # The table builder tail-calls ClearWorkspace; also exercise both documented clear sizes.
    for half_only in (0, 1):
        fx.ds_word("ClearWorkspaceHalfOnly", half_only)
        workspace = fx.m.peek("WorkspaceSegment")
        fx.segment_write(workspace, 0, _fill_pattern(0x10000, 0x71 + adapter + half_only))
        native_after, _, _, _ = fx.call_service("ClearWorkspace", "CLEARWORKSPACE")
        image = native_after
        bytes_to_clear = 0x8000 if half_only else 0x10000
        cleared = fx.segment_read(image, workspace, 0, bytes_to_clear)
        if cleared != bytes(bytes_to_clear):
            raise AssertionError(f"ClearWorkspace half_only={half_only} did not clear its range")
        checks += 1
    fx.ds_word("ClearWorkspaceHalfOnly", 0)
    return checks


def _allocation_cases(lib) -> int:
    checks = 0
    for adapter in (0, 1, 2):
        fx = VideoFixture(lib, adapter)
        try:
            checks += _allocate_and_build_tables(fx, adapter)
        finally:
            fx.close()
    return checks


def _ega_planes(lib) -> list[ctypes.Array]:
    views = []
    for plane in range(4):
        pointer = lib.overkill_ega_plane_address(0xA000, plane, 0)
        if pointer is None:
            raise AssertionError("EGA plane accessor returned null")
        views.append((ctypes.c_uint8 * 0x12000).from_address(pointer))
    return views


def _seed_screen_and_workspace(fx: VideoFixture, seed: int) -> tuple[bytes, bytes]:
    workspace = fx.m.peek("WorkspaceSegment")
    screen = fx.m.peek("ScreenSegment")
    workspace_data = _fill_pattern(0x10000, seed, 29)
    screen_data = _fill_pattern(0x10000, seed ^ 0xA5, 43)
    fx.segment_write(workspace, 0, workspace_data)
    fx.segment_write(screen, 0, screen_data)
    return workspace_data, screen_data


def _seed_ega_planes(lib, seed: int) -> tuple[list[ctypes.Array], list[bytes]]:
    views = _ega_planes(lib)
    before = []
    for plane, view in enumerate(views):
        data = _fill_pattern(0x12000, seed + plane * 23, 31)
        ctypes.memmove(ctypes.addressof(view), data, len(data))
        before.append(data)
    return views, before


def _assert_plane_bytes(actual: bytes, expected: bytes, label: str) -> None:
    if actual == expected:
        return
    index = next(i for i, (got, want) in enumerate(zip(actual, expected)) if got != want)
    raise AssertionError(f"{label}: plane byte {index:04X} native={actual[index]:02X}, expected={expected[index]:02X}")


def _expected_ega_copy_workspace(fx: VideoFixture, before: bytes,
                                 planes_before: list[bytes], full: bool) -> list[bytes]:
    output = [bytearray(x) for x in planes_before]
    workspace = fx.m.peek("WorkspaceSegment")
    page = fx.m.peek("ScreenSegment")
    wide_row_bytes = fx.m.peek("WideRowBytes")
    playfield_row_bytes = fx.m.peek("PlayfieldRowBytes")
    if full:
        src0 = 0
        row_count = 200
        dst0 = 0
    else:
        src0 = fx.m.peek("ScrollWindowOffset")
        row_count = 192
        dst0 = 4 * 40
    page_base = 0 if page == 0xA000 else 0x2000
    row_bytes = 40 if full else 26
    for y in range(row_count):
        source_row = (src0 + y * (wide_row_bytes if full else playfield_row_bytes)) & MASK16
        destination_row = (dst0 + y * 40) & MASK16
        for plane in range(4):
            source = (source_row + plane * (40 if full else 26)) & MASK16
            destination = page_base + destination_row
            for x in range(row_bytes):
                physical = ((workspace << 4) + ((source + x) & MASK16)) & 0xFFFFF
                output[plane][destination + x] = before[physical]
    return [bytes(x) for x in output]


def _clear_104_ega_case(fx: VideoFixture, seed: int) -> int:
    views, before = _seed_ega_planes(fx.lib, seed)
    fx.cs_word("EgaPageToggle", 0)
    fx.cs_word("ScreenSegment", 0xA000)
    fx.call_service("ClearScreen104x200", "CLEARSCREEN104X200",
                    ignored_ranges=(EGA_ARENA,))
    for plane, view in enumerate(views):
        expected = bytearray(before[plane])
        for y in range(200):
            start = y * 40
            expected[start:start + 26] = bytes(26)
            start = 0x2000 + y * 40
            expected[start:start + 26] = bytes(26)
        _assert_plane_bytes(bytes(view), bytes(expected),
                            f"ClearScreen104x200 EGA plane {plane}")
    if fx.m.peek("EgaPageToggle") != 0 or fx.m.peek("ScreenSegment") != 0xA000:
        raise AssertionError("ClearScreen104x200 EGA did not restore draw page zero")
    return 1


def _reset_screen_ega_case(fx: VideoFixture, seed: int) -> int:
    views, before = _seed_ega_planes(fx.lib, seed)
    fx.cs_word("EgaPageToggle", 1)
    fx.cs_word("ScreenSegment", 0xA200)
    fx.call_service("ResetPageAndClearScreen", "RESETPAGEANDCLEARSCREEN",
                    ignored_ranges=(EGA_ARENA,))
    for plane, view in enumerate(views):
        expected = bytearray(before[plane])
        expected[:16000] = bytes(16000)
        _assert_plane_bytes(bytes(view), bytes(expected),
                            f"ResetPageAndClearScreen EGA plane {plane}")
    if fx.m.peek("EgaPageToggle") != 0 or fx.m.peek("ScreenSegment") != 0xA000:
        raise AssertionError("ResetPageAndClearScreen did not select page zero")
    return 1


def _copy_ega_page_case(fx: VideoFixture, seed: int) -> int:
    views, before = _seed_ega_planes(fx.lib, seed)
    fx.call_service("CopyEgaPage0ToPage1", "COPYEGAPAGE0TOPAGE1",
                    ignored_ranges=(EGA_ARENA,))
    for plane, view in enumerate(views):
        expected = bytearray(before[plane])
        expected[0x2000:0x2000 + 8000] = before[plane][:8000]
        _assert_plane_bytes(bytes(view), bytes(expected),
                            f"CopyEgaPage0ToPage1 plane {plane}")
    return 1


def _native_raster_cases(lib) -> int:
    checks = 0
    for adapter in (0, 1, 2):
        fx = VideoFixture(lib, adapter)
        try:
            _start_native_heap(fx)
            fx.call_service("AllocateBuffers", "ALLOCATEBUFFERS")
            fx.call_service("BuildRowTables", "BUILDROWTABLES")
            _seed_screen_and_workspace(fx, 0x19 + adapter)
            fx.ds_word("ScrollWindowOffset", fx.m.peek("ScrollStartOffset"))
            fx.call_service("CopyWorkspaceToScreen", "COPYWORKSPACETOSCREEN",
                            ignored_ranges=(EGA_ARENA,) if adapter == 1 else ())
            # A second copy fixture wraps an even source offset at FFFFh, preserving
            # the original REP MOVSW word-boundary behavior while testing wraparound.
            _seed_screen_and_workspace(fx, 0x32 + adapter)
            fx.ds_word("ScrollWindowOffset", 0xFFD0)
            views: list[ctypes.Array] = []
            planes_before: list[bytes] = []
            if adapter == 1:
                views, planes_before = _seed_ega_planes(lib, 0x71)
            before = bytes(fx.m.u.mem_read(0, DOS_MEMORY_BYTES))
            fx.call_service("CopyWorkspaceToScreen", "COPYWORKSPACETOSCREEN",
                            ignored_ranges=(EGA_ARENA,) if adapter == 1 else ())
            if adapter == 1:
                expected = _expected_ega_copy_workspace(fx, before, planes_before, False)
                for plane, view in enumerate(views):
                    _assert_plane_bytes(bytes(view), expected[plane],
                                        f"CopyWorkspaceToScreen wrapped EGA plane {plane}")
            checks += 2

            _seed_screen_and_workspace(fx, 0x45 + adapter)
            fx.ds_word("ScrollWindowOffset", 0xFFD0)
            if adapter == 1:
                views, planes_before = _seed_ega_planes(lib, 0x91)
            before = bytes(fx.m.u.mem_read(0, DOS_MEMORY_BYTES))
            fx.call_service("CopyFullWorkspaceToScreen", "COPYFULLWORKSPACETOSCREEN",
                            ignored_ranges=(EGA_ARENA,) if adapter == 1 else ())
            if adapter == 1:
                expected = _expected_ega_copy_workspace(fx, before, planes_before, True)
                for plane, view in enumerate(views):
                    _assert_plane_bytes(bytes(view), expected[plane],
                                        f"CopyFullWorkspaceToScreen EGA plane {plane}")
            checks += 1

            _seed_screen_and_workspace(fx, 0x5B + adapter)
            if adapter == 1:
                checks += _clear_104_ega_case(fx, 0xA1)
                checks += _reset_screen_ega_case(fx, 0xC3)
                checks += _copy_ega_page_case(fx, 0xD7)
            else:
                fx.call_service("ClearScreen104x200", "CLEARSCREEN104X200")
                checks += 1
                # CGA/Tandy ResetPageAndClearScreen have adapter-specific extent.
                _seed_screen_and_workspace(fx, 0x7C + adapter)
                fx.call_service("ResetPageAndClearScreen", "RESETPAGEANDCLEARSCREEN")
                checks += 1
                # The original routine is a true no-op outside EGA, including ES.
                regs_before = 0x4321
                fx.call_service("CopyEgaPage0ToPage1", "COPYEGAPAGE0TOPAGE1",
                                es=regs_before)
                checks += 1
        finally:
            fx.close()
    return checks


def _map_band_case(fx: VideoFixture, map_scroll_pos: int,
                   window_offset: int, case: str) -> None:
    adapter = fx.m.peek("VideoAdapter")
    fx.cs_word("LevelMapSegment", MAP_SEGMENT)
    fx.ds_word("ScrollingBackward", 1)
    fx.ds_word("MapScrollPos", map_scroll_pos)
    fx.ds_word("ScrollWindowOffset", window_offset)

    block_segment = fx.m.peek("ShipSegment" if map_scroll_pos >= 283 * 13
                              else "LevelBlocksSegment")
    block_bytes = fx.m.word(fx.m.offset("BlockBytes"))
    is_ship = map_scroll_pos >= 283 * 13
    block_count = 44 if is_ship else 256
    data_bytes = min(0x10000, block_bytes * block_count)
    fx.segment_write(block_segment, 0,
                     _fill_pattern(data_bytes, 0x31 + adapter + (0x40 if is_ship else 0), 19))

    row_offset = (map_scroll_pos - 13 * 13) & MASK16
    tile_values = ([1, 2, 44, 43, 17, 22, 35, 36, 9, 10, 11, 12, 13]
                   if is_ship else
                   [1, 2, 44, 45, 128, 129, 200, 201, 254, 255, 256, 33, 77])
    map_data = bytes(tile & 0xFF for tile in tile_values)
    physical_map = (MAP_SEGMENT << 4) & 0xFFFFF
    fx.physical_write(physical_map + row_offset, map_data)
    # The rest of both buffers makes overrun and mirror errors visible.
    workspace = fx.m.peek("WorkspaceSegment")
    fx.segment_write(workspace, 0,
                     _fill_pattern(0x10000, 0x89 + adapter + (window_offset & 0xFF), 23))
    before = bytes(fx.m.u.mem_read(0, DOS_MEMORY_BYTES))
    fx.arena.load(before)
    fx.lib.host_draw_map_row_into_scroll_band(row_offset)
    native_after = fx.arena.snapshot()
    fx.m.u.mem_write(0, before)
    oracle_regs = fx.m.call("DrawMapRowIntoScrollBand")
    oracle_after = bytes(fx.m.u.mem_read(0, DOS_MEMORY_BYTES))
    fx._compare_memory(native_after, oracle_after,
                       f"map band adapter {adapter} {case}")
    if oracle_regs["ES"] != workspace:
        raise AssertionError(f"map band {case}: oracle did not leave ES at workspace")


def _map_band_cases(lib) -> int:
    checks = 0
    for adapter in (0, 1, 2):
        fx = VideoFixture(lib, adapter)
        try:
            _start_native_heap(fx)
            fx.call_service("AllocateBuffers", "ALLOCATEBUFFERS")
            fx.call_service("BuildRowTables", "BUILDROWTABLES")
            band = fx.m.peek("ScrollBandBytes")
            start = fx.m.peek("ScrollStartOffset")
            wrap = fx.m.peek("ScrollWrapOffset")
            _map_band_case(fx, 30 * 13, start, "ordinary row at band start")
            _map_band_case(fx, 30 * 13, wrap, "ordinary row at wrap")
            _map_band_case(fx, 283 * 13, start, "ship row")
            if band == 0:
                raise AssertionError("AllocateBuffers produced an empty scroll band")
            checks += 3
        finally:
            fx.close()
    return checks


def _retrace_case(lib) -> int:
    fx = VideoFixture(lib, 2)
    try:
        fx.cs_word("RetraceBitInverted", 0x00A5)
        # Normal virtual CRT: one sync high, then low; the measured low interval is
        # 21 reads and the high retrace pulse is 5 reads, so the polarity is not inverted.
        fx.m.port_script = [0x08, 0x00] + [0x00] * 20 + [0x08] + [0x08] * 4 + [0x00]
        fx.call_service("MeasureRetracePolarity", "MEASURERETRACEPOLARITY", es=0x4A5A)
        if fx.m.peek("RetraceBitInverted") != 0:
            raise AssertionError("short active-high retrace pulse was classified as inverted")
        if fx.m.script_reads != 28:
            raise AssertionError(f"oracle consumed {fx.m.script_reads} status reads, expected 28")
        return 1
    finally:
        fx.close()


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
    harness = _load_module("host_input_video_harness", ROOT / "tests/host/input.py")
    harness._verify_exact_oracle()
    dll_directory = os.add_dll_directory(str(HOST_DIR)) if os.name == "nt" else None
    old_heap_fill = emu.HEAP_FILL
    emu.HEAP_FILL = b"\x00\x00"
    try:
        lib = ctypes.CDLL(str(HOST_CORE))
        _bind_signatures(lib)
        prologue = VideoFixture(lib, 2)
        try:
            before = bytes(prologue.m.u.mem_read(0, DOS_MEMORY_BYTES))
            prologue.arena.load(before)
            lib.overkill_platform_call.argtypes = (ctypes.c_uint16, ctypes.POINTER(HostRegisters))
            lib.overkill_platform_call.restype = None
            registers = HostRegisters()
            lib.overkill_platform_call(_token("BUILDBYTETONIBBLEMASKTABLE"), ctypes.byref(registers))
            native = prologue.arena.snapshot()
            original = prologue.m.call("BuildByteToNibbleMaskTable")
            prologue._compare_memory(native, bytes(prologue.m.u.mem_read(0, DOS_MEMORY_BYTES)),
                                     "startup byte-to-nibble masks")
            if registers.es != original["ES"]:
                raise AssertionError("startup mask builder ES differs")
        finally:
            prologue.close()
        allocation = _allocation_cases(lib)
        raster = _native_raster_cases(lib)
        map_band = _map_band_cases(lib)
        retrace = _retrace_case(lib)
    finally:
        emu.HEAP_FILL = old_heap_fill
        if dll_directory is not None:
            dll_directory.close()

    total = allocation + raster + map_band + retrace + 1
    print(f"PASS host video services: {allocation} allocation/table, {raster} raster, "
          f"{map_band} map-band, {retrace} retrace, 1 prologue cases ({total} checks)")
    return total


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="reuse build/host and build/oracle-sym artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
