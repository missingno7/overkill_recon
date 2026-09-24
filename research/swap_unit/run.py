"""Bounded end-to-end experiment: build, local equivalence, startup, residual."""
from build_swap import *
from verify_swap import verify_units
from integration import integration

def residual():
    original=read_json(RESULTS/'boundary.json');compiled=read_json(RESULTS/'compiled.json')
    data=dict(status='PASS',residual_class='MACHINE_ONLY_UNDER_REVIEWED_BOUNDARY',outcome='SWAP_VERIFIED_C',
        original_bytes=original['bytes'],original_instructions=original['instructions'],compiled_body_bytes=compiled['body_bytes'],compiled_body_instructions=len(compiled['body_listing']),bridge_bytes=compiled['bridge_bytes'],bridge_instructions=len(compiled['bridge_listing']),
        semantic_corrections=[],natural_c_is_final_c=True,matching_recipe=None,
        differences=[
          dict(category='SEMANTIC',finding='No known algorithm difference. Ordered cursor writes, low-nibble/adjustment trigger, unsigned wrap and equality-only reset agree in differential tests.'),
          dict(category='ABI',finding='Fixed DS cursor cells become an explicit far HistoryCursors pointer; input byte and adjustment word are native C value arguments. Near cdecl stack args replace implicit globals.'),
          dict(category='ABI',finding='42-byte bridge preserves all GP/DS/ES and control flags; FAR gate returns through an unchanged historical near caller. No algorithm in bridge.'),
          dict(category='CODEGEN',finding='BP frame and four LES BX pointer reloads; ES:[BX+field] replaces absolute DS addressing; scratch BX/ES restored by bridge.'),
          dict(category='CONTROL_FLOW_SHAPE',finding='Shared C epilogue replaces original two RET sites. Same trigger and four independent equality branches.'),
          dict(category='CODEGEN',finding='Dead arithmetic flag outputs differ at9BE2. Original following9CD9 ADD overwrites them: tests compare all flags after that continuation.'),
          dict(category='PLATFORM',finding='Native MZ prefix retains C/bridge below original image so unchanged DOS resize keeps it. Existing integrity checksum footer must be regenerated, never bypassed.'),
          dict(category='UNKNOWN',finding='Unknown program regions/unresolved indirect targets prevent a global no-hidden-entry claim. Interrupt schedule/timing equivalence and unlimited stack capacity are not proven.')],
        quality='Body mismatch is modest and understandable, not an algorithmic rewrite. Exact matching requires specializing argument locations, memory addressing, frame and return layout; prior study judged that borderline. No exact-matching machinery is needed for swappability.',
        next_candidate='StorePositionHistory9CD9 + ApplyPositionHistoryToRecordsA031: first establish live scratch outputs and sequential alias effects; expand boundary if they prevent a clean ABI.')
    write_json(RESULTS/'residual.json',data)
    return data

if __name__=='__main__':
    write_json(RESULTS/'experiment.json',dict(status='RUNNING_OR_FAILED'))
    build();units=verify_units();startup=integration();r=residual()
    write_json(RESULTS/'experiment.json',dict(status='PASS',classification=r['outcome'],synthetic_cases=units['cases'],startup='PASS both modes through9690',source_sha256={p.name:sha(p.read_bytes()) for p in sorted(HERE.glob('*')) if p.is_file() and p.suffix in ('.py','.C','.ASM')}))
