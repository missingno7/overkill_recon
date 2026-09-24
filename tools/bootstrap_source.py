"""One-time source bootstrap; NEVER run implicitly during a normal build.
Unknown bytes are explicit DB bootstrap material, not reconstructed instructions.
"""
from common import *
from extract import extract
import re

CHUNK=8192
SYMBOL_NAMES={}
JCC={'jo':0x70,'jno':0x71,'jb':0x72,'jae':0x73,'je':0x74,'jne':0x75,'jbe':0x76,'ja':0x77,'js':0x78,'jns':0x79,'jp':0x7a,'jnp':0x7b,'jl':0x7c,'jge':0x7d,'jle':0x7e,'jg':0x7f,'loopne':0xe0,'loope':0xe1,'loop':0xe2,'jcxz':0xe3}

def hexh(n):return f'0{n&0xffff:X}h'
def macros():
    lines=['; Modern encoding controls, not claimed historical macros.','.8086']
    for name,op,width in [('CALL_NEAR',0xe8,2),('JMP_NEAR',0xe9,2),('JMP_SHORT',0xeb,1)]+[(k.upper()+'_SHORT',v,1) for k,v in JCC.items()]:
        lines += [f'{name} macro target',f' db {hexh(op)}',f' {"dw" if width==2 else "db"} (target-($-chunk_base)-{width}) AND {"0ffffh" if width==2 else "0ffh"}','endm']
    for name,op in [('CALL_FAR',0x9a),('JMP_FAR',0xea)]:lines += [f'{name} macro segval,offval',f' db {hexh(op)}',' dw offval,segval','endm']
    return '\n'.join(lines)+'\n'

def translate(n,start,targets):
    mn=n['mnemonic']; ops=n['operands']; b=bytes.fromhex(n['hex'])
    if not n['unresolved'] and (n['calls'] or (n['successors'] and (mn.startswith('j') or mn.startswith('loop')))):
        dest=(n['calls'] or n['successors'])[0]
        cs,ip=[int(x,16) for x in dest.split(':')]
        if mn in ('lcall','ljmp'): return f'{"CALL" if mn=="lcall" else "JMP"}_FAR {hexh(cs)},{hexh(ip)}'
        symbol=SYMBOL_NAMES.get(cs*16+ip,'loc_'+f'{cs*16+ip:05X}');targets[symbol]=(cs*16+ip-start)&65535
        if mn=='call':return f'CALL_NEAR {symbol}'
        if mn=='jmp':return f'JMP_{"SHORT" if b[0]==0xeb else "NEAR"} {symbol}'
        return f'{mn.upper()}_SHORT {symbol}'
    if mn in ('lcall','ljmp'):
        mn='call' if mn=='lcall' else 'jmp'; ops='dword ptr '+ops.replace('ptr ','').replace('dword ','')
    if mn in ('test','xchg') and re.fullmatch(r'(?:[abcd][hlx]|[sd]i|[bs]p), (?:[abcd][hlx]|[sd]i|[bs]p)',ops):ops=', '.join(reversed(ops.split(', ')))
    if mn in ('lds','les'):ops=ops.replace('ptr ','dword ptr ')
    # TASM accepts explicit segment names on numeric memory operands.
    ops=re.sub(r'0x([0-9a-f]+)',lambda m:hexh(int(m[1],16)),ops)
    ops=re.sub(r'(?<!:)\[', 'ds:[',ops)
    # BP effective addresses default to SS. Do not insert a DS override there.
    ops=re.sub(r'ds:\[([^]]*\bbp\b[^]]*)\]',r'ss:[\1]',ops) if 'cs:' not in n['operands'] and 'es:' not in n['operands'] and 'ds:' not in n['operands'] else ops
    if mn.split()[-1] in ('movsb','movsw','stosb','stosw','lodsb','lodsw','scasb','scasw','cmpsb','cmpsw'):
        prefix=[]
        for byte in b:
            if byte in (0x26,0x2e,0x36,0x3e):prefix.append(f'db {hexh(byte)} ; decoded segment override')
            elif byte not in (0xf2,0xf3):break
        return '\n    '.join(prefix+[mn])
    if mn in ('rcl','rcr','rol','ror','shl','shr','sar') and ',' not in ops: ops+=',1'
    if mn=='retf':mn='retf'
    if mn=='xlatb':
        return '\n    '.join([f'db {hexh(v)} ; decoded segment override' for v in b[:-1]]+['xlat'])
    if mn=='sal':mn='shl'
    return mn+(' '+ops if ops else '')

def generate():
    image,m=extract(); a=read_json(ROOT/'metadata/analysis.json')
    reviewed={v['address']:v for v in read_json(ROOT/'metadata/symbols.json')['symbols']}
    for v in reviewed.values():
        cs,ip=[int(n,16) for n in v['address'].split(':')];SYMBOL_NAMES[cs*16+ip]=v['name']+'_'+f'{cs*16+ip:05X}'
    unique={}
    for n in a['nodes'].values():unique.setdefault(n['linear'],n)
    (ROOT/'include/ENCODING.INC').write_text(macros())
    entries={int(f['address'][:4],16)*16+int(f['address'][5:],16):f for f in a['functions']}
    manifest=[];fallbacks=[]
    boundaries=[0]+list(range(CHUNK,len(image),CHUNK))+[len(image)]
    for i in range(1,len(boundaries)-1):
        for off in range(boundaries[i]-14,boundaries[i]):
            if off in unique and off+unique[off]['size']>boundaries[i]:boundaries[i]=off;break
    for chunk_id,(start,end) in enumerate(zip(boundaries,boundaries[1:])):
        target={}; lines=[]; records=[];p=start
        while p<end:
            if p in unique and p+unique[p]['size']<=end:
                n=unique[p];t=translate(n,start,target)
                if p in entries:
                    f=entries[p];v=reviewed.get(f['address']);lines.append('; '+(v['name'] if v else f['name']))
                    if v:
                        lines.extend('; '+line for line in __import__('textwrap').wrap(v['contract'],90))
                        lines.append('; Modern semantic name; see metadata/symbols.json for confidence and evidence.')
                lines += [f'; @{p:05X} {n["address"]} original={n["hex"]}', '    '+t]
                records.append(dict(start=p,end=p+n['size'],kind='instruction',text=t,address=n['address']))
                p+=n['size']
            else:
                q=p+1
                while q<end and q not in unique and q-p<16:q+=1
                lines += [f'; @{p:05X} UNKNOWN bootstrap bytes: not reconstructed code/data', '    db '+','.join(hexh(v) for v in image[p:q])]
                records.append(dict(start=p,end=q,kind='opaque_unknown'))
                p=q
        defs=[f'{symbol} equ {hexh(value)}' for symbol,value in sorted(target.items())]
        name=f'R{chunk_id:02}.ASM';seg=f'part{chunk_id:02}'
        text=['; Modern physical chunk, NOT an inferred original object boundary.','include ENCODING.INC',f'{seg} segment byte public \'CODE\'',f'assume cs:{seg},ds:nothing,ss:nothing,es:nothing']+['chunk_base label byte']+defs+lines+[f'{seg} ends','end']
        (ROOT/'src'/name).write_text('\n'.join(text)+'\n')
        manifest.append(dict(path='src/'+name,start=start,end=end,records=records))
    write_json(ROOT/'metadata/source-map.json',dict(schema=1,image_sha256=m['program_sha256'],chunks=manifest))
    write_json(ROOT/'metadata/relocations.json',dict(schema=1,sites=m['relocations'],entry_cs=m['entry_cs'],entry_ip=m['entry_ip']))
    print('Generated',len(manifest),'explicit ASM chunks; ordinary build does not regenerate them.')
if __name__=='__main__':
    if any((ROOT/'src').glob('*.ASM')) and '--replace-bootstrap' not in sys.argv:
        raise SystemExit('Refusing to overwrite maintained ASM. Explicit --replace-bootstrap is required; review all resulting changes.')
    generate()
