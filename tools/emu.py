"""Real-mode machine for differential tests: one linked game EXE loaded as DOS would.

Loads an MZ EXE (the exact oracle or a hybrid) at a fixed load segment, applies its
relocations and reads public symbols from the TLINK map beside it. A routine is entered
with a near call from a sentinel in its own code segment, with DS = SS = the game state
segment exactly as the game runs.

The machine has no DOS and no devices: port I/O is recorded (IN reads 0) so tests can
compare it, and the only service is INT 21h memory allocation (48h/49h/4Ah) from a
fixed bump allocator, enough to run the game's own AllocateBuffers. Any other interrupt
stops the call as a failure.
"""
from common import *
from extract import mz
from unicorn import Uc, UcError, UC_ARCH_X86, UC_MODE_16, UC_HOOK_INTR, UC_HOOK_INSN, UC_HOOK_CODE
from unicorn.x86_const import *
import re, struct

LOAD = 0x1010
HEAP = 0x4000          # first paragraph the allocator hands out (past either image's state segment window)
HEAP_END = 0xA000
HEAP_FILL = b'\x01\x00'  # allocated memory: small positive words, so unloaded images are tiny
REG = {r: globals()['UC_X86_REG_' + r] for r in
       ('AX', 'BX', 'CX', 'DX', 'SI', 'DI', 'BP', 'SP', 'CS', 'DS', 'ES', 'SS', 'IP', 'FLAGS')}
WORD_REGS = ('AX', 'BX', 'CX', 'DX', 'SI', 'DI', 'BP', 'ES')
FLAG = dict(CF=0x001, PF=0x004, AF=0x010, ZF=0x040, SF=0x080, TF=0x100, IF=0x200, DF=0x400, OF=0x800)

def read_map(path):
    """Public name (upper case) -> (segment frame, offset), relative to the load segment."""
    text = Path(path).read_text(errors='replace')
    text = text[text.index('Publics by Name'):text.index('Publics by Value')]
    return {m[3]: (int(m[1], 16), int(m[2], 16)) for m in re.finditer(r'^\s*([0-9A-F]{4}):([0-9A-F]{4})\s+(\w+)', text, re.M)}

class Machine:
    def __init__(self, exe):
        exe = Path(exe)
        _, image, relocations, _ = mz(exe.read_bytes())
        image = bytearray(image)
        for p in relocations:
            struct.pack_into('<H', image, p, (struct.unpack_from('<H', image, p)[0] + LOAD) & 0xFFFF)
        self.image = bytes(image)
        assert LOAD * 16 + len(image) <= HEAP * 16, 'image overlaps the test heap'
        self.symbols = read_map(exe.with_suffix('.MAP'))
        # The next segment's first public is beyond linker alignment padding.
        # Coverage ranges must end at the current segment's actual length.
        map_text = exe.with_suffix('.MAP').read_text(errors='replace')
        self.segment_ends = {int(m[1], 16) >> 4: LOAD * 16 + int(m[1], 16) + int(m[2], 16)
                             for m in re.finditer(r'^\s*([0-9A-F]+)H\s+[0-9A-F]+H\s+([0-9A-F]+)H\s+\w+',
                                                  map_text, re.M)}
        self.u = Uc(UC_ARCH_X86, UC_MODE_16)
        self.u.mem_map(0, 0x100000)
        self.u.mem_write(LOAD * 16, self.image)
        self.data_frame = LOAD + self.symbols['STACKTOP'][0]
        self.stack_top = self.symbols['STACKTOP'][1]
        # Heap addresses are compared as addresses: the 64 KiB DS window must end below them.
        assert self.data_frame + 0x1000 <= HEAP, 'the state segment window overlaps the test heap'
        self.u.hook_add(UC_HOOK_INTR, self._interrupt)
        self.u.hook_add(UC_HOOK_INSN, self._port_in, None, 1, 0, UC_X86_INS_IN)
        self.u.hook_add(UC_HOOK_INSN, self._port_out, None, 1, 0, UC_X86_INS_OUT)
        self.fault = None
        self.heap = HEAP
        # Port traffic of the last call, in order: ('out', port, value) and ('in', port).
        self.ports = []

    def _interrupt(self, u, number, _):
        ax = u.reg_read(REG['AX']); flags = u.reg_read(REG['FLAGS']) & ~FLAG['CF']
        if number == 0x21 and ax >> 8 == 0x48:
            need = u.reg_read(REG['BX'])
            if self.heap + need > HEAP_END:
                u.reg_write(REG['AX'], 8); u.reg_write(REG['BX'], HEAP_END - self.heap); flags |= FLAG['CF']
            else:
                u.mem_write(self.heap * 16, HEAP_FILL * (need * 8))
                u.reg_write(REG['AX'], self.heap); self.heap += need
            u.reg_write(REG['FLAGS'], flags); return
        if number == 0x21 and ax >> 8 in (0x49, 0x4A):
            u.reg_write(REG['FLAGS'], flags); return
        self.fault = f'INT {number:02X}h AX={ax:04X}'; u.emu_stop()
    def _port_in(self, u, port, size, _):
        self.ports.append(('in', port)); return 0
    def _port_out(self, u, port, size, value, _):
        self.ports.append(('out', port, value & ((1 << 8 * size) - 1)))

    # Addresses
    def linear(self, name):
        seg, off = self.symbols[name.upper()]
        return (LOAD + seg) * 16 + off
    def offset(self, name):
        """DS-relative offset of a state-segment symbol."""
        seg, off = self.symbols[name.upper()]
        assert LOAD + seg == self.data_frame, name + ' is not in the state segment'
        return off
    def poke(self, name, value):
        """Write a word variable anywhere in the image (e.g. a CS-resident variable)."""
        self.u.mem_write(self.linear(name), struct.pack('<H', value & 0xFFFF))
    def peek(self, name):
        return struct.unpack('<H', bytes(self.u.mem_read(self.linear(name), 2)))[0]

    # State segment access (DS = SS = data frame)
    def read(self, off, n): return bytes(self.u.mem_read(self.data_frame * 16 + off, n))
    def write(self, off, data): self.u.mem_write(self.data_frame * 16 + off, bytes(data))
    def word(self, off): return struct.unpack('<H', self.read(off, 2))[0]
    def set_word(self, off, v): self.write(off, struct.pack('<H', v & 0xFFFF))
    def state(self): return self.read(0, 0x10000)
    def set_state(self, data): self.write(0, data)

    def call(self, name, regs=None, flags=0x0202, sp=None, limit=5000000):
        """Near-call `name` with a return address that stops emulation. Returns the registers."""
        seg, off = self.symbols[name.upper()]
        cs = LOAD + seg
        sentinel = self.sentinel(cs)
        sp = self.stack_top - 0x40 if sp is None else sp
        sp -= 2; self.set_word(sp, sentinel - cs * 16)
        values = dict(AX=0, BX=0, CX=0, DX=0, SI=0, DI=0, BP=0, ES=self.data_frame)
        values.update(regs or {})
        for r, v in values.items(): self.u.reg_write(REG[r], v & 0xFFFF)
        for r in ('DS', 'SS'): self.u.reg_write(REG[r], self.data_frame)
        self.u.reg_write(REG['CS'], cs); self.u.reg_write(REG['SP'], sp)
        self.u.reg_write(REG['FLAGS'], flags)
        self.fault = None; self.ports = []
        # A MAIN near-return address can physically alias code in the hybrid's
        # far C segment. Stop on the actual return context, not that linear
        # address while executing a different CS or an active callee frame.
        def returned(u, address, size, _):
            if u.reg_read(REG['CS']) == cs and u.reg_read(REG['SP']) == sp + 2:
                u.emu_stop()
        done = self.u.hook_add(UC_HOOK_CODE, returned, None, sentinel, sentinel)
        try:
            self.u.emu_start(cs * 16 + off, 0, count=limit)
        except UcError as e:
            raise AssertionError(f'{name}: CPU fault {e} at {self.u.reg_read(REG["CS"]):04X}:{self.u.reg_read(REG["IP"]):04X}')
        finally:
            self.u.hook_del(done)
        ip = self.u.reg_read(REG['CS']) * 16 + self.u.reg_read(REG['IP'])
        if self.fault: raise AssertionError(f'{name}: {self.fault} at linear {ip:05X}')
        if ip != sentinel: raise AssertionError(f'{name}: did not return within {limit} instructions')
        return {r: self.u.reg_read(REG[r]) for r in WORD_REGS + ('SP', 'DS', 'SS', 'FLAGS')}

    def sentinel(self, cs):
        """Return address for the test call: cs:FFFEh. Emulation stops when execution reaches
        it in the caller's CS after unwinding the call. The same linear address may
        alias executable code in another real-mode segment; it remains runnable."""
        return cs * 16 + 0xFFFE

    def start_runtime(self, adapter=2):
        """The state the game's startup leaves for rendering and buffers, from its own code:
        VideoAdapter (default 2, Tandy/PCjr), AllocateBuffers, BuildRowTables, InitStars.
        Graphics files are not loaded: their buffers hold HEAP_FILL."""
        self.poke('VideoAdapter', adapter)
        for name in ('AllocateBuffers', 'BuildRowTables', 'InitStars'): self.call(name)
