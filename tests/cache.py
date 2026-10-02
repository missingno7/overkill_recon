"""Executable-bounded cache/resource differential tests .

The oracle and hybrid run under tools/emu.py. Only DOS, EMS, and archive-open
boundaries are stubbed; the game's cache control and both file decoders execute.
"""
import struct

from difftest import Case, far
import difftest
from emu import FLAG, LOAD, REG
from unicorn import UC_HOOK_CODE

MAP_SEGMENT = 0x9000
MAP_OFFSET = 0x4000
DEST_OFFSET = 0x0200
SOURCE_OFFSET = 0x0100
CODE_WORDS = ('PackedOutputBytes', 'EncOutputBytes', 'EncOutputBytesHigh')
difftest.FAR_LABELS += tuple(name for name in CODE_WORDS if name not in difftest.FAR_LABELS)


def word(value):
    return struct.pack("<H", value & 0xFFFF)


def entry(name, segment, count, handle=0, pages=0):
    return struct.pack("<HHHHH", name, segment, count, handle, pages)


def state_write(side, name, data):
    return (side.m.offset(name), bytes(data))


def state_word(side, name, value):
    return state_write(side, name, word(value))


def return_far(side, u):
    sp = u.reg_read(REG["SP"])
    ss = u.reg_read(REG["SS"])
    ip, cs = struct.unpack("<HH", bytes(u.mem_read(ss * 16 + sp, 4)))
    u.reg_write(REG["IP"], ip)
    u.reg_write(REG["CS"], cs)
    u.reg_write(REG["SP"], (sp + 4) & 0xFFFF)


def return_near(side, u):
    sp = u.reg_read(REG["SP"])
    ss = u.reg_read(REG["SS"])
    ip = struct.unpack("<H", bytes(u.mem_read(ss * 16 + sp, 2)))[0]
    u.reg_write(REG["IP"], ip)
    u.reg_write(REG["SP"], (sp + 2) & 0xFFFF)


def set_cf(u, enabled):
    flags = u.reg_read(REG["FLAGS"])
    flags = flags | FLAG["CF"] if enabled else flags & ~FLAG["CF"]
    u.reg_write(REG["FLAGS"], flags)


class DeviceMocks:
    def __init__(self, pair, *, opens=(), read_data=b"", drive=0, bios=(), video=2,
                 dos_segment=0x9100, dos_status=0, ems_handle=0x0077, ems_status=0,
                 read_error_at=(), cut_shutdown=False):
        self.pair = pair
        self.opens = tuple(opens)
        self.read_data = bytes(read_data)
        self.read_error_at = frozenset(read_error_at)
        self.drive = drive
        self.bios = tuple(bios)
        self.dos_segment = dos_segment
        self.dos_status = dos_status
        self.ems_handle = ems_handle
        self.ems_status = ems_status
        self.rows = []
        self.handles = []
        for side in (pair.a, pair.b):
            side.m.poke("VideoAdapter", video)
            row = dict(open_index=0, bios_index=0, read_index=0, opens=[], open_names=[],
                       bios=[], dos=[], ems=[], shutdown=0)
            self.rows.append(row)
            native_open = "ARCHIVE_OPEN_BY_NAME" in side.m.symbols
            open_at = side.m.linear("archive_open_by_name" if native_open else "OpenResourceFile")
            shutdown_at = side.m.linear("ShutdownWithError") if cut_shutdown else -1
            def intercept(u, address, size, _data, side=side, row=row, open_at=open_at,
                          shutdown_at=shutdown_at, native_open=native_open):
                if address == open_at:
                    i = row["open_index"]
                    row["open_index"] += 1
                    ds = u.reg_read(REG["DS"])
                    dx = u.reg_read(REG["SI"] if native_open else REG["DX"])
                    name = bytearray()
                    for offset in range(128):
                        char = bytes(u.mem_read(ds * 16 + ((dx + offset) & 0xFFFF), 1))[0]
                        if char == 0:
                            break
                        name.append(char)
                    row["open_names"].append(bytes(name))
                    succeeds = self.opens[i] if i < len(self.opens) else True
                    row["opens"].append(succeeds)
                    u.reg_write(REG["AX"], 0x1234 if succeeds else 2)
                    if native_open:
                        u.reg_write(REG["DX"], 0 if succeeds else 1)
                        return_near(side, u)
                    else:
                        u.reg_write(REG["BX"], 0x1234)
                        set_cf(u, not succeeds)
                        return_far(side, u)
                    return

                opcode = bytes(u.mem_read(address, 2))
                if opcode == b"\xCD\x21":
                    ax = u.reg_read(REG["AX"]); function = ax >> 8
                    if function == 0x19:
                        file_handle = side.m.word(side.m.offset("FileHandle"))
                        row["dos"].append(("drive", self.drive, file_handle))
                        u.reg_write(REG["AX"], (ax & 0xFF00) | self.drive)
                        set_cf(u, False)
                    elif function == 0x3E:
                        row["dos"].append(("close", u.reg_read(REG["BX"])))
                        u.reg_write(REG["AX"], 0)
                        set_cf(u, False)
                    elif function == 0x3F:
                        read_index = row["read_index"]
                        row["read_index"] += 1
                        count = u.reg_read(REG["CX"])
                        if read_index in self.read_error_at:
                            row["dos"].append(("read-error", count))
                            u.reg_write(REG["AX"], 5)
                            set_cf(u, True)
                        else:
                            ds, dx = u.reg_read(REG["DS"]), u.reg_read(REG["DX"])
                            payload = self.read_data[:count]
                            row["dos"].append(("read", count, len(payload)))
                            if payload:
                                u.mem_write(ds * 16 + dx, payload)
                            u.reg_write(REG["AX"], len(payload))
                            set_cf(u, False)
                    elif function == 0x48:
                        paragraphs = u.reg_read(REG["BX"])
                        row["dos"].append(("allocate", paragraphs))
                        if self.dos_status:
                            u.reg_write(REG["AX"], self.dos_status)
                            u.reg_write(REG["BX"], 0x100)
                            set_cf(u, True)
                        else:
                            u.reg_write(REG["AX"], self.dos_segment)
                            set_cf(u, False)
                    else:
                        raise AssertionError(f"unexpected INT 21h function {function:02X}")
                    u.reg_write(REG["IP"], (u.reg_read(REG["IP"]) + 2) & 0xFFFF)
                    return
                if opcode == b"\xCD\x67":
                    ax = u.reg_read(REG["AX"]); function = ax >> 8
                    if function == 0x43:
                        pages = u.reg_read(REG["BX"])
                        row["ems"].append(("allocate", pages))
                        u.reg_write(REG["AX"], (ax & 0xFF) | ((self.ems_status & 0xFF) << 8))
                        u.reg_write(REG["DX"], self.ems_handle)
                    elif function == 0x44:
                        row["ems"].append(("map", u.reg_read(REG["BX"]), u.reg_read(REG["DX"])))
                        u.reg_write(REG["AX"], ax & 0xFF)
                    elif function == 0x45:
                        row["ems"].append(("free", u.reg_read(REG["DX"])))
                        u.reg_write(REG["AX"], ax & 0xFF)
                    else:
                        raise AssertionError(f"unexpected INT 67h function {function:02X}")
                    u.reg_write(REG["IP"], (u.reg_read(REG["IP"]) + 2) & 0xFFFF)
                    return
                if opcode == b"\xCD\x13":
                    i = row["bios_index"]
                    row["bios_index"] += 1
                    failed = self.bios[i] if i < len(self.bios) else False
                    row["bios"].append(failed)
                    ax = u.reg_read(REG["AX"])
                    u.reg_write(REG["AX"], (ax & 0x00FF) | (0x8000 if failed else 0))
                    set_cf(u, failed)
                    u.reg_write(REG["IP"], (u.reg_read(REG["IP"]) + 2) & 0xFFFF)

                if address == shutdown_at:
                    row["shutdown"] += 1
                    return_near(side, u)

            self.handles.append(side.m.u.hook_add(
                UC_HOOK_CODE, intercept, None, side.image[0], side.image[1]))
            side.m.u.ctl_remove_cache(side.image[0], side.image[1])

    def close(self):
        for side, handle in zip((self.pair.a, self.pair.b), self.handles):
            side.m.u.hook_del(handle)
            side.m.u.ctl_remove_cache(side.image[0], side.image[1])

    def same_trace(self):
        assert self.rows[0] == self.rows[1], f"DOS/EMS/open traces differ: {self.rows}"


def cache_copy_case(pair, *, ems=False, name="conventional cache hit"):
    source = b"cache"
    cache_entry = entry(0x1234, 0xFFFF if ems else MAP_SEGMENT, len(source), 0x77, 1)
    writes = [state_write(pair.a, "FileCache", cache_entry + word(0xFFFF)),
              state_word(pair.a, "FileNamePtr", 0x1234),
              state_word(pair.a, "FileBufferSegment", MAP_SEGMENT),
              state_word(pair.a, "FileBufferOffset", DEST_OFFSET)]
    if ems:
        writes += [state_word(pair.a, "EmsPageFrame", MAP_SEGMENT),
                   (far("SlotBuffer", 0), source)]
    else:
        writes += [(far("SlotBuffer", 0), source),
                   state_word(pair.a, "FileCacheEnd", pair.a.m.offset("FileCache"))]
        cache_entry = entry(0x1234, MAP_SEGMENT, len(source), 0, 0)
        writes[0] = state_write(pair.a, "FileCache", cache_entry + word(0xFFFF))

    def done(m, regs):
        assert bytes(m.u.mem_read(MAP_SEGMENT * 16 + DEST_OFFSET, len(source))) == source

    return Case("CopyFromFileCache", {"AX": 0x4444, "BP": 0xABCD, "ES": 0xB800},
                writes, ("BP", "SP", "DS", "SS"), outputs=("AX", "ES"), flags=("ZF",),
                expect=done, name=name)


def cache_miss_case(pair, *, empty=False):
    filename = 0x1234
    marker = b"keep"
    table = word(0xFFFF) if empty else entry(0x5678, MAP_SEGMENT, 5) + word(0xFFFF)
    writes = [state_write(pair.a, "FileCache", table),
              state_word(pair.a, "FileNamePtr", filename),
              state_word(pair.a, "FileBufferSegment", MAP_SEGMENT),
              state_word(pair.a, "FileBufferOffset", DEST_OFFSET),
              (far("SlotBuffer", DEST_OFFSET), marker)]

    def done(m, regs):
        assert regs["AX"] == 0x1235
        assert bytes(m.u.mem_read(MAP_SEGMENT * 16 + DEST_OFFSET, len(marker))) == marker

    return Case("CopyFromFileCache", {"AX": 0x4444, "BP": 0xABCD, "ES": 0xB800},
                writes, ("BP", "SP", "DS", "SS"), outputs=("AX", "ES"), flags=("ZF",),
                expect=done, name="miss in empty cache" if empty else "miss after one entry")


def cache_allocate_case(pair, *, ems=False, count=7, name="DOS cache allocation",
                        ems_status=0, dos_status=0, ems_frame=0x9800,
                        source_offset=SOURCE_OFFSET, source_in_state=False):
    fixture = bytes((i * 29 + 7) & 255 for i in range(count))
    source_segment = pair.a.m.data_frame if source_in_state else MAP_SEGMENT
    source_write = (0, fixture) if source_in_state else (far("SlotBuffer", source_offset), fixture)
    writes = [state_word(pair.a, "FileNamePtr", 0x1234),
              state_word(pair.a, "FileBufferSegment", source_segment),
              state_word(pair.a, "FileBufferOffset", 0 if source_in_state else source_offset),
              state_word(pair.a, "FileByteCount", count),
              state_word(pair.a, "FileCacheEnd", pair.a.m.offset("FileCache")),
              state_write(pair.a, "EmsAvailable", bytes((1 if ems else 0,))),
              state_word(pair.a, "EmsPageFrame", ems_frame),
              source_write]

    def done(m, regs):
        ems_succeeded = ems and ems_status == 0
        dos_failed = dos_status != 0 and (not ems or ems_status != 0)
        if dos_failed:
            assert regs["ES"] == "unchanged"
            assert m.word(m.offset("FileCacheEnd")) == m.offset("FileCache")
            return
        assert regs["ES"] == (ems_frame if ems_succeeded else 0x9100)
        assert m.word(m.offset("FileCacheEnd")) == (m.offset("FileCache") + 10)
        fields = struct.unpack("<HHHHH", m.read(m.offset("FileCache"), 10))
        if ems_succeeded:
            assert fields == (0x1234, 0xFFFF, count, 0x77, max(1, (count + 0x3FFF) // 0x4000))
            target = ems_frame * 16
        else:
            assert fields == (0x1234, 0x9100, count, count, count)
            target = 0x9100 * 16
        expected = m.read(0, count) if source_in_state else fixture
        assert bytes(m.u.mem_read(target, count)) == expected

    return Case("CacheLoadedFile", {"ES": 0xB800, "BP": 0x3210}, writes,
                ("BP", "SP", "DS", "SS"), outputs=("ES",), expect=done, name=name)


def cache_bypass_case(pair, *, tandy=False, resident=False):
    name = "Tandy cache bypass" if tandy else "resident cache bypass"
    writes = [state_word(pair.a, "FileNamePtr", 0x1234),
              state_word(pair.a, "FileByteCount", 7),
              state_word(pair.a, "FileCacheEnd", pair.a.m.offset("FileCache")),
              state_write(pair.a, "EmsAvailable", b"\1"),
              state_write(pair.a, "FileCache", word(0xFFFF))]
    if resident:
        writes.append(state_write(pair.a, "ResidentFiles", word(0x1234) + word(0xFFFF)))

    def done(m, regs):
        assert regs["ES"] == "unchanged"
        assert m.word(m.offset("FileCacheEnd")) == m.offset("FileCache")

    return Case("CacheLoadedFile", {"ES": 0xB800}, writes,
                ("BP", "SP", "DS", "SS"), outputs=("ES",), expect=done, name=name)


def release_case(pair, *, available=True):
    writes = [state_write(pair.a, "FileCache",
                          entry(0x1000, 0x9000, 5) + entry(0x2000, 0xFFFF, 10, 0x77, 1)
                          + word(0xFFFF)),
              state_write(pair.a, "EmsAvailable", bytes((1 if available else 0,)))]
    return Case("ReleaseEmsCache", {"BP": 0x7788, "ES": 0xB800}, writes,
                ("BP", "SP", "DS", "SS", "ES"), name="only EMS entries are freed")


def loader_case(pair, *, packed=True, drive_letter="C:", bios=(), drive_a=0, drive_b=0,
                expected_name=None, case_name=None):
    filename = pair.a.m.offset("UnusedTextBuffer")
    raw_name = (drive_letter.encode("ascii") + b"cache.bic\0")
    writes = [state_write(pair.a, "UnusedTextBuffer", raw_name),
              state_word(pair.a, "FileNamePtr", filename),
              state_word(pair.a, "FileBufferSegment", MAP_SEGMENT),
              state_word(pair.a, "FileBufferOffset", DEST_OFFSET),
              state_word(pair.a, "FileByteCount", 0x7777),
              state_word(pair.a, "FileStatus", 0xFFFF),
              state_word(pair.a, "LoadWordBB82", 0xAAAA),
              state_write(pair.a, "LoadIsEnc", bytes((0 if packed else 1,))),
              state_write(pair.a, "FileHandle", word(0x5555)),
              state_write(pair.a, "FileCache", word(0xFFFF)),
              state_write(pair.a, "DriveAPresent", bytes((drive_a,))),
              state_write(pair.a, "DriveBPresent", bytes((drive_b,))),
              state_word(pair.a, "FileCacheEnd", pair.a.m.offset("FileCache"))]
    if packed:
        stream = bytes((3, 3)) + b"ABCD" + bytes((0x80,))
        expected = b"ABCD"
        opens = (False, True, True)
        name = "resource retry then real packed decoder"
    else:
        stream = bytes((0x07,)) + b"ABC" + bytes((0, 0, 0))
        expected = b"ABC"
        opens = (True,)
        name = "real ENC decoder dispatch"
    if case_name is not None:
        name = case_name

    def done(m, regs):
        assert m.word(m.offset("FileStatus")) == 0
        assert m.word(m.offset("FileByteCount")) == len(expected)
        assert m.word(m.offset("LoadWordBB82")) == 0
        assert bytes(m.u.mem_read(MAP_SEGMENT * 16 + DEST_OFFSET, len(expected))) == expected
        expected_es = MAP_SEGMENT if packed else "unchanged"
        assert regs["ES"] == expected_es, f"{name}: returned ES={regs['ES']!r}"

    return Case("LoadResourceFile", {"BP": 0xA456, "ES": 0xB800}, writes,
                ("BP", "SP", "DS", "SS"), outputs=("ES",), expect=done, name=name), opens, stream, bios, \
           expected_name if expected_name is not None else raw_name[:-1]


def loader_fixture(pair, **kwargs):
    case, opens, stream, bios, opened_name = loader_case(pair, **kwargs)
    config = dict(loader=opens, read=stream, bios=bios,
                  packed=kwargs.get("packed", True),
                  open_names=[opened_name] * len(opens))
    config["expect_read"] = True
    config["bios_expected"] = list(bios) if bios else \
        ([False] if opened_name[:1].upper() in (b"A", b"B") else [])
    if opens and not opens[0]:
        config["drive_handles"] = [2]
    if bios:
        config["drive_handles"] = [0x5555]
    return case, config


def loader_cache_hit_case(pair):
    filename = pair.a.m.offset("UnusedTextBuffer")
    payload = b"cached"
    writes = [state_write(pair.a, "UnusedTextBuffer", b"C:cache.bic\0"),
              state_word(pair.a, "FileNamePtr", filename),
              state_word(pair.a, "FileBufferSegment", MAP_SEGMENT),
              state_word(pair.a, "FileBufferOffset", DEST_OFFSET),
              state_word(pair.a, "FileByteCount", 0x7777),
              state_word(pair.a, "FileStatus", 0xFFFF),
              state_word(pair.a, "LoadWordBB82", 0xAAAA),
              state_write(pair.a, "FileCache", entry(filename, MAP_SEGMENT, len(payload)) + word(0xFFFF)),
              (far("SlotBuffer", 0), payload)]

    def done(m, regs):
        assert m.word(m.offset("FileStatus")) == 0
        assert m.word(m.offset("FileByteCount")) == 0x7777
        assert m.word(m.offset("LoadWordBB82")) == 0xAAAA
        assert bytes(m.u.mem_read(MAP_SEGMENT * 16 + DEST_OFFSET, len(payload))) == payload
        assert regs["ES"] == MAP_SEGMENT

    case = Case("LoadResourceFile", {"BP": 0xA456, "ES": 0xB800}, writes,
                ("BP", "SP", "DS", "SS"), outputs=("ES",), expect=done,
                name="resource cache hit returns before retry setup")
    return case, dict(loader=(), open_names=[], no_ems=True, no_dos_alloc=True)


def loader_controller_failure_case(pair, *, packed, stage):
    """Exercise result fields consumed by LoadResourceFile, including failure quirks."""
    filename = pair.a.m.offset("UnusedTextBuffer")
    raw_name = b"C:cache.bic"
    writes = [state_write(pair.a, "UnusedTextBuffer", raw_name + b"\0"),
              state_word(pair.a, "FileNamePtr", filename),
              state_word(pair.a, "FileBufferSegment", MAP_SEGMENT),
              state_word(pair.a, "FileBufferOffset", DEST_OFFSET),
              state_word(pair.a, "FileByteCount", 0x7777),
              state_word(pair.a, "FileStatus", 0xFFFF),
              state_word(pair.a, "LoadWordBB82", 0xAAAA),
              state_write(pair.a, "LoadIsEnc", bytes((0 if packed else 1,))),
              state_write(pair.a, "FileHandle", word(0x5555)),
              state_write(pair.a, "FileCache", word(0xFFFF)),
              state_word(pair.a, "FileCacheEnd", pair.a.m.offset("FileCache"))]

    if packed and stage == "open":
        # The outer open succeeds and is closed; the packed controller's second open fails.
        opens, stream, read_errors = (True, False), b"", ()
        expected_count, expected_es = 0, "unchanged"
        expected_dos = [("close", 0x1234)]
        name = "packed controller open failure retains ES and resets count"
        writes.append((far("PackedOutputBytes"), word(0x4567)))
    elif packed and stage == "decode":
        # One 512-byte read yields 255 two-byte repeat runs and a final run control;
        # the value refill fails after 510 bytes have already been written.
        stream = bytes((3,)) + bytes((0xFF, ord("A"))) * 255 + bytes((0xFF,))
        assert len(stream) == 0x200
        opens, read_errors = (True, True), (1,)
        expected_count, expected_es = 510, MAP_SEGMENT
        expected_dos = [("close", 0x1234), ("read", 0x200, 0x200),
                        ("read-error", 0x200), ("close", 0x1234)]
        name = "packed decode failure reports destination and partial output"
        writes.append((far("PackedOutputBytes"), word(0x4567)))
    elif not packed and stage == "initial-read":
        opens, stream, read_errors = (True,), b"", (0,)
        expected_count, expected_es = 0x3456, "unchanged"
        expected_dos = [("read-error", 0x400)]
        name = "ENC first-read failure keeps stale byte count and leaves handle open"
        writes += [(far("EncOutputBytes"), word(0x3456)),
                   (far("EncOutputBytesHigh"), word(0x789A))]
    else:
        raise ValueError(f"unsupported loader controller case: {packed=} {stage=}")

    def done(m, regs):
        assert m.word(m.offset("FileStatus")) == 0
        assert m.word(m.offset("FileByteCount")) == expected_count
        assert m.word(m.offset("LoadWordBB82")) == 0
        assert regs["ES"] == expected_es
        if packed and stage == "decode":
            assert bytes(m.u.mem_read(MAP_SEGMENT * 16 + DEST_OFFSET, expected_count)) == b"A" * expected_count

    case = Case("LoadResourceFile", {"BP": 0xA456, "ES": 0xB800}, writes,
                ("BP", "SP", "DS", "SS"), outputs=("ES",), expect=done, name=name)
    config = dict(loader=opens, read=stream, read_error_at=read_errors,
                  packed=packed, open_names=[raw_name] * len(opens), video=2,
                  expect_read=stage != "open", dos_expected=expected_dos)
    return case, config


def loader_abort_case(pair, *, escape=False):
    filename = pair.a.m.offset("UnusedTextBuffer")
    name = b"C:cache.bic"
    writes = [state_write(pair.a, "UnusedTextBuffer", name + b"\0"),
              state_word(pair.a, "FileNamePtr", filename),
              state_word(pair.a, "FileBufferSegment", MAP_SEGMENT),
              state_word(pair.a, "FileBufferOffset", DEST_OFFSET),
              state_word(pair.a, "FileByteCount", 0x7777),
              state_word(pair.a, "FileStatus", 0xFFFF),
              state_word(pair.a, "LoadWordBB82", 0xAAAA),
              state_write(pair.a, "FileHandle", word(0x5555)),
              state_write(pair.a, "FileCache", word(0xFFFF)),
              (pair.a.m.offset("KeyDownTable") + 1, b"\1" if escape else b"\0")]

    def done(m, regs):
        assert m.word(m.offset("FileStatus")) == 0
        assert m.word(m.offset("FileHandle")) == 2
        assert m.word(m.offset("FileByteCount")) == 0x7777
        assert m.word(m.offset("LoadWordBB82")) == 0
        assert regs["ES"] == "unchanged"

    case = Case("LoadResourceFile", {"BP": 0xA456, "ES": 0xB800}, writes,
                ("BP", "SP", "DS", "SS"), outputs=("ES",), expect=done,
                name="open failure takes ESC shutdown" if escape else "current-drive shutdown")
    config = dict(loader=(False,), read=b"", expect_read=False, drive=0 if escape else 2,
                  open_names=[name], cut_shutdown=True, shutdown=1)
    if not escape:
        config["drive_handles"] = [2]
    return case, config


def _fixtures(pair):
    return [
        (cache_copy_case(pair), None),
        (cache_copy_case(pair, ems=True, name="EMS cache hit maps then copies"),
         dict(ems=True)),
        (cache_miss_case(pair), None),
        (cache_miss_case(pair, empty=True), None),
        (cache_allocate_case(pair), dict(dos=True, video=1)),
        (cache_allocate_case(pair, ems=True, count=0x4000, name="exact EMS page allocation"),
         dict(ems=True, no_dos_alloc=True, video=1)),
        (cache_allocate_case(pair, ems=True, count=0, name="zero-byte EMS allocation"),
         dict(ems=True, no_dos_alloc=True, video=1)),
        (cache_allocate_case(pair, ems=True, count=0x4001, name="two-page EMS allocation"),
         dict(ems=True, no_dos_alloc=True, video=1)),
        (cache_allocate_case(pair, ems=True, count=0xFFFF, name="four-page EMS allocation",
                             source_offset=0, ems_frame=MAP_SEGMENT),
         dict(ems=True, no_dos_alloc=True, video=1)),
        (cache_allocate_case(pair, ems=True, ems_status=0x80,
                             name="EMS failure falls back to DOS"),
         dict(ems=True, dos=True, ems_status=0x80, video=1)),
        (cache_allocate_case(pair, ems=True, ems_status=0x80, dos_status=8,
                             name="EMS and DOS allocation failure"),
         dict(ems=True, dos=True, ems_status=0x80, dos_status=8, video=1)),
        (cache_bypass_case(pair, tandy=True), dict(video=2, no_ems=True, no_dos_alloc=True)),
        (cache_bypass_case(pair, resident=True), dict(video=1, no_ems=True, no_dos_alloc=True)),
        (release_case(pair), dict(ems=True)),
        (release_case(pair, available=False), dict(no_ems=True)),
        loader_cache_hit_case(pair),
        loader_fixture(pair, packed=True),
        loader_fixture(pair, packed=False),
        loader_fixture(pair, packed=False, drive_letter="", bios=(False,),
                       case_name="unprefixed resource name keeps current drive"),
        loader_fixture(pair, packed=False, drive_letter="A:", bios=(True, False), drive_a=1,
                       expected_name=b"A:cache.bic"),
        loader_fixture(pair, packed=False, drive_letter="A:", drive_a=2, drive_b=1,
                       expected_name=b"B:cache.bic"),
        loader_fixture(pair, packed=False, drive_letter="a:", drive_b=1,
                       expected_name=b"b:cache.bic"),
        loader_fixture(pair, packed=False, drive_letter="A:", drive_a=0, drive_b=2,
                       expected_name=b"C:cache.bic"),
        loader_controller_failure_case(pair, packed=True, stage="open"),
        loader_controller_failure_case(pair, packed=True, stage="decode"),
        loader_controller_failure_case(pair, packed=False, stage="initial-read"),
        loader_abort_case(pair, escape=True),
        loader_abort_case(pair, escape=False),
    ]


def cases(rng, scale, pair):
    """Normal difftest suite: keep outside bytes through Case.expect, then roll back."""
    for case, config in _fixtures(pair):
        config = config or {}
        mocks = DeviceMocks(pair, opens=config.get("loader", ()),
                            read_data=config.get("read", b""), drive=config.get("drive", 0),
                            bios=config.get("bios", ()), video=config.get("video", 2),
                            dos_status=config.get("dos_status", 0),
                            ems_status=config.get("ems_status", 0),
                            read_error_at=config.get("read_error_at", ()),
                            cut_shutdown=config.get("cut_shutdown", False))
        saved_runs = []
        if config.get("packed"):
            for side in (pair.a, pair.b):
                original_run = side.run
                saved_runs.append((side, original_run))
                buffer_offset = side.m.symbols["PACKEDREADBUFFER"][1]
                def keep_and_normalize(*args, side=side, original_run=original_run,
                                       buffer_offset=buffer_offset, **kwargs):
                    call_args = list(args)
                    if len(call_args) >= 4:
                        call_args[3] = True
                    else:
                        kwargs["keep"] = True
                    result = original_run(*call_args, **kwargs)
                    normalized = []
                    for symbol, size, value in side.outside:
                        if symbol == "PACKEDUNWINDSP+0":
                            # Native cache calls do not need the legacy nonlocal-unwind SP.
                            continue
                        elif symbol == "PACKEDREADCURSOR+0":
                            value = (value - buffer_offset) & 0xFFFF
                        normalized.append((symbol, size, value))
                    side.outside = normalized
                    return result
                side.run = keep_and_normalize
        else:
            for side in (pair.a, pair.b):
                original_run = side.run
                saved_runs.append((side, original_run))
                def keep_outside(*args, original_run=original_run, **kwargs):
                    call_args = list(args)
                    if len(call_args) >= 4:
                        call_args[3] = True
                    else:
                        kwargs["keep"] = True
                    return original_run(*call_args, **kwargs)
                side.run = keep_outside
        try:
            yield case
            mocks.same_trace()
            for row in mocks.rows:
                if "loader" in config:
                    assert row["opens"] == list(config["loader"]), \
                        f"{case.name}: open retry trace {row['opens']}"
                if "open_names" in config:
                    assert row["open_names"] == config["open_names"], \
                        f"{case.name}: opened names {row['open_names']}"
                if "bios_expected" in config:
                    assert row["bios"] == config["bios_expected"], \
                        f"{case.name}: BIOS probe trace {row['bios']}"
                if config.get("expect_read"):
                    assert any(op[0] in ("read", "read-error") for op in row["dos"]), \
                        f"{case.name}: decoder did not read"
                if config.get("expect_read") is False:
                    assert not any(op[0] == "read" for op in row["dos"]), \
                        f"{case.name}: unexpected decoder read"
                if "drive_handles" in config:
                    handles = [op[2] for op in row["dos"] if op[0] == "drive"]
                    assert handles == config["drive_handles"], \
                        f"{case.name}: FileHandle/open ordering {handles}"
                if config.get("ems"):
                    assert row["ems"], f"{case.name}: missing EMS call trace"
                if config.get("no_ems"):
                    assert not row["ems"], f"{case.name}: unexpected EMS call trace {row['ems']}"
                if config.get("dos"):
                    assert any(op[0] == "allocate" for op in row["dos"]), \
                        f"{case.name}: no DOS allocation"
                if config.get("no_dos_alloc"):
                    assert not any(op[0] == "allocate" for op in row["dos"]), \
                        f"{case.name}: unexpected DOS allocation"
                if "shutdown" in config:
                    assert row["shutdown"] == config["shutdown"], \
                        f"{case.name}: ShutdownWithError calls {row['shutdown']}"
                if "dos_expected" in config:
                    assert row["dos"] == config["dos_expected"], \
                        f"{case.name}: DOS read/close policy {row['dos']}"
        finally:
            mocks.close()
            pair.a.rollback()
            pair.b.rollback()
            for side, original_run in saved_runs:
                side.run = original_run


MUTANTS = [
    ("cache.c", "entry->name == requested", "entry->name != requested"),
    ("cache.c", "FileBufferSegment, FileBufferOffset,\n                                        source_bytes", "FileBufferSegment, 0,\n                                        source_bytes"),
    ("cache.c", "while (remaining > 0x4000)", "while (remaining >= 0x4000)"),
    ("cache.c", "DriveAPresent == 1", "DriveAPresent != 0"),
    ("cache.c", "if (enc_result.failed == 0)", "if (enc_result.failed != 0)"),
    ("cache.c", "if (packed_result.started_decoder != 0)",
     "if (packed_result.started_decoder == 0)"),
    ("cache.c", "PackedOutputBytes = 0;", "PackedOutputBytes = 1;"),
    ("cache.c", "PackedReadCursor = (word)(dword)PackedReadBuffer + 0x0200;",
     "PackedReadCursor = (word)(dword)PackedReadBuffer + 0x01FF;"),
]
