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
from unicorn import UC_HOOK_CODE  # noqa: E402
from emu import LOAD, Machine, REG, WORD_REGS  # noqa: E402


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
                 workspace_segment: int) -> dict[str, int]:
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
        machine.u.emu_start(cs * 16 + off, 0, count=1_000_000)
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
            f"DecodeGraphicsImages did not return within 1M instructions; "
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
        finally:
            if os.name == "nt":
                from _ctypes import FreeLibrary  # pylint: disable=import-outside-toplevel
                FreeLibrary(lib._handle)
                del lib
    print(f"PASS native graphics decoder: {checks} full-arena oracle fixtures")
    return checks


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--adapter", type=int, choices=(0, 1, 2),
                        help="run one adapter only (CGA 0, EGA 1, Tandy 2)")
    args = parser.parse_args()
    run(args.adapter)


if __name__ == "__main__":
    main()
