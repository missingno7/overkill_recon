"""The unique segmented boss's member data; construction and combat stay procedural."""
import struct
from level_paths import validate_point

ROLES = ('anchor', 'upper_right', 'core', 'lower_right')


def original_boss(machine):
    state, start = machine.state(), machine.offset('BossPartOffsets')
    parts = {}
    for index, role in enumerate(ROLES):
        dy, dx = struct.unpack_from('<hh', state, start + index * 4)
        # Small scalar equivalents of EncounterSegBossLevel/InitSegBossPartRecord.
        # Lower parts acquire their Y offsets during their subsequent updates.
        parts[role] = {'sprite': 32 + index,
                       'spawn_position': {'x': 32 if index in (1, 3) else 0, 'y': 0},
                       'offset': {'dx': dx, 'dy': dy}}
    return {'kind': 'segmented', 'hit_points': 200, 'parts': parts}


def validate_boss(document):
    if 'boss' not in document:
        return
    if document.get('encounter', {}).get('kind') != 'segmented_boss':
        raise ValueError('segmented boss data requires its encounter director')
    boss = document['boss']
    if not isinstance(boss, dict) or set(boss) != {'kind', 'hit_points', 'parts'}:
        raise ValueError('boss must specify kind, hit_points and parts')
    if boss['kind'] != 'segmented':
        raise ValueError('only the original segmented boss is implemented')
    if type(boss['hit_points']) is not int or not 0 <= boss['hit_points'] <= 65535:
        raise ValueError('boss hit_points must be an unsigned word')
    parts = boss['parts']
    if not isinstance(parts, dict) or set(parts) != set(ROLES):
        raise ValueError('segmented boss must specify its four named roles')
    for part in parts.values():
        if not isinstance(part, dict) or set(part) != {'sprite', 'spawn_position', 'offset'}:
            raise ValueError('boss part must specify sprite, spawn_position and offset')
        if type(part['sprite']) is not int or not 0 <= part['sprite'] <= 65535:
            raise ValueError('boss sprite must be an unsigned bank index')
        validate_point(part['spawn_position'])
        offset = part['offset']
        if not isinstance(offset, dict) or set(offset) != {'dx', 'dy'} or any(
                type(value) is not int or not -32768 <= value <= 32767 for value in offset.values()):
            raise ValueError('boss offsets must specify signed dx and dy')


def generate_boss_header(out, documents, machine):
    from level_format import validate
    if len(documents) != 6:
        raise ValueError('the original native binding requires six level definitions')
    original = original_boss(machine)
    def members(boss):
        return '{' + ', '.join('{' + ', '.join(str(value & 65535) for value in (
            boss['parts'][role]['sprite'], boss['parts'][role]['spawn_position']['x'],
            boss['parts'][role]['spawn_position']['y'])) + '}' for role in ROLES) + '}'
    lines = ['/* Generated from validated segmented-boss data and exact source offsets. */',
             '#ifndef BOSSES_GEN_H', '#define BOSSES_GEN_H',
             'static const LevelBoss original_boss_data = {' + str(original['hit_points']) +
             ', ' + members(original) + ', 0};']
    bindings = []
    for index, document in enumerate(documents):
        validate(document)
        boss = document.get('boss', original)
        offsets = [boss['parts'][role]['offset'][field] & 65535
                   for role in ROLES for field in ('dy', 'dx')]
        reference = '0'
        if any(boss['parts'][role]['offset'] != original['parts'][role]['offset'] for role in ROLES):
            reference = f'level_{index}_boss_offsets'
            lines.append(f'static const uint16_t {reference}[] = {{' +
                         ', '.join(str(value) for value in offsets) + '};')
        bindings.append('    {' + str(boss['hit_points']) + ', ' + members(boss) + ', ' + reference + '}')
    lines += ['static const LevelBoss level_bosses[] = {', ',\n'.join(bindings), '};', '#endif', '']
    out.mkdir(parents=True, exist_ok=True)
    (out / 'BOSSES_GEN.H').write_text('\n'.join(lines))
