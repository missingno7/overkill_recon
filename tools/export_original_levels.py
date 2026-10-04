"""Export canonical original level fixtures from the exact ASM build.

No original program is executed. --check compares fixtures without overwriting;
--no-build reuses the existing source-built oracle after checking its pinned hash.
"""
from common import ROOT, read_json, sha, write_json
from extract import mz
from world import K
from level_format import load, original_paths, validate, TILE_ATTRIBUTES
from level_presets import ARCHETYPES, SIZES, LAYERS, DROPS, formation_id
from level_paths import level_path_definitions, source_paths
from level_waypoints import ORDINARY_WAYPOINT_NAMES
from level_map_recipes import original_map_spawns, original_map_spawn_parameters
from level_departure import departure_definition
from level_encounter import original_encounter
from level_invaders import original_invader_slots, original_marching_formation
from level_boss import original_boss
from level_groups import original_map_group_drops
from level_policies import original_checkpoint_restart, original_music
from level_timeline import original_formation_spawn_parameters
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
    documents = []
    for level in range(6):
        formations, timeline = timeline_definition(machine, level)
        paths, leaders = level_path_definitions(machine, level, formations)
        encounter = original_encounter(level)
        if encounter['kind'] == 'invader_formation':
            encounter['slots'] = original_invader_slots(machine)
        document = {
            'format': 'overkill-level', 'version': 9,
            'profile': 'level-bindings', 'id': f'original-level-{level}',
            'resources': resource_bindings(machine, level),
            'terrain': terrain_definition(machine, level),
            'checkpoints': checkpoint_definitions(machine, level),
            'checkpoint_restart': original_checkpoint_restart(machine, level),
            'music': original_music(machine, level),
            'formations': formations, 'timeline': timeline,
            'formation_spawn_parameters': original_formation_spawn_parameters(level),
            'paths': paths, 'leader_paths': leaders,
            'map_spawns': original_map_spawns(level),
            'map_spawn_parameters': original_map_spawn_parameters(level),
            'map_group_drops': original_map_group_drops(machine),
            'departure': departure_definition(machine),
            'encounter': encounter,
            'marching_formation': original_marching_formation(level),
        }
        if encounter['kind'] == 'segmented_boss':
            document['boss'] = original_boss(machine)
        documents.append(validate(document))
    return documents


def source_formations(machine):
    """Named original storage identities and structured formation definitions."""
    state = machine.state()
    enemies = {value: name for name, value in ARCHETYPES.items()}
    sizes = {value: name for name, value in SIZES.items()}
    layers = {value: name for name, value in LAYERS.items()}
    bindings = {}
    for index in range(53):
        cursor = machine.offset(f'Formation{index:02}')
        size, layer, enemy, count = struct.unpack_from('<4H', state, cursor)
        if size not in sizes or layer not in layers or enemy not in enemies or count == 0:
            raise ValueError(f'Formation{index:02}: unmodeled header')
        members = [{'dx': dx, 'dy': dy} for dx, dy in
                   struct.iter_unpack('<hh', state[cursor + 8:cursor + 8 + count * 4])]
        definition = {'enemy': enemies[enemy], 'size': sizes[size],
                      'layer': layers[layer], 'members': members}
        name = formation_id(definition)
        if name in bindings:
            raise ValueError('ambiguous original formation identity: ' + name)
        bindings[name] = (cursor, definition)
    return bindings


def timeline_definition(machine, level):
    state = machine.state()
    bindings = source_formations(machine)
    by_cursor = {cursor: name for name, (cursor, _) in bindings.items()}
    drops = {value: name for name, value in DROPS.items()}
    formations, timeline = {}, []
    for cursor in script_event_boundaries(machine, level)[:-1]:
        clock, formation = struct.unpack_from('<2H', state, cursor)
        marker = formation == 0xFFFF
        cursor += 2
        if marker:
            cursor += 2
        formation, x, y = struct.unpack_from('<Hhh', state, cursor)
        name = by_cursor[formation]
        formations[name] = bindings[name][1]
        drop = state[machine.offset('GroupDropKinds') + (clock & 0x3F)]
        event = {'clock': clock, 'formation': name, 'x': x, 'y': y,
                 'group': {'drop': drops[drop]}}
        if marker:
            event['compatibility'] = {'clear_event_marker': True}
        timeline.append(event)
    return formations, timeline


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


def script_event_boundaries(machine, level):
    """Event ordinal -> source cursor, including the terminating event boundary.

    Only the original record framing is decoded here. Formation definitions and
    timeline behavior remain in their existing implementations.
    """
    state = machine.state()
    cursor = machine.offset(f'LevelScript{level}')
    boundaries = []
    for _ in range(0x10000 // 8):
        if cursor + 2 > len(state):
            break
        boundaries.append(cursor)
        trigger = struct.unpack_from('<H', state, cursor)[0]
        if trigger == 0xFFFF:
            return boundaries
        if cursor + 8 > len(state):
            break
        marker = struct.unpack_from('<H', state, cursor + 2)[0]
        cursor += 10 if marker == 0xFFFF else 8
    raise ValueError(f'level {level}: script has no bounded terminator')


def checkpoint_definitions(machine, level):
    state = machine.state()
    slot = machine.offset('LevelCheckpointPtrs') + level * 2
    cursor = struct.unpack_from('<H', state, slot)[0]
    boundaries = script_event_boundaries(machine, level)
    checkpoints = []
    for index in range(4):
        position, clock, script_cursor = struct.unpack_from('<3H', state, cursor + index * 8)
        row, remainder = divmod(position, K.MAP_ROW_BYTES)
        if remainder or script_cursor not in boundaries:
            raise ValueError(f'level {level}: checkpoint is not a row/event boundary')
        if index < 3:
            threshold = struct.unpack_from('<H', state, cursor + index * 8 + 6)[0]
            following = struct.unpack_from('<H', state, cursor + (index + 1) * 8)[0]
            if threshold != following:
                raise ValueError(f'level {level}: independent checkpoint threshold needs modeling')
        checkpoints.append({'map_row': row, 'script_clock': clock,
                            'resume_event': boundaries.index(script_cursor)})
    return checkpoints


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
    machine = exact_oracle(no_build)
    generated = definitions(machine)
    for path, document in zip(original_paths(directory), generated):
        if check:
            if load(path) != document:
                raise ValueError(f'{path}: level fixture differs from the oracle')
        else:
            write_json(path, document)
        print(('PASS' if check else 'Exported') + ': ' + path.name)
    shared = (Path(directory) / 'shared/waypoint-presets.json' if directory else
              ROOT / 'levels/shared/waypoint-presets.json')
    sources = source_paths(machine)
    presets = {name: sources[name][2] for name in ORDINARY_WAYPOINT_NAMES}
    if check:
        if read_json(shared) != presets:
            raise ValueError(f'{shared}: shared waypoint presets differ from the oracle')
    else:
        write_json(shared, presets)
    print(('PASS' if check else 'Exported') + ': ' + shared.name)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path)
    parser.add_argument('--check', action='store_true')
    parser.add_argument('--no-build', action='store_true')
    args = parser.parse_args()
    export(args.output, args.check, args.no_build)


if __name__ == '__main__':
    main()
