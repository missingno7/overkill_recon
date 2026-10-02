"""Native DOS plain-file mailbox checks against the exact ASM oracle.

Run ``python tests/host/file_services.py --no-build`` to reuse the current host
core and source-built oracle. File side effects are confined to a temporary C:
drive root mounted by both the DOS interrupt fixture and the native resource API.
"""
from __future__ import annotations

import argparse
import ctypes
from pathlib import Path
import struct
import sys
import tempfile

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
    """Add only the four DOS 21h file functions used by these frozen leaf routines."""

    def __init__(self, exe: Path, drive_root: Path) -> None:
        super().__init__(exe)
        self.drive_root = Path(drive_root)
        self.files = {}

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

        return super()._interrupt(u, number, _)


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
