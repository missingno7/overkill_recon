"""Actual four MZ variants, ordered alias-sensitive transfers, no C model in tester."""
from build_transfer import *
import random,itertools
from unicorn import *
from unicorn.x86_const import *
REGS={r:globals()['UC_X86_REG_'+r] for r in ('AX','BX','CX','DX','SI','DI','BP','SP','CS','DS','ES','SS','IP','EFLAGS')}
LOAD=0x1010;MAIN=LOAD+PREFIX//16;ARITH=0x8d5
TEMPLATE=bytes((i*29+17)&255 for i in range(65540))
class Probe:
    def __init__(self,mode):
        self.mode=mode;self.u=Uc(UC_ARCH_X86,UC_MODE_16);self.u.mem_map(0,0x100000)
        _,image,rel,_=mz((OUT/mode/'PLAY.EXE').read_bytes());image=bytearray(image)
        for p in rel:struct.pack_into('<H',image,p,(struct.unpack_from('<H',image,p)[0]+LOAD)&65535)
        self.u.mem_write(LOAD*16,bytes(image));self.events=[];self.coverage=set();self.deepest=0
        self.u.hook_add(UC_HOOK_MEM_WRITE,self.write);self.u.hook_add(UC_HOOK_CODE,self.code)
        self.u.hook_add(UC_HOOK_INTR,self.fail)
        self.u.hook_add(UC_HOOK_INSN,self.fail,None,1,0,UC_X86_INS_IN)
        self.u.hook_add(UC_HOOK_INSN,self.fail,None,1,0,UC_X86_INS_OUT)
    def fail(self,*args):raise AssertionError('Unexpected external effect')
    def state(self):return {r:self.u.reg_read(v) for r,v in REGS.items()}
    def code(self,u,address,size,_):
        if address==getattr(self,"stop",None):u.emu_stop();return
        self.coverage.add(address)
    def write(self,u,access,address,size,value,_):
        top=self.ss*16+self.sp
        if top-64<=address and address+size<=top:
            self.deepest=max(self.deepest,top-address)
        else:
            assert any(seg*16<=address and address+size<=seg*16+65540 for seg in self.segs),('unexpected write',hex(address))
            self.events.append((address,size,value&((1<<(8*size))-1)))
    def prepare(self,c):
        self.ds=0x4000;self.ss=0x6000 if c['separate'] else self.ds;self.out=0x8000 if c['out_separate'] else self.ds
        self.segs=sorted({self.ds,self.ss,self.out});self.sp=0xf000
        for seg in self.segs:self.u.mem_write(seg*16,TEMPLATE)
        def word(seg,off,value):self.u.mem_write(seg*16+off,struct.pack('<H',value&65535))
        self.u.mem_write(MAIN*16+0x9596,struct.pack('<H',self.out))
        for off,v in zip((0xa33a,0xa33c,0xa33e,0xa340),c['cursors']):word(self.ds,off,v)
        for off,v in zip((0xa962,0xa964),c['slots']):word(self.ds,off,v)
        for seg,off,value in c['writes']:word({'ds':self.ds,'ss':self.ss,'out':self.out}[seg],off,value)
        word(self.ds,0xa360,c.get('adjust',0));self.u.mem_write(self.ds*16+0x98be,bytes([c.get('bits',0)]))
        seed=c['seed'];vals=dict(AX=seed&65535,BX=seed*23&65535,CX=seed*47&65535,DX=seed*53&65535,SI=seed*19&65535,DI=seed*31&65535,BP=0x237c,SP=self.sp,DS=self.ds,SS=self.ss,ES=0x7000,CS=MAIN,IP=c['entry'],EFLAGS=(0x202,0x203,0xa96,0x246)[seed%4])
        for r,v in vals.items():self.u.reg_write(REGS[r],v)
        self.events=[]
    def run(self,entry):
        self.stop=MAIN*16+0x9be8
        self.u.emu_start(MAIN*16+entry,0,count=1500)
        s=self.state();assert s['CS']==MAIN and s['IP']==0x9be8,s
        # Next original CMP kills all arithmetic flags; single-instruction step.
        self.stop=MAIN*16+0x9bed
        self.u.emu_start(MAIN*16+0x9be8,0,count=10)
        assert self.state()["IP"]==0x9bed
        return s,self.state(),list(self.events),self.memory()
    def memory(self):
        result=[]
        for seg in self.segs:
            b=bytearray(self.u.mem_read(seg*16,65540))
            if seg==self.ss:b[self.sp-64:self.sp]=bytes(64)
            result.append(bytes(b))
        return result

def case(seed=0,entry=0x978c):
    return dict(seed=seed,entry=entry,separate=False,out_separate=False,cursors=[0xa27a,0xa2fe,0xa2be,0xa27e],slots=[0x3000,0x3040],writes=[('ss',0x237e,seed),('ss',0x2380,seed*7)])

def compare(probes,c):
    results=[]
    for p in probes:p.prepare(c);results.append(p.run(c['entry']))
    for p,(before,after,events,mem) in zip(probes[1:],results[1:]):
        ref=results[0]
        for r in REGS:
            mask=0xffffffff^ARITH if r=='EFLAGS' else 0xffffffff
            assert before[r]&mask==ref[0][r]&mask,(p.mode,'boundary',r,before[r],ref[0][r],c)
        assert after==ref[1],(p.mode,'after CMP',after,ref[1],c)
        assert events==ref[2],(p.mode,'ordered writes',events,ref[2],c)
        assert mem==ref[3],(p.mode,'memory',c)

def verify():
    write_json(RESULTS/'differential.json',dict(status='RUNNING_OR_FAILED'))
    probes={m:Probe(m) for m in MODES};counts={};n=0
    # Three authentic CALL edges plus fallthrough from the previous swap unit.
    for entry in (0x978c,0xcff0,0xd171,0x9bdf):
      for phase in range(48):
       for mask in range(4):
        for separate,out_separate in itertools.product((False,True),repeat=2):
         c=case(n,entry);c.update(separate=separate,out_separate=out_separate)
         c['cursors']=[0xa27a+4*((phase+lag)%48) for lag in (0,33,17,1)]
         c['slots']=[0x3000 if mask&1 else 65535,0x3040 if mask&2 else 65535]
         c['bits']=n%256;c['adjust']=n%3
         compare(list(probes.values()),c);n+=1
    counts['four_edges_ring_phases_selections_segments']=n
    # Alias topology is semantic: never snapshot a pair or second selector early.
    alias_cases=[]
    for value in (0,1,0x7fff,0x8000,0xfff7,0xfff8,0xffff):
      c=case(value);c['cursors'][0]=0x2380;alias_cases.append(('writer_overwrites_source_x',c))
      c=case(value);c['slots'][0]=c['cursors'][1];alias_cases.append(('first_store_overwrites_next_sample_x',c))
      c=case(value);c['slots']=[0x3000,0x3000];alias_cases.append(('same_record_twice',c))
      c=case(value);c['slots'][0]=0xa962;c['writes']+=[('ds',c['cursors'][1],0xffff if value&1 else 0x3080)];alias_cases.append(('first_copy_changes_second_selection',c))
      c=case(value);c['slots'][0]=0xa33c;c['writes']+=[('ds',c['cursors'][1],0xa280)];alias_cases.append(('first_copy_changes_second_cursor',c))
      c=case(value);c['slots'][0]=c['cursors'][2]-2;alias_cases.append(('first_copy_changes_second_source',c))
      c=case(value);c['cursors'][0]=0xa962;c['writes']=[('ss',0x237e,0xfff7),('ss',0x2380,0x2ff8)];alias_cases.append(('writer_changes_selections',c))
      c=case(value);c['cursors'][0]=0xa33c;c['writes']=[('ss',0x237e,0xa278),('ss',0x2380,0xa27c)];alias_cases.append(('writer_changes_read_cursors',c))
    for name,c in alias_cases:compare([probes['aa'],probes['ac']],c)
    counts['ordered_alias_cases']=len(alias_cases)
    for offset in (0,1,0x7fff,0x8000,0xfffc,0xfffe,0xffff):
        c=case(offset);c['out_separate']=True;c['separate']=True
        c['cursors']=[offset,offset,offset,0xa27e];c['slots']=[0x3000,0x3040]
        compare([probes['aa'],probes['ac']],c)
    counts['offset_wrap_boundaries']=7
    rng=random.Random(0x9be2)
    for i in range(512):
        c=case(rng.randrange(65536));c['separate']=bool(i&1);c['out_separate']=bool(i&2)
        c['slots']=[rng.choice([65535,0x3000,0x3002,0x3040]) for _ in range(2)]
        c['cursors']=[0xa27a+2*rng.randrange(94) for _ in range(4)]
        compare([probes['aa'],probes['ac']],c)
    counts['random_positions_and_overlapping_records']=512
    info=read_json(RESULTS/'compiled.json')
    op=next(x for x in info['body_listing'] if x['instruction'].startswith('add ') and x['instruction'].endswith(', 8'))
    negative=Probe('ac');p=LOAD*16+op['address']+len(bytes.fromhex(op['hex']))-1
    assert bytes(negative.u.mem_read(p,1))==b'\x08';negative.u.mem_write(p,b'\x09')
    rejected=False
    try:compare([probes['aa'],negative],case())
    except AssertionError:rejected=True
    assert rejected
    # C mode must not quietly fall back to the original helpers.
    for m in ('ac','cc'):
        assert not any(MAIN*16+l<=a<MAIN*16+h for a in probes[m].coverage for l,h in ((0x9cd9,0x9cf1),(0xa031,0xa060)))
    owned=read_json(RESULTS/'boundary.json')['ranges']
    sites=sorted(hex(a-MAIN*16) for a in probes['aa'].coverage if any(r['start']<=a-MAIN*16<r['end'] for r in owned))
    assert len(sites)==28,sites
    result=dict(status='PASS',cases=sum(counts.values()),counts=counts,original_instruction_sites_hit=sites,deepest_stack_bytes={m:p.deepest for m,p in probes.items()},negative_control='PASS changed generated ADD8 toADD9 rejected',alias_topologies=sorted({n for n,c in alias_cases}),comparison='Actual four packaged MZ images; all registers, segments, SP, exit, control flags, ordered non-stack writes and complete DS/SS/output windows excluding64 private stack bytes. All flags after next original CMP.',excluded='Arithmetic flags dead at9BE8; private below-SP scratch; arbitrary async interrupt interleavings; DF1 outside documented domain',matching_layer=False)
    write_json(RESULTS/'differential.json',result);print('PASS',result['cases'],'transfer cases',result['deepest_stack_bytes'],flush=True);return result
if __name__=='__main__':verify()
