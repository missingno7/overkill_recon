"""Independently execute the original stubs in Unicorn, without DOS emulation.
Compares the final relocated image with the pure extractor at two load bases.
"""
from common import *
from extract import extract,mz
import struct
from unicorn import Uc, UC_ARCH_X86, UC_MODE_16, UC_HOOK_CODE, UC_HOOK_INTR
from unicorn.x86_const import *

def verify(base=0x1010,asset='OVERKILL'):
    program,m=extract(asset); data=(ROOT/'assets'/asset).read_bytes(); h,image,rel,_=mz(data)
    u=Uc(UC_ARCH_X86,UC_MODE_16); u.mem_map(0,0x200000); u.mem_write(base*16,image)
    psp=base-16; u.mem_write(psp*16,b'\xcd\x20'); u.mem_write(psp*16+2,struct.pack('<H',0x9fff))
    for r,v in [(UC_X86_REG_CS,base+h['cs']),(UC_X86_REG_IP,h['ip']),(UC_X86_REG_SS,base+h['ss']),(UC_X86_REG_SP,h['sp']),(UC_X86_REG_DS,psp),(UC_X86_REG_ES,psp),(UC_X86_REG_EFLAGS,0x202)]: u.reg_write(r,v)
    transitions=[]; previous=[None]; stopped=[False]; failure=[]
    def code(u,a,n,_):
        cs=u.reg_read(UC_X86_REG_CS); ip=u.reg_read(UC_X86_REG_IP)
        if cs!=previous[0]: transitions.append([cs-base,ip]); previous[0]=cs
        if cs==base+m['entry_cs'] and ip==m['entry_ip']:
            stopped[0]=True; u.emu_stop()
    def intr(u,n,_): failure.append(f'Unexpected interrupt {n:02x}'); u.emu_stop()
    u.hook_add(UC_HOOK_CODE,code); u.hook_add(UC_HOOK_INTR,intr)
    u.emu_start((base+h['cs'])*16+h['ip'],0x1fffff,count=5000000)
    if failure or not stopped[0]: raise AssertionError(f'Bootstrap failed: {failure}')
    expected=bytearray(program)
    for site in m['relocations']:
        struct.pack_into('<H',expected,site,(struct.unpack_from('<H',expected,site)[0]+base)&0xffff)
    actual=bytes(u.mem_read(base*16,len(expected)))
    differences=[i for i,(a,b) in enumerate(zip(actual,expected)) if a!=b]
    if differences: raise AssertionError(f'Unpack mismatch {len(differences)} bytes, first {differences[:10]}')
    return dict(asset=asset,load_segment=base,program_bytes=len(program),exact=True,
                relative_cs_transitions=transitions,relocations_verified=len(m['relocations']),
                registers={r:u.reg_read(globals()['UC_X86_REG_'+r.upper()]) for r in ['ax','bx','cx','dx','si','di','bp','sp','cs','ds','es','ss','ip','eflags']})

if __name__=='__main__':
    results=[verify(b,a) for a in ('OVERKILL','OVERKILL.EXE') for b in (0x1010,0x2010)]
    write_json(ROOT/'build'/'unpack-verification.json',results)
    print(json.dumps(results,indent=2))
