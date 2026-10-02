"""Bounded differential tests for the SHADOW archive-open routine."""
import struct

from difftest import Case
from emu import FLAG, LOAD, REG
from resources import resources
from unicorn import UC_HOOK_CODE


ARCHIVE_LIST_BYTES = 0x72
TEST_CS = 0xA100
TEST_OPEN = "ARCHIVE_TEST_OPEN"
TEST_NATIVE = "ARCHIVE_TEST_NATIVE"
TEST_SETUP = "ARCHIVE_TEST_SETUP"


def word(value):
    return struct.pack("<H", value & 0xFFFF)


def set_cf(u, enabled):
    flags = u.reg_read(REG["FLAGS"])
    flags = flags | FLAG["CF"] if enabled else flags & ~FLAG["CF"]
    u.reg_write(REG["FLAGS"], flags)


def state_write(pair, name, data):
    return pair.a.m.offset(name), bytes(data)


def state_word(pair, name, value):
    return state_write(pair, name, word(value))


def shadow(entries, *, key=0x371B, mz_stub=False, signature=b"SHADOW"):
    """Build a small SHADOW file with one continuous rolling XOR key."""
    entry_size = 26
    base = 512 if mz_stub else 0
    payload_at = 12 + len(entries) * entry_size
    directory = bytearray()
    payload = bytearray()
    for name, contents in entries:
        encoded_name = name.upper().encode("ascii")
        if len(encoded_name) > 12:
            raise ValueError("test archive names must fit the 12-byte SHADOW field")
        record = bytearray(26)
        record[:5] = b"\x19\x27\x35\x43\x51"
        offset = payload_at + len(payload)
        struct.pack_into("<II", record, 5, offset, len(contents))
        record[13:26] = encoded_name.ljust(12, b" ") + b"\0"
        directory.extend(record)
        payload.extend(contents)

    low, step = key & 0xFF, key >> 8
    for at in range(len(directory)):
        directory[at] ^= low
        low = (low + step) & 0xFF

    header = struct.pack("<HH6sH", len(entries), key, signature, entry_size)
    archive = bytearray(base + len(header) + len(directory) + len(payload))
    if mz_stub:
        struct.pack_into("<HH", archive, 0, 0x5A4D, 0)
        struct.pack_into("<H", archive, 4, 2)  # MZ page count: directory begins at 512.
    archive[base:base + len(header)] = header
    archive[base + len(header):base + len(header) + len(directory)] = directory
    archive[base + len(header) + len(directory):] = payload
    return bytes(archive)


def install_far_stub(side, target, alias, offset):
    target_segment, target_offset = side.m.symbols[target.upper()]
    stub = b"\x9A" + struct.pack("<HH", target_offset, LOAD + target_segment) + b"\xC3"
    address = TEST_CS * 16 + offset
    previous = bytes(side.m.u.mem_read(address, len(stub)))
    side.m.u.mem_write(address, stub)
    side.m.symbols[alias.upper()] = (TEST_CS - LOAD, offset)
    return address, previous


def install_native_oracle_shim(side, offset):
    """Normalize the original far entry to the native helper's DX:AX result."""
    target_segment, target_offset = side.m.symbols["OPENRESOURCEFILE"]
    shim = (b"\x9A" + struct.pack("<HH", target_offset, LOAD + target_segment)
            + b"\x9C\x5A\x83\xE2\x01\xC3")
    address = TEST_CS * 16 + offset
    previous = bytes(side.m.u.mem_read(address, len(shim)))
    side.m.u.mem_write(address, shim)
    side.m.symbols[TEST_NATIVE] = (TEST_CS - LOAD, offset)
    return address, previous


class DosArchiveFiles:
    """A small deterministic byte store behind the original INT 21h file calls."""
    def __init__(self, pair, config):
        self.config = config
        self.rows = []
        self.hooks = []
        files = {bytes(name).lower(): bytes(data)
                 for name, data in config.get("files", {}).items()}
        for side in (pair.a, pair.b):
            row = dict(files=files, handles={}, dos=[], open_names=[],
                       reads=0, seeks=0, closes=0, next_handle=5)
            self.rows.append(row)

            def interrupt(u, address, _size, _data, side=side, row=row):
                if not side.image[0] <= address < side.image[1]:
                    return
                if bytes(u.mem_read(address, 2)) != b"\xCD\x21":
                    return
                ax = u.reg_read(REG["AX"])
                function = ax >> 8
                if function == 0x3D:
                    ds, dx = u.reg_read(REG["DS"]), u.reg_read(REG["DX"])
                    name = self.read_asciiz(u, ds, dx).lower()
                    row["open_names"].append(name)
                    fail = (name not in row["files"] or
                            name in self.config.get("open_fail", ()))
                    if fail:
                        u.reg_write(REG["AX"], 2)
                        set_cf(u, True)
                        row["dos"].append(("open", name, ax & 0xFF, "failed"))
                    else:
                        handle = row["next_handle"]
                        row["next_handle"] += 1
                        row["handles"][handle] = dict(data=row["files"][name], offset=0)
                        u.reg_write(REG["AX"], handle)
                        set_cf(u, False)
                        row["dos"].append(("open", name, ax & 0xFF, handle))
                elif function == 0x3F:
                    row["reads"] += 1
                    handle, count = u.reg_read(REG["BX"]), u.reg_read(REG["CX"])
                    item = row["handles"].get(handle)
                    fail = row["reads"] in self.config.get("read_fail", ()) or item is None
                    if fail:
                        u.reg_write(REG["AX"], 5)
                        set_cf(u, True)
                        row["dos"].append(("read", handle, count, "failed"))
                    else:
                        requested = self.config.get("read_short", {}).get(row["reads"], count)
                        data = item["data"][item["offset"]:item["offset"] + min(count, requested)]
                        ds, dx = u.reg_read(REG["DS"]), u.reg_read(REG["DX"])
                        if data:
                            u.mem_write(ds * 16 + dx, data)
                        item["offset"] += len(data)
                        u.reg_write(REG["AX"], len(data))
                        set_cf(u, False)
                        row["dos"].append(("read", handle, count, len(data)))
                elif function == 0x42:
                    row["seeks"] += 1
                    handle = u.reg_read(REG["BX"])
                    origin = ax & 0xFF
                    raw = (u.reg_read(REG["CX"]) << 16) | u.reg_read(REG["DX"])
                    offset = raw - 0x100000000 if raw & 0x80000000 else raw
                    item = row["handles"].get(handle)
                    fail = row["seeks"] in self.config.get("seek_fail", ()) or item is None
                    if not fail:
                        if origin == 0:
                            position = offset
                        elif origin == 1:
                            position = item["offset"] + offset
                        elif origin == 2:
                            position = len(item["data"]) + offset
                        else:
                            position = -1
                        fail = position < 0 or position > 0xFFFFFFFF
                    if fail:
                        u.reg_write(REG["AX"], 1)
                        u.reg_write(REG["DX"], 0)
                        set_cf(u, True)
                        row["dos"].append(("seek", handle, origin, offset, "failed"))
                    else:
                        item["offset"] = position
                        u.reg_write(REG["AX"], position & 0xFFFF)
                        u.reg_write(REG["DX"], (position >> 16) & 0xFFFF)
                        set_cf(u, False)
                        row["dos"].append(("seek", handle, origin, offset, position))
                elif function == 0x3E:
                    row["closes"] += 1
                    handle = u.reg_read(REG["BX"])
                    item = row["handles"].get(handle)
                    fail = row["closes"] in self.config.get("close_fail", ()) or item is None
                    if fail:
                        u.reg_write(REG["AX"], 6)
                        set_cf(u, True)
                        row["dos"].append(("close", handle, "failed"))
                    else:
                        del row["handles"][handle]
                        u.reg_write(REG["AX"], 0)
                        set_cf(u, False)
                        row["dos"].append(("close", handle, "ok"))
                else:
                    raise AssertionError(f"unexpected INT 21h function {function:02X}")
                u.reg_write(REG["IP"], (u.reg_read(REG["IP"]) + 2) & 0xFFFF)

            self.hooks.append(side.m.u.hook_add(
                UC_HOOK_CODE, interrupt, None, side.image[0], side.image[1]))
            side.m.u.ctl_remove_cache(side.image[0], side.image[1])

    @staticmethod
    def read_asciiz(u, segment, offset):
        result = bytearray()
        for i in range(256):
            value = u.mem_read(segment * 16 + ((offset + i) & 0xFFFF), 1)[0]
            if value == 0:
                return bytes(result)
            result.append(value)
        raise AssertionError("DOS open pathname was not terminated")

    def same_trace(self):
        for key in ("dos", "open_names"):
            assert self.rows[0][key] == self.rows[1][key], \
                f"archive {key} traces differ:\n  oracle {self.rows[0][key]}\n  hybrid {self.rows[1][key]}"

    def close(self, pair):
        for side, hook in zip((pair.a, pair.b), self.hooks):
            side.m.u.hook_del(hook)
            side.m.u.ctl_remove_cache(side.image[0], side.image[1])


def code_region(side):
    start = side.m.linear("ResOptions")
    end = side.m.linear("ResArchiveList") + ARCHIVE_LIST_BYTES
    return start, bytes(side.m.u.mem_read(start, end - start))


def configure_code_state(side, initial, config):
    start, data = initial
    side.m.u.mem_write(start, data)
    if config is None:
        return
    names = config["archives"]
    archive_bytes = b"".join(name + b"\0" for name in names) + b"\xFF"
    if len(archive_bytes) > ARCHIVE_LIST_BYTES:
        raise ValueError("test archive list exceeds ResArchiveList")
    archive_bytes = archive_bytes.ljust(ARCHIVE_LIST_BYTES, b"\xFF")
    side.m.u.mem_write(side.m.linear("ResArchiveList"), archive_bytes)
    side.m.poke("ResOptions", config.get("options", 0))
    starts = []
    cursor = 0
    for name in names:
        starts.append(cursor)
        cursor += len(name) + 1
    index = config.get("cursor_index", 0)
    list_offset = side.m.symbols["RESARCHIVELIST"][1]
    side.m.poke("ResCurArchive", list_offset + (starts[index] if names else 0))


def normalize_outside(side):
    list_start = side.m.symbols["RESARCHIVELIST"][1]
    normalized = []
    for where, size, value in side.outside:
        if where == "RESNAMEPTR+2":
            value = "state segment"
        elif where in ("RESSEARCHSTART+0", "RESCURARCHIVE+0"):
            value = ("ResArchiveList" if value == list_start else
                     f"ResArchiveList+{(value - list_start) & 0xFFFF:X}")
        normalized.append((where, size, value))
    # The ASM and C implementations can store the same external words in a different
    # order; compare each external location's final value.
    final_writes = {where: (where, size, value) for where, size, value in normalized}
    side.outside[:] = [final_writes[key] for key in sorted(final_writes)]


def archive_case(pair, name, config, expected=None, *, success=True, bp_preserved=True):
    filename = pair.a.m.offset("UnusedTextBuffer")
    writes = [state_write(pair, "UnusedTextBuffer", name + b"\0")]
    preserve = ["SP", "DS", "SS", "ES", "SI", "DI"]
    if bp_preserved:
        preserve.append("BP")

    def check(machine, regs):
        if expected is not None:
            expected(machine, regs)
        if success:
            assert regs["AX"] == regs["BX"], "successful open must return handle in AX and BX"
            assert not (regs["FLAGS"] & FLAG["CF"]), "successful open left CF set"
        else:
            assert regs["AX"] == 2, f"failed open returned AX={regs['AX']:04X}"
            assert regs["FLAGS"] & FLAG["CF"], "failed open cleared CF"

    return Case(TEST_OPEN,
                {"AX": 0xA5A5, "BX": 0x1234, "CX": 0x2345, "DX": filename,
                 "SI": 0x4567, "DI": 0x6789, "BP": 0x789A, "ES": 0xB800},
                writes, preserve=tuple(preserve),
                outputs=("AX", "BX", "CX", "DX") if success else ("AX",),
                flags=("CF",), expect=check, name=config["label"])


def check_success(_machine, regs, expected_handle, expected_length):
    assert regs["AX"] == expected_handle, f"handle AX={regs['AX']:04X}"
    assert regs["BX"] == expected_handle, f"handle BX={regs['BX']:04X}"
    assert regs["CX"] == (expected_length & 0xFFFF), f"length low CX={regs['CX']:04X}"
    assert regs["DX"] == ((expected_length >> 16) & 0xFFFF), f"length high DX={regs['DX']:04X}"


def setup_cases(pair):
    list_offset = pair.a.m.offset("ResourceArchiveList")
    return [
        Case(TEST_SETUP,
             {"AX": 0x4000, "SI": list_offset, "DI": 0x7788, "ES": 0xB800},
             preserve=("AX", "DI", "ES", "BP", "SP", "DS", "SS"),
             outputs=("SI",),
             expect=lambda m, _r: assert_archive_list_copied(m),
             name="ResLibSetup 4000h copies the active archive list"),
        Case(TEST_SETUP,
             {"AX": 0x8007, "SI": 0x1234, "DI": 0x7788, "ES": 0xB800},
             preserve=("AX", "SI", "DI", "ES", "BP", "SP", "DS", "SS"),
             expect=lambda m, _r: check_options(m, 7),
             name="ResLibSetup retains the represented option byte"),
    ]


def assert_archive_list_copied(machine):
    actual = bytes(machine.u.mem_read(machine.linear("ResArchiveList"), 10))
    assert actual == b"overkill\0\xFF", f"archive list copied as {actual!r}"


def check_options(machine, expected):
    assert machine.peek("ResOptions") == expected


def scenarios(pair, actual, adlib):
    plain = shadow([("F O O.BIN", b"directory payload")])
    multi = shadow([("TARGET.BIN", b"archive two")], mz_stub=True)
    target = shadow([("TARGET.BIN", b"archive two")])
    broken = b"not a SHADOW archive"
    bad_signature = shadow([("TARGET.BIN", b"bad signature")], signature=b"BROKEN")
    boundary = shadow([("EDGE.BIN", b"entry-count boundary")] +
                      [(f"ITEM{i:04d}.BIN", b"x") for i in range(799)])
    configs = [
        dict(label="pinned OVERKILL MZ archive, lowercase request", archives=[b"overkill"],
             files={b"overkill": actual}, options=0),
        dict(label="folded name and internal padding spaces", archives=[b"packed"],
             files={b"packed": plain}, options=0),
        dict(label="advance from a bad archive to a valid MZ archive", archives=[b"broken", b"valid"],
             files={b"broken": broken, b"valid": multi}, options=0),
        dict(label="wrap archive cursor after a complete miss", archives=[b"broken-a", b"broken-b"],
             files={b"broken-a": broken, b"broken-b": broken}, options=0),
        dict(label="loose-file option without directory stripping", archives=[b"ignored"],
             files={b"c:\\resource\\plain.bin": b"loose payload"}, options=1),
        dict(label="loose-file option with directory stripping", archives=[b"ignored"],
             files={b"plain.bin": b"loose payload"}, options=3),
        dict(label="option bit four leaves archive lookup intact", archives=[b"packed"],
             files={b"packed": plain}, options=4),
        dict(label="without strip option, an archive path stays qualified", archives=[b"packed"],
             files={b"packed": plain}, options=0),
        dict(label="read error advances to the next archive", archives=[b"first", b"second"],
             files={b"first": multi, b"second": multi}, options=0, read_fail={1}),
        dict(label="short header read remains a successful DOS read", archives=[b"first", b"second"],
             files={b"first": multi, b"second": multi}, options=0, read_short={1: 4}),
        dict(label="data seek error closes and reports a miss", archives=[b"packed"],
             files={b"packed": plain}, options=0, seek_fail={1}),
        dict(label="close error exits the search", archives=[b"broken"],
             files={b"broken": broken}, options=0, read_fail={1}, close_fail={1}),
        dict(label="entry count 800 is rejected", archives=[b"boundary"],
             files={b"boundary": boundary}, options=0),
        dict(label="zero entry count is rejected", archives=[b"empty"],
             files={b"empty": shadow([])}, options=0),
        dict(label="invalid SHADOW signature is rejected", archives=[b"bad"],
             files={b"bad": bad_signature}, options=0),
        dict(label="DOS open failure advances to the next archive",
             archives=[b"unopenable", b"valid-open"],
             files={b"valid-open": multi}, open_fail={b"unopenable"}, options=0),
        dict(label="MZ archive seek failure advances to the next archive",
             archives=[b"bad-mz", b"valid-seek"],
             files={b"bad-mz": multi, b"valid-seek": target},
             seek_fail={1}, options=0),
        dict(label="second MZ header read failure advances to the next archive",
             archives=[b"short-mz", b"valid-header"],
             files={b"short-mz": multi, b"valid-header": target},
             read_fail={2}, options=0),
        dict(label="directory entry read failure advances to the next archive",
             archives=[b"bad-directory", b"valid-directory"],
             files={b"bad-directory": target, b"valid-directory": target},
             read_fail={2}, options=0),
        dict(label="requested name spaces are skipped", archives=[b"packed"],
             files={b"packed": shadow([("FOO.BIN", b"spaced request payload")])},
             options=0),
    ]
    cases = [
        archive_case(pair, b"adlib.enc", configs[0],
                     lambda m, r: check_success(m, r, 5, adlib["size"]), success=True),
        archive_case(pair, b"foo.bin", configs[1],
                     lambda m, r: check_success(m, r, 5, len(b"directory payload")), success=True),
        archive_case(pair, b"target.bin", configs[2],
                     lambda m, r: check_success(m, r, 6, len(b"archive two")), success=True),
        archive_case(pair, b"missing.bin", configs[3], success=False),
        archive_case(pair, b"c:\\resource\\plain.bin", configs[4],
                     lambda m, r: check_success(m, r, 5, len(b"loose payload")), success=True),
        archive_case(pair, b"c:\\resource\\plain.bin", configs[5],
                     lambda m, r: check_success(m, r, 5, len(b"loose payload")),
                     success=True, bp_preserved=False),
        archive_case(pair, b"foo.bin", configs[6],
                     lambda m, r: check_success(m, r, 5, len(b"directory payload")), success=True),
        archive_case(pair, b"dir\\foo.bin", configs[7], success=False),
        archive_case(pair, b"target.bin", configs[8],
                     lambda m, r: check_success(m, r, 6, len(b"archive two")), success=True),
        archive_case(pair, b"target.bin", configs[9],
                     lambda m, r: check_success(m, r, 6, len(b"archive two")), success=True),
        archive_case(pair, b"foo.bin", configs[10], success=False),
        archive_case(pair, b"missing.bin", configs[11], success=False),
        archive_case(pair, b"edge.bin", configs[12], success=False),
        archive_case(pair, b"missing.bin", configs[13], success=False),
        archive_case(pair, b"target.bin", configs[14], success=False),
        archive_case(pair, b"target.bin", configs[15],
                     lambda m, r: check_success(m, r, 5, len(b"archive two")), success=True),
        archive_case(pair, b"target.bin", configs[16],
                     lambda m, r: check_success(m, r, 6, len(b"archive two")), success=True),
        archive_case(pair, b"target.bin", configs[17],
                     lambda m, r: check_success(m, r, 6, len(b"archive two")), success=True),
        archive_case(pair, b"target.bin", configs[18],
                     lambda m, r: check_success(m, r, 6, len(b"archive two")), success=True),
        archive_case(pair, b"F O O.BIN", configs[19],
                     lambda m, r: check_success(m, r, 5, len(b"spaced request payload")),
                     success=True),
    ]
    return list(zip(cases, configs))


def native_archive_cases(pair):
    archive = shadow([("NATIVE.BIN", b"native archive payload")])
    config = dict(label="native archive helper uses the live SHADOW search",
                  archives=[b"native"], files={b"native": archive}, options=0)

    def make(name, expected_handle, expected_status):
        filename = pair.a.m.offset("UnusedTextBuffer")
        writes = [state_write(pair, "UnusedTextBuffer", name + b"\0")]

        def check(_machine, regs):
            assert regs["AX"] == expected_handle, \
                f"native open returned AX={regs['AX']:04X}, expected {expected_handle:04X}"
            assert regs["DX"] == expected_status, \
                f"native open returned status DX={regs['DX']:04X}, expected {expected_status:04X}"

        case = Case(TEST_NATIVE,
                    {"AX": 0xA5A5, "BX": 0x1234, "CX": 0x2345,
                     "DX": filename, "SI": filename, "DI": 0x6789,
                     "BP": 0x789A, "ES": 0xB800},
                    writes, preserve=("SP", "DS", "SS", "BP"),
                    outputs=("AX", "DX"), expect=check,
                    name=("native helper success" if expected_status == 0
                          else "native helper miss returns DOS error AX=2"))
        return case, config

    return [make(b"native.bin", 5, 0), make(b"missing.bin", 2, 1)]


def cases(rng, scale, pair):
    """Bounded archive calls with a per-case fake DOS file backend."""
    del rng, scale
    actual, directory = resources()
    adlib = next(row for row in directory if row["name"] == "ADLIB.ENC")
    initial_code = {side: code_region(side) for side in (pair.a, pair.b)}
    stubs = {side: install_far_stub(side, "OpenResourceFile", TEST_OPEN, 0)
             for side in (pair.a, pair.b)}
    native_shim = install_native_oracle_shim(pair.a, 0x20)
    previous_native_alias = pair.b.m.symbols.get(TEST_NATIVE)
    pair.b.m.symbols[TEST_NATIVE] = pair.b.m.symbols["ARCHIVE_OPEN_BY_NAME"]
    setup_stubs = {side: install_far_stub(side, "ResLibSetup", TEST_SETUP, 0x10)
                   for side in (pair.a, pair.b)}
    original_runs = []
    config_slot = [None]

    for side in (pair.a, pair.b):
        original = side.run
        original_runs.append((side, original))

        def keep_and_configure(case, *args, side=side, original=original, **kwargs):
            configure_code_state(side, initial_code[side], config_slot[0])
            call_args = [case, *args]
            if len(call_args) >= 4:
                call_args[3] = True
            else:
                kwargs["keep"] = True
            result = original(*call_args, **kwargs)
            normalize_outside(side)
            return result

        side.run = keep_and_configure

    try:
        fixtures = ([(case, None) for case in setup_cases(pair)]
                    + scenarios(pair, actual, adlib)
                    + native_archive_cases(pair))
        for case, config in fixtures:
            config_slot[0] = config
            mocks = DosArchiveFiles(pair, config) if config is not None else None
            try:
                yield case
                if mocks is not None:
                    mocks.same_trace()
                    if case.name == "pinned OVERKILL MZ archive, lowercase request":
                        for row in mocks.rows:
                            handle = next(h for h, item in row["handles"].items()
                                          if item["data"] == actual)
                            assert row["handles"][handle]["offset"] == adlib["offset"], \
                                "real OVERKILL entry was not left at its pinned payload offset"
                    if config.get("read_fail") == {1} and config["label"].startswith("read error"):
                        for row in mocks.rows:
                            opened = [entry[1] for entry in row["dos"] if entry[0] == "open"]
                            assert opened == [b"first", b"second"], \
                                f"read failure did not advance to the next archive: {opened}"
                    if config.get("close_fail"):
                        for row in mocks.rows:
                            assert sum(entry[0] == "close" for entry in row["dos"]) == 2
                elif "4000h" in case.name:
                    for side in (pair.a, pair.b):
                        assert_archive_list_copied(side.m)
                else:
                    for side in (pair.a, pair.b):
                        check_options(side.m, 7)
            finally:
                if mocks is not None:
                    mocks.close(pair)
                pair.a.rollback()
                pair.b.rollback()
                for side in (pair.a, pair.b):
                    start, data = initial_code[side]
                    side.m.u.mem_write(start, data)
    finally:
        for side, original in original_runs:
            side.run = original
        for side, state in stubs.items():
            address, previous = state
            side.m.u.mem_write(address, previous)
        for side, state in setup_stubs.items():
            address, previous = state
            side.m.u.mem_write(address, previous)
        address, previous = native_shim
        pair.a.m.u.mem_write(address, previous)
        if previous_native_alias is None:
            pair.b.m.symbols.pop(TEST_NATIVE, None)
        else:
            pair.b.m.symbols[TEST_NATIVE] = previous_native_alias
        for side in (pair.a, pair.b):
            start, data = initial_code[side]
            side.m.u.mem_write(start, data)


MUTANTS = [
    ("archive.c", "if (requested >= 'a' && requested <= 'z') requested &= 0x5F;",
     "if (requested >= 'a' && requested <= 'z') requested = requested;"),
    ("archive.c", "low_key = (byte)(low_key + key_step);", "low_key++;"),
    ("archive.c", "ResEntryCount >= 0x0320", "ResEntryCount > 0x0320"),
    ("archive.c", "(result.status != 0 ? 2 : result.handle)",
     "(result.status != 0 ? 0 : result.handle)"),
]
