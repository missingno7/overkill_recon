"""Second explicit swap cluster; shared code is DOS packaging, not a compiler DSL."""
import sys,importlib.util,re,struct,argparse
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
sys.path.insert(0,str(ROOT/'research/swap_unit'))
import build_swap as first
from build_swap import read_json,write_json,sha,mz,dos,extract,listing,check_hashes
HERE=Path(__file__).resolve().parent
OUT=ROOT/'build/history_transfer'
RESULTS=HERE/'results'
PREFIX=0x400
MODES=('aa','ac','ca','cc') # advance then transfer

def boundary():
    g=read_json(ROOT/'metadata/runtime/main-analysis.json');ns=g['nodes']
    ranges=((0x9be2,0x9be8),(0x9cd9,0x9cf1),(0xa031,0xa060))
    owned={a for a,n in ns.items() if any(lo<=n['linear']<hi for lo,hi in ranges)}
    incoming=[(a,t,k) for a,n in ns.items() if a not in owned for k in ('calls','successors') for t in n[k] if t in owned]
    assert {t for a,t,k in incoming}=={'0000:9BE2'},incoming
    assert {a for a,t,k in incoming}=={'0000:978C','0000:9BDF','0000:CFF0','0000:D171'}
    outside=[(a,t,k) for a in sorted(owned) for k in ('calls','successors') for t in ns[a][k] if t not in owned]
    assert outside==[('0000:9BE5','0000:9BE8','successors')],outside
    image,_=extract();assert len(owned)==28
    result=dict(name='StoreAndApplyPositionHistory',entry='0000:9BE2',continuation='0000:9BE8',incoming=incoming,outside_edges=outside,instructions=len(owned),bytes=sum(hi-lo for lo,hi in ranges),
        ranges=[dict(start=lo,end=hi,sha256=sha(image[lo:hi]),listing=listing(image[lo:hi],lo)) for lo,hi in ranges],
        live_inputs=['SS:BP source record','DS cursors A33A/A33C/A33E and selections A962/A964','CS:9596 write segment','BX/SI incoming values when no delayed transfer'],
        outputs=['ordered biased position store, then zero/one/two ordered delayed copies','AX last loaded X; DI initial write cursor+4; ES fromCS:9596','BX/SI last delayed record and read end, or preserved if none','CX/DX/BP/DS/SS/SP preserved at fallthrough boundary'],
        flags='Arithmetic flags killed by next CMP at9BE8; control flags preserved',
        preconditions=['DF=0 from original startup95D3; backwards traversal is NOT represented by this semantic unit','valid source/destination/selected pointers; synthetic alias cases retain sequential reads and writes','private call stack and transfer-progress object do not alias game data','no asynchronous mutation of state cells during transfer'],
        closure='Known decoded graph, not all unknown bytes or unresolved indirect targets',scope='one added research unit; no production changes')
    write_json(RESULTS/'boundary.json',result);return result

def build():
    write_json(RESULTS/'build.json',dict(status='RUNNING_OR_FAILED'))
    check_hashes('inputs.json');check_hashes('toolchain-lock.json');boundary()
    main=(ROOT/'build/program.bin').read_bytes();original,m=extract();assert main==original
    folder=OUT/'compile';folder.mkdir(parents=True,exist_ok=True)
    files={'HISTORY.C':(ROOT/'research/swap_unit/HISTORY.C').read_text(),
        'BRIDGE.ASM':(ROOT/'research/swap_unit/BRIDGE.ASM').read_text().replace('dw 20h','dw 40h'),
        'TRANSFER.C':(HERE/'TRANSFER.C').read_text(),'TRANSFER.ASM':(HERE/'TRANSFER.ASM').read_text()}
    for n,s in files.items():(folder/n).write_bytes(s.replace('\n','\r\n').encode('ascii'))
    spec=importlib.util.spec_from_file_location('prior_c_build',ROOT/'research/c_matching/build.py');helper=importlib.util.module_from_spec(spec);spec.loader.exec_module(helper)
    for row in read_json(ROOT/'research/c_matching/toolchain-lock.json')['files']:assert sha((ROOT/row['path']).read_bytes())==row['sha256']
    flags=['-c','-ms','-1-','-f-','-N-','-O','-Z','-G-']
    for name in ('HISTORY','TRANSFER'):
        (folder/(name+'.OBJ')).unlink(missing_ok=True)
        (folder/(name+'.compile.log')).write_text(helper.run('TCC.EXE',flags+[name+'.C'],folder))
        (folder/(name+'.listing.log')).write_text(helper.run('TCC.EXE',[f for f in flags if f!='-c']+['-S',name+'.C'],folder))
    # Compiler listing TRANSFER.ASM is generated; keep the hand-written bridge distinct.
    (folder/'ADAPTER.ASM').write_bytes(files['TRANSFER.ASM'].replace('\n','\r\n').encode('ascii'))
    for name in ('BRIDGE','ADAPTER'):
        (folder/(name+'.OBJ')).unlink(missing_ok=True)
        (folder/(name+'.asm.log')).write_text(dos('TASM.EXE',['/ml',name+'.ASM,'+name+'.OBJ,'+name+'.LST'],folder))
    for n in ('PIECE.EXE','PIECE.MAP'):(folder/n).unlink(missing_ok=True)
    (folder/'link.log').write_text(dos('TLINK.EXE',['/m','/s','BRIDGE.OBJ+ADAPTER.OBJ+HISTORY.OBJ+TRANSFER.OBJ,PIECE.EXE,PIECE.MAP,,'],folder))
    _,piece,rel,_=mz((folder/'PIECE.EXE').read_bytes());assert not rel;assert len(piece)<=PREFIX
    pubs={n.lower():int(s,16)*16+int(o,16) for s,o,n in re.findall(r'^ ([0-9A-F]{4}):([0-9A-F]{4})\s+_([A-Z_0-9]+)\s*$',(folder/'PIECE.MAP').read_text(),re.M)}
    assert set(('store_apply','transfer_bridge','transfer_bridge_end','bridge','main_segment'))<=pubs.keys()
    info=dict(compiler='Turbo C2.0',flags=flags,prefix_bytes=PREFIX,publics=pubs,piece_bytes=len(piece),
        body_bytes=len(piece)-pubs['store_apply'],body_listing=listing(piece[pubs['store_apply']:],pubs['store_apply']),
        bridge_bytes=pubs['transfer_bridge_end']-pubs['transfer_bridge'],bridge_listing=listing(piece[pubs['transfer_bridge']:pubs['transfer_bridge_end']],pubs['transfer_bridge']))
    write_json(RESULTS/'compiled.json',info)
    builds=[]
    for mode in MODES:
        gates=[]
        if mode[0]=='c':gates.append((0x9cf1,pubs['bridge'],'near_return'))
        if mode[1]=='c':gates.append((0x9be2,pubs['transfer_bridge'],'fallthrough'))
        builds.append(first.package(mode,main,piece,pubs,m,prefix_bytes=PREFIX,folder=OUT/mode,gates=gates))
    result=dict(status='PASS',builds=builds,mode_order=['advance','transfer'],production_main_sha256=sha(main),body_bytes=info['body_bytes'],bridge_bytes=info['bridge_bytes'])
    write_json(RESULTS/'build.json',result);print('PASS four native packages',info['body_bytes'],'C bytes',info['bridge_bytes'],'bridge bytes',flush=True)
    return result
if __name__=='__main__':build()
