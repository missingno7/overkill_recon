"""Create/validate a loose level with a new identity and an original behavior profile.

This first runtime slice owns its decoded map, restart rules and music. Other
sections must match the selected canonical definition; unsupported edits fail.
The source stays JSON/raw tiles, with no generated registration or DS slot.
"""
import argparse
import copy
import json
from pathlib import Path
from common import ROOT, write_json
from level_format import load, validate
from level_maps import decode_original_map, original_map_dimensions, unsupported_original_map_tiles


def validate_directory(directory, originals=None):
    directory = Path(directory)
    source = (directory / 'level.json').read_bytes()
    if len(source) > 1024 * 1024:
        raise ValueError('level JSON exceeds runtime 1 MiB limit')
    def unique_object(pairs):
        result = {}
        for key, value in pairs:
            if key in result:
                raise ValueError('duplicate JSON key: ' + key)
            result[key] = value
        return result
    document = json.loads(source, object_pairs_hook=unique_object)
    def token_count(value, depth=0):
        if isinstance(value, (dict, list)) and depth >= 64:
            raise ValueError('level JSON exceeds runtime nesting limit')
        if isinstance(value, dict):
            return 1 + len(value) + sum(token_count(v, depth + 1) for v in value.values())
        if isinstance(value, list):
            return 1 + sum(token_count(v, depth + 1) for v in value)
        return 1
    if token_count(document) > 65536:
        raise ValueError('level JSON exceeds runtime token limit')
    validate(document)
    if document['version'] != 8 or 'compatibility' not in document:
        raise ValueError('loose content requires version 8 and an explicit original behavior profile')
    index = document['compatibility']['original_level']
    original = load(Path(originals or ROOT / 'levels/original') / f'level{index}.lvl')
    supported = {'id', 'version', 'compatibility', 'resources', 'music', 'checkpoint_restart'}
    for name in (set(original) | set(document)) - supported:
        if original.get(name) != document.get(name):
            raise ValueError(f'{name}: independent runtime loading is not implemented yet')
    for role in ('sprites', 'blocks', 'plaque'):
        if document['resources'][role] != original['resources'][role]:
            raise ValueError(f'{role}: independent runtime loading is not implemented yet')
    for name in ('music', 'checkpoint_restart'):
        item = document.get(name)
        if item is None or ('compatibility' in item and item != original[name]):
            raise ValueError(f'{name}: missing or changed live-original policy')
    resource = document['resources']['map']
    if not isinstance(resource, dict):
        raise ValueError('loose content must own a decoded tile-grid map')
    path = (directory / resource['path']).resolve()
    if not path.is_relative_to(directory.resolve()):
        raise ValueError('map path escapes level directory')
    tiles = path.read_bytes()
    if len(tiles) != resource['columns'] * resource['rows']:
        raise ValueError('map size does not match grid dimensions')
    unsupported = unsupported_original_map_tiles(index)
    if unsupported.intersection(tiles) or any(rule['replacement'] in unsupported
            for rule in document['checkpoint_restart']['tile_restorations']):
        raise ValueError('map/restoration contains an unmodeled original spawn-dispatch cell')
    return document


def duplicate_original(index, directory, identity, music=None):
    directory = Path(directory)
    if directory.exists() and any(directory.iterdir()):
        raise ValueError('output directory must be empty; existing level content is not overwritten')
    document = copy.deepcopy(load(ROOT / 'levels/original' / f'level{index}.lvl'))
    document.update(version=8, id=identity, compatibility={'original_level': index})
    columns, rows = original_map_dimensions(index)
    document['resources']['map'] = {'path': 'map.bin', 'encoding': 'tile-grid',
                                  'columns': columns, 'rows': rows}
    document['checkpoint_restart'].pop('compatibility')
    document['music'].pop('compatibility')
    if music is not None:
        document['music']['level'] = music
    validate(document)
    directory.mkdir(parents=True, exist_ok=True)
    (directory / 'map.bin').write_bytes(decode_original_map(index))
    write_json(directory / 'level.json', document)
    validate_directory(directory)
    return document


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    sub = parser.add_subparsers(dest='command', required=True)
    duplicate = sub.add_parser('duplicate')
    duplicate.add_argument('original', type=int, choices=range(6))
    duplicate.add_argument('directory', type=Path)
    duplicate.add_argument('--id', required=True)
    duplicate.add_argument('--music', type=int)
    check = sub.add_parser('validate')
    check.add_argument('directory', type=Path)
    args = parser.parse_args()
    if args.command == 'duplicate':
        duplicate_original(args.original, args.directory, args.id, args.music)
    document = validate_directory(args.directory)
    print('PASS loose content:', document['id'])


if __name__ == '__main__':
    main()
