"""Bind structured level definitions into the native initial DS image.

The adapter derives original storage locations/capacities from the exact oracle.
It retains source filename identities, shared patch/formation storage and drop
table aliases. Longer streams or conflicting shared definitions fail explicitly;
allocating new storage is a later
migration. No oracle source or DOS build artifact is modified.
"""
from common import ROOT
from level_format import load, original_paths, validate, encode_attribute_patches
from export_original_levels import (terrain_definition, script_event_boundaries,
                                   source_formations, timeline_definition, checkpoint_definitions)
from level_presets import ARCHETYPES, SIZES, LAYERS, DROPS
from emu import LOAD
from world import K
import argparse
from pathlib import Path
import struct


def bind_level_documents(machine, documents):
    if len(documents) != 6:
        raise ValueError('the original native binding requires six level definitions')
    documents = [validate(document) for document in documents]
    if len({document['id'] for document in documents}) != len(documents):
        raise ValueError('level identifiers must be unique')
    original = machine.state()
    state = bytearray(original)
    filenames = {}
    for symbol, (segment, offset) in machine.symbols.items():
        if symbol.startswith('FILE_') and LOAD + segment == machine.data_frame:
            end = original.index(0, offset)
            name = original[offset:end].decode('ascii').casefold()
            if name in filenames and filenames[name] != offset:
                raise ValueError(f'ambiguous source filename identity: {name}')
            filenames[name] = offset
    streams = {}
    formation_bindings = source_formations(machine)
    shared_formations, shared_drops = {}, {}
    for level, document in enumerate(documents):
        for role, table, displacement in (
                ('map', 'LevelMapFiles', level * 2),
                ('sprites', 'LevelBankFiles', level * 4),
                ('blocks', 'LevelBankFiles', level * 4 + 2),
                ('plaque', 'PlaqueFiles', level * 2)):
            name = document['resources'][role].casefold()
            if name not in filenames:
                raise ValueError(f'level {level} {role}: asset has no original filename binding: {name}')
            struct.pack_into('<H', state, machine.offset(table) + displacement, filenames[name])
        source_terrain = terrain_definition(machine, level)
        payload = encode_attribute_patches(document.get('terrain', source_terrain))
        capacity = len(encode_attribute_patches(source_terrain))
        slot = machine.offset('AttributePatchPointers') + level * 2
        cursor = struct.unpack_from('<H', original, slot)[0]
        if len(payload) > capacity:
            raise ValueError(f'level {level}: patch stream needs {len(payload)} bytes; '
                             f'original binding holds {capacity}')
        if cursor + len(payload) > len(state):
            raise ValueError('original patch storage crosses the DS boundary')
        if cursor in streams and streams[cursor] != payload:
            raise ValueError(f'level {level}: conflicting definitions for a shared original patch stream')
        streams[cursor] = payload
        # Keep unused trailing bytes intact: unchecked neighboring reads still
        # belong to the original memory model. Short streams stop at their new FF.
        state[cursor:cursor + len(payload)] = payload
        source_layouts, source_timeline = timeline_definition(machine, level)
        formations = document.get('formations', source_layouts)
        timeline = document.get('timeline', source_timeline)
        for name, formation in formations.items():
            if name not in formation_bindings:
                raise ValueError(f'level {level}: formation has no original storage binding: {name}')
            cursor, source = formation_bindings[name]
            payload = struct.pack('<4H', SIZES[formation['size']], LAYERS[formation['layer']],
                                  ARCHETYPES[formation['enemy']], len(formation['members']))
            payload += b''.join(struct.pack('<hh', member['dx'], member['dy'])
                                for member in formation['members'])
            capacity = 8 + 4 * len(source['members'])
            if len(payload) > capacity:
                raise ValueError(f'level {level}: formation exceeds original storage capacity: {name}')
            if cursor in shared_formations and shared_formations[cursor] != payload:
                raise ValueError(f'level {level}: conflicting shared formation: {name}')
            shared_formations[cursor] = payload
            state[cursor:cursor + len(payload)] = payload
        cursor = machine.offset(f'LevelScript{level}')
        start = cursor
        boundaries, payload = [], bytearray()
        for event in timeline:
            boundaries.append(start + len(payload))
            payload += struct.pack('<H', event['clock'])
            if 'compatibility' in event:
                payload += b'\xff\xff'
            payload += struct.pack('<Hhh', formation_bindings[event['formation']][0], event['x'], event['y'])
            drop_index = event['clock'] & 0x3F
            drop = DROPS[event['group']['drop']]
            if drop_index in shared_drops and shared_drops[drop_index] != drop:
                raise ValueError(f'level {level}: conflicting shared group drop binding')
            shared_drops[drop_index] = drop
            state[machine.offset('GroupDropKinds') + drop_index] = drop
        boundaries.append(start + len(payload))
        payload += b'\xff\xff'
        capacity = script_event_boundaries(machine, level)[-1] - start + 2
        if len(payload) > capacity:
            raise ValueError(f'level {level}: timeline exceeds original storage capacity')
        state[start:start + len(payload)] = payload
        if 'checkpoints' in document or 'timeline' in document:
            slot = machine.offset('LevelCheckpointPtrs') + level * 2
            cursor = struct.unpack_from('<H', original, slot)[0]
            checkpoints = document.get('checkpoints', checkpoint_definitions(machine, level))
            for index, checkpoint in enumerate(checkpoints):
                event = checkpoint['resume_event']
                if event >= len(boundaries):
                    raise ValueError(f'level {level}: checkpoint resume_event has no script boundary')
                struct.pack_into('<3H', state, cursor + index * 8,
                                 checkpoint['map_row'] * K.MAP_ROW_BYTES,
                                 checkpoint['script_clock'], boundaries[event])
                if index < 3:
                    struct.pack_into('<H', state, cursor + index * 8 + 6,
                                     checkpoints[index + 1]['map_row'] * K.MAP_ROW_BYTES)
            # The fallback has three words. Do not synthesize a fourth word:
            # ReadCheckpoint deliberately sees the original neighboring object.
    return bytes(state)


def load_original_bindings(machine, directory=None):
    return bind_level_documents(machine, [load(path) for path in original_paths(directory)])


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--levels', type=Path, default=ROOT / 'levels/original')
    parser.add_argument('--no-build', action='store_true')
    args = parser.parse_args()
    from export_original_levels import exact_oracle
    machine = exact_oracle(args.no_build)
    bound = load_original_bindings(machine, args.levels)
    changed = sum(a != b for a, b in zip(bound, machine.state()))
    print(f'PASS native bindings: six definitions, {changed} initial DS bytes changed')


if __name__ == '__main__':
    main()
