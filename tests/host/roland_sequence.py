"""Compare the native Roland sequencer with bounded calls to the original module.

Run ``python tests/host/roland_sequence.py``. The test assembles ROLAND.ASM,
checks it against ROLAND.ENC, and compares module state and ordered MIDI bytes after
each timer tick for all ten tunes and request changes.
"""
from __future__ import annotations

import argparse
import ctypes
import os
from pathlib import Path
import re
import subprocess
import sys
import struct

from unicorn import Uc, UcError, UC_ARCH_X86, UC_MODE_16, UC_HOOK_INSN, UC_HOOK_CODE
from unicorn.x86_const import UC_X86_INS_IN, UC_X86_INS_OUT
from unicorn.x86_const import UC_X86_REG_CS, UC_X86_REG_DS, UC_X86_REG_FLAGS
from unicorn.x86_const import UC_X86_REG_EAX, UC_X86_REG_IP, UC_X86_REG_SP, UC_X86_REG_SS

ROOT = Path(__file__).resolve().parents[2]
BUILD = ROOT / "build/host"
PRIVATE_BUILD = ROOT / "build/host-roland-sequence-test"
IMAGE_BYTES = 0x10000
MODULE_SEGMENT = 0x2000
STACK_SEGMENT = 0x7000
STACK_OFFSET = 0xFF00
RETURN_IP = 0xFFFE

sys.path.insert(0, str(ROOT / "tools"))
from build import assemble_driver  # noqa: E402
from resources import driver as resource_driver  # noqa: E402


def _macro(name: str) -> int:
    header = (BUILD / "ROLAND_GEN.H").read_text(encoding="ascii")
    match = re.search(rf"^#define\s+{re.escape(name)}\s+(0x[0-9A-Fa-f]+)",
                      header, re.MULTILINE)
    if match is None:
        raise AssertionError(f"generated ROLAND_GEN.H lacks {name}")
    return int(match.group(1), 16)


def _ensure_header() -> None:
    if (BUILD / "ROLAND_GEN.H").is_file():
        return
    # Generate only the derived module symbols. This keeps the test's private C
    # probe independent of the full shared host build.
    sys.path.insert(0, str(ROOT))
    from tools.host import generate_driver_addresses  # noqa: E402
    generate_driver_addresses(BUILD, "roland")


def _native_library() -> ctypes.CDLL:
    PRIVATE_BUILD.mkdir(parents=True, exist_ok=True)
    wrapper = PRIVATE_BUILD / "roland_sequence_probe.c"
    library = PRIVATE_BUILD / ("roland_sequence_probe.dll" if os.name == "nt"
                               else "libroland_sequence_probe.so")
    wrapper.write_text(r"""
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include "roland_sequence.h"

static uint8_t bytes[65536];
static size_t byte_count;

int sound_services_midi_ready(void) { return 1; }
int sound_services_midi_byte(uint8_t value)
{
    if (byte_count < sizeof(bytes)) bytes[byte_count++] = value;
    return 1;
}

int probe_bind(uint8_t *image, size_t size) { return roland_sequence_bind(image, size); }
void probe_unbind(void) { roland_sequence_unbind(); }
int probe_initialize(void) { return roland_sequence_initialize(); }
void probe_request(uint8_t tune) { roland_sequence_request(tune); }
void probe_tick(void) { roland_sequence_tick(); }
void probe_clear_bytes(void) { byte_count = 0; }
size_t probe_byte_count(void) { return byte_count; }
size_t probe_copy_bytes(uint8_t *out, size_t capacity)
{
    size_t count = byte_count < capacity ? byte_count : capacity;
    memcpy(out, bytes, count);
    return count;
}
""", encoding="ascii")

    compiler = os.environ.get("CC", "gcc")
    command = [compiler, "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
               "-shared", "-I" + str(ROOT / "host"), "-I" + str(BUILD),
               str(ROOT / "host/roland_sequence.c"), str(wrapper), "-o", str(library)]
    if os.name != "nt":
        command.insert(6, "-fPIC")
    subprocess.run(command, check=True, cwd=ROOT)
    lib = ctypes.CDLL(str(library))
    lib.probe_bind.argtypes = (ctypes.POINTER(ctypes.c_uint8), ctypes.c_size_t)
    lib.probe_bind.restype = ctypes.c_int
    lib.probe_unbind.argtypes = ()
    lib.probe_initialize.argtypes = ()
    lib.probe_initialize.restype = ctypes.c_int
    lib.probe_request.argtypes = (ctypes.c_uint8,)
    lib.probe_tick.argtypes = ()
    lib.probe_clear_bytes.argtypes = ()
    lib.probe_byte_count.argtypes = ()
    lib.probe_byte_count.restype = ctypes.c_size_t
    lib.probe_copy_bytes.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.probe_copy_bytes.restype = ctypes.c_size_t
    return lib


class ModuleOracle:
    """Run the source-built module entry or MusicTick with bounded MPU ports."""

    def __init__(self, module_image: bytes):
        self.base = MODULE_SEGMENT << 4
        self.uc = Uc(UC_ARCH_X86, UC_MODE_16)
        self.uc.mem_map(0, 0x100000)
        self.uc.mem_write(self.base, module_image.ljust(IMAGE_BYTES, b"\0"))
        self.ports: list[tuple[int, int]] = []
        self.uc.hook_add(UC_HOOK_INSN, self._port_in, None, 1, 0, UC_X86_INS_IN)
        self.uc.hook_add(UC_HOOK_INSN, self._port_out, None, 1, 0, UC_X86_INS_OUT)
        self.uc.hook_add(UC_HOOK_CODE, self._return, None,
                         self.base + RETURN_IP, self.base + RETURN_IP)
        self.uc.reg_write(UC_X86_REG_CS, MODULE_SEGMENT)
        self.uc.reg_write(UC_X86_REG_DS, MODULE_SEGMENT)
        self.uc.reg_write(UC_X86_REG_SS, STACK_SEGMENT)
        self.uc.reg_write(UC_X86_REG_FLAGS, 0x0202)

    @staticmethod
    def _port_in(_uc, port, _size, _data):
        # Ready and acknowledge polls complete immediately; the MPU reset probe
        # returns FEh from its data port to select the successful first attempt.
        return 0xFE if port == 0x330 else 0

    def _port_out(self, _uc, port, size, value, _data):
        mask = (1 << (size * 8)) - 1
        self.ports.append((port, value & mask))

    def _return(self, uc, _address, _size, _data):
        if (uc.reg_read(UC_X86_REG_CS) == MODULE_SEGMENT and
                uc.reg_read(UC_X86_REG_IP) == RETURN_IP and
                uc.reg_read(UC_X86_REG_SP) == STACK_OFFSET):
            uc.emu_stop()

    def _invoke(self, offset: int) -> int:
        stack = (STACK_SEGMENT << 4) + STACK_OFFSET - 2
        self.uc.mem_write(stack, struct.pack("<H", RETURN_IP))
        self.uc.reg_write(UC_X86_REG_SP, STACK_OFFSET - 2)
        try:
            self.uc.emu_start(self.base + offset, 0, count=2_000_000)
        except UcError as error:
            raise AssertionError(f"ROLAND routine CPU fault at {offset:04X}: {error}") from error
        if self.uc.reg_read(UC_X86_REG_IP) != RETURN_IP:
            raise AssertionError(f"ROLAND routine at {offset:04X} did not return")
        return self.uc.reg_read(UC_X86_REG_EAX) & 0xFF

    def initialize(self) -> list[int]:
        self.ports.clear()
        result = self._invoke(_macro("ROLAND_DETECTMPU401"))
        if result != 1:
            raise AssertionError("bounded MPU-401 probe did not report success")
        return [value & 0xFF for port, value in self.ports if port == 0x330]

    def request(self, tune: int):
        self.uc.mem_write(self.base + _macro("ROLAND_MUSICREQUEST"),
                          struct.pack("<H", tune & 0xFF))

    def tick(self) -> tuple[bytes, list[int]]:
        self.ports.clear()
        stack = (STACK_SEGMENT << 4) + STACK_OFFSET - 2
        self.uc.mem_write(stack, struct.pack("<H", RETURN_IP))
        self.uc.reg_write(UC_X86_REG_SP, STACK_OFFSET - 2)
        try:
            self.uc.emu_start(self.base + _macro("ROLAND_MUSICTICK"), 0,
                              count=2_000_000)
        except UcError as error:
            raise AssertionError(f"MusicTick CPU fault: {error}") from error
        if self.uc.reg_read(UC_X86_REG_IP) != RETURN_IP:
            raise AssertionError("MusicTick did not return to the bounded sentinel")
        midi = [value & 0xFF for port, value in self.ports if port == 0x330]
        state = bytes(self.uc.mem_read(self.base, IMAGE_BYTES))
        return state, midi


def _candidate_bytes(lib) -> list[int]:
    count = lib.probe_byte_count()
    storage = (ctypes.c_uint8 * count)()
    copied = lib.probe_copy_bytes(storage, count)
    if copied != count:
        raise AssertionError("native MIDI byte buffer truncated")
    return list(storage)


def _run_sequence(lib, module_image: bytes, requests: dict[int, int], ticks: int,
                  label: str) -> int:
    oracle = ModuleOracle(module_image)
    candidate = bytearray(IMAGE_BYTES)
    candidate[:len(module_image)] = module_image
    candidate_view = (ctypes.c_uint8 * IMAGE_BYTES).from_buffer(candidate)
    lib.probe_unbind()
    if not lib.probe_bind(candidate_view, IMAGE_BYTES):
        raise AssertionError("native sequencer rejected a complete module segment")

    checks = 0
    for tick_index in range(ticks):
        if tick_index in requests:
            tune = requests[tick_index]
            oracle.request(tune)
            lib.probe_request(tune)
        expected_state, expected_bytes = oracle.tick()
        lib.probe_clear_bytes()
        lib.probe_tick()
        actual_bytes = _candidate_bytes(lib)
        actual_state = bytes(candidate)
        if actual_state != expected_state:
            first = next(i for i, (a, b) in enumerate(zip(actual_state, expected_state))
                         if a != b)
            raise AssertionError(
                f"{label} tick {tick_index}: module byte {first:04X} is "
                f"{actual_state[first]:02X}, expected {expected_state[first]:02X}")
        if actual_bytes != expected_bytes:
            at = next((i for i, pair in enumerate(zip(actual_bytes, expected_bytes))
                       if pair[0] != pair[1]), min(len(actual_bytes), len(expected_bytes)))
            raise AssertionError(
                f"{label} tick {tick_index}: MIDI byte {at} differs; "
                f"got {actual_bytes[at:at+1]}, expected {expected_bytes[at:at+1]} "
                f"(counts {len(actual_bytes)} and {len(expected_bytes)})")
        checks += 1
    return checks


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--no-build", action="store_true",
                        help="reuse the already-generated ROLAND_GEN.H")
    args = parser.parse_args()
    if not args.no_build:
        _ensure_header()
    elif not (BUILD / "ROLAND_GEN.H").is_file():
        raise FileNotFoundError("generated ROLAND_GEN.H is missing; run tools/host.py first")

    source_image = assemble_driver("roland")
    asset_image, _metadata = resource_driver("roland")
    if source_image != asset_image:
        raise AssertionError("source-built ROLAND module differs from ROLAND.ENC")
    if len(source_image) != _macro("ROLAND_MODULE_BYTES"):
        raise AssertionError("generated module size disagrees with the driver image")

    lib = _native_library()
    oracle = ModuleOracle(source_image)
    expected_setup = oracle.initialize()
    full_candidate = bytearray(IMAGE_BYTES)
    full_candidate[:len(source_image)] = source_image
    candidate_view = (ctypes.c_uint8 * IMAGE_BYTES).from_buffer(full_candidate)
    lib.probe_unbind()
    if not lib.probe_bind(candidate_view, IMAGE_BYTES):
        raise AssertionError("native sequencer rejected a complete module segment")
    lib.probe_clear_bytes()
    if not lib.probe_initialize():
        raise AssertionError("native setup rejected the ready MIDI sink")
    actual_setup = _candidate_bytes(lib)
    if actual_setup != expected_setup:
        at = next((i for i, pair in enumerate(zip(actual_setup, expected_setup))
                   if pair[0] != pair[1]), min(len(actual_setup), len(expected_setup)))
        raise AssertionError(
            f"MT-32 setup MIDI byte {at} differs: got {actual_setup[at:at+1]}, "
            f"expected {expected_setup[at:at+1]}")

    checks = 0
    for tune in range(1, 11):
        checks += _run_sequence(lib, source_image, {0: tune}, 600, f"tune {tune}")
    checks += _run_sequence(lib, source_image,
                            {0: 1, 64: 2, 192: 0xFF, 320: 4}, 480,
                            "replacement and stop requests")
    lib.probe_unbind()
    print(f"Roland sequencer matched module state and MIDI event order for "
          f"{checks:,} timer ticks; MT-32 setup matched {len(actual_setup):,} bytes.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
