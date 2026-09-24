"""Narrow semantic firewall for two real C functions, not a general compiler.
C owns field names, order, arithmetic and conditions. Recipes cannot replace IR.
Unsupported C or unknown recipe keys fail closed. ABI locations are separate.
"""
from dataclasses import dataclass
import re,sys
from pathlib import Path
sys.path.insert(0,str(Path(__file__).resolve().parent))
from build import HERE,OUT,ROOT
from common import read_json,write_json,sha
from dos import dos
from omf import segments

@dataclass(frozen=True)
class CopyAdd:
 destination_field: str
 source_field: str
 constant: int

@dataclass(frozen=True)
class GuardedDecrement:
 field: str


def parse_c(source,name):
 body=re.search(r'void '+name+r'\([^)]*\)\s*\{(.*?)\n\}',source,re.S)
 if not body:raise ValueError('Unsupported function')
 text=body.group(1).strip()
 if name=='copy_position':
  statements=[v.strip() for v in text.split(';') if v.strip()];ops=[]
  for stmt in statements:
   m=re.fullmatch(r'dst->(\w+)\s*=\s*\(u16\)\(src->(\w+)\s*\+\s*(\d+)\)',stmt)
   if not m:raise ValueError('Unsupported C copy statement')
   ops.append(CopyAdd(m[1],m[2],int(m[3])))
  if len(ops)!=2:raise ValueError('Prototype only supports two ordered copy-add stores')
  return tuple(ops)
 if name=='dec_x':
  m=re.fullmatch(r'if \(r->(\w+) != 0\) --r->\1;',text)
  if not m:raise ValueError('Unsupported C guard/decrement')
  return (GuardedDecrement(m[1]),)
 raise ValueError('Prototype function not supported')


def field_offsets():
 # The field order comes from the canonical C declaration, not match recipes.
 header=(HERE/'clean/TYPES.H').read_text()
 names=re.search(r'typedef struct \{ u16 ([\w, ]+); u8 other\[\d+\]; \} Record;',header).group(1)
 return {name.strip():i*2 for i,name in enumerate(names.split(','))}


def lower(ir,recipe,abi,*,backend_test_register=None):
 fields=field_offsets();ops=[]
 if all(isinstance(op,CopyAdd) for op in ir):
  if recipe:raise ValueError('Copy body needs no matching primitive')
  reg=backend_test_register or 'ax'
  if reg not in ('ax','dx'):raise ValueError('Only non-address temporary registers allowed')
  # Original contract: src SS:BP, dst DS:BX, AX last stored result; other GPRs preserved.
  if abi!={'source':'ss:bp','destination':'ds:bx','result':'ax_last_stored'}:raise ValueError('Unreviewed ABI')
  if reg!='ax':ops.append('push '+reg)
  for op in ir:
   ops += [f'mov {reg},word ptr [bp+{fields[op.source_field]}]',f'add {reg},{op.constant}',f'mov word ptr [bx+{fields[op.destination_field]}],{reg}']
  if reg!='ax':ops+=['mov ax,'+reg,'pop '+reg]
  ops+=['ret']
 elif len(ir)==1 and isinstance(ir[0],GuardedDecrement):
  if set(recipe)-{'conditional_return'}:raise ValueError('Forbidden matching capability')
  layout=recipe.get('conditional_return','joined')
  if layout not in ('joined','split'):raise ValueError('Unknown equivalent lowering')
  if abi!={'record':'ss:bp','flags':'cmp_then_optional_dec','registers':'preserve'}:raise ValueError('Unreviewed ABI')
  field=fields[ir[0].field];ops=[f'cmp word ptr [bp+{field}],0']
  if layout=='split':ops+=['jne decrement','ret','decrement:',f'dec word ptr [bp+{field}]','ret']
  else:ops+=['je done',f'dec word ptr [bp+{field}]','done:','ret']
 else:raise ValueError('Unsupported semantic IR')
 return ops


def assemble(name,ops):
 folder=OUT/'firewall'/name;folder.mkdir(parents=True,exist_ok=True)
 asm="fw segment byte public 'CODE'\nassume cs:fw,ds:nothing,ss:nothing\n"+'\n'.join(ops)+'\nfw ends\nend\n'
 (folder/'FW.ASM').write_text(asm);dos('TASM.EXE',['FW.ASM,FW.OBJ,FW.LST'],folder)
 seg=segments((folder/'FW.OBJ').read_bytes());assert len(seg)==1
 (folder/'FW.BIN').write_bytes(seg[0][1]);return seg[0][1],asm


def test():
 from build import original_rows
 source=(HERE/'clean/SAMPLE.C').read_text();original={r['name']:bytes.fromhex(r['original_hex']) for r in original_rows()}
 abi=read_json(HERE/'abi/firewall.json');recipes=read_json(HERE/'matching/firewall.json');results={}
 forbidden=[{'temporary_register':'bx'},{'override_constant':11},{'emit_asm':'xor ax,ax'},{'remove_store':True},{'change_field':'y'},{'loop_bound':4},{'invert_condition':True},{'gameplay_call':'x'}]
 for name in ('copy_position','dec_x'):
  ir=parse_c(source,name);data,asm=assemble(name,lower(ir,recipes[name],abi[name]));assert data==original[name]
  rejected=0
  for bad in forbidden:
   try:lower(ir,dict(recipes[name],**bad),abi[name])
   except ValueError:rejected+=1
   else:raise AssertionError('Semantic mutation accepted')
  # Exercise another allowed realization: semantics remain, exact bytes may change.
  alt={} if name=='copy_position' else {'conditional_return':'joined'}
  alternate,altasm=assemble(name+'_alternate',lower(ir,alt,abi[name],backend_test_register='dx' if name=='copy_position' else None));assert alternate!=data
  results[name]=dict(status='EXACT',ir=[dict(operation=type(op).__name__,**op.__dict__) for op in ir],constraints=recipes[name],abi_contract=abi[name],rejected_mutation_recipes=rejected,generated_asm=asm,alternate_asm=altasm,exact_bytes=data.hex(),alternate_bytes=alternate.hex(),original_bytes=len(data),match_constraint_count=len(recipes[name]),abi_constraint_count=len(abi[name]),source_sha256=sha(source.encode()))
 # Changing C changes its IR/lowering; recipe cannot covertly restore old arithmetic.
 mutant=source.replace('src->x + 10','src->x + 11')
 changed,_=assemble('copy_mutated_c',lower(parse_c(mutant,'copy_position'),recipes['copy_position'],abi['copy_position']))
 assert changed!=original['copy_position']
 write_json(HERE/'results/firewall.json',dict(status='PASS',scope='Two whitelisted C forms only; independently tested C is canonical. This is not a general C parser, optimizer, or proof for other expressions.',results=results,canonical_constant_mutation_propagates=True))
 return results
if __name__=='__main__':test()
