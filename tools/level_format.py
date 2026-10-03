"""Validate the implemented resource-bindings slice of Overkill level JSON.

This deliberately does not accept unimplemented gameplay sections or certify a
playable level. Run without arguments to validate the six original fixtures.
"""
from common import ROOT, read_json
import argparse
from pathlib import Path
import re

RESOURCE_ROLES = ('map', 'sprites', 'blocks', 'plaque')


def validate(document):
    if not isinstance(document, dict) or set(document) != {
            'format', 'version', 'profile', 'id', 'resources'}:
        raise ValueError('expected format, version, profile, id and resources only')
    if document['format'] != 'overkill-level':
        raise ValueError('format must be overkill-level')
    if type(document['version']) is not int or document['version'] != 1:
        raise ValueError('unsupported level version')
    if document['profile'] != 'resource-bindings':
        raise ValueError('only the resource-bindings profile is implemented')
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
    return document


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
        load(path)
        print('PASS resource-bindings:', path.name)


if __name__ == '__main__':
    main()
