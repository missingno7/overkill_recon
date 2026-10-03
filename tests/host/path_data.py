"""Structured path/leader imports and bounded execution against the frozen ASM.

Exercise each original waypoint, arrival, stream ending and leader allocation
boundary. Compare complete DS and physical memory, including CS encounter state,
RNG, stale child fields and failed allocations. No gameplay loop is entered.
"""
from pathlib import Path
import argparse
import copy
import ctypes
import struct
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from level_format import load, original_paths, validate
from level_bindings import bind_level_documents
from level_paths import source_paths, source_leaders, PATH_BINDINGS, LEADER_BINDINGS
from level_presets import ARCHETYPES
from world import K
import importlib.util


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


def import_cases(machine, documents):
    original = machine.state()
    if bind_level_documents(machine, documents) != original:
        raise AssertionError('canonical path import changed original DS')
    old = copy.deepcopy(documents)
    for document in old:
        del document['paths'], document['leader_paths']
    if bind_level_documents(machine, old) != original:
        raise AssertionError('earlier profile changed original paths')
    bad = []
    for field, value in (('points', []), ('points', [{'x': True, 'y': 64}]),
                         ('points', [{'x': 0, 'y': 32768}]),
                         ('end', {'kind': 'jump', 'path': 'missing'})):
        edited = copy.deepcopy(documents)
        edited[0]['paths']['path_follower_b'][field] = value
        bad.append((edited, None))
    for name, edit, message in (
        ('path_follower_b', lambda p: p['points'].append({'x': 0, 'y': 64}), 'point count'),
        ('path_follower_b', lambda p: p['points'].pop(), 'point count'),
        ('path_follower_b', lambda p: p.update(end={'kind': 'restart'}), 'existing reader'),
        ('path_follower_b', lambda p: p['points'][0].update(x=17), 'conflicting shared path'),
        ('sweep_lead_in', lambda p: p['points'].pop(), 'adjacency'),
        ('sweep_lead_in', lambda p: p['points'][0].update(y=31), 'control marker'),
        ('sweep_loop', lambda p: p['points'][0].update(y=31), 'control marker'),
        ('sweep_loop', lambda p: p.update(end={'kind': 'jump', 'path': 'path_follower_b'}), 'reader target'),
    ):
        edited = copy.deepcopy(documents)
        edit(edited[0]['paths'][name])
        bad.append((edited, message))
    for level, name, edit, message in (
        (0, 'sweep_leader', lambda p: p['steps'].pop(), 'synchronization'),
        (0, 'sweep_leader', lambda p: p['steps'][0].update(follower={'x': 0, 'y': 31}), 'no-spawn'),
        (1, 'slot_hopper_leader', lambda p: p['slots'].pop(), 'end boundary'),
        (2, 'bob_chase_leader', lambda p: p['steps'][0].update(follower=None), None),
    ):
        edited = copy.deepcopy(documents)
        edit(edited[level]['leader_paths'][name])
        bad.append((edited, message))
    for edited, message in bad:
        try:
            if message is None:
                for document in edited:
                    validate(document)
            else:
                bind_level_documents(machine, edited)
        except ValueError as error:
            if message is not None and message not in str(error):
                raise
        else:
            raise AssertionError('accepted malformed/conflicting path definition')
    variants = {}
    paths = source_paths(machine)
    leaders = source_leaders(machine)
    def bind(name, edited, allowed):
        state = bind_level_documents(machine, edited)
        changed = {i for i, (a, b) in enumerate(zip(original, state)) if a != b}
        if not changed or not changed <= allowed:
            raise AssertionError(name + ': edited path crosses its binding boundary')
        variants[name] = state
    edited = copy.deepcopy(documents)
    for document in edited:
        if 'path_follower_b' in document['paths']:
            document['paths']['path_follower_b']['points'][0] = {'x': 17, 'y': 65}
    start = paths['path_follower_b'][0]
    bind('shared waypoint', edited, set(range(start, start + 4)))
    edited = copy.deepcopy(documents)
    edited[0]['leader_paths']['sweep_leader']['steps'][0] = {
        'target': {'x': 17, 'y': 65}, 'follower': {'x': 33, 'y': 81}}
    start = leaders['sweep_leader'][0]
    bind('leader target/follower', edited, set(range(start, start + 8)))
    edited = copy.deepcopy(documents)
    edited[1]['leader_paths']['slot_hopper_leader']['slots'][0] = {'x': 35, 'y': 83}
    start = machine.offset('FormationSlots')
    bind('leader slot', edited, set(range(start, start + 4)))
    edited = copy.deepcopy(documents)
    edited[0]['paths']['boss_anchor']['points'][0] = {'x': 17, 'y': 65}
    start = paths['boss_anchor'][0]
    bind('boss waypoint', edited, set(range(start, start + 4)))
    edited = copy.deepcopy(documents)
    edited[0]['paths']['sweep_loop']['points'].pop()
    start, capacity, _ = paths['sweep_loop']
    bind('shortened loop', edited, set(range(start, start + capacity - 4)))
    if variants['shortened loop'][start + capacity - 4:start + capacity] != original[start + capacity - 4:start + capacity]:
        raise AssertionError('shortened loop erased original trailing bytes after its jump')
    return len(bad) + 7, variants


def execution_cases(h, arena, checkpoints, documents, variants):
    paths, leaders = source_paths(h.m), source_leaders(h.m)
    memory = bytearray(arena.image)
    map_base = arena.map_segment << 4
    memory[map_base:map_base + 65536] = bytes([1]) * 65536
    pool = h.offset('PoolA')
    count = 0
    def run(type_id, cursor, target, label, *, level=0, arrival=True, free=K.POOL_A_COUNT - 1,
            state=None, demo=0, last_row=False, step=0, difficulty=0, boss=False,
            rng_index=0, tick=0x11):
        nonlocal count
        h.reset()
        h.m.u.mem_write(0, bytes(memory))
        h.m.set_state(state or h.baseline)
        h.state_storage.load(state or h.baseline)
        arena.load(bytes(memory))
        for name, number in (('PoolA', K.POOL_A_COUNT), ('PoolB', K.POOL_B_COUNT)):
            start = h.offset(name)
            for index in range(number):
                record = bytearray([0xA5]) * K.RECORD_SIZE
                struct.pack_into('<H', record, K.REC_STATUS,
                                 0 if index and index <= free else 1)
                h.write(start + index * K.RECORD_SIZE, record)
        record = bytearray([0xA5]) * K.RECORD_SIZE
        x, y = target['x'], target['y']
        if not arrival:
            x, y = 96, 128
        for field, value in dict(status=1, x=x, y=y, direction=K.DIR_DOWN,
                sprite=0, draw_pass=1, size_class=1, kind=K.KIND_ENEMY,
                type=type_id, hit_points=7, slot_index=65535, flash_timer=0,
                path=cursor, saved_x=x, saved_y=y, entry_delay=0).items():
            struct.pack_into('<H', record, getattr(K, 'REC_' + field.upper()), value & 65535)
        h.write(pool, record)
        h.write_symbol('PrimaryRecord', checkpoints._record(status=0, x=160, y=208))
        for name, value in (('LevelIndex', level), ('DemoActive', demo),
                ('PoolACursor', pool + K.RECORD_SIZE),
                ('PoolBCursor', h.offset('PoolB') + K.RECORD_SIZE),
                ('LevelEndPhase', 1), ('SfxEnabled', 0), ('ScrollDeltaY', 0),
                ('MapScrollPos', K.MAP_LAST_SPAWN_POS if last_row else 100 * K.MAP_ROW_BYTES),
                ('RecordTickCounter', tick), ('EncounterLiveCount', 1),
                ('DifficultySetting', difficulty), ('LeaderScriptCursor', cursor),
                ('FormationSlotCursor', h.offset('FormationSlots') + step * 20),
                ('RandomWordCursor', h.offset('CreditRandomWords') + rng_index * 2)):
            h.write_symbol(name, struct.pack('<H', value & 65535))
        h.write_symbol('ByteAttributeTable', bytes(256))
        h.write_symbol('ChildSpawnThrottle', b'\x00')
        if type_id == 0x21:
            address = h.m.linear('Type21PathCursor')
            data = struct.pack('<H', cursor)
            h.m.u.mem_write(address, data)
            ctypes.memmove(arena.base + address, data, 2)
        if boss:
            for name, value in (('SegBossAnchor', pool), ('SegBossPathCursor', cursor),
                                ('SegBossX', x), ('SegBossY', y)):
                h.write_symbol(name, struct.pack('<H', value & 65535))
            h.lib.steer_seg_boss_along_path()
        else:
            h.lib.run_type_handler(ctypes.c_void_p(h.state_addr + pool))
        ctypes.memmove(arena.base + h.m.data_frame * 16, h.state_storage.snapshot(), 65536)
        native_memory = arena.snapshot()
        h.m.call('SteerSegBossAlongPath' if boss else 'RunTypeHandler', {} if boss else {'BP': pool})
        h.compare(label)
        checkpoints._compare_arena(native_memory, bytes(h.m.u.mem_read(0, 0x100000)),
            h.m.data_frame * 16 + h.stack_lo, h.m.data_frame * 16 + h.stack_hi, label)
        count += 1
    for name, (start, capacity, path) in paths.items():
        if PATH_BINDINGS[name][1] != 'fly_off':
            continue
        type_id = ARCHETYPES[name]
        for level in range(7):
            for demo, last_row in ((0, False), (0, True), (1, False)):
                run(type_id, start, path['points'][0], f'{name} starter {level}/{demo}/{last_row}',
                    level=level, demo=demo, last_row=last_row)
        points = path['points'] + [{'x': path['end']['x'], 'y': K.LEADER_END_Y + 32}]
        for index, target in enumerate(points):
            for arrival in ((False, True) if index < len(path['points']) else (False,)):
                run(0x12, start + index * 4, target, f'{name} waypoint {index}/{arrival}', arrival=arrival)
    for name, (start, capacity, leader) in leaders.items():
        type_id = ARCHETYPES[name]
        stride = LEADER_BINDINGS[name][1]
        level = next(index for index, document in enumerate(documents) if name in document['leader_paths'])
        for index, step in enumerate(leader['steps']):
            for arrival, free in ((False, 5), (True, 0), (True, 3), (True, K.POOL_A_COUNT - 1)):
                run(type_id, start + index * stride, step['target'], f'{name} step {index}/{arrival}/{free}',
                    level=level, arrival=arrival, free=free, step=index)
        run(type_id, start + capacity - 4, {'x': leader['end']['x'], 'y': 30032},
            name + ' fly-off boundary', level=level, arrival=False)
    for name, type_id, level in (('sweep_lead_in', 0x18, 0), ('sweep_loop', 0x18, 0),
                                ('encounter_leader', 0x21, 4), ('boss_anchor', 0x76, 0)):
        start, capacity, path = paths[name]
        for index, target in enumerate(path['points']):
            for arrival in (False, True):
                for free in (0, 5):
                    run(type_id, start + index * 4, target, f'{name} step {index}/{arrival}/{free}',
                        level=level, arrival=arrival, free=free, difficulty=index % 3,
                        boss=name == 'boss_anchor')
        if path['end']['kind'] != 'continue':
            run(type_id, start + len(path['points']) * 4, {'x': 96, 'y': 128},
                name + ' control ending', level=level, boss=name == 'boss_anchor')
    start, _, sweep = paths['sweep_loop']
    random_start = h.offset('CreditRandomWords')
    for index in range(16):
        for difficulty in range(3):
            for free in (0, 5):
                run(0x18, start, sweep['points'][0],
                    f'sweep RNG {index}/difficulty {difficulty}/free {free}',
                    rng_index=index, difficulty=difficulty, free=free)
                next_word = struct.unpack_from('<H', h.baseline,
                    random_start + ((index + 1) % 16) * 2)[0]
                if next_word & 7 == 2 and difficulty == 0:
                    if h.m.word(2 + K.REC_DIRECTION) != K.DIR_DOWN:
                        raise AssertionError('throttled sweep failed to retain its stale-BX write')
    run(0x18, start, sweep['points'][0], 'sweep aimed-shot tick and waypoint arrival', tick=0x0C)
    run(0x18, start + (len(sweep['points']) - 1) * 4, {'x': 96, 'y': 128},
        'shortened loop jumps before retained trailing bytes', state=variants['shortened loop'])
    if h.m.word(pool + K.REC_PATH) != start:
        raise AssertionError('shortened loop did not jump to its own start')
    run(0x11, paths['path_follower_b'][0], {'x': 17, 'y': 65},
        'edited shared waypoint reaches native reader', state=variants['shared waypoint'])
    run(0x15, leaders['sweep_leader'][0], {'x': 17, 'y': 65},
        'edited leader target/follower reaches native reader', state=variants['leader target/follower'])
    child = pool + K.RECORD_SIZE
    if (h.m.word(child + K.REC_SAVED_X), h.m.word(child + K.REC_SAVED_Y)) != (33, 81):
        raise AssertionError('edited follower coordinate did not reach the spawned record')
    run(0x1F, leaders['slot_hopper_leader'][0], leaders['slot_hopper_leader'][2]['steps'][0]['target'],
        'edited slot reaches child target', level=1, state=variants['leader slot'])
    if (h.m.word(child + K.REC_SAVED_X), h.m.word(child + K.REC_SAVED_Y)) != (35, 83):
        raise AssertionError('edited slot did not reach the spawned record')
    run(0x76, paths['boss_anchor'][0], {'x': 17, 'y': 65},
        'edited boss waypoint reaches native reader', state=variants['boss waypoint'], boss=True)
    return count


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--no-build', action='store_true')
    args = parser.parse_args()
    if not args.no_build:
        import host
        host.build()
    harness = module('path_data_input', ROOT / 'tests/host/input.py')
    checkpoints = module('path_data_checkpoints', ROOT / 'tests/host/checkpoints.py')
    h = harness.HostHarness()
    documents = [load(path) for path in original_paths()]
    imported, variants = import_cases(h.m, documents)
    checkpoints._bind_native(h.lib)
    arena = checkpoints.Arena(h)
    executed = execution_cases(h, arena, checkpoints, documents, variants)
    print(f'PASS path data: {imported} import/validator checks, {executed} native/oracle execution cases')


if __name__ == '__main__':
    main()
