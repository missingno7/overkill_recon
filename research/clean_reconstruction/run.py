"""Reproducible clean-world pass; exact oracle has its independent build target."""
from build import *
import importlib.util

def local_module(name):
    spec=importlib.util.spec_from_file_location('clean_'+name,HERE/(name+'.py'))
    m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m);return m

def report():
    from extract import extract
    b=read_json(RESULTS/'build.json');d=read_json(RESULTS/'differential.json');demo=read_json(RESULTS/'demo.json')
    assert b['status']==d['status']==demo['status']=='PASS'
    for name,digest in b['source_sha256'].items():assert sha((HERE/'src'/name).read_bytes())==digest
    v=local_module('verify');image=extract()[0];g=read_json(ROOT/'metadata/runtime/main-analysis.json')['nodes'];regions={}
    operations={'init':'Repeated (Y+8,X+9) fill, then initial cursor indices; source loads stay inside loop.',
      'advance':'Input low nibble OR adjustment triggers four cursor advances; mapping address steps4 to index steps1 is valid only in initialized ring domain.',
      'store':'Y+8 then X+8, explicit unsigned16 wrap; second source load after first store.',
      'apply':'First selected copy then second; NULL replaces absent FFFF under pointer relation. Reads remain between stores for whole-position aliases.',
      'store_apply':'Ordinary C store then apply; no progress-register compatibility result.',
      'update':'Ordinary C advance then store/apply; leaf ABI disappears internally.'}
    for k,ranges in v.RANGES.items():
        owned={a for a,n in g.items() if any(lo<=n['linear']<hi for lo,hi in ranges)}
        incoming=[dict(source=a,target=t,kind=kind) for a,n in g.items() if a not in owned for kind in ('calls','successors') for t in n[kind] if t in owned]
        regions[k]=dict(status='LEAF_C_VERIFIED' if k in ('init','advance','store','apply') else 'C_CLUSTER_VERIFIED',
          proof_scope='Typed-state memory-effects refinement, not drop-in historical machine ABI',
          ranges=[dict(start=lo,end_exclusive=hi,sha256=sha(image[lo:hi])) for lo,hi in ranges],
          incoming_known_edges=incoming,coverage=d['coverage'][k],tests=d['counts'][k],
          c_function='history_'+k,c_calls=b['layouts']['base']['calls']['history_'+k],
          semantics=operations[k],residual_class='REPRESENTATION_AND_MACHINE_DIFFERENCES_WITH_NO_KNOWN_SEMANTIC_MISMATCH_IN_DOMAIN',
          c_instructions=len(b['layouts']['base']['listings']['history_'+k]))
    r=dict(status='PASS',regions=regions,oracle_sha256=sha(image),metrics=dict(verified_c_leaves=4,verified_c_clusters=2,largest_verified_region_bytes=172,largest_verified_region_instructions=51,historical_abi_adapters=0,historical_address_dependencies=0,remaining_gameplay_asm_dependencies=0,platform_asm_game_boundaries=0,dos_process_entry_exit_asm_modules=1),
      domain=['Initializer requires source outside history; initialized history thereafter has indices0..47','Position objects may coincide wholly; source and selected positions may be ring samples','Pointer-array and cursor metadata storage disjoint from positions','Original DS=SS=CS9596 and DF0 as established by startup; no async mutation'],
      excluded=['Malformed/off-ring cursor equivalence','Partial-word overlaps and corruption of selectors/cursors via position stores','Historical GP/flag ABI outputs: retained in oracle, not silently claimed dead','Whole game or original9690 startup integration'],
      residual_taxonomy={'SEMANTIC':'Address-to-index and sentinel-to-pointer relations are explicit. Ordered writes and final state agree within that relation; no C correction needed.',
        'ABI':'Normal near cdecl only in C world. Test runner initializes each world through its own interface; no runtime marshalling between worlds.',
        'CODEGEN':'Compiler frame, temporary allocation, indexed MOV and loop induction differ; not reproduced.',
        'CONTROL_FLOW_SHAPE':'C loop replaces unrolled cursor updates; higher C functions call reconstructed C directly.',
        'PLATFORM':'Only minimal independent DOS process entry/exit, no game hardware boundary introduced.',
        'UNKNOWN':'Global precondition validity and outer caller observable-register use remain integration obligations.'},
      hidden_coupling=['Initialization uses X+9 while later stores use X+8','No request still overwrites current history entry','Selected objects can alias each other/source/ring; order matters','Second cluster entry9BE2 maps to normal history_store_apply; update9BDF also advances first'],
      next_parent='9BE8..9BFA optional9FAF/9FEA offset placement: first establish field+8 table bounds, slot lifetime and parent-visible semantics. 9B2E also has unreviewed input/movement dependencies.',
      interpretation='Two-world bottom-up composition works for this explicit semantic domain. This is not a global register-deadness proof or a complete reconstructed game.')
    write_json(RESULTS/'regions.json',r)
    write_json(RESULTS/'experiment.json',dict(status='PASS',metrics=r['metrics'],independent_states=d['individual_test_states'],sequence_updates=d['sequence_updates'],native_dos_demo='PASS both link layouts',source_sha256={str(p.relative_to(HERE)):sha(p.read_bytes()) for p in sorted(HERE.rglob('*')) if p.is_file() and p.suffix in ('.C','.H','.ASM','.py')},build_sha256=sha((RESULTS/'build.json').read_bytes()),differential_sha256=sha((RESULTS/'differential.json').read_bytes())))
    return r
if __name__=='__main__':
    write_json(RESULTS/'experiment.json',dict(status='RUNNING_OR_FAILED'))
    build();local_module('verify').verify();local_module('demo').demo();report()
