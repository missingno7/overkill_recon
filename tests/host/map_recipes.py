"""Native map recipes against retained C handlers and the byte-exact ASM.

Fixed-field/grouped cases retain preparation, membership and mutation phases.
Compare complete DS/physical map memory and continuation offsets, including full
pools, stale records, aliases, wrapped map writes and row-scanner integration.
An alternate generated table proves structured edits reach the same evaluator.
"""
from pathlib import Path
import argparse
import copy
import ctypes
import os
import random
import struct
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
from level_format import load, original_paths, validate
from level_map_recipes import original_map_spawns, map_recipe_bindings, generate_map_recipe_header
from level_bindings import bind_level_documents
from world import K
import importlib.util


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(result)
    return result


def import_cases(h, documents):
    if bind_level_documents(h.m, documents) != h.baseline:
        raise AssertionError('map recipe import changes original DS')
    old = copy.deepcopy(documents)
    for document in old:
        del document['map_spawns']
    if map_recipe_bindings(old) != map_recipe_bindings(documents):
        raise AssertionError('earlier definitions no longer retain original recipes')
    version_one = copy.deepcopy(documents)
    expected_tiles = {1: [4, 7, 0x6C, 0x6D, 0xAC, 0xB1, 0xC9],
                      4: [0xAC, 0xB1, 0xC9], 5: [0xD2, 0xD3]}
    for level, document in enumerate(version_one):
        document['version'] = 1
        document['map_spawns'] = original_map_spawns(level, 1)
        if [recipe['tile'] for recipe in document['map_spawns']] != expected_tiles.get(level, []):
            raise AssertionError('version-1 recipe order/identities changed')
        validate(document)
    for level, (coverage, _) in enumerate(map_recipe_bindings(version_one)):
        expected = set(range(256)) if level == 1 else set(expected_tiles.get(level, []))
        if coverage != expected:
            raise AssertionError('version-1 converted scope changed')
    version_two = copy.deepcopy(documents)
    new_tiles = {0: {0xE1, 0xE2, 0xE5, 0xE6, 0xF0, 0xF1, 0xF4},
                 2: {0xC4, 0x5A}, 3: {0xCE, 0xCF, 0xD0, 0xD1, 0xD2, 0xD3, 0xD6, 0xD8},
                 4: {0xD4, 0xD7}, 5: {0xDE, 0xDF}}
    for level, document in enumerate(version_two):
        document['version'] = 2
        document['map_spawns'] = original_map_spawns(level, 2)
        validate(document)
    for level, ((old_scope, recipes), (scope, _)) in enumerate(zip(
            map_recipe_bindings(version_two), map_recipe_bindings(documents))):
        if old_scope != scope - new_tiles.get(level, set()) or len(recipes) != (15, 7, 0, 20, 17, 22)[level]:
            raise AssertionError('version-2 recipe identities/coverage changed')
    bad = []
    for field, value in (('tile', True), ('tile', 256), ('spawn', 'boss'),
            ('enemy', '0x24'), ('sprite', True), ('sprite', 65536),
            ('direction', 2), ('direction', 'center'), ('map_writes', {}),
            ('compatibility', {'map_group': True}),
            ('compatibility', {'map_group': 'join'}),
            ('map_writes', [{'dx': 0, 'dy': 0, 'tile': 256}]),
            ('map_writes', [{'dx': False, 'dy': 0, 'tile': 1}])):
        edited = copy.deepcopy(documents)
        edited[1]['map_spawns'][0][field] = value
        bad.append((edited, None))
    edited = copy.deepcopy(documents)
    edited[1]['map_spawns'].append(copy.deepcopy(edited[1]['map_spawns'][0]))
    bad.append((edited, None))
    facing = {'kind': 'center', 'right': {'sprite': 20, 'direction': 'left'},
              'at_or_left': {'sprite': 21, 'direction': 'right'}}
    for field, value in (('facing', []), ('facing', {**facing, 'kind': 'edge'}),
            ('facing', {**facing, 'right': {'direction': 'center'}}),
            ('facing', {**facing, 'at_or_left': {'direction': 'right', 'sprite': True}}),
            ('facing', {**facing, 'at_or_left': {}}),
            ('position_offset', {}), ('position_offset', {'dy': False}),
            ('position_offset', {'dy': -32769}), ('position_offset', {'dx': 32768}),
            ('position_offset', {'y': -6}),
            ('compatibility', {'direction_before_type': True})):
        edited = copy.deepcopy(documents)
        edited[1]['map_spawns'][0][field] = value
        bad.append((edited, None))
    for version in (1, 2):
        for field, value in (('facing', facing), ('position_offset', {'dy': -6})):
            edited = copy.deepcopy(documents)
            edited[1]['version'] = version
            edited[1]['map_spawns'][0][field] = value
            bad.append((edited, None))
    edited = copy.deepcopy(documents)
    edited[1]['map_spawns'][0].update(facing=facing, direction='up')
    bad.append((edited, None))
    edited = copy.deepcopy(documents)
    edited[4]['map_spawns'][0]['tile'] = 1
    bad.append((edited, 'outside the converted'))
    edited = copy.deepcopy(documents)
    edited[1]['map_spawns'][0] = {'tile': 4, 'spawn': 'none', 'map_writes': [],
        'compatibility': {'map_group': 'join_before_fields'}}
    bad.append((edited, None))
    edited = copy.deepcopy(documents)
    edited[1]['version'] = 1
    edited[1]['map_spawns'][0]['compatibility'] = {'map_group': 'allocate_only'}
    bad.append((edited, None))
    for edited, diagnostic in bad:
        try:
            if diagnostic is None:
                validate(edited[1])
            else:
                bind_level_documents(h.m, edited)
        except ValueError as error:
            if diagnostic is not None and diagnostic not in str(error):
                raise
        else:
            raise AssertionError('accepted invalid map recipe')
    # This alternative converts tile 4 to a known retained-cell volley turret,
    # disables tile 7, and gives the right turret a custom bank index/direction.
    edited = copy.deepcopy(documents)
    for level in (1, 4, 5):
        edited[level]['version'] = 1
        edited[level]['map_spawns'] = original_map_spawns(level, 1)
    # Older explicit empty lists leave the version-3 center/plunger slice procedural.
    edited[2]['version'], edited[2]['map_spawns'] = 2, []
    turret = copy.deepcopy(edited[1]['map_spawns'][4])
    turret['tile'] = 4
    edited[1]['map_spawns'][0] = turret
    edited[1]['map_spawns'].pop(1)
    edited[4]['map_spawns'] = [recipe for recipe in edited[4]['map_spawns'] if recipe['tile'] != 0xAC]
    edited[5]['map_spawns'] = [recipe for recipe in edited[5]['map_spawns'] if recipe['tile'] != 0xD3]
    for recipe in edited[3]['map_spawns']:
        if recipe['tile'] == 0xE1:
            # The member becomes an allocation-only spawn, like the neighboring
            # ordinary walker. Drop lookup still occurs before clearing the cell.
            recipe['enemy'] = 'climbing_walker_a'
            recipe['compatibility']['map_group'] = 'allocate_only'
        if recipe['tile'] == 0xCE:
            recipe['facing'] = {'kind': 'center',
                'right': {'sprite': 321, 'direction': 'up_left'},
                'at_or_left': {'sprite': 654, 'direction': 'down_right'}}
            recipe['position_offset'] = {'dx': 7, 'dy': -24}
        if recipe['tile'] == 0xD4:
            recipe['position_offset'] = {'dy': -23}
        if recipe['tile'] == 0xD6:
            # A one-sided sprite override must retain the initializer's stale
            # sprite on the other side; absence is not a zero-valued default.
            recipe['facing']['at_or_left']['sprite'] = 999
    # A version-1 level keeps the original narrower scope. Its explicit list
    # must not disable newly converted version-2 cells when the game is rebuilt.
    edited[0]['version'] = 1
    edited[0]['map_spawns'] = original_map_spawns(0, 1)
    coverage, _ = map_recipe_bindings(edited)[0]
    if coverage:
        raise AssertionError('version-1 empty recipe list acquired version-2 coverage')
    for recipe in edited[1]['map_spawns']:
        if recipe['tile'] == 0x6D:
            recipe['sprite'], recipe['direction'] = 321, 'up'
        if recipe['tile'] == 0xC9:
            # Repeated writes demonstrate that the definition is an ordered list.
            recipe['map_writes'].extend([{'dx': 0, 'dy': 0, 'tile': 60},
                                         {'dx': 0, 'dy': 0, 'tile': 61}])
    for document in edited:
        validate(document)
    out = ROOT / 'build/host-map-recipes'
    out.mkdir(parents=True, exist_ok=True)
    generate_map_recipe_header(out, edited)
    library = out / ('EDITED_MAP_RECIPES.dll' if os.name == 'nt' else 'libedited_map_recipes.so')
    command = [os.environ.get('CC', 'gcc'), '-std=c11', '-O2', '-Wall', '-Wextra', '-Werror',
               '-Wno-unknown-pragmas', '-fno-strict-aliasing', '-DOVERKILL_HOST', '-shared',
               '-I' + str(out), '-I' + str(ROOT / 'build/host'), '-I' + str(ROOT / 'c'),
               '-I' + str(ROOT / 'host'), str(ROOT / 'host/map_recipes.c'),
               '-L' + str(ROOT / 'build/host'), '-loverkill_core', '-o', str(library)]
    if os.name != 'nt':
        command += ['-fPIC', '-Wl,-rpath,' + str(ROOT / 'build/host')]
    subprocess.run(command, check=True)
    alternate = ctypes.CDLL(str(library))
    alternate.overkill_spawn_map_recipe.argtypes = (ctypes.c_void_p, ctypes.c_uint16,
        ctypes.c_uint16, ctypes.POINTER(ctypes.c_uint16))
    alternate.overkill_spawn_map_recipe.restype = ctypes.c_int
    return len(bad) + 6, alternate


def execution_cases(h, arena, checkpoints, alternate):
    lib = h.lib
    lib.level_map_cell.argtypes = (ctypes.c_void_p, ctypes.c_uint16, ctypes.c_uint16)
    lib.level_map_cell.restype = ctypes.c_uint16
    lib.spawn_from_map_row.argtypes = (ctypes.c_void_p,)
    lib.spawn_from_map_row.restype = None
    for level in range(6):
        fn = getattr(lib, f'level{level}_map_cell')
        fn.argtypes = (ctypes.c_void_p, ctypes.c_uint16, ctypes.c_uint8)
        fn.restype = ctypes.c_uint16 if level == 0 else None
    rng = random.Random(0x4D4150)
    memory = bytearray(arena.image)
    map_base = arena.map_segment << 4
    memory[map_base:map_base + 65536] = rng.randbytes(65536)
    stale = rng.randbytes(K.POOL_A_COUNT * K.RECORD_SIZE)
    pool = h.offset('PoolA')
    cursor = pool + (K.POOL_A_COUNT - 1) * K.RECORD_SIZE
    forbidden = {0: {0xFA, 0xFB}, 1: set(), 2: set(), 3: {0xEA, 0xEB},
                 4: {0xE1, 0xE2}, 5: {0xF0, 0xF1}}
    count = 0

    def write_map(segment, off, data):
        for index, value in enumerate(data):
            address = ((segment << 4) + ((off + index) & 65535)) & 0xFFFFF
            state_offset = (address - (h.m.data_frame << 4)) & 0xFFFFF
            if state_offset < 65536:
                h.write(state_offset, bytes([value]))
            else:
                h.m.u.mem_write(address, bytes([value]))
                ctypes.memmove(arena.base + address, bytes([value]), 1)

    def setup(level, cell, off, x, free, alias, map_alias=False, drop=None, groups='free'):
        h.reset()
        h.m.u.mem_write(0, bytes(memory))
        h.m.set_state(h.baseline)
        h.state_storage.load(h.baseline)
        arena.load(bytes(memory))
        h.write(pool, stale)
        for index in range(K.POOL_A_COUNT):
            is_free = (index - (K.POOL_A_COUNT - 1)) % K.POOL_A_COUNT < free
            h.write(pool + index * K.RECORD_SIZE, struct.pack('<H', 0 if is_free else 1))
        for name, value in (('PoolACursor', cursor), ('MapCellX', x), ('LevelIndex', level),
                ('RandomWordCursor', h.offset('CreditRandomWords')), ('GroupSlotIndex', 0xBEEF),
                ('GroupDropKind', 0xABCD),
                ('GroupSlotPtr', 65535), ('MapScrollPos', 1300), ('MapRowCursor', off)):
            h.write_symbol(name, struct.pack('<H', value))
        group_bytes = bytes(value for index in range(16) for value in (
            0 if groups == 'free' or groups == 'last_free' and index == 15 or
                 groups == 'mixed' and index == 3 else 3, 0xA5))
        h.write_symbol('GroupTable', group_bytes)
        if drop is not None:
            h.write(h.offset('GroupDropKinds') + (off & 63), bytes([drop]))
        h.write_symbol('PrimaryRecord', checkpoints._record(x=0x1357, y=0x2468))
        here = cursor if alias else h.offset('PrimaryRecord')
        segment = h.m.data_frame if map_alias else arena.map_segment
        address = h.m.linear('LevelMapSegment')
        data = struct.pack('<H', segment)
        h.m.u.mem_write(address, data)
        ctypes.memmove(arena.base + address, data, 2)
        # Even the ordinary map segment reaches DS for sufficiently high offsets.
        # Populate the same physical alias that the native memory resolver uses.
        write_map(segment, off, bytes([cell]))
        return here, segment

    def snapshot():
        ctypes.memmove(arena.base + h.m.data_frame * 16, h.state_storage.snapshot(), 65536)
        return h.state_storage.snapshot(), arena.snapshot()

    def compare(label, native_memory):
        h.compare(label)
        checkpoints._compare_arena(native_memory, bytes(h.m.u.mem_read(0, 0x100000)),
            h.m.data_frame * 16 + h.stack_lo, h.m.data_frame * 16 + h.stack_hi, label)

    def run(level, cell, off=1300, x=96, free=3, alias=False, map_alias=False,
            edited=False, oracle_cell=None, drop=None, groups='free', expected_fields=()):
        nonlocal count
        here, segment = setup(level, cell, off, x, free, alias, map_alias, drop, groups)
        label = (f'level {level} cell {cell:02X} off {off:04X} x {x} free {free} '
                 f'alias {alias}/{map_alias} drop {drop} groups {groups}')
        if edited:
            continuation = ctypes.c_uint16(0xBEEF)
            handled = alternate.overkill_spawn_map_recipe(ctypes.c_void_p(h.state_addr + here),
                off, level << 8 | cell, ctypes.byref(continuation))
            if not handled:
                raise AssertionError('edited recipe was not selected')
            result = continuation.value
        else:
            result = lib.level_map_cell(ctypes.c_void_p(h.state_addr + here), off, level << 8 | cell)
        native_state, native_memory = snapshot()
        registers = h.m.call(f'Level{level}MapCell', {'AX': cell if oracle_cell is None else oracle_cell,
            'SI': off, 'BP': here, 'ES': segment})
        # Authored parameters change only declared record outputs. Assert the
        # original words before editing the expectation; every other byte,
        # including saved coordinates, allocation, map and RNG, must still agree.
        for field, old, new in expected_fields:
            at = cursor + getattr(K, 'REC_' + field.upper())
            if struct.unpack('<H', h.m.read(at, 2))[0] != old:
                raise AssertionError(label + ': unexpected oracle ' + field)
            h.m.write(at, struct.pack('<H', new))
        compare(label, native_memory)
        if result != registers['SI']:
            raise AssertionError(label + ': scan continuation offset changed')
        if not edited:
            # A second independent native execution retains the old C switches.
            setup(level, cell, off, x, free, alias, map_alias, drop, groups)
            old_result = getattr(lib, f'level{level}_map_cell')(ctypes.c_void_p(h.state_addr + here), off, cell)
            _, legacy_memory = snapshot()
            checkpoints._compare_arena(native_memory, legacy_memory,
                h.m.data_frame * 16 + h.stack_lo, h.m.data_frame * 16 + h.stack_hi, label + ' old/new C')
            if level == 0 and old_result != result:
                raise AssertionError('old/new native continuation differs')
        count += 1
        return native_state

    # All safe cells across all six handlers prove fallback/no-op selection, including
    # grouped holes and RNG/pickup cases whose procedural selection is retained.
    for level in range(6):
        for cell in range(256):
            if cell not in forbidden[level]:
                run(level, cell)
    for level in range(6):
        for recipe in original_map_spawns(level):
            for off in (0, 1300, 0xFFFE, 0xFFFF):
                for x in (0, 96, 192, 65535):
                    for free in (0, 1, K.POOL_A_COUNT):
                        for alias in (False, True):
                            run(level, recipe['tile'], off, x, free, alias)
            if 'facing' in recipe:
                for x in (95, 96, 97, 32768):
                    for free in (0, 1):
                        run(level, recipe['tile'], x=x, free=free, drop=4, groups='mixed')
            for free in (0, 1):
                # Setup's incoming tile byte aliases MapCellX. Center-facing
                # triggers exceed 96; clearing crosses from the right side to 1
                # before initialization and facing read that updated live value.
                run(level, recipe['tile'], h.offset('MapCellX'), 96, free, False, True)
            if 'compatibility' in recipe:
                for drop in (0, 1, 4, 255):
                    for groups in ('free', 'full', 'last_free', 'mixed'):
                        for free in (0, 1, K.POOL_A_COUNT):
                            run(level, recipe['tile'], drop=drop, groups=groups, free=free)
    for off in range(1280, 1344):
        run(3, 0xE1, off=off, groups='mixed')
    # A map write into the live drop word occurs after group preparation but
    # before joining. Membership must use the changed word, not a cached drop.
    for free in (0, 1):
        state = run(3, 0xE1, off=h.offset('GroupDropKind'), map_alias=True,
                    drop=4, groups='mixed', free=free)
        if free and state[h.offset('GroupTable') + 7] != 1:
            raise AssertionError('group membership cached drop before the aliased map clear')
    # Pin the real no-spawn hole: allocation changes globals but not the pool,
    # selected group bytes or map. Clear-only cells have the same preparation.
    for level, cell in ((3, 0xDF), (0, 0xF5), (5, 0xE1), (5, 0xE2)):
        state = run(level, cell, drop=4, groups='last_free', free=K.POOL_A_COUNT)
        expected_pool = bytearray(stale)
        for index in range(K.POOL_A_COUNT):
            struct.pack_into('<H', expected_pool, index * K.RECORD_SIZE, 0)
        if state[pool:pool + len(stale)] != expected_pool:
            raise AssertionError('no-spawn cell changed the record pool')
        selected = h.offset('GroupTable') + 30
        if struct.unpack_from('<H', state, h.offset('GroupSlotIndex'))[0] != 15 or state[selected:selected + 2] != b'\x00\xa5':
            raise AssertionError('allocation-only cell claimed or rewrote the selected group')
    run(1, 4, edited=True, oracle_cell=0xAC)
    run(1, 7, edited=True, oracle_cell=1)
    run(4, 0xAC, edited=True, oracle_cell=1)
    run(5, 0xD3, edited=True, oracle_cell=1)
    run(3, 0xE1, edited=True, oracle_cell=0xDE, drop=4, groups='mixed')
    here, _ = setup(0, 0xE8, 1300, 96, 1, False, drop=4)
    result = ctypes.c_uint16(0xBEEF)
    if alternate.overkill_spawn_map_recipe(ctypes.c_void_p(h.state_addr + here), 1300,
            0x00E8, ctypes.byref(result)) != 0 or result.value != 0xBEEF:
        raise AssertionError('version-1 level intercepted a newly converted group cell')
    for cell in (0xC4, 0x5A):
        here, _ = setup(2, cell, 1300, 96, 1, False)
        before = snapshot()
        result = ctypes.c_uint16(0xBEEF)
        if alternate.overkill_spawn_map_recipe(ctypes.c_void_p(h.state_addr + here), 1300,
                0x0200 | cell, ctypes.byref(result)) != 0 or result.value != 0xBEEF or snapshot() != before:
            raise AssertionError('version-2 empty list intercepted a version-3 cell')
    # Facing uses the initialized X before the authored +7 pixel shift. At X=96
    # the left tuple wins even though the final coordinate is on the right side.
    for x, old_sprite, old_direction, sprite, direction in (
            (95, 0xDA, K.DIR_RIGHT, 654, K.DIR_DOWN_RIGHT),
            (96, 0xDA, K.DIR_RIGHT, 654, K.DIR_DOWN_RIGHT),
            (97, 0xC8, K.DIR_LEFT, 321, K.DIR_UP_LEFT),
            (65535, 0xC8, K.DIR_LEFT, 321, K.DIR_UP_LEFT)):
        run(3, 0xCE, x=x, free=1, edited=True, drop=4, groups='mixed', expected_fields=(
            ('sprite', old_sprite, sprite), ('direction', old_direction, direction),
            ('x', x, (x + 7) & 65535), ('y', 16, 65528)))
    run(3, 0xCE, x=96, free=0, edited=True, drop=4, groups='mixed')
    run(3, 0xD4, free=1, edited=True, expected_fields=(('y', 16, 65529),))
    previous_sprite = struct.unpack_from('<H', stale,
        (K.POOL_A_COUNT - 1) * K.RECORD_SIZE + K.REC_SPRITE)[0]
    run(3, 0xD6, x=96, free=1, edited=True,
        expected_fields=(('sprite', previous_sprite, 999),))
    run(3, 0xD6, x=97, free=1, edited=True)
    # Test custom properties directly; the oracle contains no such authored recipe.
    here, _ = setup(1, 0x6D, 1300, 96, 1, False)
    result = ctypes.c_uint16()
    alternate.overkill_spawn_map_recipe(ctypes.c_void_p(h.state_addr + here), 1300,
        0x016D, ctypes.byref(result))
    state = h.state_storage.snapshot()
    if struct.unpack_from('<H', state, cursor + K.REC_SPRITE)[0] != 321 or struct.unpack_from(
            '<H', state, cursor + K.REC_DIRECTION)[0] != K.DIR_UP:
        raise AssertionError('authored sprite/direction did not reach native record')
    here, _ = setup(1, 0xC9, 1300, 96, 0, False)
    alternate.overkill_spawn_map_recipe(ctypes.c_void_p(h.state_addr + here), 1300,
        0x01C9, ctypes.byref(result))
    if ctypes.string_at(arena.base + map_base + 1300, 1) != bytes([61]):
        raise AssertionError('authored repeated map writes did not retain source order')
    # Row-level integration observes incoming-cell mutations and allocation order.
    for level, cells in ((0, [0xE1, 0xE5, 0xE8, 0xF4, 0xF7, 0xF8]),
                         (1, [4, 7, 0x6C, 0x6D, 0xAC, 0xB1, 0xC9]),
                         (2, [0xC4, 0x5A, 0xC4, 0x30, 0x5A]),
                         (3, [0xCE, 0xD0, 0xD2, 0xD6, 0xDF, 0xE1, 0xD8]),
                         (4, [0xAC, 0xB1, 0xC9, 0xD4, 0xD7, 0xDF]),
                         (5, [0xD3, 0xD2, 0xD9, 0xDE, 0xDF, 0xE1, 0xE8])):
        for free in (0, 2, K.POOL_A_COUNT):
            here, segment = setup(level, 1, 1300, 96, free, False)
            row = bytes((cells * 13)[:13])
            write_map(segment, 1300, row)
            lib.spawn_from_map_row(ctypes.c_void_p(h.state_addr + here))
            _, native_memory = snapshot()
            h.m.call('SpawnFromMapRow', {'SI': 1300, 'BP': here, 'ES': segment})
            compare(f'level {level} recipe row free {free}', native_memory)
            count += 1
    return count, 11


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--no-build', action='store_true')
    args = parser.parse_args()
    if not args.no_build:
        import host
        host.build()
    harness = module('map_recipes_input', ROOT / 'tests/host/input.py')
    checkpoints = module('map_recipes_checkpoints', ROOT / 'tests/host/checkpoints.py')
    h = harness.HostHarness()
    documents = [load(path) for path in original_paths()]
    imported, alternate = import_cases(h, documents)
    checkpoints._bind_native(h.lib)
    arena = checkpoints.Arena(h)
    executed, authored = execution_cases(h, arena, checkpoints, alternate)
    print(f'PASS map recipes: {imported} import/validator checks, {executed} native/oracle '
          f'cases (direct cells also compare retained C), {authored} authored-data checks')


if __name__ == '__main__':
    main()
