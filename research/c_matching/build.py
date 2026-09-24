"""Bounded compiler experiment. Never imported by the production build."""
import os, re, sys, shutil, subprocess, struct, difflib
from pathlib import Path
ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT/'tools'))
from common import read_json, write_json, sha
from dos import dos
from extract import extract
from resources import driver
from capstone import Cs, CS_ARCH_X86, CS_MODE_16
HERE=Path(__file__).resolve().parent
OUT=ROOT/'build/c_matching'
CONFIGS={
 'tc_size':('TCC.EXE',['-c','-ms','-1-','-f-','-N-','-O','-Z','-G-']),
 'tc_speed':('TCC.EXE',['-c','-ms','-1-','-f-','-N-','-O','-Z','-G']),
 'msc_size':('msc51/CL.EXE',['/c','/AS','/G0','/Gs','/Os','/Zl']),
 'msc_speed':('msc51/CL.EXE',['/c','/AS','/G0','/Gs','/Ot','/Ol','/Zl']),
}
SAMPLE=[('upper_ascii',0xc7fe,'UNKNOWN'),('lower_ascii',0xca5b,'UNKNOWN'),
 ('dec_y',0xa5db,'GAME_LOGIC'),('inc_y',0xa5ed,'GAME_LOGIC'),('dec_x',0xa5fc,'GAME_LOGIC'),('inc_x',0xa60a,'GAME_LOGIC'),
 ('copy_position',0xa571,'GAME_LOGIC'),('xor_copy',0xc9d3,'UNKNOWN'),('find_free',0x7524,'GAME_LOGIC'),
 ('advance_history',0x9cf1,'GAME_LOGIC'),('store_history',0x9cd9,'GAME_LOGIC'),('place_pair',0x9fea,'GAME_LOGIC'),
 ('dec_x_twice',0xa5f9,'GAME_LOGIC'),('tandy_copy',0x306f,'PLATFORM_LOGIC'),('opl_status',0x571,'PLATFORM_LOGIC'),('pit_delay',0x579,'PLATFORM_LOGIC')]

def run(tool,args,cwd):
    env={k:v for k,v in os.environ.items() if k.upper() in ('SYSTEMROOT','WINDIR','TEMP','TMP','COMSPEC')}
    env['PATH']=str(HERE/'toolchain/msc51')+';'+str(ROOT/'toolchain')
    p=subprocess.run([str(ROOT/'toolchain/nmlgcdos/msdos.exe'),str(HERE/'toolchain'/tool),*args],cwd=cwd,env=env,capture_output=True,timeout=90)
    log=(p.stdout+p.stderr).decode('cp437',errors='replace').replace('\r','')
    if p.returncode or re.search(r'(^|\n)(Error|Fatal)',log):raise RuntimeError(log)
    return log

def load_exe(path):
    raw=path.read_bytes();h=struct.unpack_from('<14H',raw)
    end=(h[2]-1)*512+h[1] if h[1] else h[2]*512
    return raw[h[4]*16:end],[(s,o) for o,s in [struct.unpack_from('<HH',raw,h[12]+i*4) for i in range(h[3])]]

def link(folder,stem='CLEAN',objs='SAMPLE.OBJ+IO.OBJ'):
    log=dos('TLINK.EXE',['/m','/s',f'{objs},{stem}.EXE,{stem}.MAP,,'],folder)
    (folder/(stem+'.link.log')).write_text(log)
    image,rel=load_exe(folder/(stem+'.EXE'))
    # No startup, data globals, or segmented relocations are needed in these probes.
    if rel:raise ValueError(('Unexpected link relocations',rel))
    text=(folder/(stem+'.MAP')).read_text()
    pubs={name.lower():int(s,16)*16+int(o,16) for s,o,name in re.findall(r'^ ([0-9A-F]{4}):([0-9A-F]{4})\s+_([A-Z_0-9]+)\s*$',text,re.M)}
    if not all(n in pubs for n,_,_ in SAMPLE):raise ValueError('Compiler emitted incomplete sample; check DOS CRLF input')
    return image,pubs

def compile_all():
    lock=read_json(HERE/'toolchain-lock.json')
    for row in lock['files']:
        if sha((ROOT/row['path']).read_bytes())!=row['sha256']:raise ValueError('Tool hash mismatch '+row['path'])
    manifest={}
    for config,(tool,flags) in CONFIGS.items():
        folder=OUT/config;folder.mkdir(parents=True,exist_ok=True)
        for p in (HERE/'clean').iterdir():
            (folder/p.name).write_bytes(p.read_text().replace('\n','\r\n').encode('ascii'))
        for name in ('SAMPLE.OBJ','SAMPLE.ASM','CLEAN.EXE','CLEAN.MAP'):(folder/name).unlink(missing_ok=True)
        args=flags+(['SAMPLE.C'] if tool=='TCC.EXE' else ['/FaSAMPLE.ASM','SAMPLE.C'])
        log=run(tool,args,folder);(folder/'compile.log').write_text(log)
        if tool=='TCC.EXE':(folder/'listing.log').write_text(run(tool,[f for f in flags if f!='-c']+['-S','SAMPLE.C'],folder))
        (folder/'io.log').write_text(dos('TASM.EXE',['/ml','IO.ASM,IO.OBJ,IO.LST'],folder))
        image,pubs=link(folder)
        manifest[config]=dict(tool=tool,flags=flags,publics=pubs,image_sha256=sha(image),size=len(image),model='small near-code; explicit far data arguments; cdecl',cpu='8086',input_newlines='CRLF',source_sha256={p.name:sha(p.read_bytes()) for p in sorted((HERE/'clean').iterdir())})
        print(config,len(image),'bytes',len(pubs),'publics')
    write_json(OUT/'compiled.json',manifest)
    return manifest

def original_rows():
    main,_=extract();adlib,_=driver('adlib')
    graphs={'main':read_json(ROOT/'metadata/runtime/main-analysis.json'),'adlib':read_json(ROOT/'metadata/drivers/adlib-analysis.json')}
    rows=[]
    for name,start,domain in SAMPLE:
        module='adlib' if name in ('opl_status','pit_delay') else 'main';g=graphs[module];key=f'0000:{start:04X}'
        f=next(f for f in g['functions'] if f['address']==key)
        addresses=f['instructions'];end=max(g['nodes'][a]['linear']+g['nodes'][a]['size'] for a in addresses)
        image=main if module=='main' else adlib;data=image[start:end]
        union={p for a in addresses for p in range(g['nodes'][a]['linear'],g['nodes'][a]['linear']+g['nodes'][a]['size'])}
        # dec_x_twice owns its callee/fallthrough tail in the exact closed unit.
        if name=='dec_x_twice':end=0xa607;data=image[start:end]
        rows.append(dict(name=name,address=key,module=module,domain=domain,start=start,end=end,original_hex=data.hex(),original_bytes=len(data),candidate_owned_bytes=len(union),historical_bytes_sha256=sha(data)))
    return rows

def compare(manifest):
    md=Cs(CS_ARCH_X86,CS_MODE_16);rows=original_rows()
    for config,m in manifest.items():
        folder=OUT/config;image,_=load_exe(folder/'CLEAN.EXE');pubs=m['publics'];order=sorted(set(pubs.values()))+[len(image)]
        for row in rows:
            start=pubs[row['name']];end=next(v for v in order if v>start);data=image[start:end];orig=bytes.fromhex(row['original_hex'])
            od=list(md.disasm(orig,row['start']));cd=list(md.disasm(data,start))
            bmatch=sum(b.size for b in difflib.SequenceMatcher(None,orig,data,autojunk=False).get_matching_blocks())
            mnmatch=sum(b.size for b in difflib.SequenceMatcher(None,[n.mnemonic for n in od],[n.mnemonic for n in cd],autojunk=False).get_matching_blocks())
            row.setdefault('builds',{})[config]=dict(start=start,end=end,compiled_bytes=len(data),exact=data==orig,positional_equal_bytes=sum(a==b for a,b in zip(orig,data)),aligned_equal_bytes=bmatch,original_instructions=len(od),compiled_instructions=len(cd),mnemonic_lcs=mnmatch,original_listing=[f'{n.address:04X} {n.mnemonic} {n.op_str}' for n in od],compiled_listing=[f'{n.address:04X} {n.mnemonic} {n.op_str}' for n in cd],compiled_hex=data.hex())
    write_json(HERE/'results/codegen.json',dict(schema=1,method='Complete linked function extents (including any inter-function alignment). Byte LCS is descriptive only, not a semantic/matching score.',builds=manifest,sample=rows))
    return rows

if __name__=='__main__':compare(compile_all())
