"""Build maintained optional-driver ASM without reading the original asset."""
from common import *
from dos import dos
from omf import segments
import shutil

def assemble_driver(name):
    mapping=read_json(ROOT/'metadata/drivers'/f'{name}-source-map.json');path=ROOT/mapping['path'];build=ROOT/'build/driver-asm'/name;build.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(ROOT/'include/ENCODING.INC',build/'ENCODING.INC');shutil.copyfile(path,build/path.name)
    obj=build/(path.stem+'.OBJ');obj.unlink(missing_ok=True)
    log=dos('TASM.EXE',[f'{path.name},{path.stem}.OBJ,{path.stem}.LST'],build);(build/'assemble.log').write_text(log)
    segs=segments(obj.read_bytes())
    if len(segs)!=1:raise ValueError('Expected one driver segment')
    result=segs[0][1];(build/'driver.bin').write_bytes(result);return result

def validate_record_kind(row):
    import re
    kind=row['kind'];text=row['text'].strip()
    if kind not in ('instruction','opaque_unknown','reconstructed_data'):raise ValueError('Unknown driver source kind')
    if row['end']<=row['start']:raise ValueError('Empty/reversed driver source record')
    if kind=='instruction' and re.match(r'(?i)^(db|dw|dd|incbin)\b',text):raise ValueError('Raw bytes cannot count as instructions')
    if kind=='opaque_unknown' and not text.lower().startswith('db '):raise ValueError('Opaque source must remain explicit DB')
    if kind=='reconstructed_data':
        if not row.get('evidence'):raise ValueError('Reviewed data needs evidence')
        if not re.fullmatch(r'dw 0[0-9A-F]{4}h',text):raise ValueError('Only reviewed literal word data supported')
        if row['end']-row['start']!=2:raise ValueError('Reviewed word must account for exactly two bytes')

def verify_drivers():
    from resources import driver
    from verify import diff_ranges
    write_json(ROOT/'build/driver-verification.json',dict(status='RUNNING_OR_FAILED',modules=[]))
    rows=[]
    for name in ('adlib','roland'):
        built=assemble_driver(name);expected,resource=driver(name);differences=diff_ranges(expected,built)
        mapping=read_json(ROOT/'metadata/drivers'/f'{name}-source-map.json')
        # Source accounting is checked against maintained text, as with Oracle A.
        source=(ROOT/mapping['path']).read_text();blocks={};current=None
        import re
        for line in source.splitlines():
            match=re.match(r'; @([0-9A-F]{5})\b',line)
            if match:current=int(match[1],16);blocks[current]=[];continue
            text=line.split(';',1)[0].strip()
            if current is not None and text and text not in ('driver ends','end'):blocks[current].append(text)
        cursor=0
        for row in mapping['records']:
            validate_record_kind(row)
            if row['start']!=cursor:raise ValueError('Driver source-map gap')
            if blocks.get(cursor)!=[v.split(';')[0].strip() for v in row['text'].splitlines()]:raise ValueError('Driver source/source-map mismatch')
            cursor=row['end']
        if cursor!=len(expected):raise ValueError('Driver source-map length')
        row=dict(name=name,resource=resource,status='FAIL' if differences else 'PASS',sha256=sha(built),mismatching_ranges=differences,
                 reconstructed_data_bytes=sum(r['end']-r['start'] for r in mapping['records'] if r['kind']=='reconstructed_data'),
                 instruction_bytes=sum(r['end']-r['start'] for r in mapping['records'] if r['kind']=='instruction'),
                 opaque_unknown_bytes=sum(r['end']-r['start'] for r in mapping['records'] if r['kind']=='opaque_unknown'))
        rows.append(row);print(name,row['status'],len(built),'bytes',len(differences),'differences')
        if differences:print(differences[:8]);raise AssertionError('Optional driver mismatch')
    write_json(ROOT/'build/driver-verification.json',dict(status='PASS',modules=rows));return rows
if __name__=='__main__':verify_drivers()
