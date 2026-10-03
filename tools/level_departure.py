"""Mothership departure data inferred from the shared original tables.

Canonical components retain live DS references in the native migration adapter.
Authored components are independent immutable level data; they never overwrite a
shared original table or another level. State-machine behavior stays procedural.
"""
from world import K
import struct


def validate_departure(document):
    if 'departure' not in document:
        return
    departure = document['departure']
    if not isinstance(departure, dict) or set(departure) != {
            'kind', 'terrain_rows', 'animated_parts', 'waypoints'}:
        raise ValueError('departure must specify kind, terrain_rows, animated_parts and waypoints')
    if departure['kind'] != 'mothership':
        raise ValueError('only the original mothership departure is implemented')
    rows = departure['terrain_rows']
    if not isinstance(rows, list) or len(rows) != 5 or any(
            not isinstance(row, list) or len(row) != K.MAP_ROW_BYTES for row in rows):
        raise ValueError('mothership terrain requires five rows of thirteen tiles')
    if any(type(tile) is not int or not 0 <= tile <= 255 for row in rows for tile in row):
        raise ValueError('mothership tiles must be bytes')
    parts = departure['animated_parts']
    if not isinstance(parts, list) or len(parts) != 4:
        raise ValueError('mothership requires four ordered animated parts')
    for part in parts:
        if not isinstance(part, dict) or set(part) != {'x', 'y', 'sprite'}:
            raise ValueError('mothership part must specify x, y and sprite')
        _point(part)
        if type(part['sprite']) is not int or not 0 <= part['sprite'] <= 65535:
            raise ValueError('mothership sprite must be an unsigned bank index')
    waypoints = departure['waypoints']
    if not isinstance(waypoints, dict) or set(waypoints) != {'approach', 'dock'}:
        raise ValueError('mothership waypoints must specify approach and dock')
    for point in waypoints.values():
        if not isinstance(point, dict) or set(point) != {'x', 'y'}:
            raise ValueError('mothership waypoint must specify x and y')
        _point(point)


def _point(point):
    if any(type(point[field]) is not int or not -32768 <= point[field] <= 32767
           for field in ('x', 'y')):
        raise ValueError('mothership positions must be signed playfield words')


def departure_definition(machine):
    state = machine.state()
    at = machine.offset('LevelEndMapRows')
    rows = [list(state[at + row * K.MAP_ROW_BYTES:at + (row + 1) * K.MAP_ROW_BYTES])
            for row in range(5)]
    at = machine.offset('Type53SpawnTable')
    parts = [{'y': y, 'x': x, 'sprite': sprite}
             for y, x, sprite in struct.iter_unpack('<hhH', state[at:at + 24])]
    waypoints = {}
    for name, symbol in (('approach', 'AutopilotWaypointA'), ('dock', 'AutopilotWaypointB')):
        y, x = struct.unpack_from('<hh', state, machine.offset(symbol))
        waypoints[name] = {'x': x, 'y': y}
    result = {'kind': 'mothership', 'terrain_rows': rows,
              'animated_parts': parts, 'waypoints': waypoints}
    validate_departure({'departure': result})
    return result


def generate_departure_header(out, documents, machine):
    """Generate per-component references, retaining legacy live reads when equal.

    The default bindings are migration metadata, not public compatibility flags.
    A changed component belongs solely to that definition, with no shared DS write.
    """
    from level_format import validate
    if len(documents) != 6:
        raise ValueError('the original native binding requires six level definitions')
    original = departure_definition(machine)
    lines = ['/* Generated from validated level definitions and exact source tables. */',
             '#ifndef DEPARTURES_GEN_H', '#define DEPARTURES_GEN_H']
    bindings = []
    for index, document in enumerate(documents):
        validate(document)
        departure = document.get('departure', original)
        components = (
            ('terrain_rows', 'uint8_t', [tile for row in departure['terrain_rows'] for tile in row],
             departure['terrain_rows'] == original['terrain_rows']),
            ('animated_parts', 'uint16_t', [part[field] & 65535 for part in departure['animated_parts']
                                          for field in ('y', 'x', 'sprite')],
             departure['animated_parts'] == original['animated_parts']),
            ('approach', 'uint16_t', [departure['waypoints']['approach'][field] & 65535
                                    for field in ('y', 'x')],
             departure['waypoints']['approach'] == original['waypoints']['approach']),
            ('dock', 'uint16_t', [departure['waypoints']['dock'][field] & 65535
                                for field in ('y', 'x')],
             departure['waypoints']['dock'] == original['waypoints']['dock']),
        )
        references = []
        for name, kind, values, unchanged in components:
            if unchanged:
                references.append('0')
            else:
                symbol = f'level_{index}_departure_{name}'
                lines.append(f'static const {kind} {symbol}[] = {{' +
                             ', '.join(str(value) for value in values) + '};')
                references.append(symbol)
        bindings.append('    {' + ', '.join(references) + '}')
    lines += ['static const LevelDeparture departure_overrides[] = {',
              ',\n'.join(bindings), '};', '#endif', '']
    out.mkdir(parents=True, exist_ok=True)
    (out / 'DEPARTURES_GEN.H').write_text('\n'.join(lines))
