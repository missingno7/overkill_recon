"""Native map recipes against retained C handlers and the byte-exact ASM.

The first slice converts all level-1 cases and shared level-4/5 turrets/hatch.
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
    bad = []
    for field, value in (('tile', True), ('tile', 256), ('spawn', 'boss'),
            ('enemy', '0x24'), ('sprite', True), ('sprite', 65536),
            ('direction', 2), ('direction', 'center'), ('map_writes', {}),
            ('map_writes', [{'dx': 0, 'dy': 0, 'tile': 256}]),
            ('map_writes', [{'dx': False, 'dy': 0, 'tile': 1}])):
        edited = copy.deepcopy(documents)
        edited[1]['map_spawns'][0][field] = value
        bad.append((edited, None))
    edited = copy.deepcopy(documents)
    edited[1]['map_spawns'].append(copy.deepcopy(edited[1]['map_spawns'][0]))
    bad.append((edited, None))
    edited = copy.deepcopy(documents)
    edited[4]['map_spawns'][0]['tile'] = 0xCE
    bad.append((edited, 'outside the converted'))
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
    turret = copy.deepcopy(edited[1]['map_spawns'][4])
    turret['tile'] = 4
    edited[1]['map_spawns'][0] = turret
    edited[1]['map_spawns'].pop(1)
    edited[4]['map_spawns'] = [recipe for recipe in edited[4]['map_spawns'] if recipe['tile'] != 0xAC]
    edited[5]['map_spawns'] = [recipe for recipe in edited[5]['map_spawns'] if recipe['tile'] != 0xD3]
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
    return len(bad) + 3, alternate


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

    def setup(level, cell, off, x, free, alias, map_alias=False):
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
                ('GroupSlotPtr', 65535), ('MapScrollPos', 1300), ('MapRowCursor', off)):
            h.write_symbol(name, struct.pack('<H', value))
        h.write_symbol('GroupTable', bytes([0, 0xA5]) * 16)
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
            edited=False, oracle_cell=None):
        nonlocal count
        here, segment = setup(level, cell, off, x, free, alias, map_alias)
        label = f'level {level} cell {cell:02X} off {off:04X} x {x} free {free} alias {alias}/{map_alias}'
        if edited:
            continuation = ctypes.c_uint16(0xBEEF)
            handled = alternate.overkill_spawn_map_recipe(ctypes.c_void_p(h.state_addr + here),
                off, level << 8 | cell, ctypes.byref(continuation))
            if not handled:
                raise AssertionError('edited recipe was not selected')
            result = continuation.value
        else:
            result = lib.level_map_cell(ctypes.c_void_p(h.state_addr + here), off, level << 8 | cell)
        _, native_memory = snapshot()
        registers = h.m.call(f'Level{level}MapCell', {'AX': cell if oracle_cell is None else oracle_cell,
            'SI': off, 'BP': here, 'ES': segment})
        compare(label, native_memory)
        if result != registers['SI']:
            raise AssertionError(label + ': scan continuation offset changed')
        if not edited:
            # A second independent native execution retains the old C switches.
            setup(level, cell, off, x, free, alias, map_alias)
            old_result = getattr(lib, f'level{level}_map_cell')(ctypes.c_void_p(h.state_addr + here), off, cell)
            _, legacy_memory = snapshot()
            checkpoints._compare_arena(native_memory, legacy_memory,
                h.m.data_frame * 16 + h.stack_lo, h.m.data_frame * 16 + h.stack_hi, label + ' old/new C')
            if level == 0 and old_result != result:
                raise AssertionError('old/new native continuation differs')
        count += 1

    # All safe cells across all six handlers prove fallback/no-op selection, including
    # grouped holes and RNG/pickup cases that are intentionally not migrated yet.
    for level in range(6):
        for cell in range(256):
            if cell not in forbidden[level]:
                run(level, cell)
    for level in (1, 4, 5):
        for recipe in original_map_spawns(level):
            for off in (0, 1300, 0xFFFE, 0xFFFF):
                for x in (0, 96, 192, 65535):
                    for free in (0, 1, K.POOL_A_COUNT):
                        for alias in (False, True):
                            run(level, recipe['tile'], off, x, free, alias)
            for free in (0, 1):
                # Writes that alias MapCellX affect the subsequent initializer read.
                run(level, recipe['tile'], h.offset('MapCellX'), 96, free, False, True)
    run(1, 4, edited=True, oracle_cell=0xAC)
    run(1, 7, edited=True, oracle_cell=1)
    run(4, 0xAC, edited=True, oracle_cell=1)
    run(5, 0xD3, edited=True, oracle_cell=1)
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
    for level, cells in ((1, [4, 7, 0x6C, 0x6D, 0xAC, 0xB1, 0xC9]),
                         (4, [0xAC, 0xB1, 0xC9]), (5, [0xD3, 0xD2])):
        for free in (0, 2, K.POOL_A_COUNT):
            here, segment = setup(level, 1, 1300, 96, free, False)
            row = bytes((cells * 13)[:13])
            write_map(segment, 1300, row)
            lib.spawn_from_map_row(ctypes.c_void_p(h.state_addr + here))
            _, native_memory = snapshot()
            h.m.call('SpawnFromMapRow', {'SI': 1300, 'BP': here, 'ES': segment})
            compare(f'level {level} recipe row free {free}', native_memory)
            count += 1
    return count, 2


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
