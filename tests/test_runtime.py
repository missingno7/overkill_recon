"""Executable leaf/branch and resource-format checks for the runtime investigation."""
import sys,unittest,struct,tempfile,gzip
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'tools'))
from common import *
from extract import extract
from resources import driver,resources,decode_enc
from unicorn import *
from unicorn.x86_const import *

class RuntimeTests(unittest.TestCase):
    def test_resources_pinned_and_complete(self):
        data,rows=resources();self.assertEqual(len(rows),58)
        expected={'adlib':(436669,8021,16318,'05fa5a7e41d1b3a4dadc162aa1096bbafc9cf8c51cf6dc7ab22a0fbd0ef0013e'),'roland':(444690,7548,14594,'bbb8458f2c752f7be87928f1e68d7af965d8f80f8ab32e58a3c40b12528eb2bb')}
        for name,(offset,size,length,digest) in expected.items():
            b,m=driver(name);self.assertEqual((m['offset'],m['size'],len(b),sha(b)),(offset,size,length,digest));self.assertEqual(m['compressed_consumed'],size)
            with self.assertRaises(ValueError):decode_enc(data[offset:offset+size-1])
    def test_input_is_state_selected_existing_code(self):
        image,m=extract();loaded=bytearray(image);base=0x1010;ds=base+0x15bc
        for site in m['relocations']:struct.pack_into('<H',loaded,site,(struct.unpack_from('<H',loaded,site)[0]+base)&65535)
        for mode,scan,expected in [(0,0x39,16),(2,0x39,16),(0,0x77,0),(2,0x77,16),(1,None,None)]:
            u=Uc(UC_ARCH_X86,UC_MODE_16);u.mem_map(0,0x100000);u.mem_write(base*16,bytes(loaded))
            for reg,val in [(UC_X86_REG_CS,base),(UC_X86_REG_DS,ds),(UC_X86_REG_SS,0x8000),(UC_X86_REG_SP,0xfffe),(UC_X86_REG_EFLAGS,0x202)]:u.reg_write(reg,val)
            u.mem_write(0x8fffe,struct.pack('<H',0xf800));u.mem_write(ds*16+0x10,struct.pack('<H',mode));u.mem_write(ds*16+0x98c4,bytes(128))
            if scan is not None:u.mem_write(ds*16+0x98c4+scan,b'\1')
            seen=set();ports=[];writes=[]
            def code(uc,addr,size,_):
                seen.add(addr-base*16)
                if addr==base*16+0xf800:uc.emu_stop()
            def inp(uc,port,size,_):ports.append(port);return 0
            u.hook_add(UC_HOOK_CODE,code);u.hook_add(UC_HOOK_INSN,inp,None,1,0,UC_X86_INS_IN)
            u.hook_add(UC_HOOK_MEM_WRITE,lambda uc,access,addr,size,value,data:writes.append((addr,size)))
            u.emu_start(base*16+0x162,0xfffff,count=200000)
            self.assertIn(0xf800,seen)
            self.assertEqual(0x1ce in seen,mode==1);self.assertEqual(0x17e in seen,mode!=1)
            if mode==1:self.assertTrue(ports and set(ports)=={0x201})
            else:self.assertEqual(u.mem_read(ds*16+0x98be,1)[0],expected);self.assertFalse(ports)
            self.assertFalse(any(base*16<=addr<base*16+0x10220 for addr,size in writes))
    def test_adlib_status_leaf_contract(self):
        payload,_=driver('adlib');u=Uc(UC_ARCH_X86,UC_MODE_16);u.mem_map(0,0x100000);u.mem_write(0x30000,payload)
        for reg,val in [(UC_X86_REG_CS,0x3000),(UC_X86_REG_DS,0x3000),(UC_X86_REG_SS,0x8000),(UC_X86_REG_SP,0xfffe),(UC_X86_REG_AX,0x1234),(UC_X86_REG_DX,0xabcd),(UC_X86_REG_EFLAGS,0x247)]:u.reg_write(reg,val)
        u.mem_write(0x8fffe,struct.pack('<H',0xf000));seen=[]
        def inp(uc,port,size,_):seen.append((port,size));return 0xa0
        u.hook_add(UC_HOOK_INSN,inp,None,1,0,UC_X86_INS_IN)
        u.hook_add(UC_HOOK_CODE,lambda uc,addr,size,data:uc.emu_stop() if addr==0x3f000 else None)
        u.emu_start(0x30571,0xfffff,count=100)
        self.assertEqual(seen,[(0x388,1)]);self.assertEqual(u.reg_read(UC_X86_REG_AX),0x12a0);self.assertEqual(u.reg_read(UC_X86_REG_DX),0xabcd);self.assertEqual(u.reg_read(UC_X86_REG_EFLAGS),0x247)
        self.assertEqual(bytes(u.mem_read(0x30000,len(payload))),payload)
if __name__=='__main__':unittest.main()
