"""Validate the implemented structured-data slice of Overkill level JSON.

This deliberately does not accept unimplemented gameplay sections or certify a
playable level. Run without arguments to validate the six original fixtures.
"""
from common import ROOT, read_json
from world import K
from level_presets import ARCHETYPES, SIZES, LAYERS, DROPS
from level_paths import validate_path_sections
from level_map_recipes import validate_map_spawns
from level_departure import validate_departure
from level_encounter import validate_encounter
from level_invaders import validate_marching_formation
from level_boss import validate_boss
from level_groups import validate_map_group_drops
from level_policies import validate_level_policies
from level_timeline import validate_formation_spawn_parameters
from level_leaders import validate_authored_leader_paths
import argparse
from pathlib import Path
import re

RESOURCE_ROLES = ('map', 'sprites', 'blocks', 'plaque')
TILE_ATTRIBUTES = {'open': 0, 'wall': 1, 'shot_permeable_wall': 2}


def validate(document):
    if not isinstance(document, dict):
        raise ValueError('expected a level object')
    fields = {'format', 'version', 'profile', 'id', 'resources'}
    profile = document.get('profile')
    if profile == 'level-bindings':
        fields.add('terrain')
        if 'checkpoints' in document:
            fields.add('checkpoints')
        if 'timeline' in document or 'formations' in document:
            fields.update(('timeline', 'formations'))
        fields.update(name for name in ('paths', 'leader_paths', 'map_spawns', 'departure', 'encounter',
                                       'marching_formation', 'boss', 'map_spawn_parameters',
                                       'map_group_drops', 'checkpoint_restart', 'music', 'formation_spawn_parameters') if name in document)
    elif profile != 'resource-bindings':
        raise ValueError('only resource-bindings and level-bindings profiles are implemented')
    if 'compatibility' in document:
        fields.add('compatibility')
        compatibility = document['compatibility']
        if (document.get('version') not in (8, 9, 10, 11) or profile != 'level-bindings' or
                not isinstance(compatibility, dict) or set(compatibility) != {'original_level'} or
                type(compatibility['original_level']) is not int or
                not 0 <= compatibility['original_level'] < 6):
            raise ValueError('loose content requires an explicit original_level behavior profile (0..5)')
    if set(document) != fields:
        raise ValueError('expected exactly: ' + ', '.join(sorted(fields)))
    if document['format'] != 'overkill-level':
        raise ValueError('format must be overkill-level')
    if type(document['version']) is not int or document['version'] not in (1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11):
        raise ValueError('unsupported level version')
    if not isinstance(document['id'], str) or len(document['id']) > 127 or not re.fullmatch(
            r'[a-z][a-z0-9_-]*', document['id']):
        raise ValueError('id must be a lowercase semantic identifier')
    resources = document['resources']
    if not isinstance(resources, dict) or set(resources) != set(RESOURCE_ROLES):
        raise ValueError('resources must specify map, sprites, blocks and plaque')
    for role, name in resources.items():
        if role == 'map' and isinstance(name, dict):
            if (document['version'] not in (8, 9, 10, 11) or set(name) != {'path', 'encoding', 'columns', 'rows'} or
                    name['encoding'] != 'tile-grid' or type(name['columns']) is not int or
                    name['columns'] != 13 or type(name['rows']) is not int or name['rows'] != 288):
                raise ValueError('local map requires version 8..11 and a 13 by 288 tile-grid')
            if (not isinstance(name['path'], str) or len(name['path']) > 1023 or not re.fullmatch(
                    r'[a-zA-Z0-9_-]+(?:/[a-zA-Z0-9_-]+)*\.bin', name['path'])):
                raise ValueError('local map path must be a safe relative .bin path')
            continue
        extension = '(?:enc|ENC)' if role == 'plaque' else '(?:bic|BIC)'
        if not isinstance(name, str) or not re.fullmatch(
                r'[a-zA-Z0-9_-]+\.' + extension, name):
            raise ValueError(f'{role}: expected a BIC or ENC asset basename for this role')
    if profile == 'level-bindings':
        terrain = document['terrain']
        if not isinstance(terrain, dict) or set(terrain) != {'default', 'attribute_patches'}:
            raise ValueError('terrain must specify default and attribute_patches only')
        if terrain['default'] != 'wall':
            raise ValueError('this profile initializes terrain attributes to wall')
        patches = terrain['attribute_patches']
        if not isinstance(patches, list):
            raise ValueError('attribute_patches must be an ordered list')
        for patch in patches:
            if not isinstance(patch, dict) or set(patch) != {'tile', 'attribute'}:
                raise ValueError('each attribute patch must specify tile and attribute')
            if type(patch['tile']) is not int or not 0 <= patch['tile'] < 255:
                raise ValueError('patch tile must be 0..254; 255 terminates the legacy stream')
            if not isinstance(patch['attribute'], str) or patch['attribute'] not in TILE_ATTRIBUTES:
                raise ValueError('unknown tile attribute')
    if 'checkpoints' in document:
        checkpoints = document['checkpoints']
        count = len(checkpoints) if isinstance(checkpoints, list) else 0
        if not (count == 4 if document['version'] < 9 else 1 <= count <= 65535):
            raise ValueError('checkpoints require four entries before version 9, or a nonempty list in version 9')
        previous_row = -1
        for checkpoint in checkpoints:
            if not isinstance(checkpoint, dict) or set(checkpoint) != {
                    'map_row', 'script_clock', 'resume_event'}:
                raise ValueError('checkpoint must specify map_row, script_clock and resume_event')
            for field, maximum in (('map_row', 0xFFFF // K.MAP_ROW_BYTES),
                                   ('script_clock', 0xFFFF), ('resume_event', 0xFFFF)):
                if type(checkpoint[field]) is not int or not 0 <= checkpoint[field] <= maximum:
                    raise ValueError(f'checkpoint {field} is outside its unsigned binding range')
            if checkpoint['map_row'] <= previous_row:
                raise ValueError('checkpoint map rows must increase')
            previous_row = checkpoint['map_row']
    if 'timeline' in document:
        formations = document['formations']
        if not isinstance(formations, dict):
            raise ValueError('formations must be a named object')
        for name, formation in formations.items():
            if not isinstance(name, str) or len(name) > 127 or not re.fullmatch(r'[a-z][a-z0-9_]*', name):
                raise ValueError('formation names must be semantic identifiers')
            if not isinstance(formation, dict) or set(formation) != {'enemy', 'size', 'layer', 'members'}:
                raise ValueError('formation must specify enemy, size, layer and members')
            for field, choices in (('enemy', ARCHETYPES), ('size', SIZES), ('layer', LAYERS)):
                if not isinstance(formation[field], str) or formation[field] not in choices:
                    raise ValueError('unknown formation ' + field)
            members = formation['members']
            if not isinstance(members, list) or not 1 <= len(members) <= 65535:
                raise ValueError('formations require a nonempty ordered member list')
            for member in members:
                if not isinstance(member, dict) or set(member) != {'dx', 'dy'}:
                    raise ValueError('member must specify dx and dy')
                for coordinate in member.values():
                    if type(coordinate) is not int or not -32768 <= coordinate <= 32767:
                        raise ValueError('member offsets must be signed words')
        timeline = document['timeline']
        if not isinstance(timeline, list):
            raise ValueError('timeline must be an ordered event list')
        previous_clock = 65535
        for event in timeline:
            fields = {'clock', 'formation', 'x', 'y', 'group'}
            if isinstance(event, dict) and 'compatibility' in event:
                fields.add('compatibility')
                if event['compatibility'] != {'clear_event_marker': True} or type(
                        event['compatibility']['clear_event_marker']) is not bool:
                    raise ValueError('only clear_event_marker=true compatibility is implemented')
            if not isinstance(event, dict) or set(event) != fields:
                raise ValueError('event must specify clock, formation, x, y and group')
            if type(event['clock']) is not int or not 0 <= event['clock'] < 65535:
                raise ValueError('event clock must be an unsigned word below the terminator')
            if event['clock'] > previous_clock:
                raise ValueError('event clocks must be non-increasing')
            previous_clock = event['clock']
            if not isinstance(event['formation'], str) or event['formation'] not in formations:
                raise ValueError('event references an undefined formation')
            for coordinate in (event['x'], event['y']):
                if type(coordinate) is not int or not -32768 <= coordinate <= 32767:
                    raise ValueError('event origins must be signed words')
            group = event['group']
            if not isinstance(group, dict) or set(group) != {'drop'} or not isinstance(
                    group['drop'], str) or group['drop'] not in DROPS:
                raise ValueError('event group must specify a known drop')
        if any(checkpoint['resume_event'] > len(timeline)
               for checkpoint in document.get('checkpoints', [])):
            raise ValueError('checkpoint resume_event has no timeline boundary')
    validate_path_sections(document)
    if document['version'] >= 11:
        validate_authored_leader_paths(document)
    validate_map_spawns(document)
    validate_map_group_drops(document)
    validate_level_policies(document)
    validate_formation_spawn_parameters(document)
    validate_departure(document)
    validate_encounter(document)
    validate_marching_formation(document)
    validate_boss(document)
    return document


def encode_attribute_patches(terrain):
    """Validated semantic patches -> ordered legacy pairs and tile-only terminator."""
    return bytes(value for patch in terrain['attribute_patches']
                 for value in (patch['tile'], TILE_ATTRIBUTES[patch['attribute']])) + b'\xff'


def load(path):
    try:
        return validate(read_json(path))
    except (ValueError, TypeError) as error:
        raise ValueError(f'{path}: {error}') from error


def original_paths(directory=None):
    directory = Path(directory or ROOT / 'levels/original')
    return [directory / f'level{level}.lvl' for level in range(6)]


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('files', nargs='*', type=Path)
    args = parser.parse_args()
    for path in args.files or original_paths():
        document = load(path)
        print('PASS ' + document['profile'] + ':', path.name)


if __name__ == '__main__':
    main()
