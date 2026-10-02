"""Checks the native 20-bit segmented-address adapter.

Run ``python tests/host/addresses.py`` to build the host core and exercise DS aliases
and the real-memory arena. Pass ``--no-build`` to reuse ``build/host``.
"""
from __future__ import annotations

import argparse
import ctypes
import os
from pathlib import Path
import re
import sys

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
HOST_DIR = ROOT / "build/host"
HOST_CORE = HOST_DIR / ("OVERKILL_CORE.dll" if sys.platform == "win32"
                        else "liboverkill_core.so")
HOST_HEADER = HOST_DIR / "HOST_GEN.H"
DOS_MEMORY_BYTES = 0x100000
DOS_ADDRESS_MASK = DOS_MEMORY_BYTES - 1
DS_WINDOW_BYTES = 0x10000

sys.path.insert(0, str(TOOLS))
from graph import read_map  # noqa: E402


def _macro(header: str, name: str) -> int:
    match = re.search(
        rf"^\s*#define\s+{re.escape(name)}\s+(0[xX][0-9A-Fa-f]+|[0-9]+)[uUlL]*\b",
        header, re.MULTILINE)
    if match is None:
        raise AssertionError(f"{HOST_HEADER} is missing numeric macro {name}")
    return int(match.group(1), 0)


def _host_layout() -> tuple[int, int, int]:
    if not HOST_HEADER.is_file():
        raise FileNotFoundError(f"generated host header is missing: {HOST_HEADER}")
    header = HOST_HEADER.read_text(encoding="ascii")
    load_segment = _macro(header, "HOST_LOAD_SEGMENT")
    data_segment = _macro(header, "HOST_DATA_SEGMENT")
    data_linear = _macro(header, "HOST_DATA_LINEAR")

    segments, _parts, _publics = read_map()
    data_frame_linear, _data_size = segments["DATA"]
    if data_frame_linear & 0x0F:
        raise AssertionError("MAP DATA frame is not paragraph aligned")
    map_data_segment = (load_segment + (data_frame_linear >> 4)) & 0xFFFF
    if data_segment != map_data_segment:
        raise AssertionError(
            f"generated DATA segment {data_segment:04X} disagrees with MAP "
            f"frame {map_data_segment:04X}")
    if data_linear != (data_segment << 4):
        raise AssertionError(
            f"generated DATA linear base {data_linear:05X} does not match "
            f"segment {data_segment:04X}")
    return load_segment, data_segment, data_linear


def _linear(segment: int, offset: int) -> int:
    return ((segment << 4) + offset) & DOS_ADDRESS_MASK


def _bind_signatures(lib) -> None:
    lib.overkill_bind_real_memory.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_bind_real_memory.restype = ctypes.c_int
    lib.overkill_bind_state.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_bind_state.restype = ctypes.c_int
    lib.overkill_segment_address.argtypes = (ctypes.c_uint16, ctypes.c_uint16)
    lib.overkill_segment_address.restype = ctypes.c_void_p
    lib.overkill_ds_address.argtypes = (ctypes.c_uint16,)
    lib.overkill_ds_address.restype = ctypes.c_void_p
    lib.overkill_ds_offset.argtypes = (ctypes.c_void_p,)
    lib.overkill_ds_offset.restype = ctypes.c_uint16


def _segment_pointer(lib, segment: int, offset: int) -> int:
    pointer = lib.overkill_segment_address(segment & 0xFFFF, offset & 0xFFFF)
    if pointer is None:
        raise AssertionError(f"null pointer for {segment:04X}:{offset:04X}")
    return int(pointer)


def _bind_real_memory(lib, data_segment: int, data_linear: int) -> tuple[int, int]:
    checks = 0

    # The byte arena itself need not have word alignment. Its memory remains installed
    # after rejected rebinds, including a failed candidate with a different address.
    unaligned_storage = ctypes.create_string_buffer(DOS_MEMORY_BYTES + 1)
    unaligned_base = ctypes.addressof(unaligned_storage) + 1
    if not lib.overkill_bind_real_memory(unaligned_base, DOS_MEMORY_BYTES):
        raise AssertionError("real-memory binding rejected a full unaligned byte arena")
    checks += 1

    second_storage = ctypes.create_string_buffer(DOS_MEMORY_BYTES + 1)
    second_base = ctypes.addressof(second_storage) + 1
    for candidate, size, label in (
            (None, DOS_MEMORY_BYTES, "null arena"),
            (second_base, DOS_MEMORY_BYTES - 1, "short arena")):
        if lib.overkill_bind_real_memory(candidate, size):
            raise AssertionError(f"real-memory binding accepted a {label}")
        checks += 1

    # These pairs include both sides of the 64 KiB boundary and the 1 MiB wrap.
    # Each pair must identify one byte, and writes through either alias must be visible.
    pairs = (
        ((0x0000, 0x0000), (0xFFFF, 0x0010)),
        ((0x0000, 0xFFFF), (0x0FFF, 0x000F)),
        ((0x0FFF, 0x0010), (0x1000, 0x0000)),
        ((0xFFFF, 0x000F), (0xFFFE, 0x001F)),
        ((0xFFFF, 0x0010), (0x0000, 0x0000)),
    )
    arena_base = unaligned_base
    for index, (left, right) in enumerate(pairs):
        left_linear = _linear(*left)
        right_linear = _linear(*right)
        if left_linear != right_linear:
            raise AssertionError(f"test aliases do not match: {left!r}, {right!r}")
        expected = arena_base + left_linear
        left_pointer = _segment_pointer(lib, *left)
        right_pointer = _segment_pointer(lib, *right)
        if left_pointer != expected or right_pointer != expected:
            raise AssertionError(
                f"real address {left[0]:04X}:{left[1]:04X}/"
                f"{right[0]:04X}:{right[1]:04X}: got {left_pointer:#x}/"
                f"{right_pointer:#x}, expected {expected:#x}")
        value = (0x31 + index * 47) & 0xFF
        ctypes.c_ubyte.from_address(left_pointer).value = value
        if ctypes.c_ubyte.from_address(right_pointer).value != value:
            raise AssertionError("write through one segment alias was not visible through the other")
        checks += 1

    # A rejected replacement must leave the original arena available.
    if lib.overkill_bind_real_memory(second_base, DS_WINDOW_BYTES):
        raise AssertionError("real-memory binding accepted an undersized replacement")
    retained = _segment_pointer(lib, 0x0000, 0x0001)
    if retained != unaligned_base + 1:
        raise AssertionError("failed real-memory rebind replaced the installed arena")
    checks += 1

    # Install an aligned arena for binding the borrowed DS view into the same storage.
    aligned_storage = ctypes.create_string_buffer(DOS_MEMORY_BYTES + 16)
    raw_base = ctypes.addressof(aligned_storage)
    aligned_base = (raw_base + 15) & ~15
    if not lib.overkill_bind_real_memory(aligned_base, DOS_MEMORY_BYTES):
        raise AssertionError("real-memory binding rejected a full aligned arena")
    checks += 1

    # Legacy callers can still borrow a separate DS window. All 65,536 offsets are
    # tested directly and through an alternate segment:offset spelling.
    state_storage = ctypes.create_string_buffer(DS_WINDOW_BYTES + 2)
    state_base = (ctypes.addressof(state_storage) + 1) & ~1
    state_end = state_base + DS_WINDOW_BYTES
    if not lib.overkill_bind_state(state_base, DS_WINDOW_BYTES):
        raise AssertionError("native core rejected the aligned borrowed DS window")
    for offset in range(DS_WINDOW_BYTES):
        direct = _segment_pointer(lib, data_segment, offset)
        if direct != state_base + offset:
            raise AssertionError(
                f"DS address {offset:04X}: got {direct:#x}, expected {state_base + offset:#x}")

        if offset >= 16:
            alias_segment, alias_offset = data_segment + 1, offset - 16
        else:
            alias_segment, alias_offset = data_segment - 1, offset + 16
        alias = _segment_pointer(lib, alias_segment, alias_offset)
        if alias != state_base + offset:
            raise AssertionError(
                f"DS alias {alias_segment:04X}:{alias_offset:04X} for {offset:04X}: "
                f"got {alias:#x}, expected {state_base + offset:#x}")
    alias_count = 2 * DS_WINDOW_BYTES
    checks += alias_count

    # The separately borrowed DS wins over arena storage, including alternate aliases.
    probe_offset = 0xFFFF
    arena_probe = aligned_base + data_linear + probe_offset
    borrowed_probe = state_base + probe_offset
    ctypes.c_ubyte.from_address(arena_probe).value = 0xA5
    ctypes.c_ubyte.from_address(borrowed_probe).value = 0x5A
    if _segment_pointer(lib, data_segment, probe_offset) != borrowed_probe:
        raise AssertionError("DS end byte did not resolve to the borrowed window")
    if ctypes.c_ubyte.from_address(arena_probe).value != 0xA5:
        raise AssertionError("borrowed DS write unexpectedly changed the real-memory arena")
    checks += 1

    # Rebind DS into the arena: direct DS access, segment aliases, and arena access now
    # share one canonical byte at every tested boundary.
    canonical_state = aligned_base + data_linear
    if not lib.overkill_bind_state(canonical_state, DS_WINDOW_BYTES):
        raise AssertionError("native core rejected DS placed inside the aligned arena")
    for offset in (0, 1, 15, 16, 0xFFFE, 0xFFFF):
        alias_segment, alias_offset = data_segment + 1, offset - 16
        if offset < 16:
            alias_segment, alias_offset = data_segment - 1, offset + 16
        pointer = _segment_pointer(lib, alias_segment, alias_offset)
        expected = canonical_state + offset
        if pointer != expected or lib.overkill_ds_address(offset) != expected:
            raise AssertionError(f"canonical DS boundary {offset:04X} resolved inconsistently")
        value = (offset ^ 0xD3) & 0xFF
        ctypes.c_ubyte.from_address(pointer).value = value
        if ctypes.c_ubyte.from_address(aligned_base + data_linear + offset).value != value:
            raise AssertionError(f"DS alias write at {offset:04X} missed the real arena")
    if _segment_pointer(lib, data_segment, 0xFFFF) != canonical_state + 0xFFFF:
        raise AssertionError("the final DS byte did not resolve to state_window + FFFFh")
    if lib.overkill_ds_offset(canonical_state + DS_WINDOW_BYTES) != 0:
        raise AssertionError("one-past DS pointer did not wrap to DOS offset 0000h")
    one_past_address = _segment_pointer(lib, data_segment + 0x1000, 0)
    if one_past_address != canonical_state + DS_WINDOW_BYTES:
        raise AssertionError("the physical byte after DS did not resolve to the arena one-past pointer")
    checks += 3 * 6 + 3

    # Keep all backing allocations alive until all native pointers have been used.
    _ = (unaligned_storage, second_storage, aligned_storage, state_storage, state_end)
    return checks, alias_count


def run(no_build: bool = False) -> int:
    if no_build:
        if not HOST_CORE.is_file():
            raise FileNotFoundError("--no-build requires the current build/host core")
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    _load_segment, data_segment, data_linear = _host_layout()
    dll_directory = os.add_dll_directory(str(HOST_DIR)) if os.name == "nt" else None
    try:
        lib = ctypes.CDLL(str(HOST_CORE))
        _bind_signatures(lib)
        checks, aliases = _bind_real_memory(lib, data_segment, data_linear)
    finally:
        if dll_directory is not None:
            dll_directory.close()

    print(f"PASS host addresses: {aliases} exhaustive DS direct/alias addresses, "
          f"{checks} binding and boundary checks")
    return checks


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="reuse the current build/host core and generated header")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
