"""Build the native gameplay core from shared DOS C regions.

The platform state view is generated from the exact ASM oracle, not a second set of
globals. Windows uses the official pinned SDL3 MinGW SDK under ignored build/deps.
The non-Windows compiler branch uses pkg-config sdl3, but oracle generation still
requires the bundled Windows DOS runners. No global installation is changed.
"""
from common import ROOT, read_json, sha
from pathlib import Path
import os
import re
import shutil
import struct
import subprocess
import urllib.request
import zipfile
import hybrid
from extract import mz
from graph import read_map
from build import assemble_driver
from resources import driver


def generate_state(out):
    exe, _ = hybrid.build(ROOT / 'build/oracle-sym', with_c=False)
    _, image, _, _ = mz(exe.read_bytes())
    oracle = read_json(ROOT / 'metadata/oracle.json')
    if len(image) != oracle['program_bytes'] or sha(image) != oracle['program_sha256']:
        raise ValueError('host state must come from the exact source-built oracle')
    segments, _, publics = read_map()
    base, size = segments['DATA']
    # Reject conflicting name rows rather than silently selecting one address.
    text = exe.with_suffix('.MAP').read_text().split('Publics by Value')[0]
    rows = re.findall(r'^ ([0-9A-F]{4}):([0-9A-F]{4})\s+(\w+)\s*$', text, re.M)
    seen = set()
    for _, _, name in rows:
        if name.upper() in seen:
            raise ValueError('duplicate oracle public: ' + name)
        seen.add(name.upper())
    offsets = {}
    for name, kind, _ in hybrid.state_labels():
        offset = publics[name.upper()] - base
        width = {'byte': 1, 'word': 2, 'dword': 4}[kind]
        if not 0 <= offset <= size or offset + width > 0x10000:
            raise ValueError('not in the oracle DS window: ' + name)
        offsets[name.upper()] = offset
    out.mkdir(parents=True, exist_ok=True)
    hybrid.generate_header(out, state_offsets=offsets)
    # Bind the structured original definitions only into native initialization.
    # The exact oracle image/header layout and DOS hybrid stay independent.
    from emu import Machine
    from level_bindings import load_original_bindings
    from level_format import load, original_paths
    from level_map_recipes import generate_map_recipe_header
    from level_departure import generate_departure_header
    from level_encounter import generate_encounter_header
    from level_invaders import generate_invader_header
    from level_boss import generate_boss_header
    from level_policies import generate_level_policy_header
    from level_maps import generate_map_limit_header
    from level_timeline import generate_timeline_parameter_header, generate_level_preset_header
    machine = Machine(exe)
    original_state = image[base:base + size].ljust(0x10000, b'\0')
    if machine.state() != original_state:
        raise ValueError('level binding requires the canonical native DS initialization')
    (out / 'STATE.BIN').write_bytes(load_original_bindings(machine))
    generate_map_recipe_header(out, [load(path) for path in original_paths()], machine)
    generate_departure_header(out, [load(path) for path in original_paths()], machine)
    generate_encounter_header(out, [load(path) for path in original_paths()])
    generate_invader_header(out, [load(path) for path in original_paths()], machine)
    generate_boss_header(out, [load(path) for path in original_paths()], machine)
    generate_level_policy_header(out, [load(path) for path in original_paths()], machine)
    generate_map_limit_header(out)
    generate_timeline_parameter_header(out, [load(path) for path in original_paths()], machine)
    generate_level_preset_header(out)
    generate_addresses(out, exe)
    generate_driver_addresses(out, 'adlib')
    generate_driver_addresses(out, 'roland')
    return offsets


def generate_driver_addresses(out, name):
    image = assemble_driver(name)
    if image != driver(name)[0]:
        raise ValueError('native driver definitions require an exact driver oracle')
    listing = (ROOT / 'build/driver-asm' / name / (name.upper() + '.LST')).read_text()
    definitions = re.findall(r'^(\w+)\s+(?:Byte|Word|Near|Far)\s+DRIVER:([0-9A-F]{4})\s*$', listing, re.M)
    constants = re.findall(r'^(\w+)\s+Number\s+([0-9A-F]{4})\s*$', listing, re.M)
    prefix = name.upper()
    header = [f'/* Generated from the byte-exact {prefix} assembler listing. */',
              f'#ifndef {prefix}_GEN_H', f'#define {prefix}_GEN_H',
              f'#define {prefix}_MODULE_BYTES 0x{len(image):04X}']
    header += [f'#define {prefix}_{symbol} 0x{value}'
               for symbol, value in sorted(definitions + constants)]
    header += ['#endif', '']
    (out / (prefix + '_GEN.H')).write_text('\n'.join(header))


def generate_addresses(out, exe):
    """Derive inert DOS address tokens and initial address-space bytes from the oracle.

    Native C implements every executed routine; code offsets remain word identities
    in original tables. Source-built bytes also preserve unchecked adjacent-data reads.
    """
    load = 0x1010
    map_text = exe.with_suffix('.MAP').read_text()
    names = map_text.split('Publics by Name', 1)[1].split('Publics by Value', 1)[0]
    symbols = {name.upper(): (int(frame, 16), int(offset, 16))
               for frame, offset, name in re.findall(
                   r'^\s*([0-9A-F]{4}):([0-9A-F]{4})\s+(\w+)\s*$', names, re.M)}
    data_segment = load + symbols['STACKTOP'][0]
    header = ['/* Generated from the frozen source-built oracle and C declarations. */',
              '#ifndef HOST_GEN_H', '#define HOST_GEN_H',
              f'#define HOST_LOAD_SEGMENT 0x{load:04X}',
              f'#define HOST_DATA_SEGMENT 0x{data_segment:04X}',
              f'#define HOST_DATA_LINEAR 0x{data_segment << 4:05X}',
              'void *overkill_segment_address(word segment, word offset);']
    for name, (frame, offset) in sorted(symbols.items()):
        header.append(f'#define HOST_TOKEN_{name} ((word)0x{offset:04X})')
        header.append(f'#define HOST_OFFSET_{name} ((word)0x{offset:04X})')
        header.append(f'#define HOST_SEGMENT_{name} ((word)0x{load + frame:04X})')
    declarations = '\n'.join(p.read_text(errors='replace')
                              for p in sorted((ROOT / 'c').glob('*'))
                              if p.suffix in ('.c', '.h'))
    objects = {}
    for volatile, kind, name, array in re.findall(
            r'extern\s+(volatile\s+)?(byte|word|dword)\s+__far\s+(\w+)\s*(\[[^\]]*\])?\s*;',
            declarations):
        if name.upper() not in symbols:
            raise ValueError('far object missing from exact oracle map: ' + name)
        declaration = (bool(volatile), kind, bool(array))
        if name in objects and objects[name][1:] != declaration[1:]:
            raise ValueError('conflicting far object declarations: ' + name)
        old = objects.get(name, declaration)
        objects[name] = (old[0] or declaration[0], kind, bool(array))
    for name, (volatile, kind, array) in sorted(objects.items()):
        frame, offset = symbols[name.upper()]
        qualifier = 'volatile ' if volatile else ''
        pointer = f'(({qualifier}{kind} *)overkill_segment_address(0x{load + frame:04X}, 0x{offset:04X}))'
        header.append(f'#define {name} {pointer if array else "(*" + pointer + ")"}')
    functions = set(re.findall(r'extern\s+void\s+(?:__far\s+)?(\w+)\s*\(void\)\s*;', declarations))
    # Cross-region C forward declarations refer to executable native C bodies,
    # not DOS bridge services, even when their signatures match an old thunk.
    definitions = set(re.findall(r'\b(?:void|word|dword)\s+(?:__far\s+)?(\w+)\s*\([^;{}]*\)\s*\{', declarations))
    functions -= definitions
    occupied = {offset for _, offset in symbols.values()}
    service = 0xFFFF
    for name in sorted(functions):
        if name.upper() in symbols:
            header.append(f'#define {name} HOST_TOKEN_{name.upper()}')
        else:
            # New DOS bridge entries have no oracle address. Give only the native
            # service boundary a distinct tag, never a callable native pointer.
            while service in occupied:
                service -= 1
            if service < 0:
                raise ValueError('native service token space exhausted')
            header.append(f'#define HOST_SERVICE_{name.upper()} ((word)0x{service:04X})')
            header.append(f'#define {name} HOST_SERVICE_{name.upper()}')
            occupied.add(service)
            service -= 1
    header += ['#endif', '']
    (out / 'HOST_GEN.H').write_text('\n'.join(header))
    _, image, relocations, _ = mz(exe.read_bytes())
    image = bytearray(image)
    for offset in relocations:
        value = struct.unpack_from('<H', image, offset)[0]
        struct.pack_into('<H', image, offset, (value + load) & 0xFFFF)
    arena = bytearray(0x100000)
    arena[load << 4:(load << 4) + len(image)] = image
    # DS remains the exact 64 KiB baseline already used by the bounded host harness.
    state = (out / 'STATE.BIN').read_bytes()
    arena[data_segment << 4:(data_segment << 4) + len(state)] = state
    (out / 'HOST_IMAGE.BIN').write_bytes(arena)


def sdl_flags():
    if os.name != 'nt':
        return subprocess.check_output(['pkg-config', '--cflags', '--libs', 'sdl3'],
                                       text=True).split()
    lock = read_json(ROOT / 'metadata/sdl3.json')
    deps = ROOT / 'build/deps'
    sdk = deps / ('SDL3-' + lock['version']) / 'x86_64-w64-mingw32'
    if not (sdk / 'include/SDL3/SDL.h').is_file():
        deps.mkdir(parents=True, exist_ok=True)
        archive = deps / ('SDL3-devel-' + lock['version'] + '-mingw.zip')
        if not archive.is_file() or sha(archive.read_bytes()) != lock['sha256']:
            with urllib.request.urlopen(lock['mingw_zip'], timeout=60) as response:
                archive.write_bytes(response.read())
        if sha(archive.read_bytes()) != lock['sha256']:
            raise ValueError('SDL3 SDK hash mismatch')
        with zipfile.ZipFile(archive) as zipped:
            for name in zipped.namelist():
                if not (deps / name).resolve().is_relative_to(deps.resolve()):
                    raise ValueError('SDK path leaves build/deps')
            zipped.extractall(deps)
    return ['-I' + str(sdk / 'include'), str(sdk / 'lib/libSDL3.dll.a')], sdk


def build(full=True):
    out = ROOT / 'build/host'
    generate_state(out)
    compiler = os.environ.get('CC', 'gcc')
    command = [compiler, '-std=c11', '-O2', '-Wall', '-Wextra', '-Werror',
               '-Wno-unknown-pragmas', '-fno-strict-aliasing', '-DOVERKILL_HOST',
               '-shared', '-I' + str(out), '-I' + str(ROOT / 'c'),
               '-I' + str(ROOT / 'host')]
    if os.name != 'nt':
        command += ['-fPIC']
    if full:
        sources = sorted((ROOT / 'c').glob('*.c'))
        sources += [p for p in sorted((ROOT / 'host').glob('*.c')) if p.name != 'main.c']
        sources += [ROOT / 'third_party/nuked_opl3/opl3.c']
    else:
        sources = [ROOT / p for p in ('c/input_normalize.c', 'c/movement.c', 'c/pools.c', 'c/terrain.c', 'c/combat.c', 'c/pod_motion.c', 'c/render.c', 'host/memory.c', 'host/level_encounter.c',
                   'host/input_services.c', 'host/sdl_input.c', 'host/sdl_gamepad.c', 'host/sdl_video.c', 'host/render_services.c', 'host/clock_services.c',
                   'host/resource_services.c', 'host/file_services.c', 'host/video_services.c', 'host/text_video.c')]
    command += [str(p) for p in sources]
    flags = sdl_flags()
    library = out / ('OVERKILL_CORE.dll' if os.name == 'nt' else 'liboverkill_core.so')
    if os.name == 'nt':
        flags, sdk = flags
        if subprocess.check_output([compiler, '-dumpmachine'], text=True).strip() != 'x86_64-w64-mingw32':
            raise ValueError('the pinned SDL SDK requires x86_64-w64-mingw32 GCC')
        shutil.copyfile(sdk / 'bin/SDL3.dll', out / 'SDL3.dll')
        command += ['-static-libgcc']
        command += ['-Wl,--out-implib=' + str(out / 'liboverkill_core.dll.a')]
        if full:
            flags += ['-lwinmm']
    subprocess.run(command + list(flags) + ['-o', str(library)], check=True)
    print('Native core:', library)
    if full:
        executable = out / ('OVERKILL_SDL3.exe' if os.name == 'nt' else 'overkill_sdl3')
        entry = [compiler, '-std=c11', '-O2', '-Wall', '-Wextra', '-Werror',
                 '-Wno-unknown-pragmas', '-fno-strict-aliasing', '-DOVERKILL_HOST',
                 '-I' + str(out), '-I' + str(ROOT / 'c'), '-I' + str(ROOT / 'host'),
                 str(ROOT / 'host/main.c')]
        if os.name == 'nt':
            entry += ['-static-libgcc', str(out / 'liboverkill_core.dll.a')]
        else:
            entry += ['-L' + str(out), '-loverkill_core', '-Wl,-rpath,$ORIGIN']
        subprocess.run(entry + list(flags) + ['-o', str(executable)], check=True)
        assets = out / 'assets'
        assets.mkdir(exist_ok=True)
        for item in read_json(ROOT / 'metadata/inputs.json')['files']:
            source = ROOT / item['path']
            if source.stat().st_size != item['size'] or sha(source.read_bytes()) != item['sha256']:
                raise ValueError('original asset mismatch: ' + item['path'])
            shutil.copyfile(source, assets / source.name)
        from level_format import original_paths
        levels = out / 'levels/original'
        levels.mkdir(parents=True, exist_ok=True)
        for path in original_paths():
            shutil.copyfile(path, levels / path.name)
        (out / 'saves').mkdir(exist_ok=True)
        licenses = out / 'licenses'
        licenses.mkdir(exist_ok=True)
        for source in (ROOT / 'third_party/nuked_opl3/LICENSE',
                       ROOT / 'third_party/font8x8/Dominus-copying.txt',
                       ROOT / 'third_party/font8x8/README.md'):
            shutil.copyfile(source, licenses / (source.parent.name + '-' + source.name))
        if os.name == 'nt':
            shutil.copyfile(sdk.parent / 'LICENSE.txt', licenses / 'SDL3-LICENSE.txt')
        print('Native game:', executable)
    return library


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--full', action='store_true', help='link all native game and platform regions')
    parser.add_argument('--core', action='store_true', help='build only the smaller bounded core harness')
    args = parser.parse_args()
    build(full=not args.core)
