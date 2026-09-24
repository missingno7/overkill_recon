"""Isolated original-code grid dependencies and DOS-vector frame boundary."""
import sys, struct, unittest, itertools
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'tools'))
from extract import extract
from unicorn import Uc, UC_ARCH_X86, UC_MODE_16, UC_HOOK_INTR, UC_HOOK_CODE
from unicorn.x86_const import *

class GridVectorTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls): cls.image=extract()[0]
    def machine(self):
        u=Uc(UC_ARCH_X86,UC_MODE_16);u.mem_map(0,0x100000);u.mem_write(0x10000,self.image)
        return u
    def reset(self,u,cs=0x1000):
        for r,v in dict(CS=cs,DS=0x4000,ES=0x6000,SS=0x5000,SP=0xff00,
                        BP=0x100,AX=0x1234,BX=0x200,CX=0x9abc,DX=0xdef0,
                        SI=0x300,DI=0x400,EFLAGS=0x603).items():
            u.reg_write(globals()['UC_X86_REG_'+r],v)
        self.put(u,0x5ff00,0xf800)
    def put(self,u,p,v):u.mem_write(p,struct.pack('<H',v&65535))
    def call(self,u,ip,cs=0x1000,far=False):
        if far:self.put(u,0x5ff02,0x1000)
        end=0x1f800 if far else cs*16+0xf800
        u.emu_start(cs*16+ip,end,count=100)
        self.assertEqual(u.reg_read(UC_X86_REG_IP),0xf800)
        self.assertEqual(u.reg_read(UC_X86_REG_SP),0xff04 if far else 0xff02)
    def test_grid_offset_sign_wrap_and_scratch(self):
        u=self.machine()
        values=(0,1,15,16,0x7fff,0x8000,0xffff)
        for y,bias,x,base in itertools.product(values,values,values,(0,0xffff)):
            self.reset(u);self.put(u,0x50102,y);self.put(u,0x50104,x)
            self.put(u,0x4234e,bias);self.put(u,0x42350,base)
            expected=bytearray(u.mem_read(0x40000,65536));total=(y+bias)&65535
            struct.pack_into('<H',expected,0x215a,total)
            self.call(u,0x5073)
            negative=bool(total&0x8000);row=total>>4;col=x>>4
            for r,v in dict(AX=total if negative else col,
                            BX=0xffff if negative else (base-13*row+col)&65535,
                            CX=0x9abc if negative else 4*row,
                            DX=0xdef0 if negative else row,
                            BP=0x100,SI=0x300,DI=0x400,DS=0x4000,SS=0x5000,ES=0x6000).items():
                self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+r]),v)
            self.assertEqual(bytes(u.mem_read(0x40000,65536)),bytes(expected))
            self.assertEqual(bytes(u.mem_read(0x50102,4)),struct.pack('<HH',y,x))
            self.assertEqual(u.reg_read(UC_X86_REG_EFLAGS)&0x600,0x600)
    def test_indexed_attribute_all_byte_indices_and_live_flags(self):
        u=self.machine();self.put(u,0x19592,0x6000)
        u.mem_write(0x4c3aa,bytes(reversed(range(256))))
        before=bytes(u.mem_read(0x40000,65536))
        for index in range(256):
            self.reset(u);u.mem_write(0x60200,bytes([index]));self.call(u,0x505b)
            value=255-index
            self.assertEqual(u.reg_read(UC_X86_REG_AX),value)
            self.assertEqual(u.reg_read(UC_X86_REG_SI),0xc3aa+index)
            flags=u.reg_read(UC_X86_REG_EFLAGS)
            expected=(0x40 if value==0 else 0)|(0x80 if value&128 else 0)|(4 if value.bit_count()%2==0 else 0)
            self.assertEqual(flags&0x8c5,expected) # CF/OF clear, SZP defined; AF unspecified.
            for r,v in dict(BX=0x200,CX=0x9abc,DX=0xdef0,BP=0x100,DI=0x400,DS=0x4000,SS=0x5000,ES=0x6000).items():
                self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+r]),v)
            self.assertEqual(bytes(u.mem_read(0x40000,65536)),before)
    def test_shared_response_entry_gates_wrap_and_complete_memory(self):
        u=self.machine()
        cases=itertools.product((0,1,0xffff),(0,1,2),(0,1),(0,1,2,0x8000,0xffff))
        for gate,count_gate,optional,counter in cases:
            self.reset(u)
            self.put(u,0x4bedc,gate);self.put(u,0x42324,count_gate)
            u.mem_write(0x498c0,bytes([optional]));u.mem_write(0x4beff,b'\x73')
            self.put(u,0x50120,counter);self.put(u,0x50124,0xabcd)
            expected=bytearray(u.mem_read(0,0x100000))
            enabled=gate!=0 or count_gate==1
            result=(counter-1)&65535 if enabled else counter
            carry=enabled and result==0
            if optional:expected[0x4beff]=14
            struct.pack_into('<H',expected,0x50120,result)
            struct.pack_into('<H',expected,0x50124,0 if carry else 5)
            regs={r:u.reg_read(r) for r in (UC_X86_REG_AX,UC_X86_REG_BX,
                UC_X86_REG_CX,UC_X86_REG_DX,UC_X86_REG_SI,UC_X86_REG_DI,
                UC_X86_REG_BP,UC_X86_REG_DS,UC_X86_REG_ES,UC_X86_REG_SS)}
            self.call(u,0xac56)
            self.assertEqual(bytes(u.mem_read(0,0x100000)),bytes(expected))
            self.assertEqual(u.reg_read(UC_X86_REG_EFLAGS)&1,int(carry))
            self.assertEqual(u.reg_read(UC_X86_REG_EFLAGS)&0x600,0x600)
            for r,value in regs.items():self.assertEqual(u.reg_read(r),value)

    def test_grid_response_composed_region(self):
        u=self.machine();self.put(u,0x19592,0x6000)
        # Both attributes are independent bytes; include nonboolean values.
        cases=itertools.product((0,1,15,16,0xffff),(0,0xffff),
                                ((0,0),(0,1),(1,0),(255,2)),(0,1,2))
        for x,y,attrs,counter in cases:
            self.reset(u);self.put(u,0x50102,y);self.put(u,0x50104,x)
            self.put(u,0x4234e,0);self.put(u,0x42350,0xfff2)
            self.put(u,0x4bedc,1);self.put(u,0x42324,0)
            self.put(u,0x50120,counter);self.put(u,0x50124,0xabcd)
            u.mem_write(0x498c0,b'\x01');u.mem_write(0x4beff,b'\x73')
            grid=0xffff if y&0x8000 else (0xfff2-13*(y>>4)+(x>>4))&65535
            first=(grid+13)&65535;second=(first+1)&65535
            u.mem_write(0x60000+first,b'\x11');u.mem_write(0x60000+second,b'\x22')
            u.mem_write(0x4c3bb,bytes([attrs[0]]));u.mem_write(0x4c3cc,bytes([attrs[1]]))
            second_read=attrs[0]==0 and (x&15)!=0
            value=attrs[1] if second_read else attrs[0]
            expected=bytearray(u.mem_read(0,0x100000))
            struct.pack_into('<H',expected,0x4215a,y)
            # The two near CALLs reuse this one stack word; last return is observable memory.
            struct.pack_into('<H',expected,0x5fefe,0xac52 if second_read else 0xac45)
            result=(counter-1)&65535;carry=value!=0 and result==0
            if value:
                expected[0x4beff]=14
                struct.pack_into('<H',expected,0x50120,result)
                struct.pack_into('<H',expected,0x50124,0 if carry else 5)
            self.call(u,0xac3c)
            self.assertEqual(bytes(u.mem_read(0,0x100000)),bytes(expected))
            for r,v in dict(AX=value,BX=second if second_read else first,
                    SI=0xc3cc if second_read else 0xc3bb,ES=0x6000,
                    CX=0x9abc if y&0x8000 else 4*(y>>4),
                    DX=0xdef0 if y&0x8000 else y>>4,
                    BP=0x100,DI=0x400,DS=0x4000,SS=0x5000).items():
                self.assertEqual(u.reg_read(globals()['UC_X86_REG_'+r]),v)
            self.assertEqual(u.reg_read(UC_X86_REG_EFLAGS)&1,int(carry))
            self.assertEqual(u.reg_read(UC_X86_REG_EFLAGS)&0x600,0x600)

    def test_far_to_near_bridges_preserve_callee_effects_and_stack(self):
        u=self.machine()
        for bridge,target,reg in ((0x8d8b,0xa60a,UC_X86_REG_AX),(0x8d8e,0xc7fe,UC_X86_REG_BP)):
            self.reset(u);u.reg_write(reg,target);self.put(u,0x50104,175)
            if reg==UC_X86_REG_BP:u.reg_write(UC_X86_REG_AX,0x0061)
            self.put(u,0x5ff02,0x1f7f);seen=[]
            def observe(uc,pc,size,_):
                if pc==0x10000+target:
                    sp=uc.reg_read(UC_X86_REG_SP)
                    seen.append((sp,int.from_bytes(uc.mem_read(0x50000+sp,2),'little')))
            hook=u.hook_add(UC_HOOK_CODE,observe)
            u.emu_start(0x10000+bridge,0x1f7f0+0xf800,count=100)
            u.hook_del(hook)
            self.assertEqual(seen,[(0xfefe,bridge+2)])
            self.assertEqual(u.reg_read(UC_X86_REG_CS),0x1f7f)
            self.assertEqual(u.reg_read(UC_X86_REG_IP),0xf800)
            self.assertEqual(u.reg_read(UC_X86_REG_SP),0xff04)
            if reg==UC_X86_REG_AX:
                self.assertEqual(int.from_bytes(u.mem_read(0x50104,2),'little'),176)
            else:self.assertEqual(u.reg_read(UC_X86_REG_AX),0x0041)

    def test_vector_helper_request_ds_restore_and_far_boundary(self):
        u=self.machine();seen=[]
        def service(uc,number,_):
            self.assertEqual(number,0x21)
            seen.append(tuple(uc.reg_read(r) for r in (UC_X86_REG_AX,UC_X86_REG_DS,UC_X86_REG_DX)))
            # Do not accidentally prove preservation by giving DOS no scratch effects.
            uc.reg_write(UC_X86_REG_AX,0x7777);uc.reg_write(UC_X86_REG_DX,0x8888)
        u.hook_add(UC_HOOK_INTR,service)
        for vector,offset in ((0,0),(0x24,6),(0xff,0xffff)):
            self.reset(u,0x2534);u.reg_write(UC_X86_REG_AX,0xab00|vector);u.reg_write(UC_X86_REG_DX,offset)
            self.call(u,0x45,0x2534)
            self.assertEqual(seen[-1],(0x2500|vector,0x2534,offset))
            self.assertEqual(u.reg_read(UC_X86_REG_DS),0x4000)
            self.assertEqual(u.reg_read(UC_X86_REG_AX),0x7777)
            self.assertEqual(u.reg_read(UC_X86_REG_DX),0x8888)
        self.reset(u,0x2534);self.call(u,0x3c,0x2534,far=True)
        self.assertEqual(seen[-1],(0x2524,0x2534,6))
        self.assertEqual(u.reg_read(UC_X86_REG_CS),0x1000)
        self.assertEqual(u.reg_read(UC_X86_REG_DS),0x4000)

if __name__=='__main__':unittest.main()
