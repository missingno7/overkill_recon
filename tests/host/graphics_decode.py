"""Differential checks for the original packed-graphics decoders.

The fixtures enter only DecodeGraphicsImages in the frozen oracle. They do not
advance the game beyond startup buffer initialization.
"""
from __future__ import annotations

import argparse
import ctypes
import os
from pathlib import Path
import re
import struct
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
HOST_DIR = ROOT / "build/host"
HOST_HEADER = HOST_DIR / "HOST_GEN.H"
ORACLE_EXE = ROOT / "build/oracle-sym/OVERKILL.EXE"
DOS_MEMORY_BYTES = 0x100000
WORD_MASK = 0xFFFF

sys.path.insert(0, str(TOOLS))
sys.path.insert(0, str(ROOT / "tests"))
from unicorn import UC_HOOK_CODE  # noqa: E402
from emu import LOAD, Machine, REG, WORD_REGS  # noqa: E402
from resources import decode_enc, resources  # noqa: E402
from resource_codecs import _packed_reference  # noqa: E402


class HostRegisters(ctypes.Structure):
    _fields_ = [(name.lower(), ctypes.c_uint16)
                for name in ("AX", "BX", "CX", "DX", "SI", "DI", "BP", "ES")]


def _macro(name: str) -> int:
    header = HOST_HEADER.read_text(encoding="ascii")
    match = re.search(rf"^\s*#define\s+{re.escape(name)}\s+.*?0x([0-9A-Fa-f]+)",
                      header, re.MULTILINE)
    if match is None:
        raise AssertionError(f"{HOST_HEADER} is missing {name}")
    return int(match.group(1), 16)


def _word(name: str, value: int) -> bytes:
    return struct.pack("<H", value & WORD_MASK)


def _write_segment(machine: Machine, segment: int, offset: int, data: bytes) -> None:
    """Write through DOS segment:offset arithmetic, including offset wrap."""
    for index, value in enumerate(data):
        address = (((segment << 4) + ((offset + index) & WORD_MASK)) & 0xFFFFF)
        machine.u.mem_write(address, bytes((value,)))


def _compile_probe(output: Path) -> None:
    compiler = os.environ.get("CC", "gcc")
    with tempfile.TemporaryDirectory(prefix="overkill-graphics-decode-") as temp:
        probe = Path(temp) / "video_stub.c"
        probe.write_text(
            '#include "video_services.h"\n'
            'int overkill_video_service(word token, HostRegisters *registers) {\n'
            '    (void)token; (void)registers; return 0;\n'
            '}\n'
            'int presentation_dispatch(word token, HostRegisters *registers) {\n'
            '    (void)token; (void)registers; return 0;\n'
            '}\n',
            encoding="ascii")
        command = [compiler, "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
                   "-Wno-unknown-pragmas", "-fno-strict-aliasing", "-DOVERKILL_HOST",
                   "-shared", "-I" + str(HOST_DIR), "-I" + str(ROOT / "c"),
                   "-I" + str(ROOT / "host")]
        if os.name != "nt":
            command.append("-fPIC")
        else:
            command.append("-Wl,--export-all-symbols")
        command += [str(ROOT / "host/memory.c"), str(ROOT / "host/graphics_decode.c"),
                    str(probe), "-o", str(output)]
        subprocess.run(command, check=True)


def _make_stream() -> bytes:
    stream = bytearray()
    for image_index, (rows, row_bytes) in enumerate(((2, 2), (1, 1))):
        stream += _word("rows", rows) + _word("row_bytes", row_bytes)
        for row in range(rows):
            for plane in range(4):
                for column in range(row_bytes):
                    stream.append((0x91 + image_index * 37 + row * 23 +
                                   plane * 41 + column * 67) & 0xFF)
    stream += b"\0\0\0\0"
    return bytes(stream)


def _oracle_call(machine: Machine, registers: HostRegisters,
                 workspace_segment: int,
                 instruction_limit: int = 1_000_000) -> dict[str, int]:
    seg, off = machine.symbols["DECODEGRAPHICSIMAGES"]
    cs = LOAD + seg
    sentinel = machine.sentinel(cs)
    sp = machine.stack_top - 0x40 - 2
    machine.set_word(sp, sentinel - cs * 16)
    values = {name.upper(): getattr(registers, name.lower()) for name in (
        "ax", "bx", "cx", "dx", "si", "di", "bp", "es")}
    for name, value in values.items():
        machine.u.reg_write(REG[name], value & WORD_MASK)
    machine.u.reg_write(REG["DS"], workspace_segment)
    machine.u.reg_write(REG["SS"], machine.data_frame)
    machine.u.reg_write(REG["CS"], cs)
    machine.u.reg_write(REG["SP"], sp)
    machine.u.reg_write(REG["FLAGS"], 0x0202)
    machine.fault = None
    def returned(engine, address, _size, _user):
        if (engine.reg_read(REG["CS"]) == cs and
                engine.reg_read(REG["SP"]) == sp + 2):
            engine.emu_stop()

    hook = machine.u.hook_add(UC_HOOK_CODE, returned, None, sentinel, sentinel)
    try:
        machine.u.emu_start(cs * 16 + off, 0, count=instruction_limit)
    finally:
        machine.u.hook_del(hook)
    ip = machine.u.reg_read(REG["CS"]) * 16 + machine.u.reg_read(REG["IP"])
    if machine.fault:
        raise AssertionError(f"DecodeGraphicsImages oracle fault: {machine.fault}")
    if ip != sentinel:
        position = (machine.u.reg_read(REG["CS"]), machine.u.reg_read(REG["IP"]))
        registers_now = {name: machine.u.reg_read(REG[name])
                         for name in ("AX", "BX", "CX", "DX", "SI", "DI", "BP")}
        raise AssertionError(
            f"DecodeGraphicsImages did not return within {instruction_limit:,} instructions; "
            f"stopped at {position[0]:04X}:{position[1]:04X}, regs={registers_now}")
    return {name: machine.u.reg_read(REG[name]) for name in WORD_REGS}


def _native_arena(lib, machine: Machine) -> tuple[ctypes.Array, int]:
    backing = ctypes.create_string_buffer(DOS_MEMORY_BYTES + 15)
    base = (ctypes.addressof(backing) + 15) & ~15
    if not lib.overkill_bind_real_memory(base, DOS_MEMORY_BYTES):
        raise AssertionError("native decoder rejected the 1 MiB real-mode arena")
    data_linear = _macro("HOST_DATA_LINEAR")
    if not lib.overkill_bind_state(base + data_linear, 0x10000):
        raise AssertionError("native decoder rejected the canonical DATA window")
    return backing, base


def _fixture(lib, adapter: int, make_mask: int, record: int,
             wrap_source: bool, wrap_destination: bool) -> int:
    machine = Machine(ORACLE_EXE)
    machine.start_runtime(adapter)
    workspace = machine.peek("WorkspaceSegment")
    source_offset = 0xFFF9 if wrap_source else 0x5317
    destination_segment = 0x7200
    destination_offset = 0xFFFC if wrap_destination else 0x6123
    stream = _make_stream()
    _write_segment(machine, workspace, source_offset, stream)

    machine.poke("LoadMakeMask", make_mask)
    machine.poke("LoadRecordImages", record)
    image_offsets = machine.symbols["PANELIMAGEOFFSETS"][1]
    machine.poke("LoadImageSlot", image_offsets)
    machine.u.mem_write(machine.linear("PerFileFlagsEnabled"), b"\x01")
    flags_offset = 0x9100
    _write_segment(machine, machine.data_frame, flags_offset, b"\x01\x02")

    before = bytes(machine.u.mem_read(0, DOS_MEMORY_BYTES))
    backing, base = _native_arena(lib, machine)
    ctypes.memmove(base, before, DOS_MEMORY_BYTES)
    initial_regs = HostRegisters(0xA1A1, 0xB2B2, 0xC3C3, 0xD4D4,
                                 source_offset, destination_offset, flags_offset,
                                 destination_segment)
    native_regs = HostRegisters.from_buffer_copy(bytes(initial_regs))
    native_result = lib.overkill_graphics_service(
        _macro("HOST_TOKEN_DECODEGRAPHICSIMAGES"), ctypes.byref(native_regs))
    if native_result != 1:
        raise AssertionError("native graphics service did not accept image decoding")
    native_after = ctypes.string_at(base, DOS_MEMORY_BYTES)

    oracle_regs = HostRegisters.from_buffer_copy(bytes(initial_regs))
    machine.u.mem_write(0, before)
    expected_registers = _oracle_call(machine, oracle_regs, workspace)
    oracle_after = bytes(machine.u.mem_read(0, DOS_MEMORY_BYTES))

    stack_begin = machine.data_frame * 16 + machine.offset("StackArea")
    stack_end = machine.data_frame * 16 + machine.stack_top
    if native_after != oracle_after:
        for address, (got, expected) in enumerate(zip(native_after, oracle_after)):
            if stack_begin <= address < stack_end:
                continue
            if got != expected:
                raise AssertionError(
                    f"adapter={adapter} mask={make_mask} record={record} "
                    f"srcwrap={wrap_source} dstwrap={wrap_destination}: "
                    f"{address:05X} native={got:02X} ASM={expected:02X}")

    # The C adapter transports AX/CX/SI/DI/BP/ES; BX/DX are not part of this
    # service's native call contract and are intentionally not synthesized.
    for name in ("ax", "cx", "si", "di", "bp", "es"):
        actual = getattr(native_regs, name)
        expected = expected_registers[name.upper()]
        if actual != expected:
            raise AssertionError(
                f"adapter={adapter} {name.upper()} native={actual:04X} ASM={expected:04X}")
    # Keep the arena backing alive through all native comparisons.
    del backing
    return 1


def _graphics_assets() -> list[dict[str, object]]:
    """Decode the pinned SHADOW graphics payloads to the bytes the image leaf sees."""
    archive, rows = resources()
    assets: list[dict[str, object]] = []
    for row in rows:
        name = row["name"].upper()
        if name.endswith(".BIC"):
            if name.endswith("MAP.BIC"):
                # Level maps are loaded into the map buffer and are not image lists.
                continue
            destination_segment_add = 0
            payload = archive[row["offset"]:row["offset"] + row["size"]]
            mode, writes, _consumed = _packed_reference(payload)
            image_bytes = bytearray(max(offset for offset, _ in writes) + 1)
            for offset, value in writes:
                image_bytes[offset] = value
            stream = bytes(image_bytes)
            basename = name[:-4]
            if basename in ("1X1", "2X2", "2X2C", "MANEXPL"):
                mask, record = 1, 0
                destination, destination_offset, slot = {
                    "1X1": ("Sprites1x1Segment", 0, None),
                    "2X2": ("Sprites2x2Segment", 0, None),
                    "2X2C": ("Sprites2x2CSegment", 0, None),
                    "MANEXPL": ("ManExplSegment", 0, None),
                }[basename]
            elif basename.startswith("G") and basename[1:].isdigit():
                mask, record = 1, 0
                destination, destination_offset, slot = "LevelSpritesSegment", 0, None
            elif basename.startswith("LEV") and basename.endswith("BLX"):
                mask, record = 0, 0
                destination, destination_offset, slot = "LevelBlocksSegment", 0, None
            elif basename == "THEND":
                mask, record = 0, 1
                destination, destination_offset, slot = "TheEndSegment", 0, "PanelImageOffsets"
            elif basename == "BLUEBITS":
                mask, record = 0, 1
                destination, destination_offset, slot = "BlueBitsSegment", 0, "BlueBitsImageOffsets"
            elif basename == "WINDOW":
                mask, record = 0, 1
                destination, destination_offset, slot = "WorkspaceSegment", 0, "PlaqueImageOffset"
                # Startup captures the launcher image one paragraph beyond the 200-row page.
                destination_segment_add = 0x07D1
            elif basename == "SHIP":
                mask, record = 0, 0
                destination, destination_offset, slot = "ShipSegment", 0, None
            else:
                # LOGO.BIC is a shipped valid stream, but the frozen data notes it is
                # never loaded. Exercise its decoder bytes in an isolated scratch span.
                mask, record = 0, 0
                destination, destination_offset, slot = 0x7200, 0, None
            assets.append({
                "name": name,
                "stream": stream,
                "mask": mask,
                "record": record,
                "destination": destination,
                "destination_offset": destination_offset,
                "destination_segment_add": destination_segment_add,
                "slot": slot,
                "file_label": "FILE_" + basename + "_BIC",
                "mode": mode,
            })
            continue

        if not name.endswith(".ENC") or name in ("ADLIB.ENC", "ROLAND.ENC"):
            continue
        payload = archive[row["offset"]:row["offset"] + row["size"]]
        stream, _consumed = decode_enc(payload)
        basename = name[:-4]
        if basename == "PANEL":
            destination, destination_offset, slot = "PanelSegment", 0, "PanelImageOffsets"
        elif basename == "LEVSCR":
            destination, destination_offset, slot = "WorkspaceSegment", 0x8000, "ScreenImageOffset"
        elif basename == "CHOOSE":
            destination, destination_offset, slot = "WorkspaceSegment", 0x4000, "ChooseImageOffsets"
        elif basename.startswith("PLAQ") and basename[4:].isdigit():
            destination, destination_offset, slot = "PlaqueSegment", 0, "PlaqueImageOffset"
        else:
            # OPAGE/IPAGE and the menu/configuration pages use LoadAndShowPage.
            destination, destination_offset, slot = "WorkspaceSegment", 0x8000, "ScreenImageOffset"
        assets.append({
            "name": name,
            "stream": stream,
            "mask": 0,
            "record": 1,
            "destination": destination,
            "destination_offset": destination_offset,
            "destination_segment_add": 0,
            "slot": slot,
            "file_label": "FILE_" + basename + "_ENC",
            "mode": "ENC",
        })
    if not assets:
        raise AssertionError("pinned SHADOW archive has no graphics image streams")
    return assets


def _image_stream_budget(stream: bytes) -> int:
    """Bound the direct oracle leaf using the decoded image dimensions."""
    position = 0
    pixels = 0
    while position + 4 <= len(stream):
        rows, row_bytes = struct.unpack_from("<HH", stream, position)
        position += 4
        if rows == 0 and row_bytes == 0:
            break
        if rows == 0 or row_bytes == 0:
            raise AssertionError(f"invalid image header at decoded offset {position - 4:04X}")
        payload_bytes = rows * row_bytes * 4
        if position + payload_bytes > 0x10000:
            raise AssertionError("decoded graphics stream exceeds the cleared 64 KiB workspace")
        pixels += rows * row_bytes * 8
        position += payload_bytes
    else:
        # ClearWorkspace supplies the zero header following streams that end exactly
        # after their final plane data.
        if position != len(stream):
            raise AssertionError("graphics stream ends in a partial image header")
    # EGA spends substantially more instructions per pixel than the CGA/Tandy paths.
    # The hard ceiling keeps malformed or unexpected assets from becoming unbounded.
    return min(30_000_000, max(1_000_000, pixels * 180 + 500_000))


def _write_linear_wrapped(machine: Machine, segment: int, offset: int,
                          data: bytes) -> None:
    address = ((segment << 4) + offset) & 0xFFFFF
    first = min(len(data), DOS_MEMORY_BYTES - address)
    if first:
        machine.u.mem_write(address, data[:first])
    if first < len(data):
        machine.u.mem_write(0, data[first:])


class _RealAssetRunner:
    def __init__(self, lib, adapter: int):
        self.lib = lib
        self.adapter = adapter
        self.machine = Machine(ORACLE_EXE)
        self.machine.start_runtime(adapter)
        self.workspace = self.machine.peek("WorkspaceSegment")
        self.baseline = bytes(self.machine.u.mem_read(0, DOS_MEMORY_BYTES))
        self.backing, self.base = _native_arena(lib, self.machine)
        self.stack_begin = (self.machine.data_frame * 16 +
                            self.machine.offset("StackArea"))
        self.stack_end = self.machine.data_frame * 16 + self.machine.stack_top

    def _file_flag_word(self, asset: dict[str, object]) -> int:
        name_offset = _macro("HOST_TOKEN_" + str(asset["file_label"]))
        return self.machine.word((name_offset - 2) & WORD_MASK)

    def run(self, asset: dict[str, object]) -> None:
        machine = self.machine
        machine.u.mem_write(0, self.baseline)
        stream = bytes(asset["stream"])
        # The real loader clears WorkspaceSegment, then writes the BIC-expanded or
        # ENC-decoded resource at offset zero. The cleared tail supplies image-list EOS.
        _write_linear_wrapped(machine, self.workspace, 0, bytes(0x10000))
        _write_linear_wrapped(machine, self.workspace, 0, stream)

        make_mask = int(asset["mask"])
        record = int(asset["record"])
        slot = asset["slot"]
        slot_offset = (machine.symbols[str(slot).upper()][1] if slot else 0)
        destination = asset["destination"]
        destination_segment = (machine.peek(destination) if isinstance(destination, str)
                               else int(destination))
        destination_segment = (destination_segment +
                               int(asset["destination_segment_add"])) & WORD_MASK
        destination_offset = int(asset["destination_offset"])
        per_file_enabled = int(self.adapter == 1)
        flag_word = self._file_flag_word(asset) if per_file_enabled else WORD_MASK

        machine.poke("LoadMakeMask", make_mask)
        machine.poke("LoadRecordImages", record)
        machine.poke("LoadImageSlot", slot_offset)
        machine.u.mem_write(machine.linear("PerFileFlagsEnabled"),
                            bytes((per_file_enabled,)))
        if self.adapter == 0 and str(asset["name"]) == "LEVSCR.ENC":
            # run_choose_screen temporarily maps source color 7 to CGA black.
            cga_map = machine.linear("CgaColorMap")
            machine.u.mem_write(cga_map + 7, b"\0")

        before = bytes(machine.u.mem_read(0, DOS_MEMORY_BYTES))
        ctypes.memmove(self.base, before, DOS_MEMORY_BYTES)
        initial_regs = HostRegisters(0xA1A1, 0xB2B2, 0xC3C3, 0xD4D4,
                                    0, destination_offset, flag_word,
                                    destination_segment)
        native_regs = HostRegisters.from_buffer_copy(bytes(initial_regs))
        native_result = self.lib.overkill_graphics_service(
            _macro("HOST_TOKEN_DECODEGRAPHICSIMAGES"), ctypes.byref(native_regs))
        if native_result != 1:
            raise AssertionError(f"{asset['name']}: native service did not accept decoder token")
        native_after = ctypes.string_at(self.base, DOS_MEMORY_BYTES)

        oracle_regs = HostRegisters.from_buffer_copy(bytes(initial_regs))
        machine.u.mem_write(0, before)
        expected_registers = _oracle_call(
            machine, oracle_regs, self.workspace, _image_stream_budget(stream))
        oracle_after = bytes(machine.u.mem_read(0, DOS_MEMORY_BYTES))
        if native_after != oracle_after:
            for address, (got, expected) in enumerate(zip(native_after, oracle_after)):
                if self.stack_begin <= address < self.stack_end:
                    continue
                if got != expected:
                    raise AssertionError(
                        f"{asset['name']} adapter={self.adapter} mode={asset['mode']} "
                        f"mask={make_mask} record={record}: {address:05X} "
                        f"native={got:02X} ASM={expected:02X}")
        for name in ("ax", "cx", "si", "di", "bp", "es"):
            actual = getattr(native_regs, name)
            expected = expected_registers[name.upper()]
            if actual != expected:
                raise AssertionError(
                    f"{asset['name']} adapter={self.adapter} {name.upper()} "
                    f"native={actual:04X} ASM={expected:04X}")


def _asset_fixtures(lib, adapters: tuple[int, ...]) -> int:
    assets = _graphics_assets()
    checks = 0
    for adapter in adapters:
        runner = _RealAssetRunner(lib, adapter)
        for asset in assets:
            runner.run(asset)
            checks += 1
        del runner
    return checks


def run(adapter_filter: int | None = None) -> int:
    if not HOST_HEADER.is_file() or not ORACLE_EXE.is_file():
        raise FileNotFoundError("generate the host header and exact oracle before testing")
    with tempfile.TemporaryDirectory(prefix="overkill-graphics-decode-") as temp:
        library = Path(temp) / ("graphics_decode.dll" if os.name == "nt"
                                else "libgraphics_decode.so")
        _compile_probe(library)
        lib = ctypes.CDLL(str(library))
        try:
            lib.overkill_bind_real_memory.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
            lib.overkill_bind_real_memory.restype = ctypes.c_int
            lib.overkill_bind_state.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
            lib.overkill_bind_state.restype = ctypes.c_int
            lib.overkill_graphics_service.argtypes = (
                ctypes.c_uint16, ctypes.POINTER(HostRegisters))
            lib.overkill_graphics_service.restype = ctypes.c_int
            checks = 0
            adapters = (adapter_filter,) if adapter_filter is not None else (2, 0, 1)
            for adapter in adapters:
                for make_mask, record in ((0, 0), (1, 0), (1, 1)):
                    checks += _fixture(lib, adapter, make_mask, record, False, False)
                checks += _fixture(lib, adapter, 1, 1, True, True)
            asset_checks = _asset_fixtures(lib, adapters)
            checks += asset_checks
        finally:
            if os.name == "nt":
                from _ctypes import FreeLibrary  # pylint: disable=import-outside-toplevel
                FreeLibrary(lib._handle)
                del lib
    print(f"PASS native graphics decoder: {checks} full-arena oracle fixtures "
          f"({asset_checks} shipped graphics asset cases)")
    return checks


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--adapter", type=int, choices=(0, 1, 2),
                        help="run one adapter only (CGA 0, EGA 1, Tandy 2)")
    args = parser.parse_args()
    run(args.adapter)


if __name__ == "__main__":
    main()
