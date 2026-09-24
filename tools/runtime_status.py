"""Extend baseline reports with explicit initial/runtime/module distinctions."""
from common import *
from collections import Counter
from report import scc_order

def extend_reports():
    coverage_path=ROOT/'metadata/runtime/observed-coverage.json'
    if not coverage_path.exists():return
    coverage=read_json(coverage_path);status=read_json(ROOT/'metadata/status.json')
    old=read_json(ROOT/'metadata/analysis.json');live=read_json(ROOT/'metadata/runtime/main-analysis.json')
    code={p for a in (old,live) for n in a['nodes'].values() for p in range(n['linear'],n['linear']+n['size'])}
    status['initial_cfg_instruction_bytes']=status['decoded_instruction_bytes'];status['decoded_instruction_bytes']=len(code)
    reviewed={r['address']:r for r in read_json(ROOT/'metadata/symbols.json')['symbols']}
    functions=read_json(ROOT/'metadata/runtime/functions.json')
    for f in functions:
        if f['address'] in reviewed:
            r=reviewed[f['address']]
            f.update({k:r[k] for k in ('name','category','contract','confidence','claim_axes','concern','concern_evidence')})
            f['semantic_evidence']=r['evidence'];f['named']=True
    write_json(ROOT/'metadata/runtime/functions.json',functions)
    write_json(ROOT/'metadata/runtime/bottom-up-queue.json',sorted(functions,key=lambda f:(f['call_graph_depth'],len(f['instructions']),f['address'])))
    graph=read_json(ROOT/'metadata/runtime/call-graph.json')
    for n in graph['nodes']:
        if n['address'] in reviewed:n['name']=reviewed[n['address']]['name']
    write_json(ROOT/'metadata/runtime/call-graph.json',graph)
    status['runtime_main']=dict(coverage,named_functions=sum(f['named'] for f in functions),anonymous_functions=sum(not f['named'] for f in functions),categories=dict(Counter(f['category'] for f in functions)))
    modules=[]
    named={ (r['module'],r['address']):r for r in read_json(ROOT/'metadata/drivers/symbols.json')['symbols']}
    for name in ('adlib','roland'):
        a=read_json(ROOT/'metadata/drivers'/f'{name}-analysis.json');mapping=read_json(ROOT/'metadata/drivers'/f'{name}-source-map.json');functions=a['functions'];_,depth=scc_order(functions)
        for f in functions:
            if (name,f['address']) in named:f.update(named[(name,f['address'])]);f['named']=True
            f['module']=name;f['call_graph_depth']=depth[f['address']]
        write_json(ROOT/'metadata/drivers'/f'{name}-functions.json',functions)
        write_json(ROOT/'metadata/drivers'/f'{name}-bottom-up-queue.json',sorted(functions,key=lambda f:(f['call_graph_depth'],len(f['instructions']),f['address'])))
        counts=Counter(f['category'] for f in functions)
        row=dict(module=name,reconstructed_data_bytes=sum(r['end']-r['start'] for r in mapping['records'] if r['kind']=='reconstructed_data'),total_bytes=mapping['resource']['decoded_size'],reconstructed_asm_bytes=sum(r['end']-r['start'] for r in mapping['records'] if r['kind']=='instruction'),opaque_raw_fallback_bytes=sum(r['end']-r['start'] for r in mapping['records'] if r['kind']=='opaque_unknown'),identified_functions=len(functions),named_functions=sum(f['named'] for f in functions),anonymous_functions=sum(not f['named'] for f in functions),leaf_functions=sum(f['leaf'] for f in functions),**{c:counts[c] for c in ('C_READY','C_READY_WITH_ENV','ASM_COUPLED','HARDWARE','STRUCTURAL','UNKNOWN')})
        modules.append(row)
    status['optional_modules']=modules
    def byte_union(functions,nodes):
        return {p for f in functions for k in f['instructions'] for p in range(nodes[k]['linear'],nodes[k]['linear']+nodes[k]['size'])}
    main_functions=read_json(ROOT/'metadata/runtime/functions.json')
    reviewed_main=[f for f in main_functions if f['address'] in reviewed]
    metrics=dict(main_function_candidate_owned_bytes=len(byte_union(main_functions,live['nodes'])),main_reviewed_contract_instruction_bytes=len(byte_union(reviewed_main,live['nodes'])),main_reviewed_contracts=len(reviewed_main),main_reviewed_boundaries=len(reviewed_main),main_boundaries_strong_or_proven=sum(f['confidence']['boundary'] in ('STRONG','PROVEN') for f in reviewed_main),main_reviewed_named_instruction_bytes=len(byte_union(reviewed_main,live['nodes'])),main_unresolved_indirect_sites=len(live['unresolved']),main_reviewed_concerns=dict(Counter(f.get('concern','UNKNOWN') for f in reviewed_main)),ownership_caveat='Function candidate ownership is not proven partitioning; shared tails are counted once. Reviewed-contract bytes count owned instructions, not a transitive claim about unknown callees.')
    metrics['driver_reviewed_contracts']=len(named)
    metrics['driver_boundaries_strong_or_proven']=sum(r['confidence']['boundary'] in ('STRONG','PROVEN') for r in named.values())
    status['semantic_review']=metrics
    write_json(ROOT/'metadata/status.json',status)
    lines=['\n## Active runtime view','',f"The initial-entry inventory above retains {status['identified_functions']} function candidates. The active main runtime graph has **{coverage['main_function_candidates']} candidates**, with **{coverage['additional_main_cfg_instruction_bytes']} additional identified instruction bytes**. This is reachability evidence, not a new main-code variant.",'',f"Maintained main instruction source: **{status['reconstructed_asm_bytes']} bytes**; explicit main UNKNOWN DB: **{status['opaque_raw_fallback_bytes']} bytes**. Initial plus runtime discovery identifies {len(code)} instruction bytes. See metadata/runtime/observed-coverage.json for actual execution coverage.",'','| Module | Total bytes | Instruction ASM | Reviewed data | Opaque bytes | Functions | Named | Leaf |','|---|---:|---:|---:|---:|---:|---:|---:|']
    for r in modules:lines.append(f"| {r['module']} | {r['total_bytes']} | {r['reconstructed_asm_bytes']} | {r['reconstructed_data_bytes']} | {r['opaque_raw_fallback_bytes']} | {r['identified_functions']} | {r['named_functions']} | {r['leaf_functions']} |")
    lines.extend(['','Module totals include data and UNKNOWN bytes; they are separate input artifacts that occupy a versioned slot, not extra simultaneous main-image space. Future-C classes are recorded separately per module in metadata/status.json.',''])
    receipt=ROOT/'build/runtime-verification.json'
    if receipt.exists():lines.extend(['Runtime verifier: **'+read_json(receipt)['status']+'**. This verifies the reproducible candidate 9690 frontier and ASM correspondence, not global stability.',''])
    lines.extend(['Active queues: metadata/runtime/bottom-up-queue.json and metadata/drivers/*-bottom-up-queue.json. Initial/cold inventory is retained for provenance. See [runtime-materialization.md](runtime-materialization.md) for the exact watch scope and untested paths.',''])
    lines.extend(['## Reviewed semantics','',f"Main: {metrics['main_reviewed_contracts']} reviewed contracts/boundaries, {metrics['main_boundaries_strong_or_proven']} boundaries STRONG/PROVEN; {metrics['main_reviewed_contract_instruction_bytes']} unique instruction bytes with reviewed contracts and names. Optional drivers: {metrics['driver_reviewed_contracts']} reviewed contracts.",'',f"Main active graph: {metrics['main_unresolved_indirect_sites']} unresolved indirect sites; {metrics['main_function_candidate_owned_bytes']} instruction bytes assigned to function candidates. Assignment is not a proven partition. Main reviewed concern classes: {metrics['main_reviewed_concerns']}.",'',f"Main reviewed data: {status['reconstructed_data_bytes']} bytes; record-field relationships are documented separately and do not imply every byte in those records is understood.",''])
    p=ROOT/'docs/status.md';text=p.read_text();text=text.split('\n## Active runtime view')[0]
    text=text.replace('| decoded_instruction_bytes | '+str(status['initial_cfg_instruction_bytes'])+' |','| decoded_instruction_bytes | '+str(len(code))+' |')
    p.write_text(text+'\n'.join(lines))
    model=read_json(ROOT/'metadata/project-model.json');model['runtime_module_topology']=dict(evidence='metadata/runtime/materialization.json',main='Oracle A code shared with bounded live runtime',optional_slot='relative 1022:0000 before1534 frame; separate AdLib/Roland identities',modern_driver_source_names=['src/drivers/ADLIB.ASM','src/drivers/ROLAND.ASM'],historically_surviving_resource_names=['ADLIB.ENC','ROLAND.ENC'],confidence='STRUCTURALLY_SUPPORTED executable modules; historical ASM/OMF boundaries UNKNOWN',input='coexisting runtime-state-selected paths',video='coexisting renderer routines selected by data/table dispatch',global_ESMR='UNPROVEN; reproducible candidate at0000:9690')
    model['unresolved']=list(dict.fromkeys(v for v in model['unresolved'] if v not in ('Overlay directory and optional driver extraction','All-path executable stability after candidate ESMR; earliest frontier minimality; physical timing/environment validation')))
    model['research_policy']=dict(method='STATIC_BOTTOM_UP',execution_cap='0000:97B2 first gameplay entry',exhaustive_game_state_coverage_required=False,limits='Global stability and earliest-frontier minimality remain unproven; resolve concrete uncertainties statically first.')
    write_json(ROOT/'metadata/project-model.json',model)
    p=ROOT/'docs/bottom-up.md';text=p.read_text().split('\n## Runtime queue')[0];p.write_text(text+'\n## Runtime queue\n\nThe active main queue is metadata/runtime/bottom-up-queue.json; optional driver queues are metadata/drivers/*-bottom-up-queue.json. Use `python tools/runtime_report.py main 0162` or `python tools/runtime_report.py adlib 0571`. Preserve the initial inventory above as provenance; the driver slot has separate cold/AdLib/Roland identities.\n')

    # Refine the appended-file accounting without claiming every resource's encoding.
    directory_path=ROOT/'metadata/resource-directory.json'
    if directory_path.exists():
        fm=read_json(ROOT/'metadata/file-map.json');directory=read_json(directory_path)
        for f in fm['files']:
            if f['path']!='assets/OVERKILL':continue
            original=f['regions'];base=original[1]['end'];end=original[-1]['end'];rows=original[:2]+[dict(start=base,end=base+12,kind='SHADOW_CONTAINER_HEADER'),dict(start=base+12,end=base+12+26*len(directory),kind='XOR_DIRECTORY_26_BYTE_RECORDS')];cursor=rows[-1]['end']
            for r in sorted(directory,key=lambda r:r['offset']):
                if cursor<r['offset']:rows.append(dict(start=cursor,end=r['offset'],kind='UNKNOWN_CONTAINER_GAP'))
                rows.append(dict(start=r['offset'],end=r['offset']+r['size'],kind='OPTIONAL_EXECUTABLE_ENC' if r['name'] in ('ADLIB.ENC','ROLAND.ENC') else 'ORIGINAL_RESOURCE_ENCODING_NOT_CLASSIFIED_HERE',name=r['name'],sha256=r['sha256']));cursor=r['offset']+r['size']
            if cursor<end:rows.append(dict(start=cursor,end=end,kind='UNKNOWN_CONTAINER_TRAILER'))
            f['regions']=rows
        write_json(ROOT/'metadata/file-map.json',fm)
