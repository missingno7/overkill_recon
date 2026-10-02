"""Compare the native AdLib sequencer with bounded calls to the original module.

Run ``python tests/host/adlib_sequence.py``. The test freshly assembles ADLIB.ASM,
checks it against the shipped ADLIB.ENC image, then compares module bytes and ordered
OPL register writes after every timer tick for all ten tunes.
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
from unicorn.x86_const import UC_X86_REG_IP, UC_X86_REG_SP, UC_X86_REG_SS

ROOT = Path(__file__).resolve().parents[2]
BUILD = ROOT / "build/host"
IMAGE_BYTES = 0x10000
MODULE_SEGMENT = 0x2000
STACK_SEGMENT = 0x7000
STACK_OFFSET = 0xFF00
RETURN_IP = 0xFFFE

sys.path.insert(0, str(ROOT / "tools"))
from build import assemble_driver  # noqa: E402
from resources import driver as resource_driver  # noqa: E402


def _macro(name: str) -> int:
    header = (BUILD / "ADLIB_GEN.H").read_text(encoding="ascii")
    match = re.search(rf"^#define\s+{re.escape(name)}\s+(0x[0-9A-Fa-f]+)",
                      header, re.MULTILINE)
    if match is None:
        raise AssertionError(f"generated ADLIB_GEN.H lacks {name}")
    return int(match.group(1), 16)


def _native_library() -> ctypes.CDLL:
    BUILD.mkdir(parents=True, exist_ok=True)
    wrapper = BUILD / "adlib_sequence_probe.c"
    library = BUILD / ("adlib_sequence_probe.dll" if os.name == "nt"
                       else "libadlib_sequence_probe.so")
    wrapper.write_text(r"""
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include "adlib_sequence.h"

typedef struct { uint8_t reg, value; } OplWrite;
static OplWrite writes[16384];
static size_t write_count;

void sound_services_opl2_write(uint8_t reg, uint8_t value)
{
    if (write_count < sizeof(writes) / sizeof(writes[0])) {
        writes[write_count].reg = reg;
        writes[write_count].value = value;
        ++write_count;
    }
}

int probe_bind(uint8_t *image, size_t bytes) { return adlib_sequence_bind(image, bytes); }
void probe_unbind(void) { adlib_sequence_unbind(); }
void probe_request(uint8_t tune) { adlib_sequence_request(tune); }
void probe_tick(void) { adlib_sequence_tick(); }
void probe_clear_writes(void) { write_count = 0; }
size_t probe_write_count(void) { return write_count; }
size_t probe_copy_writes(OplWrite *out, size_t capacity)
{
    size_t count = write_count < capacity ? write_count : capacity;
    memcpy(out, writes, count * sizeof(*out));
    return count;
}
""", encoding="ascii")

    compiler = os.environ.get("CC", "gcc")
    command = [compiler, "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
               "-shared", "-I" + str(ROOT / "host"), "-I" + str(BUILD),
               str(ROOT / "host/adlib_sequence.c"), str(wrapper), "-o", str(library)]
    if os.name != "nt":
        command.insert(6, "-fPIC")
    subprocess.run(command, check=True, cwd=ROOT)
    lib = ctypes.CDLL(str(library))
    lib.probe_bind.argtypes = (ctypes.POINTER(ctypes.c_uint8), ctypes.c_size_t)
    lib.probe_bind.restype = ctypes.c_int
    lib.probe_unbind.argtypes = ()
    lib.probe_request.argtypes = (ctypes.c_uint8,)
    lib.probe_tick.argtypes = ()
    lib.probe_clear_writes.argtypes = ()
    lib.probe_write_count.argtypes = ()
    lib.probe_write_count.restype = ctypes.c_size_t
    lib.probe_copy_writes.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.probe_copy_writes.restype = ctypes.c_size_t
    return lib


class ModuleOracle:
    """Run only the source-built module's MusicTick routine with inert ports."""

    def __init__(self, module_image: bytes):
        self.base = MODULE_SEGMENT << 4
        self.memory = bytearray(IMAGE_BYTES)
        self.memory[:len(module_image)] = module_image
        self.uc = Uc(UC_ARCH_X86, UC_MODE_16)
        self.uc.mem_map(0, 0x100000)
        self.uc.mem_write(self.base, bytes(self.memory))
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
    def _port_in(_uc, _port, _size, _data):
        return 0

    def _port_out(self, _uc, port, size, value, _data):
        mask = (1 << (size * 8)) - 1
        self.ports.append((port, value & mask))

    def _return(self, uc, _address, _size, _data):
        if (uc.reg_read(UC_X86_REG_CS) == MODULE_SEGMENT and
                uc.reg_read(UC_X86_REG_IP) == RETURN_IP and
                uc.reg_read(UC_X86_REG_SP) == STACK_OFFSET):
            uc.emu_stop()

    def request(self, tune: int):
        self.uc.mem_write(self.base + _macro("ADLIB_MUSICREQUEST"),
                          struct.pack("<H", tune & 0xFF))

    def tick(self) -> tuple[bytes, list[tuple[int, int]]]:
        self.ports.clear()
        stack = (STACK_SEGMENT << 4) + STACK_OFFSET - 2
        self.uc.mem_write(stack, struct.pack("<H", RETURN_IP))
        self.uc.reg_write(UC_X86_REG_SP, STACK_OFFSET - 2)
        try:
            self.uc.emu_start(self.base + _macro("ADLIB_MUSICTICK"), 0,
                              count=2_000_000)
        except UcError as error:
            raise AssertionError(f"MusicTick CPU fault: {error}") from error
        if self.uc.reg_read(UC_X86_REG_IP) != RETURN_IP:
            raise AssertionError("MusicTick did not return to the bounded sentinel")

        writes = []
        selected_register = None
        for port, value in self.ports:
            if port == 0x388:
                selected_register = value
            elif port == 0x389:
                if selected_register is None:
                    raise AssertionError("OPL data port write without a register select")
                writes.append((selected_register, value))
                selected_register = None
        if selected_register is not None:
            raise AssertionError("OPL register select had no data write")
        state = bytes(self.uc.mem_read(self.base, IMAGE_BYTES))
        return state, writes


def _candidate_tick(lib, buffer) -> tuple[bytes, list[tuple[int, int]]]:
    lib.probe_clear_writes()
    lib.probe_tick()
    count = lib.probe_write_count()
    storage = (ctypes.c_uint8 * (count * 2))()
    copied = lib.probe_copy_writes(storage, count)
    if copied != count:
        raise AssertionError("native OPL write buffer truncated")
    flat = bytes(storage)
    writes = [(flat[i], flat[i + 1]) for i in range(0, len(flat), 2)]
    return bytes(buffer), writes


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
        expected_state, expected_writes = oracle.tick()
        actual_state, actual_writes = _candidate_tick(lib, candidate)
        if actual_state != expected_state:
            first = next(i for i, (a, b) in enumerate(zip(actual_state, expected_state)) if a != b)
            raise AssertionError(
                f"{label} tick {tick_index}: module byte {first:04X} is "
                f"{actual_state[first]:02X}, expected {expected_state[first]:02X}")
        if actual_writes != expected_writes:
            at = next((i for i, pair in enumerate(zip(actual_writes, expected_writes))
                       if pair[0] != pair[1]), min(len(actual_writes), len(expected_writes)))
            raise AssertionError(
                f"{label} tick {tick_index}: OPL write {at} differs; "
                f"got {actual_writes[at:at+1]}, expected {expected_writes[at:at+1]} "
                f"(counts {len(actual_writes)} and {len(expected_writes)})")
        checks += 1
    return checks


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--no-build", action="store_true",
                        help="reuse the already-generated ADLIB_GEN.H")
    args = parser.parse_args()
    if not args.no_build or not (BUILD / "ADLIB_GEN.H").is_file():
        # host.py emits the derived ADLIB_GEN.H as part of the native build.
        subprocess.run([sys.executable, str(ROOT / "tools/host.py")], check=True,
                       cwd=ROOT)

    source_image = assemble_driver("adlib")
    asset_image, _metadata = resource_driver("adlib")
    if source_image != asset_image:
        raise AssertionError("source-built AdLib module differs from ADLIB.ENC")
    if len(source_image) != _macro("ADLIB_MODULE_BYTES"):
        raise AssertionError("generated module size disagrees with the driver image")

    lib = _native_library()
    checks = 0
    for tune in range(1, 11):
        checks += _run_sequence(lib, source_image, {0: tune}, 600,
                                f"tune {tune}")
    checks += _run_sequence(lib, source_image,
                            {0: 1, 64: 2, 192: 0xFF, 320: 4}, 480,
                            "replacement and stop requests")
    lib.probe_unbind()
    print(f"AdLib sequencer matched the module state and OPL event order for "
          f"{checks:,} timer ticks.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
