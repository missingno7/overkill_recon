"""Build ONE research swap unit. Does not alter production source/build machinery."""
import argparse, importlib.util, re, shutil, struct, sys
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'tools'))
from common import read_json,write_json,sha
from dos import dos
from extract import extract,mz
from verify import verify,check_hashes
from capstone import Cs,CS_ARCH_X86,CS_MODE_16
HERE=Path(__file__).resolve().parent
OUT=ROOT/'build/swap_unit'
RESULTS=HERE/'results'
PREFIX=0x200
ENTRY,END=0x9cf1,0x9d4d

def listing(data,start=0):
    return [dict(address=n.address,hex=n.bytes.hex(),instruction=n.mnemonic+' '+n.op_str) for n in Cs(CS_ARCH_X86,CS_MODE_16).disasm(data,start)]

def boundary():
    g=read_json(ROOT/'metadata/runtime/main-analysis.json');ns=g['nodes']
    owned={a for a,n in ns.items() if ENTRY<=n['linear']<END}
    assert len(owned)==22
    incoming=[dict(source=a,target=t,kind=kind) for a,n in ns.items() if a not in owned for kind in ('calls','successors') for t in n[kind] if t in owned]
    assert incoming==[dict(source='0000:9BDF',target='0000:9CF1',kind='calls')],incoming
    assert not [(a,t) for a in owned for t in ns[a]['calls']+ns[a]['successors'] if t not in owned]
    image,_=extract()
    assert sha(image[ENTRY:END])=='36ae000084d54f5f54c64df9790828fe78a18df4dc6c9fa60fe7306d1e2082be'
    row=dict(unit='AdvancePositionHistoryIfRequested',domain='GAME_LOGIC',entry='0000:9CF1',end_exclusive='0000:9D4D',bytes=END-ENTRY,instructions=22,incoming=incoming,
        exits=['near RET at 9CFF','near RET at 9D4C'],external_effects=[],
        live_inputs=['DS:98BE low nibble','DS:A360 word','four DS:A33A..A340 word cursors','SS:SP near return address'],
        observable_outputs=['all general/segment registers preserved','SP +2 at near RET','same return continuation','ordered cursor writes','control flags preserved'],
        dead_outputs=['CF PF AF ZF SF OF overwritten by 9CD9 ADD before any use on reviewed continuation'],
        preconditions=['normal entry via reviewed 9BDF caller','valid stack scratch disjoint from cursor/input/adjustment/code cells','replacement requires 64 free stack bytes; original caller stack capacity remains an explicit integration obligation','no asynchronous mutation of these cells during operation; interleaving coverage is not claimed'],
        cursor_domain='48 aligned ring values; equality-only wrap retained for every 16-bit input value, without invented bounds',
        closure_scope='All decoded incoming edges checked. Unknown executable bytes/unresolved indirect targets preclude a global closure theorem.',
        graph_sha256=sha((ROOT/'metadata/runtime/main-analysis.json').read_bytes()),original_sha256=sha(image[ENTRY:END]),original_listing=listing(image[ENTRY:END],ENTRY))
    write_json(RESULTS/'boundary.json',row);return row

def compile_piece():
    spec=importlib.util.spec_from_file_location('prior_c_build',ROOT/'research/c_matching/build.py')
    helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
    for row in read_json(ROOT/'research/c_matching/toolchain-lock.json')['files']:
        assert sha((ROOT/row['path']).read_bytes())==row['sha256'],row['path']
    folder=OUT/'compile';folder.mkdir(parents=True,exist_ok=True)
    for name in ('HISTORY.C','BRIDGE.ASM'):
        (folder/name).write_bytes((HERE/name).read_text().replace('\n','\r\n').encode('ascii'))
    for name in ('HISTORY.OBJ','HISTORY.ASM','BRIDGE.OBJ','PIECE.EXE','PIECE.MAP'):(folder/name).unlink(missing_ok=True)
    flags=['-c','-ms','-1-','-f-','-N-','-O','-Z','-G-']
    (folder/'compile.log').write_text(helper.run('TCC.EXE',flags+['HISTORY.C'],folder))
    (folder/'listing.log').write_text(helper.run('TCC.EXE',[f for f in flags if f!='-c']+['-S','HISTORY.C'],folder))
    (folder/'bridge.log').write_text(dos('TASM.EXE',['/ml','BRIDGE.ASM,BRIDGE.OBJ,BRIDGE.LST'],folder))
    (folder/'link.log').write_text(dos('TLINK.EXE',['/m','/s','BRIDGE.OBJ+HISTORY.OBJ,PIECE.EXE,PIECE.MAP,,'],folder))
    h,image,rel,_=mz((folder/'PIECE.EXE').read_bytes());assert not rel,rel
    pubs={n.lower():int(s,16)*16+int(o,16) for s,o,n in re.findall(r'^ ([0-9A-F]{4}):([0-9A-F]{4})\s+_([A-Z_0-9]+)\s*$',(folder/'PIECE.MAP').read_text(),re.M)}
    assert set(('launch','main_segment','bridge','bridge_end','advance_history'))<=pubs.keys(),pubs
    assert len(image)<=PREFIX and pubs['launch']==0
    body=image[pubs['advance_history']:]
    info=dict(compiler='Turbo C 2.0',flags=flags,abi='near cdecl, explicit far data pointer, no CRT',publics=pubs,piece_bytes=len(image),bridge_bytes=pubs['bridge_end']-pubs['bridge'],body_bytes=len(body),
        body_listing=listing(body,pubs['advance_history']),bridge_listing=listing(image[pubs['bridge']:pubs['bridge_end']],pubs['bridge']),clean_source_sha256=sha((HERE/'HISTORY.C').read_bytes()),body_sha256=sha(body),prefix_bytes=PREFIX)
    write_json(RESULTS/'compiled.json',info);return image,pubs,info

def container_checksum(data):
    # Authentic checksum at C8D5/C916..C91F; C938..C94C removes footer updates.
    value=0x1234
    for byte in data:
        value=(value+byte)&65535
        value=(value&255)|((((value>>8)+(value&255))&255)<<8)
    return value

def package(mode,main,piece,pubs,manifest):
    image=bytearray(piece.ljust(PREFIX,b'\0')+main);reloc=[pubs['main_segment']]
    for site in manifest['relocations']:
        p=PREFIX+site;struct.pack_into('<H',image,p,(struct.unpack_from('<H',image,p)[0]+PREFIX//16)&65535);reloc.append(p)
    if mode=='C':
        image[PREFIX+ENTRY:PREFIX+ENTRY+6]=b'\x9a'+struct.pack('<HH',pubs['bridge'],0)+b'\xc3'
        reloc.append(PREFIX+ENTRY+3)
    header=bytearray(0x220);size=len(header)+len(image);assert len(reloc)*4+28<=len(header)
    vals=[0x5a4d,size%512,(size+511)//512,len(reloc),len(header)//16,0,0xffff,PREFIX//16+0x15bc,0xa278,0,0,0,28,0]
    struct.pack_into('<14H',header,0,*vals)
    for i,p in enumerate(reloc):struct.pack_into('<HH',header,28+4*i,p%16,p//16)
    original=(ROOT/'assets/OVERKILL').read_bytes()
    assert container_checksum(original[:-2])==struct.unpack('<H',original[-2:])[0]
    from resources import resources
    _,rows=resources()
    assert max(r['offset']+r['size'] for r in rows)<=len(original)-2
    overlay=mz(original)[3];payload=bytes(header+image)+overlay[:-2]
    checksum=container_checksum(payload);raw=payload+struct.pack('<H',checksum)
    folder=OUT/mode.lower();folder.mkdir(parents=True,exist_ok=True)
    (folder/'OVERKILL').write_bytes(raw);(folder/'PLAY.EXE').write_bytes(raw)
    shutil.copyfile(ROOT/'assets/OVERKILL.EXE',folder/'OVERKILL.EXE')
    normalized=bytearray(image[PREFIX:])
    for site in manifest['relocations']:struct.pack_into('<H',normalized,site,(struct.unpack_from('<H',normalized,site)[0]-PREFIX//16)&65535)
    changes=[i for i,(a,b) in enumerate(zip(normalized,main)) if a!=b]
    assert not changes if mode=='ASM' else all(ENTRY<=i<ENTRY+6 for i in changes)
    desc=dict(mode=mode,path=str((folder/'PLAY.EXE').relative_to(ROOT)),sha256=sha(raw),image_bytes=len(image),mz_relocations=len(reloc),main_cs_relative=PREFIX//16,main_normalized_changed_offsets=changes,prefix_sha256=sha(image[:PREFIX]),original_overlay_sha256=sha(overlay),resource_payload_sha256=sha(overlay[:-2]),container_checksum=checksum,checksum_rule='C8D5,C916..C91F,C938..C94C; recomputed final two bytes outside every resource',
        launcher_companion='Pinned original OVERKILL.EXE is read by startup integrity code; PLAY.EXE executes rebuilt main, never packed game code.')
    write_json(folder/'manifest.json',desc);return desc

def build(mode='both',verify_exact=True):
    write_json(RESULTS/'build.json',dict(status='RUNNING_OR_FAILED'))
    check_hashes('inputs.json');check_hashes('toolchain-lock.json');boundary()
    if verify_exact:verify()
    main=(ROOT/'build/program.bin').read_bytes();oracle,m=extract();assert main==oracle
    piece,pubs,info=compile_piece()
    builds=[package(v,main,piece,pubs,m) for v in (['ASM','C'] if mode=='both' else [mode])]
    result=dict(status='PASS',original_main_sha256=sha(main),production_unchanged=True,builds=builds)
    write_json(RESULTS/'build.json',result)
    print('PASS research native MZ build',mode,info['body_bytes'],'C bytes',info['bridge_bytes'],'bridge bytes',flush=True)
    return result

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--implementation',choices=['ASM','C','both'],default='both');a=p.parse_args();build(a.implementation)
