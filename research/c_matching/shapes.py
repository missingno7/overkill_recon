"""Four bounded source-shape/hint probes, generated from canonical clean C."""
from build import *

def variants():
 s=(HERE/'clean/SAMPLE.C').read_text();shaped=s
 for name,lo,hi,op in [('upper_ascii','a','z','& 0xdf'),('lower_ascii','A','Z','| 0x20')]:
  pat=r'u8 '+name+r'\(u8 ch\)\n\{.*?\n\}'
  replacement="u8 "+name+"(u8 ch)\n{\n    if (ch < '"+lo+"') return ch;\n    if (ch > '"+hi+"') return ch;\n    return (u8)(ch "+op+");\n}"
  shaped,n=re.subn(pat,lambda m:replacement,shaped,flags=re.S);assert n==1
 shaped=shaped.replace('for (i=0; i<16; ++i)', 'for (i=16; i!=0; --i)')
 shaped=shaped.replace('    if (r->x != 0) --r->x;\n    if (r->x != 0) --r->x;', '    if (r->x >= 2) r->x -= 2;\n    else r->x = 0;')
 hinted=s.replace('    u16 i;','    register u16 i;').replace('    u16 left;','    register u16 left;').replace('Record far *r)','register Record far *r)')
 manifest=read_json(OUT/'compiled.json')
 for name,key,source in [('tc_shape','tc_size',shaped),('msc_shape','msc_size',shaped),('tc_hints','tc_size',hinted),('msc_hints','msc_size',hinted)]:
  tool,flags=CONFIGS[key];folder=OUT/name;folder.mkdir(parents=True,exist_ok=True)
  for p in (HERE/'clean').iterdir():(folder/p.name).write_bytes((source if p.name=='SAMPLE.C' else p.read_text()).replace('\n','\r\n').encode('ascii'))
  for file in ('SAMPLE.OBJ','CLEAN.EXE','CLEAN.MAP'):(folder/file).unlink(missing_ok=True)
  log=run(tool,flags+(['SAMPLE.C'] if tool=='TCC.EXE' else ['/FaSAMPLE.ASM','SAMPLE.C']),folder);(folder/'compile.log').write_text(log)
  if tool=='TCC.EXE':(folder/'listing.log').write_text(run(tool,[f for f in flags if f!='-c']+['-S','SAMPLE.C'],folder))
  dos('TASM.EXE',['/ml','IO.ASM,IO.OBJ,IO.LST'],folder);image,pubs=link(folder)
  manifest[name]=dict(tool=tool,flags=flags,publics=pubs,image_sha256=sha(image),size=len(image),model='small/near code, explicit far data, cdecl',cpu='8086',source_variant='minor source shape' if name.endswith('shape') else 'register hints',source_sha256=sha(source.encode()),source_diff=''.join(difflib.unified_diff(s.splitlines(True),source.splitlines(True),fromfile='clean/SAMPLE.C',tofile='generated/'+name+'/SAMPLE.C')))
  print(name,len(image),'bytes')
 write_json(OUT/'compiled.json',manifest);compare(manifest)
 return manifest
if __name__=='__main__':variants()
