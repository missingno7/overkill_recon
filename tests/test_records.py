"""Original-code contracts for record searches and input-driven coordinate updates."""
import sys,struct,itertools,unittest
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from common import *
from extract import extract
from unicorn import *
from unicorn.x86_const import *

class RecordMovementTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):cls.image=extract()[0]
    def machine(self):
        u=Uc(UC_ARCH_X86,UC_MODE_16);u.mem_map(0,0x100000);u.mem_write(0x10000,self.image)
        self.reset(u);return u
    def reset(self,u):
        for r,v in {'CS':0x1000,'DS':0x4000,'ES':0x6000,'SS':0x5000,'SP':0xff00,'BP':0x100,'AX':0x1234,'BX':0x5678,'CX':0x9abc,'DX':0xdef0,'SI':0x200,'DI':0x300,'EFLAGS':0x603}.items():u.reg_write(globals()['UC_X86_REG_'+r],v)
        u.mem_write(0x5ff00,struct.pack('<H',0xf800))
    def run_at(self,u,ip):
        u.emu_start(0x10000+ip,0x1f800,count=1000)
        self.assertEqual(u.reg_read(UC_X86_REG_IP),0xf800);self.assertEqual(u.reg_read(UC_X86_REG_SP),0xff02)
    def word(self,u,p):return int.from_bytes(u.mem_read(p,2),'little')
    def put(self,u,p,v):u.mem_write(p,struct.pack('<H',v&65535))
    def test_record_searches_every_start_and_free_position(self):
        for ip,base,count,cursor in [(0x7524,0x23b4,35,0x95d8),(0x7573,0x2b5c,34,0x95da)]:
            u=self.machine();busy=bytearray([0xa5]*(count*56))
            for i in range(count):struct.pack_into('<H',busy,i*56,1)
            for start in range(count):
                for free in range(-1,count):
                    self.reset(u);records=bytearray(busy)
                    if free>=0:struct.pack_into('<H',records,free*56,0)
                    u.mem_write(0x40000+base,bytes(records));self.put(u,0x40000+cursor,base+56*start)
                    self.run_at(u,ip)
                    self.assertEqual(u.reg_read(UC_X86_REG_BX),0xffff if free<0 else base+free*56)
                    self.assertEqual(u.reg_read(UC_X86_REG_CX),0 if free<0 else count-((free-start)%count))
                    self.assertEqual(self.word(u,0x40000+cursor),base+56*(start if free<0 else free))
                    self.assertEqual(bytes(u.mem_read(0x40000+base,len(records))),bytes(records))
                    for r,v in [('AX',0x1234),('DX',0xdef0),('SI',0x200),('DI',0x300),('BP',0x100)]:self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+r]),v)
            # B normalizes the end cursor before reading; A does not.
            self.reset(u);u.mem_write(0x40000+base,bytes(busy));self.put(u,0x40000+base+count*56,0);self.put(u,0x40000+cursor,base+count*56)
            self.run_at(u,ip)
            self.assertEqual(u.reg_read(UC_X86_REG_BX),0xffff if ip==0x7573 else base+count*56)
    def test_double_steps_and_mode_bypass(self):
        u=self.machine();cases=[0,1,2,0x1f,0x20,0x21,0x22,0xaf,0xb0,0xb1,0xbf,0xc0,0xc1,0xfffe,0xffff]
        specs=[(0xa5d1,2,lambda x:x if x==0x20 else (x-1)&65535),(0xa5ea,2,lambda x:x if x==0xc0 else (x+1)&65535),(0xa5f9,4,lambda x:max(0,x-1)),(0xa607,4,lambda x:x+1 if x<0xb0 else x)]
        for ip,field,step in specs:
            for mode in (0,1,0xffff):
                for value in cases:
                    self.reset(u);self.put(u,0x4a47c,mode);self.put(u,0x50100+field,value);self.put(u,0x40100+field,0xdead)
                    self.run_at(u,ip);expected=(value-1)&65535 if ip==0xa5d1 and mode else step(step(value))
                    self.assertEqual(self.word(u,0x50100+field),expected);self.assertEqual(self.word(u,0x40100+field),0xdead)
                    for r,v in [('AX',0x1234),('BX',0x5678),('CX',0x9abc),('DX',0xdef0)]:self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+r]),v)
                    self.assertEqual(u.reg_read(UC_X86_REG_EFLAGS)&0x600,0x600)
    def test_count_dispatch_all_sentinels_and_input_adjustments(self):
        u=self.machine();targets=set();self.assertEqual(self.image[0x44af],0xc3)
        def plus(x):return x+1 if x<176 else x
        def minus(x):return max(x-1,0)
        for flags in itertools.product((False,True),repeat=4):
            positive=int(flags[0])+int(flags[2]);negative=int(flags[1])+int(flags[3]);index=negative+3*positive
            for gate in (0,1,2):
                for buttons,left,right,x in [(0,0,0,0),(0,0,0,175),(0,0,0,176),(0,0,0,65535),(0,1,1,0),(0,1,1,176),(1,1,1,10),(2,1,1,10),(3,1,1,10),(0,2,2,10)]:
                    self.reset(u);self.put(u,0x50104,x);self.put(u,0x40104,0xbeef);u.mem_write(0x498be,bytes([buttons]));u.mem_write(0x4a39e,bytes([left,right]));self.put(u,0x42324,gate)
                    for i,active in enumerate(flags):self.put(u,0x4a966+2*i,0x8000 if active else 0xffff)
                    seen=[]
                    hook=u.hook_add(UC_HOOK_CODE,lambda uc,p,s,d:seen.append(p-0x10000));self.run_at(u,0x9c01);u.hook_del(hook)
                    expected=x;changed=0
                    if not buttons&2 and left==1:expected=plus(plus(expected));changed=1
                    if not buttons&1 and right==1:expected=minus(minus(expected));changed=1
                    diff=positive-negative
                    if diff and (abs(diff)==2 or gate!=1):expected=plus(expected) if diff>0 else minus(expected);changed=1
                    self.assertEqual(self.word(u,0x50104),expected);self.assertEqual(self.word(u,0x40104),0xbeef);self.assertEqual(self.word(u,0x4a360),changed)
                    target=int.from_bytes(self.image[0x9c70+2*index:0x9c72+2*index],'little');self.assertIn(target,seen);targets.add(target)
                    self.assertEqual(u.reg_read(UC_X86_REG_BX),2*index);self.assertEqual(u.reg_read(UC_X86_REG_AX),(positive<<8)|negative)
        self.assertEqual(targets,{0x44af,0x9c82,0x9c93,0x9c9c,0x9cad})
if __name__=='__main__':unittest.main()
