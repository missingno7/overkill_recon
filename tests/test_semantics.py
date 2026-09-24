"""Behavioral checks against independently extracted original machine code.
These test semantics, including easily missed SS-vs-DS and source mutation.
"""
import sys,unittest,struct
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from common import *
from extract import extract
from unicorn import Uc,UC_ARCH_X86,UC_MODE_16
from unicorn.x86_const import *

class SemanticTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.program,_=extract()
        cls.u=Uc(UC_ARCH_X86,UC_MODE_16);cls.u.mem_map(0,0x100000);cls.u.mem_write(0x10000,cls.program)
    def run_leaf(self,ip,ax=0x5a00,flags=0x202):
        u=self.u
        state={'CS':0x1000,'DS':0x4000,'ES':0x6000,'SS':0x5000,'SP':0xff00,'BP':0x100,'BX':0x200,'SI':0x300,'DI':0x400,'CX':0x3210,'DX':0x9876,'AX':ax,'EFLAGS':flags}
        for r,v in state.items():u.reg_write(globals()['UC_X86_REG_'+r],v)
        u.mem_write(0x5ff00,struct.pack('<H',0xfdf0))
        u.emu_start(0x10000+ip,0x1fdf0,count=500)
        self.assertEqual(u.reg_read(UC_X86_REG_IP),0xfdf0)
        self.assertEqual(u.reg_read(UC_X86_REG_SP),0xff02)
        return u
    def test_ascii_all_256_values(self):
        for ip,lo,hi,mask in [(0xc7fe,0x61,0x7a,0xdf),(0xca5b,0x41,0x5a,0x20)]:
            for value in range(256):
                u=self.run_leaf(ip,0x5a00|value)
                result=(value&mask if ip==0xc7fe else value|mask) if lo<=value<=hi else value
                self.assertEqual(u.reg_read(UC_X86_REG_AX),0x5a00|result)
                for r,v in [('BX',0x200),('CX',0x3210),('DX',0x9876),('BP',0x100),('SI',0x300),('DI',0x400)]:self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+r]),v)
    def test_word_updates_boundaries_and_wrap(self):
        values=[0,1,0x1f,0x20,0x21,0xaf,0xb0,0xb1,0xbf,0xc0,0xc1,0x7fff,0x8000,0xfffe,0xffff]
        specs=[(0xa5db,2,lambda x:x if x==0x20 else (x-1)&65535),(0xa5ed,2,lambda x:x if x==0xc0 else (x+1)&65535),(0xa5fc,4,lambda x:max(x-1,0)),(0xa60a,4,lambda x:x+1 if x<0xb0 else x)]
        for ip,field,fn in specs:
            for value in values:
                self.u.mem_write(0x50100+field,struct.pack('<H',value));self.u.mem_write(0x40100+field,b'\x55\xaa')
                u=self.run_leaf(ip)
                self.assertEqual(bytes(u.mem_read(0x50100+field,2)),struct.pack('<H',fn(value)))
                self.assertEqual(bytes(u.mem_read(0x40100+field,2)),b'\x55\xaa')
    def test_copy_plus10_distinct_default_segments(self):
        for a,b in [(0,1),(0xfffc,0xffff),(0x7fff,0x8000)]:
            self.u.mem_write(0x50102,struct.pack('<HH',a,b));self.u.mem_write(0x40102,b'\x11\x22\x33\x44')
            u=self.run_leaf(0xa571)
            self.assertEqual(bytes(u.mem_read(0x40202,4)),struct.pack('<HH',(a+10)&65535,(b+10)&65535))
            self.assertEqual(u.reg_read(UC_X86_REG_AX),(a+10)&65535)
    def test_xor_copy_mutates_source_and_observes_df(self):
        for df in (0,0x400):
            direction=-1 if df else 1
            for i in range(16):self.u.mem_write(0x40300+direction*i,bytes([i]))
            u=self.run_leaf(0xc9d3,flags=0x202|df)
            for i in range(16):
                self.assertEqual(bytes(u.mem_read(0x40300+direction*i,1)),bytes([i^0xaa]))
                self.assertEqual(bytes(u.mem_read(0x60400+direction*i,1)),bytes([i^0xaa]))
            self.assertEqual(u.reg_read(UC_X86_REG_SI),0x300+16*direction)
            self.assertEqual(u.reg_read(UC_X86_REG_DI),0x400+16*direction)
            self.assertEqual(u.reg_read(UC_X86_REG_CX),0)
    def test_prefix_caller_uses_case_fold_without_changing_case(self):
        for prefix in b'ABCDabcdZz':
            for colon in (ord(':'),ord('/')):
                for flag_a in (0,1,2):
                    for flag_b in (0,1,2):
                        self.u.mem_write(0x421aa,struct.pack('<H',0x1000))
                        self.u.mem_write(0x41000,bytes([prefix,colon,0]))
                        self.u.mem_write(0x4bb86,bytes([flag_a,flag_b]))
                        expected=prefix
                        if colon==ord(':'):
                            while True:
                                folded=expected-32 if 97<=expected<=122 else expected
                                if folded==65 and flag_a!=1:expected+=1
                                elif folded==66 and flag_b!=1:expected+=1
                                else:break
                        u=self.run_leaf(0xc80b)
                        self.assertEqual(bytes(u.mem_read(0x41000,3)),bytes([expected,colon,0]))

    def test_counter_wrap_and_carry_preservation(self):
        for value in (0,0x7f,0xff):
            for carry in (0,1):
                self.u.mem_write(0x1066b,bytes([value]));u=self.run_leaf(0x66c,flags=0x202|carry)
                self.assertEqual(bytes(u.mem_read(0x1066b,1)),bytes([(value+1)&255]))
                self.assertEqual(u.reg_read(UC_X86_REG_EFLAGS)&1,carry)
                u=self.run_leaf(0x672,flags=0x202|carry)
                self.assertEqual(bytes(u.mem_read(0x1066b,1)),b'\0')
                self.assertEqual(u.reg_read(UC_X86_REG_EFLAGS),0x202|carry)

if __name__=='__main__':unittest.main()
