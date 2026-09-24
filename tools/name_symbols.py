"""Apply reviewed symbol names without changing layout. Explicit source edit only."""
from common import *
import argparse,re,textwrap

def apply(module,addresses):
    driver=module!='main'
    map_path=ROOT/'metadata/drivers'/f'{module}-source-map.json' if driver else ROOT/'metadata/source-map.json'
    mapping=read_json(map_path);chunks=[mapping] if driver else mapping['chunks']
    symbols=read_json(ROOT/('metadata/drivers/symbols.json' if driver else 'metadata/symbols.json'))['symbols']
    symbols=[s for s in symbols if (not driver or s['module']==module) and s['address'] in addresses]
    if {s['address'] for s in symbols}!=set(addresses):raise ValueError('Every requested address needs reviewed metadata')
    for c in chunks:
        p=ROOT/c['path'];source=p.read_text();definitions=[]
        for s in symbols:
            seg,off=[int(v,16) for v in s['address'].split(':')];linear=seg*16+off
            old=f'loc_{linear:05X}';name=s['name']+f'_{linear:05X}'
            source=re.sub(r'\b'+old+r'\b',name,source)
            for r in c['records']:
                if r['kind']=='instruction':r['text']=re.sub(r'\b'+old+r'\b',name,r['text'])
            if not any(r['start']==linear and r['kind']=='instruction' for r in c['records']):continue
            if not re.search(r'^'+name+r' equ ',source,re.M):definitions.append(name+f' equ 0{linear-(0 if driver else c["start"]):X}h')
            title='; '+s['name']+' (modern reconstruction name)'
            if title not in source:
                comment=title+'\n'+'\n'.join('; '+v for v in textwrap.wrap(s['contract'],110))+'\n; Evidence: '+('metadata/drivers/symbols.json' if driver else 'metadata/symbols.json')+'\n'
                source=source.replace(f'; @{linear:05X} ',comment+f'; @{linear:05X} ',1)
        if definitions:source=source.replace('chunk_base label byte\n','chunk_base label byte\n'+'\n'.join(definitions)+'\n',1)
        p.write_text(source)
    write_json(map_path,mapping)
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('module',choices=['main','adlib','roland']);p.add_argument('addresses',nargs='+');p.add_argument('--apply',action='store_true');a=p.parse_args()
    if not a.apply:raise SystemExit('Explicit --apply required; source and source map are edited.')
    apply(a.module,a.addresses)
