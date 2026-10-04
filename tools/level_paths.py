"""Original path stream bindings, with public points in playfield coordinates.

These codecs retain the distinct stream readers; they do not implement movement.
Source labels describe storage identities and fixed synchronization boundaries.
"""
import re
import struct
from world import K

PATH_BINDINGS = {
    'path_follower_a': ('SteerPath10', 'fly_off'),
    'path_follower_b': ('SteerPath11', 'fly_off'),
    'path_follower_c': ('Type41Path', 'fly_off'),
    'path_follower_d': ('Type43Path', 'fly_off'),
    'path_follower_e': ('Type44Path', 'fly_off'),
    'path_follower_f': ('Type45Path', 'fly_off'),
    'path_follower_g': ('Type4APath', 'fly_off'),
    'demo_path_follower': ('Type51Path', 'fly_off'),
    'path_follower_left': ('PathType66', 'fly_off'),
    'path_follower_right': ('PathType67', 'fly_off'),
    'sweep_lead_in': ('SweepPathLeadIn', 'continue'),
    'sweep_loop': ('SweepPath', 'jump'),
    'encounter_leader': ('Type21Path', 'restart'),
    'boss_anchor': ('BossPath', 'restart'),
}
LEADER_BINDINGS = {
    'sway_leader': ('LeaderScript13', 4),
    'sweep_leader': ('LeaderScript15', 8),
    'bob_chase_leader': ('LeaderScript1C', 8),
    'slot_hopper_leader': ('LeaderScript1F', 4),
    'sweeper_leader': ('LeaderScript7D', 8),
    'march_leader': ('LeaderScript7E', 8),
}


def signed(value):
    return (value + 32768) % 65536 - 32768


def point(state, cursor):
    y, x = struct.unpack_from('<2H', state, cursor)
    return {'x': signed(x), 'y': signed(y + 32)}


def encode_point(value):
    return struct.pack('<2H', (value['y'] - 32) & 65535, value['x'] & 65535)


def source_paths(machine):
    state = machine.state()
    result = {}
    for name, (label, ending) in PATH_BINDINGS.items():
        start = cursor = machine.offset(label)
        points = []
        for _ in range(65536 // 4):
            if ending == 'continue' and cursor == machine.offset('SweepPath'):
                end = {'kind': 'continue', 'path': 'sweep_loop'}
                break
            y = struct.unpack_from('<H', state, cursor)[0]
            if ending == 'fly_off' and y == K.LEADER_END_Y:
                end = {'kind': 'fly_off', 'x': point(state, cursor)['x']}
                cursor += 4
                break
            if ending in ('restart', 'jump') and y == 65535:
                end = {'kind': ending}
                cursor += 2
                if ending == 'jump':
                    target = struct.unpack_from('<H', state, cursor)[0]
                    if target != start:
                        raise ValueError(label + ': unmodeled path jump')
                    end['path'] = name
                    cursor += 2
                break
            points.append(point(state, cursor))
            cursor += 4
        else:
            raise ValueError(label + ': no bounded ending')
        result[name] = (start, cursor - start, {'points': points, 'end': end})
    return result


def source_leaders(machine):
    state = machine.state()
    result = {}
    for name, (label, stride) in LEADER_BINDINGS.items():
        start, stop = machine.offset(label), machine.offset(label + 'End')
        if (stop - start) % stride or struct.unpack_from('<H', state, stop)[0] != K.LEADER_END_Y:
            raise ValueError(label + ': unmodeled end boundary')
        steps = []
        for cursor in range(start, stop, stride):
            step = {'target': point(state, cursor)}
            if stride == 8:
                y, x = struct.unpack_from('<2H', state, cursor + 4)
                if y == 65535 and name != 'bob_chase_leader':
                    if x != 65535:
                        raise ValueError(label + ': unmodeled suppressed follower X')
                    step['follower'] = None
                else:
                    step['follower'] = point(state, cursor + 4)
            steps.append(step)
        definition = {'steps': steps, 'end': {'kind': 'fly_off', 'x': point(state, stop)['x']}}
        if name == 'slot_hopper_leader':
            definition['slots'] = [point(state, cursor) for cursor in range(
                machine.offset('FormationSlots'), machine.offset('FormationSlotsEnd'), 4)]
        result[name] = (start, stop - start + 4, definition)
    return result


def level_path_definitions(machine, level, formations):
    paths, leaders = source_paths(machine), source_leaders(machine)
    enemies = {formation['enemy'] for formation in formations.values()}
    selected_paths = {name for name in enemies if name in paths}
    selected_leaders = {name for name in enemies if name in leaders}
    if 'sweep_leader' in enemies:
        selected_paths.update(('sweep_lead_in', 'sweep_loop'))
    # These dependencies belong to the existing encounter director specializations.
    if level == 0:
        selected_paths.add('boss_anchor')
    if level == 4:
        selected_paths.add('encounter_leader')
    return ({name: paths[name][2] for name in sorted(selected_paths)},
            {name: leaders[name][2] for name in sorted(selected_leaders)})


def validate_point(value):
    if not isinstance(value, dict) or set(value) != {'x', 'y'} or any(
            type(coordinate) is not int or not -32768 <= coordinate <= 32767
            for coordinate in value.values()):
        raise ValueError('path points must specify signed playfield x and y')


def validate_end(end, paths, leader=False, available_paths=None):
    if not isinstance(end, dict):
        raise ValueError('path ending must be an object')
    kind = end.get('kind')
    if kind == 'fly_off':
        if set(end) != {'kind', 'x'} or type(end['x']) is not int or not -32768 <= end['x'] <= 32767:
            raise ValueError('fly_off ending must specify signed x')
    elif not leader and kind == 'restart' and set(end) == {'kind'}:
        pass
    elif not leader and kind in ('jump', 'continue') and set(end) == {'kind', 'path'}:
        known_paths = paths if available_paths is None else available_paths
        if not isinstance(end['path'], str) or end['path'] not in known_paths:
            raise ValueError('path ending references an undefined path')
    else:
        raise ValueError('unsupported path ending')


def validate_path_sections(document):
    paths = document.get('paths', {})
    leaders = document.get('leader_paths', {})
    for section in (paths, leaders):
        if not isinstance(section, dict) or any(not isinstance(name, str) or not re.fullmatch(
                r'[a-z][a-z0-9_]*', name) for name in section):
            raise ValueError('path sections must be named objects')
    available_paths = set(paths)
    if document.get('version', 0) >= 12:
        # v12 path references can resolve to a borrowed original special
        # preset even when that path is omitted from the owned section.
        from level_special_paths import SPECIAL_PATH_NAMES
        available_paths.update(SPECIAL_PATH_NAMES)
    for definition in paths.values():
        if not isinstance(definition, dict) or set(definition) != {'points', 'end'} or not isinstance(
                definition['points'], list) or not definition['points']:
            raise ValueError('path must specify nonempty points and end')
        for value in definition['points']:
            validate_point(value)
        validate_end(definition['end'], paths, available_paths=available_paths)
    for name, definition in leaders.items():
        fields = {'steps', 'end'} | ({'slots'} if name == 'slot_hopper_leader' else set())
        if name not in LEADER_BINDINGS or not isinstance(definition, dict) or set(definition) != fields:
            raise ValueError('leader path must specify its supported steps, end and slots')
        steps = definition['steps']
        if not isinstance(steps, list) or not steps:
            raise ValueError('leader path requires nonempty steps')
        for step in steps:
            fields = {'target'} | ({'follower'} if LEADER_BINDINGS[name][1] == 8 else set())
            if not isinstance(step, dict) or set(step) != fields:
                raise ValueError('leader step has the wrong fields for its existing behavior')
            validate_point(step['target'])
            if 'follower' in step:
                if step['follower'] is None and name != 'bob_chase_leader':
                    continue
                validate_point(step['follower'])
        validate_end(definition['end'], paths, leader=True)
        if 'slots' in definition:
            if not isinstance(definition['slots'], list) or not definition['slots']:
                raise ValueError('leader slots require nonempty positions')
            for slot in definition['slots']:
                validate_point(slot)


def bind_path_sections(machine, documents, state, default_formations):
    paths, leaders = source_paths(machine), source_leaders(machine)
    shared = {}
    def write(start, payload, label):
        if start in shared and shared[start] != payload:
            raise ValueError('conflicting shared path binding: ' + label)
        shared[start] = payload
        state[start:start + len(payload)] = payload
    for level, document in enumerate(documents):
        default_paths, default_leaders = level_path_definitions(machine, level,
            default_formations[level])
        # An omitted section retains originals, including their sharing constraints.
        for name, definition in {**default_paths, **document.get('paths', {})}.items():
            if name not in paths:
                raise ValueError('path has no original storage binding: ' + name)
            start, capacity, source = paths[name]
            end = definition['end']
            if end['kind'] != source['end']['kind']:
                raise ValueError('path ending does not match its existing reader: ' + name)
            if 'path' in end and end['path'] not in paths:
                raise ValueError('path jump has no original target binding')
            if end['kind'] == 'jump' and end['path'] != source['end']['path']:
                raise ValueError('path jump must retain its original reader target: ' + name)
            if end['kind'] == 'fly_off' and len(definition['points']) != len(source['points']):
                raise ValueError('fly-off path must retain its original point count: ' + name)
            payload = b''.join(encode_point(value) for value in definition['points'])
            if end['kind'] == 'fly_off':
                payload += struct.pack('<2H', K.LEADER_END_Y, end['x'] & 65535)
            elif end['kind'] == 'restart':
                payload += b'\xff\xff'
            elif end['kind'] == 'jump':
                payload += struct.pack('<2H', 65535, paths[end['path']][0])
            elif end['path'] != source['end']['path'] or len(payload) != capacity:
                raise ValueError('continued path must retain original adjacency and point count')
            if len(payload) > capacity:
                raise ValueError('path exceeds original storage capacity: ' + name)
            if end['kind'] in ('restart', 'jump', 'continue') and any(value['y'] == 31 for value in definition['points']):
                raise ValueError('path point collides with the original control marker')
            write(start, payload, name)
        for name, definition in {**default_leaders, **document.get('leader_paths', {})}.items():
            start, capacity, source = leaders[name]
            if len(definition['steps']) != len(source['steps']):
                raise ValueError('leader path must retain its synchronization boundary: ' + name)
            payload = bytearray()
            for step in definition['steps']:
                payload += encode_point(step['target'])
                if 'follower' in step:
                    follower = step['follower']
                    if follower is not None and follower['y'] == 31 and name != 'bob_chase_leader':
                        raise ValueError('follower position collides with the no-spawn marker')
                    payload += b'\xff' * 4 if follower is None else encode_point(follower)
            payload += struct.pack('<2H', K.LEADER_END_Y, definition['end']['x'] & 65535)
            write(start, payload, name)
            if 'slots' in definition:
                if len(definition['slots']) != len(source['slots']):
                    raise ValueError('leader slots must retain their original end boundary')
                write(machine.offset('FormationSlots'), b''.join(
                    encode_point(slot) for slot in definition['slots']), 'leader slots')
