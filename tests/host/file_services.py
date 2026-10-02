"""Native DOS plain-file mailbox checks against the exact ASM oracle.

Run ``python tests/host/file_services.py --no-build`` to reuse the current host
core and source-built oracle. File side effects are confined to a temporary C:
drive root mounted by both the DOS interrupt fixture and the native resource API.
"""
from __future__ import annotations

import argparse
import ctypes
from pathlib import Path
import shutil
import struct
import sys
import tempfile
from unicorn import UcError, UC_HOOK_CODE

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
TESTS = ROOT / "tests"
HOST_TESTS = ROOT / "tests/host"
sys.path.insert(0, str(TOOLS))
sys.path.insert(0, str(TESTS))
sys.path.insert(0, str(HOST_TESTS))

from emu import FLAG, Machine, REG  # noqa: E402

ORACLE_EXE = ROOT / "build/oracle-sym/OVERKILL.EXE"
HOST_DIR = ROOT / "build/host"
STATE_BYTES = 0x10000
DOS_PATH_AT = 0xF000
BUFFER_AT = 0xE000


class FileMachine(Machine):
    """Add DOS 21h file operations used by the frozen resource and mailbox leaves."""

    def __init__(self, exe: Path, drive_root: Path) -> None:
        super().__init__(exe)
        self.drive_root = Path(drive_root)
        self.files = {}
        self.read_log = []

    def close_all(self) -> None:
        for file in self.files.values():
            file.close()
        self.files.clear()

    def _path(self, u, offset: int) -> Path | None:
        segment = u.reg_read(REG["DS"])
        raw = bytearray()
        for index in range(4096):
            address = (segment << 4) + ((offset + index) & 0xFFFF)
            value = u.mem_read(address, 1)[0]
            if value == 0:
                break
            raw.append(value)
        else:
            return None
        text = raw.decode("ascii")
        if len(text) >= 2 and text[1] == ":":
            if text[0].upper() != "C":
                return None
            text = text[2:]
        relative = text.lstrip("\\/").replace("\\", "/")
        path = (self.drive_root / relative).resolve()
        try:
            path.relative_to(self.drive_root.resolve())
        except ValueError:
            return None
        return path

    def _interrupt(self, u, number, _):
        ax = u.reg_read(REG["AX"])
        flags = u.reg_read(REG["FLAGS"]) & ~FLAG["CF"]
        if number != 0x21:
            return super()._interrupt(u, number, _)

        function = ax >> 8
        if function in (0x3C, 0x3D):
            path = self._path(u, u.reg_read(REG["DX"]))
            try:
                if path is None:
                    raise FileNotFoundError
                file = path.open("wb" if function == 0x3C else "rb")
            except OSError as error:
                dos_error = 3 if isinstance(error, NotADirectoryError) else 2
                u.reg_write(REG["AX"], dos_error)
                u.reg_write(REG["FLAGS"], flags | FLAG["CF"])
                return
            handle = 5
            while handle in self.files and handle < 0xFFFF:
                handle += 1
            if handle == 0xFFFF:
                file.close()
                u.reg_write(REG["AX"], 4)
                u.reg_write(REG["FLAGS"], flags | FLAG["CF"])
                return
            self.files[handle] = file
            u.reg_write(REG["AX"], handle)
            u.reg_write(REG["FLAGS"], flags)
            return

        handle = u.reg_read(REG["BX"])
        file = self.files.get(handle)
        if function == 0x3E:
            if file is None:
                u.reg_write(REG["AX"], 6)
                u.reg_write(REG["FLAGS"], flags | FLAG["CF"])
                return
            try:
                file.close()
                del self.files[handle]
            except OSError:
                u.reg_write(REG["AX"], 5)
                u.reg_write(REG["FLAGS"], flags | FLAG["CF"])
                return
            u.reg_write(REG["AX"], 0)
            u.reg_write(REG["FLAGS"], flags)
            return

        if function in (0x3F, 0x40):
            if file is None:
                u.reg_write(REG["AX"], 6)
                u.reg_write(REG["FLAGS"], flags | FLAG["CF"])
                return
            count = u.reg_read(REG["CX"])
            segment = u.reg_read(REG["DS"])
            offset = u.reg_read(REG["DX"])
            try:
                if function == 0x3F:
                    data = file.read(count)
                    if data:
                        u.mem_write((segment << 4) + offset, data)
                    transferred = len(data)
                    self.read_log.append((handle, count, transferred))
                else:
                    data = bytes(u.mem_read((segment << 4) + offset, count))
                    transferred = file.write(data)
                    file.flush()
            except OSError:
                u.reg_write(REG["AX"], 5)
                u.reg_write(REG["FLAGS"], flags | FLAG["CF"])
                return
            u.reg_write(REG["AX"], transferred & 0xFFFF)
            u.reg_write(REG["FLAGS"], flags)
            return

        if function == 0x42:
            if file is None:
                u.reg_write(REG["AX"], 6)
                u.reg_write(REG["FLAGS"], flags | FLAG["CF"])
                return
            origin = ax & 0xFF
            displacement = ((u.reg_read(REG["CX"]) << 16) |
                            u.reg_read(REG["DX"]))
            if displacement & 0x80000000:
                displacement -= 0x100000000
            whence = {0: 0, 1: 1, 2: 2}.get(origin)
            try:
                if whence is None:
                    raise ValueError("invalid DOS seek origin")
                file.seek(displacement, whence)
                position = file.tell()
                if position < 0 or position > 0xFFFFFFFF:
                    raise OSError("DOS seek position is out of range")
            except (OSError, ValueError):
                u.reg_write(REG["AX"], 1)
                u.reg_write(REG["FLAGS"], flags | FLAG["CF"])
                return
            u.reg_write(REG["AX"], position & 0xFFFF)
            u.reg_write(REG["DX"], (position >> 16) & 0xFFFF)
            u.reg_write(REG["FLAGS"], flags)
            return

        return super()._interrupt(u, number, _)

    def far_call(self, label: str, regs=None, flags=0x0202, limit=5000000):
        """Call a far oracle entry with a sentinel return frame."""
        segment, offset = self.symbols[label.upper()]
        cs = 0x1010 + segment
        sp = self.stack_top - 0x100
        return_ip = 0xFFFE
        self.set_word(sp, return_ip)
        self.set_word(sp + 2, cs)
        values = dict(AX=0, BX=0, CX=0, DX=0, SI=0, DI=0, BP=0,
                      ES=self.data_frame)
        values.update(regs or {})
        for register, value in values.items():
            self.u.reg_write(REG[register], value & 0xFFFF)
        for register in ("DS", "SS"):
            self.u.reg_write(REG[register], self.data_frame)
        self.u.reg_write(REG["CS"], cs)
        self.u.reg_write(REG["SP"], sp)
        self.u.reg_write(REG["FLAGS"], flags)
        self.fault = None
        self.ports = []
        sentinel = cs * 16 + return_ip

        def returned(u, _address, _size, _):
            if (u.reg_read(REG["CS"]) == cs and
                    u.reg_read(REG["SP"]) == sp + 4):
                u.emu_stop()

        hook = self.u.hook_add(UC_HOOK_CODE, returned, None, sentinel, sentinel)
        try:
            self.u.emu_start(cs * 16 + offset, 0, count=limit)
        except UcError as error:
            raise AssertionError(
                f"{label}: CPU fault {error} at "
                f"{self.u.reg_read(REG['CS']):04X}:{self.u.reg_read(REG['IP']):04X}")
        finally:
            self.u.hook_del(hook)
        ip = self.u.reg_read(REG["CS"]) * 16 + self.u.reg_read(REG["IP"])
        if self.fault:
            raise AssertionError(f"{label}: {self.fault} at linear {ip:05X}")
        if ip != sentinel:
            raise AssertionError(f"{label}: did not return within {limit} instructions")
        return {register: self.u.reg_read(REG[register])
                for register in ("AX", "BX", "CX", "DX", "SI", "DI", "BP",
                                 "ES", "SP", "DS", "SS", "FLAGS")}


class EmsFileMachine(FileMachine):
    """File fixture with the small EMS handle/page-frame behavior used by cache leaves."""

    EMS_PAGE_BYTES = 0x4000

    def __init__(self, exe: Path, drive_root: Path) -> None:
        super().__init__(exe, drive_root)
        self.ems_pages = {}
        self.ems_frame_map = {}

    def _interrupt(self, u, number, data):
        if number != 0x67:
            return super()._interrupt(u, number, data)
        ax = u.reg_read(REG["AX"])
        function = ax >> 8
        if function == 0x43:
            page_count = u.reg_read(REG["BX"])
            handle = next((candidate for candidate in range(1, 0x100)
                           if candidate not in self.ems_pages), None)
            if handle is None or page_count == 0:
                u.reg_write(REG["AX"], 0x8000)
                return
            self.ems_pages[handle] = [bytearray(self.EMS_PAGE_BYTES)
                                      for _ in range(page_count)]
            u.reg_write(REG["AX"], 0)
            u.reg_write(REG["DX"], handle)
            return
        if function == 0x44:
            physical_page = ax & 0xFF
            logical_page = u.reg_read(REG["BX"])
            handle = u.reg_read(REG["DX"])
            pages = self.ems_pages.get(handle)
            if (pages is None or logical_page >= len(pages) or
                    physical_page >= 4):
                u.reg_write(REG["AX"], 0x8000)
                return
            frame_segment = self.word(self.offset("EmsPageFrame"))
            frame_address = ((frame_segment << 4) +
                             physical_page * self.EMS_PAGE_BYTES)
            previous = self.ems_frame_map.get(physical_page)
            if previous is not None:
                previous_handle, previous_page = previous
                self.ems_pages[previous_handle][previous_page][:] = bytes(
                    u.mem_read(frame_address, self.EMS_PAGE_BYTES))
            u.mem_write(frame_address, bytes(pages[logical_page]))
            self.ems_frame_map[physical_page] = (handle, logical_page)
            u.reg_write(REG["AX"], 0)
            return
        if function == 0x45:
            handle = u.reg_read(REG["DX"])
            self.ems_pages.pop(handle, None)
            for physical, mapping in tuple(self.ems_frame_map.items()):
                if mapping[0] == handle:
                    del self.ems_frame_map[physical]
            u.reg_write(REG["AX"], 0)
            return
        raise AssertionError(f"unexpected INT 67h function {function:02X}")


class HostRegisters(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in
                ("ax", "bx", "cx", "dx", "si", "di", "bp", "es")]


def _word(h, name: str, value: int) -> None:
    h.write_symbol(name, struct.pack("<H", value & 0xFFFF))


def _request(h, path: str, *, count: int = 0, data: bytes = b"") -> None:
    h.write(DOS_PATH_AT, path.encode("ascii") + b"\0")
    h.write(BUFFER_AT, data)
    _word(h, "FileNamePtr", DOS_PATH_AT)
    _word(h, "FileBufferSegment", h.m.data_frame)
    _word(h, "FileBufferOffset", BUFFER_AT)
    _word(h, "FileByteCount", count)


def _invoke_pair(h, token: int, label: str, es: int = 0xBEEF) -> None:
    oracle_regs = h.m.call(label, {"ES": es})
    registers = HostRegisters(0x1357, 0x2468, 0x369A, 0x48BC,
                              0x5ADE, 0x6CF0, 0x7E12, es)
    handled = h.lib.overkill_file_service(token, ctypes.byref(registers))
    if handled != 1:
        raise AssertionError(f"native {label} service did not claim its token")
    if registers.es != es or oracle_regs["ES"] != es:
        raise AssertionError(f"{label} changed ES across the DOS service boundary")
    h.compare(label)


def _bind_native_file_api(h) -> None:
    h.lib.overkill_bind_real_memory.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    h.lib.overkill_bind_real_memory.restype = ctypes.c_int
    h.lib.overkill_file_service.argtypes = (
        ctypes.c_uint16, ctypes.POINTER(HostRegisters))
    h.lib.overkill_file_service.restype = ctypes.c_int
    h.lib.overkill_resource_mount_drive.argtypes = (ctypes.c_char, ctypes.c_char_p)
    h.lib.overkill_resource_mount_drive.restype = ctypes.c_int
    h.lib.overkill_resource_set_current_drive.argtypes = (ctypes.c_char,)
    h.lib.overkill_resource_set_current_drive.restype = ctypes.c_int
    h.lib.overkill_file_services_set_save_root.argtypes = (ctypes.c_char_p,)
    h.lib.overkill_file_services_set_save_root.restype = ctypes.c_int


def _test_load(h, source: Path) -> int:
    h.reset()
    data = bytes(range(256)) * 4 + b"\0plain-DOS-file\xff"
    source.write_bytes(data)
    _request(h, r"C:\LOAD.BIN")
    _word(h, "FileStatus", 0x7777)
    _word(h, "FileByteCount", 0x1234)
    _word(h, "FileHandle", 0x8888)
    token = h.m.symbols["LOADFILETOBUFFER"][1]
    _invoke_pair(h, token, "LoadFileToBuffer")
    if bytes(h.state[BUFFER_AT:BUFFER_AT + len(data)]) != data:
        raise AssertionError("load did not copy the entire file into the guest buffer")
    if int.from_bytes(h.state[h.offset("FileByteCount"):h.offset("FileByteCount") + 2], "little") != len(data):
        raise AssertionError("load did not store the DOS byte count")
    if int.from_bytes(h.state[h.offset("FileStatus"):h.offset("FileStatus") + 2], "little") != 0:
        raise AssertionError("successful load did not set FileStatus to OK")
    return 1


def _test_open_failure(h) -> int:
    h.reset()
    _request(h, r"C:\MISSING.BIN")
    _word(h, "FileStatus", 0x7777)
    _word(h, "FileByteCount", 0x1234)
    _word(h, "FileHandle", 0x8888)
    token = h.m.symbols["LOADFILETOBUFFER"][1]
    _invoke_pair(h, token, "LoadFileToBuffer")
    for name, expected in (("FileStatus", 1), ("FileByteCount", 0x1234),
                           ("FileHandle", 0x8888)):
        actual = int.from_bytes(h.state[h.offset(name):h.offset(name) + 2], "little")
        if actual != expected:
            raise AssertionError(f"open failure: {name}={actual:04X}, expected {expected:04X}")
    return 1


def _test_save(h, destination: Path) -> int:
    h.reset()
    payload = b"replacement bytes\x00\xff\x10"
    destination.write_bytes(b"old contents which must be truncated")
    _request(h, r"C:\SAVE.BIN", count=len(payload), data=payload)
    _word(h, "FileStatus", 0x7777)
    _word(h, "FileHandle", 0x8888)
    token = h.m.symbols["SAVEBUFFERTOFILE"][1]
    _invoke_pair(h, token, "SaveBufferToFile")
    if destination.read_bytes() != payload:
        raise AssertionError("save did not truncate and replace the destination bytes")
    for name, expected in (("FileStatus", 0x7777), ("FileByteCount", len(payload))):
        actual = int.from_bytes(h.state[h.offset(name):h.offset(name) + 2], "little")
        if actual != expected:
            raise AssertionError(f"save changed {name}: {actual:04X}, expected {expected:04X}")
    return 1


def _test_create_failure(h) -> int:
    h.reset()
    _request(h, r"C:\NO-SUCH-DIRECTORY\SAVE.BIN", count=3, data=b"abc")
    _word(h, "FileStatus", 0x7777)
    _word(h, "FileHandle", 0x8888)
    token = h.m.symbols["SAVEBUFFERTOFILE"][1]
    _invoke_pair(h, token, "SaveBufferToFile")
    for name, expected in (("FileStatus", 0x7777), ("FileByteCount", 3),
                           ("FileHandle", 0x8888)):
        actual = int.from_bytes(h.state[h.offset(name):h.offset(name) + 2], "little")
        if actual != expected:
            raise AssertionError(f"create failure changed {name}: {actual:04X}, expected {expected:04X}")
    return 1


def _test_save_root_override(h, drive_root: Path, save_root: Path) -> int:
    game_file = drive_root / "hiscore.dat"
    saved_file = save_root / "hiscore.dat"
    saved_file.parent.mkdir(parents=True, exist_ok=True)
    original = b"same initial hiscore bytes"
    game_file.write_bytes(original)
    saved_file.write_bytes(original)

    h.reset()
    _request(h, r"C:\HISCORE.DAT")
    token = h.m.symbols["LOADFILETOBUFFER"][1]
    _invoke_pair(h, token, "LoadFileToBuffer")
    if bytes(h.state[BUFFER_AT:BUFFER_AT + len(original)]) != original:
        raise AssertionError("HISCORE.DAT override load returned incorrect bytes")

    h.reset()
    payload = b"persistent native score data\0\xff"
    _request(h, r"C:\HISCORE.DAT", count=len(payload), data=payload)
    _word(h, "FileStatus", 0x5151)
    token = h.m.symbols["SAVEBUFFERTOFILE"][1]
    _invoke_pair(h, token, "SaveBufferToFile")
    if game_file.read_bytes() != payload or saved_file.read_bytes() != payload:
        raise AssertionError("HISCORE.DAT override did not preserve the DOS and native save targets")

    # The override is name-specific; ordinary mailbox paths still use the DOS drive.
    return _test_save(h, drive_root / "SAVE.BIN") + 2


class PackedLoadResult(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in
                ("failed", "ax", "output_offset", "started_decoder", "bx")]


class EncFileResult(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in
                ("failed", "ax", "si", "di", "flags", "bp")]


RESOURCE_STATE = (("RESOPTIONS", 2), ("RESCURARCHIVE", 2),
                  ("RESSEARCHSTART", 2), ("RESHANDLE", 2),
                  ("RESNAMEPTR", 4), ("RESENTRYCOUNT", 2), ("RESKEY", 2),
                  ("RESSIGNATURE", 6), ("RESENTRYSIZE", 2),
                  ("RESENTRYBUF", 26), ("RESARCHIVEBASE", 4),
                  ("RESARCHIVELIST", 0x72))


def _bind_resource_test_api(h) -> None:
    lib = h.lib
    lib.archive_setup_resource_library.argtypes = ()
    lib.archive_setup_resource_library.restype = None
    lib.archive_open_by_name.argtypes = (ctypes.c_uint16,)
    lib.archive_open_by_name.restype = ctypes.c_uint32
    lib.packed_load_file.argtypes = (ctypes.POINTER(PackedLoadResult), ctypes.c_uint16)
    lib.packed_load_file.restype = None
    lib.enc_decode_file.argtypes = (ctypes.POINTER(EncFileResult),)
    lib.enc_decode_file.restype = None
    lib.cache_loaded_file.argtypes = (ctypes.c_uint16,)
    lib.cache_loaded_file.restype = ctypes.c_uint16
    lib.copy_from_file_cache.argtypes = ()
    lib.copy_from_file_cache.restype = ctypes.c_uint16
    lib.release_ems_cache.argtypes = ()
    lib.release_ems_cache.restype = None
    lib.overkill_resource_seek.argtypes = (
        ctypes.c_uint16, ctypes.c_uint16, ctypes.c_uint16, ctypes.c_uint16,
        ctypes.POINTER(ctypes.c_uint16))
    lib.overkill_resource_seek.restype = ctypes.c_uint32
    lib.overkill_resource_read_buffer.argtypes = (
        ctypes.c_uint16, ctypes.c_uint16, ctypes.c_void_p)
    lib.overkill_resource_read_buffer.restype = ctypes.c_uint32
    lib.overkill_resource_close_result.argtypes = (ctypes.c_uint16,)
    lib.overkill_resource_close_result.restype = ctypes.c_uint32
    lib.overkill_bind_state.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_bind_state.restype = ctypes.c_int


def _bind_native_oracle_image(h, machine: FileMachine):
    """Bind native C to this fixture's exact relocated 1 MiB DOS image."""
    size = 0x100000
    raw = ctypes.create_string_buffer(size + 15)
    base = (ctypes.addressof(raw) + 15) & ~15
    image = bytes(machine.u.mem_read(0, size))
    ctypes.memmove(base, image, size)
    arena = (ctypes.c_ubyte * size).from_address(base)
    if not h.lib.overkill_bind_real_memory(arena, size):
        raise AssertionError("native memory adapter rejected the oracle's real-mode arena")
    if not h.lib.overkill_bind_state(base + machine.data_frame * 16, STATE_BYTES):
        raise AssertionError("native state adapter rejected the oracle's DS frame")
    h.lib.archive_setup_resource_library()
    return raw, arena, base


def _new_resource_machine(resource_root: Path, name: str | None = None) -> FileMachine:
    machine = FileMachine(ORACLE_EXE, resource_root)
    machine.call("SetupResourceArchive")
    if name is not None:
        machine.write(DOS_PATH_AT, name.encode("ascii") + b"\0")
    return machine


def _native_symbol(base: int, machine: FileMachine, name: str, size: int) -> bytes:
    return ctypes.string_at(base + machine.linear(name), size)


def _compare_resource_state(base: int, machine: FileMachine, label: str) -> None:
    for name, size in RESOURCE_STATE:
        native = _native_symbol(base, machine, name, size)
        oracle = bytes(machine.u.mem_read(machine.linear(name), size))
        if native != oracle:
            raise AssertionError(f"{label}: native {name} differs from the ASM result")
    native_state = ctypes.string_at(base + machine.data_frame * 16, STATE_BYTES)
    oracle_state = machine.state()
    stack_lo = machine.offset("StackArea")
    stack_hi = machine.stack_top
    if (native_state[:stack_lo] != oracle_state[:stack_lo] or
            native_state[stack_hi:] != oracle_state[stack_hi:]):
        for offset, (got, want) in enumerate(zip(native_state, oracle_state)):
            if stack_lo <= offset < stack_hi:
                continue
            if got != want:
                raise AssertionError(
                    f"{label}: native DS:{offset:04X}={got:02X}, ASM={want:02X}")


def _read_native_handle(lib, handle: int, count: int) -> bytes:
    buffer = (ctypes.c_ubyte * count)()
    result = lib.overkill_resource_read_buffer(handle, count, buffer)
    if result >> 16 or (result & 0xFFFF) != count:
        raise AssertionError(f"native archive payload read returned {result:08X}")
    return bytes(buffer)


def _test_archive_lookup(h, resource_root: Path, name: str, *, found: bool) -> int:
    machine = _new_resource_machine(resource_root, name)
    _raw, _arena, base = _bind_native_oracle_image(h, machine)
    oracle = machine.far_call("OpenResourceFile", {"AX": 0x3D02, "DX": DOS_PATH_AT,
                                                       "SI": 0x1357, "DI": 0x2468,
                                                       "ES": 0xBEEF})
    native = h.lib.archive_open_by_name(DOS_PATH_AT)
    expected_status = 0 if found else 1
    expected_handle = oracle["AX"]
    if (oracle["FLAGS"] & FLAG["CF"]) != expected_status:
        raise AssertionError(f"ASM OpenResourceFile found={found} returned wrong carry")
    if native >> 16 != expected_status or native & 0xFFFF != expected_handle:
        raise AssertionError(
            f"archive lookup {name}: native {native:08X}, "
            f"ASM AX={expected_handle:04X} CF={expected_status}")
    _compare_resource_state(base, machine, f"archive lookup {name}")

    if found:
        length = (oracle["DX"] << 16) | oracle["CX"]
        if length == 0:
            raise AssertionError(f"ASM archive lookup returned an empty length for {name}")
        native_position = ctypes.c_uint16(0xFFFF)
        position = h.lib.overkill_resource_seek(expected_handle, 0, 0, 1,
                                                 ctypes.byref(native_position))
        if native_position.value != 0 or position != machine.files[expected_handle].tell():
            raise AssertionError(f"archive lookup {name}: file handle positions differ")
        sample = min(length, 64)
        oracle_bytes = machine.files[expected_handle].read(sample)
        native_bytes = _read_native_handle(h.lib, expected_handle, sample)
        if oracle_bytes != native_bytes:
            raise AssertionError(f"archive lookup {name}: payload bytes differ")
        machine.files[expected_handle].close()
        del machine.files[expected_handle]
        native_close = h.lib.overkill_resource_close_result(expected_handle)
        if native_close != 0:
            raise AssertionError(f"archive lookup {name}: native close returned {native_close:08X}")
    return 1


def _compare_packed_output(base: int, machine: FileMachine, segment: int,
                           offset: int, length: int, label: str) -> None:
    if length > 0x10000 - offset:
        raise AssertionError(f"{label}: decoded output crosses the test destination window")
    address = (segment << 4) + offset
    native = ctypes.string_at(base + address, 0x10000 - offset)
    oracle = bytes(machine.u.mem_read(address, 0x10000 - offset))
    if native != oracle:
        for index, (got, want) in enumerate(zip(native, oracle)):
            if got != want:
                raise AssertionError(
                    f"{label}: decoded output at {segment:04X}:{offset + index:04X} "
                    f"native={got:02X}, ASM={want:02X}")


def _test_packed_resource(h, resource_root: Path, name: str) -> int:
    machine = _new_resource_machine(resource_root, name)
    machine.poke("PackedNamePtr", DOS_PATH_AT)
    machine.poke("PackedDestSegment", 0x7000)
    machine.poke("PackedDestOffset", 0x0123)
    machine.poke("PackedReadCursor", machine.symbols["PACKEDREADBUFFER"][1] + 0x0200)
    machine.poke("PackedOutputBytes", 0)
    machine.poke("PackedOpenFailed", 1)
    _raw, _arena, base = _bind_native_oracle_image(h, machine)

    oracle = machine.call("LoadPackedFile")
    native_result = PackedLoadResult()
    h.lib.packed_load_file(ctypes.byref(native_result), 0xBEEF)
    label = f"packed {name}"
    if bool(oracle["FLAGS"] & FLAG["CF"]) != bool(native_result.failed):
        raise AssertionError(f"{label}: success/carry differs")
    for field, expected in (("AX", oracle["AX"]), ("BX", oracle["BX"]),
                            ("DI", oracle["DI"])):
        actual = {"AX": native_result.ax, "BX": native_result.bx,
                  "DI": native_result.output_offset}[field]
        if actual != expected:
            raise AssertionError(f"{label}: {field} native={actual:04X}, ASM={expected:04X}")
    output_bytes = machine.peek("PackedOutputBytes")
    native_count = struct.unpack("<H", _native_symbol(base, machine,
                                                       "PackedOutputBytes", 2))[0]
    if native_count != output_bytes:
        raise AssertionError(f"{label}: output byte count native={native_count}, ASM={output_bytes}")
    if native_result.started_decoder != 1:
        raise AssertionError(f"{label}: native loader did not enter a decoder")
    _compare_packed_output(base, machine, 0x7000, 0x0123, output_bytes, label)
    for symbol, size in (("PACKEDREADBUFFER", 0x200), ("PACKEDREADCURSOR", 2),
                         ("PACKEDOUTPUTBYTES", 2), ("PACKEDFILEHANDLE", 2),
                         ("PACKEDCOLUMNHEADER0", 2), ("PACKEDCOLUMNWIDTH", 2),
                         ("PACKEDCOLUMNHEADER2", 2)):
        if _native_symbol(base, machine, symbol, size) != bytes(
                machine.u.mem_read(machine.linear(symbol), size)):
            raise AssertionError(f"{label}: native {symbol} differs from the ASM result")
    _compare_resource_state(base, machine, label)
    return 1


def _test_enc_resource(h, resource_root: Path, name: str) -> int:
    machine = _new_resource_machine(resource_root, name)
    machine.poke("EncDestSegment", 0x7000)
    machine.poke("EncDestOffset", 0x0123)
    oracle_open = machine.far_call("OpenResourceFile", {"AX": 0x3D02,
                                                           "DX": DOS_PATH_AT})
    if oracle_open["FLAGS"] & FLAG["CF"]:
        raise AssertionError(f"ASM could not open shipped ENC resource {name}")
    machine.poke("EncFileHandle", oracle_open["AX"])
    _raw, _arena, base = _bind_native_oracle_image(h, machine)

    native_open = h.lib.archive_open_by_name(DOS_PATH_AT)
    if native_open >> 16 or (native_open & 0xFFFF) == 0:
        raise AssertionError(f"native could not open shipped ENC resource {name}: {native_open:08X}")
    native_handle = native_open & 0xFFFF
    machine.poke("EncFileHandle", native_handle)
    machine.poke("EncDestSegment", 0x7000)
    machine.poke("EncDestOffset", 0x0123)
    _compare_resource_state(base, machine, f"ENC archive open {name}")

    oracle = machine.call("DecodeEncFile")
    native_result = EncFileResult()
    h.lib.enc_decode_file(ctypes.byref(native_result))
    label = f"ENC {name}"
    if bool(oracle["FLAGS"] & FLAG["CF"]) != bool(native_result.failed):
        raise AssertionError(f"{label}: success/carry differs")
    if oracle["AX"] != native_result.ax:
        raise AssertionError(f"{label}: close AX native={native_result.ax:04X}, ASM={oracle['AX']:04X}")
    if oracle["SI"] != native_result.si or oracle["DI"] != native_result.di:
        raise AssertionError(
            f"{label}: cursors native SI:DI={native_result.si:04X}:{native_result.di:04X}, "
            f"ASM={oracle['SI']:04X}:{oracle['DI']:04X}")
    if oracle["BP"] != native_result.bp:
        raise AssertionError(f"{label}: ring cursor native={native_result.bp:04X}, ASM BP={oracle['BP']:04X}")
    output_count = ((machine.peek("EncOutputBytesHigh") << 16) |
                    machine.peek("EncOutputBytes"))
    native_count = struct.unpack("<I", _native_symbol(base, machine,
                                                        "EncOutputBytes", 4))[0]
    if native_count != output_count:
        raise AssertionError(f"{label}: output count native={native_count}, ASM={output_count}")
    if oracle["DI"] != ((0x0123 + output_count) & 0xFFFF):
        raise AssertionError(f"{label}: ASM destination cursor does not match output count")
    start = (0x7000 << 4) + 0x0123
    native_output = ctypes.string_at(base + start, output_count)
    oracle_output = bytes(machine.u.mem_read(start, output_count))
    if native_output != oracle_output:
        for index, (got, want) in enumerate(zip(native_output, oracle_output)):
            if got != want:
                raise AssertionError(
                    f"{label}: byte {index} native={got:02X}, ASM={want:02X}")
    for symbol, size in (("ENCREADBUFFER", 0x400), ("ENCRINGBUFFER", 0x1000),
                         ("ENCOUTPUTBYTES", 4), ("ENCPUSHBACK", 1),
                         ("ENCPUSHEDBYTE", 1)):
        if _native_symbol(base, machine, symbol, size) != bytes(
                machine.u.mem_read(machine.linear(symbol), size)):
            raise AssertionError(f"{label}: native {symbol} differs from the ASM result")
    if h.lib.overkill_resource_close_result(native_handle) == 0:
        # The decoder closes on success; a second close must now report DOS invalid handle.
        raise AssertionError(f"{label}: native decoder left its archive handle open")
    if name == "PLAQ5.ENC":
        reads = [(asked, received) for handle, asked, received in machine.read_log
                 if handle == oracle_open["AX"] and asked == 0x400]
        if reads[-2:] != [(0x400, 0x400), (0x400, 212)]:
            raise AssertionError(f"{label}: expected 1 KiB initial/refill reads ending short, got {reads}")
        probe_open = h.lib.archive_open_by_name(DOS_PATH_AT)
        if probe_open >> 16:
            raise AssertionError(f"{label}: native short-read probe could not reopen its entry")
        probe_handle = probe_open & 0xFFFF
        probe_reads = []
        for expected in (0x400, 212):
            buffer = (ctypes.c_ubyte * 0x400)()
            transferred = h.lib.overkill_resource_read_buffer(probe_handle, 0x400, buffer)
            if transferred >> 16:
                raise AssertionError(f"{label}: native short-read probe failed: {transferred:08X}")
            probe_reads.append(transferred & 0xFFFF)
            if probe_reads[-1] != expected:
                raise AssertionError(
                    f"{label}: native 1 KiB read returned {probe_reads[-1]}, expected {expected}")
        if h.lib.overkill_resource_close_result(probe_handle) != 0:
            raise AssertionError(f"{label}: native short-read probe could not close its handle")
    _compare_resource_state(base, machine, label)
    return 1


def _test_ems_cache_reuse(h, resource_root: Path, name: str) -> int:
    machine = EmsFileMachine(ORACLE_EXE, resource_root)
    machine.call("SetupResourceArchive")
    machine.write(DOS_PATH_AT, name.encode("ascii") + b"\0")
    machine.poke("PackedNamePtr", DOS_PATH_AT)
    machine.poke("PackedDestSegment", 0x7000)
    machine.poke("PackedDestOffset", 0x0123)
    machine.poke("PackedReadCursor", machine.symbols["PACKEDREADBUFFER"][1] + 0x0200)
    machine.poke("PackedOutputBytes", 0)
    oracle_load = machine.call("LoadPackedFile")
    if oracle_load["FLAGS"] & FLAG["CF"]:
        raise AssertionError(f"ASM could not decode {name} before EMS cache test")
    byte_count = machine.peek("PackedOutputBytes")
    if byte_count == 0 or byte_count > 0xFFFF:
        raise AssertionError(f"EMS cache fixture has unsupported decoded count {byte_count}")

    machine.poke("FileNamePtr", DOS_PATH_AT)
    machine.poke("FileBufferSegment", 0x7000)
    machine.poke("FileBufferOffset", 0x0123)
    machine.poke("FileByteCount", byte_count)
    machine.poke("FileCacheEnd", machine.offset("FileCache"))
    machine.poke("VideoAdapter", 1)
    machine.poke("EmsPageFrame", 0x9000)
    machine.write(machine.offset("EmsAvailable"), b"\x01")
    machine.write(machine.offset("FileCache"), b"\xff\xff" + b"\0" * 8)
    _raw, _arena, base = _bind_native_oracle_image(h, machine)

    oracle_cache = machine.call("CacheLoadedFile", {"ES": 0xBEEF})
    native_cache = h.lib.cache_loaded_file(0xBEEF)
    if oracle_cache["ES"] != native_cache:
        raise AssertionError(
            f"EMS cache {name}: returned segment native={native_cache:04X}, "
            f"ASM ES={oracle_cache['ES']:04X}")
    cache_entry_bytes = bytes(machine.u.mem_read(machine.linear("FileCache"), 10))
    native_entry_bytes = _native_symbol(base, machine, "FileCache", 10)
    if native_entry_bytes != cache_entry_bytes:
        raise AssertionError(f"EMS cache {name}: cache entry differs")
    frame_segment = machine.peek("EmsPageFrame")
    page_count = struct.unpack_from("<H", cache_entry_bytes, 8)[0]
    frame_address = frame_segment << 4
    frame_bytes = page_count * 0x4000
    native_frame = ctypes.string_at(base + frame_address, frame_bytes)
    oracle_frame = bytes(machine.u.mem_read(frame_address, frame_bytes))
    if native_frame != oracle_frame:
        mismatch = next(i for i, (got, want) in enumerate(zip(native_frame, oracle_frame))
                        if got != want)
        raise AssertionError(f"EMS cache {name}: mapped page frame differs at {mismatch}")
    source_address = (0x7000 << 4) + 0x0123
    if oracle_frame[:byte_count] != bytes(machine.u.mem_read(source_address, byte_count)):
        mismatch = next(i for i, (got, want) in enumerate(zip(
            oracle_frame[:byte_count], machine.u.mem_read(source_address, byte_count)))
                        if got != want)
        raise AssertionError(
            f"EMS cache {name}: ASM initial frame copy differs at {mismatch} "
            f"(pages={page_count}, count={byte_count})")

    # Move the destination and hit the EMS-backed entry a second time. This verifies
    # both page remapping and the cache's copy semantics using the actual decoded asset.
    second_segment, second_offset = 0x8000, 0x0321
    machine.poke("FileBufferSegment", second_segment)
    machine.poke("FileBufferOffset", second_offset)
    ctypes.memmove(base + machine.linear("FileBufferSegment"),
                   struct.pack("<HH", second_segment, second_offset), 4)
    destination = (second_segment << 4) + second_offset
    marker = b"\xA5" * byte_count
    machine.u.mem_write(destination, marker)
    ctypes.memmove(base + destination, marker, len(marker))
    oracle_hit = machine.call("CopyFromFileCache", {"AX": 0})
    native_hit = h.lib.copy_from_file_cache()
    if (oracle_hit["AX"] & 0xFF) != (native_hit & 0xFF):
        raise AssertionError(
            f"EMS cache {name}: hit result native={native_hit:04X}, ASM AX={oracle_hit['AX']:04X}")
    native_output = ctypes.string_at(base + destination, byte_count)
    oracle_output = bytes(machine.u.mem_read(destination, byte_count))
    decoded = bytes(machine.u.mem_read((0x7000 << 4) + 0x0123, byte_count))
    if oracle_output != decoded:
        mismatch = next(i for i, (got, want) in enumerate(zip(oracle_output, decoded))
                        if got != want)
        raise AssertionError(
            f"EMS cache {name}: ASM remap differs from decoded bytes at {mismatch}: "
            f"{oracle_output[mismatch]:02X}!={decoded[mismatch]:02X}")
    if native_output != oracle_output:
        mismatch = next(i for i, (got, want) in enumerate(zip(native_output, oracle_output))
                        if got != want)
        raise AssertionError(
            f"EMS cache {name}: native remap differs from ASM at {mismatch}: "
            f"{native_output[mismatch]:02X}!={oracle_output[mismatch]:02X}")
    _compare_resource_state(base, machine, f"EMS cache {name}")

    machine.call("ReleaseEmsCache")
    h.lib.release_ems_cache()
    if machine.ems_pages:
        raise AssertionError(f"ASM did not release the EMS handle for {name}")
    _compare_resource_state(base, machine, f"EMS cache release {name}")
    return 1


def run(no_build: bool = False) -> int:
    if no_build:
        if not (HOST_DIR / ("OVERKILL_CORE.dll" if sys.platform == "win32" else
                            "liboverkill_core.so")).is_file():
            raise FileNotFoundError("--no-build requires the current native host core")
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    count = 0
    with tempfile.TemporaryDirectory(prefix="overkill-files-") as temporary:
        root = Path(temporary)
        save_root = root / "native-saves"
        save_root.mkdir()
        import input as harness_module  # pylint: disable=import-outside-toplevel
        original_machine = harness_module.Machine
        harness_module.Machine = lambda exe: FileMachine(exe, root)
        try:
            h = harness_module.HostHarness()
        finally:
            harness_module.Machine = original_machine
        _bind_native_file_api(h)
        host_image = (HOST_DIR / "HOST_IMAGE.BIN").read_bytes()
        if len(host_image) != 0x100000:
            raise AssertionError("generated native real-mode arena is not exactly 1 MiB")
        real_memory = (ctypes.c_ubyte * len(host_image)).from_buffer_copy(host_image)
        if not h.lib.overkill_bind_real_memory(real_memory, len(host_image)):
            raise AssertionError("native memory adapter rejected the generated real-mode arena")
        token_load = h.m.symbols["LOADFILETOBUFFER"][1]
        token_save = h.m.symbols["SAVEBUFFERTOFILE"][1]
        drive = str(root).encode("utf-8")
        if not h.lib.overkill_resource_mount_drive(b"C", drive):
            raise AssertionError("native resource layer rejected the temporary C: root")
        if not h.lib.overkill_resource_set_current_drive(b"C"):
            raise AssertionError("native resource layer rejected current drive C:")
        try:
            if not h.lib.overkill_file_services_set_save_root(None):
                raise AssertionError("native file service could not clear its save-root override")
            count += _test_load(h, root / "LOAD.BIN")
            count += _test_open_failure(h)
            count += _test_save(h, root / "SAVE.BIN")
            count += _test_create_failure(h)
            if not h.lib.overkill_file_services_set_save_root(str(save_root).encode("utf-8")):
                raise AssertionError("native file service rejected the temporary save root")
            count += _test_save_root_override(h, root, save_root)

            # Exercise the production archive and decoder path against the same shipped
            # container. The lowercase alias matches ResourceArchiveList on case-sensitive
            # hosts while retaining the exact asset bytes.
            resource_root = root / "resources"
            resource_root.mkdir()
            shutil.copyfile(HOST_DIR / "assets" / "OVERKILL", resource_root / "overkill")
            if not h.lib.overkill_resource_mount_drive(b"C", str(resource_root).encode("utf-8")):
                raise AssertionError("native resource layer rejected the shipped archive root")
            count += _test_archive_lookup(h, resource_root, "BLUEBITS.BIC", found=True)
            count += _test_archive_lookup(h, resource_root, "MISSING.BIC", found=False)
            count += _test_packed_resource(h, resource_root, "LOGO.BIC")
            count += _test_packed_resource(h, resource_root, "BLUEBITS.BIC")
            count += _test_packed_resource(h, resource_root, "1X1.BIC")
            count += _test_enc_resource(h, resource_root, "PLAQ5.ENC")
            count += _test_ems_cache_reuse(h, resource_root, "BLUEBITS.BIC")
        finally:
            h.lib.overkill_file_services_set_save_root(None)
            h.m.close_all()
            h.lib.overkill_resource_mount_drive(b"C", None)

    print(f"PASS host file services: {count} oracle-vs-native scenarios "
          f"(LOADFILETOBUFFER={token_load:04X}, SAVEBUFFERTOFILE={token_save:04X})")
    return count


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="reuse build/host and build/oracle-sym artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
