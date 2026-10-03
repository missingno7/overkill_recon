"""Validate the implemented resource/terrain slice of Overkill level JSON.

This deliberately does not accept unimplemented gameplay sections or certify a
playable level. Run without arguments to validate the six original fixtures.
"""
from common import ROOT, read_json
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
    elif profile != 'resource-bindings':
        raise ValueError('only resource-bindings and level-bindings profiles are implemented')
    if set(document) != fields:
        raise ValueError('expected exactly: ' + ', '.join(sorted(fields)))
    if document['format'] != 'overkill-level':
        raise ValueError('format must be overkill-level')
    if type(document['version']) is not int or document['version'] != 1:
        raise ValueError('unsupported level version')
    if not isinstance(document['id'], str) or not re.fullmatch(
            r'[a-z][a-z0-9_-]*', document['id']):
        raise ValueError('id must be a lowercase semantic identifier')
    resources = document['resources']
    if not isinstance(resources, dict) or set(resources) != set(RESOURCE_ROLES):
        raise ValueError('resources must specify map, sprites, blocks and plaque')
    for role, name in resources.items():
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
