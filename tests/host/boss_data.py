"""Segmented-boss member data and ordered setup/cleanup against bounded ASM calls."""
from pathlib import Path
import argparse
import copy
import ctypes
import os
import struct
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from level_format import load, original_paths, validate
from level_boss import original_boss, generate_boss_header, ROLES
from level_encounter import generate_encounter_header
from world import K


def compile_alternate(out, documents, h):
    h.reset()
    generate_boss_header(out, documents, h.m)
    generate_encounter_header(out, documents)
    library = out / ('EDITED_BOSSES.dll' if os.name == 'nt' else 'libedited_bosses.so')
    command = [os.environ.get('CC', 'gcc'), '-std=c11', '-O2', '-Wall', '-Wextra', '-Werror',
               '-Wno-unknown-pragmas', '-fno-strict-aliasing', '-DOVERKILL_HOST', '-shared',
               '-I' + str(out), '-I' + str(ROOT / 'build/host'), '-I' + str(ROOT / 'c'),
               '-I' + str(ROOT / 'host')]
    if os.name != 'nt':
        command += ['-fPIC', '-Wl,-rpath,' + str(ROOT / 'build/host')]
    command += [str(ROOT / path) for path in ('c/enemies.c', 'c/frame.c', 'c/combat.c',
                                             'host/level_boss.c', 'host/level_encounter.c')]
    command += ['-L' + str(ROOT / 'build/host'), '-loverkill_core', '-o', str(library)]
    subprocess.run(command, check=True)
    return ctypes.CDLL(str(library))


def fixtures(h, documents):
    if documents[0]['boss'] != original_boss(h.m):
        raise AssertionError('canonical boss differs from source geometry/curated setup')
    omitted = copy.deepcopy(documents)
    del omitted[0]['boss']
    first, second = ROOT / 'build/host-boss-canonical', ROOT / 'build/host-boss-omitted'
    generate_boss_header(first, documents, h.m)
    generate_boss_header(second, omitted, h.m)
    if (first / 'BOSSES_GEN.H').read_bytes() != (second / 'BOSSES_GEN.H').read_bytes():
        raise AssertionError('omitted boss changes original bindings')
    malformed = []
    for path, value in ((('kind',), 'generic'), (('hit_points',), True),
            (('hit_points',), 65536), (('parts',), []),
            (('parts', 'anchor', 'sprite'), -1), (('parts', 'core', 'sprite'), False),
            (('parts', 'lower_right', 'spawn_position', 'x'), 32768),
            (('parts', 'upper_right', 'spawn_position', 'y'), True),
            (('parts', 'core', 'offset', 'dy'), -32769),
            (('parts', 'anchor', 'offset', 'dx'), False)):
        edited = copy.deepcopy(documents[0])
        target = edited['boss']
        for name in path[:-1]:
            target = target[name]
        target[path[-1]] = value
        malformed.append(edited)
    edited = copy.deepcopy(documents[0])
    edited['boss']['parts']['0x78'] = edited['boss']['parts'].pop('core')
    malformed.append(edited)
    edited = copy.deepcopy(documents[0])
    del edited['encounter']
    malformed.append(edited)
    edited = copy.deepcopy(documents[0])
    edited['encounter'] = copy.deepcopy(documents[1]['encounter'])
    malformed.append(edited)
    for document in malformed:
        try:
            validate(document)
        except ValueError:
            continue
        raise AssertionError('accepted malformed boss data')
    return 2 + len(malformed)


class Cases:
    def __init__(self, base, far_call):
        self.base, self.h, self.arena = base, base.h, base.arena
        self.far_call, self.count = far_call, 0

    def setup(self, level, *, action='setup', free=3, part=0, origin=(32, 16), phase=16,
              actor=None, links=None, extra_enemy=False, shot_alias=None):
        h = self.h
        actor = self.base.setup(level, free=free, rtype=0x21 if action == 'setup' else 0x76 + part,
                                actor=actor)
        h.write_symbol('SfxEnabled', b'\x01')
        if extra_enemy:
            h.write(self.base.pool + 4 * K.RECORD_SIZE + K.REC_KIND, struct.pack('<H', K.KIND_ENEMY))
        if action != 'setup':
            for name, value in (('SegBossX', origin[0]), ('SegBossY', origin[1]),
                                ('FrameCount128', phase), ('SegBossActive', 1)):
                h.write_symbol(name, struct.pack('<H', value & 65535))
            h.write(actor + K.REC_TYPE, struct.pack('<H', 0x76 + part))
            h.write(actor + K.REC_SIZE_CLASS, struct.pack('<H', 2))
        if links is not None:
            for name, value in zip(('SegBossAnchor', 'SegBossPart77', 'SegBossCore', 'SegBossPart79'), links):
                h.write_symbol(name, struct.pack('<H', value))
        if shot_alias is not None:
            h.write(shot_alias, bytes([0xA5]) * K.RECORD_SIZE)
            h.write(shot_alias, b'\x00\x00')
            h.write_symbol('PoolBCursor', struct.pack('<H', shot_alias))
        return actor

    def compare(self, lib, level, *, source=None, authored=None, geometry=None, **state):
        h, arena = self.h, self.arena
        source = level if source is None else source
        actor = self.setup(source, **state)
        action = state.get('action', 'setup')
        names = {'setup': ('type21_encounter_director', 'Type21EncounterDirector'),
                 'place': ('run_type_handler', 'RunTypeHandler'),
                 'release': ('release_encounter_member', 'ReleaseEncounterMember'),
                 'init': ('init_seg_boss_part_record', 'InitSegBossPartRecord')}
        native, oracle = names[action]
        table = h.offset('BossPartOffsets')
        if geometry is not None:
            data = struct.pack('<8H', *(geometry['parts'][role]['offset'][field] & 65535
                                       for role in ROLES for field in ('dy', 'dx')))
            h.m.write(table, data)
        if action == 'init':
            self.far_call(h.m, oracle, {'BX': actor})
        else:
            h.m.call(oracle, {'BP': actor})
        expected = bytearray(h.m.state())
        physical = bytearray(h.m.u.mem_read(0, 0x100000))
        changes = []
        if geometry is not None:
            if expected[table:table + 16] != data:
                raise AssertionError('authored geometry fixture changed its source table')
            changes.append((table, h.baseline[table:table + 16]))
        if source != level:
            at = h.offset('LevelIndex')
            if struct.unpack_from('<H', expected, at)[0] != source:
                raise AssertionError('fixture changed its source identity')
            changes.append((at, struct.pack('<H', level)))
        if authored is not None:
            # Explicit output changes for curated immediate setup parameters.
            # Keep every other effect (including failed-setup cleanup) compared.
            records = [('core', actor)] if action == 'setup' else [('anchor', actor)]
            if action == 'setup':
                records += [(role, self.base.pool + index * K.RECORD_SIZE)
                            for index, role in enumerate(('anchor', 'upper_right', 'lower_right'), 1)
                            if index <= state.get('free', 3)]
            for role, record in records:
                failed = action == 'setup' and state.get('free', 3) < 3
                # The reverse smart-bomb pass zeroes the last allocated part
                # first. Its release explodes the linked parts; those now have
                # type 1, so later visits preserve their initialized health.
                first_destroyed = ('core', 'anchor', 'upper_right')[state.get('free', 3)] if failed else None
                zeroed = role == first_destroyed
                edits = [(K.REC_HIT_POINTS, 0 if zeroed else 200,
                          0 if zeroed else authored['hit_points'])]
                if action == 'setup':
                    old_x = 32 if role in ('upper_right', 'lower_right') else 0
                    edits += [(K.REC_X, old_x, authored['parts'][role]['spawn_position']['x']),
                              (K.REC_Y, 0, authored['parts'][role]['spawn_position']['y'])]
                    if state.get('free', 3) >= 3:
                        edits.append((K.REC_SPRITE, 32 + ROLES.index(role), authored['parts'][role]['sprite']))
                for field, old, new in edits:
                    at = record + field
                    if struct.unpack_from('<H', expected, at)[0] != old:
                        got = struct.unpack_from('<H', expected, at)[0]
                        raise AssertionError(f'unexpected oracle setup word {role} {field:02X}: '
                                             f'{got} expected {old}; {state}')
                    changes.append((at, struct.pack('<H', new & 65535)))
        for at, data in changes:
            expected[at:at + len(data)] = data
            absolute = h.m.data_frame * 16 + at
            physical[absolute:absolute + len(data)] = data
        actor = self.setup(level, **state)
        fn = getattr(lib, native)
        fn.argtypes, fn.restype = (ctypes.c_void_p,), None
        fn(ctypes.c_void_p(h.state_addr + actor))
        ctypes.memmove(arena.base + h.m.data_frame * 16, h.state_storage.snapshot(), 65536)
        actual_memory = arena.snapshot()
        h.m.set_state(bytes(expected))
        label = f'{native} level={level} source={source} {state}'
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
    import importlib.util
    spec = importlib.util.spec_from_file_location('boss_encounters', ROOT / 'tests/host/encounter_data.py')
    encounters = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(encounters)
    harness = encounters.module('boss_input', ROOT / 'tests/host/input.py')
    checkpoints = encounters.module('boss_checkpoints', ROOT / 'tests/host/checkpoints.py')
    far_call = encounters.module('boss_far_calls', ROOT / 'tests/host/player_frame.py')._call_far
    h = harness.HostHarness()
    documents = [load(path) for path in original_paths()]
    checked = fixtures(h, documents)
    checkpoints._bind_native(h.lib)
    cases = Cases(encounters.Cases(h, checkpoints.Arena(h), checkpoints), far_call)
    pool, stride = h.offset('PoolA'), K.RECORD_SIZE
    links = ((pool + stride, pool + 2 * stride, pool, pool + 3 * stride),
             (0, 0, pool, 0), (pool + stride,) * 4, (pool,) * 4)
    for free in range(4):
        for pointers in links:
            cases.compare(h.lib, 0, free=free, links=pointers)
        cases.compare(h.lib, 0, free=free, extra_enemy=True)
    for level in (*range(6), 65535):
        cases.compare(h.lib, level, action='init')
        for part in range(4):
            for origin in ((32, 16), (50, -20), (32760, 32760), (-32760, -32760)):
                for phase in (0, 15, 16):
                    cases.compare(h.lib, level, action='place', part=part, origin=origin, phase=phase)
    for part in range(4):
        for pointers in links:
            cases.compare(h.lib, 0, action='release', part=part, links=pointers)
    table = h.offset('BossPartOffsets')
    for actor in (table + 2 - K.REC_Y, h.offset('SegBossX') - K.REC_Y):
        cases.compare(h.lib, 0, action='place', actor=actor)
    cases.compare(h.lib, 0, action='place', part=2, phase=0, shot_alias=table)
    edited = copy.deepcopy(documents)
    edited[1]['boss'] = copy.deepcopy(documents[0]['boss'])
    edited[1]['encounter'] = copy.deepcopy(documents[0]['encounter'])
    alternate = compile_alternate(ROOT / 'build/host-boss-data', edited, h)
    for free in range(4):
        cases.compare(alternate, 1, source=0, free=free)
    boss = edited[1]['boss']
    boss['hit_points'] = 73
    for index, role in enumerate(ROLES):
        boss['parts'][role]['sprite'] = 51 + index
        boss['parts'][role]['spawn_position'] = {'x': 45 + index * 12, 'y': 8 + index * 4}
        boss['parts'][role]['offset'] = {'dx': -13 + index * 19, 'dy': -24 + index * 17}
    authored = compile_alternate(ROOT / 'build/host-authored-bosses', edited, h)
    for free in range(4):
        for pointers in links:
            cases.compare(authored, 1, source=0, free=free, links=pointers, authored=boss)
    cases.compare(authored, 1, action='init', authored=boss)
    for part in range(4):
        for origin in ((32, 16), (32760, -20)):
            for phase in (0, 15, 16):
                cases.compare(authored, 1, action='place', part=part, origin=origin,
                              phase=phase, geometry=boss)
    # Edited content remains local to its definition; other/fallback identities
    # retain original setup scalars and live offset storage.
    for level in (0, 3, 65535):
        cases.compare(authored, level, action='init')
        cases.compare(authored, level, action='place', part=2, phase=0)
    print(f'PASS boss data: {checked} fixture/validator checks, {cases.count} native/oracle calls')


if __name__ == '__main__':
    main()
