"""Encounter policies curated from the maintained director/faller C and ASM.

These small scalar choices are not opaque tables. Boss assembly, leader movement
and allocation retain their existing procedures; invader slots have a separate codec.
"""
KINDS = {'segmented_boss': 0, 'invader_formation': 1,
         'leader_path': 2, 'fallers_then_burster': 3}
MOTIONS = {'animated': 0, 'alternate_animated': 1, 'aimed_drift': 2}


def original_encounter(level):
    """Equivalent choices in Type21EncounterDirector/EncounterSpawnFaller/Type23.

    The exporter computes the original HP formula once. Runtime original levels
    consume its explicit result rather than deriving HP from an episode position.
    Out-of-range identities remain a native migration fallback, not public data.
    """
    kind = {0: 'segmented_boss', 3: 'invader_formation', 4: 'leader_path'}.get(
        level, 'fallers_then_burster')
    result = {'kind': kind, 'director_destructible': level == 4,
              'fallers': {
                  'hit_points': 1 if level == 2 else 'invulnerable' if level in (1, 3, 5)
                                else 'spawn_default',
                  'variant': 'record_tick' if level in (1, 3, 5) else 'preserve',
                  'motion': 'aimed_drift' if level == 2 else 'alternate_animated'
                            if level in (3, 5) else 'animated'}}
    if kind == 'invader_formation':
        result.update(fallers_until_tick=50, invaders_at_tick=90)
    elif kind == 'fallers_then_burster':
        result.update(fallers_until_tick=200, burster_at_tick=240,
                      burster={'hit_points': ((level + 1) * 10) & 65535,
                               'sprite': 113, 'x': 96})
    return result


def validate_encounter(document):
    if 'encounter' not in document:
        return
    encounter = document['encounter']
    if not isinstance(encounter, dict) or not isinstance(encounter.get('kind'), str) or \
            encounter['kind'] not in KINDS:
        raise ValueError('unknown encounter kind')
    fields = {'kind', 'director_destructible', 'fallers'}
    kind = encounter['kind']
    if kind == 'invader_formation':
        fields.update(('fallers_until_tick', 'invaders_at_tick'))
        if 'slots' in encounter:
            fields.add('slots')
            from level_invaders import validate_invader_slots
            validate_invader_slots(encounter['slots'])
    elif kind == 'fallers_then_burster':
        fields.update(('fallers_until_tick', 'burster_at_tick', 'burster'))
    if set(encounter) != fields:
        raise ValueError('encounter fields do not match its kind')
    if type(encounter['director_destructible']) is not bool:
        raise ValueError('director_destructible must be boolean')
    fallers = encounter['fallers']
    if not isinstance(fallers, dict) or set(fallers) != {'hit_points', 'variant', 'motion'}:
        raise ValueError('fallers must specify hit_points, variant and motion')
    hp = fallers['hit_points']
    if not ((isinstance(hp, str) and hp in ('spawn_default', 'invulnerable')) or
            (type(hp) is int and 0 <= hp < 65535)):
        raise ValueError('faller hit_points must be a word, spawn_default or invulnerable')
    if not isinstance(fallers['variant'], str) or fallers['variant'] not in ('preserve', 'record_tick'):
        raise ValueError('unknown faller variant policy')
    if not isinstance(fallers['motion'], str) or fallers['motion'] not in MOTIONS:
        raise ValueError('unknown faller motion')
    if kind in ('invader_formation', 'fallers_then_burster'):
        next_tick = 'invaders_at_tick' if kind == 'invader_formation' else 'burster_at_tick'
        for field in ('fallers_until_tick', next_tick):
            _word(encounter[field], field)
        if encounter[next_tick] < encounter['fallers_until_tick']:
            raise ValueError('encounter followup tick precedes the faller phase end')
    if kind == 'fallers_then_burster':
        burster = encounter['burster']
        if not isinstance(burster, dict) or set(burster) != {'hit_points', 'sprite', 'x'}:
            raise ValueError('burster must specify hit_points, sprite and x')
        for field in ('hit_points', 'sprite'):
            _word(burster[field], 'burster ' + field)
        if type(burster['x']) is not int or not -32768 <= burster['x'] <= 32767:
            raise ValueError('burster x must be a signed playfield word')


def _word(value, name):
    if type(value) is not int or not 0 <= value <= 65535:
        raise ValueError(name + ' must be an unsigned word')


def encounter_words(document, level):
    """Private descriptor layout; unused procedure parameters keep original defaults.

    Bounded oracle tests can call the invader helper on any original level. Its
    default thresholds stay 50/90 even when that level's director uses another kind.
    """
    value = document.get('encounter', original_encounter(level))
    fallers = value['fallers']
    hp = fallers['hit_points']
    burster = value.get('burster', {'hit_points': ((level + 1) * 10) & 65535,
                                  'sprite': 113, 'x': 96})
    invader = value['kind'] == 'invader_formation'
    return (KINDS[value['kind']], int(value['director_destructible']),
            200 if invader else value.get('fallers_until_tick', 200),
            value.get('burster_at_tick', 240), burster['hit_points'], burster['sprite'],
            burster['x'] & 65535,
            value['fallers_until_tick'] if invader else 50, value.get('invaders_at_tick', 90),
            int(hp != 'spawn_default'), 65535 if hp == 'invulnerable' else 0 if hp == 'spawn_default' else hp,
            int(fallers['variant'] == 'record_tick'), MOTIONS[fallers['motion']])


def generate_encounter_header(out, documents):
    from level_format import validate
    if len(documents) != 6:
        raise ValueError('the original native binding requires six level definitions')
    lines = ['/* Generated from validated semantic encounter definitions. */',
             '#ifndef ENCOUNTERS_GEN_H', '#define ENCOUNTERS_GEN_H',
             'static const LevelEncounter level_encounters[] = {']
    for level, document in enumerate(documents):
        validate(document)
        lines.append('    {' + ', '.join(str(word) for word in encounter_words(document, level)) + '},')
    lines += ['};', '#endif', '']
    out.mkdir(parents=True, exist_ok=True)
    (out / 'ENCOUNTERS_GEN.H').write_text('\n'.join(lines))
