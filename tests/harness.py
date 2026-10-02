"""Regression for a far code segment aliasing a near-call return sentinel."""
from difftest import Case, ALL_REGS
from emu import LOAD
import struct

def cases(rng, scale, pair):
    undo = []
    try:
        for side in (pair.a, pair.b):
            m = side.m
            seg, _ = m.symbols['RETURNNEAR']
            cs = LOAD + seg
            sentinel = m.sentinel(cs)
            # Execute INC AX / RETF at the sentinel's linear address through an
            # alias CS, then return normally in the caller's CS to that address.
            entry = b'\x9A' + struct.pack('<HH', 0xE, cs + 0xFFF) + b'\xC3'
            for at, data in ((m.linear('ReturnNear'), entry), (sentinel, b'\x40\xCB')):
                undo.append((side, at, bytes(m.u.mem_read(at, len(data)))))
                m.u.mem_write(at, data)
            m.u.ctl_remove_cache(side.image[0], side.image[1])
        def done(m, regs):
            if regs['AX'] != 1: raise AssertionError('far alias stopped before INC AX / RETF')
        yield Case('ReturnNear', preserve=ALL_REGS, outputs=('AX',), expect=done, name='far return-address alias')
    finally:
        for side, at, data in reversed(undo): side.m.u.mem_write(at, data)
        for side in (pair.a, pair.b): side.m.u.ctl_remove_cache(side.image[0], side.image[1])
