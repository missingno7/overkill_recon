"""Special original path presets and v12 owned-path validation."""

from pathlib import Path

from common import ROOT, read_json
from level_paths import PATH_BINDINGS, source_paths, validate_point
from world import K


SPECIAL_PATH_TARGETS = {
    'sweep_lead_in': 1,
    'sweep_loop': 1,
    'encounter_leader': 2,
    'boss_anchor': 3,
}
SPECIAL_PATH_NAMES = tuple(SPECIAL_PATH_TARGETS)
SPECIAL_PATH_ENDINGS = {
    'sweep_lead_in': {'kind': 'continue', 'path': 'sweep_loop'},
    'sweep_loop': {'kind': 'jump', 'path': 'sweep_loop'},
    'encounter_leader': {'kind': 'restart'},
    'boss_anchor': {'kind': 'restart'},
}


def _node_count(definition):
    return len(definition['points']) + (definition['end']['kind'] != 'continue')


def original_special_path_presets():
    presets = read_json(ROOT / 'levels/shared/special-path-presets.json')
    if not isinstance(presets, dict) or set(presets) != set(SPECIAL_PATH_NAMES):
        raise ValueError('shared special-path catalog must define the four original special paths')
    for name, definition in presets.items():
        _validate_definition(name, definition)
    return presets


def generate_special_path_preset_header(out, machine):
    """Emit the four special path streams from exact-source extraction."""
    sources = source_paths(machine)
    catalog = original_special_path_presets()
    expected = {name: sources[name][2] for name in SPECIAL_PATH_NAMES}
    if catalog != expected:
        raise ValueError('shared special-path catalog differs from maintained original path streams')

    ending_codes = {'continue': 0, 'jump': 1, 'restart': 2}
    lines = [
        '/* Generated from the maintained original special path streams. */',
        '#ifndef LEVEL_SPECIAL_PATH_PRESETS_GEN_H',
        '#define LEVEL_SPECIAL_PATH_PRESETS_GEN_H',
    ]
    descriptors = []
    for name in SPECIAL_PATH_NAMES:
        start, _capacity, definition = sources[name]
        points = definition['points']
        ending = definition['end']
        symbol = 'special_path_' + name
        lines.append(f'static const LevelSpecialPoint {symbol}[] = {{')
        for point in points:
            lines.append(f'    {{{(point["y"] - 32) & 0xFFFF}, {point["x"] & 0xFFFF}, 0, 0}},')
        if ending['kind'] != 'continue':
            lines.append('    {0xFFFF, 0, 0, 1}')
        lines.append('};')
        descriptors.append((name, start, len(points) + (ending['kind'] != 'continue'),
                            ending_codes[ending['kind']], SPECIAL_PATH_TARGETS[name], symbol))

    lines.append('static const LevelSpecialPreset level_special_path_presets[] = {')
    lines.extend(
        f'    {{"{name}", {start}, {count}, {ending}, {target}, {symbol}}},'
        for name, start, count, ending, target, symbol in descriptors
    )
    lines.append('    {0, 0, 0, 0, 0, 0}')
    lines.extend(('};', '#endif', ''))
    out = Path(out)
    out.mkdir(parents=True, exist_ok=True)
    (out / 'LEVEL_SPECIAL_PATH_PRESETS_GEN.H').write_text('\n'.join(lines))


def _validate_definition(name, definition):
    if name not in SPECIAL_PATH_TARGETS:
        raise ValueError('unknown special path: ' + str(name))
    if (not isinstance(definition, dict) or set(definition) != {'points', 'end'} or
            not isinstance(definition['points'], list) or not definition['points']):
        raise ValueError(name + ': special paths require nonempty points and a fixed ending')
    for point in definition['points']:
        validate_point(point)
    ending = definition['end']
    if ending != SPECIAL_PATH_ENDINGS[name]:
        raise ValueError(name + ': special path ending topology must match its existing reader')
    if len(definition['points']) > 65535 - (ending['kind'] != 'continue'):
        raise ValueError(name + ': special path exceeds word-sized point count')
    if name in ('sweep_loop', 'boss_anchor') and len({(p['x'], p['y']) for p in definition['points']}) < 2:
        raise ValueError(name + ': looping paths require at least two distinct points')


def validate_authored_special_paths(document, original, default_counts=None):
    """Validate v12's independently owned subset of four special paths."""
    if type(document.get('version')) is not int or document['version'] < 12:
        raise ValueError('owned special paths require version 12')
    paths = document.get('paths')
    original_paths = original.get('paths')
    if not isinstance(paths, dict) or not isinstance(original_paths, dict):
        raise ValueError('version 12 paths and original paths must be named objects')
    unknown = set(paths) - set(PATH_BINDINGS)
    if unknown:
        raise ValueError('authored paths contain an unknown path name')
    owned = paths.keys() & set(SPECIAL_PATH_NAMES)
    for name in owned:
        _validate_definition(name, paths[name])

    counts = default_counts
    if counts is None:
        presets = original_special_path_presets()
        counts = {name: _node_count(presets[name]) for name in SPECIAL_PATH_NAMES}
    if (not isinstance(counts, dict) or set(counts) != set(SPECIAL_PATH_NAMES) or
            any(type(counts[name]) is not int or not 1 <= counts[name] <= 65535
                for name in SPECIAL_PATH_NAMES)):
        raise ValueError('default special-path counts must include four unsigned counts')
    total = sum(counts.values())
    for name in owned:
        total += _node_count(paths[name]) - counts[name]
    if total > 65535:
        raise ValueError('special defaults and authored points exceed 65535 nodes')
