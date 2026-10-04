"""Native LevelDef bindings, terrain and checkpoints against the frozen oracle.

The probe compiles the production coordinator and binding code with narrow service
substitutions. Identical substitutions hook the corresponding ASM entries. No
original game loop runs. --no-build reuses generated headers and the full host core;
the small production-code probe is always rebuilt.
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
from export_original_levels import definitions, script_event_boundaries
from level_format import load, original_paths, validate, encode_attribute_patches
from level_bindings import bind_level_documents, load_original_bindings
from emu import REG, LOAD
from world import K
from unicorn import UC_HOOK_CODE


class Definition(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in
                ('map', 'sprites', 'blocks', 'plaque', 'attribute_patches', 'checkpoints', 'timeline_cursor')]


class Checkpoint(ctypes.Structure):
    _fields_ = [('map_position', ctypes.c_uint16), ('script_clock', ctypes.c_uint16)]


class Registers(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in
                ('ax', 'bx', 'cx', 'dx', 'si', 'di', 'bp', 'es')]


class DosRegisters(ctypes.Structure):
    _fields_ = [('bp', ctypes.c_uint16), ('es', ctypes.c_uint16)]


def module(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    result = importlib.util.module_from_spec(spec)
    sys.modules[name] = result
    spec.loader.exec_module(result)
    return result


def probe():
    out = ROOT / 'build/host'
    library = out / ('level_def_probe.dll' if os.name == 'nt' else 'level_def_probe.so')
    command = [os.environ.get('CC', 'gcc'), '-std=c11', '-O2', '-Wall', '-Wextra',
               '-Werror', '-Wno-unknown-pragmas', '-fno-strict-aliasing',
               '-DOVERKILL_HOST', '-shared']
    command += ['-static-libgcc'] if os.name == 'nt' else ['-fPIC']
    command += ['-I' + str(ROOT / p) for p in ('build/host', 'c', 'host')]
    command += [str(ROOT / p) for p in ('tests/host/level_def_probe.c',
                                       'c/levels.c', 'host/level_def.c', 'host/level_departure.c', 'host/memory.c')]
    subprocess.run(command + ['-o', str(library)], check=True)
    return library


def fixtures(machine):
    expected = definitions(machine)
    actual = [load(path) for path in original_paths()]
    if actual != expected:
        raise AssertionError('canonical resource fixtures differ from the exact oracle')
    bad = []
    for key, value in (('version', True), ('version', 3), ('profile', 'complete'),
                       ('id', '0x34'), ('objects', [])):
        document = copy.deepcopy(actual[0])
        document[key] = value
        bad.append(document)
    for name in ('../lev0map.bic', 'lev0map.jpg', 'lev0map.enc', 34):
        document = copy.deepcopy(actual[0])
        document['resources']['map'] = name
        bad.append(document)
    document = copy.deepcopy(actual[0])
    del document['resources']['plaque']
    bad.append(document)
    for field, value in (('map_row', True), ('map_row', -1), ('map_row', 5042),
                         ('script_clock', 65536), ('resume_event', False)):
        document = copy.deepcopy(actual[0])
        document['checkpoints'][0][field] = value
        bad.append(document)
    for value in ([], {}, actual[0]['checkpoints'][:3]):
        document = copy.deepcopy(actual[0])
        document['checkpoints'] = value
        bad.append(document)
    document = copy.deepcopy(actual[0])
    document['checkpoints'][1]['map_row'] = document['checkpoints'][0]['map_row']
    bad.append(document)
    for tile, attribute in ((True, 'open'), (-1, 'open'), (255, 'open'),
                            (256, 'open'), (2, 'unknown'), (2, 0)):
        document = copy.deepcopy(actual[0])
        document['terrain']['attribute_patches'] = [{'tile': tile, 'attribute': attribute}]
        bad.append(document)
    for value in ('open', None):
        document = copy.deepcopy(actual[0])
        document['terrain']['default'] = value
        bad.append(document)
    document = copy.deepcopy(actual[0])
    document['terrain']['attribute_patches'] = {}
    bad.append(document)
    for document in bad:
        try:
            validate(document)
        except ValueError:
            continue
        raise AssertionError(f'validator accepted invalid definition: {document}')
    return len(actual) + len(bad)


def import_checks(machine):
    documents = [load(path) for path in original_paths()]
    original = machine.state()
    if load_original_bindings(machine) != original:
        raise AssertionError('canonical resource/terrain import changes the original DS image')
    for level, document in enumerate(documents):
        slot = machine.offset('AttributePatchPointers') + level * 2
        cursor = struct.unpack_from('<H', original, slot)[0]
        payload = encode_attribute_patches(document['terrain'])
        if original[cursor:cursor + len(payload)] != payload:
            raise AssertionError(f'level {level}: patch ordering or duplicate entries changed')
    legacy = copy.deepcopy(documents)
    for document in legacy:
        document['profile'] = 'resource-bindings'
        del document['terrain']
        del document['checkpoints']
        del document['formations']
        del document['timeline']
        del document['paths']
        del document['leader_paths']
        del document['map_spawns']
        del document['departure']
        del document['encounter']
        del document['marching_formation']
        document.pop('boss', None)
    if bind_level_documents(machine, legacy) != original:
        raise AssertionError('resource-only profile no longer preserves original terrain')
    bad = []
    too_long = copy.deepcopy(documents)
    too_long[0]['terrain']['attribute_patches'].append({'tile': 2, 'attribute': 'open'})
    bad.append((too_long, 'original binding holds'))
    conflict = copy.deepcopy(documents)
    conflict[4]['terrain']['attribute_patches'][0]['attribute'] = 'wall'
    bad.append((conflict, 'shared original patch stream'))
    unknown = copy.deepcopy(documents)
    unknown[0]['resources']['map'] = 'custommap.bic'
    bad.append((unknown, 'no original filename binding'))
    repeated = copy.deepcopy(documents)
    repeated[1]['id'] = repeated[0]['id']
    bad.append((repeated, 'identifiers must be unique'))
    bad.append((documents[:-1], 'six level definitions'))
    invalid_event = copy.deepcopy(documents)
    invalid_event[0]['checkpoints'][0]['resume_event'] = 65535
    bad.append((invalid_event, 'no timeline boundary'))
    for documents_, diagnostic in bad:
        try:
            bind_level_documents(machine, documents_)
        except ValueError as error:
            if diagnostic not in str(error): raise
        else:
            raise AssertionError(f'import accepted invalid binding: {diagnostic}')
    # A real structured edit reaches the initialized native state and touches
    # only the named pointer slot and the selected patch value byte.
    edited = copy.deepcopy(documents)
    edited[0]['resources']['sprites'] = documents[1]['resources']['sprites']
    edited[0]['terrain']['attribute_patches'][0]['attribute'] = 'shot_permeable_wall'
    bound = bind_level_documents(machine, edited)
    slot = machine.offset('LevelBankFiles')
    cursor = struct.unpack_from('<H', original, machine.offset('AttributePatchPointers'))[0]
    allowed = {slot, slot + 1, cursor + 1}
    changed = {i for i, (a, b) in enumerate(zip(original, bound)) if a != b}
    if not changed or not changed <= allowed or bound[cursor + 1] != 2:
        raise AssertionError('structured edit did not preserve its native binding boundary')
    shortened = copy.deepcopy(documents)
    shortened[0]['terrain']['attribute_patches'] = []
    short_state = bind_level_documents(machine, shortened)
    if short_state[cursor] != 255 or short_state[cursor + 1:] != original[cursor + 1:]:
        raise AssertionError('shortened stream changed ignored trailing bytes')
    without_checkpoints = copy.deepcopy(documents)
    for document in without_checkpoints:
        del document['checkpoints']
    if bind_level_documents(machine, without_checkpoints) != original:
        raise AssertionError('earlier terrain profile changes original checkpoints')
    checkpoint_edit = copy.deepcopy(documents)
    checkpoint_edit[0]['checkpoints'][1] = {
        'map_row': 76, 'script_clock': 0xBEEF, 'resume_event': 2}
    changed_state = bind_level_documents(machine, checkpoint_edit)
    cursor = struct.unpack_from('<H', original, machine.offset('LevelCheckpointPtrs'))[0]
    allowed = set(range(cursor + 6, cursor + 14))
    changed = {i for i, (a, b) in enumerate(zip(original, changed_state)) if a != b}
    if not changed or not changed <= allowed:
        raise AssertionError('checkpoint edit crosses its record/previous threshold boundary')
    if struct.unpack_from('<4H', changed_state, cursor + 6) != (
            76 * 13, 76 * 13, 0xBEEF, script_event_boundaries(machine, 0)[2]):
        raise AssertionError('checkpoint row/event binding did not reach the native image')
    return 18, bound, changed_state


def tile_attributes(h, imported):
    lib = h.lib
    lib.overkill_initialize_tile_attributes.argtypes = (ctypes.c_uint16,)
    lib.overkill_initialize_tile_attributes.restype = None
    attr = h.offset('ByteAttributeTable')
    pointers = h.offset('AttributePatchPointers')
    count = 0
    # Stop at the actual end of the tile stage: map rows and keyboard handling
    # belong to the coordinator tests. Return through the original near ABI.
    def done(u, pc, size, _):
        sp, ss = u.reg_read(REG['SP']), u.reg_read(REG['SS'])
        ip = int.from_bytes(bytes(u.mem_read(ss * 16 + sp, 2)), 'little')
        u.reg_write(REG['SP'], (sp + 2) & 0xFFFF)
        u.reg_write(REG['IP'], ip)
    at = h.m.linear('AttributePatchesDone')
    hook = h.m.u.hook_add(UC_HOOK_CODE, done, begin=at, end=at)
    def compare(level, label, writes=(), state=None):
        nonlocal count
        h.reset()
        if state is not None:
            h.m.set_state(state)
            h.state_storage.load(state)
        h.write_symbol('LevelIndex', struct.pack('<H', level))
        for offset, data in writes: h.write(offset, data)
        slot = (pointers + 2 * level) & 0xFFFF
        h.m.call('InitializeByteAttributes')
        lib.overkill_initialize_tile_attributes(slot)
        h.compare(label)
        if h.state_storage.snapshot()[attr + 255] != 1:
            raise AssertionError(f'{label}: terminator tile changed')
        count += 1
    try:
        for level in (*range(6), 0x8000, 0x8001, 0x8005):
            for seed in (bytes([0xA5]) * 256, bytes(range(256))):
                compare(level, f'tile attributes level {level:04X}', [(attr, seed)])
        compare(0, 'structured terrain edit', state=imported)
        scratch = 0x0400
        for raw_value in (0, 1, 2, 0x80, 0xFF):
            compare(0, f'ordered repeated raw attribute {raw_value}', [
                (pointers, struct.pack('<H', scratch)),
                (scratch, bytes((7, 2, 7, raw_value, 254, raw_value, 255, 0x12)))])
        compare(0, 'stream pair wraps past FFFF', [
            (pointers, b'\xff\xff'), (0xFFFF, b'\x05'), (0, b'\x02\xff')])
        compare(0, 'terminator at FFFF has no value byte', [
            (pointers, b'\xff\xff'), (0xFFFF, b'\xff'), (0, b'\x80')])
        # The reset overwrites this binding with 0101h before it is dereferenced.
        alias = attr + 16
        level = ((alias - pointers) & 0xFFFF) // 2
        compare(level, 'binding aliases reset table', [
            (alias, struct.pack('<H', 0x0201)),
            (0x0101, b'\x0a\x02\xff'), (0x0201, b'\x0b\x00\xff')])
        # The first write supplies the terminator for a later stream read. This
        # would behave differently if patches were buffered before applying them.
        compare(5, 'patch writes alter later stream reads', [
            (pointers + 10, struct.pack('<H', attr - 2)),
            (attr - 2, b'\xfc\xff')])
    finally:
        h.m.u.hook_del(hook)
    return count


def bindings(h):
    lib = h.lib
    lib.overkill_level_def.argtypes = (ctypes.c_uint16, ctypes.POINTER(Definition))
    lib.overkill_level_def.restype = None
    lib.overkill_level_resource_name.argtypes = (ctypes.c_uint16,)
    lib.overkill_level_resource_name.restype = ctypes.c_uint16
    bases = [h.offset(name) for name in ('LevelMapFiles', 'LevelBankFiles',
                                       'LevelBankFiles', 'PlaqueFiles')]
    h.reset()
    before = h.state_storage.snapshot()
    definition = Definition()
    for level in range(0x10000):
        lib.overkill_level_def(level, ctypes.byref(definition))
        expected = [(bases[0] + 2 * level) & 0xFFFF,
                    (bases[1] + 4 * level) & 0xFFFF,
                    (bases[2] + 4 * level + 2) & 0xFFFF,
                    (bases[3] + 2 * level) & 0xFFFF]
        for role, slot in zip(('map', 'sprites', 'blocks', 'plaque'), expected):
            if getattr(definition, role) != slot:
                raise AssertionError(f'level {level:04X} {role}: binding differs')
            want = struct.unpack_from('<H', before, slot)[0]
            if lib.overkill_level_resource_name(slot) != want:
                raise AssertionError(f'level {level:04X} {role}: live resource differs')
    h.compare('all word indices are read-only', ignore_stack=False)
    # A definition keeps a reference rather than a stale snapshot of a pointer.
    lib.overkill_level_def(3, ctypes.byref(definition))
    for role in ('map', 'sprites', 'blocks', 'plaque'):
        slot = getattr(definition, role)
        h.write(slot, struct.pack('<H', 0xABCD))
        if lib.overkill_level_resource_name(slot) != 0xABCD:
            raise AssertionError(f'{role}: resource value was cached')
    for level in range(0x10000):
        lib.overkill_level_def(level, ctypes.byref(definition))
        for field, table in (('attribute_patches', 'AttributePatchPointers'),
                             ('checkpoints', 'LevelCheckpointPtrs'),
                             ('timeline_cursor', 'LevelScriptCursorPtrs')):
            if getattr(definition, field) != (h.offset(table) + 2 * level) & 0xFFFF:
                raise AssertionError(f'{level:04X}: {field} binding differs')
    return 0x10000 * 7 + 4


def checkpoint_selection(h, imported):
    lib = h.lib
    lib.overkill_select_checkpoint.argtypes = (ctypes.c_uint16, ctypes.POINTER(Checkpoint))
    lib.overkill_select_checkpoint.restype = None
    pointers = h.offset('LevelCheckpointPtrs')
    saved_cursor = h.offset('CheckpointScriptCursor')
    count = 0
    def compare(level, position, label, writes=(), state=None):
        nonlocal count
        h.reset()
        if state is not None:
            h.m.set_state(state)
            h.state_storage.load(state)
        h.write_symbol('MapScrollPos', struct.pack('<H', position))
        for offset, data in writes:
            h.write(offset, data)
        binding = (pointers + 2 * level) & 0xFFFF
        cursor = h.m.word(binding)
        selection = Checkpoint()
        lib.overkill_select_checkpoint(binding, ctypes.byref(selection))
        # Compose the original reader's four calls, with the final carry ignored.
        # Its writes remain live between calls, exactly as in RestartAtCheckpoint.
        for index in range(4):
            result = h.m.call('ReadCheckpoint', {'SI': cursor})
            cursor = result['SI']
            if index == 3 or result['FLAGS'] & 1:
                break
        if (selection.map_position, selection.script_clock) != (result['DI'], result['DX']):
            raise AssertionError(f'{label}: checkpoint selection differs')
        h.compare(label)
        count += 1
    for level in range(6):
        checkpoints = load(original_paths()[level])['checkpoints']
        positions = {0, 0x7FFF, 0x8000, 0xFFFF}
        for checkpoint in checkpoints[1:]:
            position = checkpoint['map_row'] * 13
            positions.update((position - 1, position, position + 1))
        for position in sorted(positions):
            compare(level, position, f'checkpoint level {level} position {position:04X}')
            compare(level + 0x8000, position, f'checkpoint wrapped level {level} position {position:04X}')
    compare(0, 76 * 13, 'structured checkpoint edit', state=imported)
    scratch = 0x0400
    for position, threshold in ((0x7FFF, 0x8000), (0x8000, 0x7FFF),
                                (0xFFFF, 0), (0, 0xFFFF), (0, 0), (0xFFFF, 0xFFFF)):
        payload = struct.pack('<15H', 13, 3, 17, threshold,
                              26, 4, 18, threshold, 39, 5, 19, threshold, 52, 6, 20)
        compare(0, position, f'unsigned checkpoint {position:04X}/{threshold:04X}', [
            (pointers, struct.pack('<H', scratch)), (scratch, payload)])
    compare(0, 0, 'checkpoint words wrap at FFFF', [
        (pointers, b'\xf8\xff'), (0xFFF8, struct.pack('<4H', 13, 3, 17, 0)),
        (0, struct.pack('<4H', 26, 4, 18, 1))])
    compare(0, 0x200, 'candidate cursor write changes its own threshold', [
        (pointers, struct.pack('<H', saved_cursor - 6)),
        (saved_cursor - 6, struct.pack('<8H', 13, 3, 0x100, 0xFFFF, 26, 4, 18, 0xFFFF))])
    compare(0, 0x200, 'candidate cursor write changes following position', [
        (pointers, struct.pack('<H', saved_cursor - 8)),
        (saved_cursor - 8, struct.pack('<8H', 13, 3, 0x1234, 0, 26, 4, 18, 0xFFFF))])
    fallback = h.m.word(pointers + 10) + 30
    for neighbor in (0, 0xFFFF):
        compare(5, 0x0B00, 'fallback neighboring word ignored ' + str(neighbor), [
            (fallback, struct.pack('<H', neighbor))])
    return count


def coordinator(h, library):
    lib = ctypes.CDLL(str(library))
    lib.overkill_bind_state.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    lib.overkill_bind_real_memory.argtypes = (ctypes.c_void_p, ctypes.c_size_t)
    if not lib.overkill_bind_state(h.state_addr, 0x10000):
        raise AssertionError('probe state binding failed')
    arena = (ctypes.c_ubyte * 0x100000)()
    if not lib.overkill_bind_real_memory(ctypes.addressof(arena), len(arena)):
        raise AssertionError('probe arena binding failed')
    callback_type = ctypes.CFUNCTYPE(None, ctypes.c_uint16, ctypes.POINTER(Registers))
    lib.level_probe_bind.argtypes = (callback_type,)
    for name in ('load_level_map', 'load_level_graphics'):
        getattr(lib, name).argtypes = (ctypes.POINTER(DosRegisters),)
    count = 0
    for kind, indices in (('map', (*range(6), 0x8000, 0x8001)),
                          ('graphics', (*range(6), 6, 7, 0x4000, 0x4001,
                                        0x8000, 0x8001, 0x8005, 0xFFFF))):
        for level in indices:
            for retry in (False, True):
                # Change level/table state at service boundaries to distinguish
                # already-selected filenames from later resource/attribute reads.
                for mutate in (False, True):
                    h.reset()
                    h.write_symbol('LevelIndex', struct.pack('<H', level))
                    h.write_symbol('KeyDownTable', bytes([1]) * K.KEY_DOWN_COUNT)
                    segments = {'LevelMapSegment': 0x9000, 'WorkspaceSegment': 0x8000,
                                'LevelBlocksSegment': 0x7000, 'LevelSpritesSegment': 0x6000,
                                'PlaqueSegment': 0x5000}
                    for name, value in segments.items():
                        h.m.poke(name, value)
                    h.m.u.mem_write(h.m.linear('PerFileFlagsEnabled'), b'\x01')
                    h.m.poke('LoadDestOffset', 0x20)
                    ctypes.memmove(arena, bytes(h.m.u.mem_read(0, 0x100000)), len(arena))
                    traces = [[], []]
                    errors = []
                    def service(side, event, registers):
                        def address(name):
                            if h.m.symbols[name.upper()][0] == h.m.data_frame - LOAD:
                                return h.state_addr + h.offset(name)
                            return ctypes.addressof(arena) + h.m.linear(name)
                        def read(name, width=2):
                            if side == 0:
                                return h.m.peek(name) if width == 2 else h.m.read(h.offset(name), 1)[0]
                            return int.from_bytes(ctypes.string_at(address(name), width), 'little')
                        def write(name, value, width=2):
                            payload = int(value).to_bytes(width, 'little')
                            if side == 0:
                                h.m.u.mem_write(h.m.linear(name), payload)
                            else:
                                ctypes.memmove(address(name), payload, width)
                        trace = traces[side]
                        if event in (1, 3):
                            trace.append((event, registers.bp, registers.es,
                                tuple(read(name) for name in ('FileNamePtr', 'FileBufferSegment',
                                    'FileBufferOffset', 'LoadNamePtr', 'LoadDestSegment',
                                    'LoadDestOffset', 'LoadImageSlot', 'LoadMakeMask', 'LoadRecordImages')),
                                read('LoadIsEnc', 1)))
                        elif event == 2:
                            trace.append((event, registers.bp, registers.es))
                        if event == 1:
                            attempt = sum(row[0] == 1 for row in trace)
                            if kind == 'map' and mutate and attempt == 1:
                                write('LevelIndex', 4)
                                slot = (h.offset('LevelMapFiles') + (level << 1)) & 0xFFFF
                                payload = struct.pack('<H', h.offset('File_LEV2MAP_BIC'))
                                if side == 0: h.m.write(slot, payload)
                                else: ctypes.memmove(h.state_addr + slot, payload, 2)
                            write('FileStatus', K.FILE_STATUS_READ_FAILED
                                  if retry and attempt == 1 else K.FILE_STATUS_OK)
                            if kind == 'map' and not (retry and attempt == 1):
                                dest = read('FileBufferSegment') << 4
                                data = bytes([0x5A]) * K.MAP_END_POS
                                if side == 0: h.m.u.mem_write(dest, data)
                                else: ctypes.memmove(ctypes.addressof(arena) + dest, data, len(data))
                        elif event == 3:
                            decodes = sum(row[0] == 3 for row in trace)
                            write('DecodeFileFlags', registers.bp)
                            write('DecodeImageIndex', 0xFFFF)
                            registers.bp, registers.es = 0xA100 + decodes, 0xB200 + decodes
                            if mutate and decodes == 1:
                                write('PendingSpriteFile', h.offset('File_G2_BIC'))
                                write('LevelIndex', 4)
                                slot = h.offset('PlaqueFiles') + 8
                                payload = struct.pack('<H', h.offset('File_PLAQ2_ENC'))
                                if side == 0: h.m.write(slot, payload)
                                else: ctypes.memmove(h.state_addr + slot, payload, 2)
                        elif event == 4:
                            if side == 0:
                                registers.es = 0  # ASM already cleared KeyDownTable.
                            else:
                                ctypes.memset(h.state_addr + h.offset('KeyDownTable'), 0, K.KEY_DOWN_COUNT)
                        elif event == 5:
                            registers.es = read('WorkspaceSegment')
                            size = 0x8000 if read('ClearWorkspaceHalfOnly') else 0x10000
                            if side == 0: h.m.u.mem_write(registers.es << 4, bytes(size))
                            else: ctypes.memset(ctypes.addressof(arena) + (registers.es << 4), 0, size)
                    def native_service(event, registers):
                        try: service(1, event, registers.contents)
                        except Exception as error: errors.append(error)
                    callback = callback_type(native_service)
                    lib.level_probe_bind(callback)
                    hooks = []
                    for label, event in (('LoadResourceFile', 1), ('PromptLoadErrorWaitFire', 2),
                                         ('DecodeGraphicsImages', 3), ('FlushBiosKeyboardBuffer', 4),
                                         ('ClearWorkspace', 5)):
                        def hook(u, pc, size, _, event=event):
                            registers = Registers()
                            registers.bp, registers.es = u.reg_read(REG['BP']), u.reg_read(REG['ES'])
                            service(0, event, registers)
                            if event == 3:
                                # The real decoder restores DS from MAIN; its input
                                # DS was WorkspaceSegment, unlike the C state view.
                                u.reg_write(REG['DS'], h.m.data_frame)
                            u.reg_write(REG['BP'], registers.bp)
                            u.reg_write(REG['ES'], registers.es)
                            # Emulate the near service's RET.
                            sp = u.reg_read(REG['SP'])
                            ss = u.reg_read(REG['SS'])
                            ip = int.from_bytes(bytes(u.mem_read(ss * 16 + sp, 2)), 'little')
                            u.reg_write(REG['SP'], (sp + 2) & 0xFFFF)
                            u.reg_write(REG['IP'], ip)
                        at = h.m.linear(label)
                        hooks.append(h.m.u.hook_add(UC_HOOK_CODE, hook, begin=at, end=at))
                    try:
                        oracle = h.m.call('LoadLevelMap' if kind == 'map' else 'LoadLevelGraphics',
                                          {'BP': 0x4567, 'ES': 0xB800})
                        registers = DosRegisters(0x4567, 0xB800)
                        getattr(lib, 'load_level_' + kind)(ctypes.byref(registers))
                        if errors: raise errors[0]
                        label = f'{kind} level={level:04X} retry={retry} mutate={mutate}'
                        if traces[0] != traces[1]:
                            raise AssertionError(f'{label}: ordered loader traces differ\n{traces}')
                        if (registers.bp, registers.es) != (oracle['BP'], oracle['ES']):
                            raise AssertionError(f'{label}: register results differ')
                        h.compare(label)
                        for name in ('LoadNamePtr', 'LoadDestSegment', 'LoadImageSlot',
                                     'LoadMakeMask', 'LoadRecordImages', 'DecodeFileFlags', 'DecodeImageIndex'):
                            at = h.m.linear(name)
                            if bytes(h.m.u.mem_read(at, 2)) != bytes(arena[at:at + 2]):
                                raise AssertionError(f'{label}: {name} differs')
                        if kind == 'map':
                            at = 0x90000
                            if bytes(h.m.u.mem_read(at, 0x10000)) != bytes(arena[at:at + 0x10000]):
                                raise AssertionError(f'{label}: map mutation differs')
                        count += 1
                    finally:
                        for handle in hooks: h.m.u.hook_del(handle)
    return count


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--no-build', action='store_true')
    args = parser.parse_args()
    if not args.no_build:
        import host
        host.build()
    harness = module('level_def_input_harness', ROOT / 'tests/host/input.py')
    h = harness.HostHarness()
    fixture_count = fixtures(h.m)
    import_count, imported, imported_checkpoints = import_checks(h.m)
    binding_count = bindings(h)
    attribute_count = tile_attributes(h, imported)
    checkpoint_count = checkpoint_selection(h, imported_checkpoints)
    loader_count = coordinator(h, probe())
    print(f'PASS LevelDef: {fixture_count} fixture/validator checks, '
          f'{import_count} import checks, {binding_count} binding checks, '
          f'{attribute_count} native/oracle attribute cases, '
          f'{checkpoint_count} native/oracle checkpoint selections, '
          f'{loader_count} native/oracle loader cases')


if __name__ == '__main__':
    main()
