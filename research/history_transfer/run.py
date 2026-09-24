"""Bounded second swap experiment; no production C dependency."""
from build_transfer import *
from verify_transfer import verify
from integration import integration
import subprocess

def residual():
    b=read_json(RESULTS/'boundary.json');c=read_json(RESULTS/'compiled.json')
    r=dict(status='PASS',outcome='SWAP_VERIFIED_C',residual_class='MACHINE_ONLY_UNDER_STATED_PRECONDITIONS',original_bytes=b['bytes'],original_instructions=b['instructions'],c_bytes=c['body_bytes'],c_instructions=len(c['body_listing']),bridge_bytes=c['bridge_bytes'],bridge_instructions=len(c['bridge_listing']),semantic_corrections=[],matching_recipe=None,
      differences=[
        dict(category='SEMANTIC',finding='Sequential biased store followed by conditional delayed copies; earlier stores may change later source words, selector or cursor. Volatile native C preserves these accesses; synthetic alias tests agree.'),
        dict(category='ABI',finding='Explicit far source/output pointers, near DS cursor/selection views and far private progress result. Result fields preserve historical AX/DI/ES and conditional BX/SI outputs without putting copying or selection semantics into the shim.'),
        dict(category='CODEGEN',finding='TC2.0 replaces LODS/STOS with indexed MOV, uses SI for the transferred word, a BP frame and two local slots. Four-byte pointer marshalling and progress stores dominate expansion.'),
        dict(category='CONTROL_FLOW_SHAPE',finding='Two original calls with RETs become one C function with two optional transfer blocks and a shared epilogue. Six-byte far-call/NOP gate preserves continuation9BE8.'),
        dict(category='CODEGEN',finding='Original arithmetic flags at9BE8 are dead at the next CMP; all control flags preserved and all flags compared after that original instruction.'),
        dict(category='PLATFORM',finding='No platform operations in body. DOS near/far addressing and stack model remain explicit; no portable ISO C claim.'),
        dict(category='UNKNOWN',finding='Known decoded inbound graph only; no proof against unresolved indirect entry. Arbitrary asynchronous mutation and timing not covered. Extra64-byte stack reservation is a precondition, not globally proven capacity.')],
      recommendation='Verified C is preferable to prescribing the original register/string-op choreography. The101-byte bridge exceeds the77-byte original cluster. A larger boundary or proven dead outputs may reduce adaptation cost; do not generalize a matching DSL.',
      delete_diff='No matching layer exists. TRANSFER.C compiles independently with normal TC2.0. The bridge only adapts the original boundary; clean C owns arithmetic, conditions, ordered writes and transfer progress.')
    write_json(RESULTS/'residual.json',r);return r

def first_regression():
    # Compare to the committed first experiment, not a mutable generated baseline.
    raw=subprocess.check_output(['git','-c','safe.directory='+str(ROOT).replace('\\','/'),'show','543f93c:research/swap_unit/results/build.json'],cwd=ROOT)
    import json
    before=json.loads(raw);first.build(verify_exact=False);after=read_json(first.RESULTS/'build.json')
    old=[x['sha256'] for x in before['builds']];new=[x['sha256'] for x in after['builds']];assert old==new
    result=dict(status='PASS',baseline_commit='543f93c',first_game_hashes=new,packager_sha256=sha((ROOT/'research/swap_unit/build_swap.py').read_bytes()),scope='Default packaging regenerates both first-experiment games byte-for-byte. Existing first synthetic/startup receipts apply to these unchanged machine images; not a claim their full pipeline was rerun.')
    write_json(RESULTS/'first-regression.json',result);return result

def finish():
    r=residual();d=read_json(RESULTS/'differential.json');i=read_json(RESULTS/'integration.json')
    assert d['status']==i['status']=='PASS'
    write_json(RESULTS/'experiment.json',dict(status='PASS',classification=r['outcome'],synthetic_cases=d['cases'],integration='four native packages reach9690; unit itself exercised synthetically through actual callers',source_sha256={str(p.relative_to(ROOT)):sha(p.read_bytes()) for p in sorted(HERE.glob('*')) if p.is_file() and p.suffix in ('.py','.C','.ASM')},shared_packager_sha256=sha((ROOT/'research/swap_unit/build_swap.py').read_bytes())))
if __name__=='__main__':
    write_json(RESULTS/'experiment.json',dict(status='RUNNING_OR_FAILED'))
    first.verify();build();verify();integration();first_regression();finish()
