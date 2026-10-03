"""Structured timelines/formations and their unchanged native execution vs ASM.

Every original event is tested with free, partial and full pools using stale
records. Comparisons include the complete DS and physical arena (except stack).
No gameplay loop or enemy behavior rewrite is involved.
"""
from pathlib import Path
import argparse
import copy
import ctypes
import random
import struct
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from level_format import load, original_paths, validate
from level_bindings import bind_level_documents
from export_original_levels import script_event_boundaries, source_formations
from world import K
import importlib.util


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


def import_cases(machine, documents):
    original = machine.state()
    bindings = source_formations(machine)
    bad = []
    for field, value in (('enemy', '0x34'), ('size', 1), ('layer', 'background'),
                         ('members', []), ('members', [{'dx': True, 'dy': 0}])):
        edited = copy.deepcopy(documents)
        name = edited[0]['timeline'][0]['formation']
        edited[0]['formations'][name][field] = value
        bad.append((edited, None))
    for field, value in (('clock', True), ('clock', 65535), ('x', 32768), ('y', -32769),
                         ('formation', 'missing'), ('group', {'drop': 'missile'}),
                         ('compatibility', {'clear_event_marker': 1})):
        edited = copy.deepcopy(documents)
        edited[0]['timeline'][0][field] = value
        bad.append((edited, None))
    edited = copy.deepcopy(documents)
    edited[0]['timeline'][1]['clock'] = 273
    bad.append((edited, None))
    edited = copy.deepcopy(documents)
    del edited[0]['formations']
    bad.append((edited, None))
    edited = copy.deepcopy(documents)
    edited[0]['timeline'].append(copy.deepcopy(edited[0]['timeline'][-1]))
    bad.append((edited, 'timeline exceeds'))
    edited = copy.deepcopy(documents)
    name = edited[0]['timeline'][0]['formation']
    edited[0]['formations'][name]['members'].append({'dx': 0, 'dy': 0})
    bad.append((edited, 'formation exceeds'))
    edited = copy.deepcopy(documents)
    name = edited[0]['timeline'][1]['formation']
    edited[0]['formations'][name]['members'][0]['dx'] = 1
    bad.append((edited, 'conflicting shared formation'))
    edited = copy.deepcopy(documents)
    edited[0]['timeline'][0]['group']['drop'] = 'fuel'
    bad.append((edited, 'conflicting shared group drop'))
    for edited, diagnostic in bad:
        try:
            if diagnostic is None:
                validate(edited[0])
            else:
                bind_level_documents(machine, edited)
        except ValueError as error:
            if diagnostic is not None and diagnostic not in str(error):
                raise
        else:
            raise AssertionError('accepted malformed/conflicting timeline definition')
    earlier = copy.deepcopy(documents)
    for document in earlier:
        del document['formations'], document['timeline']
    if bind_level_documents(machine, earlier) != original:
        raise AssertionError('earlier checkpoint profile changes the original timeline')
    edited = copy.deepcopy(documents)
    name = edited[0]['timeline'][0]['formation']
    edited[0]['timeline'][0]['x'] = 176
    edited[0]['formations'][name]['enemy'] = 'slow_descender'
    edited[0]['formations'][name]['members'][0]['dx'] = 8
    bound = bind_level_documents(machine, edited)
    event_start = machine.offset('LevelScript0')
    formation_start = bindings[name][0]
    allowed = {event_start + 4, event_start + 5,
               formation_start + 4, formation_start + 5, formation_start + 8, formation_start + 9}
    changed = {i for i, (a, b) in enumerate(zip(original, bound)) if a != b}
    if not changed or not changed <= allowed:
        raise AssertionError('structured timeline/formation edit crosses its byte boundary')
    marked = copy.deepcopy(documents)
    del marked[2]['timeline'][1]['compatibility']
    shifted = bind_level_documents(machine, marked)
    slot = machine.offset('LevelCheckpointPtrs') + 4
    start = struct.unpack_from('<H', original, slot)[0]
    for index in range(4):
        old = struct.unpack_from('<H', original, start + index * 8 + 4)[0]
        new = struct.unpack_from('<H', shifted, start + index * 8 + 4)[0]
        if new != old - (2 if index else 0):
            raise AssertionError('marker edit failed to relocate checkpoint event cursors')
    end = script_event_boundaries(machine, 2)[-1] + 2
    if shifted[end - 2:end] != original[end - 2:end]:
        raise AssertionError('shortened script erased original trailing bytes')
    drops = copy.deepcopy(documents)
    for document in drops:
        for event in document['timeline']:
            if event['clock'] & 0x3F == 16:
                event['group']['drop'] = 'fuel'
    drop_state = bind_level_documents(machine, drops)
    changed = {i for i, (a, b) in enumerate(zip(original, drop_state)) if a != b}
    if changed != {machine.offset('GroupDropKinds') + 16}:
        raise AssertionError('consistent semantic drop edit crosses its shared table cell')
    return len(bad) + 4, bound, shifted, drop_state


def execution_cases(h, arena, checkpoints, documents, edited, shifted, drop_state):
    lib = h.lib
    lib.run_level_script_events.argtypes = ()
    lib.run_level_script_events.restype = None
    # Baselines include physical MAIN data for reset_type21_path and a readable
    # map for under-terrain column snapping. All map cells are open here.
    memory = bytearray(arena.image)
    map_base = arena.map_segment << 4
    memory[map_base:map_base + 65536] = bytes([1]) * 65536
    pool = h.offset('PoolA')
    random_bytes = random.Random(0x53444C).randbytes(K.POOL_A_COUNT * K.RECORD_SIZE)
    count = 0
    def run(level, cursor, clock, free, label, state=None, writes=(), groups_full=False):
        nonlocal count
        h.reset()
        h.m.u.mem_write(0, bytes(memory))
        h.m.set_state(state or h.baseline)
        h.state_storage.load(state or h.baseline)
        arena.load(bytes(memory))
        h.write(pool, random_bytes)
        for index in range(K.POOL_A_COUNT):
            # Use free records on both sides of the round-robin wrap.
            status = 0 if (index - (K.POOL_A_COUNT - 2)) % K.POOL_A_COUNT < free else 1
            h.write(pool + index * K.RECORD_SIZE, struct.pack('<H', status))
        for name, value in (('LevelIndex', level), ('LevelScriptClock', clock),
                            ('PoolACursor', pool + (K.POOL_A_COUNT - 2) * K.RECORD_SIZE),
                            ('GroupSlotIndex', 0xBEEF), ('GroupSlotPtr', 0xFFFF),
                            ('MapScrollPos', 100 * K.MAP_ROW_BYTES)):
            h.write_symbol(name, struct.pack('<H', value))
        h.write(h.offset('LevelScriptCursors') + 2 * (level & 0x7FFF), struct.pack('<H', cursor))
        h.write_symbol('GroupTable', bytes((1 if groups_full else 0, 0xA5)) * 16)
        h.write_symbol('ByteAttributeTable', bytes(256))
        h.write_symbol('EventMarkerFlag', b'\xa5')
        for offset, data in writes:
            h.write(offset, data)
        lib.run_level_script_events()
        ctypes.memmove(arena.base + h.m.data_frame * 16, h.state_storage.snapshot(), 65536)
        native_memory = arena.snapshot()
        h.m.call('RunLevelScriptEvents')
        h.compare(label)
        checkpoints._compare_arena(native_memory, bytes(h.m.u.mem_read(0, 0x100000)),
                                   h.m.data_frame * 16 + h.stack_lo,
                                   h.m.data_frame * 16 + h.stack_hi, label)
        count += 1
    for level, document in enumerate(documents):
        boundaries = script_event_boundaries(h.m, level)
        for index, event in enumerate(document['timeline']):
            for free in (K.POOL_A_COUNT, 3, 0):
                run(level, boundaries[index], event['clock'], free,
                    f'level {level} event {index} free {free}', groups_full=(index % 3 == 0))
        # Both sides of equality preserve the pending event, including late clocks.
        for clock in (0, 273, 271, 65535):
            run(level, boundaries[0], clock, K.POOL_A_COUNT, f'nonmatching clock {level}/{clock}')
        run(level, boundaries[-1], 65535, K.POOL_A_COUNT, f'terminator level {level}')
        run(level + 0x8000, boundaries[0], document['timeline'][0]['clock'],
            K.POOL_A_COUNT, f'wrapped timeline level {level}')
    run(0, h.offset('LevelScript0'), 272, K.POOL_A_COUNT, 'structured event/preset/member edit', state=edited)
    actor = pool + (K.POOL_A_COUNT - 2) * K.RECORD_SIZE
    if h.m.word(actor + K.REC_TYPE) != 0x27 or h.m.word(actor + K.REC_X) != 184:
        raise AssertionError('structured edit did not reach the spawned record')
    # A marker removal changes framing and moves every later event cursor.
    run(2, h.offset('LevelScript2') + 8, 271, K.POOL_A_COUNT, 'structured marker removal', state=shifted)
    run(0, h.offset('LevelScript0'), 272, K.POOL_A_COUNT, 'consistent structured group drop edit', state=drop_state)
    if h.m.read(h.offset('GroupTable'), 2) != b'\x01\x04':
        raise AssertionError('semantic fuel drop did not reach the allocated group')
    scratch, form = 0x400, h.offset('Formation00')
    words = (64, 65535, form, 17, 0, 64, form, 17, 0, 63, form, 17, 0, 65535)
    script = struct.pack('<' + 'H' * len(words), *words)
    for members in (0, 1, 5):
        for free in (0, 3, K.POOL_A_COUNT):
            for drop, groups_full in ((0, False), (2, False), (2, True)):
                writes = [(scratch, script), (form, struct.pack('<4H', 1, 1, 0x31, members)),
                          (h.offset('GroupDropKinds'), bytes([drop]))]
                run(0, scratch, 64, free, f'count {members} free {free} drop {drop} full {groups_full}',
                    writes=writes, groups_full=groups_full)
                if h.m.word(h.offset('LevelScriptCursors')) != scratch + 18:
                    raise AssertionError('equal-clock events did not consume before allocation')
                if h.m.read(h.offset('EventMarkerFlag'), 1) != b'\x01':
                    raise AssertionError('marker state did not follow the last consumed event')
                lib.run_level_script_events()
                h.m.call('RunLevelScriptEvents')
                h.compare('same-clock second call leaves the next trigger pending')
                if h.m.word(h.offset('LevelScriptCursors')) != scratch + 18:
                    raise AssertionError('a missed trigger was incorrectly caught up')
                count += 1
    return count


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--no-build', action='store_true')
    args = parser.parse_args()
    if not args.no_build:
        import host
        host.build()
    harness = module('timeline_input', ROOT / 'tests/host/input.py')
    checkpoints = module('timeline_checkpoints', ROOT / 'tests/host/checkpoints.py')
    h = harness.HostHarness()
    documents = [load(path) for path in original_paths()]
    imported, edited, shifted, drop_state = import_cases(h.m, documents)
    checkpoints._bind_native(h.lib)
    arena = checkpoints.Arena(h)
    executed = execution_cases(h, arena, checkpoints, documents, edited, shifted, drop_state)
    events = sum(len(document['timeline']) for document in documents)
    forms = {name for document in documents for name in document['formations']}
    print(f'PASS timelines: {events} original events, {len(forms)} referenced formations, '
          f'{imported} import/validator checks, {executed} native/oracle execution cases')


if __name__ == '__main__':
    main()
