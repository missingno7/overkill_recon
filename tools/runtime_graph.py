"""Extend the semantic CFG with independently observed runtime entry/flow evidence.
No source regeneration. Initial analysis remains a distinct artifact.
"""
from common import *
from analyze import analyze
from extract import extract
from materialize_runtime import code_offsets
from report import scc_order
import argparse,struct

def generate(folders):
    image,m=extract();loaded=bytearray(image)
    for off in m['relocations']:struct.pack_into('<H',loaded,off,(struct.unpack_from('<H',loaded,off)[0]+0x1010)&65535)
    seeds=set();observed=set();versions=[];runs=[];executed=set()
    for folder in folders:
        s=read_json(folder/'state.json');runs.append(dict(path=str(folder.relative_to(ROOT)),profile=s['video']+'-'+s['sound'],steps=s['sequence'],reason=s['reason'],state_sha256=sha((folder/'state.json').read_bytes()),frontiers=list(s['checkpoints'])))
        for k,node in s['visited'].items():
            cs,ip=[int(v,16) for v in k.split(':')];cs-=0x1010;start=cs*16+ip
            if not 0<=start<len(image) or 0x10220<=start<0x15340:continue
            if node.get('versions'):versions.append(dict(address=k,phase='multiple observed runtime identities',versions=node['versions']))
            if bytes.fromhex(node['hex'])!=loaded[start:start+node['size']]:
                versions.append(dict(address=k,phase='observed runtime',hex=node['hex'],oracle_a_hex=loaded[start:start+node['size']].hex()));continue
            observed.add((cs,ip,'original execution observed instruction'));executed.update(range(start,start+node['size']))
        for v in s['vectors']:
            cs,ip=[int(x,16) for x in v['handler'].split(':')];cs-=0x1010
            if 0<=cs*16+ip<len(image):seeds.add((cs,ip,'original execution installed interrupt '+hex(v['vector'])))
    out=ROOT/'metadata/runtime';out.mkdir(parents=True,exist_ok=True)
    a=analyze(image,m,sorted(seeds),out/'main-analysis.json',excluded=[(0x10220,0x15340)],quiet=True,observed=sorted(observed))
    old=read_json(ROOT/'metadata/analysis.json');newbytes=code_offsets(a)-code_offsets(old)
    assembled={p for c in read_json(ROOT/'metadata/source-map.json')['chunks'] for r in c['records'] if r['kind']=='instruction' for p in range(r['start'],r['end'])}
    groups,depth=scc_order(a['functions']);names={s['address']:s for s in read_json(ROOT/'metadata/symbols.json')['symbols']}
    for f in a['functions']:
        f['call_graph_depth']=depth[f['address']]
        if f['address'] in names:
            r=names[f['address']];f.update({k:r[k] for k in ('name','category','contract','confidence','claim_axes')});f['named']=True
    write_json(out/'functions.json',a['functions']);write_json(out/'bottom-up-queue.json',sorted(a['functions'],key=lambda f:(f['call_graph_depth'],len(f['instructions']),f['address'])))
    write_json(out/'call-graph.json',dict(nodes=[dict(address=f['address'],name=f['name'],depth=depth[f['address']]) for f in a['functions']],edges=[dict(caller=f['address'],callee=c,kind=kind) for f in a['functions'] for kind,values in [('call',f['callees']),('tail',f['tail_targets'])] for c in values],external_driver_entrypoints=['1022:0000','1022:0004'],strongly_connected_components=groups))
    write_json(out/'observed-coverage.json',dict(runs=runs,observed_main_instruction_bytes=len(executed),main_cfg_instruction_bytes=len(code_offsets(a)),additional_main_cfg_instruction_bytes=len(newbytes),main_function_candidates=len(a['functions']),initial_function_candidates=len(old['functions']),conflicts=a['conflicts'],unmatched_runtime_instruction_versions=versions,newly_discovered_main_bytes_are_assembled=not bool(newbytes-assembled),newly_discovered_main_bytes_remaining_opaque=len(newbytes-assembled),source_priority='Use runtime graph for bottom-up work; preserve reviewed source. Exact source-map accounting independently tracks instruction versus opaque representation.'))
    write_json(out/'xrefs.json',dict(memory=[dict(instruction=k,**v) for k,n in a['nodes'].items() for v in n['memory']],unresolved_transfers=a['unresolved'],tables=a['tables'],vectors=a['vectors']))
    print('Runtime graph:',len(a['functions']),'functions;',len(newbytes),'additional main code bytes;',len(versions),'unmatched versions;',len(a['conflicts']),'conflicts')
    return a
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('folders',nargs='+',type=Path);a=p.parse_args();generate([f.resolve() for f in a.folders])
