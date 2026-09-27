"""Per-frame region (c/frame.c), the long scrolls: fuzz targets for RestartAtCheckpoint
(checkpoint choice, the map reset before the view, the line-by-line scroll back from
MAP_RESTART_POS) and ScrollMapToLevelStart (the whole map scrolled back). Each case runs
thousands of scroll lines, so these targets live apart from tests/frame.py and are fuzzed
with fewer iterations (python tools/fuzz.py frame_restart 150). The direct cases and quirks
are in tests/frame.py; this suite only replays the saved corpora.
"""
from fuzz import Target
from frame import restart_world, scroll_world, REGION, LOOP, WINDOW, K
import itertools

_cycles = {}
def _next(name, values): return next(_cycles.setdefault(name, itertools.cycle(values)))

def _restart_seed(w): return restart_world(w, level=_next('restart', range(K.LEVEL_COUNT)))
def _start_seed(w): return scroll_world(w, level=_next('start', range(K.LEVEL_COUNT)), full_map=True)

FUZZ = [
    Target('frame_restart', 'RestartAtCheckpoint', _restart_seed, REGION, LOOP, pin_bp=True,
           globals=('MapScrollPos', 'LevelIndex', 'LastTileStepBackward', 'ScrollSubRow', 'ScrollWindowOffset'),
           domains={'MapScrollPos': range(K.MAP_START_POS, K.MAP_END_POS + 1), 'LevelIndex': range(K.LEVEL_COUNT),
                    'ScrollSubRow': range(16), 'ScrollWindowOffset': WINDOW}, seeds=6),
    Target('frame_levelstart', 'ScrollMapToLevelStart', _start_seed, REGION, LOOP, pin_bp=True,
           globals=('LastTileStepBackward', 'ScrollDeltaY'), seeds=2),
]
