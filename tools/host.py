"""Build native input, movement, pools, terrain and combat from the shared DOS C.

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
import subprocess
import urllib.request
import zipfile
import hybrid
from extract import mz
from graph import read_map


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
    (out / 'STATE.BIN').write_bytes(image[base:base + size].ljust(0x10000, b'\0'))
    return offsets


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


def build():
    out = ROOT / 'build/host'
    generate_state(out)
    compiler = os.environ.get('CC', 'gcc')
    command = [compiler, '-std=c11', '-O2', '-Wall', '-Wextra', '-Werror',
               '-Wno-unknown-pragmas', '-fno-strict-aliasing', '-DOVERKILL_HOST',
               '-shared', '-I' + str(out), '-I' + str(ROOT / 'c'),
               '-I' + str(ROOT / 'host')]
    if os.name != 'nt':
        command += ['-fPIC']
    command += [str(ROOT / p) for p in ('c/input_normalize.c', 'c/movement.c', 'c/pools.c', 'c/terrain.c', 'c/combat.c', 'host/memory.c',
                'host/input_services.c', 'host/sdl_input.c')]
    flags = sdl_flags()
    library = out / ('OVERKILL_CORE.dll' if os.name == 'nt' else 'liboverkill_core.so')
    if os.name == 'nt':
        flags, sdk = flags
        if subprocess.check_output([compiler, '-dumpmachine'], text=True).strip() != 'x86_64-w64-mingw32':
            raise ValueError('the pinned SDL SDK requires x86_64-w64-mingw32 GCC')
        shutil.copyfile(sdk / 'bin/SDL3.dll', out / 'SDL3.dll')
        command += ['-static-libgcc']
        command += ['-Wl,--out-implib=' + str(out / 'liboverkill_core.dll.a')]
    subprocess.run(command + list(flags) + ['-o', str(library)], check=True)
    print('Native core:', library)
    return library


if __name__ == '__main__':
    build()
