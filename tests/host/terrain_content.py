"""Owned tile properties, exact original initialization and collision semantics.

Run against an existing full native build. No shared artifacts are rebuilt.
"""
from pathlib import Path
import copy
import ctypes
import struct
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT / 'tools'))
sys.path.append(str(ROOT / 'tests/host'))

from common import write_json
from level_content import duplicate_original, validate_directory
from level_format import TILE_ATTRIBUTES
from emu import REG, FLAG
from unicorn import UC_HOOK_CODE
from world import K
import level_content_runtime as loader


def bind(h):
    lib = h.lib
    lib.overkill_level_terrain_current.argtypes = ()
    lib.overkill_level_terrain_current.restype = ctypes.c_void_p
    lib.overkill_initialize_tile_attributes.argtypes = (ctypes.c_uint16,)
    lib.overkill_initialize_tile_attributes.restype = None
    lib.map_attribute.argtypes = (ctypes.c_uint16,)
    lib.map_attribute.restype = ctypes.c_uint16
    lib.probe_ship_terrain_collision.argtypes = (ctypes.c_void_p,)
    lib.probe_ship_terrain_collision.restype = ctypes.c_uint16
    lib.shot_bounds_check.argtypes = (ctypes.c_void_p,)
    lib.shot_bounds_check.restype = None
    return loader._bind_content_api(h)


def load(h, directory):
    validate_directory(directory)
    ok, error = loader._load(h, directory)
    if not ok:
        raise AssertionError(error)


def expected(document):
    table = bytearray([TILE_ATTRIBUTES[document['terrain']['default']]]) * 256
    for patch in document['terrain']['attribute_patches']:
        table[patch['tile']] = TILE_ATTRIBUTES[patch['attribute']]
    return bytes(table)


def table(h):
    start = h.offset('ByteAttributeTable')
    return h.state_storage.snapshot()[start:start + 256]


def reset(h, arena):
    h.m.u.mem_write(0, arena.image)
    h.reset()
    arena.load(bytes(h.m.u.mem_read(0, loader.checkpoints.DOS_MEMORY_BYTES)))


def compare_arena(h, arena, native, label):
    ctypes.memmove(arena.base + h.m.data_frame * 16, native, 65536)
    loader.checkpoints._compare_arena(
        arena.snapshot(), bytes(h.m.u.mem_read(0, loader.checkpoints.DOS_MEMORY_BYTES)),
        h.m.data_frame * 16 + h.stack_lo, h.m.data_frame * 16 + h.stack_hi, label)


def original_cases(h, arena, work):
    def stop_at_map_stage(u, _pc, _size, _data):
        sp, ss = u.reg_read(REG['SP']), u.reg_read(REG['SS'])
        ip = int.from_bytes(bytes(u.mem_read(ss * 16 + sp, 2)), 'little')
        u.reg_write(REG['SP'], (sp + 2) & 65535)
        u.reg_write(REG['IP'], ip)
    at = h.m.linear('AttributePatchesDone')
    hook = h.m.u.hook_add(UC_HOOK_CODE, stop_at_map_stage, begin=at, end=at)
    count = 0
    try:
        for profile in range(6):
            directory = work / f'original-{profile}'
            document = duplicate_original(profile, directory, f'terrain_original_{profile}')
            load(h, directory)
            provider = h.lib.overkill_level_terrain_current()
            if not provider or ctypes.string_at(provider, 256) != expected(document):
                raise AssertionError('original owned terrain differs from source definition')
            for seed in (bytes(range(256)), bytes([0xA5]) * 256):
                for binding in (h.offset('AttributePatchPointers') + profile * 2, 65535):
                    reset(h, arena)
                    h.write_symbol('LevelIndex', struct.pack('<H', profile))
                    h.write_symbol('ByteAttributeTable', seed)
                    h.lib.overkill_initialize_tile_attributes(binding)
                    native = h.state_storage.snapshot()
                    h.m.call('InitializeByteAttributes')
                    h.compare(f'owned original terrain {profile} binding {binding}')
                    compare_arena(h, arena, native, f'owned original terrain {profile}')
                    count += 1
    finally:
        h.m.u.hook_del(hook)
    return count


def authored_cases(h, arena, work):
    directory = work / 'authored'
    document = duplicate_original(4, directory, 'authored_terrain')
    # Exceed the original stream capacity and cover every byte-valued tile,
    # including FF. Repeated overrides use their final semantic value.
    document['terrain']['attribute_patches'] = [
        {'tile': tile, 'attribute': name}
        for name in TILE_ATTRIBUTES for tile in range(256)] + [
        {'tile': 11, 'attribute': 'open'}, {'tile': 12, 'attribute': 'wall'},
        {'tile': 13, 'attribute': 'shot_permeable_wall'},
        {'tile': 255, 'attribute': 'open'}, {'tile': 108, 'attribute': 'open'}]
    write_json(directory / 'level.json', document)
    load(h, directory)
    wanted = expected(document)
    count = 0
    for index in (0, 4, 6, 65535):
        reset(h, arena)
        h.write_symbol('LevelIndex', struct.pack('<H', index))
        h.lib.overkill_initialize_tile_attributes(65535)
        if table(h) != wanted:
            raise AssertionError('authored terrain used a legacy level or binding')
        baseline = h.state_storage.snapshot()
        pointers = h.offset('AttributePatchPointers')
        source = struct.unpack_from('<H', h.baseline, pointers + 8)[0]
        poison = ((pointers, bytes([0xCC]) * 12), (source, bytes([0xDD]) * 32))
        for at, payload in poison:
            h.write(at, payload)
        h.write_symbol('ByteAttributeTable', bytes(256))
        h.lib.overkill_initialize_tile_attributes(65535)
        predicted = bytearray(baseline)
        for at, payload in poison:
            predicted[at:at + len(payload)] = payload
        if h.state_storage.snapshot() != predicted:
            raise AssertionError('poisoned live streams changed owned terrain initialization')
        if ctypes.string_at(h.lib.overkill_level_terrain_current(), 256) != wanted:
            raise AssertionError('mutable terrain output changed immutable content')
        count += 1

    # Feed owned attributes into the existing ASM/C collision leaves. Both wall
    # values block the ship; only ordinary walls remove player shots.
    for tile, attribute in enumerate(wanted):
        reset(h, arena)
        h.lib.overkill_initialize_tile_attributes(65535)
        h.m.write(h.offset('ByteAttributeTable'), wanted)
        # The pre-allocation CS map segment overlaps DS in the oracle image.
        # Gameplay gets a separate allocated map; bind the same safe window here.
        map_segment = 0x9000
        map_at = map_segment << 4
        h.m.poke('LevelMapSegment', map_segment)
        ctypes.memmove(arena.base + h.m.linear('LevelMapSegment'),
                       struct.pack('<H', map_segment), 2)
        if not h.lib.overkill_bind_level_map(arena.base + map_at, 65536):
            raise AssertionError('native rejected the collision map window')
        payload = bytes([tile]) * 65536
        h.m.u.mem_write(map_at, payload)
        ctypes.memmove(arena.base + map_at, payload, len(payload))
        if h.lib.map_attribute(100) != attribute:
            raise AssertionError(f'tile {tile}: wrong runtime property')
        actor = h.offset('PoolB')
        record = bytearray(K.RECORD_SIZE)
        for field, value in (('STATUS', 1), ('Y', 64), ('X', 64), ('SPRITE', 0),
                             ('KIND', K.KIND_TYPED), ('TYPE', 2), ('SLOT_INDEX', 65535)):
            struct.pack_into('<H', record, getattr(K, 'REC_' + field), value)
        h.write(actor, record)
        h.write_symbol('DemoActive', b'\0\0')
        pointer = ctypes.c_void_p(h.state_addr + actor)
        ship_hit = h.lib.probe_ship_terrain_collision(pointer)
        result = h.m.call('ProbeShipTerrainCollision', {'BP': actor})
        if ship_hit != int(bool(attribute)) or ship_hit != int(bool(result['FLAGS'] & FLAG['CF'])):
            raise AssertionError(f'tile {tile}: ship property mismatch: attribute={attribute}, '
                                 f'native={ship_hit}, flags={result["FLAGS"]:04x}, '
                                 f'map={arena.map_segment:04x}, data={h.m.data_frame:04x}')
        h.compare(f'tile {tile}: owned ship collision')
        compare_arena(h, arena, h.state_storage.snapshot(), f'tile {tile}: ship arena')
        h.lib.shot_bounds_check(pointer)
        h.m.call('ShotBoundsCheck', {'BP': actor})
        status = struct.unpack_from('<H', h.state_storage.snapshot(), actor + K.REC_STATUS)[0]
        if status != int(attribute != 1):
            raise AssertionError(f'tile {tile}: shot property mismatch')
        h.compare(f'tile {tile}: owned shot collision')
        compare_arena(h, arena, h.state_storage.snapshot(), f'tile {tile}: shot arena')
        count += 2

    # Levels 1 and 4 share legacy storage; successful authored loads do not.
    sibling = work / 'sibling'
    sibling_document = duplicate_original(1, sibling, 'terrain_sibling')
    load(h, sibling)
    h.lib.overkill_initialize_tile_attributes(65535)
    if table(h) != expected(sibling_document) or table(h)[108] != 2:
        raise AssertionError('authored level 4 changed level 1 through shared storage')
    load(h, directory)
    h.lib.overkill_initialize_tile_attributes(65535)
    if table(h)[108] != 0:
        raise AssertionError('switching back lost the authored level 4 override')
    empty_directory = work / 'empty-overrides'
    empty_document = duplicate_original(1, empty_directory, 'all_wall_terrain')
    empty_document['terrain']['attribute_patches'] = []
    write_json(empty_directory / 'level.json', empty_document)
    load(h, empty_directory)
    h.lib.overkill_initialize_tile_attributes(65535)
    if table(h) != bytes([1]) * 256:
        raise AssertionError('empty authored overrides fell back to original open tiles')
    return count + 3, directory, document


def rejection_cases(h, work, directory, document):
    load(h, directory)
    pointer = h.lib.overkill_level_terrain_current()
    identity = loader._id(h)
    attributes = ctypes.string_at(pointer, 256)
    changes = [lambda d: d.pop('terrain'),
               lambda d: d['terrain'].update(default='open'),
               lambda d: d['terrain'].update(attribute_patches={}),
               lambda d: d['terrain'].update(extra=True)]
    for tile in (-1, 256, True):
        changes.append(lambda d, value=tile: d['terrain']['attribute_patches'][0].update(tile=value))
    changes.append(lambda d: d['terrain']['attribute_patches'][0].update(attribute='solid'))
    changes.append(lambda d: d['terrain']['attribute_patches'][0].update(extra=1))
    for index, change in enumerate(changes):
        bad = copy.deepcopy(document)
        change(bad)
        candidate = work / f'bad-{index}'
        candidate.mkdir()
        write_json(candidate / 'level.json', bad)
        (candidate / 'map.bin').write_bytes((directory / 'map.bin').read_bytes())
        try:
            validate_directory(candidate)
        except ValueError:
            pass
        else:
            raise AssertionError(f'Python accepted malformed terrain {index}')
        ok, error = loader._load(h, candidate)
        if ok or not error:
            raise AssertionError(f'native accepted malformed terrain {index}')
        if (loader._id(h) != identity or h.lib.overkill_level_terrain_current() != pointer or
                ctypes.string_at(pointer, 256) != attributes):
            raise AssertionError('failed terrain load changed active content')
    older = work / 'v12'
    old_document = duplicate_original(1, older, 'old_terrain')
    old_document['version'] = 12
    write_json(older / 'level.json', old_document)
    load(h, older)
    if h.lib.overkill_level_terrain_current():
        raise AssertionError('v12 retained the owned terrain provider')
    h.reset()
    pointers = h.offset('AttributePatchPointers')
    h.write(pointers + 2, struct.pack('<H', 0x400))
    h.write(0x400, bytes((108, 0, 255)))
    h.lib.overkill_initialize_tile_attributes(pointers + 2)
    if table(h)[108] != 0 or table(h)[255] != 1:
        raise AssertionError('v12 stopped using its live legacy patch stream')
    h.lib.overkill_level_content_unload()
    if h.lib.overkill_level_terrain_current():
        raise AssertionError('unload retained owned terrain')
    return len(changes) + 2


def run():
    h = loader.HostHarness()
    arena, _map = bind(h)
    try:
        with tempfile.TemporaryDirectory(prefix='overkill-owned-terrain-') as temporary:
            work = Path(temporary)
            count = original_cases(h, arena, work)
            authored_count, directory, document = authored_cases(h, arena, work)
            count += authored_count + rejection_cases(h, work, directory, document)
            import timeline_content
            if not h.lib.overkill_bind_level_map(arena.base + (arena.map_segment << 4), 65536):
                raise AssertionError('native rejected the checkpoint map window')
            count += timeline_content._checkpoint_restart_case(
                h, arena, work / 'restart', owned_terrain=True)
    finally:
        h.lib.overkill_level_content_unload()
        h.check_canaries()
    print(f'PASS owned terrain initialization, collision and loader semantics; {count} cases')


if __name__ == '__main__':
    run()
