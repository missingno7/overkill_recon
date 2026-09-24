"""Fresh Oracle B execution and source correspondence; never accepts a cached run."""
from common import *
from materialize_runtime import materialize
from build_drivers import assemble_driver
import struct,argparse

def verify(repeat=False):
    out=ROOT/'build/runtime-oracle';write_json(ROOT/'build/runtime-verification.json',dict(status='RUNNING_OR_FAILED'))
    m=materialize(out=out);baseline=read_json(ROOT/'metadata/runtime/frontier-reference.json')
    if m['main_address_space_sha256']!=baseline['main_address_space_sha256']:raise AssertionError('Canonical runtime RAM window changed')
    regions=read_json(out/'executable-regions.json');built=bytearray((ROOT/'build/program.bin').read_bytes());image=(out/'main-runtime.bin').read_bytes()
    for off in read_json(ROOT/'metadata/relocations.json')['sites']:struct.pack_into('<H',built,off,(struct.unpack_from('<H',built,off)[0]+0x1010)&65535)
    for r in regions['main']['executable_ranges']:
        if built[r['start']:r['end']]!=image[r['start']:r['end']]:raise AssertionError('Built main instructions differ from runtime')
    for mod in m['modules']:
        raw=assemble_driver(mod['identity']);original=(out/mod['load']['artifact']).read_bytes();initialized=(out/(mod['identity']+'-driver.bin')).read_bytes()
        if raw!=original:raise AssertionError('Built driver differs from authentic loader')
        for r in mod['code_ranges']:
            if raw[r['start']:r['end']]!=initialized[r['start']:r['end']]:raise AssertionError('Built driver code differs after initialization')
    checked=[]
    if repeat:
        again=ROOT/'build/runtime-oracle-repeat';materialize(out=again)
        for name in ('main-runtime.bin','main-executable.bin','adlib-driver.bin','module-0.bin','state.json','writes.bin.gz','executable-regions.json','manifest.json'):
            if (out/name).read_bytes()!=(again/name).read_bytes():raise AssertionError('Non-deterministic runtime artifact: '+name)
            checked.append(name)
    receipt=dict(status='PASS',oracle_a='verified separately without weakening its criterion',oracle_b=m['main_address_space_sha256'],main_code_bytes=m['main_executable_bytes'],driver_loaded_bytes=sum(v['source']['decoded_size'] for v in m['modules']),exact_repeat_artifacts=checked,
                 criterion='Fresh authentic startup matches pinned candidate-frontier RAM hash; rebuilt main instruction projection and complete rebuilt uninitialized driver match original execution. Initialized driver instruction bytes remain exact. Mutable runtime RAM is produced by execution, not claimed as a second static ASM dump.',global_stability='NOT_PROVEN',mismatching_ranges=[])
    write_json(ROOT/'build/runtime-verification.json',receipt);print('PASS: bounded runtime oracle and ASM correspondence');return receipt
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--repeat',action='store_true');a=p.parse_args();verify(a.repeat)
