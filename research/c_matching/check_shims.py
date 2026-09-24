"""Two actual ABI bridges to ordinary compiled C; no matching diff is used."""
from verify_clean import *

def check():
 folder=OUT/'tc_size';shutil.copyfile(HERE/'abi/SHIMS.ASM',folder/'SHIMS.ASM')
 dos('TASM.EXE',['/ml','SHIMS.ASM,SHIMS.OBJ,SHIMS.LST'],folder)
 image,pubs=link(folder,'SHIM','SAMPLE.OBJ+IO.OBJ+SHIMS.OBJ')
 orig,_=extract();a=Check(orig,0x10000);b=Check(image,0x20000);results={}
 for name,entry,values,field in [('upper',0xc7fe,range(256),False),('dec_x',0xa5fc,list(range(260))+[0x7fff,0x8000,0xffff],True)]:
  count=0
  for x in values:
   for flags in (0x202,0x203,0x246,0xa93):
    for v in (a,b):v.reset(AX=0xa500|x if not field else 0x4321,EFLAGS=flags);v.put(0x50104,x)
    a.call(entry);b.call(pubs['shim_'+name]);count+=1
    for reg in ('AX','BX','CX','DX','BP','SI','DI','DS','ES','SS','SP','EFLAGS'):
     assert a.reg(reg)==b.reg(reg),(name,x,flags,reg,a.reg(reg),b.reg(reg))
    assert a.mem(0x50100,56)==b.mem(0x50100,56)
  start=pubs['shim_'+name];end=pubs['shim_dec_x'] if name=='upper' else len(image)
  results[name]=dict(status='PASS',cases=count,shim_bytes=end-start,shim_instructions=len(list(Cs(CS_ARCH_X86,CS_MODE_16).disasm(image[start:end],start))),clean_body_bytes=(pubs['lower_ascii']-pubs['upper_ascii']) if name=='upper' else pubs['inc_x']-pubs['dec_x'],scope='All GP/DS/ES/SS registers, flags, stack balance and record effects; return code address rebased. Private temporary stack cells excluded; valid nonaliasing call stack required.')
 write_json(HERE/'results/abi-shims.json',dict(compiler='tc_size',matching_layer_used=False,results=results))
 print(results)
if __name__=='__main__':check()
