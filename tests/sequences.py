"""Stateful sequences at a raised test boundary: whole record-update passes.

Each sequence builds one world whose pools hold records of types that reach the C
regions (with stale free slots in between), then alternates UpdateAllRecords (every
record handler, spawns and removals, in the original pool order) with TickFrameTimers,
comparing oracle and hybrid after every step: the first divergence names its step.
Both sides may end the level, lose the player or empty the pools; they only have to do
the same thing.
"""
from difftest import Case
from world import World, K

LOOP = ('BP', 'SP', 'DS', 'SS')
# Record types whose handlers use the movement region, by pool.
POOL_A_TYPES = (0x12, 0x1D, 0x1E, 0x2E, 0x14, 0x48, 0x81, 0x3E, 0x3F, 0x60)
POOL_B_TYPES = (0x0A, 0x0B, 0x02, 0x03)

def world(rng, pair):
    w = World(pair, rng).plausible()
    for i in range(K.POOL_A_COUNT):
        r = w.record('PoolA', i)
        if rng.randrange(3): r.live(kind=K.KIND_ENEMY, type=rng.choice(POOL_A_TYPES))
        else: r.randomize().free()
        if r.get('type') == 0x12: r.set(field_36=pair.sym('Type41Path') + 4 * rng.randrange(6))
        r.set(saved_x=rng.randrange(0, 0xC1), saved_y=rng.randrange(0x10, 0xC0), direction=rng.randrange(8))
    for i in range(K.POOL_B_COUNT):
        r = w.record('PoolB', i)
        if rng.randrange(2):
            r.live(kind=K.KIND_TYPED, type=rng.choice(POOL_B_TYPES), size=0, player_shot=rng.randrange(2),
                   field_1c=rng.choice((0, 1, 5, 30, 0xFFFF)), target=w.slot('PoolA', rng.randrange(35)))
        else: r.randomize().free()
    for name, mod in (('SteerSpeed', 4), ('ChaseStepPixels', 4), ('EncounterTicks', 0x60)):
        w.word(name, rng.randrange(mod))
    return w

def cases(rng, scale, pair):
    for i in range(40 * scale):
        w = world(rng, pair)
        steps = [Case('UpdateAllRecords', {}, w.writes(), LOOP, name=f'world {i} frame 0')]
        for f in range(1, rng.choice((4, 8, 16))):
            steps.append(Case('TickFrameTimers', {}, (), LOOP, name=f'world {i} tick {f}'))
            steps.append(Case('UpdateAllRecords', {}, (), LOOP, name=f'world {i} frame {f}'))
        yield steps
