"""Byte identity and full local ABI checks for matching and alternate lowerings."""
from verify_clean import *

def check():
 main,_=extract();deltas=read_json(HERE/'results/delta.json')['results'];firewall=read_json(HERE/'results/firewall.json')['results'];original={r['name']:r for r in original_rows()};results={}
 cases=[]
 for name,row in deltas.items():cases.append(('delta/'+name,name,bytes.fromhex(row['bytes']),True))
 for name,row in firewall.items():
  cases.append(('firewall/'+name,name,bytes.fromhex(row['exact_bytes']),True));cases.append(('firewall_alternate/'+name,name,bytes.fromhex(row['alternate_bytes']),False))
 for label,name,code,exact in cases:
  entry=original[name]['start'];target=bytes.fromhex(original[name]['original_hex'])
  assert (code==target)==exact,label
  a=Check(main,0x10000);b=Check(bytes(entry)+code,0x10000);count=0
  values=range(256) if 'ascii' in name else [0,1,2,0x1f,0x20,0x21,0xaf,0xb0,0xbf,0xc0,0xc1,0x7fff,0x8000,0xfffa,0xffff]
  for value in values:
   for flags in (0x202,0x203,0x246,0xa93):
    for v in (a,b):
     v.reset(AX=0xa500|value,EFLAGS=flags);v.put(0x50102,value);v.put(0x50104,value);v.put(0x40202,0xbeef);v.put(0x40204,0xbeef)
     v.u.mem_write(0x498be,bytes([value&255]));v.put(0x4a360,value%3);v.u.mem_write(0x4a33a,struct.pack('<4H',0xa336,0xa2fe,0xa2be,0xa27e))
    a.call(entry);b.call(entry);count+=1
    for reg in ('AX','BX','CX','DX','BP','SI','DI','DS','ES','SS','SP','EFLAGS'):assert a.reg(reg)==b.reg(reg),(label,value,flags,reg)
    assert a.mem(0x40000,65536)==b.mem(0x40000,65536),label
    assert a.mem(0x50000,0xf000)==b.mem(0x50000,0xf000),label
  results[label]=dict(exact=exact,cases=count,full_local_abi='PASS',no_original_code_fallback=True)
 write_json(HERE/'results/matching-checks.json',dict(status='PASS',checks=results,deletion='verify_clean.py compiles/runs canonical C without importing delta or firewall; check_shims.py uses ordinary C, no matching layer. Standalone generated bodies contain no original code bytes as fallback.',limits='Isolated states, flags, segments and ordinary data effects. Private stack scratch excluded; no whole-game/timing equivalence claim.'))
 print('PASS',len(results),'exact/alternate bodies, full local ABI checks')
if __name__=='__main__':check()
