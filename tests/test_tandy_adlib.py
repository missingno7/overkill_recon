"""Isolated original-routine checks; no game startup or gameplay execution."""
import sys,struct,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from common import *
from extract import extract
from resources import driver
from unicorn import *
from unicorn.x86_const import *

class TandyAdlibTests(unittest.TestCase):
    def machine(self,payload):
        u=Uc(UC_ARCH_X86,UC_MODE_16);u.mem_map(0,0x100000);u.mem_write(0x10000,payload)
        for r,v in {'CS':0x1000,'DS':0x4000,'ES':0x6000,'SS':0x8000,'SP':0xff00,'AX':0x1234,'BX':0x4567,'CX':0x89ab,'DX':0xcdef,'SI':0x100,'DI':0x300,'BP':0x7890,'EFLAGS':0x202}.items():u.reg_write(globals()['UC_X86_REG_'+r],v)
        u.mem_write(0x8ff00,struct.pack('<H',0xf800));return u
    def run_at(self,u,ip,count=100000):
        u.emu_start(0x10000+ip,0x1f800,count=count)
        self.assertEqual(u.reg_read(UC_X86_REG_IP),0xf800)
        self.assertEqual(u.reg_read(UC_X86_REG_SP),0xff02)
    def test_tandy_address_helpers_use_full_byte_indices_and_word_wrap(self):
        image,_=extract()
        for ip,table in [(0x3103,0x9ee8),(0x3118,0x9bc8),(0x312d,0x9d58)]:
            u=self.machine(image)
            for y in (0,1,199,200,255):
                base=(0xfffd+y*17)&65535;u.mem_write(0x40000+table+2*y,struct.pack('<H',base))
                for x in (0,1,39,255):
                    u.reg_write(UC_X86_REG_AX,(y<<8)|x);u.reg_write(UC_X86_REG_SP,0xff00)
                    self.run_at(u,ip)
                    self.assertEqual(u.reg_read(UC_X86_REG_AX),(base+4*x)&65535)
                    self.assertEqual(u.reg_read(UC_X86_REG_DI),(base+4*x)&65535)
                    self.assertEqual(u.reg_read(UC_X86_REG_BX),base)
                    self.assertEqual(u.reg_read(UC_X86_REG_SI),0x100)
    def test_tandy_row_copies_match_independent_layout(self):
        image,_=extract()
        for ip,stride in [(0x306f,None),(0x3097,104),(0x30b4,160)]:
            for first in (0,1,3,4,191):
                u=self.machine(image);rows=7;width=12
                u.mem_write(0x195a4,struct.pack('<H',0x6000));u.mem_write(0x19598,struct.pack('<H',0x6000))
                data=bytes((i*37+11)&255 for i in range(rows*width));u.mem_write(0x40100,struct.pack('<HH',rows,width//4)+data)
                def row_start(y):return (y%4)*8192+(y//4)*160 if stride is None else y*stride
                start=row_start(first)+6;u.reg_write(UC_X86_REG_DI,start)
                before=bytes([0xa5])*65536;u.mem_write(0x60000,before);expected=bytearray(before)
                for row in range(rows):
                    dest=row_start(first+row)+6;expected[dest:dest+width]=data[row*width:(row+1)*width]
                ports=[];u.hook_add(UC_HOOK_INSN,lambda uc,p,s,v,d:ports.append(p),None,1,0,UC_X86_INS_OUT)
                self.run_at(u,ip)
                self.assertEqual(bytes(u.mem_read(0x60000,65536)),bytes(expected));self.assertFalse(ports)
                self.assertEqual(u.reg_read(UC_X86_REG_DI),row_start(first+rows)+6)
                self.assertEqual(u.reg_read(UC_X86_REG_SI),0x104+rows*width)
                self.assertEqual(u.reg_read(UC_X86_REG_CX),0);self.assertEqual(u.reg_read(UC_X86_REG_BP),width)
    def test_nibble_mask_expansion_all_256_values(self):
        image,_=extract();u=self.machine(image)
        # Deliberately distinct: the routine sets ES but its stores use DS.
        u.mem_write(0x19596,struct.pack('<H',0x6000))
        u.mem_write(0x41514,bytes([0xa5])*1024);u.mem_write(0x61514,bytes([0x5a])*1024)
        self.run_at(u,0x0fe4)
        expected=bytes((((v>>(7-2*j))&1)*0xf0)|(((v>>(6-2*j))&1)*0x0f) for v in range(256) for j in range(4))
        self.assertEqual(bytes(u.mem_read(0x41514,1024)),expected)
        self.assertEqual(bytes(u.mem_read(0x61514,1024)),bytes([0x5a])*1024)
        self.assertEqual(u.reg_read(UC_X86_REG_DI),0x1917)
        self.assertEqual(u.reg_read(UC_X86_REG_ES),0x6000)
        for reg,val in [('BX',0x4567),('CX',0x89ab),('SI',0x100),('BP',0x7890)]:self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+reg]),val)
    def test_tandy_clear_exact_32k(self):
        image,_=extract();u=self.machine(image);u.mem_write(0x195a4,struct.pack('<H',0x6000))
        u.mem_write(0x60000,bytes([0xa5])*65536);self.run_at(u,0x3345)
        self.assertEqual(bytes(u.mem_read(0x60000,65536)),bytes(32768)+bytes([0xa5])*32768)
        self.assertEqual(u.reg_read(UC_X86_REG_DI),0x8000)
    def attach_ready_adlib_ports(self,u):
        writes=[]
        def inp(uc,port,size,data):
            self.assertIn(port,(0x42,0x61));return 0
        def out(uc,port,size,value,data):
            if port in (0x388,0x389):writes.append((port,value))
        u.hook_add(UC_HOOK_INSN,inp,None,1,0,UC_X86_INS_IN)
        u.hook_add(UC_HOOK_INSN,out,None,1,0,UC_X86_INS_OUT)
        return writes
    def test_adlib_original_register_table_and_sentinel(self):
        payload,_=driver('adlib')
        registers=[0x40,0x41,0x42,0x43,0x44,0x45,0x48,0x49,0x4a,0x4b,0x4c,0x5d,0x50,0x51,0x52,0x53,0x54,0x55,0xb0,0xb1,0xb2,0xb3,0xb4,0xb6,0xb7,0xb8,0xb9]
        for first_zero in (False,True):
            u=self.machine(payload);u.reg_write(UC_X86_REG_DS,0x1000)
            if first_zero:u.mem_write(0x104b1,b'\0\0')
            writes=self.attach_ready_adlib_ports(u);self.run_at(u,0x4a4)
            expected=[v for i,r in enumerate(registers) for v in [(0x388,0 if first_zero and i==0 else r),(0x389,0 if first_zero and i==0 else (0x7f if i<18 else 0))]]
            self.assertEqual(writes,expected);self.assertEqual(u.reg_read(UC_X86_REG_SI),0x4e9);self.assertEqual(u.reg_read(UC_X86_REG_AX),0)
            for r,v in [('BX',0x4567),('CX',0x89ab),('DX',0xcdef),('DI',0x300),('BP',0x7890)]:self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+r]),v)
    def test_adlib_record_a0_b0_pair_index_wrap_and_cache(self):
        payload,_=driver('adlib')
        for note,transpose,delta in [(0,0,0),(18,0,0),(19,0,0),(95,0,0),(96,0,0),(127,0,0),(128,0,0),(255,0,0),(255,2,0xffff),(18,1,0x1234)]:
            for channel in (0,8):
                u=self.machine(payload);u.reg_write(UC_X86_REG_DS,0x1000);di=0x5a9+channel*32;u.reg_write(UC_X86_REG_DI,di)
                u.mem_write(0x10000+di,bytes([note]));u.mem_write(0x10000+di+0x12,bytes([transpose]));u.mem_write(0x10000+di+0x1a,struct.pack('<H',delta));u.mem_write(0x10000+di+0x1d,b'\x73')
                before=bytes(u.mem_read(0x10000+di,32));writes=self.attach_ready_adlib_ports(u);self.run_at(u,0x24f)
                index=(note+transpose)&255
                word=(struct.unpack_from('<H',payload,0x7a9+((2*index)&255))[0]+delta)&65535
                high=(word>>8)|payload[0x749+index]
                self.assertEqual(writes,[(0x388,channel|0xa0),(0x389,word&255),(0x388,channel|0xb0),(0x389,high|0x20)])
                expected=bytearray(before);struct.pack_into('<H',expected,0x14,word);struct.pack_into('<H',expected,8,(high<<8)|(channel|0xb0));expected[0x1e]=0x73
                self.assertEqual(bytes(u.mem_read(0x10000+di,32)),bytes(expected))
                self.assertEqual(u.reg_read(UC_X86_REG_AX),((high|0x20)<<8)|0x73)
                for r,v in [('BX',0x4567),('SI',0x100),('CX',0x89ab),('DX',0xcdef),('DI',di)]:self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+r]),v)
    def test_adlib_step13_zero_return_and_fallthrough(self):
        payload,_=driver('adlib')
        for note,step in [(3,0),(255,1),(1,254)]:
            u=self.machine(payload);u.reg_write(UC_X86_REG_DS,0x1000);u.reg_write(UC_X86_REG_DI,0x5a9)
            u.mem_write(0x105a9,bytes([note]));u.mem_write(0x105a9+0x13,bytes([step]));writes=self.attach_ready_adlib_ports(u);seen=[]
            u.hook_add(UC_HOOK_CODE,lambda uc,addr,size,data:seen.append(addr-0x10000));self.run_at(u,0x244)
            self.assertEqual(u.mem_read(0x105a9,1)[0],(note+step)&255)
            self.assertEqual(0x24f in seen,step!=0);self.assertEqual(len(writes),4 if step else 0)
            if not step:self.assertIn(0x243,seen)
    def test_tandy_workspace_copy_and_partial_clear_extents(self):
        image,_=extract()
        for ip in (0x3354,0x3389):
            u=self.machine(image);u.mem_write(0x195a4,struct.pack('<H',0x6000));u.mem_write(0x19598,struct.pack('<H',0x5000));u.mem_write(0x19596,struct.pack('<H',0x7000))
            start=0x1000;u.mem_write(0x4234c,struct.pack('<H',start));data=bytes((i*17+(i//104))&255 for i in range(104*192));u.mem_write(0x50000+start,data)
            original=bytes([0xa5])*65536;u.mem_write(0x60000,original);expected=bytearray(original)
            for r in range(192 if ip==0x3354 else 200):
                y=r+4 if ip==0x3354 else r;off=(y%4)*8192+(y//4)*160
                expected[off:off+104]=data[r*104:(r+1)*104] if ip==0x3354 else bytes(104)
            self.run_at(u,ip);self.assertEqual(bytes(u.mem_read(0x60000,65536)),bytes(expected))
            if ip==0x3354:
                self.assertEqual(u.reg_read(UC_X86_REG_DS),0x7000);self.assertEqual(u.reg_read(UC_X86_REG_SI),start+104*192);self.assertEqual(u.reg_read(UC_X86_REG_DI),49*160)
            else:self.assertEqual(u.reg_read(UC_X86_REG_DS),0x4000);self.assertEqual(u.reg_read(UC_X86_REG_DI),50*160)
    def test_adlib_delay_and_register_writer_port_contract(self):
        payload,_=driver('adlib')
        for ip,ax in [(0x579,0x1234),(0x557,0xa52b),(0x557,0x0004),(0x557,0xff02)]:
            u=self.machine(payload);u.reg_write(UC_X86_REG_DS,0x1000);u.reg_write(UC_X86_REG_AX,ax);u.reg_write(UC_X86_REG_BX,0x1fec)
            counters=iter([0x1ffe,0x1fec]*(2 if ip==0x557 else 1));half=[];events=[]
            def inp(uc,port,size,data):
                if port==0x61:value=0xa4
                elif port==0x42:
                    if not half:
                        v=next(counters);half.extend([v&255,v>>8])
                    value=half.pop(0)
                else:raise AssertionError(hex(port))
                events.append(('in',port,value));return value
            def out(uc,port,size,value,data):events.append(('out',port,value))
            u.hook_add(UC_HOOK_INSN,inp,None,1,0,UC_X86_INS_IN);u.hook_add(UC_HOOK_INSN,out,None,1,0,UC_X86_INS_OUT)
            self.run_at(u,ip)
            def delay():
                e=[('out',0x43,0xb6),('in',0x61,0xa4),('out',0x61,0xa7)]
                for lo,written in ((0xfe,0xff),(0xec,0xfe)):e += [('out',0x42,written),('out',0x42,0x1f),('out',0x43,0x86),('out',0x43,0xb6),('in',0x42,lo),('in',0x42,0x1f)]
                return e+[('in',0x61,0xa4),('out',0x61,0xa4)]
            expected=delay() if ip==0x579 else [('out',0x388,ax&255)]+delay()+[('out',0x389,ax>>8)]+delay()
            self.assertEqual(events,expected)
            self.assertEqual(u.reg_read(UC_X86_REG_AX),ax if ip==0x579 else (ax&0xff00)|(ax>>8))
            for reg,val in [('BX',0x1fec),('DX',0xcdef),('CX',0x89ab),('SI',0x100),('DI',0x300),('BP',0x7890)]:self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+reg]),val)
            self.assertEqual(bytes(u.mem_read(0x10000,len(payload))),payload)
if __name__=='__main__':unittest.main()
