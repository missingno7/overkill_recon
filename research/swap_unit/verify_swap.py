"""Execute actual packaged ASM/C game variants through caller 9BDF and 9CD9.
No second implementation of the cursor algorithm, no matching recipe, no replay.
"""
from build_swap import *
import itertools,random
from unicorn import *
from unicorn.x86_const import *
REGS={r:globals()['UC_X86_REG_'+r] for r in ('AX','BX','CX','DX','SI','DI','BP','SP','CS','DS','ES','SS','IP','EFLAGS')}
ARITH=0x8d5
LOAD=0x1010
MAIN=LOAD+PREFIX//16

class Probe:
    def __init__(self,mode):
        self.mode=mode;self.u=Uc(UC_ARCH_X86,UC_MODE_16);self.u.mem_map(0,0x100000)
        h,image,rel,_=mz((OUT/mode/'PLAY.EXE').read_bytes());image=bytearray(image)
        for p in rel:struct.pack_into('<H',image,p,(struct.unpack_from('<H',image,p)[0]+LOAD)&65535)
        self.u.mem_write(LOAD*16,bytes(image));self.coverage=set();self.events=[];self.boundary=None
        self.u.hook_add(UC_HOOK_MEM_WRITE,self.write)
        self.u.hook_add(UC_HOOK_CODE,self.code)
        self.u.hook_add(UC_HOOK_INTR,self.fail)
        self.u.hook_add(UC_HOOK_INSN,self.fail,None,1,0,UC_X86_INS_IN)
        self.u.hook_add(UC_HOOK_INSN,self.fail,None,1,0,UC_X86_INS_OUT)
        self.template=bytes((i*29+17)&255 for i in range(65536))
        self.last_segments=None;self.deepest=0
    def fail(self,*args):raise AssertionError('Unexpected external/port/interrupt effect')
    def reg(self,r):return self.u.reg_read(REGS[r])
    def state(self):return {r:self.reg(r) for r in REGS}
    def code(self,u,address,size,_):
        self.coverage.add(address)
        if address==MAIN*16+0x9be2:self.boundary=(self.state(),list(self.events))
    def write(self,u,access,address,size,value,_):
        stackbase=self.ss*16
        if stackbase+self.sp-64<=address and address+size<=stackbase+self.sp:
            self.deepest=max(self.deepest,stackbase+self.sp-address)
        else:
            assert (self.ds*16+0xa33a<=address and address+size<=self.ds*16+0xa342) or (self.ds*16+0xa27a<=address and address+size<=self.ds*16+0xa33a),('unexpected memory write',self.mode,hex(address),size)
            self.events.append((address,size,value&((1<<(size*8))-1)))
    def prepare(self,cursors,bits,adjust,seed,separate=False,flags_override=None):
        self.ds=MAIN+0x15bc;self.ss=0x5000 if separate else self.ds
        self.sp=0xa278-2*(seed%16)
        if self.last_segments!=(self.ds,self.ss):
            self.u.mem_write(self.ds*16,self.template)
            if self.ss!=self.ds:self.u.mem_write(self.ss*16,self.template)
            self.last_segments=(self.ds,self.ss)
        # Test-defined caller state. Return stack disjoint from globals and source record.
        self.u.mem_write(self.ds*16+0xa27a,b'\x6d'*192)
        self.u.mem_write(self.ds*16+0xa33a,struct.pack('<4H',*cursors))
        self.u.mem_write(self.ds*16+0x98be,bytes([bits]))
        self.u.mem_write(self.ds*16+0xa360,struct.pack('<H',adjust))
        self.u.mem_write(self.ss*16+self.sp-80,b'\xa5'*96)
        self.u.mem_write(self.ss*16+0x237e,struct.pack('<HH',seed&65535,(seed*7)&65535))
        flags=(0x202,0x203,0xa96,0x246)[seed%4] if flags_override is None else flags_override
        vals=dict(AX=seed&65535,BX=(seed*23)&65535,CX=(seed*47)&65535,DX=(seed*53)&65535,SI=(seed*19)&65535,DI=(seed*31)&65535,BP=0x237c,SP=self.sp,DS=self.ds,SS=self.ss,ES=0x6000,CS=MAIN,IP=0x9bdf,EFLAGS=flags)
        for r,v in vals.items():self.u.reg_write(REGS[r],v)
        self.events=[];self.boundary=None
    def run(self,continue_store=True):
        # Enter the authentic CALL instruction, not a test-only replacement call stub.
        self.u.emu_start(MAIN*16+0x9bdf,MAIN*16+(0x9be5 if continue_store else 0x9be2),count=500)
        assert self.reg('IP')==(0x9be5 if continue_store else 0x9be2)
        if not continue_store:self.boundary=(self.state(),list(self.events))
        return self.state()
    def memory(self):
        parts=[]
        for seg in sorted({self.ds,self.ss}):
            data=bytearray(self.u.mem_read(seg*16,65536))
            if seg==self.ss:data[self.sp-64:self.sp]=bytes(64)
            parts.append(bytes(data))
        return parts

def compare(a,b,cursors,bits,adjust,seed=0,separate=False,continue_store=True,flags_override=None):
    for p in (a,b):p.prepare(cursors,bits,adjust,seed,separate,flags_override)
    af=a.run(continue_store);bf=b.run(continue_store)
    assert a.boundary and b.boundary
    ar,aw=a.boundary;br,bw=b.boundary
    for r in REGS:
        mask=(0xffff^ARITH) if r=='EFLAGS' else 0xffffffff
        assert ar[r]&mask==br[r]&mask,('boundary register',r,ar[r],br[r],cursors,bits,adjust)
    assert aw==bw,('ordered unit writes',aw,bw,cursors,bits,adjust)
    for r in REGS:
        mask=0xffffffff if continue_store or r!='EFLAGS' else (0xffff^ARITH)
        assert af[r]&mask==bf[r]&mask,('after caller continuation',r,af[r],bf[r])
    assert a.events==b.events,('caller ordered writes',a.events,b.events)
    assert a.memory()==b.memory(),('complete DS/SS memory outside private stack scratch',cursors,bits,adjust)

def verify_units():
    write_json(RESULTS/'differential.json',dict(status='RUNNING_OR_FAILED'))
    a,b=Probe('asm'),Probe('c');counts={};seed=0
    for phase in range(48):
        cursors=[0xa27a+4*((phase+lag)%48) for lag in (0,33,17,1)]
        for bits in range(256):
            for adjust in (0,1,65535):
                compare(a,b,cursors,bits,adjust,seed);seed+=1
    counts['all_48_phases_256_inputs_3_adjustments']=seed
    # All sixteen independent wrap combinations, including coincident cursor VALUES.
    n=0
    for choices in itertools.product((0xa27a,0xa336),repeat=4):
        for bits,adj in ((0,0),(0,1),(0xf0,0),(0xff,0)):
            compare(a,b,list(choices),bits,adj,n,True);n+=1
    counts['independent_wrap_masks_segment_separated']=n
    # Full word domain for each cursor independently, not just expected valid ring states.
    # Do not continue into 9CD9 with out-of-ring write pointers.
    n=0
    for value in range(65536):
        compare(a,b,[value,(value+1)&65535,(value+0x8000)&65535,(value+0xfffc)&65535],1,0,value,False,False);n+=1
    counts['all_word_values_each_cursor_no_invented_bounds']=n
    rng=random.Random(0x9cf1);n=0
    for _ in range(2048):
        c=[0xa27a+4*rng.randrange(48) for i in range(4)]
        compare(a,b,c,rng.randrange(256),rng.randrange(65536),rng.randrange(65536),bool(n%2));n+=1
    counts['random_independent_cursors_and_segments']=n
    n=0
    for flags in (0x2,0x203,0xa96,0x246,0x602,0x603,0xe96,0x646):
        for bits,adj in ((0,0),(0,1),(0xf0,0),(0xff,0)):
            compare(a,b,[0xa27a,0xa336,0xa2fe,0xa2be],bits,adj,n,False,False,flags);n+=1
    counts['IF_DF_control_flags_no_async_injection']=n
    # Negative control: alter one actual generated ADD immediate from4 to5.
    # This is deliberately wrong code, never used in either game build.
    info=read_json(RESULTS/'compiled.json')
    op=next(v for v in info['body_listing'] if v['instruction'].startswith('add word ptr') and v['instruction'].endswith(', 4'))
    address=LOAD*16+op['address']+len(bytes.fromhex(op['hex']))-1
    # Fresh CPU avoids executing a cached translation after host-side code mutation.
    negative=Probe('c')
    old=bytes(negative.u.mem_read(address,1));assert old==b'\x04';negative.u.mem_write(address,b'\x05')
    rejected=False
    try:compare(a,negative,[0xa27a,0xa2fe,0xa2be,0xa27e],1,0)
    except AssertionError:rejected=True
    finally:negative.u.mem_write(address,old)
    assert rejected,'Differential test failed to detect altered algorithm'
    result=dict(status='PASS',cases=sum(counts.values()),counts=counts,negative_control='PASS: changed generated cursor increment rejected',
        original_instruction_sites_hit=sorted(hex(p-MAIN*16) for p in a.coverage if MAIN*16+ENTRY<=p<MAIN*16+END),
        c_body_instruction_sites_hit=sorted(hex(p-LOAD*16) for p in b.coverage if LOAD*16+info['publics']['advance_history']<=p<LOAD*16+info['piece_bytes']),
        deepest_stack_bytes_below_callers_sp=dict(ASM=a.deepest,C=b.deepest),
        comparison='actual packaged MZ variants, actual caller CALL9BDF; all registers/segments/stack/exit and control flags, ordered non-stack writes, full DS and SS memory excluding64 private stack bytes; all flags after original next helper9CD9 for valid cursors',
        excluded='dead arithmetic flags at9BE2; private below-SP stack contents; instruction timing and arbitrary interrupt interleavings',matching_layer_used=False)
    assert len(result['original_instruction_sites_hit'])==22
    write_json(RESULTS/'differential.json',result);print('PASS swap differential',result['cases'],'cases',result['deepest_stack_bytes_below_callers_sp'],flush=True)
    return result

if __name__=='__main__':verify_units()
