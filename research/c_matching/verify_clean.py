"""Execute fresh compiled DOS C independently of any matching layer.
Comparison projects each ABI onto values, ordered memory effects and I/O events.
It does not silently claim all scratch registers or hardware timing are equivalent.
"""
import sys, struct, itertools
from collections import Counter
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
from build import *
from unicorn import *
from unicorn.x86_const import *

class Check:
 def __init__(self,image,base):
  self.u=Uc(UC_ARCH_X86,UC_MODE_16);self.u.mem_map(0,0x100000);self.u.mem_write(base,image);self.base=base
 def put(self,p,v):self.u.mem_write(p,struct.pack('<H',v&65535))
 def word(self,p):return int.from_bytes(self.u.mem_read(p,2),'little')
 def reset(self,**regs):
  vals=dict(CS=self.base>>4,DS=0x4000,SS=0x5000,ES=0x6000,SP=0xff00,AX=0x5a33,BX=0x200,BP=0x100,CX=0x4567,DX=0x6789,SI=0x300,DI=0x400,EFLAGS=0x202);vals.update(regs)
  for r,v in vals.items():self.u.reg_write(globals()['UC_X86_REG_'+r],v)
 def call(self,ip,args=(),limit=200000):
  self.u.reg_write(UC_X86_REG_SP,0xff00);self.put(0x5ff00,0xf800)
  for i,v in enumerate(args):self.put(0x5ff02+i*2,v)
  self.u.emu_start(self.base+ip,self.base+0xf800,count=limit)
  assert self.u.reg_read(UC_X86_REG_IP)==0xf800,('non-return',hex(ip))
  assert self.u.reg_read(UC_X86_REG_SP)==0xff02,('stack imbalance',hex(ip))
 def reg(self,r):return self.u.reg_read(globals()['UC_X86_REG_'+r])
 def mem(self,p,n):return bytes(self.u.mem_read(p,n))

def verify(manifest):
 image,_=extract();adlib,_=driver('adlib');counts={};rows={n:a for n,a,_ in SAMPLE}
 for config,m in manifest.items():
  main=Check(image,0x10000);audio=Check(adlib,0x10000);compiled=Check(load_exe(OUT/config/'CLEAN.EXE')[0],0x20000);pub=m['publics'];tally=Counter()
  def calls(name,orig,args=()):
   orig.call(rows[name]);compiled.call(pub[name],args);tally[name]+=1
  for name in ('upper_ascii','lower_ascii'):
   for value in range(256):
    main.reset(AX=0xa500|value);compiled.reset();calls(name,main,[value]);assert main.reg('AX')&255==compiled.reg('AX')&255,(config,name,value)
  # Exhaust all16-bit inputs for the reference compiler; enumerate boundary and
  # representative values for every other compiled variant, including high words.
  values=range(65536) if config=='tc_size' else sorted(set(range(260))|{0x7fff,0x8000,0xfffe,0xffff})
  for name,field in [('dec_y',2),('inc_y',2),('dec_x',4),('inc_x',4),('dec_x_twice',4)]:
   for value in values:
    for v in (main,compiled):v.reset();v.put(0x50100+field,value)
    calls(name,main,[0x100,0x5000]);assert main.word(0x50100+field)==compiled.word(0x50100+field),(config,name,value)
  for name in ('copy_position','store_history'):
   for dstseg,dst in [(0x4000,0x200),(0x5000,0x100),(0x5000,0x102),(0x5000,0xfe)]:
    for y,x in [(0,0),(10,20),(0xfffa,0xfffe),(0xffff,0xffff)]:
     for v in (main,compiled):
      v.reset(BX=dst);v.u.mem_write(0x40000,b'\xa5'*65536);v.u.mem_write(0x50000,b'\xa5'*0xf000);v.put(0x50102,y);v.put(0x50104,x)
     if name=='copy_position':main.u.reg_write(UC_X86_REG_DS,dstseg)
     else:
      main.put(0x19596,dstseg)
      for v in (main,compiled):v.put(0x4a33a,dst)
     calls(name,main,[dst,dstseg,0x100,0x5000]+([0x900,0x4000] if name=='store_history' else []))
     if name=='store_history':
      assert main.reg('AX')==compiled.reg('AX');assert main.reg('DI')==compiled.word(0x40900)
      main.put(0x40900,compiled.word(0x40900))
     assert main.mem(0x40000,65536)==compiled.mem(0x40000,65536),(config,name,'DS')
     assert main.mem(0x50000,0xf000)==compiled.mem(0x50000,0xf000),(config,name,'SS alias')
  for delta in (-16,-1,0,1,8,16,32):
   for seed in (0,1,127,255):
    for v in (main,compiled):v.reset(ES=0x4000,SI=0x300,DI=0x300+delta);v.u.mem_write(0x40200,bytes((i+seed)&255 for i in range(512)))
    calls('xor_copy',main,[0x300+delta,0x4000,0x300,0x4000,0x900,0x4000]);assert (main.reg('SI'),main.reg('DI'),main.reg('CX'))==struct.unpack('<3H',compiled.mem(0x40900,6));assert main.mem(0x40200,512)==compiled.mem(0x40200,512)
  for start in range(35):
   for free in range(-1,35):
    for v in (main,compiled):
     v.reset();v.u.mem_write(0x423b4,b'\xa5'*(35*56));v.put(0x495d8,0x23b4+start*56)
     if free>=0:v.put(0x423b4+free*56,0)
    calls('find_free',main,[0x95d8,0x800]);assert main.reg('BX')==compiled.reg('AX');assert main.reg('CX')==compiled.word(0x40800);assert main.word(0x495d8)==compiled.word(0x495d8);assert main.mem(0x423b4,35*56)==compiled.mem(0x423b4,35*56)
  for phase in range(48):
   for bits in (0,1,2,4,8,15,16,255):
    for adjust in (0,1,2):
     cursor=struct.pack('<4H',*[0xa27a+4*((phase+d)%48) for d in (0,33,17,1)])
     for v in (main,compiled):v.reset();v.u.mem_write(0x4a33a,cursor);v.u.mem_write(0x498be,bytes([bits]));v.put(0x4a360,adjust)
     calls('advance_history',main,[0xa33a,0x4000,bits,adjust]);assert main.mem(0x4a33a,8)==compiled.mem(0x4a33a,8)
  for index in (0,1,2,3,0xffff):
   for x in (0,1,191,192,193,32767,32768,65535):
    for work in (0,8,0xfff8):
     for present in (True,False):
      for v in (main,compiled):
       v.reset(BX=0x200 if present else 0xffff,SI=0x800);v.put(0x50108,index);v.put(0x50102,0xfff8);v.put(0x50104,x);v.put(0x4a398,work);v.u.mem_write(0x4a39e,b'\x00\x01');v.u.mem_write(0x40200,b'\xa5'*56);v.u.mem_write(0x40000+((0x800+index*4)&65535),struct.pack('<HH',10,3))
      calls('place_pair',main,[0x200 if present else 0xffff,0x4000,0x100,0x5000,0x800,0x4000,work,0xa39e,0x4000])
      assert main.mem(0x40200,56)==compiled.mem(0x40200,56),(config,'place_pair',index,x,work,present)
      assert main.mem(0x4a39e,2)==compiled.mem(0x4a39e,2)
  for y in (0,3,4,17,190):
   for rowsn in (1,2,5):
    for units in (1,2,8,26):
     off=(y%4)*8192+(y//4)*160;source=struct.pack('<HH',rowsn,units)+bytes((i*17)&255 for i in range(rowsn*units*4))
     for v in (main,compiled):v.reset(SI=0x3000,DI=off);v.put(0x195a4,0x6000);v.u.mem_write(0x43000,source);v.u.mem_write(0x60000,b'\xa5'*65536)
     calls('tandy_copy',main,[0,0x6000,0x3000,0x4000,off,0x900,0x4000]);assert (main.reg('SI'),main.reg('DI'),main.reg('CX'),main.reg('BP'))==struct.unpack('<4H',compiled.mem(0x40900,8));assert main.mem(0x60000,65536)==compiled.mem(0x60000,65536),(config,'tandy',y,rowsn,units)
  def ports(machine,readvals):
   pending=iter(readvals);events=[]
   def inp(u,port,size,data):
    value=next(pending);events.append(['in',port,value]);return value
   def out(u,port,size,value,data):events.append(['out',port,value])
   h1=machine.u.hook_add(UC_HOOK_INSN,inp,None,1,0,UC_X86_INS_IN);h2=machine.u.hook_add(UC_HOOK_INSN,out,None,1,0,UC_X86_INS_OUT)
   return events,(h1,h2)
  for value in range(256):
   audio.reset(DS=0x1000);compiled.reset();audio.put(0x1000e,0x388);ae,ah=ports(audio,[value]);ce,ch=ports(compiled,[value]);calls('opl_status',audio,[0x388]);assert ae==ce;assert audio.reg('AX')&255==compiled.reg('AX')&255
   for h in ah:audio.u.hook_del(h)
   for h in ch:compiled.u.hook_del(h)
  for threshold,readwords in [(0x1fec,[0x1fff,0x1fec]),(0x1ffc,[0x1ffc]),(0,[0x8000]),(0xffff,[0,0xffff]),(0x8000,[0x7fff,0x8000])]:
   reads=[0xa4]+[b for w in readwords for b in (w&255,w>>8)]+[0xa4]
   audio.reset(DS=0x1000,BX=threshold);compiled.reset();ae,ah=ports(audio,reads);ce,ch=ports(compiled,reads);calls('pit_delay',audio,[threshold]);assert ae==ce,(config,'pit events',ae,ce)
   for h in ah:audio.u.hook_del(h)
   for h in ch:compiled.u.hook_del(h)
  counts[config]=dict(tally);print(config,'PASS',sum(tally.values()),'isolated ASM/C comparisons',flush=True)
 write_json(HERE/'results/semantics.json',dict(status='PASS',counts=counts,claim='Independent fresh compiler builds, without matching layer. Explicit semantic/ABI projection; not whole-game/drop-in equivalence. PIT tests compare port event order, not physical timing.',domains=dict(scalars='ASCII exhaustive256; guarded fields exhaustive65536 for tc_size, boundary/representative for other builds',memory='all pool start/free pairs; history phases/input/gates; signed clamps/indexwrap; segment-separated and overlapping copies',platform='full Tandy destination memory; AdLib status256; PIT five repeat/exit/signed scripts')))
 return counts

if __name__=='__main__':verify(read_json(OUT/'compiled.json'))
