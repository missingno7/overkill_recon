"""Exact acceptance, byte diff, provenance checks and generated status/report entry."""
from common import *
from extract import extract
from build import assemble
import argparse,subprocess,re

def check_hashes(manifest):
    for row in read_json(ROOT/'metadata'/manifest)['files']:
        p=ROOT/row['path'];data=p.read_bytes()
        if len(data)!=row['size'] or sha(data)!=row['sha256']:raise ValueError('Hash mismatch: '+row['path'])

def diff_ranges(expected,actual):
    out=[];start=None
    for i in range(max(len(expected),len(actual))+1):
        differs=i<max(len(expected),len(actual)) and (i>=len(expected) or i>=len(actual) or expected[i]!=actual[i])
        if differs and start is None:start=i
        if not differs and start is not None:out.append(dict(start=start,end=i,expected_hex=expected[start:i][:32].hex(),actual_hex=actual[start:i][:32].hex()));start=None
    return out

def audit_source():
    mapping=read_json(ROOT/'metadata/source-map.json');cursor=0;counts={};instructions=[]
    from bootstrap_source import macros
    if (ROOT/'include/ENCODING.INC').read_text()!=macros():raise ValueError('Encoding macros changed; review their semantics and update the audited definition.')
    # Shared semantic vocabulary may define constants only, never emit code.
    for line in (ROOT/'include/MOVEMENT.INC').read_text().splitlines():
        value=line.split(';',1)[0].strip()
        if value and not re.fullmatch(r'[A-Za-z_][A-Za-z_0-9]* equ 0[0-9A-F]+h',value):
            raise ValueError('Non-constant directive in MOVEMENT.INC')
    for chunk in mapping['chunks']:
        if chunk['start']!=cursor:raise ValueError('Source chunk gap')
        p=ROOT/chunk['path'];text=p.read_text(); lower=text.lower()
        for forbidden in ('incbin','binary_include','org ','include assets','include ../'):
            if forbidden in lower:raise ValueError('Unapproved source directive in '+str(p))
        blocks={}
        current=None
        for line in text.splitlines():
            match=re.match(r'; @([0-9A-F]{5})\b',line)
            if match:current=int(match[1],16);blocks[current]=[];continue
            stripped=line.split(';',1)[0].strip()
            if current is not None and stripped and stripped!='end' and not re.fullmatch(r'part[0-9]+ ends',stripped):blocks[current].append(stripped)
        # Changed instruction representation must update the explicit source map.
        # This prevents relabelling raw DB capsules as decoded ASM coverage.

        for r in chunk['records']:
            if r['start']!=cursor or r['end']<=cursor:raise ValueError('Source record gap/overlap')
            if f'@{r["start"]:05X}' not in text:raise ValueError('Source-map annotation missing')
            counts[r['kind']]=counts.get(r['kind'],0)+r['end']-r['start'];cursor=r['end']
            if r['kind']=='instruction':
                expected_lines=[v.split(';',1)[0].strip() for v in r['text'].splitlines() if v.split(';',1)[0].strip()]
                if blocks.get(r['start'])!=expected_lines:raise ValueError(f'Instruction/source-map mismatch at {r["start"]:05X}; review and update its representation.')
                instructions.append(r)
            elif r['kind']=='reconstructed_data':
                if not r.get('evidence') or r['end']-r['start']!=2:raise ValueError('Reviewed word data needs extent and evidence')
                if not re.fullmatch(r'dw (?:0[0-9A-F]+h|[A-Za-z_][A-Za-z_0-9]*)',r['text']):raise ValueError('Unsupported reviewed word expression')
                if blocks.get(r['start'])!=[r['text']]:raise ValueError('Reviewed data/source-map mismatch')
            elif r['kind']!='opaque_unknown' or any(not v.lower().startswith('db ') for v in blocks.get(r['start'],[])):raise ValueError('Raw region has unaccounted directives')
    if cursor!=read_json(ROOT/'metadata/oracle.json')['program_bytes']:raise ValueError('Incomplete source accounting')
    return counts

def verify(rebuild=True):
    # Failed invocations must never leave a stale passing receipt.
    write_json(ROOT/'build/verification.json',dict(status='RUNNING_OR_FAILED',match=False))
    check_hashes('inputs.json');check_hashes('toolchain-lock.json');counts=audit_source()
    actual=assemble() if rebuild else (ROOT/'build/program.bin').read_bytes()
    expected,m=extract(output=ROOT/'build/oracle/OVERKILL')
    baseline=read_json(ROOT/'metadata/oracle.json')
    if m!=baseline:raise ValueError('Extraction differs from reviewed oracle manifest')
    differences=diff_ranges(expected,actual)
    rel=read_json(ROOT/'metadata/relocations.json')
    if rel['sites']!=m['relocations'] or rel['entry_cs']!=m['entry_cs'] or rel['entry_ip']!=m['entry_ip']:raise ValueError('Relocation/entry manifest mismatch')
    receipt=dict(status='PASS' if not differences else 'FAIL',match=not differences,
        criterion='All normalized pre-startup program-image bytes, length, entry and ordered 123 relocation sites. Packed whole-file identity NOT claimed.',
        original_image_bytes=len(expected),assembled_bytes=len(actual),expected_sha256=sha(expected),actual_sha256=sha(actual),
        mismatching_ranges=differences,source_bytes=counts,whole_original_file_match='NOT_BUILT',
        source_sha256={p.relative_to(ROOT).as_posix():sha(p.read_bytes()) for p in sorted(list((ROOT/'src').glob('*.ASM'))+list((ROOT/'include').glob('*.INC')))})
    write_json(ROOT/'build/verification.json',receipt)
    if differences:raise AssertionError('Binary mismatch; see build/verification.json: '+str(differences[:3]))
    print('PASS: exact normalized image;',len(actual),'bytes;',counts)
    return receipt

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('--full',action='store_true');args=parser.parse_args()
    if args.full:write_json(ROOT/'build/full-verification.json',dict(status='RUNNING_OR_FAILED'))
    verify()
    from build_drivers import verify_drivers
    verify_drivers()
    if args.full:
        from verify_unpack import verify as boot
        write_json(ROOT/'build/unpack-verification.json',[boot(b,a) for a in ('OVERKILL','OVERKILL.EXE') for b in (0x1010,0x2010)])
        from topology_experiments import run
        run()
        from verify_runtime import verify as runtime
        runtime(repeat=False)
        subprocess.run([sys.executable,'-m','unittest','discover','-s',str(ROOT/'tests'),'-v'],check=True,cwd=ROOT)
        write_json(ROOT/'build/full-verification.json',dict(status='PASS',unpack_checks=4,semantic_and_infrastructure_tests='PASS',topology_variants=5,runtime_oracle='PASS bounded startup',optional_drivers='PASS',image_sha256=sha((ROOT/'build/program.bin').read_bytes())))
    from report import generate
    generate()
