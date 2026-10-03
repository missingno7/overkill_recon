"""Invader slots and independent march clocks through production C and bounded ASM."""
from pathlib import Path
import argparse
import copy
import ctypes
import importlib.util
import os
import struct
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from level_format import load, original_paths, validate
from level_invaders import (original_invader_slots, original_marching_formation,
                            generate_invader_header)
from level_paths import encode_point
from world import K


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(spec)
    sys.modules[name] = result
    spec.loader.exec_module(result)
    return result


def compile_alternate(out, documents, machine):
    generate_invader_header(out, documents, machine)
    library = out / ('EDITED_INVADERS.dll' if os.name == 'nt' else 'libedited_invaders.so')
    command = [os.environ.get('CC', 'gcc'), '-std=c11', '-O2', '-Wall', '-Wextra', '-Werror',
               '-Wno-unknown-pragmas', '-fno-strict-aliasing', '-DOVERKILL_HOST', '-shared',
               '-I' + str(out), '-I' + str(ROOT / 'build/host'), '-I' + str(ROOT / 'c'),
               '-I' + str(ROOT / 'host')]
    if os.name != 'nt':
        command += ['-fPIC', '-Wl,-rpath,' + str(ROOT / 'build/host')]
    command += [str(ROOT / path) for path in ('c/enemies.c', 'c/frame.c', 'host/level_invaders.c')]
    command += ['-L' + str(ROOT / 'build/host'), '-loverkill_core', '-o', str(library)]
    subprocess.run(command, check=True)
    return ctypes.CDLL(str(library))


def fixtures(h, documents):
    if documents[3]['encounter']['slots'] != original_invader_slots(h.m):
        raise AssertionError('canonical slots differ from the source table')
    for index, document in enumerate(documents):
        if document['marching_formation'] != original_marching_formation(index):
            raise AssertionError('canonical march differs from maintained procedures')
    omitted = copy.deepcopy(documents)
    for document in omitted:
        del document['marching_formation']
    del omitted[3]['encounter']['slots']
    first, second = ROOT / 'build/host-invaders-canonical', ROOT / 'build/host-invaders-omitted'
    generate_invader_header(first, documents, h.m)
    generate_invader_header(second, omitted, h.m)
    if (first / 'INVADERS_GEN.H').read_bytes() != (second / 'INVADERS_GEN.H').read_bytes():
        raise AssertionError('omitted sections changed canonical slot/timing bindings')
    malformed = []
    for field, value in (('enabled', 1), ('step_delays', []), ('fire_delays', None),
                         ('step_delays', [{'minimum_members': 1, 'frames': 1}]),
                         ('fire_delays', [{'minimum_members': True, 'frames': 1}]),
                         ('fire_delays', [{'minimum_members': 0, 'frames': 256}]),
                         ('step_delays', [{'minimum_members': 0, 'frames': -1}]),
                         ('step_delays', [{'minimum_members': 0, 'frames': False}]),
                         ('step_delays', [{'minimum_members': 65536, 'frames': 1},
                                          {'minimum_members': 0, 'frames': 1}]),
                         ('step_delays', [{'minimum_members': 0, 'frames': 1},
                                          {'minimum_members': 0, 'frames': 2}])):
        edited = copy.deepcopy(documents[5])
        edited['marching_formation'][field] = value
        malformed.append(edited)
    for slots in ([], [{}] * 24, [{'x': 0, 'y': True}] * 24, [{'x': 32768, 'y': 0}] * 24):
        edited = copy.deepcopy(documents[3])
        edited['encounter']['slots'] = slots
        malformed.append(edited)
    edited = copy.deepcopy(documents[1])
    edited['encounter']['slots'] = documents[3]['encounter']['slots']
    malformed.append(edited)
    for document in malformed:
        try:
            validate(document)
        except ValueError:
            continue
        raise AssertionError('accepted malformed invader data')
    return 9 + len(malformed)


class Cases:
    def __init__(self, base):
        self.base, self.h, self.arena = base, base.h, base.arena
        self.far_call = module('invader_far_calls', ROOT / 'tests/host/player_frame.py')._call_far
        # Distinguish the real adjacent physical byte from both low DS and the
        # borrowed state's canary when an unchecked LODSW begins at FFFFh.
        base.memory[self.h.m.data_frame * 16 + 65536] = 0xC7
        self.count = 0

    def put(self, name, value, width=2):
        self.h.write_symbol(name, struct.pack('<H' if width == 2 else 'B', value))

    def setup(self, level, *, slot=None, free=2, child_alias=None, march=False,
              live=17, delay=1, fire_delay=1, pulse=0, edge=0, members=False, sfx=0):
        h = self.h
        actor = self.base.setup(level, free=free)
        self.put('SfxEnabled', sfx, 1)
        if not march:
            if child_alias is not None:
                h.write(child_alias, bytes([0xA5]) * K.RECORD_SIZE)
                h.write(child_alias, b'\x00\x00')
                self.put('PoolACursor', child_alias)
            self.put('InvaderSlotCursor', slot)
            return actor
        for pool, count in (('PoolA', K.POOL_A_COUNT), ('PoolB', K.POOL_B_COUNT)):
            for index in range(count):
                h.write(h.offset(pool) + index * K.RECORD_SIZE, bytes(K.RECORD_SIZE))
        words = {'EncounterLiveCount': live, 'EnergyTanks': 65535,
                 'LeaderScriptCursor': h.offset('LeaderScript7EEnd'),
                 'FramesSinceInvaderSpawn': 65534, 'InvaderNextMarchLeft': 1,
                 'InvaderNextDropStep': 2, 'MarchStepX': 2, 'RecordTickCounter': 90}
        for name, value in words.items():
            self.put(name, value)
        for name, value in {'MarchDelay': delay, 'MarchFireDelay': fire_delay,
                'MarchStepNow': pulse, 'MarchFireNow': pulse, 'MarchEdgeHit': edge,
                'MarchDropNow': 3, 'Type93KilledLatch': 1}.items():
            self.put(name, value, 1)
        if members:
            # Two eligible members: the reverse record pass chooses who consumes
            # the fire pulse and records an exact-edge hit for the following pass.
            for index, x in ((0, 64), (1, 190)):
                record = bytearray(self.base.checkpoints._record(status=1, x=x, y=64,
                    kind=K.KIND_ENEMY, type=0x80, sprite=0x160, size_class=1, hit_points=5))
                for field, value in ((K.REC_SAVED_Y, 64), (K.REC_SAVED_X, x),
                                     (K.REC_ENTRY_DELAY, 0)):
                    struct.pack_into('<H', record, field, value)
                h.write(self.base.pool + index * K.RECORD_SIZE, record)
        return actor

    def compare(self, lib, level, *, source=None, oracle_slots=None, expected_bytes=(),
                function='encounter_spawn_invader', **state):
        h, arena = self.h, self.arena
        source = level if source is None else source
        actor = self.setup(source, **state)
        table = h.offset('InvaderFormation')
        if oracle_slots is not None:
            h.m.write(table, b''.join(encode_point(point) for point in oracle_slots))
        oracle = {'encounter_spawn_invader': 'EncounterSpawnInvader',
                  'update_all_records': 'UpdateAllRecords',
                  'step_march_fire_delay': 'StepMarchFireDelay'}[function]
        call = self.far_call if function == 'step_march_fire_delay' else lambda m, name, regs: m.call(name, regs)
        registers = call(h.m, oracle, {'BP': actor})
        expected = bytearray(h.m.state())
        physical = bytearray(h.m.u.mem_read(0, 0x100000))
        changes = []
        if oracle_slots is not None:
            # Only test-only source table bytes differ. Disjoint authored cases
            # require the oracle table to remain intact; aliases use canonical DS.
            edited = b''.join(encode_point(point) for point in oracle_slots)
            if expected[table:table + 96] != edited:
                raise AssertionError('authored fixture mutated its source table')
            changes.append((table, h.baseline[table:table + 96]))
        if source != level:
            at = h.offset('LevelIndex')
            if struct.unpack_from('<H', expected, at)[0] != source:
                raise AssertionError('fixture changed its source identity')
            changes.append((at, struct.pack('<H', level)))
        for name, old, new in expected_bytes:
            at = h.offset(name)
            if expected[at] != old:
                raise AssertionError('unexpected oracle delay reload')
            changes.append((at, bytes([new])))
        for at, data in changes:
            expected[at:at + len(data)] = data
            absolute = h.m.data_frame * 16 + at
            physical[absolute:absolute + len(data)] = data
        actor = self.setup(level, **state)
        fn = getattr(lib, function)
        fn.argtypes = () if state.get('march') else (ctypes.c_void_p,)
        fn.restype = ctypes.c_uint16 if function == 'update_all_records' else None
        result = fn() if state.get('march') else fn(ctypes.c_void_p(h.state_addr + actor))
        if function == 'update_all_records' and result != registers['BP']:
            raise AssertionError('record pass returned the wrong final BP')
        ctypes.memmove(arena.base + h.m.data_frame * 16, h.state_storage.snapshot(), 65536)
        actual_memory = arena.snapshot()
        h.m.set_state(bytes(expected))
        label = f'{function} level={level} source={source} {state}'
        h.compare(label)
        self.base.checkpoints._compare_arena(actual_memory, bytes(physical),
            h.m.data_frame * 16 + h.stack_lo, h.m.data_frame * 16 + h.stack_hi, label)
        self.count += 1


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--no-build', action='store_true')
    args = parser.parse_args()
    if not args.no_build:
        import host
        host.build()
    encounters = module('invader_encounters', ROOT / 'tests/host/encounter_data.py')
    harness = encounters.module('invader_input', ROOT / 'tests/host/input.py')
    checkpoints = encounters.module('invader_checkpoints', ROOT / 'tests/host/checkpoints.py')
    h = harness.HostHarness()
    documents = [load(path) for path in original_paths()]
    checked = fixtures(h, documents)
    checkpoints._bind_native(h.lib)
    cases = Cases(encounters.Cases(h, checkpoints.Arena(h), checkpoints))
    start, end = h.offset('InvaderFormation'), h.offset('InvaderFormationEnd')
    for level in range(6):
        for slot in list(range(start, end + 1, 4)) + [start + 1, end + 1, 0, 65534, 65535]:
            for free in (0, 2):
                cases.compare(h.lib, level, slot=slot, free=free)
    for alias in (start + 2 - K.REC_SAVED_Y, h.offset('InvaderSlotCursor') - K.REC_SAVED_Y):
        cases.compare(h.lib, 3, slot=start, child_alias=alias)
    for slot in (start, end - 4, end):
        for free in (0, 2):
            cases.compare(h.lib, 3, slot=slot, free=free, sfx=1)
    for level in (*range(6), 6, 65535):
        for live in (0, 2, 3, 4, 5, 8, 9, 16, 17, 65535):
            for delay, fire, pulse in ((0, 0, 255), (1, 1, 255), (2, 2, 1)):
                cases.compare(h.lib, level, march=True, live=live, delay=delay,
                    fire_delay=fire, pulse=pulse, edge=2, function='update_all_records')
    for live in (0, 2, 3, 4, 5, 8, 9, 16, 17, 65535):
        for fire in (0, 1, 2, 255):
            cases.compare(h.lib, 5, march=True, live=live, fire_delay=fire,
                          function='step_march_fire_delay')
    for edge in (0, 1, 255):
        cases.compare(h.lib, 5, march=True, edge=edge, members=True, function='update_all_records')
    edited = copy.deepcopy(documents)
    edited[1]['encounter'] = copy.deepcopy(documents[3]['encounter'])
    slots = edited[1]['encounter']['slots']
    for index, point in enumerate(slots):
        point.update(x=20 + index * 5, y=48 + index % 3 * 12)
    slots[-1].update(x=-103, y=-48)  # Signed coordinates and a distinct table-seam high byte.
    edited[1]['marching_formation'] = copy.deepcopy(documents[5]['marching_formation'])
    edited[5]['marching_formation'] = copy.deepcopy(documents[0]['marching_formation'])
    edited[0]['marching_formation']['step_delays'] = [{'minimum_members': 0, 'frames': 77}]
    edited[0]['marching_formation']['fire_delays'] = [{'minimum_members': 0, 'frames': 88}]
    alternate = compile_alternate(ROOT / 'build/host-invader-data', edited, h.m)
    for slot in list(range(start, end + 1, 4)) + [start + 1, end - 1, end + 1, 65535]:
        for free in (0, 2):
            cases.compare(alternate, 1, slot=slot, free=free, oracle_slots=slots)
    for level in (3, 5):
        cases.compare(alternate, level, slot=start)
    for level, source in ((1, 5), (5, 0)):
        for delay in (0, 1, 2):
            cases.compare(alternate, level, source=source, march=True, delay=delay,
                          members=True, function='update_all_records')
    # Even after editing slot zero's tiers, invalid word identities keep originals.
    cases.compare(alternate, 65535, march=True, fire_delay=1, function='step_march_fire_delay')
    edited[1]['marching_formation']['step_delays'] = [
        {'minimum_members': 14, 'frames': 7}, {'minimum_members': 0, 'frames': 0}]
    edited[1]['marching_formation']['fire_delays'] = [
        {'minimum_members': 14, 'frames': 9}, {'minimum_members': 0, 'frames': 0}]
    authored = compile_alternate(ROOT / 'build/host-authored-invaders', edited, h.m)
    for live, old_step, old_fire, step, fire in ((14, 6, 100, 7, 9), (13, 6, 100, 0, 0),
                                               (0, 1, 40, 0, 0)):
        cases.compare(authored, 1, source=5, march=True, live=live, members=True,
            expected_bytes=(('MarchDelay', old_step, step), ('MarchFireDelay', old_fire, fire)),
            function='update_all_records')
    cases.compare(authored, 1, source=5, march=True, live=14, delay=0, fire_delay=0,
                  pulse=255, members=True, function='update_all_records')
    print(f'PASS invader data: {checked} fixture/validator checks, {cases.count} native/oracle calls')


if __name__ == '__main__':
    main()
