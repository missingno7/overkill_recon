"""Explicit one-time optional-driver ASM bootstrap. Never run by normal builds."""
from common import *
from resources import driver
from analyze import analyze
from bootstrap_source import translate,hexh
import argparse

def generate(name,replace=False):
    path=ROOT/'src/drivers'/f'{name.upper()}.ASM'
    if path.exists() and not replace:raise ValueError('Refusing to overwrite maintained driver ASM')
    image,m=driver(name)
    obs_path=ROOT/'metadata/drivers'/f'{name}-observations.json'
    observed=[(0,n['offset'],'original runtime instruction observed') for n in read_json(obs_path)['instruction_observations']] if obs_path.exists() else []
    extra_seeds=[(0,int(r['address'].split(':')[1],16),'reviewed callable byte sequence; original caller may be unknown') for r in read_json(ROOT/'metadata/drivers/symbols.json')['symbols'] if r['module']==name]
    a=analyze(image,dict(entry_cs=0,entry_ip=0,program_sha256=sha(image)),[(0,4,'far initialization entry called by original CA98 dispatcher')]+extra_seeds,ROOT/'metadata/drivers'/f'{name}-analysis.json',quiet=True,observed=observed)
    unique={n['linear']:n for n in a['nodes'].values()};targets={};lines=[];records=[];pos=0
    if a['conflicts']:raise ValueError(a['conflicts'])
    while pos<len(image):
        if pos in unique:
            n=unique[pos];text=translate(n,0,targets);end=pos+n['size'];kind='instruction'
            lines.extend([f'; @{pos:05X} module:{pos:04X} original={n["hex"]}','    '+text])
        else:
            end=pos+1
            while end<len(image) and end not in unique and end-pos<16:end+=1
            text='db '+','.join(hexh(v) for v in image[pos:end]);kind='opaque_unknown'
            lines.extend([f'; @{pos:05X} UNKNOWN module bytes; code/data distinction not yet proven','    '+text])
        records.append(dict(start=pos,end=end,kind=kind,text=text));pos=end
    text=['; Modern optional-module source; historical source filename unknown.','; Original resource: '+m['name']+'; no relocation table in ENC stream.','include ENCODING.INC',"driver segment byte public 'CODE'",'assume cs:driver,ds:nothing,ss:nothing,es:nothing','chunk_base label byte']+[f'{k} equ {hexh(v)}' for k,v in sorted(targets.items())]+lines+['driver ends','end']
    path.parent.mkdir(parents=True,exist_ok=True);path.write_text('\n'.join(text)+'\n')
    write_json(ROOT/'metadata/drivers'/f'{name}-source-map.json',dict(path=path.relative_to(ROOT).as_posix(),resource=m,records=records))
    print(name,len(image),'instruction bytes',sum(n['size'] for n in unique.values()),'functions',len(a['functions']))
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--replace',action='store_true');a=p.parse_args()
    for name in ('adlib','roland'):generate(name,a.replace)
