"""Deterministic headless end-to-end flows for the native SDL runtime.

Run ``python tests/host/runtime.py`` after the root task has built
``build/host/OVERKILL_SDL3.exe``. This suite never builds or launches the original
DOS executable. It mounts the packaged assets read-only and puts every save,
script, trace, and screenshot in a fresh temporary directory.

Coverage is limited to title/chooser/gameplay transitions, all six chooser slots,
the full pause cheat and six F4 level transitions, Esc-to-Y game-over return to
the options menu, six redefined keys and SoundOption persistence, normal Alt+X
high-score save/reload, and saved video/audio choices with one-sided CLI
overrides. Audio timing, synthesis, and backend behavior are deliberately not
asserted.
"""
from __future__ import annotations

import os
from pathlib import Path
import re
import struct
import subprocess
import tempfile

ROOT = Path(__file__).resolve().parents[2]
HOST_DIR = ROOT / "build/host"
RUNTIME = HOST_DIR / "OVERKILL_SDL3.exe"
ASSETS = HOST_DIR / "assets"
HOST_GENERATED = HOST_DIR / "HOST_GEN.H"
GAME_GENERATED = HOST_DIR / "GAME_GEN.H"

# SDL physical scancodes, which the runtime maps back to original set-1 codes.
SPACE = 44
DOWN = 81
ESC = 41
F4 = 61
F10 = 67
LALT = 226
LETTER_SCANCODES = {
    "A": 4, "B": 5, "C": 6, "D": 7, "E": 8, "F": 9, "G": 10,
    "H": 11, "I": 12, "J": 13, "K": 14, "L": 15, "M": 16,
    "N": 17, "O": 18, "P": 19, "Q": 20, "R": 21, "S": 22,
    "T": 23, "U": 24, "V": 25, "W": 26, "X": 27, "Y": 28,
    "Z": 29,
}
UNRESOLVED_SERVICE = re.compile(
    r"Unhandled Overkill platform service token|Unsupported loaded music module",
    re.IGNORECASE,
)


def _key(events: list[tuple[int, int, int]], when_ms: int, scan: int,
         hold_ms: int = 250) -> None:
    events.append((when_ms, scan, 1))
    events.append((when_ms + hold_ms, scan, 0))


def _chooser_events(slot: int) -> list[tuple[int, int, int]]:
    if not 0 <= slot < 6:
        raise ValueError("chooser slot must be from 0 through 5")
    events: list[tuple[int, int, int]] = []
    for when_ms in (12_000, 18_000, 24_000, 30_000):
        _key(events, when_ms, SPACE, 500 if when_ms != 30_000 else 1_000)
    for index in range(slot):
        _key(events, 19_500 + index * 500, DOWN)
    # The final primary press starts the selected level and remains held long
    # enough to pass the animated intro just as in the known runtime flow.
    events.extend(((32_000, SPACE, 1), (42_000, SPACE, 0)))
    return sorted(events)


def _completion_events() -> list[tuple[int, int, int]]:
    events: list[tuple[int, int, int]] = []
    for when_ms in (12_000, 18_000, 24_000, 30_000):
        _key(events, when_ms, SPACE, 500 if when_ms != 30_000 else 1_000)

    _key(events, 39_000, F10, 200)
    phrase = "REMINDMETOSMILEYOUKNOWTHEOLDFRIENDSLINE"
    if len(phrase) != 39:
        raise AssertionError("the full pause cheat phrase must contain 39 keys")
    for index, letter in enumerate(phrase):
        _key(events, 39_500 + index * 100, LETTER_SCANCODES[letter], 40)
    _key(events, 44_500, F10, 200)

    # Six F4 make/release pairs skip six complete levels. Space acknowledges the
    # win screen at the loop boundary and lets the next level advance continue.
    for index in range(6):
        _key(events, 47_000 + index * 12_000, F4, 250)
        _key(events, 51_000 + index * 12_000, SPACE, 300)
    return sorted(events)


def _key_redefinition_events() -> list[tuple[int, int, int]]:
    events: list[tuple[int, int, int]] = []
    _key(events, 12_000, SPACE)
    _key(events, 15_000, LETTER_SCANCODES["A"])
    _key(events, 15_500, LETTER_SCANCODES["K"])
    _key(events, 15_750, LETTER_SCANCODES["M"])
    _key(events, 16_000, LETTER_SCANCODES["R"])
    for index, letter in enumerate("WSADFG"):
        _key(events, 17_000 + index * 500, LETTER_SCANCODES[letter], 200)
    _key(events, 22_000, SPACE, 250)
    _key(events, 24_000, SPACE, 250)
    events.extend(((26_000, SPACE, 1), (35_000, SPACE, 0)))
    events.extend(((45_000, LALT, 1), (45_100, LETTER_SCANCODES["X"], 1),
                   (45_300, LETTER_SCANCODES["X"], 0), (45_350, LALT, 0)))
    return sorted(events)


def _write_script(path: Path, events: list[tuple[int, int, int]]) -> None:
    ordered = sorted(events)
    if any(ordered[index][0] > ordered[index + 1][0]
           for index in range(len(ordered) - 1)):
        raise AssertionError("input script events are not in time order")
    path.write_text("".join(f"{when} {scan} {pressed}\n"
                            for when, scan, pressed in ordered), encoding="ascii")


def _parse_trace(path: Path) -> tuple[dict[str, int], dict[str, int],
                                      list[tuple[int, int, int, int]]]:
    state: dict[str, int] | None = None
    settings: dict[str, int] | None = None
    services: list[tuple[int, int, int, int]] = []
    for line in path.read_text(encoding="ascii").splitlines():
        fields = line.split(",")
        if fields[0] == "state" and len(fields) == 9:
            names = ("level", "scroll", "intro_frames", "fuel", "player_x",
                     "player_y", "player_status", "lives")
            state = {name: int(value, 16) for name, value in zip(names, fields[1:])}
        elif fields[0] == "settings" and len(fields) == 5:
            names = ("video_adapter", "sound_module", "input_mode", "sound_option")
            settings = {name: int(value, 16) for name, value in zip(names, fields[1:])}
        elif fields[0] == "service" and len(fields) == 7:
            # Keep only timestamp, token, map position, and level. Audio trace
            # records are intentionally ignored by this integration suite.
            services.append((int(fields[1]), int(fields[2], 16),
                             int(fields[5], 16), int(fields[6], 16)))
    if state is None:
        raise AssertionError(f"runtime trace has no final game state: {path}")
    if settings is None:
        raise AssertionError(f"runtime trace has no saved-settings state: {path}")
    return state, settings, services


def _assert_frame(path: Path, label: str) -> None:
    image = path.read_bytes()
    if len(image) < 54 or image[:2] != b"BM":
        raise AssertionError(f"{label}: runtime did not produce a BMP frame")
    pixel_offset = struct.unpack_from("<I", image, 10)[0]
    width, height = struct.unpack_from("<ii", image, 18)
    bits_per_pixel = struct.unpack_from("<H", image, 28)[0]
    if width <= 0 or height <= 0 or bits_per_pixel not in (24, 32):
        raise AssertionError(f"{label}: unexpected BMP format {width}x{height}x{bits_per_pixel}")
    pixel_bytes = bits_per_pixel // 8
    row_stride = (width * pixel_bytes + 3) & ~3
    required_bytes = row_stride * height
    if len(image) < pixel_offset + required_bytes:
        raise AssertionError(f"{label}: screenshot pixel buffer is truncated")
    colors: set[tuple[int, int, int]] = set()
    for y in range(height):
        row_start = pixel_offset + y * row_stride
        for x in range(width):
            pixel_start = row_start + x * pixel_bytes
            # BMP stores BGR(A); compare only visible RGB, ignoring alpha and
            # the per-row alignment bytes after the final pixel.
            colors.add((image[pixel_start + 2], image[pixel_start + 1],
                        image[pixel_start]))
            if len(colors) >= 2:
                break
        if len(colors) >= 2:
            break
    if len(colors) < 2:
        raise AssertionError(f"{label}: screenshot frame contains no visible variation")


def _generated_token(macro_name: str) -> int:
    if not HOST_GENERATED.is_file():
        raise FileNotFoundError(f"generated host token header is missing: {HOST_GENERATED}")
    generated = HOST_GENERATED.read_text(encoding="ascii")
    pattern = re.compile(
        rf"^#define {re.escape(macro_name)} \(\(word\)0x([0-9A-Fa-f]+)\)$",
        re.MULTILINE,
    )
    match = pattern.search(generated)
    if match is None:
        raise AssertionError(f"generated host header has no {macro_name} token")
    return int(match.group(1), 16)


def _file_service_tokens() -> tuple[int, int]:
    return (_generated_token("HOST_TOKEN_LOADFILETOBUFFER"),
            _generated_token("HOST_TOKEN_SAVEBUFFERTOFILE"))


def _generated_game_constant(macro_name: str) -> int:
    if not GAME_GENERATED.is_file():
        raise FileNotFoundError(f"generated game header is missing: {GAME_GENERATED}")
    generated = GAME_GENERATED.read_text(encoding="ascii")
    pattern = re.compile(
        rf"^#define {re.escape(macro_name)} \(0x([0-9A-Fa-f]+)\)$",
        re.MULTILINE,
    )
    match = pattern.search(generated)
    if match is None:
        raise AssertionError(f"generated game header has no {macro_name} constant")
    return int(match.group(1), 16)


def _generated_ds_offset(symbol: str) -> int:
    if not GAME_GENERATED.is_file():
        raise FileNotFoundError(f"generated game header is missing: {GAME_GENERATED}")
    generated = GAME_GENERATED.read_text(encoding="ascii")
    pattern = re.compile(
        rf"^#define {re.escape(symbol)} \(\(byte \*\)overkill_ds_address\(0x([0-9A-Fa-f]+)\)\)$",
        re.MULTILINE,
    )
    match = pattern.search(generated)
    if match is None:
        raise AssertionError(f"generated game header has no DS address for {symbol}")
    return int(match.group(1), 16)


def _oracle_word_initializer(symbol: str) -> int:
    oracle_data = (ROOT / "src/DATA.ASM").read_text(encoding="latin-1")
    pattern = re.compile(
        rf"^{re.escape(symbol)}\s+dw\s+([0-9A-Fa-f]+)h\b",
        re.MULTILINE,
    )
    match = pattern.search(oracle_data)
    if match is None:
        raise AssertionError(f"oracle DATA.ASM has no word initializer for {symbol}")
    return int(match.group(1), 16)


def _decode_hiscore_settings(path: Path) -> dict[str, int | tuple[int, ...]]:
    encoded_file = path.read_bytes()
    block_bytes = _generated_game_constant("HISCORE_BLOCK_BYTES")
    if len(encoded_file) != block_bytes + 2:
        raise AssertionError(
            f"{path.name}: expected {block_bytes + 2} bytes, got {len(encoded_file)}"
        )
    encoded = encoded_file[:block_bytes]
    checksum = struct.unpack_from("<H", encoded_file, block_bytes)[0]
    if checksum != (sum(encoded) & 0xFFFF):
        raise AssertionError(f"{path.name}: encoded high-score checksum is invalid")
    decoded = bytes(
        value ^ 0xAA ^ ((block_bytes - index) & 0xFF)
        for index, value in enumerate(encoded)
    )

    settings_base = (_generated_ds_offset("SavedSettings") -
                     _generated_ds_offset("HiscoreBlock"))
    joy_words = _generated_game_constant("JOY_THRESHOLD_WORDS")
    key_count = _generated_game_constant("KEY_BIT_SCANCODE_COUNT")
    sound_option_offset = settings_base
    input_mode_offset = sound_option_offset + 2 + joy_words * 2
    key_bindings_offset = input_mode_offset + 2
    video_offset = key_bindings_offset + key_count
    sound_module_offset = video_offset + 2
    saved_settings_end = sound_module_offset + 1 + 2 + 2
    if settings_base < 0 or saved_settings_end > block_bytes:
        raise AssertionError("generated settings layout extends outside HISCORE_BLOCK")

    def read_word(offset: int) -> int:
        return struct.unpack_from("<H", decoded, offset)[0]

    bindings = tuple(decoded[key_bindings_offset:key_bindings_offset + key_count])
    expected_binding_slots = (
        ("YMINUS", "W"), ("YPLUS", "S"), ("XMINUS", "A"),
        ("XPLUS", "D"), ("PRIMARY", "F"), ("SECONDARY", "G"),
    )
    for slot_name, key_name in expected_binding_slots:
        slot = _generated_game_constant(f"KEY_SLOT_{slot_name}")
        expected_scan = _generated_game_constant(f"SCAN_{key_name}")
        if bindings[slot] != expected_scan:
            raise AssertionError(
                f"saved {slot_name} binding is {bindings[slot]:02X}, "
                f"expected {key_name} scan code {expected_scan:02X}"
            )

    return {
        "sound_option": read_word(sound_option_offset),
        "input_mode": read_word(input_mode_offset),
        "bindings": bindings,
        "video_adapter": read_word(video_offset),
        "sound_module": decoded[sound_module_offset],
    }


def _run_case(work: Path, name: str, events: list[tuple[int, int, int]],
              milliseconds: int, save_dir: Path,
              launcher_args: tuple[str, ...] = ("--sound", "off")) -> tuple[
                  dict[str, int], dict[str, int],
                  list[tuple[int, int, int, int]], Path, str]:
    case_dir = work / name
    case_dir.mkdir()
    input_path = case_dir / "input.txt"
    trace_path = case_dir / "trace.csv"
    frame_path = case_dir / "frame.bmp"
    save_dir.mkdir(parents=True, exist_ok=True)
    _write_script(input_path, events)
    command = [
        str(RUNTIME), "--headless", *launcher_args, "--milliseconds",
        str(milliseconds), "--input-script", str(input_path), "--trace",
        str(trace_path), "--screenshot", str(frame_path), "--assets",
        str(ASSETS), "--saves", str(save_dir),
    ]
    environment = dict(os.environ)
    environment["SDL_VIDEODRIVER"] = "dummy"
    environment["SDL_AUDIODRIVER"] = "dummy"
    try:
        result = subprocess.run(command, cwd=HOST_DIR, env=environment,
                                capture_output=True, text=True, timeout=90,
                                check=False)
    except subprocess.TimeoutExpired as error:
        raise AssertionError(f"{name}: runtime exceeded its 90-second bound") from error
    combined_output = result.stdout + result.stderr
    if result.returncode != 0:
        raise AssertionError(
            f"{name}: runtime exited {result.returncode}\n{combined_output[-4000:]}"
        )
    if UNRESOLVED_SERVICE.search(combined_output):
        raise AssertionError(f"{name}: unresolved runtime service\n{combined_output[-4000:]}")
    if not trace_path.is_file() or trace_path.stat().st_size == 0:
        raise AssertionError(f"{name}: runtime did not emit its service/state trace")
    _assert_frame(frame_path, name)
    state, settings, services = _parse_trace(trace_path)
    return state, settings, services, frame_path, combined_output


def _assert_gameplay_state(state: dict[str, int], expected_level: int, label: str) -> None:
    if state["level"] != expected_level:
        raise AssertionError(
            f"{label}: final LevelIndex={state['level']}, expected {expected_level}"
        )
    if state["scroll"] == 0 or state["intro_frames"] == 0:
        raise AssertionError(f"{label}: level intro/gameplay state did not advance")
    if state["fuel"] == 0 or state["player_status"] == 0:
        raise AssertionError(f"{label}: final state has no live player")


def _assert_settings(settings: dict[str, int], video: int, sound: int,
                     label: str) -> None:
    actual = (settings["video_adapter"], settings["sound_module"])
    expected = (video, sound)
    if actual != expected:
        raise AssertionError(
            f"{label}: final video/audio choices are {actual}, expected {expected}"
        )


def _run_escape_to_options_case(work: Path) -> None:
    events = _chooser_events(0)
    _key(events, 46_000, ESC)
    _key(events, 48_000, LETTER_SCANCODES["Y"], 500)
    _state, _settings, services, _frame, _output = _run_case(
        work, "escape-y-gameover-options", events, 75_000,
        work / "saves" / "escape-y-gameover-options",
    )

    quit_prompt_token = _generated_token("HOST_SERVICE_SESSIONDRAWQUITPROMPT")
    menu_music_token = _generated_token("HOST_SERVICE_MENUREQUESTMUSIC")
    prompt_times = [timestamp for timestamp, token, _scroll, _level in services
                    if token == quit_prompt_token]
    if not prompt_times:
        raise AssertionError("gameplay Escape did not call SessionDrawQuitPrompt")
    prompt_time = min(prompt_times)
    menu_return_times = [
        timestamp for timestamp, token, _scroll, _level in services
        if token == menu_music_token and timestamp > prompt_time
        and timestamp >= 48_000_000_000
    ]
    if not menu_return_times:
        raise AssertionError(
            "Y confirmation did not return through MenuRequestMusic after the quit prompt"
        )


def _run_key_redefinition_case(work: Path) -> None:
    load_file_token, save_file_token = _file_service_tokens()
    save_dir = work / "saves" / "key-redefinition"
    saved_state, saved_settings, save_services, _frame, _output = _run_case(
        work, "key-redefinition-save", _key_redefinition_events(), 47_000,
        save_dir,
    )
    _assert_gameplay_state(saved_state, 1, "key-redefinition gameplay exit")
    if not any(token == save_file_token for _time, token, _scroll, _level in save_services):
        raise AssertionError("key-redefinition Alt+X did not call SaveBufferToFile")

    save_file = save_dir / "hiscore.dat"
    expected_settings = _decode_hiscore_settings(save_file)
    expected_sound_option = (_oracle_word_initializer("SoundOption") + 1) & 3
    expected_input_mode = _generated_game_constant("INPUT_MODE_KEYS_A")
    if expected_settings["sound_option"] != expected_sound_option:
        raise AssertionError(
            "M did not advance SoundOption from its source default: "
            f"saved {expected_settings['sound_option']}, expected {expected_sound_option}"
        )
    if expected_settings["input_mode"] != expected_input_mode:
        raise AssertionError(
            "K did not leave keyboard table A selected: "
            f"saved mode {expected_settings['input_mode']}, expected {expected_input_mode}"
        )
    for key in ("sound_option", "input_mode", "video_adapter", "sound_module"):
        if saved_settings[key] != expected_settings[key]:
            raise AssertionError(
                f"Alt+X trace {key}={saved_settings[key]} disagrees with saved file "
                f"value {expected_settings[key]}"
            )

    original_file = save_file.read_bytes()
    reload_events: list[tuple[int, int, int]] = []
    _key(reload_events, 12_000, SPACE)
    reload_events.extend(((15_000, LALT, 1), (15_100, LETTER_SCANCODES["X"], 1),
                          (15_300, LETTER_SCANCODES["X"], 0), (15_350, LALT, 0)))
    _state, reload_settings, reload_services, _frame, _output = _run_case(
        work, "key-redefinition-reload", reload_events, 16_000, save_dir,
        launcher_args=(),
    )
    if not any(token == load_file_token for _time, token, _scroll, _level in reload_services):
        raise AssertionError("key-redefinition restart did not call LoadFileToBuffer")
    if not any(token == save_file_token for _time, token, _scroll, _level in reload_services):
        raise AssertionError("key-redefinition reload exit did not call SaveBufferToFile")
    if reload_settings != saved_settings:
        raise AssertionError(
            f"reloaded options differ from saved options: {reload_settings} != {saved_settings}"
        )
    if save_file.read_bytes() != original_file:
        raise AssertionError(
            "reloaded Alt+X round-trip changed HISCORE.DAT; saved key bindings "
            "or settings did not survive loading"
        )


def run() -> int:
    if not RUNTIME.is_file():
        raise FileNotFoundError(
            f"built native SDL runtime is missing: {RUNTIME}; root owns this build"
        )
    if RUNTIME.name != "OVERKILL_SDL3.exe":
        raise AssertionError("runtime test must use the native SDL executable")
    if not ASSETS.is_dir():
        raise FileNotFoundError(f"packaged game assets are missing: {ASSETS}")
    load_file_token, save_file_token = _file_service_tokens()

    case_count = 0
    with tempfile.TemporaryDirectory(prefix="overkill-runtime-") as temporary:
        work = Path(temporary)

        # The source defaults to ChooseSlot 0. With no saved settings, slot n
        # starts gameplay at LevelIndex (n + 1) modulo the six-level cycle.
        expected_levels = []
        for slot in range(6):
            state, _settings, _services, _frame, _output = _run_case(
                work, f"chooser-{slot}", _chooser_events(slot), 50_000,
                work / "saves" / f"chooser-{slot}",
            )
            expected_level = (slot + 1) % 6
            _assert_gameplay_state(state, expected_level, f"chooser slot {slot}")
            expected_levels.append(state["level"])
            case_count += 1
        if set(expected_levels) != set(range(6)):
            raise AssertionError(f"chooser did not reach each level: {expected_levels}")

        completion_state, _settings, completion_services, _frame, _output = _run_case(
            work, "pause-cheat-six-levels", _completion_events(), 125_000,
            work / "saves" / "completion",
        )
        reached_after_cheat = {
            level for timestamp, _token, _scroll, level in completion_services
            if timestamp >= 44_000_000_000
        }
        if reached_after_cheat != set(range(6)):
            raise AssertionError(
                "full pause cheat/F4 flow did not trace all six levels after resume: "
                f"{sorted(reached_after_cheat)}"
            )
        if completion_state["level"] != 1:
            raise AssertionError(
                "six F4 completions should wrap the initial gameplay level back to 1; "
                f"got {completion_state['level']}"
            )
        case_count += 1

        _run_escape_to_options_case(work)
        case_count += 1

        _run_key_redefinition_case(work)
        case_count += 2

        # Save a nondefault chooser slot through normal Alt+X shutdown, then use
        # the same save root on a fresh process. The reload must select that saved
        # slot, which distinguishes valid settings restoration from the defaults.
        save_dir = work / "saves" / "persistent"
        save_events = _chooser_events(3)
        save_events.extend(((50_000, LALT, 1), (50_100, 27, 1)))
        saved_state, saved_settings, save_services, _frame, _output = _run_case(
            work, "alt-x-save", save_events, 52_000, save_dir,
            launcher_args=("--video", "cga", "--sound", "adlib"),
        )
        if saved_state["level"] != 4:
            raise AssertionError(f"Alt+X did not occur after slot 3 gameplay: {saved_state}")
        _assert_settings(saved_settings, video=0, sound=0x61, label="Alt+X save")
        if not any(token == save_file_token for _time, token, _scroll, _level in save_services):
            raise AssertionError("normal Alt+X shutdown did not call SaveBufferToFile")
        save_file = save_dir / "hiscore.dat"
        if not save_file.is_file() or save_file.stat().st_size != 174:
            actual = save_file.stat().st_size if save_file.exists() else "missing"
            raise AssertionError(f"Alt+X save file is {actual} bytes, expected 174")
        case_count += 1

        reload_state, reload_settings, reload_services, _frame, _output = _run_case(
            work, "saved-settings-reload", _chooser_events(0), 50_000, save_dir,
            launcher_args=(),
        )
        _assert_gameplay_state(reload_state, 4, "saved settings reload")
        _assert_settings(reload_settings, video=0, sound=0x61,
                         label="saved settings reload")
        if not any(token == load_file_token for _time, token, _scroll, _level in reload_services):
            raise AssertionError("second startup did not call LoadFileToBuffer")
        if save_file.stat().st_size != 174:
            raise AssertionError("startup reload altered the 174-byte high-score file")
        case_count += 1

        # Each partial override starts from the saved CGA/AdLib settings and
        # preserves whichever choice its command line leaves unspecified.
        video_state, video_settings, _services, _frame, _output = _run_case(
            work, "video-only-override", _chooser_events(0), 50_000, save_dir,
            launcher_args=("--video", "tandy"),
        )
        _assert_gameplay_state(video_state, 4, "video-only override")
        _assert_settings(video_settings, video=2, sound=0x61,
                         label="video-only override")
        case_count += 1

        sound_state, sound_settings, _services, _frame, _output = _run_case(
            work, "sound-only-override", _chooser_events(0), 50_000, save_dir,
            launcher_args=("--sound", "off"),
        )
        _assert_gameplay_state(sound_state, 4, "sound-only override")
        _assert_settings(sound_settings, video=0, sound=0,
                         label="sound-only override")
        case_count += 1

    print("PASS SDL runtime: six chooser slots reached levels "
          f"{expected_levels}; pause cheat cycled levels 0..5; Esc/Y returned "
          "through the quit prompt to the options menu; key bindings and "
          "SoundOption survived Alt+X reload; Alt+X saved and "
          "reloaded a 174-byte HISCORE.DAT; saved video/audio choices survived "
          "restart and one-sided overrides. "
          f"{case_count} bounded headless runs; "
          "audio timing/synthesis intentionally excluded.")
    return case_count


if __name__ == "__main__":
    run()
