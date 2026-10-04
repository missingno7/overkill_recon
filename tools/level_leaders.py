"""Shared original leader-script presets and owned v11 leader validation."""

from pathlib import Path
import re

from common import ROOT, read_json
from level_paths import LEADER_BINDINGS, source_leaders, validate_point
from world import K


NO_FOLLOWER_SENTINEL_NAMES = frozenset((
    'sweep_leader', 'sweeper_leader', 'march_leader',
))


def original_leader_presets():
    """Read the six semantic leader definitions exported from the exact source."""
    presets = read_json(ROOT / 'levels/shared/leader-presets.json')
    if not isinstance(presets, dict) or set(presets) != set(LEADER_BINDINGS):
        raise ValueError('shared leader catalog must define all six original leaders')
    for name, definition in presets.items():
        _validate_definition(name, definition)
    return presets


def _encoded_y(point):
    return (point['y'] - 32) & 0xFFFF


def generate_leader_preset_header(out, machine):
    """Emit immutable default leader scripts and slot positions from the oracle."""
    sources = source_leaders(machine)
    catalog = original_leader_presets()
    source_definitions = {name: sources[name][2] for name in LEADER_BINDINGS}
    if catalog != source_definitions:
        raise ValueError('shared leader catalog differs from maintained original leader streams')

    lines = [
        '/* Generated from the maintained original leader scripts. */',
        '#ifndef LEVEL_LEADER_PRESETS_GEN_H',
        '#define LEVEL_LEADER_PRESETS_GEN_H',
    ]
    descriptors = []
    for name, (label, _stride) in LEADER_BINDINGS.items():
        start, _capacity, definition = sources[name]
        symbol = 'leader_steps_' + name
        lines.append(f'static const LevelLeaderStep {symbol}[] = {{')
        for step in definition['steps']:
            target = step['target']
            if 'follower' not in step:
                follower_y = follower_x = spawn_follower = 0
            elif step['follower'] is None:
                follower_y = follower_x = 0xFFFF
                spawn_follower = 0
            else:
                follower = step['follower']
                follower_y, follower_x = _encoded_y(follower), follower['x'] & 0xFFFF
                spawn_follower = 1
            lines.append(
                f'    {{{_encoded_y(target)}, {target["x"] & 0xFFFF}, '
                f'{follower_y}, {follower_x}, {spawn_follower}, 0}},'
            )
        terminal_x = definition['end']['x'] & 0xFFFF
        lines.append(f'    {{{K.LEADER_END_Y}, {terminal_x}, 0, 0, 0, 1}}')
        lines.append('};')
        descriptors.append((name, start, machine.offset(label + 'End'),
                            len(definition['steps']) + 1, symbol))

    slots = catalog['slot_hopper_leader']['slots']
    lines.append('static const LevelLeaderSlot level_leader_slots_default[] = {')
    lines.extend(f'    {{{_encoded_y(slot)}, {slot["x"] & 0xFFFF}}},' for slot in slots)
    lines.append('};')
    lines.append('static const LevelLeaderPreset level_leader_presets[] = {')
    lines.extend(
        f'    {{"{name}", {start}, {end}, {count}, {symbol}}},'
        for name, start, end, count, symbol in descriptors
    )
    lines.append('    {0, 0, 0, 0, 0}')
    lines.extend(('};', '#endif', ''))
    out = Path(out)
    out.mkdir(parents=True, exist_ok=True)
    (out / 'LEVEL_LEADER_PRESETS_GEN.H').write_text('\n'.join(lines))


def _validate_definition(name, definition):
    stride = LEADER_BINDINGS[name][1]
    fields = {'steps', 'end'} | ({'slots'} if name == 'slot_hopper_leader' else set())
    if not isinstance(definition, dict) or set(definition) != fields:
        raise ValueError(name + ': leader path has unexpected fields')
    steps = definition['steps']
    if not isinstance(steps, list) or not 1 <= len(steps) <= 65534:
        raise ValueError(name + ': leader paths require 1..65534 steps')
    for step in steps:
        step_fields = {'target'} | ({'follower'} if stride == 8 else set())
        if not isinstance(step, dict) or set(step) != step_fields:
            raise ValueError(name + ': leader step fields do not match its existing reader')
        validate_point(step['target'])
        if stride == 8:
            follower = step['follower']
            if follower is None:
                if name not in NO_FOLLOWER_SENTINEL_NAMES:
                    raise ValueError(name + ': follower suppression is not supported')
            else:
                # Y=31 is a real signed semantic coordinate for bob_chase_leader;
                # only JSON null expresses a no-follower sentinel.
                validate_point(follower)
    ending = definition['end']
    if (not isinstance(ending, dict) or set(ending) != {'kind', 'x'} or
            ending['kind'] != 'fly_off' or type(ending['x']) is not int or
            not -32768 <= ending['x'] <= 32767):
        raise ValueError(name + ': leader script must end with signed-x fly_off')

    if name == 'slot_hopper_leader':
        slots = definition['slots']
        if not isinstance(slots, list) or not 2 <= len(slots) <= 65535:
            raise ValueError('slot_hopper_leader slots require 2..65535 positions')
        for slot in slots:
            validate_point(slot)
        if len({(slot['x'], slot['y']) for slot in slots}) < 2:
            raise ValueError('slot_hopper_leader slots require at least two distinct positions')


def validate_authored_leader_paths(document):
    """Validate optional v11 owned leader scripts against demonstrated readers."""
    if 'leader_paths' not in document:
        return
    if type(document.get('version')) is not int or document['version'] < 11:
        raise ValueError('owned leader_paths require version 11')
    leaders = document['leader_paths']
    if not isinstance(leaders, dict):
        raise ValueError('leader_paths must be a named object')
    if any(not isinstance(name, str) or not re.fullmatch(r'[a-z][a-z0-9_]*', name)
           for name in leaders):
        raise ValueError('leader path names must be semantic identifiers')
    unknown = set(leaders) - set(LEADER_BINDINGS)
    if unknown:
        raise ValueError('unknown leader path: ' + ', '.join(sorted(unknown)))

    presets = original_leader_presets()
    total = sum(len(presets[name]['steps']) + 1 for name in LEADER_BINDINGS)
    for name, definition in leaders.items():
        _validate_definition(name, definition)
        total += len(definition['steps']) - len(presets[name]['steps'])
    if total > 65535:
        raise ValueError('leader defaults and authored steps exceed 65535 points')
