"""Mothership departure data against the frozen DOS oracle.

Run ``python tests/host/departure.py`` to rebuild the native core and run the
bounded checks, or pass ``--no-build`` to reuse build/host and build/oracle-sym.
The fixtures call leaf entries only; no gameplay loop is started.
"""
from __future__ import annotations

import argparse
import copy
import ctypes
import importlib.util
import os
from pathlib import Path
import struct
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
HOST_DIR = ROOT / "build/host"
HOST_IMAGE = HOST_DIR / "HOST_IMAGE.BIN"
sys.path.insert(0, str(TOOLS))
from level_departure import departure_definition, generate_departure_header  # noqa: E402
from level_format import load, original_paths, validate  # noqa: E402
from level_bindings import load_original_bindings  # noqa: E402
from world import FIELDS, K, RECORD  # noqa: E402

DOS_MEMORY_BYTES = 0x100000
MAP_SEGMENT = 0x9000


def _module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    result = importlib.util.module_from_spec(spec)
    sys.modules[name] = result
    spec.loader.exec_module(result)
    return result


class Departure(ctypes.Structure):
    _fields_ = [(name, ctypes.c_void_p)
                for name in ("terrain_rows", "animated_parts", "approach", "dock")]


class MainArena:
    """Native physical memory corresponding to the oracle's relocated image."""

    def __init__(self, h) -> None:
        image = HOST_IMAGE.read_bytes()
        if len(image) != DOS_MEMORY_BYTES:
            raise AssertionError("HOST_IMAGE.BIN must be a 1 MiB image")
        self.image = image
        self.storage = (ctypes.c_ubyte * DOS_MEMORY_BYTES).from_buffer_copy(image)
        self.base = ctypes.addressof(self.storage)
        h.lib.overkill_bind_real_memory.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
        h.lib.overkill_bind_real_memory.restype = ctypes.c_int
        if not h.lib.overkill_bind_real_memory(self.base, DOS_MEMORY_BYTES):
            raise AssertionError("native core rejected its 1 MiB physical-memory arena")

    def reset(self) -> None:
        ctypes.memmove(self.base, self.image, DOS_MEMORY_BYTES)

    def sync_oracle_symbol(self, h, name: str) -> None:
        address = h.m.linear(name)
        ctypes.memmove(self.base + address,
                       bytes(h.m.u.mem_read(address, 2)), 2)


def _native_physical(h, arena: MainArena, address: int, size: int) -> bytes:
    address &= 0xFFFFF
    ds_base = h.m.data_frame << 4
    ds_offset = (address - ds_base) & 0xFFFFF
    if ds_offset + size <= 0x10000:
        return ctypes.string_at(h.state_addr + ds_offset, size)
    return ctypes.string_at(arena.base + address, size)


def _oracle_physical(h, address: int, size: int) -> bytes:
    return bytes(h.m.u.mem_read(address & 0xFFFFF, size))


def _oracle_state_with_canonical_tables(h, state: bytes, tables) -> bytes:
    """Compare runtime results despite different static-content storage.

    Authored values live in native level data, but the ASM reader needs them in
    its DS tables. Only those test-only source edits are removed; all map, record
    and phase effects remain in the comparison. Authored cases use disjoint maps.
    """
    restored = bytearray(state)
    for name, size in tables:
        offset = h.offset(name)
        restored[offset:offset + size] = h.baseline[offset:offset + size]
    return bytes(restored)


def _compile_alternate(documents, machine) -> ctypes.CDLL:
    out = ROOT / "build/host-departure"
    out.mkdir(parents=True, exist_ok=True)
    generate_departure_header(out, documents, machine)
    compiler = os.environ.get("CC", "gcc")
    command = [compiler, "-std=c11", "-O2", "-Wall", "-Wextra", "-Werror",
               "-Wno-unknown-pragmas", "-fno-strict-aliasing", "-DOVERKILL_HOST",
               "-shared", "-I" + str(out), "-I" + str(HOST_DIR),
               "-I" + str(ROOT / "c"), "-I" + str(ROOT / "host")]
    if os.name != "nt":
        command.append("-fPIC")
    command += [str(ROOT / path) for path in (
        "c/levels.c", "c/frame.c", "c/player.c", "host/level_departure.c")]
    if os.name == "nt":
        command += ["-static-libgcc", "-L" + str(HOST_DIR), "-loverkill_core"]
        output = out / "departure_edited.dll"
    else:
        command += ["-L" + str(HOST_DIR), "-loverkill_core",
                    "-Wl,-rpath," + str(HOST_DIR)]
        output = out / "libdeparture_edited.so"
    subprocess.run(command + ["-o", str(output)], check=True)
    return ctypes.CDLL(str(output))


def _bind_departure_api(lib) -> None:
    word = ctypes.c_uint16
    pointer = ctypes.c_void_p
    lib.overkill_level_departure.argtypes = (word, ctypes.POINTER(Departure))
    lib.overkill_level_departure.restype = None
    for name in ("initialize_level_byte_attributes", "run_level_end_sequence"):
        fn = getattr(lib, name)
        fn.argtypes = ()
        fn.restype = None
    lib.scroll_forward_and_check_level_end.argtypes = (pointer,)
    lib.scroll_forward_and_check_level_end.restype = None


def _fixtures(h) -> int:
    documents = [load(path) for path in original_paths()]
    expected = departure_definition(h.m)
    for level, document in enumerate(documents):
        if document.get("departure") != expected:
            raise AssertionError(f"canonical level {level} departure differs from the oracle tables")

    # The section is optional for earlier profiles. Omission must mean the original
    # shared tables and leave the initial state image byte-for-byte unchanged.
    old = copy.deepcopy(documents)
    for document in old:
        document.pop("departure")
        validate(document)
    if load_original_bindings(h.m) != h.baseline:
        raise AssertionError("canonical departure binding changes default DS bytes")
    canonical_header = ROOT / "build/host-departure-canonical"
    omitted_header = ROOT / "build/host-departure-omitted"
    generate_departure_header(canonical_header, documents, h.m)
    generate_departure_header(omitted_header, old, h.m)
    if ((canonical_header / "DEPARTURES_GEN.H").read_bytes() !=
            (omitted_header / "DEPARTURES_GEN.H").read_bytes()):
        raise AssertionError("omitted departure no longer binds the shared legacy tables")

    malformed = []
    for path, value in (
            (("kind",), "boss"),
            (("terrain_rows",), []),
            (("terrain_rows", 0), [1] * (K.MAP_ROW_BYTES - 1)),
            (("terrain_rows", 0, 0), True),
            (("terrain_rows", 0, 0), 256),
            (("animated_parts",), []),
            (("animated_parts", 0, "x"), 32768),
            (("animated_parts", 0, "y"), -32769),
            (("animated_parts", 0, "sprite"), -1),
            (("animated_parts", 0, "sprite"), 65536),
            (("waypoints", "approach", "x"), False),
            (("waypoints", "dock", "y"), 32768),
    ):
        edited = copy.deepcopy(documents[0])
        target = edited["departure"]
        for key in path[:-1]:
            target = target[key]
        target[path[-1]] = value
        malformed.append(edited)
    edited = copy.deepcopy(documents[0])
    del edited["departure"]["waypoints"]["dock"]
    malformed.append(edited)
    edited = copy.deepcopy(documents[0])
    edited["departure"]["animated_parts"][0]["extra"] = 1
    malformed.append(edited)
    for document in malformed:
        try:
            validate(document)
        except (ValueError, TypeError):
            continue
        raise AssertionError("departure validator accepted malformed data")
    return len(documents) + len(old) + len(malformed) + 1


def _pointer_bindings(h, lib) -> int:
    lib.overkill_level_departure.argtypes = (ctypes.c_uint16, ctypes.POINTER(Departure))
    lib.overkill_level_departure.restype = None
    table_names = ("LevelEndMapRows", "Type53SpawnTable",
                   "AutopilotWaypointA", "AutopilotWaypointB")
    fields = ("terrain_rows", "animated_parts", "approach", "dock")
    for level in range(6):
        departure = Departure()
        lib.overkill_level_departure(level, ctypes.byref(departure))
        for field, symbol in zip(fields, table_names):
            if getattr(departure, field) != h.state_addr + h.offset(symbol):
                raise AssertionError(f"level {level} {field} stopped referencing its live DS table")

    # Mutating the aliased DS data after obtaining the view remains visible through
    # the immutable descriptor's pointer, as the old runtime's reads are live.
    departure = Departure()
    lib.overkill_level_departure(2, ctypes.byref(departure))
    row_offset = h.offset("LevelEndMapRows")
    saved = h.state_storage.snapshot()[row_offset]
    h.write(row_offset, bytes([(saved + 1) & 0xFF]))
    if ctypes.c_uint8.from_address(departure.terrain_rows).value != (saved + 1) & 0xFF:
        raise AssertionError("default terrain reference cached the old DS value")
    h.reset()
    return 7


def _setup_map_case(h, arena: MainArena, level: int) -> None:
    h.reset()
    arena.reset()
    h.m.poke("LevelMapSegment", MAP_SEGMENT)
    arena.sync_oracle_symbol(h, "LevelMapSegment")
    h.write_symbol("LevelIndex", struct.pack("<H", level))


def _map_tail_cases(h, arena, lib, custom=None) -> int:
    lib.initialize_level_byte_attributes.argtypes = ()
    lib.initialize_level_byte_attributes.restype = None
    count = 0
    # Compare the actual standalone ASM initializer with the native coordinator
    # for every original level, including all five appended rows.
    for level in range(6):
        if custom is not None and level == 2:
            continue
        _setup_map_case(h, arena, level)
        h.m.call("InitializeByteAttributes")
        physical = ((MAP_SEGMENT << 4) + K.MAP_END_ROWS_POS) & 0xFFFFF
        expected = _oracle_physical(h, physical, 5 * K.MAP_ROW_BYTES)
        expected_state = h.m.state()

        _setup_map_case(h, arena, level)
        lib.initialize_level_byte_attributes()
        h.m.set_state(expected_state)
        h.compare(f"original departure terrain level {level}")
        actual = _native_physical(h, arena, physical, 5 * K.MAP_ROW_BYTES)
        if actual != expected:
            raise AssertionError(f"level {level}: appended mothership terrain differs")
        count += 1

    # Forward overlapping copy is observable because the original uses REP MOVSB.
    # Aim the destination three bytes into its own 65-byte source table so each
    # earlier store changes later source reads. The oracle and native path must agree.
    _setup_map_case(h, arena, 0)
    source = h.offset("LevelEndMapRows")
    delta = source - K.MAP_END_ROWS_POS
    segment = h.m.data_frame + (delta + 15) // 16
    h.m.poke("LevelMapSegment", segment)
    arena.sync_oracle_symbol(h, "LevelMapSegment")
    h.m.call("InitializeByteAttributes")
    physical = ((segment << 4) + K.MAP_END_ROWS_POS) & 0xFFFFF
    expected = _oracle_physical(h, physical, 5 * K.MAP_ROW_BYTES)
    expected_state = h.m.state()
    _setup_map_case(h, arena, 0)
    h.m.poke("LevelMapSegment", segment)
    arena.sync_oracle_symbol(h, "LevelMapSegment")
    lib.initialize_level_byte_attributes()
    h.m.set_state(expected_state)
    h.compare("overlapping departure terrain copy")
    if _native_physical(h, arena, physical, 5 * K.MAP_ROW_BYTES) != expected:
        raise AssertionError("overlapping departure terrain copy changed source-read order")
    count += 1

    if custom is not None:
        # An authored level's changed rows are compiled into its LevelDeparture view.
        rows = custom["departure"]["terrain_rows"]
        payload = bytes(tile for row in rows for tile in row)
        _setup_map_case(h, arena, 2)
        h.m.write(h.offset("LevelEndMapRows"), payload)
        h.m.call("InitializeByteAttributes")
        physical = ((MAP_SEGMENT << 4) + K.MAP_END_ROWS_POS) & 0xFFFFF
        expected = _oracle_physical(h, physical, 5 * K.MAP_ROW_BYTES)
        expected_state = _oracle_state_with_canonical_tables(
            h, h.m.state(), (("LevelEndMapRows", 5 * K.MAP_ROW_BYTES),))
        _setup_map_case(h, arena, 2)
        lib.initialize_level_byte_attributes()
        h.m.set_state(expected_state)
        h.compare("authored departure terrain level 2")
        actual = _native_physical(h, arena, ((MAP_SEGMENT << 4) + K.MAP_END_ROWS_POS) & 0xFFFFF,
                                  5 * K.MAP_ROW_BYTES)
        if actual != expected:
            raise AssertionError("authored departure rows missed the compiled native path")
        count += 1

        # The same binary retains legacy rows for another level; level 3 does not
        # inherit level 2's generated data.
        _setup_map_case(h, arena, 3)
        h.m.call("InitializeByteAttributes")
        expected = _oracle_physical(h, ((MAP_SEGMENT << 4) + K.MAP_END_ROWS_POS) & 0xFFFFF,
                                    5 * K.MAP_ROW_BYTES)
        expected_state = h.m.state()
        _setup_map_case(h, arena, 3)
        lib.initialize_level_byte_attributes()
        h.m.set_state(expected_state)
        h.compare("authored departure isolated from level 3")
        if _native_physical(h, arena, ((MAP_SEGMENT << 4) + K.MAP_END_ROWS_POS) & 0xFFFFF,
                            5 * K.MAP_ROW_BYTES) != expected:
            raise AssertionError("authored level 2 terrain leaked into level 3")
        count += 1
    return count


def _pool_state(h, free_slots=()):
    base = h.offset("PoolA")
    data = bytearray(RECORD * K.POOL_A_COUNT)
    for index in range(K.POOL_A_COUNT):
        at = index * RECORD
        struct.pack_into("<H", data, at + FIELDS["status"], 0 if index in free_slots else 1)
        struct.pack_into("<H", data, at + FIELDS["kind"], K.KIND_SCENERY)
        struct.pack_into("<H", data, at + FIELDS["type"], 0x44 + index)
        struct.pack_into("<H", data, at + FIELDS["draw_pass"], 0x1200 + index)
        struct.pack_into("<H", data, at + FIELDS["flash_timer"], 0x2300 + index)
        struct.pack_into("<H", data, at + FIELDS["hit_points"], 0x3400 + index)
    h.write(base, data)
    h.write_symbol("PoolACursor", struct.pack("<H", base + (K.POOL_A_COUNT - 1) * RECORD))
    return base


def _scroll_setup(h, arena, level, free_slots=()):
    _setup_map_case(h, arena, level)
    _pool_state(h, free_slots)
    for name, value in (("MapScrollPos", K.MAP_END_POS), ("ScrollSubRow", 1),
                        ("ScrollWindowOffset", 0), ("ScrollDeltaY", 0),
                        ("LastTileStepBackward", 0), ("LevelEndPhase", 0),
                        ("EncounterLiveCount", 0), ("EncounterEndDelay", 0)):
        h.write_symbol(name, struct.pack("<H", value))
    h.write_symbol("SfxEnabled", b"\x00")
    h.write_symbol("PrimaryRecord", bytes(RECORD))


def _frame_end_cases(h, arena, lib, custom=None) -> int:
    lib.scroll_forward_and_check_level_end.argtypes = (ctypes.c_void_p,)
    lib.scroll_forward_and_check_level_end.restype = None
    count = 0
    for level in range(6):
        if custom is not None and level == 2:
            continue
        for free_slots in ((34, 0), tuple(range(K.POOL_A_COUNT)), ()):
            _scroll_setup(h, arena, level, free_slots)
            primary = h.offset("PrimaryRecord")
            h.m.call("ScrollForwardAndCheckLevelEnd", {"BP": primary})
            expected_state = h.m.state()
            _scroll_setup(h, arena, level, free_slots)
            lib.scroll_forward_and_check_level_end(ctypes.c_void_p(h.state_addr + primary))
            h.m.set_state(expected_state)
            h.compare(f"mothership frame spawns level {level} free={free_slots}")
            if free_slots:
                base = h.offset("PoolA")
                available = set(free_slots)
                allocated = [((K.POOL_A_COUNT - 1 + step) % K.POOL_A_COUNT)
                             for step in range(K.POOL_A_COUNT)
                             if ((K.POOL_A_COUNT - 1 + step) % K.POOL_A_COUNT) in available]
                allocated = allocated[:min(4, len(available))]
                records = [base + slot * RECORD for slot in allocated]
                expected = ((0x20, 0x18, 0x10), (0x20, 0x98, 0x13),
                            (0x40, 0x28, 0x16), (0x40, 0x88, 0x19))
                for record, (y, x, sprite) in zip(records, expected):
                    got = tuple(h.m.word(record + FIELDS[name]) for name in ("y", "x", "sprite"))
                    if got != (y, x, sprite):
                        raise AssertionError("table cursor did not advance once per successful allocation")
                    for name, stale in (("draw_pass", 0x1200 + (record - base) // RECORD),
                                        ("flash_timer", 0x2300 + (record - base) // RECORD),
                                        ("hit_points", 0x3400 + (record - base) // RECORD)):
                        if h.m.word(record + FIELDS[name]) != stale:
                            raise AssertionError(f"end spawn unexpectedly initialized stale {name}")
            count += 1

    if custom is not None:
        parts = custom["departure"]["animated_parts"]
        payload = b"".join(struct.pack("<hhH", part["y"], part["x"], part["sprite"])
                           for part in parts)
        _scroll_setup(h, arena, 2, (34, 0))
        h.m.write(h.offset("Type53SpawnTable"), payload)
        h.m.call("ScrollForwardAndCheckLevelEnd", {"BP": h.offset("PrimaryRecord")})
        expected_state = _oracle_state_with_canonical_tables(
            h, h.m.state(), (("Type53SpawnTable", 24),))
        _scroll_setup(h, arena, 2, (34, 0))
        lib.scroll_forward_and_check_level_end(ctypes.c_void_p(h.state_addr + h.offset("PrimaryRecord")))
        h.m.set_state(expected_state)
        h.compare("authored animated parts level 2")
        for slot, part in zip((34, 0), parts):
            record = h.offset("PoolA") + slot * RECORD
            got = tuple(h.m.word(record + FIELDS[name]) for name in ("y", "x", "sprite"))
            if got != (part["y"] & 0xFFFF, part["x"] & 0xFFFF, part["sprite"]):
                raise AssertionError("authored animated-part table missed compiled native path")
        count += 1
    return count


def _waypoint_setup(h, arena, level, phase, x, y):
    _setup_map_case(h, arena, level)
    primary = h.offset("PrimaryRecord")
    data = bytearray(RECORD)
    struct.pack_into("<H", data, FIELDS["x"], x & 0xFFFF)
    struct.pack_into("<H", data, FIELDS["y"], y & 0xFFFF)
    struct.pack_into("<H", data, FIELDS["sprite"], 1)
    h.write(primary, data)
    _pool_state(h, (0,))
    h.write_symbol("PoolACursor", struct.pack("<H", h.offset("PoolA")))
    for name, value in (("LevelEndPhase", phase), ("SidePodSpreadLeft", 0),
                        ("SidePodSpreadRight", 0), ("Fuel", 0x58),
                        ("EnergyTanks", 3), ("EnergyPoints", 0x18)):
        h.write_symbol(name, struct.pack("<H", value))


def _phase_cases(h, arena, lib, docs, custom=None) -> int:
    lib.run_level_end_sequence.argtypes = ()
    lib.run_level_end_sequence.restype = None
    count = 0
    cases = []
    for level, document in enumerate(docs):
        if custom is not None and level == 2:
            continue
        waypoints = document["departure"]["waypoints"]
        a = waypoints["approach"]
        b = waypoints["dock"]
        cases.extend(((level, 1, a["x"], (a["y"] + 1) & 0xFFFF),
                      (level, 1, a["x"], a["y"]),
                      (level, 2, b["x"], b["y"])))
    if custom is not None:
        waypoints = custom["departure"]["waypoints"]
        a, b = waypoints["approach"], waypoints["dock"]
        cases.extend(((2, 1, a["x"], (a["y"] + 1) & 0xFFFF,
                       custom["departure"]["waypoints"]),
                      (2, 1, a["x"], a["y"], custom["departure"]["waypoints"]),
                      (2, 2, b["x"], b["y"], custom["departure"]["waypoints"]),
                      (3, 1, docs[3]["departure"]["waypoints"]["approach"]["x"],
                       docs[3]["departure"]["waypoints"]["approach"]["y"], None)))
    for case in cases:
        if len(case) == 4:
            level, phase, x, y = case
            edited_waypoints = None
        else:
            level, phase, x, y, edited_waypoints = case
        _waypoint_setup(h, arena, level, phase, x, y)
        if edited_waypoints is not None:
            _write_oracle_waypoints(h, edited_waypoints)
        h.m.call("RunLevelEndSequence")
        expected_state = h.m.state()
        if edited_waypoints is not None:
            expected_state = _oracle_state_with_canonical_tables(
                h, expected_state, (("AutopilotWaypointA", 4), ("AutopilotWaypointB", 4)))
        _waypoint_setup(h, arena, level, phase, x, y)
        lib.run_level_end_sequence()
        h.m.set_state(expected_state)
        h.compare(f"departure phase/waypoint level={level} phase={phase}")
        count += 1
    return count


def _write_oracle_waypoints(h, waypoints):
    for key, symbol in (("approach", "AutopilotWaypointA"), ("dock", "AutopilotWaypointB")):
        point = waypoints[key]
        h.m.write(h.offset(symbol), struct.pack("<hh", point["y"], point["x"]))


def _authored_documents(docs):
    edited = copy.deepcopy(docs)
    departure = edited[2]["departure"]
    departure["terrain_rows"][2][4] = (departure["terrain_rows"][2][4] + 37) & 0xFF
    part = departure["animated_parts"][0]
    part.update(x=-53, y=91, sprite=0x177)
    departure["waypoints"]["approach"].update(x=0x36, y=0x90)
    departure["waypoints"]["dock"].update(x=0x72, y=0x20)
    for document in edited:
        validate(document)
    return edited


def _authored_view_cases(h, lib, edited) -> int:
    original_ptrs = (h.offset("LevelEndMapRows"), h.offset("Type53SpawnTable"),
                     h.offset("AutopilotWaypointA"), h.offset("AutopilotWaypointB"))
    fields = ("terrain_rows", "animated_parts", "approach", "dock")
    for level in range(6):
        departure = Departure()
        lib.overkill_level_departure(level, ctypes.byref(departure))
        if level == 2:
            for field in fields:
                if getattr(departure, field) == h.state_addr + original_ptrs[fields.index(field)]:
                    raise AssertionError(f"authored level {level} {field} still aliases original shared data")
        else:
            for field, offset in zip(fields, original_ptrs):
                if getattr(departure, field) != h.state_addr + offset:
                    raise AssertionError(f"authored level 2 leaked into level {level} {field}")
    departure = Departure()
    lib.overkill_level_departure(2, ctypes.byref(departure))
    parts = edited[2]["departure"]["animated_parts"]
    got = struct.unpack("<12H", ctypes.string_at(departure.animated_parts, 24))
    expected = tuple(part[field] & 0xFFFF for part in parts for field in ("y", "x", "sprite"))
    if got != expected:
        raise AssertionError("authored part words were not emitted as the expected Y/X/sprite order")
    a = struct.unpack("<2h", ctypes.string_at(departure.approach, 4))
    b = struct.unpack("<2h", ctypes.string_at(departure.dock, 4))
    if a != (edited[2]["departure"]["waypoints"]["approach"]["y"],
             edited[2]["departure"]["waypoints"]["approach"]["x"]):
        raise AssertionError("authored approach waypoint did not reach its compiled view")
    if b != (edited[2]["departure"]["waypoints"]["dock"]["y"],
             edited[2]["departure"]["waypoints"]["dock"]["x"]):
        raise AssertionError("authored dock waypoint did not reach its compiled view")
    return 7


def run(no_build: bool = False) -> int:
    if no_build:
        if not (HOST_DIR / "OVERKILL_CORE.dll" if sys.platform == "win32"
                else HOST_DIR / "liboverkill_core.so").is_file():
            raise FileNotFoundError("--no-build requires the current build/host core")
    else:
        sys.path.insert(0, str(TOOLS))
        import host as host_build  # pylint: disable=import-outside-toplevel
        host_build.build()

    harness = _module("departure_input_harness", ROOT / "tests/host/input.py")
    h = harness.HostHarness()
    arena = MainArena(h)
    docs = [load(path) for path in original_paths()]
    counts = {"fixtures and validator": _fixtures(h)}
    _bind_departure_api(h.lib)
    counts["live DS references"] = _pointer_bindings(h, h.lib)
    counts["original ASM/native map tails"] = _map_tail_cases(h, arena, h.lib)
    counts["original ASM/native end spawns"] = _frame_end_cases(h, arena, h.lib)
    counts["original ASM/native waypoint phases"] = _phase_cases(h, arena, h.lib, docs)

    edited = _authored_documents(docs)
    alternate = _compile_alternate(edited, h.m)
    _bind_departure_api(alternate)
    counts["compiled authored data isolation"] = _authored_view_cases(h, alternate, edited)
    counts["authored ASM/native map tails"] = _map_tail_cases(h, arena, alternate, edited[2])
    counts["authored ASM/native end spawns"] = _frame_end_cases(h, arena, alternate, edited[2])
    counts["authored ASM/native waypoint phases"] = _phase_cases(h, arena, alternate, docs, edited[2])
    h.check_canaries()
    total = sum(counts.values())
    details = ", ".join(f"{name}: {count}" for name, count in counts.items())
    print(f"PASS host departure: {total} checks ({details})")
    return total


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--no-build", action="store_true",
                        help="reuse build/host and build/oracle-sym artifacts")
    args = parser.parse_args()
    run(no_build=args.no_build)


if __name__ == "__main__":
    main()
