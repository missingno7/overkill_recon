"""Loose-level loader and headless custom-content runtime checks.

Run ``python tests/host/level_content_runtime.py`` against the existing full host
build. The suite does not build or modify shared build outputs.
"""
from __future__ import annotations

import copy
import ctypes
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
TOOLS = ROOT / "tools"
TESTS = ROOT / "tests"
HOST_TESTS = ROOT / "tests/host"
sys.path.insert(0, str(TOOLS))
sys.path.append(str(TESTS))

from common import write_json  # noqa: E402
from level_content import duplicate_original, validate_directory  # noqa: E402


def _load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise ImportError(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


HostHarness = _load_module("level_content_input_harness", HOST_TESTS / "input.py").HostHarness
runtime = _load_module("level_content_runtime_helpers", HOST_TESTS / "runtime.py")
checkpoints = _load_module("level_content_checkpoint_helpers", HOST_TESTS / "checkpoints.py")


class TileRestoration(ctypes.Structure):
    _fields_ = [("tile", ctypes.c_uint8), ("replacement", ctypes.c_uint8)]


class CheckpointRestart(ctypes.Structure):
    _fields_ = [
        ("lookback_rows", ctypes.c_uint16),
        ("rule_count", ctypes.c_uint16),
        ("rules", ctypes.POINTER(TileRestoration)),
    ]


def _bind_content_api(harness: HostHarness):
    lib = harness.lib
    lib.overkill_level_content_load.argtypes = (
        ctypes.c_char_p, ctypes.c_char_p, ctypes.c_char_p, ctypes.c_size_t,
    )
    lib.overkill_level_content_load.restype = ctypes.c_int
    lib.overkill_level_content_unload.argtypes = ()
    lib.overkill_level_content_unload.restype = None
    lib.overkill_level_content_id.argtypes = ()
    lib.overkill_level_content_id.restype = ctypes.c_char_p
    lib.overkill_level_content_behavior_profile.argtypes = ()
    lib.overkill_level_content_behavior_profile.restype = ctypes.c_uint16
    lib.overkill_level_content_copy_map.argtypes = ()
    lib.overkill_level_content_copy_map.restype = ctypes.c_int
    lib.overkill_bind_real_memory.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_bind_real_memory.restype = ctypes.c_int
    lib.overkill_bind_level_map.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_bind_level_map.restype = ctypes.c_int
    lib.overkill_level_music.argtypes = (ctypes.c_uint16,)
    lib.overkill_level_music.restype = ctypes.c_uint8
    lib.overkill_level_checkpoint_restart.argtypes = (ctypes.c_uint16,)
    lib.overkill_level_checkpoint_restart.restype = ctypes.POINTER(CheckpointRestart)
    arena = checkpoints.Arena(harness)
    arena.load(bytes(harness.m.u.mem_read(0, checkpoints.DOS_MEMORY_BYTES)))
    map_memory = (ctypes.c_uint8 * 0x10000).from_address(
        arena.base + ((arena.map_segment << 4) & 0xFFFFF)
    )
    return arena, map_memory


def _load(harness: HostHarness, directory: Path) -> tuple[bool, str]:
    error = ctypes.create_string_buffer(512)
    ok = harness.lib.overkill_level_content_load(
        os.fsencode(directory), os.fsencode(ROOT / "levels/original"),
        error, len(error),
    )
    return bool(ok), error.value.decode("utf-8", errors="replace")


def _id(harness: HostHarness) -> str | None:
    value = harness.lib.overkill_level_content_id()
    return value.decode("ascii") if value else None


def _map_bytes(map_memory) -> bytes:
    return bytes(map_memory[:13 * 288])


def _rewrite(directory: Path, document: dict) -> None:
    write_json(directory / "level.json", document)


def _invalid_fixtures(root: Path) -> list[tuple[str, Path]]:
    cases: list[tuple[str, Path]] = []

    def add(name: str, mutate, *, map_bytes: bytes | None = None) -> None:
        directory = root / name
        document = duplicate_original(2, directory, f"invalid_{name}")
        changed = copy.deepcopy(document)
        mutate(changed)
        _rewrite(directory, changed)
        if map_bytes is not None:
            (directory / "map.bin").write_bytes(map_bytes)
        cases.append((name, directory))

    add("wrong-map-size", lambda _d: None,
        map_bytes=(root / "wrong-map-source.bin").read_bytes() + b"\0")
    add("unknown-field", lambda d: d.update(unrecognized_option=True))
    add("changed-timeline", lambda d: d["timeline"][0].update(x=d["timeline"][0]["x"] + 1))
    add("changed-graphics", lambda d: d["resources"].update(sprites="G0.BIC"))
    add("missing-section", lambda d: d.pop("encounter"))
    add("escaped-map-path", lambda d: d["resources"]["map"].update(path="../outside.bin"))
    add("long-id", lambda d: d.update(id="a" * 128))
    add("long-map-path", lambda d: d["resources"]["map"].update(path="a" * 1020 + ".bin"))
    add("nul-key", lambda d: d.update({"hidden\0field": 1}))
    add("nul-value", lambda d: d.update(id="bad\0identifier"))
    # The native switches cannot give authored meaning to these two guarded CS
    # words beyond the actual original dispatch table.
    directory = root / "unmodeled-map-cell"
    duplicate_original(3, directory, "invalid_unmodeled_map_cell")
    tiles = bytearray((directory / "map.bin").read_bytes())
    tiles[100] = 0xEA
    (directory / "map.bin").write_bytes(tiles)
    cases.append(("unmodeled-map-cell", directory))
    directory = root / "unmodeled-restoration"
    document = duplicate_original(3, directory, "invalid_unmodeled_restoration")
    document["checkpoint_restart"]["tile_restorations"][0]["replacement"] = 0xEB
    _rewrite(directory, document)
    cases.append(("unmodeled-restoration", directory))
    return cases


def _python_and_native_loader_checks(work: Path) -> int:
    harness = HostHarness()
    _arena, map_memory = _bind_content_api(harness)
    checks = 0
    try:
        for index in range(6):
            directory = work / f"original-{index}"
            document = duplicate_original(index, directory, f"custom_planet_{index}")
            loaded = validate_directory(directory)
            if loaded["id"] != document["id"]:
                raise AssertionError("Python validator changed the loose level identity")
            ok, error = _load(harness, directory)
            if not ok:
                raise AssertionError(f"native loader rejected original duplicate {index}: {error}")
            if (_id(harness) != document["id"] or
                    harness.lib.overkill_level_content_behavior_profile() != index):
                raise AssertionError(f"native content identity/profile differs for source {index}")
            if not harness.lib.overkill_level_content_copy_map():
                raise AssertionError("native map copy rejected loaded content")
            if _map_bytes(map_memory) != (directory / "map.bin").read_bytes():
                raise AssertionError(f"native decoded map differs for source {index}")
            checks += 1

        # A new ID owns map bytes and both policies. Current-content policy lookup
        # must not accidentally fall back to the six original numeric slots.
        owned_dir = work / "owned-content"
        document = duplicate_original(2, owned_dir, "independent_moon", music=9)
        document["checkpoint_restart"] = {"lookback_rows": 1, "tile_restorations": [
            {"tile": 76, "replacement": 91}, {"tile": 76, "replacement": 92}]}
        _rewrite(owned_dir, document)
        original_map = bytearray((owned_dir / "map.bin").read_bytes())
        original_map[0] ^= 0x5A
        original_map[13 * 40 + 7] ^= 0xA5
        (owned_dir / "map.bin").write_bytes(original_map)
        if validate_directory(owned_dir)["id"] != "independent_moon":
            raise AssertionError("Python validator rejected owned map data")
        ok, error = _load(harness, owned_dir)
        if not ok:
            raise AssertionError(f"native loader rejected owned map: {error}")
        harness.write_symbol("LevelIndex", (6).to_bytes(2, "little"))
        if harness.lib.overkill_level_content_behavior_profile() != 2:
            raise AssertionError("custom behavior profile changed with LevelIndex")
        for index in (0, 6, 0x8006):
            if harness.lib.overkill_level_music(index) != 9:
                raise AssertionError(f"owned music policy used legacy slot {index:04X}")
            restart = harness.lib.overkill_level_checkpoint_restart(index)
            if not restart:
                raise AssertionError(f"owned checkpoint policy missing at index {index:04X}")
            if (restart.contents.lookback_rows != document["checkpoint_restart"]["lookback_rows"] or
                    restart.contents.rule_count != len(document["checkpoint_restart"]["tile_restorations"])):
                raise AssertionError("owned checkpoint policy does not match level data")
        if not harness.lib.overkill_level_content_copy_map() or _map_bytes(map_memory) != bytes(original_map):
            raise AssertionError("authored map cells did not reach the native runtime copy")
        checks += 1

        # Apply the loaded semantic restart policy through the actual frame leaf,
        # including ordered duplicate rules and both excluded window boundaries.
        for offset in (25, 38, 39):
            map_memory[offset] = 76
        harness.write_symbol("MapScrollPos", (39).to_bytes(2, "little"))
        harness.lib.reset_map_before_view.argtypes = ()
        harness.lib.reset_map_before_view.restype = None
        harness.lib.reset_map_before_view()
        if (map_memory[25], map_memory[38], map_memory[39]) != (76, 91, 76):
            raise AssertionError("loaded restart rules lost first-match order/window bounds")
        if not harness.lib.overkill_level_content_copy_map() or _map_bytes(map_memory) != bytes(original_map):
            raise AssertionError("map reload did not undo runtime restart mutations")
        checks += 1

        # Reloading an already loaded ID takes a fresh immutable content snapshot.
        reloaded_map = bytearray(original_map)
        reloaded_map[101] ^= 0xFF
        (owned_dir / "map.bin").write_bytes(reloaded_map)
        ok, error = _load(harness, owned_dir)
        if not ok or not harness.lib.overkill_level_content_copy_map():
            raise AssertionError(f"native content reload failed: {error}")
        if _map_bytes(map_memory) != bytes(reloaded_map):
            raise AssertionError("reloading content did not replace its prior map snapshot")
        checks += 1

        # Every rejection is checked by both validators while the previous
        # successful content remains active and usable.
        wrong_map_source = work / "wrong-map-source.bin"
        wrong_map_source.write_bytes((owned_dir / "map.bin").read_bytes())
        invalid = _invalid_fixtures(work)
        kept_id = _id(harness)
        kept_profile = harness.lib.overkill_level_content_behavior_profile()
        kept_map = _map_bytes(map_memory)
        kept_music = harness.lib.overkill_level_music(6)
        kept_restart_pointer = ctypes.cast(
            harness.lib.overkill_level_checkpoint_restart(6), ctypes.c_void_p
        ).value
        for name, directory in invalid:
            try:
                validate_directory(directory)
            except (ValueError, OSError):
                pass
            else:
                raise AssertionError(f"Python validator accepted invalid content: {name}")
            ok, error = _load(harness, directory)
            if ok:
                raise AssertionError(f"native loader accepted invalid content: {name}")
            if not error:
                raise AssertionError(f"native loader gave no diagnostic for {name}")
            if (_id(harness) != kept_id or
                    harness.lib.overkill_level_content_behavior_profile() != kept_profile or
                    harness.lib.overkill_level_music(6) != kept_music):
                raise AssertionError(f"failed load {name} replaced active identity/policy")
            pointer = ctypes.cast(
                harness.lib.overkill_level_checkpoint_restart(6), ctypes.c_void_p
            ).value
            if pointer != kept_restart_pointer:
                raise AssertionError(f"failed load {name} replaced active restart policy")
            if (not harness.lib.overkill_level_content_copy_map() or
                    _map_bytes(map_memory) != kept_map):
                raise AssertionError(f"failed load {name} replaced active map data")
            checks += 1
    finally:
        harness.lib.overkill_level_content_unload()
        if (_id(harness) is not None or harness.lib.overkill_level_content_copy_map() or
                harness.lib.overkill_level_checkpoint_restart(2) or
                harness.lib.overkill_level_music(2) != harness.baseline[harness.offset("LevelMusicTable") + 2]):
            raise AssertionError("unload did not release current content and restore canonical policies")
        harness.check_canaries()
    return checks


def _custom_headless_case(work: Path) -> None:
    if not runtime.RUNTIME.is_file():
        raise FileNotFoundError(f"native SDL runtime is missing: {runtime.RUNTIME}")
    if not runtime.ASSETS.is_dir():
        raise FileNotFoundError(f"packaged host assets are missing: {runtime.ASSETS}")
    content = work / "headless-content"
    duplicate_original(2, content, "headless_custom_planet", music=9)
    events = runtime._chooser_events(0)
    case = work / "headless-run"
    case.mkdir()
    script = case / "input.txt"
    trace = case / "trace.csv"
    frame = case / "frame.bmp"
    saves = case / "saves"
    saves.mkdir()
    runtime._write_script(script, events)
    command = [
        str(runtime.RUNTIME), "--headless", "--sound", "off", "--milliseconds", "60000",
        "--input-script", str(script), "--trace", str(trace), "--screenshot", str(frame),
        "--assets", str(runtime.ASSETS), "--saves", str(saves), "--level", str(content),
    ]
    environment = dict(os.environ)
    environment["SDL_VIDEODRIVER"] = "dummy"
    environment["SDL_AUDIODRIVER"] = "dummy"
    result = subprocess.run(command, cwd=runtime.HOST_DIR, env=environment,
                            capture_output=True, text=True, timeout=90, check=False)
    output = result.stdout + result.stderr
    if result.returncode != 0:
        raise AssertionError(f"custom headless runtime exited {result.returncode}:\n{output[-3000:]}")
    if not trace.is_file() or not frame.is_file():
        raise AssertionError("custom headless launch did not produce trace and screenshot")
    runtime._assert_frame(frame, "custom level")
    state, _settings, services = runtime._parse_trace(trace)
    lines = trace.read_text(encoding="ascii").splitlines()
    if "content,headless_custom_planet" not in lines:
        raise AssertionError("headless trace omitted the selected custom content ID")
    if state["level"] != 2:
        raise AssertionError(f"custom compatibility profile started LevelIndex {state['level']}, expected 2")
    if state["scroll"] <= 156 or state["fuel"] == 0 or state["player_status"] == 0:
        raise AssertionError(f"custom level did not reach live gameplay: {state}")
    menu_music = runtime._generated_token("HOST_SERVICE_MENUREQUESTMUSIC")
    if not any(token == menu_music for _time, token, _scroll, _level in services):
        raise AssertionError("custom launch skipped the normal title/options music path")


def run() -> int:
    with tempfile.TemporaryDirectory(prefix="overkill-level-content-") as temporary:
        work = Path(temporary)
        # The wrong-size fixture starts from one valid map, then appends one byte.
        (work / "wrong-map-source.bin").write_bytes(bytes(13 * 288))
        checks = _python_and_native_loader_checks(work)
        _custom_headless_case(work)
    print(f"PASS loose level content: {checks} full-core API checks and one headless gameplay run")
    return checks + 1


if __name__ == "__main__":
    run()
