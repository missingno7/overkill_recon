"""Explicitly promote proven unchanged runtime instruction spans in existing DB ranges.
Existing maintained instruction text, labels and semantic comments are preserved.
"""
from common import *
from bootstrap_source import translate,hexh
from extract import extract
import argparse,re

def promote(driver_name=None):
    if driver_name:
        from resources import driver
        image,_=driver(driver_name);map_path=ROOT/'metadata/drivers'/f'{driver_name}-source-map.json';driver_map=read_json(map_path)
        mapping=dict(chunks=[dict(driver_map,start=0,end=len(image))]);a=read_json(ROOT/'metadata/drivers'/f'{driver_name}-analysis.json')
    else:
        image,_=extract();map_path=ROOT/'metadata/source-map.json';mapping=read_json(map_path);a=read_json(ROOT/'metadata/runtime/main-analysis.json')
    nodes={n['linear']:n for n in a['nodes'].values()};total=0
    for chunk in mapping['chunks']:
        path=ROOT/chunk['path'];source=path.read_text();old=chunk['records'];new=[];edits=[];targets={};i=0
        while i<len(old):
            row=old[i]
            if row['kind']!='opaque_unknown':new.append(row);i+=1;continue
            j=i+1
            while j<len(old) and old[j]['kind']=='opaque_unknown':j+=1
            lo=old[i]['start'];hi=old[j-1]['end'];pos=lo;records=[];lines=[];added=0
            while pos<hi:
                if pos in nodes and pos+nodes[pos]['size']<=hi:
                    n=nodes[pos];end=pos+n['size'];text=translate(n,chunk['start'],targets)
                    if bytes.fromhex(n['hex'])!=image[pos:end]:raise ValueError('Runtime instruction is not Oracle A code')
                    records.append(dict(start=pos,end=end,kind='instruction',text=text,address=n['address'],provenance=('independently decoded driver instruction; metadata/drivers/'+driver_name+'-analysis.json' if driver_name else 'unchanged runtime instruction; metadata/runtime/main-analysis.json')))
                    lines.extend([f'; @{pos:05X} {n["address"]} original={n["hex"]} runtime CFG evidence','    '+text]);added+=end-pos
                else:
                    end=pos+1
                    while end<hi and end not in nodes and end-pos<16:end+=1
                    records.append(dict(start=pos,end=end,kind='opaque_unknown',text='db '+','.join(hexh(v) for v in image[pos:end])))
                    lines.extend([f'; @{pos:05X} UNKNOWN bootstrap bytes: not reconstructed code/data','    db '+','.join(hexh(v) for v in image[pos:end])])
                pos=end
            if added:
                start=source.index(f'; @{lo:05X} ');last=source.index(f'; @{old[j-1]["start"]:05X} ');finish=source.index('\n',source.index('\n',last)+1)+1
                edits.append((start,finish,'\n'.join(lines)+'\n'));new.extend(records);total+=added
            else:new.extend(old[i:j])
            i=j
        if edits:
            for start,finish,text in reversed(edits):source=source[:start]+text+source[finish:]
            extra=[]
            for name,value in sorted(targets.items()):
                existing=re.search(r'^'+re.escape(name)+r' equ (\S+)$',source,re.M)
                if existing:
                    if existing[1].lower()!=hexh(value).lower():raise ValueError('Conflicting existing label')
                else:extra.append(f'{name} equ {hexh(value)}')
            source=source.replace('chunk_base label byte\n','chunk_base label byte\n'+'\n'.join(extra)+'\n',1)
            path.write_text(source);chunk['records']=new
    if driver_name:driver_map['records']=mapping['chunks'][0]['records'];write_json(map_path,driver_map)
    else:write_json(map_path,mapping)
    print('Promoted',total,'bytes from explicit UNKNOWN DB to exact instruction source; existing instructions preserved.')
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--apply',action='store_true');p.add_argument('--driver',choices=['adlib','roland']);a=p.parse_args()
    if not a.apply:raise SystemExit('Explicit --apply required; this edits maintained source.')
    promote(a.driver)
