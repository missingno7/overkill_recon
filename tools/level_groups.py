"""Original map-group drop cycles and their native immutable overrides.

The canonical cycle remains live DS data shared with event drops. Authored map
cycles can vary independently per level without changing that oracle storage.
"""
from level_presets import DROPS


def original_map_group_drops(machine):
    at = machine.offset('GroupDropKinds')
    names = {value: name for name, value in DROPS.items()}
    return {'kind': 'legacy_offset_cycle',
            'drops': [names[value] for value in machine.state()[at:at + 64]]}


def validate_map_group_drops(document):
    if 'map_group_drops' not in document:
        return
    definition = document['map_group_drops']
    if document['version'] < 6 or not isinstance(definition, dict) or set(definition) != {'kind', 'drops'}:
        raise ValueError('map_group_drops requires version 6, kind and drops')
    if definition['kind'] != 'legacy_offset_cycle':
        raise ValueError('unsupported map group drop rule')
    drops = definition['drops']
    if not isinstance(drops, list) or len(drops) != 64 or any(
            not isinstance(drop, str) or drop not in DROPS for drop in drops):
        raise ValueError('legacy offset cycle requires exactly 64 semantic drop names')


def map_group_drop_overrides(documents, machine=None):
    if not any('map_group_drops' in document for document in documents):
        return [None] * len(documents)
    if machine is None:
        from export_original_levels import exact_oracle
        machine = exact_oracle(True)
    original = bytes(DROPS[name] for name in original_map_group_drops(machine)['drops'])
    overrides = []
    for document in documents:
        validate_map_group_drops(document)
        cycle = document.get('map_group_drops')
        payload = bytes(DROPS[name] for name in cycle['drops']) if cycle is not None else original
        overrides.append(None if payload == original else payload)
    return overrides
