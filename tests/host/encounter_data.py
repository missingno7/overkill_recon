"""Encounter descriptors through production C, compared with bounded ASM calls.

Permutation cases change only the descriptor's storage slot. The reference uses
the source level identity and comparisons account only for that input difference;
records, RNG, counters, map and CS cursor effects must still match.
"""
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
from level_bindings import bind_level_documents
from level_encounter import original_encounter, encounter_words, generate_encounter_header
from world import K


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(spec)
    sys.modules[name] = result
    spec.loader.exec_module(result)
    return result


def imports(h, documents):
    if bind_level_documents(h.m, documents) != h.baseline:
        raise AssertionError('canonical encounter definitions change initial DS')
    for level, document in enumerate(documents):
        encounter = {name: value for name, value in document['encounter'].items() if name != 'slots'}
        if encounter != original_encounter(level):
            raise AssertionError('canonical encounter differs from maintained rules')
    old = copy.deepcopy(documents)
    for document in old:
        del document['encounter']
    if [encounter_words(document, level) for level, document in enumerate(old)] != [
            encounter_words(document, level) for level, document in enumerate(documents)]:
        raise AssertionError('omitted encounter changes the original policies')
    bad = []
    for field, value in (('kind', '0x21'), ('kind', []), ('director_destructible', 1),
                         ('fallers_until_tick', True), ('burster_at_tick', 199),
                         ('burster_at_tick', 65536), ('burster', {})):
        edited = copy.deepcopy(documents[1])
        edited['encounter'][field] = value
        bad.append(edited)
    for section, field, value in (('fallers', 'hit_points', True), ('fallers', 'hit_points', 65535),
            ('fallers', 'hit_points', 'normal'), ('fallers', 'variant', 'random'),
            ('fallers', 'motion', 'flyer'), ('burster', 'hit_points', -1),
            ('burster', 'sprite', True), ('burster', 'x', 32768)):
        edited = copy.deepcopy(documents[1])
        edited['encounter'][section][field] = value
        bad.append(edited)
    for document in bad:
        try:
            validate(document)
        except ValueError:
            continue
        raise AssertionError('accepted malformed encounter')
    return len(documents) + len(bad) + 2


def compile_alternate(out, documents):
    generate_encounter_header(out, documents)
    library = out / ('EDITED_ENCOUNTERS.dll' if os.name == 'nt' else 'libedited_encounters.so')
    command = [os.environ.get('CC', 'gcc'), '-std=c11', '-O2', '-Wall', '-Wextra', '-Werror',
               '-Wno-unknown-pragmas', '-fno-strict-aliasing', '-DOVERKILL_HOST', '-shared',
               '-I' + str(out), '-I' + str(ROOT / 'build/host'), '-I' + str(ROOT / 'c'),
               '-I' + str(ROOT / 'host')]
    if os.name != 'nt':
        command += ['-fPIC', '-Wl,-rpath,' + str(ROOT / 'build/host')]
    command += [str(ROOT / path) for path in ('c/enemies.c', 'c/combat.c', 'host/level_encounter.c')]
    command += ['-L' + str(ROOT / 'build/host'), '-loverkill_core', '-o', str(library)]
    subprocess.run(command, check=True)
    return ctypes.CDLL(str(library))


class Cases:
    def __init__(self, h, arena, checkpoints):
        self.h, self.arena, self.checkpoints = h, arena, checkpoints
        self.memory = bytearray(arena.image)
        address = h.m.linear('LevelMapSegment')
        self.memory[address:address + 2] = struct.pack('<H', 0x9000)
        self.memory[0x90000:0xA0000] = bytes([1]) * 65536
        if not h.lib.overkill_bind_level_map(arena.base + 0x90000, 65536):
            raise AssertionError('map binding failed')
        self.pool = h.offset('PoolA')
        self.count = 0

    def setup(self, level, tick=0, free=4, frame=7, rtype=0x21, arrival=True, variant=0,
              cursor_end=False, actor=None):
        h, arena = self.h, self.arena
        h.reset()
        h.m.u.mem_write(0, bytes(self.memory))
        h.m.set_state(h.baseline)
        arena.load(bytes(self.memory))
        for name, count in (('PoolA', K.POOL_A_COUNT), ('PoolB', K.POOL_B_COUNT)):
            for index in range(count):
                record = bytearray([0xA5]) * K.RECORD_SIZE
                for field, value in dict(status=0 if 0 < index <= free else 1,
                        kind=K.KIND_SCENERY, type=0, slot_index=65535).items():
                    struct.pack_into('<H', record, getattr(K, 'REC_' + field.upper()), value)
                h.write(h.offset(name) + index * K.RECORD_SIZE, record)
        record = bytearray([0xA5]) * K.RECORD_SIZE
        for field, value in dict(status=1, y=64, x=96, saved_y=64 if arrival else 80,
                saved_x=96, size_class=1, kind=K.KIND_ENEMY, type=rtype,
                sprite=0, direction=K.DIR_DOWN, draw_pass=1, hit_points=20,
                slot_index=65535, flash_timer=0, faller_variant=variant).items():
            struct.pack_into('<H', record, getattr(K, 'REC_' + field.upper()), value & 65535)
        actor = self.pool if actor is None else actor
        h.write(actor, record)
        h.write_symbol('PrimaryRecord', self.checkpoints._record(status=0, x=160, y=208))
        words = dict(LevelIndex=level, EncounterTicks=tick, FrameCount8=frame,
            PoolACursor=self.pool + K.RECORD_SIZE, PoolBCursor=h.offset('PoolB') + K.RECORD_SIZE,
            LevelEndPhase=1, ScrollDeltaY=0, MapScrollPos=1300, RecordTickCounter=0xFFFF,
            EncounterLiveCount=1, EncounterEndDelay=100, SegBossActive=0, DifficultySetting=2,
            FallerColumnCursor=h.offset('FallerColumnsEnd') if cursor_end else h.offset('FallerColumns'),
            InvaderSlotCursor=h.offset('InvaderFormationEnd') if cursor_end else h.offset('InvaderFormation'),
            RandomWordCursor=h.offset('CreditRandomWords'), DemoActive=0,
            SegBossAnchor=self.pool + K.RECORD_SIZE, SegBossCore=actor,
            SegBossPart77=self.pool + 2 * K.RECORD_SIZE, SegBossPart79=self.pool + 3 * K.RECORD_SIZE)
        for name, value in words.items():
            h.write_symbol(name, struct.pack('<H', value & 65535))
        h.write_symbol('SfxEnabled', b'\x00')
        h.write_symbol('ByteAttributeTable', bytes(256))
        cursor = h.m.linear('Type21PathCursor')
        data = struct.pack('<H', h.offset('Type21Path'))
        h.m.u.mem_write(cursor, data)
        ctypes.memmove(arena.base + cursor, data, 2)
        return actor

    def compare(self, lib, native, oracle, level, *, source=None, source_tick=None,
                expected_words=(), **state):
        source = level if source is None else source
        h, arena = self.h, self.arena
        reference_state = dict(state)
        if source_tick is not None:
            reference_state['tick'] = source_tick
        actor = self.setup(source, **reference_state)
        h.m.call(oracle, {'BP': actor})
        expected = bytearray(h.m.state())
        expected_memory = bytearray(h.m.u.mem_read(0, 0x100000))
        if source != level:
            offset = h.offset('LevelIndex')
            if struct.unpack_from('<H', expected, offset)[0] != source:
                raise AssertionError('permutation fixture changed its source identity')
            expected[offset:offset + 2] = struct.pack('<H', level)
            base = h.m.data_frame * 16
            expected_memory[base + offset:base + offset + 2] = struct.pack('<H', level)
        # Authored scalar cases use the same original procedure at its equivalent
        # clock. Only the declared input clock and explicit data outputs differ;
        # every other byte must match. Check old values before applying those
        # expectations so the fixture cannot conceal an unexpected oracle effect.
        differences = list(expected_words)
        if source_tick is not None:
            differences.append((h.offset('EncounterTicks'), source_tick, state['tick']))
        for offset, old, new in differences:
            if struct.unpack_from('<H', expected, offset)[0] != old:
                raise AssertionError(f'unexpected reference word at {offset:04X}')
            data = struct.pack('<H', new)
            expected[offset:offset + 2] = data
            base = h.m.data_frame * 16
            expected_memory[base + offset:base + offset + 2] = data
        actor = self.setup(level, **state)
        fn = getattr(lib, native)
        fn.argtypes = (ctypes.c_void_p,)
        fn.restype = None
        fn(ctypes.c_void_p(h.state_addr + actor))
        ctypes.memmove(arena.base + h.m.data_frame * 16, h.state_storage.snapshot(), 65536)
        snapshot = arena.snapshot()
        h.m.set_state(bytes(expected))
        label = f'{native} level={level} source={source} {state}'
        h.compare(label)
        self.checkpoints._compare_arena(snapshot, bytes(expected_memory),
            h.m.data_frame * 16 + h.stack_lo, h.m.data_frame * 16 + h.stack_hi, label)
        self.count += 1


def execute(cases, lib, mapping=range(6)):
    for level, source in enumerate(mapping):
        for tick in (0, 49, 50, 89, 90, 199, 200, 239, 240, 65535):
            for free in (0, 2, 4):
                cases.compare(lib, 'type21_encounter_director', 'Type21EncounterDirector',
                              level, source=source, tick=tick, free=free)
        for frame in (6, 7):
            for free in (0, 2):
                for cursor_end in (False, True):
                    cases.compare(lib, 'encounter_spawn_faller', 'EncounterSpawnFaller',
                                  level, source=source, frame=frame, free=free, cursor_end=cursor_end)
        for arrival in (False, True):
            for variant in range(4):
                cases.compare(lib, 'type23_column_faller', 'Type23ColumnFaller',
                              level, source=source, rtype=0x23, arrival=arrival, variant=variant)
        cases.compare(lib, 'destroy_record', 'DestroyRecord', level, source=source)


def authored(cases, documents):
    edited = copy.deepcopy(documents)
    encounter = edited[1]['encounter']
    encounter.update(fallers_until_tick=10, burster_at_tick=12, director_destructible=True)
    encounter['burster'].update(hit_points=77, sprite=99, x=81)
    encounter['fallers'].update(hit_points=7, variant='preserve', motion='aimed_drift')
    edited[3]['encounter'].update(fallers_until_tick=10, invaders_at_tick=12)
    alternate = compile_alternate(ROOT / 'build/host-authored-encounters', edited)
    child = cases.pool + K.RECORD_SIZE
    faller_words = ((child + K.REC_HIT_POINTS, 65535, 7),
                    (child + K.REC_FALLER_VARIANT, 3, 0xA5A5),
                    (cases.h.offset('RecordTickCounter'), 0, 65535))
    cases.compare(alternate, 'encounter_spawn_faller', 'EncounterSpawnFaller', 1,
                  expected_words=faller_words)
    cases.compare(alternate, 'encounter_spawn_faller', 'EncounterSpawnFaller', 1, free=0)
    for tick, reference in ((9, 199), (10, 200), (11, 239), (12, 240), (65535, 65535)):
        outputs = faller_words if tick < 10 else () if tick < 12 else (
            (cases.pool + K.REC_HIT_POINTS, 20, 77),
            (cases.pool + K.REC_SPRITE, 113, 99), (cases.pool + K.REC_X, 96, 81))
        cases.compare(alternate, 'type21_encounter_director', 'Type21EncounterDirector', 1,
                      tick=tick, source_tick=reference, expected_words=outputs)
    for tick, reference in ((9, 49), (10, 50), (11, 89), (12, 90)):
        cases.compare(alternate, 'type21_encounter_director', 'Type21EncounterDirector', 3,
                      tick=tick, source_tick=reference)
    # The independently authored motion and damage flags use their existing
    # procedures, even though this level's director still selects a burster.
    cases.compare(alternate, 'type23_column_faller', 'Type23ColumnFaller', 1,
                  source=2, rtype=0x23)
    cases.compare(alternate, 'destroy_record', 'DestroyRecord', 1, source=4)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--no-build', action='store_true')
    args = parser.parse_args()
    if not args.no_build:
        import host
        host.build()
    harness = module('encounter_data_input', ROOT / 'tests/host/input.py')
    checkpoints = module('encounter_data_checkpoints', ROOT / 'tests/host/checkpoints.py')
    h = harness.HostHarness()
    documents = [load(path) for path in original_paths()]
    imported = imports(h, documents)
    checkpoints._bind_native(h.lib)
    arena = checkpoints.Arena(h)
    cases = Cases(h, arena, checkpoints)
    execute(cases, h.lib)
    # The same content at different slots must retain its encounter behavior and
    # fixed HP. Other level subsystems have not yet been detached from those slots.
    mapping = (3, 5, 2, 0, 4, 1)
    edited = copy.deepcopy(documents)
    for level, source in enumerate(mapping):
        edited[level]['encounter'] = copy.deepcopy(documents[source]['encounter'])
    alternate = compile_alternate(ROOT / 'build/host-encounter-data', edited)
    execute(cases, alternate, mapping)
    authored(cases, documents)
    # Non-authored word identities retain the original fallback arithmetic/rules.
    for level in (6, 7, 0x8000, 65535):
        cases.compare(h.lib, 'type21_encounter_director', 'Type21EncounterDirector', level, tick=240)
        cases.compare(h.lib, 'encounter_spawn_faller', 'EncounterSpawnFaller', level)
        cases.compare(h.lib, 'type23_column_faller', 'Type23ColumnFaller', level, rtype=0x23)
    # Writes through the director change LevelIndex before the HP formula reads it.
    for field in (K.REC_TYPE, K.REC_SPRITE):
        cases.compare(h.lib, 'type21_encounter_director', 'Type21EncounterDirector', 1,
                      tick=240, actor=h.offset('LevelIndex') - field)
    print(f'PASS encounter data: {imported} import/validator checks, '
          f'{cases.count} native/oracle calls including permutations, authored policies and live identity aliases')


if __name__ == '__main__':
    main()
