"""Native LevelDef resource bindings and loader order against the frozen oracle.

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
from export_original_levels import definitions
from level_format import load, original_paths, validate
from emu import REG, LOAD
from world import K
from unicorn import UC_HOOK_CODE


class Definition(ctypes.Structure):
    _fields_ = [(name, ctypes.c_uint16) for name in ('map', 'sprites', 'blocks', 'plaque')]


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
                                       'c/levels.c', 'host/level_def.c', 'host/memory.c')]
    subprocess.run(command + ['-o', str(library)], check=True)
    return library


def fixtures(machine):
    expected = definitions(machine)
    actual = [load(path) for path in original_paths()]
    if actual != expected:
        raise AssertionError('canonical resource fixtures differ from the exact oracle')
    bad = []
    for key, value in (('version', True), ('version', 2), ('profile', 'complete'),
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
    for document in bad:
        try:
            validate(document)
        except ValueError:
            continue
        raise AssertionError(f'validator accepted invalid definition: {document}')
    return len(actual) + len(bad)


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
    for role, _ in Definition._fields_:
        slot = getattr(definition, role)
        h.write(slot, struct.pack('<H', 0xABCD))
        if lib.overkill_level_resource_name(slot) != 0xABCD:
            raise AssertionError(f'{role}: resource value was cached')
    return 0x10000 * 4 + 4


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
    binding_count = bindings(h)
    loader_count = coordinator(h, probe())
    print(f'PASS LevelDef: {fixture_count} fixture/validator checks, '
          f'{binding_count} resource checks, {loader_count} native/oracle loader cases')


if __name__ == '__main__':
    main()
