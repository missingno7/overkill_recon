"""Generate inventory, call graph, bottom-up queue, evidence and readable reports."""
from common import *
from collections import Counter,defaultdict
from extract import extract
import html,re,struct

def scc_order(functions):
    edges={f['address']:sorted(set(f['callees']+f['tail_targets'])) for f in functions}
    index={};low={};stack=[];on=set();groups=[]
    def visit(v):
        index[v]=low[v]=len(index);stack.append(v);on.add(v)
        for w in edges[v]:
            if w not in edges:continue
            if w not in index:visit(w);low[v]=min(low[v],low[w])
            elif w in on:low[v]=min(low[v],index[w])
        if low[v]==index[v]:
            group=[]
            while True:
                w=stack.pop();on.remove(w);group.append(w)
                if w==v:break
            groups.append(sorted(group))
    for v in edges:
        if v not in index:visit(v)
    owner={v:i for i,g in enumerate(groups) for v in g};depth={}
    def rank(i):
        if i not in depth:depth[i]=max([rank(owner[w])+1 for v in groups[i] for w in edges[v] if w in owner and owner[w]!=i] or [0])
        return depth[i]
    for i,g in enumerate(groups):rank(i)
    return groups,{v:depth[owner[v]] for v in edges}

def generate():
    a=read_json(ROOT/'metadata/analysis.json');reviewed={s['address']:s for s in read_json(ROOT/'metadata/symbols.json')['symbols']};receipt=read_json(ROOT/'build/verification.json')
    functions=a['functions']; nodes=a['nodes'];image,m=extract()
    for f in functions:
        if f['address'] in reviewed:
            r=reviewed[f['address']];f.update({k:r[k] for k in ('name','category','contract','confidence','claim_axes','concern','concern_evidence')});f['semantic_evidence']=r['evidence'];f['named']=True
    groups,depth=scc_order(functions)
    for f in functions:f['call_graph_depth']=depth[f['address']]
    write_json(ROOT/'metadata/functions.json',functions)
    write_json(ROOT/'metadata/call-graph.json',dict(nodes=[dict(address=f['address'],name=f['name'],depth=f['call_graph_depth']) for f in functions],edges=[dict(caller=f['address'],callee=c,kind=kind) for f in functions for kind,values in [('call',f['callees']),('tail',f['tail_targets'])] for c in values],strongly_connected_components=groups,limitation='Indirect transfers retain unresolved status even when supported candidates are followed. Depth is over known SCC edges, not proof of a complete call graph.'))
    write_json(ROOT/'metadata/regions.json',dict(image_bytes=len(image),regions=a['regions'],strings=a['strings'],tables=a['tables'],interrupt_vectors=a['vectors'],uninitialized_state='UNKNOWN; do not label unpacker workspace or zero-filled initialized bytes BSS.'))
    categories=Counter(f['category'] for f in functions);counts=receipt.get('source_bytes',{})
    status=dict(schema=1,original_container_bytes=m['mz']['executable_bytes']+m['mz']['appended_bytes'],original_executable_bytes_accounted=m['mz']['executable_bytes'],
        original_appended_bytes_accounted=m['mz']['appended_bytes'],program_image_bytes_accounted=len(image),accounting_means='Complete address/range coverage, including UNKNOWN; not semantic recovery.',
        decoded_instruction_bytes=sum(r['end']-r['start'] for r in a['regions'] if r['kind']=='reachable_instruction'),
        reconstructed_data_bytes=counts.get('reconstructed_data',0),reconstructed_asm_bytes=counts.get('instruction',0),opaque_raw_fallback_bytes=counts.get('opaque_unknown',0),
        identified_functions=len(functions),function_boundary_caveat='Candidates from entry, direct calls, dispatch pointers and verified vector installation; shared tails and aliases are explicit.',
        named_functions=sum(f['named'] for f in functions),anonymous_functions=sum(not f['named'] for f in functions),leaf_functions=sum(f['leaf'] for f in functions),
        **{c:categories[c] for c in ['C_READY','C_READY_WITH_ENV','ASM_COUPLED','HARDWARE','STRUCTURAL','UNKNOWN']},
        semantically_supported_unique_instruction_bytes=len({p for f in functions if f['named'] for k in f['instructions'] for p in range(nodes[k]['linear'],nodes[k]['linear']+nodes[k]['size'])}),
        build_status=receipt['status'],binary_match_status='BYTE_EXACT_NORMALIZED_PROGRAM_IMAGE' if receipt.get('match') else 'FAIL',whole_file_match='NOT_BUILT',known_mismatching_ranges=receipt.get('mismatching_ranges',[]),
        unresolved_indirect_sites=len(a['unresolved']),decode_conflicts=len(a['conflicts']),historical_module_boundaries_proven=0)
    write_json(ROOT/'metadata/status.json',status)
    lines=['# Reconstruction status','', 'This is an exact, incomplete ASM bootstrap. Byte coverage and semantic understanding are separate.','', '| Metric | Value |','|---|---:|']
    for key in ['program_image_bytes_accounted','decoded_instruction_bytes','reconstructed_asm_bytes','reconstructed_data_bytes','opaque_raw_fallback_bytes','identified_functions','named_functions','anonymous_functions','leaf_functions','C_READY','C_READY_WITH_ENV','ASM_COUPLED','HARDWARE','STRUCTURAL','UNKNOWN','semantically_supported_unique_instruction_bytes','unresolved_indirect_sites','decode_conflicts']:
        lines.append('| '+key+' | '+str(status[key])+' |')
    lines+=['',f"Build: **{status['build_status']}**. Normalized program image: **{status['binary_match_status']}**.",'Known mismatching ranges: '+str(status['known_mismatching_ranges'])+'. Packed original file: **not rebuilt**.','',
        'Every one of the 143,088 initialized image bytes has a source-map owner. UNKNOWN ranges use visible DB declarations and count as opaque. The instruction denominator for the whole game is not yet known. No 100% code-recovery claim is made.','',
        'Function entries and boundaries remain candidates unless the symbol evidence says otherwise. A static leaf can still depend on machine flags, asynchronous writes, shared memory or unobserved indirect control flow. C_READY does not mean C source has been produced.','',
        'Recreate this report with `python tools/verify.py`. Full independent unpack, toolchain experiments and semantic checks: `python tools/verify.py --full`.','',
        'Next: resolve remaining indirect tables with bounded-index evidence; recover keyboard/vector callbacks; account for runtime-written code; promote exact data extents and prove more leaf contracts. Whole-file repacking remains a separate unmet milestone.']
    (ROOT/'docs/status.md').write_text('\n'.join(lines)+'\n')
    listing=['# Bottom-up function queue','','Depth is the longest known path in the SCC-condensed call graph. Unknown edges remain explicit.','', '| Address | Name | Depth | Bytes | Class | Leaf | Unresolved |','|---|---|---:|---:|---|---|---:|']
    for f in sorted(functions,key=lambda f:(f['call_graph_depth'],not f['leaf'],f['instruction_bytes'],f['address'])):
        listing.append(f"| {f['address']} | {f['name']} | {f['call_graph_depth']} | {f['instruction_bytes']} | {f['category']} | {f['leaf']} | {len(f['unresolved'])} |")
    (ROOT/'docs/bottom-up.md').write_text('\n'.join(listing)+'\n')
    detail=['# Reviewed symbols','','All names below are modern reconstruction names. Original symbol spellings are unknown.']
    for f in functions:
        if not f['named']:continue
        detail += ['',f"## {f['name']} ({f['address']})",'',f['contract'],'',f"Future C class: `{f['category']}`. Confidence: `{json.dumps(f['confidence'],sort_keys=True)}`.",'','Callers: '+', '.join(f['callers'])+'.','Callees: '+', '.join(f['callees'])+'.','Register access inventory (decoder-derived, not a proven ABI): read '+', '.join(f['registers_read'])+'; write '+', '.join(f['registers_written'])+'.','','Evidence:']+['- '+v for v in f['semantic_evidence']]
    (ROOT/'docs/symbols.md').write_text('\n'.join(detail)+'\n')
    # Static xrefs retain segment/base/index distinctions, especially SS:[BP].
    xrefs=[];writes=[]
    for k,n in nodes.items():
        for mem in n['memory']:
            xrefs.append(dict(instruction=k,**mem))
            if mem['segment']=='cs' and not mem['base'] and not mem['index'] and mem['access']&2:
                site=n['segment']*16+(mem['displacement']&65535)
                writes.append(dict(instruction=k,linear=site,size=mem['size'],overlaps_decoded_code=any(v['linear']<=site<v['linear']+v['size'] for v in nodes.values())))
    write_json(ROOT/'metadata/xrefs.json',dict(memory=xrefs,cs_writes=writes,interrupts=[dict(address=k,operand=n['operands']) for k,n in nodes.items() if n['mnemonic']=='int'],ports=[dict(address=k,mnemonic=n['mnemonic'],operands=n['operands']) for k,n in nodes.items() if n['mnemonic'] in ('in','out')]))
    # Code frames are observed CS values, not claims about original SEGDEF ownership.
    frames=[]
    for cs in sorted({n['segment'] for n in nodes.values()}):
        ns=[n for n in nodes.values() if n['segment']==cs]
        frames.append(dict(relative_segment=cs,linear_base=cs*16,min_reached_offset=min(n['offset'] for n in ns),max_reached_end=max(n['offset']+n['size'] for n in ns),status='OBSERVED_ADDRESS_FRAME_NOT_OBJECT_BOUNDARY'))
    reloc_targets=Counter(struct.unpack_from('<H',image,p)[0] for p in m['relocations'])
    field_counts=Counter((mem['segment'],mem['base'],mem['displacement']) for n in nodes.values() for mem in n['memory'] if mem['base'] and not mem['index'] and 0<=mem['displacement']<=64)
    patterns=dict(selector_dispatch=dict(sites=[t['site'] for t in a['tables']],count=len(a['tables']),pattern='MOV BX,CS:[95BC]; SHL BX,1; indirect CS:[BX+table]',claim='Recurring idiom PROVEN; shared historical macro SPECULATIVE; macro name UNKNOWN'),
                  field_accesses=[dict(segment=k[0],base=k[1],displacement=k[2],sites=v) for k,v in field_counts.most_common(40)])
    model=dict(schema=1,claim_axes=['BYTE_EXACT','STRUCTURALLY_SUPPORTED','SEMANTICALLY_SUPPORTED','HISTORICALLY_PROVEN'],
        toolchain=dict(assembler_candidate='TASM 1.0',linker_candidate='TLINK 2.0',candidate_compatibility='MEASURED',historical_assembler='UNKNOWN',historical_linker='UNKNOWN',object_format_candidate='OMF; not preserved in packed asset',cpu='Decoded/assembled subset accepted by .8086; full game CPU requirement still unproven',memory_model='Observed multiple real-mode code frames and mixed near/far calls; no standard C memory-model claim'),
        observed_code_frames=frames,relocation_segment_words=[dict(value=k,count=v) for k,v in sorted(reloc_targets.items())],
        original_object_boundaries=[],historical_filenames=[],modern_layout='18 physical source chunks of approximately 8192 bytes (cuts avoid instructions) chosen to bound DOS assembler memory. Not original modules.',
        patterns=patterns,data_structures=[dict(name='word_fields_2_and_4',facts=['SS:[BP+2] and SS:[BP+4] independently updated at A5DB..A615','A571 reads those fields and writes DS:[BX+2/4] plus10','The two bases need not have the same segment','Record size, signed coordinate meaning and entity role UNKNOWN'],confidence='SEMANTICALLY_SUPPORTED_FIELDS_ONLY'),dict(name='buffer_state_0610',facts=['DS:0410..060F is a 512-byte input buffer','DS:0610 cursor; DS:0612 BX scratch; DS:0614 byte scratch','DOS file handle at DS:0240','Error path restores SP from CS:0242'],confidence='SEMANTICALLY_SUPPORTED')],
        unresolved=['Original assembler/linker versions, flags and names','Original object ordering and module boundaries','Original pre-packing MZ header and relocation order','BSS ownership and maximum memory requirements','Remaining indirect call/jump tables and runtime-written code','Overlay directory and optional driver extraction'])
    write_json(ROOT/'metadata/project-model.json',model)
    write_json(ROOT/'metadata/file-map.json',dict(files=[dict(path='assets/'+name,regions=[dict(start=0,end=h['header_bytes'],kind='MZ_HEADER'),dict(start=h['header_bytes'],end=h['executable_bytes'],kind='NESTED_PACKED_LOAD_MODULE'),dict(start=h['executable_bytes'],end=h['executable_bytes']+h['appended_bytes'],kind='APPENDED_DATA_UNKNOWN_INTERNAL_LAYOUT')]) for name,h in [('OVERKILL',m['mz']),('OVERKILL.EXE',read_json(ROOT/'metadata/launcher-extraction.json')['mz'])]]))
    # Searchable offline browser. All text goes through textContent, no HTML from assets.
    payload=json.dumps(functions).replace('<','\\u003c')
    browser='''<!doctype html><meta charset="utf-8"><title>Overkill function inventory</title><style>body{font:15px system-ui;margin:2rem;background:#141920;color:#e6edf3}input{padding:.7rem;width:32rem;max-width:90%}main{display:grid;grid-template-columns:32rem 1fr;gap:2rem}button{display:block;width:100%;text-align:left;background:#222c38;color:inherit;border:0;margin:3px 0;padding:.6rem;cursor:pointer}pre{white-space:pre-wrap}small{color:#a9bdcf}</style><h1>Overkill function inventory</h1><p>Candidate boundaries; unknown edges remain explicit. All addresses are relative to the load segment.</p><input id="search" placeholder="Filter address, name, class or contract"><main><section id="list"></section><pre id="detail">Select a function.</pre></main><script>const data='''+payload+''';const list=document.querySelector('#list'),detail=document.querySelector('#detail'),q=document.querySelector('#search');function render(){list.replaceChildren();for(const f of data){if(!JSON.stringify(f).toLowerCase().includes(q.value.toLowerCase()))continue;const b=document.createElement('button');b.textContent=f.address+' '+f.name+' ['+f.category+']';b.onclick=()=>detail.textContent=JSON.stringify(f,null,2);list.append(b)}}q.oninput=render;render();</script>'''
    (ROOT/'docs/functions.html').write_text(browser,encoding='utf-8')
    from runtime_status import extend_reports
    extend_reports()
    print('Reports updated:',status['identified_functions'],'candidates;',status['named_functions'],'reviewed names.')

if __name__=='__main__':
    if len(sys.argv)>1:
        functions=read_json(ROOT/'metadata/functions.json');query=sys.argv[1].lower()
        print(json.dumps([f for f in functions if query in (f['address']+' '+f['name']).lower()],indent=2))
    else:generate()
