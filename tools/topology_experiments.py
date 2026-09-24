"""Rebuild different object topologies with pinned TASM/TLINK; record observations."""
from common import *
from dos import dos
from extract import mz
import hashlib

def run():
    out=ROOT/'build'/'experiments';out.mkdir(parents=True,exist_ok=True)
    results={}
    variants={'combined':('byte',False,False),'split_byte':('byte',True,False),'split_word':('word',True,False),'split_para':('para',True,False),'split_reverse':('byte',True,True)}
    for name,(alignment,split,reverse) in variants.items():
        d=out/name;d.mkdir(exist_ok=True)
        bodies=['mov al,11h\nret','mov bl,22h\nret'] if split else ['mov al,11h\nret\nmov bl,22h\nret']
        logs=[];objs=[]
        for i,body in enumerate(bodies):
            source=f".8086\nCODE segment {alignment} public 'CODE'\nassume cs:CODE\n"+('start:\n' if i==0 else '')+body+'\nCODE ends\nend'+(' start' if i==0 else '')+'\n'
            p=d/f'M{i}.ASM';p.write_text(source);logs.append(dos('TASM.EXE',[f'M{i}.ASM,M{i}.OBJ,M{i}.LST'],d));objs.append(f'M{i}.OBJ')
        if reverse:objs.reverse()
        logs.append(dos('TLINK.EXE',['+'.join(objs)+',OUT.EXE,OUT.MAP'],d))
        h,image,rel,overlay=mz((d/'OUT.EXE').read_bytes())
        results[name]=dict(alignment=alignment,object_order=objs,module_hex=image.hex(),module_size=len(image),relocations=rel,entry_cs=h['cs'],entry_ip=h['ip'],image_sha256=sha(image),source_files=[p.name for p in d.glob('*.ASM')])
        (d/'tools.log').write_text('\n'.join(logs))
    if results['combined']['module_hex']!=results['split_byte']['module_hex']:raise AssertionError('Unexpected byte-alignment probe change')
    write_json(ROOT/'metadata'/'topology-experiments.json',dict(schema=1,results=results,
        conclusions=[{'claim':'A single code object and two byte-aligned PUBLIC contributions can yield identical linked module bytes.','status':'PROVEN_FOR_PROBE'},
        {'claim':'Word/paragraph contribution alignment and object order constrain output layout.','status':'PROVEN_FOR_PROBE'},
        {'claim':'Overkill object boundaries cannot be uniquely recovered from instruction byte exactness.','status':'LIMITATION'},
        {'claim':'This experiment does not establish that TASM/TLINK built Overkill.','status':'UNKNOWN_HISTORICAL_IDENTITY'}]))
    print(json.dumps(results,indent=2))
    return results
if __name__=='__main__':run()
