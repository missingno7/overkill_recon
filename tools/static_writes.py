"""Static executable-write inventory. Unresolved aliases remain explicit.
This is an audit of the recovered CFG, not an all-code no-SMC proof.
"""
from common import *
from materialize_runtime import code_offsets
from collections import Counter

def audit():
    result={};lines=['# Static executable-write audit','','This inventory is derived from recovered instruction operands. It runs no game code.','Direct CS targets are compared with identified instructions; other segments and','effective addresses remain unresolved. Disjointness is not proof that unknown bytes','can never execute. Implicit stack effects are counted separately.','']
    for name,path in [('main',ROOT/'metadata/runtime/main-analysis.json')]+[(n,ROOT/'metadata/drivers'/f'{n}-analysis.json') for n in ('adlib','roland')]:
        a=read_json(path);code=code_offsets(a);rows=[];stack=[]
        for k,n in sorted(a['nodes'].items()):
            if n['mnemonic'] in ('push','pushf','pushfd','pusha','pushaw','call','lcall','int'):stack.append(k)
            for op in n['memory']:
                if not op['access']&2:continue
                row=dict(instruction=k,mnemonic=n['mnemonic'],operands=n['operands'],memory=op)
                if op['segment']=='cs' and not op['base'] and not op['index']:
                    positions=[n['segment']*16+((op['displacement']+i)&65535) for i in range(op['size'])]
                    overlap=sorted(set(positions)&code);row.update(kind='DIRECT_CS',target_offsets=positions,identified_instruction_overlap=overlap,classification='OVERLAPS_IDENTIFIED_CODE' if overlap else 'DISJOINT_FROM_IDENTIFIED_CODE')
                else:row.update(kind='UNRESOLVED_ADDRESS_OR_SEGMENT',classification='REQUIRES_LOCAL_ALIAS_OR_CALLER_PROOF')
                rows.append(row)
        counts=Counter(r['kind'] for r in rows);overlap=[r for r in rows if r.get('identified_instruction_overlap')]
        result[name]=dict(instruction_count=len(a['nodes']),explicit_memory_write_operands=len(rows),direct_cs_targets=counts['DIRECT_CS'],unresolved_address_or_segment=counts['UNRESOLVED_ADDRESS_OR_SEGMENT'],overlapping_direct_cs_writes=overlap,implicit_stack_write_sites=stack,writes=rows)
        lines.extend([f'## {name}','',f"Explicit memory-write operands: {len(rows)}; direct CS targets: {counts['DIRECT_CS']}; unresolved address/segment: {counts['UNRESOLVED_ADDRESS_OR_SEGMENT']}; direct CS overlaps with identified code: {len(overlap)}.",''])
        for r in overlap:lines.append(f"- {r['instruction']}: {r['mnemonic']} {r['operands']} — requires review.")
    result['scope']='Recovered CFG only. No whole-program proof; unresolved aliases and implicit stack writes must not be silently classified as safe.'
    write_json(ROOT/'metadata/runtime/static-writes.json',result);(ROOT/'docs/static-writes.md').write_text('\n'.join(lines).rstrip()+'\n')
    print({k:{f:v[f] for f in ('explicit_memory_write_operands','direct_cs_targets','unresolved_address_or_segment')} for k,v in result.items() if isinstance(v,dict)})
    return result
if __name__=='__main__':audit()
