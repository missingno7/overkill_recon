"""Local original-ASM checks for the coordinate-history cluster; no game replay."""
import sys, struct, unittest
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from common import *
from extract import extract
from unicorn import Uc, UC_ARCH_X86, UC_MODE_16
from unicorn.x86_const import *


class PositionHistoryTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.image = extract()[0]

    def machine(self, data=0x4000, flags=0x203):
        u = Uc(UC_ARCH_X86, UC_MODE_16)
        u.mem_map(0, 0x100000)
        u.mem_write(0x10000, self.image)
        for r, v in dict(CS=0x1000, DS=data, SS=0x5000, ES=0x6000,
                         BP=0x100, AX=0x1234, BX=0x5678, CX=0x9abc,
                         DX=0xdef0, SI=0x200, DI=0x300, EFLAGS=flags).items():
            u.reg_write(globals()['UC_X86_REG_' + r], v)
        self.put(u, 0x19596, 0x6000)
        return u

    def put(self, u, addr, value):
        u.mem_write(addr, struct.pack('<H', value & 0xffff))

    def call(self, u, ip):
        u.reg_write(UC_X86_REG_SP, 0xff00)
        self.put(u, 0x5ff00, 0xf800)
        u.emu_start(0x10000 + ip, 0x1f800, count=1000)
        self.assertEqual(u.reg_read(UC_X86_REG_IP), 0xf800)
        self.assertEqual(u.reg_read(UC_X86_REG_SP), 0xff02)

    def test_shared_history_continuation_gate_and_feedback_lifetime(self):
        # Exercise the caller itself: no advance; absent slots isolate gate effects.
        for gate in (0, 1, 0xffff):
            for cursor_state in (0, 0xb6, 0xb7, 0xffff):
                u = self.machine()
                self.put(u, 0x4a33a, 0xa27a)
                self.put(u, 0x50102, 0xfffc)
                self.put(u, 0x50104, 0xffff)
                for slot in (0xa962, 0xa964, 0xa966, 0xa968, 0xa96a, 0xa96c):
                    self.put(u, 0x40000+slot, 0xffff)
                self.put(u, 0x4a398, 0x9abc)
                self.put(u, 0x4a39a, 0x1234)
                self.put(u, 0x4a39c, 0x5678)
                u.mem_write(0x4a39e, bytes([7, 8]))
                self.put(u, 0x4bdac, gate)
                self.put(u, 0x42350, cursor_state)
                expected_ds = bytearray(u.mem_read(0x40000, 65536))
                expected_es = bytearray(u.mem_read(0x60000, 65536))
                expected_es[0xa27a:0xa27e] = struct.pack('<HH', 4, 7)
                place = gate != 0 or cursor_state > 0xb6
                if place:
                    expected_ds[0xa398:0xa39a] = struct.pack('<H', 0x5678)
                    expected_ds[0xa39e:0xa3a0] = bytes(2)
                self.call(u, 0x9be2)
                self.assertEqual(bytes(u.mem_read(0x40000, 65536)), bytes(expected_ds))
                self.assertEqual(bytes(u.mem_read(0x60000, 65536)), bytes(expected_es))
                for r, value in dict(BP=0x100, CX=0x9abc, DX=0xdef0,
                                     DS=0x4000, SS=0x5000, ES=0x6000,
                                     DI=0xa27e, AX=0x5678 if place else 7,
                                     BX=0xffff if place else 0x5678,
                                     SI=0xa368 if place else 0x200).items():
                    self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+r]), value)
                self.assertEqual(bytes(u.mem_read(0x50102, 4)), struct.pack('<HH', 0xfffc, 0xffff))

    def test_initial_history_bias_and_segment_ownership(self):
        for y, x in [(0, 0), (192, 88), (0xffff, 0xfff8)]:
            u = self.machine()
            self.put(u, 0x5237e, y)
            self.put(u, 0x52380, x)
            u.mem_write(0x60000, b'\xa5' * 65536)
            expected = bytearray(b'\xa5' * 65536)
            expected[0xa27a:0xa33a] = struct.pack('<HH', (y+8)&65535, (x+9)&65535) * 48
            self.call(u, 0x99bf)
            self.assertEqual(bytes(u.mem_read(0x60000, 65536)), bytes(expected))
            self.assertEqual(bytes(u.mem_read(0x4a33a, 8)), struct.pack('<4H', 0xa27a, 0xa2fe, 0xa2be, 0xa27e))
            for r, v in dict(BP=0x237c, AX=(x+9)&65535, CX=0, DI=0xa33a,
                             BX=0x5678, DX=0xdef0, SI=0x200, DS=0x4000, SS=0x5000, ES=0x6000).items():
                self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+r]), v)

    def test_store_direction_and_sequential_alias(self):
        for backwards in (False, True):
            u = self.machine(flags=0x203 | (0x400 if backwards else 0))
            self.put(u, 0x4a33a, 0xa336)
            self.put(u, 0x50102, 0xffff)
            self.put(u, 0x50104, 0xfffe)
            self.call(u, 0x9cd9)
            second = 0xa334 if backwards else 0xa338
            self.assertEqual(bytes(u.mem_read(0x6a336, 2)), b'\x07\x00')
            self.assertEqual(bytes(u.mem_read(0x60000+second, 2)), b'\x06\x00')
            self.assertEqual(u.reg_read(UC_X86_REG_DI), 0xa332 if backwards else 0xa33a)
            self.assertEqual(bytes(u.mem_read(0x4a33a, 2)), b'\x36\xa3')
        # First destination aliases the next source word: X is reloaded after Y store.
        u = self.machine()
        self.put(u, 0x19596, 0x5000)
        self.put(u, 0x4a33a, 0x104)
        self.put(u, 0x50102, 10)
        self.put(u, 0x50104, 90)
        self.call(u, 0x9cd9)
        self.assertEqual(bytes(u.mem_read(0x50104, 4)), struct.pack('<HH', 18, 26))

    def test_advance_trigger_ring_and_invalid_cursors(self):
        u = self.machine()
        for phase in range(48):
            cursors = [0xa27a + 4*((phase+offset)%48) for offset in (0, 33, 17, 1)]
            for bits in range(256):
                for adjustment in (0, 1, 2):
                    u.mem_write(0x4a33a, struct.pack('<4H', *cursors))
                    u.mem_write(0x498be, bytes([bits]))
                    self.put(u, 0x4a360, adjustment)
                    before = bytes(u.mem_read(0x40000, 65536))
                    self.call(u, 0x9cf1)
                    expected = bytearray(before)
                    if bits & 15 or adjustment:
                        advanced = [0xa27a+((p-0xa27a+4)%192) for p in cursors]
                        expected[0xa33a:0xa342] = struct.pack('<4H', *advanced)
                    self.assertEqual(bytes(u.mem_read(0x40000, 65536)), bytes(expected))
            for r, v in dict(AX=0x1234, BX=0x5678, CX=0x9abc, DX=0xdef0, SI=0x200, DI=0x300, BP=0x100).items():
                self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+r]), v)
        u.mem_write(0x4a33a, struct.pack('<4H', 0xa33a, 0xffff, 0xa335, 0xa338))
        self.call(u, 0x9cf1)
        self.assertEqual(bytes(u.mem_read(0x4a33a, 8)), struct.pack('<4H', 0xa33e, 3, 0xa339, 0xa33c))

    def test_apply_slots_and_alias_order(self):
        for present in range(4):
            for same_destination in (False, True):
                u = self.machine()
                self.put(u, 0x4a962, 0x300 if present&1 else 0xffff)
                self.put(u, 0x4a964, (0x300 if same_destination else 0x400) if present&2 else 0xffff)
                self.put(u, 0x4a33c, 0xa2fe)
                self.put(u, 0x4a33e, 0xa2be)
                u.mem_write(0x4a2fe, struct.pack('<HH', 1, 2))
                u.mem_write(0x4a2be, struct.pack('<HH', 3, 4))
                expected = bytearray(u.mem_read(0x40000, 65536))
                if present&1: expected[0x302:0x306] = struct.pack('<HH', 1, 2)
                if present&2:
                    p = 0x302 if same_destination else 0x402
                    expected[p:p+4] = struct.pack('<HH', 3, 4)
                self.call(u, 0xa031)
                self.assertEqual(bytes(u.mem_read(0x40000, 65536)), bytes(expected))
                self.assertEqual(bool(u.reg_read(UC_X86_REG_EFLAGS)&0x40), not bool(present&2))
                if not present:
                    self.assertEqual(u.reg_read(UC_X86_REG_AX), 0x1234)
                    self.assertEqual(u.reg_read(UC_X86_REG_BX), 0x5678)
                    self.assertEqual(u.reg_read(UC_X86_REG_SI), 0x200)
        u = self.machine()
        self.put(u, 0x4a962, 0xa2fe)
        self.put(u, 0x4a964, 0xffff)
        self.put(u, 0x4a33c, 0xa2fe)
        u.mem_write(0x4a2fe, struct.pack('<HH', 10, 90))
        self.call(u, 0xa031)
        self.assertEqual(bytes(u.mem_read(0x4a2fe, 6)), struct.pack('<HHH', 10, 10, 10))

    def test_offset_pair_signed_clamp_and_unbounded_index(self):
        u = self.machine()
        for index in (0, 1, 2, 3, 0xffff):
            for raw_x in (0, 1, 191, 192, 193, 32767, 32768, 65535):
                for work in (0, 7, 0xfff8, 0x8000):
                    for stale in (0, 1):
                        u.reg_write(UC_X86_REG_BX, 0x300)
                        u.reg_write(UC_X86_REG_SI, 0x4800)
                        self.put(u, 0x50108, index)
                        self.put(u, 0x50102, 0xfffa)
                        self.put(u, 0x50104, 0x1234)
                        self.put(u, 0x4a398, work)
                        p = (0x4800+4*index)&65535
                        u.mem_write(0x40000+p, struct.pack('<HH', 10, (raw_x-0x1234-2*work)&65535))
                        u.mem_write(0x4a39e, bytes([stale, stale]))
                        expected = bytearray(u.mem_read(0x40000, 65536))
                        signed_x = raw_x if raw_x<32768 else raw_x-65536
                        struct.pack_into('<HH', expected, 0x302, 4, min(192, max(0, signed_x)))
                        if signed_x<0: expected[0xa39e] = 1
                        if signed_x>192: expected[0xa39f] = 1
                        self.call(u, 0x9fea)
                        self.assertEqual(bytes(u.mem_read(0x40000, 65536)), bytes(expected))
                        self.assertEqual(u.reg_read(UC_X86_REG_AX), raw_x)
                        self.assertEqual(u.reg_read(UC_X86_REG_SI), (p+4)&65535)
                        # Final comparison occurs before the upper clamp store.
                        self.assertEqual(bool(u.reg_read(UC_X86_REG_EFLAGS)&0x40), signed_x==192)
        u = self.machine()
        u.reg_write(UC_X86_REG_BX, 0xffff)
        self.call(u, 0x9fea)
        self.assertEqual(u.reg_read(UC_X86_REG_AX), 0x1234)
        self.assertEqual(u.reg_read(UC_X86_REG_SI), 0x200)

    def test_four_offset_records_order_and_aggregate_clamp_bytes(self):
        for present in range(16):
            for index in range(3):
                for x, work_a, work_b in [(0, 0, 0), (192, 0, 0), (80, 0xfff8, 8)]:
                    for same_destination in (False, True):
                        u = self.machine()
                        # Original table bytes, independently extracted from pinned inputs.
                        u.mem_write(0x4a368, self.image[0x1ff28:0x1ff58])
                        self.put(u, 0x50108, index)
                        self.put(u, 0x50102, 0xfffc)
                        self.put(u, 0x50104, x)
                        self.put(u, 0x4a39a, work_a)
                        self.put(u, 0x4a39c, work_b)
                        u.mem_write(0x4a39e, b'\x07\x08')
                        for i in range(4):self.put(u, 0x4a966+2*i, (0x300 if same_destination else 0x300+i*56) if present&(1<<i) else 0xffff)
                        expected = bytearray(u.mem_read(0x40000, 65536))
                        expected[0xa39e:0xa3a0] = b'\x00\x00'
                        struct.pack_into('<H', expected, 0xa398, work_b)
                        for i, table, work in [(3,0xa38c,work_a),(1,0xa374,work_a),(2,0xa380,work_b),(0,0xa368,work_b)]:
                            if not present&(1<<i):continue
                            dy, dx = struct.unpack_from('<hh', expected, table+4*index)
                            raw_x = (x+dx+2*work)&65535
                            signed_x = raw_x if raw_x<32768 else raw_x-65536
                            dst = 0x300 if same_destination else 0x300+i*56
                            struct.pack_into('<HH', expected, dst+2, (0xfffc+dy)&65535, min(192,max(0,signed_x)))
                            if signed_x<0:expected[0xa39e] = 1
                            if signed_x>192:expected[0xa39f] = 1
                        self.call(u, 0x9faf)
                        self.assertEqual(bytes(u.mem_read(0x40000, 65536)), bytes(expected))
                        self.assertEqual(u.reg_read(UC_X86_REG_BP), 0x100)
                        self.assertEqual(u.reg_read(UC_X86_REG_CX), 0x9abc)
                        self.assertEqual(u.reg_read(UC_X86_REG_DX), 0xdef0)

    def test_delayed_positions_across_two_wraps(self):
        # Independent chronological list, not a second implementation of ring arithmetic.
        u = self.machine(data=0x6000)
        self.put(u, 0x5237e, 100)
        self.put(u, 0x52380, 50)
        self.call(u, 0x99bf)
        self.put(u, 0x6a962, 0x300)
        self.put(u, 0x6a964, 0x400)
        samples = [(108, 59)] * 48
        for t in range(120):
            request = t%5 != 0
            u.mem_write(0x698be, bytes([1 if request else 0]))
            self.put(u, 0x6a360, 0)
            self.put(u, 0x5237e, t)
            self.put(u, 0x52380, 2*t)
            if request: samples.append((t+8, 2*t+8))
            else: samples[-1] = (t+8, 2*t+8)
            self.call(u, 0x9cf1)
            self.call(u, 0x9cd9)
            self.call(u, 0xa031)
            self.assertEqual(bytes(u.mem_read(0x60302, 4)), struct.pack('<HH', *samples[-16]))
            self.assertEqual(bytes(u.mem_read(0x60402, 4)), struct.pack('<HH', *samples[-32]))


if __name__ == '__main__':
    unittest.main()
