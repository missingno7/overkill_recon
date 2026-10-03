"""Export canonical resource/terrain original level fixtures from the exact ASM build.

No original program is executed. --check compares fixtures without overwriting;
--no-build reuses the existing source-built oracle after checking its pinned hash.
"""
from common import ROOT, read_json, sha, write_json
from extract import mz
from level_format import load, original_paths, validate, TILE_ATTRIBUTES
import argparse
from pathlib import Path
import struct


def resource_bindings(machine, level):
    state = machine.state()
    def filename(table, displacement):
        slot = (machine.offset(table) + displacement) & 0xFFFF
        pointer = struct.unpack_from('<H', state, slot)[0]
        end = state.index(0, pointer)
        return state[pointer:end].decode('ascii')
    return {
        'map': filename('LevelMapFiles', level * 2),
        'sprites': filename('LevelBankFiles', level * 4),
        'blocks': filename('LevelBankFiles', level * 4 + 2),
        'plaque': filename('PlaqueFiles', level * 2),
    }


def definitions(machine):
    return [validate({
        'format': 'overkill-level', 'version': 1,
        'profile': 'level-bindings', 'id': f'original-level-{level}',
        'resources': resource_bindings(machine, level),
        'terrain': terrain_definition(machine, level),
    }) for level in range(6)]


def terrain_definition(machine, level):
    state = machine.state()
    slot = (machine.offset('AttributePatchPointers') + level * 2) & 0xFFFF
    cursor = struct.unpack_from('<H', state, slot)[0]
    names = {value: name for name, value in TILE_ATTRIBUTES.items()}
    patches = []
    # Static original streams must terminate; never silently truncate bad input.
    for _ in range(0x10000):
        tile = state[cursor]
        cursor = (cursor + 1) & 0xFFFF
        if tile == 255:
            return {'default': 'wall', 'attribute_patches': patches}
        value = state[cursor]
        cursor = (cursor + 1) & 0xFFFF
        if value not in names:
            raise ValueError(f'level {level}: unmodeled original tile attribute {value}')
        patches.append({'tile': tile, 'attribute': names[value]})
    raise ValueError(f'level {level}: original attribute stream has no terminator')


def exact_oracle(no_build=False):
    if no_build:
        exe = ROOT / 'build/oracle-sym/OVERKILL.EXE'
    else:
        import hybrid
        exe, _ = hybrid.build(ROOT / 'build/oracle-sym', with_c=False)
    _, image, _, _ = mz(exe.read_bytes())
    pinned = read_json(ROOT / 'metadata/oracle.json')
    if len(image) != pinned['program_bytes'] or sha(image) != pinned['program_sha256']:
        raise ValueError('level export requires the exact source-built oracle')
    from emu import Machine
    return Machine(exe)


def export(directory=None, check=False, no_build=False):
    generated = definitions(exact_oracle(no_build))
    for path, document in zip(original_paths(directory), generated):
        if check:
            if load(path) != document:
                raise ValueError(f'{path}: resource fixture differs from the oracle')
        else:
            write_json(path, document)
        print(('PASS' if check else 'Exported') + ': ' + path.name)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--check', action='store_true')
    parser.add_argument('--no-build', action='store_true')
    args = parser.parse_args()
    export(args.output, args.check, args.no_build)


if __name__ == '__main__':
    main()
