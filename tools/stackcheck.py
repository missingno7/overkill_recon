#!/usr/bin/env python3
"""Measure bounded synchronous and INT 08h stack use in the DOS hybrid.

The tool consumes the existing exact-oracle/hybrid EXEs and verified sound-module
resources. It does not build either EXE, execute the game session loop, or chain the
BIOS timer handler. Synchronous suite calls and interrupt-handler instructions are
observed at every opcode, so reserved stack frames count even when never written.

Run from the repository root:
    python tools/stackcheck.py                 # all bounded difftest suites + IRQ probes
    python tools/stackcheck.py session rendering  # named suites; use suite names from tests/
    python tools/stackcheck.py --scale 2       # scale synchronous suites

The combined figure is a bounded test model: highest direct-call suite high-water
from StackTop (including the test harness reserve) plus the largest observed INT 08h
increment. It is not a universal gameplay maximum; see the printed limitations.
"""

from __future__ import annotations

import argparse
import hashlib
import importlib
import json
import random
import struct
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, str(ROOT / "tests"))

from difftest import FAR_LABELS, MAP_SEGMENT, Pair, run_suites  # noqa: E402
from emu import LOAD, Machine, REG  # noqa: E402
from resources import driver  # noqa: E402
from unicorn import UC_HOOK_CODE, UcError  # noqa: E402


STACK_BUDGET = 512
MUSIC_TITLE = 2
SHIM_SEG = 0xF000
SHIM_LINEAR = SHIM_SEG << 4
SHIM_RET_FAR = 5
SHIM_RET_IRET = 7
EMU_LIMIT = 5_000_000


class StackProbe:
    """Record actual SS:SP minima during direct suite calls."""

    def __init__(self, side):
        self.side = side
        self.machine = side.m
        self.enabled = False
        self.context = ""
        self.entry_sp = 0
        self.low_sp = 0x10000
        self.opcodes = 0
        self.maximum = None
        self.hook = self.machine.u.hook_add(UC_HOOK_CODE, self._opcode)

    def begin(self, context: str, entry_sp: int):
        self.context = context
        self.entry_sp = entry_sp
        self.low_sp = 0x10000
        self.opcodes = 0
        self.enabled = True

    def finish(self):
        self.enabled = False
        if self.low_sp == 0x10000:
            return
        sample = {
            "context": self.context,
            "entry_sp": self.entry_sp,
            "min_sp": self.low_sp,
            "body_depth": max(0, self.entry_sp - self.low_sp),
            "from_top": self.machine.stack_top - self.low_sp,
            "caller_reserve": self.machine.stack_top - self.entry_sp,
            "stack_area": self.machine.offset("StackArea"),
            "opcodes": self.opcodes,
        }
        if self.maximum is None or sample["from_top"] > self.maximum["from_top"]:
            self.maximum = sample

    def _opcode(self, u, _address, _size, _user):
        if self.enabled:
            self.opcodes += 1
            if u.reg_read(REG["SS"]) == self.machine.data_frame:
                sp = u.reg_read(REG["SP"])
                if sp < self.low_sp:
                    self.low_sp = sp


def install_probe(side):
    probe = StackProbe(side)
    original_run = side.run

    def observed_run(case, sp=None, fresh=True, keep=False):
        effective_sp = side.m.stack_top - 0x40 if sp is None else sp
        # A suite may temporarily replace Machine.call with a bounded DOS/BIOS runner.
        # Observe the outer Side.run so those calls retain the opcode/SP measurement.
        probe.begin(f"{case.label} {case.name}".strip(), effective_sp - 2)
        try:
            return original_run(case, sp=sp, fresh=fresh, keep=keep)
        finally:
            probe.finish()

    side.run = observed_run
    return probe


class OpcodeStackObserver:
    """Record actual SS:SP at every opcode in one far call or interrupt."""

    def __init__(self, machine: Machine):
        self.machine = machine
        self.enabled = False
        self.min_sp = 0x10000
        self.opcodes = 0
        self.stop_ip = 0
        self.hook = machine.u.hook_add(UC_HOOK_CODE, self._on_code)

    def begin(self, stop_ip: int) -> None:
        self.min_sp = 0x10000
        self.opcodes = 0
        self.stop_ip = stop_ip
        self.enabled = True

    def end(self) -> None:
        self.enabled = False

    def _on_code(self, u, address, _size, _user):
        if not self.enabled:
            return
        self.opcodes += 1
        if u.reg_read(REG["SS"]) == self.machine.data_frame:
            sp = u.reg_read(REG["SP"])
            if sp < self.min_sp:
                self.min_sp = sp
        if address == SHIM_LINEAR + self.stop_ip:
            u.emu_stop()


def invoke(machine: Machine, observer: OpcodeStackObserver, target_cs: int, target_ip: int,
           *, caller_depth: int, interrupt_frame: bool = False,
           extra_regs: dict[str, int] | None = None, limit: int = EMU_LIMIT):
    """Enter a far target from F000h; optionally return through the target's IRET."""
    stop_ip = SHIM_RET_IRET if interrupt_frame else SHIM_RET_FAR
    if interrupt_frame:
        shim = bytes((0x9C, 0xFA, 0x9A)) + struct.pack("<HH", target_ip, target_cs)
        assert len(shim) == SHIM_RET_IRET
    else:
        shim = bytes((0x9A,)) + struct.pack("<HH", target_ip, target_cs)
        assert len(shim) == SHIM_RET_FAR
    shim += b"\xEB\xFE"
    machine.u.mem_write(SHIM_LINEAR, shim)

    start_sp = machine.stack_top - caller_depth
    if start_sp < machine.offset("StackArea") + 32:
        raise ValueError("caller depth leaves less than 32 bytes before StackArea")
    values = {"AX": 0, "BX": 0, "CX": 0, "DX": 0, "SI": 0, "DI": 0,
              "BP": 0, "ES": machine.data_frame}
    values.update(extra_regs or {})
    for register, value in values.items():
        machine.u.reg_write(REG[register], value & 0xFFFF)
    machine.u.reg_write(REG["DS"], machine.data_frame)
    machine.u.reg_write(REG["SS"], machine.data_frame)
    machine.u.reg_write(REG["CS"], SHIM_SEG)
    machine.u.reg_write(REG["IP"], 0)
    machine.u.reg_write(REG["SP"], start_sp)
    machine.u.reg_write(REG["FLAGS"], 0x0202)
    machine.fault = None

    observer.begin(stop_ip)
    try:
        machine.u.emu_start(SHIM_LINEAR, SHIM_LINEAR + stop_ip, count=limit)
    except UcError as error:
        raise RuntimeError(
            f"emulator fault at {machine.u.reg_read(REG['CS']):04X}:"
            f"{machine.u.reg_read(REG['IP']):04X}: {error}"
        ) from error
    finally:
        observer.end()

    cs = machine.u.reg_read(REG["CS"])
    ip = machine.u.reg_read(REG["IP"])
    if machine.fault:
        raise RuntimeError(f"unexpected interrupt during bounded call: {machine.fault}")
    if (cs, ip) != (SHIM_SEG, stop_ip):
        raise RuntimeError(
            f"bounded call did not return to shim {SHIM_SEG:04X}:{stop_ip:04X}; "
            f"stopped at {cs:04X}:{ip:04X} after {observer.opcodes} opcodes"
        )
    if observer.min_sp == 0x10000:
        raise RuntimeError("no stack pointer samples were observed")
    stack_area = machine.offset("StackArea")
    if observer.min_sp < stack_area:
        raise RuntimeError(
            f"stack crossed StackArea: minimum SP={observer.min_sp:04X}, "
            f"StackArea={stack_area:04X}"
        )
    return {
        "start_sp": start_sp,
        "min_sp": observer.min_sp,
        "increment": start_sp - observer.min_sp,
        "total_from_top": machine.stack_top - observer.min_sp,
        "remaining": observer.min_sp - stack_area,
        "opcodes": observer.opcodes,
        "ax": machine.u.reg_read(REG["AX"]),
    }


class Symbols:
    def __init__(self, machine: Machine):
        self.machine = machine

    def sym(self, name: str) -> int:
        return self.machine.offset(name)


def sound_sfx_scenarios(machine: Machine):
    """Reuse persistent bounded SfxTimerTick sequences from tests/sound.py."""
    suite = importlib.import_module("sound")
    generated = suite.cases(random.Random(0x08E3), 1, Symbols(machine))
    scenarios = []
    try:
        for item in generated:
            steps = item if isinstance(item, list) else [item]
            if not steps or not all(step.label == "SfxTimerTick" for step in steps):
                break
            scenarios.append(steps)
    finally:
        generated.close()
    if not scenarios:
        raise RuntimeError("tests/sound.py produced no SfxTimerTick sequences")
    return scenarios


def apply_case_writes(machine: Machine, writes):
    for location, data in writes:
        if location >> 16:
            far_index = (location >> 16) - 1
            label = FAR_LABELS[far_index]
            offset = location & 0xFFFF
            address = MAP_SEGMENT * 16 if label == "SlotBuffer" else machine.linear(label)
            machine.u.mem_write(address + offset, bytes(data))
        else:
            machine.write(location, data)


def module_image(machine: Machine, decoded: bytes):
    slot_seg, slot_off = machine.symbols["SOUNDMODULESLOT"]
    buffer_seg, buffer_off = machine.symbols["SLOTBUFFER"]
    if slot_off != 0 or buffer_seg != slot_seg:
        raise RuntimeError("unexpected sound-module slot layout")
    if len(decoded) > buffer_off:
        raise RuntimeError(f"decoded module ({len(decoded)} bytes) overlaps SlotBuffer")
    slot_linear = machine.linear("SOUNDMODULESLOT")
    empty = bytes(machine.u.mem_read(slot_linear, buffer_off))
    overlay = bytearray(empty)
    overlay[:len(decoded)] = decoded
    return LOAD + slot_seg, slot_linear, empty, bytes(overlay)


def max_sfx_irq(machine: Machine, observer: OpcodeStackObserver, scenarios,
                pristine_state: bytes, empty_slot: bytes, *, loaded_image: bytes | None,
                force_loaded: bool):
    slot_linear = machine.linear("SOUNDMODULESLOT")
    best = None
    total_ticks = 0
    for scenario_index, steps in enumerate(scenarios, 1):
        machine.set_state(pristine_state)
        machine.u.mem_write(slot_linear, loaded_image if force_loaded else empty_slot)
        machine.write(machine.offset("SoundModuleLoaded"), bytes((int(force_loaded),)))
        if force_loaded:
            # Successful LoadSoundModule requests title music after module init.
            machine.u.mem_write(slot_linear + 8, struct.pack("<H", MUSIC_TITLE))
        for step_index, step in enumerate(steps, 1):
            apply_case_writes(machine, step.writes)
            # Phase zero reaches the frame-timer path and avoids the BIOS chain.
            machine.write(machine.offset("TimerTickPhase"), b"\x00")
            try:
                measured = invoke(
                    machine, observer,
                    target_cs=LOAD + machine.symbols["INTERRUPT08HANDLER"][0],
                    target_ip=machine.symbols["INTERRUPT08HANDLER"][1],
                    caller_depth=0,
                    interrupt_frame=True,
                )
            except Exception as error:
                raise RuntimeError(
                    f"INT08 failed in SFX scenario {scenario_index} "
                    f"step {step_index} ({step.name!r}): {error}"
                ) from error
            total_ticks += 1
            label = step.name or f"scenario {scenario_index} step {step_index}"
            if best is None or measured["increment"] > best["increment"]:
                best = dict(measured, scenario=label,
                            scenario_index=scenario_index, step_index=step_index)
    return best, total_ticks


def measure_irq_variant(exe: Path, module_name: str | None, expected_hashes: dict[str, str]):
    machine = Machine(exe)
    machine.start_runtime(adapter=2)
    machine.poke("LevelMapSegment", MAP_SEGMENT)
    machine.u.mem_write(MAP_SEGMENT * 16, bytes(0x10000))
    pristine_state = machine.state()
    observer = OpcodeStackObserver(machine)
    scenarios = sound_sfx_scenarios(machine)
    _, _, empty_slot, _ = module_image(machine, b"")
    init = None
    description = "no optional module; C SfxTimerTick + frame timer"

    if module_name is not None:
        decoded, metadata = driver(module_name)
        digest = hashlib.sha256(decoded).hexdigest()
        if digest != expected_hashes[module_name]:
            raise RuntimeError(
                f"{module_name} decoded hash {digest} != verified {expected_hashes[module_name]}"
            )
        if metadata["decoded_sha256"] != digest:
            raise RuntimeError(f"{module_name} resource decoder metadata hash disagrees")
        driver_cs, slot_linear, empty_slot, loaded_image = module_image(machine, decoded)
        machine.set_state(pristine_state)
        machine.u.mem_write(slot_linear, loaded_image)
        init = invoke(machine, observer, driver_cs, 4, caller_depth=0,
                      extra_regs={"ES": driver_cs})
        if (init["ax"] & 0xFF) != 0:
            raise RuntimeError(
                f"{module_name} detector reported hardware with emulator zero-input ports"
            )
        loaded_image = bytes(machine.u.mem_read(slot_linear, len(loaded_image)))
        description = f"{module_name} module; zero-port init result 0; forced loaded for active tick"
    else:
        loaded_image = None

    result, ticks = max_sfx_irq(
        machine, observer, scenarios, pristine_state, empty_slot,
        loaded_image=loaded_image, force_loaded=module_name is not None,
    )
    machine.u.hook_del(observer.hook)
    return description, result, ticks, init, len(scenarios)


def run_synchronous(suites: list[str] | None, scale: int):
    pair = Pair()
    probes = {"oracle": install_probe(pair.a), "hybrid": install_probe(pair.b)}
    try:
        total = run_suites(suites, scale=scale, pair=pair, quiet=True)
    finally:
        for probe in probes.values():
            probe.machine.u.hook_del(probe.hook)
    return total, probes


def load_verified_module_hashes(path: Path):
    data = json.loads(path.read_text(encoding="utf-8"))
    if data.get("status") != "PASS":
        raise RuntimeError(f"sound-driver verification is not PASS: {path}")
    return {item["name"]: item["sha256"] for item in data["modules"]}


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("suites", nargs="*", help="difftest suite names; default is all suites")
    parser.add_argument("--scale", type=int, default=1,
                        help="scale factor for synchronous difftest suites (default: 1)")
    args = parser.parse_args()
    if args.scale < 1:
        parser.error("--scale must be at least 1")

    exe = ROOT / "build" / "hybrid" / "OVERKILL.EXE"
    oracle = ROOT / "build" / "oracle-sym" / "OVERKILL.EXE"
    manifest_path = ROOT / "build" / "driver-verification.json"
    if not exe.is_file() or not exe.with_suffix(".MAP").is_file():
        raise SystemExit("hybrid EXE and MAP must already exist; stackcheck does not build")
    if not oracle.is_file() or not oracle.with_suffix(".MAP").is_file():
        raise SystemExit("oracle-sym EXE and MAP must already exist; stackcheck does not build")
    if not manifest_path.is_file():
        raise SystemExit("build/driver-verification.json must already exist; stackcheck does not build")

    suites = args.suites or None
    total, probes = run_synchronous(suites, args.scale)
    stack_bytes = probes["hybrid"].machine.stack_top - probes["hybrid"].machine.offset("StackArea")
    if stack_bytes != STACK_BUDGET:
        raise RuntimeError(f"linked hybrid stack is {stack_bytes} B, expected {STACK_BUDGET} B")

    print(f"Target: existing {exe.relative_to(ROOT)}; no build performed")
    print(f"Synchronous difftest: {total} bounded calls across "
          f"{len(suites) if suites else len(__import__('difftest').suite_names())} suites, scale {args.scale}")
    for side_name, probe in probes.items():
        sample = probe.maximum
        if sample is None:
            print(f"{side_name}: no calls observed")
            continue
        print(
            f"{side_name}: body={sample['body_depth']} B; test caller reserve="
            f"{sample['caller_reserve']} B (includes near return); observed total="
            f"{sample['from_top']} B from StackTop; remaining="
            f"{sample['min_sp'] - sample['stack_area']} B; {sample['context']!r}; "
            f"{sample['opcodes']} opcodes"
        )

    expected_hashes = load_verified_module_hashes(manifest_path)
    if not {"adlib", "roland"} <= set(expected_hashes):
        raise RuntimeError("driver verification manifest lacks AdLib or Roland hashes")
    irq_results = []
    for module_name in (None, "adlib", "roland"):
        description, result, ticks, init, scenario_count = measure_irq_variant(
            exe, module_name, expected_hashes
        )
        irq_results.append((description, result))
        init_text = (f"; direct far-init increment={init['increment']} B, "
                     f"observed init total={init['total_from_top']} B from StackTop"
                     if init is not None else "")
        print(
            f"IRQ {description}: {ticks} INT08 calls from {scenario_count} persistent "
            f"SFX sequences; handler increment={result['increment']} B (includes "
            f"6-B frame); min SP={result['min_sp']:04X}; remaining="
            f"{result['remaining']} B; {result['scenario']!r}; "
            f"{result['opcodes']} opcodes{init_text}"
        )

    hybrid_sample = probes["hybrid"].maximum
    if hybrid_sample is None:
        raise RuntimeError("hybrid synchronous suites did not observe a call")
    max_irq = max(result["increment"] for _, result in irq_results)
    combined = hybrid_sample["from_top"] + max_irq
    remaining = stack_bytes - combined
    print(
        f"Bounded combined model: hybrid sync high-water {hybrid_sample['from_top']} B "
        f"(body {hybrid_sample['body_depth']} + test caller reserve "
        f"{hybrid_sample['caller_reserve']}) + max IRQ increment {max_irq} B = "
        f"{combined} / {stack_bytes} B; remaining {remaining} B"
    )
    print("Limits: INT08 phase is held at 0, so the BIOS chained path is excluded; "
          "manual play and arbitrary interrupt timing are not measured. Sound modules "
          "are initialized with zero-input emulator ports, then forced loaded only to "
          "exercise their actual timer tick path. This is bounded evidence, not a "
          "universal whole-session maximum.")

    if combined > stack_bytes:
        print(f"FAIL: bounded combined model exceeds the {stack_bytes}-byte DOS stack")
        return 1
    print(f"PASS: bounded combined model fits the {stack_bytes}-byte DOS stack")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
