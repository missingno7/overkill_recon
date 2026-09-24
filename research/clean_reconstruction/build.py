"""Native C-world build: source -> OMF -> TLINK EXE. No oracle/image input."""
import sys,os,re,struct,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'tools'))
from common import read_json,write_json,sha
from dos import dos
from capstone import Cs,CS_ARCH_X86,CS_MODE_16
HERE=Path(__file__).resolve().parent
OUT=ROOT/'build/clean_reconstruction';RESULTS=HERE/'results'
FLAGS=['-c','-ms','-1-','-f-','-N-','-O','-Z','-G-']
FUNCTIONS=['history_init','history_advance','history_store','history_apply','history_store_apply','history_update','main']

def compile_c(args,folder):
    tc=ROOT/'research/c_matching/toolchain'
    env={k:v for k,v in os.environ.items() if k.upper() in ('SYSTEMROOT','WINDIR','TEMP','TMP','COMSPEC')};env['PATH']=str(tc)+';'+str(ROOT/'toolchain')
    p=subprocess.run([str(ROOT/'toolchain/nmlgcdos/msdos.exe'),str(tc/'TCC.EXE'),*args],cwd=folder,env=env,capture_output=True,timeout=90)
    log=(p.stdout+p.stderr).decode('cp437').replace('\r','')
    if p.returncode or re.search(r'(^|\n)(Error|Fatal)',log):raise RuntimeError(log)
    return log

def mz(raw):
    v=struct.unpack_from('<14H',raw);assert v[0]==0x5a4d
    end=(v[2]-1)*512+v[1] if v[1] else v[2]*512
    rel=[seg*16+off for off,seg in (struct.unpack_from('<HH',raw,v[12]+4*i) for i in range(v[3]))]
    return dict(ss=v[7],sp=v[8],cs=v[11],ip=v[10],minimum_extra=v[5]),raw[v[4]*16:end],rel

def omf_records(raw):
    types=[];p=0
    while p<len(raw):
        typ=raw[p];n=struct.unpack_from('<H',raw,p+1)[0];row=raw[p:p+3+n]
        assert len(row)==3+n and sum(row)%256==0
        types.append(typ);p+=3+n
    return {hex(t):types.count(t) for t in sorted(set(types))}

def build():
    write_json(RESULTS/'build.json',dict(status='RUNNING_OR_FAILED'))
    for lock in ('metadata/toolchain-lock.json','research/c_matching/toolchain-lock.json'):
        for row in read_json(ROOT/lock)['files']:assert sha((ROOT/row['path']).read_bytes())==row['sha256']
    folder=OUT/'objects';folder.mkdir(parents=True,exist_ok=True)
    sources=list((HERE/'src').iterdir())
    for p in sources:
        text=p.read_text();assert not re.search(r'(?i)INCBIN|program\.bin|9CF1|A33A|A27A|9596',text)
        (folder/p.name).write_bytes(text.replace('\n','\r\n').encode('ascii'))
    for name in ('HISTORY','UPDATE','DEMO'):
        (folder/(name+'.OBJ')).unlink(missing_ok=True)
        (folder/(name+'.compile.log')).write_text(compile_c(FLAGS+[name+'.C'],folder))
        (folder/(name+'.listing.log')).write_text(compile_c([x for x in FLAGS if x!='-c']+['-S',name+'.C'],folder))
    for name in ('START','SHIFT'):
        (folder/(name+'.OBJ')).unlink(missing_ok=True)
        (folder/(name+'.log')).write_text(dos('TASM.EXE',['/ml',name+'.ASM,'+name+'.OBJ,'+name+'.LST'],folder))
    layouts={'base':['START','HISTORY','UPDATE','DEMO'],'moved':['START','SHIFT','UPDATE','DEMO','HISTORY']};result={}
    for mode,objects in layouts.items():
        stem=mode.upper();(folder/(stem+'.EXE')).unlink(missing_ok=True)
        (folder/(stem+'.log')).write_text(dos('TLINK.EXE',['/m','/s','+'.join(x+'.OBJ' for x in objects)+','+stem+'.EXE,'+stem+'.MAP,,'],folder))
        raw=(folder/(stem+'.EXE')).read_bytes();header,image,rel=mz(raw)
        publics={n.lower():dict(segment=int(s,16),offset=int(o,16),linear=int(s,16)*16+int(o,16)) for s,o,n in re.findall(r'^ ([0-9A-F]{4}):([0-9A-F]{4})\s+_([A-Z_0-9]+)\s*$',(folder/(stem+'.MAP')).read_text(),re.M)}
        assert set(FUNCTIONS)<=publics.keys()
        code_order=sorted([(publics[n]['linear'],n) for n in FUNCTIONS]+[(publics['start']['linear'],'start')])
        # Public functions are all in _TEXT; exact function extent from subsequent public.
        # Last function extent comes from compiler _TEXT module length in MAP segment rows.
        rows=re.findall(r'^ [0-9A-F]+H\s+([0-9A-F]+)H\s+[0-9A-F]+H _TEXT\s+CODE', (folder/(stem+'.MAP')).read_text(),re.M)
        assert len(rows)==1;code_end=int(rows[0],16)+1
        listings={}
        for i,(off,name) in enumerate(code_order):
            end=code_order[i+1][0] if i+1<len(code_order) else code_end
            listings[name]=[dict(address=n.address,hex=n.bytes.hex(),instruction=n.mnemonic+' '+n.op_str) for n in Cs(CS_ARCH_X86,CS_MODE_16).disasm(image[off:end],off)]
        edges={}
        by_address={p['linear']:n for n,p in publics.items() if n in FUNCTIONS}
        for name in FUNCTIONS:
            edges[name]=[by_address.get(int(x['instruction'].split()[1],16),'UNRESOLVED') for x in listings[name] if x['instruction'].startswith('call ')]
        assert edges['history_store_apply']==['history_store','history_apply'],edges
        assert edges['history_update']==['history_advance','history_store_apply'],edges
        assert not any('UNRESOLVED' in v for v in edges.values())
        target=OUT/mode;target.mkdir(parents=True,exist_ok=True)
        (target/'CLEAN.EXE').write_bytes(raw);(target/'CLEAN.MAP').write_bytes((folder/(stem+'.MAP')).read_bytes())
        result[mode]=dict(objects=objects,header=header,publics=publics,bytes=len(raw),sha256=sha(raw),relocations=rel,calls=edges,listings=listings)
    assert result['base']['publics']['history_advance']['linear']!=result['moved']['publics']['history_advance']['linear']
    report=dict(status='PASS',compiler='Turbo C2.0',flags=FLAGS,assembler='TASM1.0',linker='TLINK2.0',world='clean source only; no original-game executable input',layouts=result,omf={n:omf_records((folder/(n+'.OBJ')).read_bytes()) for n in ('START','HISTORY','UPDATE','DEMO')},source_sha256={p.name:sha(p.read_bytes()) for p in sources},historical_abi_adapters=0,historical_address_dependencies=0,unreconstructed_gameplay_asm_calls=0)
    write_json(RESULTS/'build.json',report);print('PASS clean linked C worlds',[(m,r['publics']['history_advance']['offset'],r['bytes']) for m,r in result.items()],flush=True);return report
if __name__=='__main__':build()
