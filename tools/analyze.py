"""Recursive 16-bit CFG discovery. Unreached bytes stay explicitly unknown.
Function entries are candidates, never a partition inferred from prologues.
"""
from common import *
from extract import extract
from capstone import *
from capstone.x86 import *
from collections import defaultdict,deque
import re

def analyze(image=None,m=None,seeds=None,output=None,excluded=(),quiet=False,observed=None):
    if image is None:image,m=extract()
    md=Cs(CS_ARCH_X86,CS_MODE_16); md.detail=True
    pending=deque([(m['entry_cs'],m['entry_ip'],'unpacked_entry')]+list(seeds or [])+list(observed or [])); nodes={}; entries={}; conflicts=[]; tables=[]; vectors=[]
    def key(cs,ip): return f'{cs:04X}:{ip:04X}'
    def enqueue(cs,ip,why,entry=False):
        ip&=65535
        if 0<=cs*16+ip<len(image) and not any(lo<=cs*16+ip<hi for lo,hi in excluded):
            pending.append((cs,ip,why))
            if entry: entries.setdefault(key(cs,ip),set()).add(why)
    entries[key(m['entry_cs'],m['entry_ip'])]={'unpacked_entry'}
    for cs,ip,why in seeds or []:entries.setdefault(key(cs,ip),set()).add(why)
    while pending:
        cs,ip,why=pending.popleft(); k=key(cs,ip)
        if k in nodes: continue
        linear=cs*16+ip
        if any(lo<=linear<hi for lo,hi in excluded):continue
        ins=next(md.disasm(image[linear:linear+15],ip,count=1),None)
        if ins is None:
            conflicts.append({'address':k,'reason':'undecodable reachable byte'}); continue
        if ins.mnemonic in ('int3','ud2','hlt'):
            conflicts.append({'address':k,'reason':'unusual reachable instruction','text':ins.mnemonic})
        try: reads,writes=ins.regs_access()
        except CsError: reads,writes=[],[]
        mem=[]
        for op in ins.operands:
            if op.type==X86_OP_MEM:
                mm=op.mem
                mem.append(dict(segment=ins.reg_name(mm.segment) or 'default',base=ins.reg_name(mm.base),index=ins.reg_name(mm.index),scale=mm.scale,displacement=mm.disp,size=op.size,access=op.access))
        node=dict(address=k,segment=cs,offset=ip,linear=linear,size=ins.size,hex=ins.bytes.hex(),
                  mnemonic=ins.mnemonic,operands=ins.op_str,registers_read=[ins.reg_name(r) for r in reads],
                  registers_written=[ins.reg_name(r) for r in writes],memory=mem,successors=[],calls=[],unresolved=[])
        is_call=ins.group(CS_GRP_CALL); is_jump=ins.group(CS_GRP_JUMP) or ins.mnemonic.startswith('loop')
        far=ins.mnemonic in ('lcall','ljmp')
        if is_call or is_jump:
            dest=None
            if far and len(ins.operands)==2 and all(o.type==X86_OP_IMM for o in ins.operands):
                dest=(ins.operands[0].imm,ins.operands[1].imm)
            elif len(ins.operands)==1 and ins.operands[0].type==X86_OP_IMM:
                dest=(cs,ins.operands[0].imm&65535)
            if dest:
                dkey=key(*dest)
                node['calls' if is_call else 'successors'].append(dkey)
                enqueue(*dest,f'{"call" if is_call else "branch"} from {k}',entry=is_call)
            else:
                node['unresolved'].append('indirect_call' if is_call else 'indirect_jump')
                # Reviewed finite count dispatch: normal entry9C01 clears AX at9C35,
                # calls INC AH twice and INC AL twice conditionally, then BX=2*(AL+3*AH).
                # Exact guard prevents applying this proof to another module/version.
                if cs==0 and ip==0x9c6b and image[0x9bfb:0x9c01]==bytes.fromhex('fec4c3fec0c3') and image[0x9c35:0x9c70]==bytes.fromhex('33c0833e66a9ff7403e8baff833e68a9ff7403e8b3ff833e6aa9ff7403e8a6ff833e6ca9ff7403e89fff8ad832ff02dc02dc02dcd1e32effa7709c'):
                    targets=[key(0,int.from_bytes(image[0x9c70+2*i:0x9c72+2*i],'little')) for i in range(9)]
                    node['unresolved'].clear();node['successors'].extend(sorted(set(targets)))
                    node['resolved_candidates']=targets
                    for target in sorted(set(targets)):enqueue(0,int(target[5:],16),'proved count dispatch from '+k)
                    tables.append(dict(start=0x9c70,end=0x9c82,kind='near_code_pointer_table',entries=targets,site=k,confidence='PROVEN',exhaustive=True,evidence='metadata/record-movement.json; two conditional increments each of initially zero AH and AL give index AL+3*AH in0..8',precondition='normal entry through9C01/9C35; no arbitrary mid-block entry or asynchronous register corruption'))
                # A measured recurring selector dispatch. Keep unresolved status:
                # 0..2 is supported at startup, not a proof of all later writes.
                if cs==0 and image[linear-7:linear]==bytes.fromhex('2e8b1ebc95d1e3') and len(ins.operands)==1 and ins.operands[0].type==X86_OP_MEM:
                    mm=ins.operands[0].mem
                    if mm.segment==X86_REG_CS and mm.base==X86_REG_BX and not mm.index:
                        table=mm.disp&65535
                        targets=[]
                        for i in range(3):
                            off=int.from_bytes(image[table+2*i:table+2*i+2],'little')
                            targets.append(key(cs,off));enqueue(cs,off,f'selector table at {table:04X} referenced by {k}',entry=True)
                        node['calls' if is_call else 'successors'].extend(targets)
                        node['resolved_candidates']=targets
                        tables.append(dict(start=table,end=table+6,kind='near_code_pointer_table',entries=targets,site=k,confidence='STRONG',exhaustive=False,evidence='Exact load CS:95BC / SHL BX,1 / CS indirect transfer; startup 9619 limits selector to 0..2.'))
        terminal=ins.group(CS_GRP_RET) or ins.group(CS_GRP_IRET) or ins.mnemonic in ('jmp','ljmp','hlt','ud2')
        if not terminal:
            nxt=(cs,(ip+ins.size)&65535); node['successors'].append(key(*nxt)); enqueue(*nxt,f'fallthrough from {k}')
        if ins.mnemonic=='int' and ins.op_str=='0x21' and image[linear-9:linear-5]==bytes.fromhex('1e0e1fba') and image[linear-3]==0xb8 and image[linear-1]==0x25:
            off=int.from_bytes(image[linear-5:linear-3],'little');vector=image[linear-2]
            enqueue(cs,off,f'INT 21h/25{vector:02X} installs DS=CS at {k}',entry=True)
            vectors.append(dict(vector=vector,handler=key(cs,off),site=k,confidence='PROVEN'))
        nodes[k]=node
    # Detect physical conflicts; segment aliases are retained in the graph.
    occupied={}
    for n in nodes.values():
        for p in range(n['linear'],n['linear']+n['size']):
            old=occupied.get(p)
            if old is not None and old!=n['linear']: conflicts.append({'linear':p,'reason':'overlapping instruction starts'})
            occupied[p]=n['linear']
    functions=[]; owners=defaultdict(list)
    for entry,ev in sorted(entries.items()):
        todo=[entry]; visited=set(); calls=set(); tails=set(); unresolved=[]
        while todo:
            k=todo.pop()
            if k in visited or k not in nodes: continue
            if k!=entry and k in entries: tails.add(k); continue
            visited.add(k); n=nodes[k]; calls.update(n['calls']); unresolved.extend(n['unresolved']); todo.extend(n['successors'])
        for k in visited: owners[k].append(entry)
        regs_r=set();regs_w=set();memory=[];hardware=[]
        for k in sorted(visited):
            n=nodes[k]; regs_r.update(n['registers_read']);regs_w.update(n['registers_written'])
            memory.extend([dict(instruction=k,**a) for a in n['memory']])
            if n['mnemonic'] in ('int','in','out','insb','insw','outsb','outsw','cli','sti','iret'): hardware.append(k)
        category='HARDWARE' if hardware else ('STRUCTURAL' if unresolved or tails else 'UNKNOWN')
        functions.append(dict(address=entry,name='sub_'+entry.replace(':','_'),named=False,
            evidence=sorted(ev),confidence=dict(boundary='INFERRED',operation='UNKNOWN',semantic_name='UNKNOWN',gameplay_role='UNKNOWN'),
            instructions=sorted(visited),instruction_bytes=sum(nodes[k]['size'] for k in visited),callees=sorted(calls),tail_targets=sorted(tails),
            callers=[],unresolved=unresolved,leaf=not calls and not unresolved and not tails,
            category=category,registers_read=sorted(regs_r),registers_written=sorted(regs_w),memory=memory,hardware=hardware))
    byaddr={f['address']:f for f in functions}
    for f in functions:
        for k in f['callees']+f['tail_targets']:
            if k in byaddr: byaddr[k]['callers'].append(f['address'])
    for f in functions:
        f['callers']=sorted(set(f['callers']))
        f['shared_instructions']=[k for k in f['instructions'] if len(owners[k])>1]
        if f['shared_instructions'] and f['category']=='UNKNOWN':f['category']='ASM_COUPLED'
    code_bytes=set(occupied); regions=[]; start=0
    for p in range(1,len(image)+1):
        if p==len(image) or ((p in code_bytes)!=(start in code_bytes)):
            regions.append(dict(start=start,end=p,kind='reachable_instruction' if start in code_bytes else 'UNKNOWN',confidence='INFERRED' if start in code_bytes else 'UNKNOWN'));start=p
    strings=[]
    for match in re.finditer(rb'[\x20-\x7e]{6,}',image):
        if not any(p in code_bytes for p in range(match.start(),match.end())):
            strings.append(dict(start=match.start(),end=match.end(),text=match.group().decode('ascii'),confidence='CANDIDATE'))
    result=dict(schema=1,image_sha256=m['program_sha256'],image_bytes=len(image),entry=f"{m['entry_cs']:04X}:{m['entry_ip']:04X}",
                nodes=nodes,functions=functions,regions=regions,strings=strings,tables=tables,vectors=vectors,conflicts=conflicts,
                unresolved=[dict(address=k,kind=t) for k,n in nodes.items() for t in n['unresolved']])
    write_json(output or ROOT/'metadata'/'analysis.json',result)
    if quiet:return result
    print('instructions',len(nodes),'unique code bytes',len(code_bytes),'functions',len(functions),'conflicts',len(conflicts))
    for f in sorted((f for f in functions if f['leaf']),key=lambda f:len(f['instructions']))[:35]:
        print(f['address'],len(f['instructions']),' ; '.join(nodes[k]['mnemonic']+' '+nodes[k]['operands'] for k in f['instructions']))
    return result
if __name__=='__main__': analyze()
