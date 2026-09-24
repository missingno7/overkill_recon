"""Summarize repeatable traces without treating them as an exhaustive game proof."""
from common import *
from materialize_runtime import artifacts,code_offsets,ranges
from runtime_trace import report
from resources import driver,resources
from extract import extract
import collections

def generate():
    root=ROOT/'build/runtime-matrix';profiles=[];main=code_offsets(read_json(ROOT/'metadata/runtime/main-analysis.json'))
    for folder in sorted(root.iterdir()):
        if not (folder/'state.json').exists():continue
        s=read_json(folder/'state.json');m=artifacts(folder);r=report(folder,quiet=True)
        profiles.append(dict(profile=folder.name,reason=s['reason'],frontier=m['frontier'],sequence=s['sequence'],psp_tail=s['psp_tail'],module_resources=[v['resource'] for v in s['module_loads']],main_code_changed_bytes=m['main_executable_changed_bytes'],main_address_space_sha256=m['main_address_space_sha256'],vectors=s['vectors'],write_statistics=r['statistics']))
    runs=[]
    folders=list((ROOT/'build/runtime-video').iterdir())
    for name in ('tandy-adlib-play','tandy-adlib-gameplay','tandy-adlib-level-right','tandy-roland-ticks'):
        folder=ROOT/'build/runtime-probe'/name
        if (folder/'state.json').exists():folders.append(folder)
    for folder in folders:
        s=read_json(folder/'state.json');r=report(folder,quiet=True)
        runs.append(dict(name=folder.name,profile=s['video']+'-'+s['sound'],steps=s['sequence'],reason=s['reason'],irq_count=s['irq_count'],execution_model_sha256=s.get('execution_model_sha256','exploratory-earlier-revision'),frontiers={k:v['sequence'] for k,v in s['checkpoints'].items()},unique_instructions=len(s['visited']),gameplay_loop_visits=s['visited'].get('1010:97B2',{}).get('hits',0),slot_5e42_instruction_visits=s['visited'].get('1010:5E42',{}).get('hits',0),key_events=s.get('key_events',[]),
            post_frontier_steps=s['sequence']-s['checkpoints']['frontier-9690']['sequence'],post_frontier_executable_write_attempts=r['statistics'].get('post_frontier_executable_write_attempts',0),post_frontier_changed_executable_bytes=r['statistics'].get('post_frontier_changed_executable_bytes',0),remaining_changed_writes=r['post_frontier_changed_writes'],module_loads=s['module_loads'],state_sha256=sha((folder/'state.json').read_bytes())))
    for run in runs:
        folder=next(f for f in folders if f.name==run['name']);state=read_json(folder/'state.json');memory=(folder/'memory.bin').read_bytes();ds=int.from_bytes(memory[0x10100+0x9596:0x10100+0x9598],'little')
        run['execution_frames']=dict(collections.Counter(k[:4] for k in state['visited']))
        run['final_selection_word_DS2356']=int.from_bytes(memory[ds*16+0x2356:ds*16+0x2358],'little')
        run['scope']='observed instructions and conservatively recovered CFG, not every possible executable byte'
    slot=read_json(root/'tandy-adlib/runtime-code-writes.json')['slot_5e42'];final=[r for r in slot if r['writer']=='32FF:0099'];first=min(r['sequence'] for r in final);last=max(r['sequence'] for r in final)
    slot_fact=dict(relative_range=[0x5e42,0x5f1b],end_exclusive=True,legacy_end_inclusive=0x5f1a,range_kind="reported probe window, not a proven function boundary",writer='32FF:0099',next_ip='32FF:009B',writes=len(final),changed_bytes=sum(sum(x!=y for x,y in zip(bytes.fromhex(r['old']),bytes.fromhex(r['new']))) for r in final),first_sequence=first,last_sequence=last,oracle_a_sequence=1370856,classification='UNPACK_RELOCATION_MATERIALIZATION',after_oracle_a_writes=sum(r['phase']=='after-A' for r in slot),conclusion='The gameplay body already exists in Oracle A; legacy cold bytes belong to a pre-EXEPACK intermediate.')
    matrix_deltas=[]
    from verify import diff_ranges
    for sound in ('pc','adlib'):
        ref=(root/f'tandy-{sound}'/'frontier-9690.bin').read_bytes()
        for video in ('cga','ega'):
            body=(root/f'{video}-{sound}'/'frontier-9690.bin').read_bytes();matrix_deltas.append(dict(reference=f'tandy-{sound}',profile=f'{video}-{sound}',differences=diff_ranges(ref,body),interpretation='Only selector at relative 95BC differs at 9690. Later renderer preparation changes data/tables and selects existing routines.'))
    renderer_deltas=[]
    ref_folder=ROOT/'build/runtime-video/tandy-pc'
    if (ref_folder/'frontier-96ce.bin').exists():
        ref=(ref_folder/'frontier-96ce.bin').read_bytes()
        for video in ('cga','ega'):
            f=ROOT/'build/runtime-video'/f'{video}-pc'
            if not (f/'frontier-96ce.bin').exists():continue
            body=(f/'frontier-96ce.bin').read_bytes();diff=diff_ranges(ref,body)
            for row in diff:
                lo,hi=row['start'],row['end'];row['reference_sha256']=sha(ref[lo:hi]);row['variant_sha256']=sha(body[lo:hi]);row['watched_instruction_differences']=[p for p in range(lo,hi) if p in main and ref[p]!=body[p]]
                row['classification']='NON_WATCHED_STATE_OR_DATA' if not row['watched_instruction_differences'] else 'EXECUTABLE_DIFFERENCE_REQUIRING_REVIEW'
            renderer_deltas.append(dict(reference='tandy-pc',profile=video+'-pc',frontier='0000:96CE',ranges=diff,known_state_fields=['CS:95BC selector','CS:959E..95C4 geometry/addressing state','DS:1024..1072 selected 39-word table copied by0889'],claim='All differing ranges enumerated; unnamed ranges remain unclassified state/data, not invented structures.'))
    result=dict(schema=1,research_policy=dict(method='STATIC_BOTTOM_UP',execution='Only necessary targeted probes or startup verification; hard cap at first gameplay entry 0000:97B2',historical_traces='Previously collected longer traces are retained as evidence only; do not reproduce them',exhaustive_state_coverage_required=False),architecture_decision='SHARED_INITIAL_MAIN_ASM_PLUS_VERSIONED_OPTIONAL_DRIVER_MODULES',canonical_reconstruction_profile=dict(video='Tandy/PCjr',sound='AdLib / YM3812 (OPL2)',input_initial_state='default keyboard',status='explicit research default; not a unique historical machine'),oracle_a='unchanged 143088-byte image, 123 ordered relocations, entry 0000:95C9',oracle_b=dict(frontier='0000:9690',status='REPRODUCIBLE_BOUNDED_CANDIDATE_ESMR',earliest_claim='Earliest tested common caller frontier after optional audio initialization. Minimality and all-path stability are NOT proven.',main_semantic_target='shared Oracle A main code; runtime graph supplements reachability; optional slot has a separate identity',full_data_state='specific deterministic synthetic hardware schedule; not a universal historical RAM state'),slot_5e42=slot_fact,profiles=profiles,video_pairwise_deltas=matrix_deltas,renderer_preparation_deltas=renderer_deltas,stability_runs=runs,optional_modules=[driver(n)[1] for n in ('adlib','roland')],
        taxonomy=dict(unpack_relocation='PROVEN before A; 5E42 is part of it',runtime_main_code_installation='NONE OBSERVED after A',hardware_specialization='NONE OBSERVED in watched executable bytes',optional_module_load='PROVEN: ENC decoder 0000:EDE9 to relative segment 1022',interrupt_vector_installation='PROVEN: vectors 24h, 08h, 09h',recurring_self_modification='NONE OBSERVED in bounded traces; not excluded on untested paths',unknown='Statically unresolved code, indirect write destinations and exact earliest boundary; exhaustive game-state coverage is not required'),
        input=dict(kind='RUNTIME_STATE',selector='DS:0010',default=0,joystick=1,alternate_keyboard=2,evidence=['0000:0162 branch; 0171 alternate table branch; 01CE joystick path; tests/test_runtime.py executes all three','Menu 5656 selects0; 0011 selects1; 56CE selects2; original input code coexists in A']),
        claim_confidence=dict(oracle_a_identity='PROVEN',driver_loaded_bytes='PROVEN against original CPU output and independent decoder',slot_5e42_before_A='PROVEN',input_state_branching='PROVEN within decoded/tested poller',shared_main_code='STRONG bounded static/dynamic evidence',video_not_instruction_patching='STRONG for observed paths; UNKNOWN globally',canonical_profile='MODERN_RECONSTRUCTION_CHOICE',ESMR_minimality='UNKNOWN',global_post_ESMR_stability='UNKNOWN',historical_ASM_filenames='UNKNOWN'),
        environment_limits=['Original instructions execute in pinned Unicorn; DOS and hardware are explicitly modeled, not a full PC emulator.','PIT/IRQ/retrace use synthetic instruction schedules. No physical timing or visual/audio correctness claim.','MPU exposes ready/ACK and OPL2 timer1 exposes status; this does not emulate music synthesis.','Writes in conventional RAM are fully journaled; execution outside it is rejected except model BIOS IRET stubs.','Only observed plus conservatively decoded instruction ranges are watched. Unknown code coverage cannot be claimed.','Global ESMR stability and earliest-instruction minimality remain open.'])
    write_json(ROOT/'metadata/runtime/materialization.json',result)
    _,directory=resources();write_json(ROOT/'metadata/resource-directory.json',directory)
    print('Recorded',len(profiles),'profiles and',len(runs),'stability runs;',slot_fact)
    return result
if __name__=='__main__':generate()
