"""Ordered invader slots and the separate opening-march timing policies.

Slots are extracted from the source-built table. Timing tiers are small curated
equivalents of UpdateAllRecords/StepMarchFireDelay, not a new movement system.
"""
import struct
from level_paths import point, encode_point, validate_point


def original_marching_formation(level):
    return {'enabled': level == 5,
            'step_delays': [{'minimum_members': minimum, 'frames': frames}
                            for minimum, frames in ((17, 10), (9, 6), (5, 4), (0, 1))],
            'fire_delays': [{'minimum_members': minimum, 'frames': frames}
                            for minimum, frames in ((17, 120), (9, 100), (5, 80), (3, 60), (0, 40))]}


def original_invader_slots(machine):
    start, end = machine.offset('InvaderFormation'), machine.offset('InvaderFormationEnd')
    if end - start != 24 * 4:
        raise ValueError('unmodeled invader slot count')
    state = machine.state()
    return [point(state, at) for at in range(start, end, 4)]


def validate_invader_slots(slots):
    if not isinstance(slots, list) or len(slots) != 24:
        raise ValueError('the original invader binding requires 24 ordered slots')
    for slot in slots:
        validate_point(slot)


def validate_marching_formation(document):
    if 'marching_formation' not in document:
        return
    march = document['marching_formation']
    if not isinstance(march, dict) or set(march) != {'enabled', 'step_delays', 'fire_delays'}:
        raise ValueError('marching_formation must specify enabled, step_delays and fire_delays')
    if type(march['enabled']) is not bool:
        raise ValueError('marching_formation enabled must be boolean')
    for name in ('step_delays', 'fire_delays'):
        tiers = march[name]
        if not isinstance(tiers, list) or not 1 <= len(tiers) <= 65535:
            raise ValueError(name + ' must contain an ordered nonempty tier list')
        previous = 65536
        for tier in tiers:
            if not isinstance(tier, dict) or set(tier) != {'minimum_members', 'frames'}:
                raise ValueError('march delay tier must specify minimum_members and frames')
            minimum, frames = tier['minimum_members'], tier['frames']
            if type(minimum) is not int or not 0 <= minimum < previous:
                raise ValueError('march member thresholds must be strictly descending unsigned words')
            if type(frames) is not int or not 0 <= frames <= 255:
                raise ValueError('march delay frames must be a byte')
            previous = minimum
        if previous != 0:
            raise ValueError('march delay tiers must end with minimum_members 0')


def generate_invader_header(out, documents, machine):
    from level_format import validate
    if len(documents) != 6:
        raise ValueError('the original native binding requires six level definitions')
    original = original_invader_slots(machine)
    lines = ['/* Generated from validated slot/timing data and exact source tables. */',
             '#ifndef INVADERS_GEN_H', '#define INVADERS_GEN_H']
    default = original_marching_formation(0)
    def emit_tiers(symbol, tiers):
        lines.append(f'static const MarchDelayTier {symbol}[] = {{' +
                     ', '.join('{' + str(tier['minimum_members']) + ', ' + str(tier['frames']) + '}'
                               for tier in tiers) + '};')
    for name in ('step_delays', 'fire_delays'):
        emit_tiers('original_' + name, default[name])
    bindings = []
    for index, document in enumerate(documents):
        validate(document)
        slots = document.get('encounter', {}).get('slots', original)
        reference = '0'
        if slots != original:
            reference = f'level_{index}_invader_slots'
            words = struct.unpack('<48H', b''.join(encode_point(slot) for slot in slots))
            lines.append(f'static const uint16_t {reference}[] = {{' +
                         ', '.join(str(word) for word in words) + '};')
        march = document.get('marching_formation', original_marching_formation(index))
        tier_references = []
        for name in ('step_delays', 'fire_delays'):
            symbol = 'original_' + name
            if march[name] != default[name]:
                symbol = f'level_{index}_{name}'
                emit_tiers(symbol, march[name])
            tier_references.extend((symbol, str(len(march[name]))))
        bindings.append('    {' + ', '.join((reference, str(int(march['enabled'])),
                                            *tier_references)) + '}')
    lines += ['static const LevelInvaders level_invaders[] = {',
              ',\n'.join(bindings), '};', '#endif', '']
    out.mkdir(parents=True, exist_ok=True)
    (out / 'INVADERS_GEN.H').write_text('\n'.join(lines))
