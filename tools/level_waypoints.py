"""Shared ordinary path presets and authored fly-off waypoint validation."""

from pathlib import Path
import re

from common import ROOT, read_json
from level_paths import PATH_BINDINGS, source_paths, validate_point
from world import K


ORDINARY_WAYPOINT_NAMES = tuple(
    name for name, (_label, ending) in PATH_BINDINGS.items() if ending == 'fly_off'
)


def original_waypoint_presets():
    """Read the shared semantic waypoint catalog exported from the oracle."""
    presets = read_json(ROOT / 'levels/shared/waypoint-presets.json')
    if not isinstance(presets, dict) or set(presets) != set(ORDINARY_WAYPOINT_NAMES):
        raise ValueError('shared waypoint catalog must define all ten ordinary presets')
    for name, definition in presets.items():
        if (not isinstance(definition, dict) or set(definition) != {'points', 'end'} or
                not isinstance(definition['points'], list) or
                not 1 <= len(definition['points']) <= 65534 or
                not isinstance(definition['end'], dict) or
                set(definition['end']) != {'kind', 'x'} or
                definition['end']['kind'] != 'fly_off'):
            raise ValueError(name + ': malformed shared ordinary waypoint preset')
        for point in definition['points']:
            validate_point(point)
        validate_point({'x': definition['end']['x'], 'y': 0})
    return presets


def generate_waypoint_preset_header(out, machine):
    """Generate immutable ordinary path defaults from maintained oracle data."""
    if len(ORDINARY_WAYPOINT_NAMES) != 10:
        raise ValueError('expected ten original ordinary waypoint presets')
    sources = source_paths(machine)
    catalog = original_waypoint_presets()
    source_definitions = {name: sources[name][2] for name in ORDINARY_WAYPOINT_NAMES}
    if catalog != source_definitions:
        raise ValueError('shared waypoint catalog differs from maintained original path streams')
    lines = [
        '/* Generated from the maintained original path streams. */',
        '#ifndef LEVEL_WAYPOINT_PRESETS_GEN_H',
        '#define LEVEL_WAYPOINT_PRESETS_GEN_H',
    ]
    descriptors = []
    for name in ORDINARY_WAYPOINT_NAMES:
        start, _capacity, definition = sources[name]
        points = definition['points']
        ending = definition['end']
        if ending.get('kind') != 'fly_off':
            raise ValueError(name + ': ordinary preset must terminate with fly_off')
        symbol = 'waypoints_' + name
        lines.append(f'static const LevelWaypoint {symbol}[] = {{')
        for point in points:
            encoded_y = (point['y'] - 32) & 0xFFFF
            encoded_x = point['x'] & 0xFFFF
            lines.append(f'    {{{encoded_y}, {encoded_x}, 0}},')
        lines.append(f'    {{{K.LEADER_END_Y}, {ending["x"] & 0xFFFF}, 1}}')
        lines.append('};')
        descriptors.append((name, start, len(points) + 1, symbol))

    lines.append('static const LevelWaypointPreset level_waypoint_presets[] = {')
    lines.extend(
        f'    {{"{name}", {start}, {count}, {symbol}}},'
        for name, start, count, symbol in descriptors
    )
    lines.append('    {0, 0, 0, 0}')
    lines.extend(('};', '#endif', ''))
    out = Path(out)
    out.mkdir(parents=True, exist_ok=True)
    (out / 'LEVEL_WAYPOINT_PRESETS_GEN.H').write_text('\n'.join(lines))


def validate_authored_waypoints(document, original, default_counts=None):
    """Validate a v10 path section while retaining original special paths.

    ``default_counts`` may override the catalog-derived name -> point counts
    for focused tests. Counts include each preset's terminal waypoint.
    """
    if type(document.get('version')) is not int or document['version'] < 10:
        raise ValueError('authored waypoints require version 10')
    paths = document.get('paths')
    original_paths = original.get('paths')
    if not isinstance(paths, dict) or not isinstance(original_paths, dict):
        raise ValueError('version 10 paths and original paths must be named objects')

    ordinary = set(ORDINARY_WAYPOINT_NAMES)
    special = set(original_paths) - ordinary
    if any(not isinstance(name, str) or not re.fullmatch(r'[a-z][a-z0-9_]*', name)
           for name in paths):
        raise ValueError('path names must be semantic identifiers')
    if any(name not in ordinary and name not in special for name in paths):
        raise ValueError('authored paths contain an unknown path name')
    missing_special = special - set(paths)
    if missing_special:
        raise ValueError('original special paths must be retained: ' + ', '.join(sorted(missing_special)))

    owned_counts = {}
    for name in ordinary.intersection(paths):
        definition = paths[name]
        if (not isinstance(definition, dict) or set(definition) != {'points', 'end'} or
                not isinstance(definition['points'], list) or
                not 1 <= len(definition['points']) <= 65534):
            raise ValueError(name + ': owned waypoint paths require 1..65534 points and an ending')
        for point in definition['points']:
            validate_point(point)
        ending = definition['end']
        if (not isinstance(ending, dict) or set(ending) != {'kind', 'x'} or
                ending['kind'] != 'fly_off' or type(ending['x']) is not int or
                not -32768 <= ending['x'] <= 32767):
            raise ValueError(name + ': owned ordinary paths must end with signed-x fly_off')
        owned_counts[name] = len(definition['points']) + 1

    for name in special:
        if paths[name] != original_paths[name]:
            raise ValueError(name + ': original nonordinary path must remain unchanged')

    counts = default_counts
    if counts is None:
        counts = {name: len(definition['points']) + 1
                  for name, definition in original_waypoint_presets().items()}
    if (not isinstance(counts, dict) or set(counts) != ordinary or
            any(type(counts[name]) is not int or not 1 <= counts[name] <= 65535
                for name in ordinary)):
        raise ValueError('default waypoint counts must include ten unsigned counts')
    total = sum(counts.values())
    for name, count in owned_counts.items():
        total += count - counts[name]
    if total > 65535:
        raise ValueError('ten original defaults and authored waypoints exceed 65535 points')
