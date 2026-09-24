from common import *
import struct
from unicorn import Uc, UC_ARCH_X86, UC_MODE_16, UC_HOOK_CODE, UC_HOOK_INTR
from unicorn.x86_const import *
data=(ROOT/'assets'/'OVERKILL').read_bytes()
h=struct.unpack_from('<14H',data)
end=(h[2]-1)*512+(h[1] or 512)
u=Uc(UC_ARCH_X86,UC_MODE_16); u.mem_map(0,0x200000)
base=0x1010
u.mem_write(base*16,data[h[4]*16:end]); u.mem_write(0x10000,b'\xcd\x20')
for r,v in [(UC_X86_REG_CS,base+h[11]),(UC_X86_REG_IP,h[10]),(UC_X86_REG_SS,base+h[7]),(UC_X86_REG_SP,h[8]),(UC_X86_REG_DS,0x1000),(UC_X86_REG_ES,0x1000),(UC_X86_REG_EFLAGS,0x202)]: u.reg_write(r,v)
seen=set(); stops=set()
def code(u,a,n,_):
 cs=u.reg_read(UC_X86_REG_CS); ip=u.reg_read(UC_X86_REG_IP)
 if cs not in seen: seen.add(cs); print(f'new CS {cs:04x}:{ip:04x}',flush=True); (ROOT/'build'/f'probe_start_{cs:04x}.bin').write_bytes(bytes(u.mem_read(0,0x100000)))
 if ip in (0xe,0xfc,0x155) and bytes(u.mem_read(cs*16+0x69,17))==bytes.fromhex('d1ed4a7505ad89c5b2107303a4ebf131c9') and (cs,ip) not in stops:
  stops.add((cs,ip))
  print('stage',hex(cs),hex(ip),{r:hex(u.reg_read(globals()['UC_X86_REG_'+r.upper()])) for r in ['ds','es','si','di','ss','sp']},flush=True)
  (ROOT/'build'/f'probe_{cs:04x}_{ip:04x}.bin').write_bytes(bytes(u.mem_read(0,0x100000)))
 if cs==base and ip==0x95c9:
  print('INNER ENTRY',flush=True); (ROOT/'build'/'probe_inner.bin').write_bytes(bytes(u.mem_read(0,0x100000))); u.emu_stop()
def intr(u,n,_): print('UNEXPECTED INT',hex(n),flush=True); u.emu_stop()
u.hook_add(UC_HOOK_CODE,code); u.hook_add(UC_HOOK_INTR,intr)
u.emu_start((base+h[11])*16+h[10],0x1fffff,count=5000000)
print('STOP',hex(u.reg_read(UC_X86_REG_CS)),hex(u.reg_read(UC_X86_REG_IP)))

