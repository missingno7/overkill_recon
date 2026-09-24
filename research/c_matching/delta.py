"""Codegen-only experiment: bind C arguments and choose early-return layout.
Input is unmodified Turbo C assembly. This generator NEVER reads oracle bytes.
No operation, arithmetic constant or gameplay store may be inserted by recipes.
"""
import re,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
from build import HERE,OUT,ROOT
from common import read_json,write_json
from dos import dos
from omf import segments

def instructions(source,name):
 body=re.search(r'_'+name+r'\s+proc\s+near(.*?)_'+name+r'\s+endp',source,re.S|re.I).group(1)
 return [re.sub(r'\s+',' ',line.strip()).lower() for line in body.splitlines() if line.strip() and not line.strip().startswith(';')]

def transform(lines,recipe):
 allowed={'split_return_edges','pointers','values'}
 if set(recipe)-allowed:raise ValueError('Unknown matching/ABI key')
 if not isinstance(recipe['split_return_edges'],int) or not 0<=recipe['split_return_edges']<=2:raise ValueError('Invalid return-layout constraint')
 lines=list(lines);assert lines[:2]==['push bp','mov bp,sp'];assert lines[-2:]==['pop bp','ret']
 lines=lines[2:-2]+['ret'];removed=3;rewritten=0;bound=None;out=[]
 for line in lines:
  load=re.fullmatch(r'les bx,dword ptr \[bp\+(\d+)\]',line)
  if load:
   bound=recipe['pointers'][load[1]];removed+=1;continue
  original=line
  if re.search(r'\b(call|push|pop|loop)\b',line) or '[bp-' in line:raise ValueError('Unsupported compiler state/control flow')
  for offset,operand in recipe.get('values',{}).items():
   line=re.sub(r'(?:byte|word) ptr \[bp\+'+offset+r'\]',lambda m:operand,line)
  if '[bp' in line:raise ValueError('Unbound compiler-frame access')
  if 'es:[bx' in line:
   assert bound is not None
   def bind(m):
    displacement=int(m.group(1) or '0')
    if 'base_address' in bound:return 'ds:['+str(bound['base_address']+displacement)+']'
    return '['+bound['register']+(('+'+str(displacement)) if displacement else '')+']'
   line=re.sub(r'es:\[bx(?:\+(\d+))?\]',bind,line)
  if line in ('mov al,al','mov ax,ax'):removed+=1;continue
  rewritten+=line!=original;out.append(line)
 # These are control-layout constraints, not a replacement algorithm. Only
 # selected conditional edges already ending in the common RET are split.
 inverse={'jb':'jae','ja':'jbe','je':'jne','jae':'jb','jne':'je','jbe':'ja'}
 labels={line[:-1]:i for i,line in enumerate(out) if line.endswith(':')};splits=0;result=[]
 for line in out:
  m=re.fullmatch(r'(jb|ja|je|jae|jne|jbe) (@\d+)',line)
  if m and splits<recipe['split_return_edges']:
   tail=[n for n in out[labels[m[2]]+1:] if not n.endswith(':')]
   if tail==['ret']:
    label='delta_continue_'+str(splits);result.extend([inverse[m[1]]+' '+label,'ret',label+':']);splits+=1;continue
  result.append(line)
 assert splits==recipe['split_return_edges']
 # Dead labels carry no semantics. Keep referenced labels and rename assembler locals.
 result=[line for line in result if not line.startswith('@') or any(v.endswith(' '+line[:-1]) for v in result if v!=line)]
 result=[line.replace('@','compiler_label_') for line in result]
 return result,dict(compiler_instructions=sum(not l.endswith(':') for l in lines)+3,removed_instructions=removed,operand_rebound_instructions=rewritten,branch_relayout_sites=splits,output_instructions=sum(not l.endswith(':') for l in result),inserted_ret_instructions=splits,semantic_constants_from_recipe=0)

def generate():
 recipes=read_json(HERE/'matching/recipes.json');abi=read_json(HERE/'abi/bindings.json');source=(OUT/'tc_size/SAMPLE.ASM').read_text();results={}
 for name,recipe in recipes.items():
  if set(recipe)-{'split_return_edges'}:raise ValueError('Recipe may only choose return layout')
  binding=abi[name]; combined=dict(binding,split_return_edges=recipe.get('split_return_edges',0)); lines,metrics=transform(instructions(source,name),combined);folder=OUT/'matching'/name;folder.mkdir(parents=True,exist_ok=True)
  asm="matchcode segment byte public 'CODE'\nassume cs:matchcode,ds:nothing,ss:nothing\n"+'\n'.join(lines)+'\nmatchcode ends\nend\n'
  (folder/'MATCH.ASM').write_text(asm);(folder/'assemble.log').write_text(dos('TASM.EXE',['MATCH.ASM,MATCH.OBJ,MATCH.LST'],folder))
  seg=segments((folder/'MATCH.OBJ').read_bytes());assert len(seg)==1
  (folder/'MATCH.BIN').write_bytes(seg[0][1]);results[name]=dict(metrics,recipe=recipe,abi_binding=binding,generated_asm=asm,bytes=seg[0][1].hex(),match_constraints=recipe.get('split_return_edges',0),abi_binding_constraints=len(binding.get('pointers',{}))+len(binding.get('values',{})),abi_frame_elimination=True)
 write_json(HERE/'results/delta.json',dict(generator_reads_oracle=False,results=results))
 return results

if __name__=='__main__':generate()
