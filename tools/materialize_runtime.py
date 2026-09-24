"""Fresh original execution -> bounded post-initialization runtime artifact.
9690 is a tested candidate frontier, not a proof of stability on every game path.
"""
from common import *
from runtime_machine import Machine
from resources import driver
from extract import extract
import argparse,struct

def ranges(offsets):
    result=[]
    for p in sorted(offsets):
        if result and result[-1]['end']==p:result[-1]['end']+=1
        else:result.append(dict(start=p,end=p+1))
    return result

def code_offsets(analysis):
    return {i for n in analysis['nodes'].values() for i in range(n['linear'],n['linear']+n['size'])}

def artifacts(folder):
    state=read_json(folder/'state.json')
    if 'frontier-9690' not in state['checkpoints']:raise ValueError('Startup never reached candidate frontier')
    image=(folder/'frontier-9690.bin').read_bytes();initial,_=extract();rel=read_json(ROOT/'metadata/relocations.json')['sites'];loaded=bytearray(initial)
    for off in rel:struct.pack_into('<H',loaded,off,(struct.unpack_from('<H',loaded,off)[0]+0x1010)&65535)
    # A main address-space window includes code, mutable data, unknown bytes and the driver slot.
    (folder/'main-runtime.bin').write_bytes(image)
    a=read_json(ROOT/'metadata/analysis.json');offsets=code_offsets(a)
    live=ROOT/'metadata/runtime/main-analysis.json'
    if live.exists():offsets|=code_offsets(read_json(live))
    offsets={p for p in offsets if not 0x10220<=p<0x15340}
    main_ranges=ranges(offsets);projection=b''.join(image[r['start']:r['end']] for r in main_ranges)
    mismatches=[p for p in sorted(offsets) if image[p]!=loaded[p]]
    if mismatches:raise AssertionError('Main executable bytes differ at '+str(mismatches[:20]))
    (folder/'main-executable.bin').write_bytes(projection)
    modules=[];driver_regions=[]
    if state['sound']!='pc':
        name=state['sound'];raw,source=driver(name)
        if len(state['module_loads'])!=1:raise ValueError('Unexpected module load count')
        load=state['module_loads'][0]
        if (folder/load['artifact']).read_bytes()!=raw:raise AssertionError('Original decoder differs from independent resource decoder')
        start=(load['segment']-0x1010)*16+load['offset'];body=image[start:start+len(raw)]
        da=read_json(ROOT/'metadata/drivers'/f'{name}-analysis.json');dc=code_offsets(da)
        if any(raw[p]!=body[p] for p in dc):raise AssertionError('Driver executable mutation before frontier')
        (folder/f'{name}-driver.bin').write_bytes(body);(folder/f'{name}-uninitialized-module.bin').write_bytes(raw)
        driver_regions=ranges(dc)
        modules.append(dict(identity=name,source=source,load=load,initialized_sha256=sha(body),initialized_changes=[dict(offset=i,old=x,new=y) for i,(x,y) in enumerate(zip(raw,body)) if x!=y],relocations='NONE observed: exact independent decoded bytes equal original loaded bytes before initialization',entrypoints=[0,4],code_bytes=len(dc),code_ranges=driver_regions))
    regions=dict(main=dict(base_segment=0x1010,address_space_bytes=len(image),executable_ranges=main_ranges,code_bytes=len(offsets),excluded_driver_reservation=[0x10220,0x15340]),modules=modules,interrupt_vectors=state['vectors'],coverage='Conservative static CFG plus observed instruction seeds; unknown bytes remain unknown. This is not a complete executable-region proof.')
    write_json(folder/'executable-regions.json',regions)
    manifest=dict(schema=1,oracle='B_BOUNDED_POST_INITIALIZATION',frontier='1010:9690',relative_frontier='0000:9690',frontier_status='CANDIDATE_ESMR; global stability not proven',profile=dict(video=state['video'],sound=state['sound'],input='default keyboard'),sequence=state['checkpoints']['frontier-9690']['sequence'],oracle_a_preserved=True,main_executable_changed_bytes=len(mismatches),modules=modules,
        main_address_space_sha256=sha(image),main_executable_sha256=sha(projection),main_executable_bytes=len(projection),inputs=read_json(ROOT/'metadata/inputs.json'),environment=dict(model='bounded DOS/BIOS/PIT/OPL2/MPU synthetic environment; authentic original CPU instructions',load_segment=0x1010,irq_period=state['irq_period'],timing='instruction-callback schedule, not cycle accurate'),
        tooling={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in [ROOT/'tools/runtime_machine.py',ROOT/'tools/resources.py',ROOT/'tools/extract.py']})
    write_json(folder/'manifest.json',manifest);return manifest

def materialize(video='tandy',sound='adlib',out=None,irq_period=20000):
    folder=out or ROOT/'build/runtime-oracle';folder.mkdir(parents=True,exist_ok=True)
    (folder/'manifest.json').unlink(missing_ok=True)
    state=Machine(video,sound,folder,limit=9000000,stop=0x9690,irq_period=irq_period).run()
    if state['reason']!='REQUESTED_FRONTIER':raise RuntimeError(state['reason'])
    from runtime_trace import report
    report(folder,quiet=True)
    return artifacts(folder)
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--video',choices=['cga','ega','tandy'],default='tandy');p.add_argument('--sound',choices=['pc','adlib','roland'],default='adlib');p.add_argument('--input',choices=['keyboard'],default='keyboard');p.add_argument('--out',type=Path);a=p.parse_args()
    print(materialize(a.video,a.sound,a.out)['main_address_space_sha256'])
