"""Only verification connects historical addresses to clean typed C objects."""
from build import *
import itertools,random
from extract import extract
from unicorn import *
from unicorn.x86_const import *
REG={n:globals()['UC_X86_REG_'+n] for n in ('AX','BX','CX','DX','SI','DI','BP','SP','CS','DS','ES','SS','IP','EFLAGS')}
RANGES={'init':[(0x99bf,0x99f6)],'advance':[(0x9cf1,0x9d4d)],'store':[(0x9cd9,0x9cf1)],'apply':[(0xa031,0xa060)]}
RANGES['store_apply']=[(0x9be2,0x9be8)]+RANGES['store']+RANGES['apply']
RANGES['update']=[(0x9bdf,0x9be8)]+RANGES['advance']+RANGES['store']+RANGES['apply']
ENTRY={'init':0x99bf,'advance':0x9cf1,'store':0x9cd9,'apply':0xa031,'store_apply':0x9be2,'update':0x9bdf}
TEMPLATE=bytes([0xa5])*65536
class Probe:
    def __init__(self,mode,oracle=None):
        self.mode=mode;self.u=Uc(UC_ARCH_X86,UC_MODE_16);self.u.mem_map(0,0x100000)
        self.cs=0x1000 if mode=='oracle' else 0x6000;self.ds=0x4000;self.sp=0xf000
        if mode=='oracle':self.u.mem_write(self.cs*16,oracle);self.publics={}
        else:
            _,image,rel=mz((OUT/mode/'CLEAN.EXE').read_bytes());image=bytearray(image)
            for p in rel:struct.pack_into('<H',image,p,(struct.unpack_from('<H',image,p)[0]+self.cs)&65535)
            self.u.mem_write(self.cs*16,bytes(image));self.publics=read_json(RESULTS/'build.json')['layouts'][mode]['publics']
        self.u.hook_add(UC_HOOK_MEM_WRITE,self.write);self.u.hook_add(UC_HOOK_CODE,self.code)
        self.u.hook_add(UC_HOOK_INTR,self.fail)
        self.u.hook_add(UC_HOOK_INSN,self.fail,None,1,0,UC_X86_INS_IN)
        self.u.hook_add(UC_HOOK_INSN,self.fail,None,1,0,UC_X86_INS_OUT)
        self.coverage={k:set() for k in ENTRY};self.deepest=0
    def fail(self,*args):raise AssertionError('Unexpected external effect in history closure')
    def code(self,u,address,size,_):
        if address==self.stop:u.emu_stop();return
        self.coverage[self.kind].add(address-self.cs*16)
    def word(self,offset,value):self.u.mem_write(self.ds*16+offset,struct.pack('<H',value&65535))
    def write(self,u,access,address,size,value,_):
        off=address-self.ds*16
        if self.sp-512<=off and off+size<=self.sp+32:
            self.deepest=max(self.deepest,self.sp-off);return
        assert size==2 and off in self.mapping,(self.mode,'unmodeled write',hex(address),size)
        key=self.mapping[off]
        if key[0]=='cursor' and self.mode=='oracle':
            assert (value-0xa27a)%4==0
            value=(value-0xa27a)//4
        self.events.append((key,value&65535))
    def prepare(self,kind,c):
        self.kind=kind;self.u.mem_write(self.ds*16,TEMPLATE)
        if self.mode=='oracle':
            positions=[0xa27a+4*i for i in range(48)]+[0x237e,0x3002,0x3042];cursors=[0xa33a+2*i for i in range(4)]
        else:positions=[0x2000+4*i for i in range(48)]+[0x4000,0x4100,0x4200];cursors=[0x20c0+2*i for i in range(4)]
        self.positions=positions;self.cursors=cursors;self.mapping={}
        for i,(off,pair) in enumerate(zip(positions,c['positions'])):
            for field,(delta,value) in enumerate(zip((0,2),pair)):
                self.word(off+delta,value);self.mapping[off+delta]=('position',i,field)
        for i,(off,value) in enumerate(zip(cursors,c['cursors'])):
            self.word(off,0xa27a+4*value if self.mode=='oracle' else value);self.mapping[off]=('cursor',i)
        for i,sel in enumerate(c['selected']):
            self.word((0xa962 if self.mode=='oracle' else 0x4300)+2*i,(65535 if self.mode=='oracle' else 0) if sel is None else positions[sel]-(2 if self.mode=='oracle' else 0))
        if self.mode=='oracle':
            self.u.mem_write(self.cs*16+0x9596,struct.pack('<H',self.ds));self.word(0xa360,c['adjustment']);self.u.mem_write(self.ds*16+0x98be,bytes([c['input']]))
            ip=ENTRY[kind];args=[]
        else:
            ip=self.publics['history_'+kind]['offset'];h=0x2000;source=positions[c['source']];selected=0x4300
            args={'init':[h,source],'advance':[h,c['input'],c['adjustment']],'store':[h,source],'apply':[h,selected],'store_apply':[h,source,selected],'update':[h,source,selected,c['input'],c['adjustment']]}[kind]
        self.word(self.sp,0xfff0)
        for i,arg in enumerate(args):self.word(self.sp+2+2*i,arg)
        for r,v in dict(CS=self.cs,DS=self.ds,SS=self.ds,ES=0x5000,SP=self.sp,BP=positions[c['source']]-2,AX=0x1234,BX=0x5678,CX=0x9abc,DX=0xdef0,SI=0x123,DI=0x456,IP=ip,EFLAGS=0x203).items():self.u.reg_write(REG[r],v)
        self.events=[];self.before=bytes(self.u.mem_read(self.ds*16,65536));self.ip=ip
        self.stop=self.cs*16+(0x9be8 if self.mode=='oracle' and kind in ('store_apply','update') else 0xfff0)
    def run(self):
        self.u.emu_start(self.cs*16+self.ip,0,count=15000)
        assert self.u.reg_read(REG['CS'])*16+self.u.reg_read(REG['IP'])==self.stop
        expect_sp=self.sp if self.mode=='oracle' and self.kind in ('store_apply','update') else self.sp+2
        assert self.u.reg_read(REG['SP'])==expect_sp,(self.mode,'stack')
        for r in ('DS','SS'):assert self.u.reg_read(REG[r])==self.ds
        memory=bytes(self.u.mem_read(self.ds*16,65536));a=bytearray(self.before);b=bytearray(memory)
        for off in self.mapping:a[off:off+2]=b[off:off+2]=b'\0\0'
        a[self.sp-512:self.sp+32]=b[self.sp-512:self.sp+32]=bytes(544)
        assert a==b,(self.mode,'untouched memory')
        values={key:struct.unpack_from('<H',memory,off)[0] for off,key in self.mapping.items()}
        if self.mode=='oracle':
            for k,v in list(values.items()):
                if k[0]=='cursor':assert (v-0xa27a)%4==0;values[k]=(v-0xa27a)//4
        return values,list(self.events)

def case(seed=0):
    return dict(positions=[((seed*17+i*113)&65535,(seed*31+i*173)&65535) for i in range(51)],cursors=[0,33,17,1],selected=[49,50],source=48,input=1,adjustment=0)

def compare(probes,kind,c):
    results=[]
    for p in probes:p.prepare(kind,c);results.append(p.run())
    for p,r in zip(probes[1:],results[1:]):assert r==results[0],(kind,p.mode,c,r,results[0])

def verify():
    write_json(RESULTS/'differential.json',dict(status='RUNNING_OR_FAILED'))
    original=extract()[0];assert original==(ROOT/'build/program.bin').read_bytes()
    probes=[Probe('oracle',original),Probe('base'),Probe('moved')];counts={k:0 for k in ENTRY}
    def check(k,c):compare(probes,k,c);counts[k]+=1
    for seed in (0,1,0x7fff,0x8000,0xfff7,0xfff8,0xffff):
        c=case(seed);c['positions'][48]=(seed,seed);check('init',c)
    for phase in range(48):
      for bits in range(256):
       for adj in (0,1,65535):
        c=case(phase);c.update(cursors=[(phase+x)%48 for x in (0,33,17,1)],input=bits,adjustment=adj);check('advance',c)
    for phase in range(48):
      for mask in range(4):
       for alias in ('distinct','same','source','read_sample','write_sample','source_in_ring'):
        c=case(phase*7+mask);c['cursors']=[(phase+x)%48 for x in (0,33,17,1)]
        target={'distinct':[49,50],'same':[49,49],'source':[48,48],'read_sample':[c['cursors'][2],c['cursors'][1]],'write_sample':[c['cursors'][0],c['cursors'][0]],'source_in_ring':[49,50]}[alias]
        c['selected']=[target[i] if mask&(1<<i) else None for i in range(2)]
        if alias=='source_in_ring':c['source']=phase
        c['input']=(0,1,0xf0,0xff)[mask];c['adjustment']=phase%3
        for k in ('store','apply','store_apply','update'):check(k,c)
    rng=random.Random(0x2026)
    for i in range(1024):
        c=case(rng.randrange(65536));c['cursors']=[rng.randrange(48) for _ in range(4)];c['source']=rng.choice([48,*range(48)])
        c['selected']=[rng.choice([None,48,49,50,*range(48)]) for _ in range(2)];c['input']=rng.randrange(256);c['adjustment']=rng.randrange(65536)
        for k in ('store','apply','store_apply','update'):check(k,c)
    # Higher-level sequence proof: carry actual observed state across initialization
    # and 120 updates, including paused cursors. No Python history implementation.
    c=case(0);c['positions'][48]=(100,50)
    for k in ['init']+['update']*120:
        for p in probes:p.prepare(k,c)
        rows=[p.run() for p in probes];assert rows[0]==rows[1]==rows[2]
        state=rows[0][0];c['positions']=[tuple(state[('position',i,f)] for f in (0,1)) for i in range(51)];c['cursors']=[state[('cursor',i)] for i in range(4)]
        c['positions'][48]=((c['positions'][48][0]+1)&65535,(c['positions'][48][1]+2)&65535);c['input']=0 if c['positions'][48][0]%5==0 else 1
    negative=Probe('base');row=read_json(RESULTS/'build.json')['layouts']['base']
    op=next(x for x in row['listings']['history_store'] if x['instruction'].startswith('add ') and x['instruction'].endswith(', 8'))
    raw=bytes.fromhex(op['hex']);immediate_size=2 if raw.endswith(b'\x08\x00') else 1
    addr=negative.cs*16+op['address']+len(raw)-immediate_size
    assert bytes(negative.u.mem_read(addr,1))==b'\x08';negative.u.mem_write(addr,b'\x09')
    rejected=False
    try:compare([probes[0],negative],'update',case())
    except AssertionError:rejected=True
    assert rejected
    # Both leaves remain correct; change only their caller's sequencing.
    reversed_calls=Probe('base')
    calls=[x for x in row['listings']['history_store_apply'] if x['instruction'].startswith('call ')]
    assert len(calls)==2
    for op,target in zip(calls,('history_apply','history_store')):
        at=op['address'];assert bytes(reversed_calls.u.mem_read(reversed_calls.cs*16+at,1))==b'\xE8'
        displacement=(row['publics'][target]['offset']-at-3)&65535
        reversed_calls.u.mem_write(reversed_calls.cs*16+at+1,struct.pack('<H',displacement))
    # Preserve each callee's correct arguments as well as its unchanged body.
    for old,new in ((6,8),(8,6)):
        op=next(x for x in row['listings']['history_store_apply'] if x['instruction']=='push word ptr [bp + '+str(old)+']')
        address=reversed_calls.cs*16+op['address']+len(bytes.fromhex(op['hex']))-1
        assert bytes(reversed_calls.u.mem_read(address,1))==bytes([old])
        reversed_calls.u.mem_write(address,bytes([new]))
    entered=[]
    def check_arguments(u,address,size,data):
        for name,argument in (('history_apply',0x4300),('history_store',0x4000)):
            if address==reversed_calls.cs*16+row['publics'][name]['offset']:
                sp=u.reg_read(REG['SP'])
                assert struct.unpack('<HH',u.mem_read(reversed_calls.ds*16+sp+2,4))==(0x2000,argument)
                entered.append(name)
    reversed_calls.u.hook_add(UC_HOOK_CODE,check_arguments)
    wrong_order=case();wrong_order['cursors']=[0,0,0,0]
    rejected_order=False
    try:compare([probes[0],reversed_calls],'update',wrong_order)
    except AssertionError:rejected_order=True
    assert entered==['history_apply','history_store'],entered
    assert rejected_order,'Cluster test failed to reject reversed correct leaves'
    g=read_json(ROOT/'metadata/runtime/main-analysis.json')['nodes'];coverage={}
    for k,ranges in RANGES.items():
        expected={n['linear'] for n in g.values() if any(lo<=n['linear']<hi for lo,hi in ranges)}
        assert expected<=probes[0].coverage[k],(k,expected-probes[0].coverage[k])
        coverage[k]=dict(original_bytes=sum(hi-lo for lo,hi in ranges),original_instructions=len(expected),all_instruction_sites_exercised=True)
    result=dict(status='PASS',counts=counts,individual_test_states=sum(counts.values()),sequence_updates=120,coverage=coverage,negative_controls=['Changed leaf ADD8 to9 rejected by whole update-cluster test','Reversed store/apply calls, correct callee arguments and unchanged leaves, rejected by whole update-cluster test'],largest_region=dict(bytes=172,instructions=51),deepest_stack_bytes={p.mode:p.deepest for p in probes},comparison='Typed positions, normalized cursors, ordered semantic writes, complete non-object memory guards and per-world normal return/stack; two linked C layouts independently compared with original ASM',not_claimed=['Historical register/flag ABI equivalence','Uninitialized or malformed offset-domain equivalence','Pointer/control-cell corruption equivalence','Arbitrary concurrent mutation','Whole game or original startup integration'],proof_domain='Initialized valid ring indices; typed whole Position aliases permitted; metadata/pointer arrays disjoint; original DF0; no async mutation')
    write_json(RESULTS/'differential.json',result);print('PASS clean leaves and clusters',counts,flush=True);return result
if __name__=='__main__':verify()
