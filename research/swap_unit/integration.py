"""Research MZ loading + original bounded DOS environment. Production untouched."""
from build_swap import *
from runtime_machine import Machine
from unicorn.x86_const import UC_X86_REG_EFLAGS

class BuiltGame(Machine):
    def __init__(self,mode,stop=0x9690,limit=9000000,keys=None):
        self.mode=mode;self.package=OUT/mode
        super().__init__('tandy','adlib',out=OUT/('startup-'+mode),limit=limit,stop=stop,trace=False,keys=keys)
        h,image,rel,_=mz((self.package/'PLAY.EXE').read_bytes());data=bytearray(image);load=self.base
        for p in rel:struct.pack_into('<H',data,p,(struct.unpack_from('<H',data,p)[0]+load)&65535)
        self.u.mem_write(load*16,bytes(data))
        self.base=load+PREFIX//16;self.phase='startup';self.initial_seq=0;self.swap_hits=0;self.bridge_hits=0
        for r,v in dict(cs=load+h['cs'],ip=h['ip'],ss=load+h['ss'],sp=h['sp'],ds=self.psp,es=self.psp,eflags=0x202).items():self.set(r,v)
        # Start with an ordinary empty command tail; native prefix installs the canonical bytes.
        self.u.mem_write(self.psp*16+0x80,b'\x00\r\0\0\0')
        self.piece=read_json(RESULTS/'compiled.json')
    def code(self,u,address,size,data):
        if address==self.base*16+ENTRY:self.swap_hits+=1
        if address==(self.base-PREFIX//16)*16+self.piece['publics']['bridge']:self.bridge_hits+=1
        super().code(u,address,size,data)
    def interrupt(self,u,num,data):
        if num==0x21 and self.reg('ax')>>8==0x3d:
            name=self.readstr(self.ptr('ds','dx'));base=name.replace('\\','/').split('/')[-1].upper()
            if base in ('OVERKILL','PLAY.EXE','OVERKILL.EXE'):
                path=self.package/base
                self.file_io.append(dict(op='open',name=name,sequence=self.seq,source='fresh built package'))
                handle=self.next_handle;self.next_handle+=1;self.files[handle]=[base,path.read_bytes(),0]
                self.set('ax',handle);self.flag(1,False);return
        super().interrupt(u,num,data)

def integration():
    write_json(RESULTS/'integration.json',dict(status='RUNNING_OR_FAILED'))
    outcomes=[];images=[]
    for mode in ('asm','c'):
        machine=BuiltGame(mode);state=machine.run()
        assert state['reason']=='REQUESTED_FRONTIER',state['reason']
        assert (machine.reg('cs'),machine.reg('ip'))==(machine.base,0x9690)
        assert machine.u.mem_read(machine.psp*16+0x80,5)==bytes.fromhex('030d02410d')
        assert machine.allocs[machine.psp]==machine.base+0x22ef-machine.psp
        assert len(state['module_loads'])==1 and state['module_loads'][0]['resource'].upper()=='ADLIB.ENC'
        from resources import driver
        assert (machine.out/'module-0.bin').read_bytes()==driver('adlib')[0]
        outcomes.append(dict(mode=mode,status='PASS',frontier='0000:9690',main_segment=machine.base,steps=state['sequence'],swap_hits=machine.swap_hits,bridge_hits=machine.bridge_hits,
            module_sha256=state['module_loads'][0]['sha256'],allocation_paragraphs=machine.allocs[machine.psp],registers=state['registers'],file_opens=[e for e in machine.file_io if e['op']=='open']))
        images.append(bytes(machine.u.mem_read(machine.base*16,len(machine.initial))))
    different=[i for i,(a,b) in enumerate(zip(*images)) if a!=b]
    # The original integrity routine necessarily retains different file checksums.
    # Validate their actual formulas; do not merely allow arbitrary scratch changes.
    checksum_state=[]
    for mode,image in zip(('asm','c'),images):
        raw=(OUT/mode/'OVERKILL').read_bytes()
        expected={0xc88c:container_checksum(raw[:-2]),0xc890:container_checksum(raw)}
        for off,value in expected.items():assert struct.unpack_from('<H',image,off)[0]==value,(mode,off,value)
        checksum_state.append(dict(mode=mode,verified_words={hex(k):v for k,v in expected.items()}))
    expected_ranges=set(range(ENTRY,ENTRY+6))|{0xc88c,0xc88d,0xc890,0xc891}
    assert set(different)<=expected_ranges,different[:20]
    result=dict(status='PASS',runs=outcomes,main_state_difference_offsets=different,checksum_state=checksum_state,
        scope='Actual generated MZ load/relocations, original startup, fresh built resource container, authentic AdLib initialization, modeled DOS/BIOS/ports; stops9690, no gameplay replay',
        caveat='Startup frontier precedes this game-logic unit. Actual swapped entry and original caller/continuation are exercised by separate synthetic full-image tests; no natural gameplay-path execution claim.')
    write_json(RESULTS/'integration.json',result);print('PASS both packaged games reach9690; differences only entry gate and verified checksum scratch',flush=True)
    return result

if __name__=='__main__':integration()
