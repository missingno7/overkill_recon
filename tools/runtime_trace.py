"""Post-filter a complete write journal against initial and actually executed bytes.
The compressed journal is the lossless record, including unchanged writes.
"""
from common import *
from runtime_machine import HEAD
import gzip,struct,argparse,collections

def records(path):
    with gzip.open(path,'rb') as f:
        while header:=f.read(HEAD.size):
            if len(header)!=HEAD.size:raise ValueError('Truncated write header')
            seq,cs,ip,addr,size,origin=HEAD.unpack(header);old=f.read(size);new=f.read(size)
            if len(new)!=size:raise ValueError('Truncated write body')
            yield seq,cs,ip,addr,old,new,origin

def report(folder,quiet=False):
    state=read_json(folder/'state.json');a=state['checkpoints']['oracle-a']['sequence'];mask=bytearray((folder/'executed-mask.bin').read_bytes());initial=set()
    for n in read_json(ROOT/'metadata/analysis.json')['nodes'].values():
        for i in range(0x10100+n['linear'],0x10100+n['linear']+n['size']):mask[i]=1;initial.add(i)
    # The driver slot has versioned identity. Its cold stub's former instructions
    # can become mutable header DATA; don't call those recurring SMC.
    live_mask=bytearray(mask);modules=state.get('module_loads',[])
    if modules:
        live_mask[0x20320:0x25440]=bytes(0x5120)
        da=read_json(ROOT/'metadata/drivers'/f"{state['sound']}-analysis.json")
        for n in da['nodes'].values():live_mask[0x20320+n['linear']:0x20320+n['linear']+n['size']]=b'\1'*n['size']
        observed=(folder/'executed-mask.bin').read_bytes()
        for p in range(0x20320,0x25440):
            if observed[p]:live_mask[p]=1
        for p in range(len(mask)):
            if live_mask[p]:mask[p]=1
    frontier=state['checkpoints'].get('frontier-9690',{}).get('sequence')
    live=ROOT/'metadata/runtime/main-analysis.json'
    if live.exists():
        for n in read_json(live)['nodes'].values():
            lo=0x10100+n['linear'];hi=lo+n['size'];live_mask[lo:hi]=b'\1'*n['size'];mask[lo:hi]=b'\1'*n['size']
    groups=[];stats=collections.Counter();last=None;slot=[];vector_writes=[];post=[]
    for seq,cs,ip,addr,old,new,origin in records(folder/'writes.bin.gz'):
        if addr<0x1601b and addr+len(new)>0x15f42:slot.append(dict(sequence=seq,writer=f'{cs:04X}:{ip:04X}',destination=addr,size=len(new),old=old.hex(),new=new.hex(),phase='before-A' if seq<a else 'after-A'))
        if seq>=a and addr<1024:vector_writes.append(dict(sequence=seq,writer=f'{cs:04X}:{ip:04X}',destination=addr,old_hex=old.hex(),new_hex=new.hex(),classification='INTERRUPT_VECTOR_INSTALLATION'))
        if frontier and seq>frontier and any(live_mask[addr:addr+len(new)]):
            stats['post_frontier_executable_write_attempts']+=1
            count=sum(x!=y and bool(live_mask[addr+i]) for i,(x,y) in enumerate(zip(old,new)))
            stats['post_frontier_changed_executable_bytes']+=count
            if count:post.append(dict(sequence=seq,writer=f'{cs:04X}:{ip:04X}',destination=addr,old_hex=old.hex(),new_hex=new.hex()))
        if not any(mask[addr:addr+len(new)]):continue
        phase='UNPACK_RELOCATION_MATERIALIZATION' if seq<a else 'UNCLASSIFIED_AFTER_A'
        if seq>=a and modules:
            load=modules[0];lo=load['segment']*16+load['offset'];hi=lo+load['size']
            if addr<hi and addr+len(new)>lo and seq<=load['sequence']:phase='OPTIONAL_MODULE_LOAD'
            elif lo<=addr<hi and not any(live_mask[addr:addr+len(new)]):phase='RETIRED_CODE_NOW_DATA'
        stats[phase+'_writes']+=1
        changes=[i for i,(o,n) in enumerate(zip(old,new)) if o!=n and mask[addr+i]]
        stats[phase+'_changed_executable_bytes']+=len(changes)
        if not changes:continue
        row=dict(first_sequence=seq,last_sequence=seq,writer=f'{cs:04X}:{ip:04X}',destination_start=addr,destination_end=addr+len(new),destination_canonical_segment=addr>>4,destination_canonical_offset=addr&15,old_hex=old.hex(),new_hex=new.hex(),write_count=1,classification=phase,origin={0:'CPU',1:'DOS_BIOS_HOST',2:'IRQ_ENTRY'}[origin],changed_watched_bytes=len(changes))
        if last and row['writer']==last['writer'] and row['classification']==last['classification'] and seq-last['last_sequence']<=100 and (addr==last['destination_end'] or addr+len(new)==last['destination_start']):
            if addr==last['destination_end']:last['old_hex']+=old.hex();last['new_hex']+=new.hex();last['destination_end']+=len(new)
            else:last['old_hex']=old.hex()+last['old_hex'];last['new_hex']=new.hex()+last['new_hex'];last['destination_start']=addr
            last['last_sequence']=seq;last['write_count']+=1;last['changed_watched_bytes']+=len(changes)
        else:groups.append(row);last=row
    for g in groups:
        g['destination_canonical_segment']=g['destination_start']>>4;g['destination_canonical_offset']=g['destination_start']&15
    result=dict(profile=state['video']+'-'+state['sound'],stop_reason=state['reason'],sequence=state['sequence'],oracle_a_sequence=a,watch_definition='union of conservative initial static CFG and instruction bytes observed anywhere after A in this run; includes writes before first execution; not proof about unexecuted code',statistics=dict(stats),events=groups,slot_5e42=slot,vector_writes=vector_writes,post_frontier_changed_writes=post)
    write_json(folder/'runtime-code-writes.json',result)
    if quiet:return result
    print(result['profile'],dict(stats),'groups',len(groups),'slot',len(slot))
    for g in groups:
        if g['classification']=='UNCLASSIFIED_AFTER_A':print(g['first_sequence'],g['writer'],hex(g['destination_start']),hex(g['destination_end']),g['write_count'],g['changed_watched_bytes'])
    return result
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('folder',type=Path);a=p.parse_args();report(a.folder)
