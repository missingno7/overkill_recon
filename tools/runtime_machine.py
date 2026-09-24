"""Independent, bounded DOS startup execution for runtime-materialization research.
No original game routine is replaced. All unsupported environment interactions fail.
"""
from common import *
from extract import mz,extract
import struct,gzip,argparse,collections,time
from unicorn import *
from unicorn.x86_const import *

REGS={r:globals()['UC_X86_REG_'+r.upper()] for r in ('ax','bx','cx','dx','si','di','bp','sp','cs','ds','es','ss','ip','eflags')}
HEAD=struct.Struct('<QHHIHB') # sequence, writer CS/IP, destination, size, origin (0 CPU/1 DOS)

class Machine:
    def __init__(self,video='tandy',sound='adlib',out=None,limit=3000000,stop=None,trace=True,irq_period=20000,keys=None):
        self.video=video;self.sound=sound;self.base=0x1010;self.psp=self.base-16
        self.out=out or ROOT/'build/runtime-probe'/f'{video}-{sound}';self.out.mkdir(parents=True,exist_ok=True)
        self.key_script=list(keys or []);self.keys=list(keys or []);self.key_events=[];self.key_data=0;self.irq_period=irq_period;self.limit=limit;self.stop=stop;self.trace=trace;self.seq=0;self.phase='packed';self.current=(0,0)
        self.events=[];self.files={};self.next_handle=5;self.allocs={self.psp:0x9fff-self.psp};self.file_io=[]
        self.ports=collections.Counter();self.port_values={};self.status_reads=0;self.opl_index=0;self.opl_status=0;self.opl_regs={};self.opl_deadline=None;self.pit=65535;self.pit_channels={};self.strategy=0;self.next_irq=0;self.irq_pending=None;self.irq_count=0
        self.vectors=[];self.visited={};self.exec_mask=bytearray(0x100000);self.initial_mask=bytearray(0x100000)
        self.module_loads=[];self.active_resource=None;self.checkpoints={};self.error=None;self.reason='STEP_BUDGET';self.journal_file=(self.out/'writes.bin.gz').open('wb') if trace else None;self.journal=gzip.GzipFile(filename='',mode='wb',fileobj=self.journal_file,compresslevel=1,mtime=0) if trace else None
        for row in read_json(ROOT/'metadata/inputs.json')['files']:
            data=(ROOT/row['path']).read_bytes()
            if len(data)!=row['size'] or sha(data)!=row['sha256']:raise ValueError('Original input hash mismatch: '+row['path'])
        self.u=Uc(UC_ARCH_X86,UC_MODE_16);self.u.mem_map(0,0x200000)
        data=(ROOT/'assets/OVERKILL').read_bytes();h,image,rel,_=mz(data);self.header=h;self.u.mem_write(self.base*16,image)
        self.u.mem_write(self.psp*16,b'\xcd\x20');self.u.mem_write(self.psp*16+2,struct.pack('<H',0x9fff))
        tail=bytes([0x0d,{'cga':0,'ega':1,'tandy':2}[video]])+(bytes([{'adlib':65,'roland':82}[sound]]) if sound!='pc' else b'')
        self.tail=tail;self.u.mem_write(self.psp*16+0x80,bytes([len(tail)])+tail+b'\r')
        self.u.mem_write(self.psp*16+0x2c,struct.pack('<H',0x800))
        self.u.mem_write(0x8000,b'COMSPEC=C:\\COMMAND.COM\0PATH=C:\\OVERKILL\0\0\x01\x00C:\\OVERKILL\\OVERKILL\0')
        self.u.mem_write(0xffffe,b'\xfd') # Tandy/PCjr ROM machine identification; vary below if consumed.
        self.u.mem_write(0x410,struct.pack('<H',0x21));self.u.mem_write(0x413,struct.pack('<H',640))
        self.u.mem_write(0x449,b'\x03');self.u.mem_write(0x44a,struct.pack('<H',80));self.u.mem_write(0x44c,struct.pack('<H',4000))
        self.u.mem_write(0x41a,b'\x1e\x00\x1e\x00')
        for n in range(256):self.u.mem_write(n*4,struct.pack('<HH',0x100+n,0xf000));self.u.mem_write(0xf0100+n,b'\xcf')
        for r,v in dict(cs=self.base+h['cs'],ip=h['ip'],ss=self.base+h['ss'],sp=h['sp'],ds=self.psp,es=self.psp,eflags=0x202).items():self.set(r,v)
        for n in read_json(ROOT/'metadata/analysis.json')['nodes'].values():
            start=self.base*16+n['linear'];self.initial_mask[start:start+n['size']]=b'\1'*n['size']
        self.initial,_=extract()
        self.u.hook_add(UC_HOOK_CODE,self.code)
        self.u.hook_add(UC_HOOK_MEM_WRITE,self.write_hook)
        self.u.hook_add(UC_HOOK_INTR,self.interrupt)
        self.u.hook_add(UC_HOOK_INSN,self.port_in,None,1,0,UC_X86_INS_IN)
        self.u.hook_add(UC_HOOK_INSN,self.port_out,None,1,0,UC_X86_INS_OUT)
    def reg(self,r):return self.u.reg_read(REGS[r])
    def set(self,r,v):self.u.reg_write(REGS[r],v)
    def flag(self,mask,on):self.set('eflags',(self.reg('eflags')|mask) if on else (self.reg('eflags')&~mask))
    def ptr(self,seg,off):return self.reg(seg)*16+self.reg(off)
    def readstr(self,addr,terminator=0):
        b=bytearray()
        for i in range(512):
            c=self.u.mem_read(addr+i,1)[0]
            if c==terminator:return b.decode('cp437')
            b.append(c)
        raise RuntimeError('Unterminated DOS string')
    def logwrite(self,address,new,origin=0):
        if address>=0xa0000 or not new:return
        old=bytes(self.u.mem_read(address,len(new)))
        if self.journal:
            for off in range(0,len(new),60000):
                part=new[off:off+60000];self.journal.write(HEAD.pack(self.seq,*self.current,address+off,len(part),origin)+old[off:off+len(part)]+part)
    def write_hook(self,u,access,address,size,value,_):
        self.logwrite(address,int(value&((1<<(8*size))-1)).to_bytes(size,'little'))
    def write(self,address,data,origin=1):self.logwrite(address,data,origin);self.u.mem_write(address,data)
    def code(self,u,address,size,_):
        self.seq+=1
        if self.seq%10000000==0:print(self.video,self.sound,'steps',self.seq,flush=True)
        self.current=(self.reg('cs'),self.reg('ip'))
        cs,ip=self.current
        if address>=0xa0000 and cs!=0xf000:raise RuntimeError('Executable address outside conventional RAM/BIOS model')
        if self.phase=='packed':
            if (cs,ip)==(self.base,0x95c9):
                self.phase='startup';self.initial_seq=self.seq
                expected=bytearray(self.initial)
                for site in extract()[1]['relocations']:struct.pack_into('<H',expected,site,(struct.unpack_from('<H',expected,site)[0]+self.base)&65535)
                if bytes(u.mem_read(self.base*16,len(expected)))!=expected:raise RuntimeError('Oracle A changed')
                self.checkpoint('oracle-a')
        else:
            self.exec_mask[address:address+size]=b'\1'*size
            key=f'{cs:04X}:{ip:04X}'
            if key not in self.visited:self.visited[key]=dict(first=self.seq,size=size,hex=bytes(u.mem_read(address,size)).hex(),hits=0)
            self.visited[key]['hits']+=1
            now=bytes(u.mem_read(address,size)).hex()
            if now!=self.visited[key]['hex']:
                self.visited[key].setdefault('versions',{}).setdefault(now,self.seq)
            if cs==self.base and ip==0xcb95:
                self.active_resource=self.readstr(self.ptr('ds','dx'))
            if cs==self.base and ip==0xcbcd and not self.reg('eflags')&1:
                length=struct.unpack('<I',u.mem_read(self.base*16+0xede5,4))[0]
                off,seg=struct.unpack('<HH',u.mem_read(self.base*16+0xecee,4))
                payload=bytes(u.mem_read(seg*16+off,length));name=f'module-{len(self.module_loads)}.bin'
                (self.out/name).write_bytes(payload)
                self.module_loads.append(dict(resource=self.active_resource,sequence=self.seq,segment=seg,offset=off,size=length,sha256=sha(payload),artifact=name))
            if cs==self.base and ip in (0x966e,0x9682,0x9687,0x9690,0x96c2,0x96ce,0x971a,0x97b2,0x97c8,0xd007,0xd445):
                name=f'frontier-{ip:04x}'
                if name not in self.checkpoints:self.checkpoint(name)
            if (cs,ip)==(self.base,0x97b2) or (self.stop is not None and (cs,ip)==(self.base,self.stop)):
                self.reason='REQUESTED_FRONTIER';u.emu_stop();return
            event=self.keys[0] if self.keys else None
            due=bool(event) and ((isinstance(event,list) and self.seq>=event[0]) or (isinstance(event,dict) and key==event['at'] and self.visited[key]['hits']>=event.get('hit',1)))
            if due and self.reg('eflags')&0x200 and not self.port_values.get(0x21,0)&2:
                self.keys.pop(0)
                if isinstance(event,dict):
                    scan=event['scan']
                    if 'hold' in event:self.keys.insert(0,[self.seq+event['hold'],scan|0x80])
                else:at,scan=event
                self.key_data=scan;self.key_events.append(dict(sequence=self.seq,scan=scan,trigger=event))
                self.irq_pending=9;u.emu_stop();return
            if self.irq_period and self.seq>=self.next_irq and self.reg('eflags')&0x200 and not self.port_values.get(0x21,0)&1:
                off,seg=struct.unpack('<HH',u.mem_read(8*4,4))
                if seg!=0xf000:
                    self.irq_pending=8;self.next_irq=self.seq+self.irq_period;u.emu_stop()
    def checkpoint(self,name):
        state=dict(sequence=self.seq,registers={r:self.reg(r) for r in REGS},phase=self.phase)
        self.checkpoints[name]=state
        (self.out/(name+'.bin')).write_bytes(bytes(self.u.mem_read(self.base*16,len(self.initial))))
        print(self.video,self.sound,name,self.seq,flush=True)
    def interrupt(self,u,num,_):
        ax=self.reg('ax');ah=ax>>8;al=ax&255
        self.events.append(dict(sequence=self.seq,site=f'{self.current[0]:04X}:{self.current[1]:04X}',interrupt=num,ax=ax))
        if num==0x21:
            if ah in (0,0x4c):self.reason=f'DOS_EXIT_{al:02X}';u.emu_stop();return
            if ah==0x30:self.set('ax',5);self.set('bx',0);self.set('cx',0)
            elif ah==0x35:
                off,seg=struct.unpack('<HH',u.mem_read(al*4,4));self.set('es',seg);self.set('bx',off)
            elif ah==0x25:
                off=self.reg('dx');seg=self.reg('ds');self.write(al*4,struct.pack('<HH',off,seg));self.vectors.append(dict(sequence=self.seq,vector=al,handler=f'{seg:04X}:{off:04X}',site=self.current))
            elif ah==0x19:self.set('ax',(ax&0xff00)|2)
            elif ah==0x47:self.write(self.ptr('ds','si'),b'OVERKILL\0')
            elif ah in (0x1a,0x0d):pass
            elif ah in (0x09,0x02):pass
            elif ah==0x3d:
                name=self.readstr(self.ptr('ds','dx'));base=name.replace('\\','/').split('/')[-1].upper();path=ROOT/'assets'/base
                self.file_io.append(dict(op='open',name=name,sequence=self.seq))
                if base not in ('OVERKILL','OVERKILL.EXE','OVERKILL.DOC') or not path.is_file():self.set('ax',2);self.flag(1,True);return
                handle=self.next_handle;self.next_handle+=1;self.files[handle]=[base,path.read_bytes(),0];self.set('ax',handle)
            elif ah==0x3e:
                if self.reg('bx') not in self.files:raise RuntimeError('Unknown close handle')
                del self.files[self.reg('bx')]
            elif ah==0x3f:
                name,data,pos=self.files[self.reg('bx')];chunk=data[pos:pos+self.reg('cx')];dest=self.ptr('ds','dx')
                self.file_io.append(dict(op='read',asset=name,offset=pos,size=len(chunk),destination=dest,sequence=self.seq,site=self.current))
                self.write(dest,chunk);self.files[self.reg('bx')][2]+=len(chunk);self.set('ax',len(chunk))
            elif ah==0x42:
                f=self.files[self.reg('bx')];offset=(self.reg('cx')<<16)|self.reg('dx');offset=offset-(1<<32) if offset&(1<<31) else offset
                pos=offset+(0 if al==0 else (f[2] if al==1 else len(f[1])))
                if pos<0:raise RuntimeError('Negative seek')
                f[2]=pos;self.set('ax',pos&65535);self.set('dx',pos>>16)
            elif ah==0x58:
                if al==0:self.set('ax',self.strategy)
                elif al==1 and self.reg('bx') in (0,1,2):self.strategy=self.reg('bx')
                else:raise RuntimeError('Unknown allocation strategy subfunction')
            elif ah==0x4a:
                seg=self.reg('es');size=self.reg('bx')
                if seg not in self.allocs:raise RuntimeError(f'Unknown resize block {seg:x}')
                if seg+size>0x9fff:raise RuntimeError('Oversized memory resize')
                self.allocs[seg]=size
            elif ah==0x48:
                need=self.reg('bx');candidate=self.psp;gaps=[]
                for seg,size in sorted(self.allocs.items()):
                    if candidate+need<=seg-1:gaps.append((candidate,seg-1-candidate))
                    candidate=max(candidate,seg+size+1)
                if candidate+need<=0x9fff:gaps.append((candidate,0x9fff-candidate))
                if not gaps:raise RuntimeError('Allocation out of memory')
                if self.strategy==0:candidate=gaps[0][0]
                elif self.strategy==1:candidate=min(gaps,key=lambda x:(x[1],x[0]))[0]
                else:candidate=gaps[-1][0]+gaps[-1][1]-need
                self.allocs[candidate]=need;self.set('ax',candidate)
            elif ah==0x49:
                seg=self.reg('es')
                if seg not in self.allocs:raise RuntimeError(f'Unknown free {seg:x}')
                del self.allocs[seg]
            elif ah==0x40:
                if self.reg('bx')>2:raise RuntimeError('Disk writes not modeled')
                self.set('ax',self.reg('cx'))
            else:raise RuntimeError(f'Unsupported DOS AX={ax:04X} at {self.current}')
            self.flag(1,False);return
        if num==0x10:
            if ah==0:self.write(0x449,bytes([al]));return
            if ah==0x0f:self.set('ax',(80<<8)|u.mem_read(0x449,1)[0]);self.set('bx',self.reg('bx')&255);return
            if ah==0x12 and (self.reg('bx')&255)==0x10:self.set('bx',0x0003);return
            if ah in (1,2,3,5,6,7,9,0x0e,0x0b,0x10):return
            raise RuntimeError(f'Unsupported BIOS video AX={ax:04x}')
        if num==0x16:
            if ah==1:self.flag(0x40,True);return
            if ah==0:self.reason='BLOCKING_BIOS_KEYBOARD';u.emu_stop();return
            if ah==2:self.set('ax',ax&0xff00);return
        if num==0x11:self.set('ax',0x21);return
        if num==0x12:self.set('ax',640);return
        if num==0x1a and ah==0:self.set('cx',0);self.set('dx',0);self.set('ax',0);return
        if num==0x13 and ah in (0,4):self.set('ax',al);self.flag(1,False);return
        raise RuntimeError(f'Unsupported interrupt {num:02X}, AX={ax:04X} at {self.current}')
    def port_in(self,u,port,size,_):
        try:return self._port_in(u,port,size,_)
        except Exception as e:self.error=e;u.emu_stop();return 0
    def _port_in(self,u,port,size,_):
        self.ports[('in',port)]+=1
        if port in (0x3da,0x3ba):self.status_reads+=1;return 9 if self.status_reads%4<2 else 0
        if port in (0x3c8,0x3c7):return self.port_values.get(port,0)
        if port==0x3c6:return self.port_values.get(port,0xff)
        if port==0x388:
            if self.opl_deadline is not None and self.seq>=self.opl_deadline:self.opl_status|=0xc0
            return self.opl_status
        if port==0x331:return 0 # MPU ready / data available; command ACK below.
        if port==0x330:return 0xfe
        if port==0x61:return self.port_values.get(port,0)
        if port==0x60:return self.key_data
        if port==0x64:return 0
        if port in (0x40,0x42):
            channel=self.pit_channels.setdefault(port,dict(reload=65536,at=0,read=0,write=0))
            if channel['read']==0:channel['sample']=(channel['reload']-(self.seq-channel['at'])*4)&65535
            result=(channel['sample']>>(channel['read']*8))&255;channel['read']^=1
            return result
        if port==0x201:return 0xff
        if port==0x21:return self.port_values.get(port,0)
        raise RuntimeError(f'Unsupported port input {port:04X} at {self.current}')
    def port_out(self,u,port,size,value,_):
        self.ports[('out',port)]+=1;self.port_values[port]=value
        if port==0x43:
            selected=0x40+(value>>6)
            if selected in (0x40,0x42):
                ch=self.pit_channels.setdefault(selected,dict(reload=65536,at=0,read=0,write=0))
                ch['read']=0;ch['write']=0
        if port in (0x40,0x42):
            ch=self.pit_channels.setdefault(port,dict(reload=65536,at=0,read=0,write=0))
            if ch['write']==0:ch['low']=value
            else:ch['reload']=(ch['low']|(value<<8)) or 65536;ch['at']=self.seq
            ch['write']^=1
        if port==0x388:self.opl_index=value
        if port==0x389:
            self.opl_regs[self.opl_index]=value
            if self.opl_index==4:
                if value&0x80:self.opl_status=0
                elif value&1:self.opl_deadline=self.seq+80*(256-self.opl_regs.get(2,0))
                else:self.opl_deadline=None
    def run(self):
        try:
            while self.seq<self.limit:
                self.u.emu_start(self.reg('cs')*16+self.reg('ip'),0x1fffff,count=self.limit-self.seq)
                if self.error is not None:raise self.error
                if self.irq_pending is None:break
                vector=self.irq_pending;self.irq_pending=None;self.irq_count+=1
                # Real-mode interrupt entry: original vector handler executes normally.
                for value in (self.reg('eflags')&65535,self.reg('cs'),self.reg('ip')):
                    self.set('sp',(self.reg('sp')-2)&65535);self.write(self.ptr('ss','sp'),struct.pack('<H',value),2)
                self.flag(0x300,False)
                off,seg=struct.unpack('<HH',self.u.mem_read(vector*4,4));self.set('cs',seg);self.set('ip',off)
        except Exception as e:self.reason=type(e).__name__+': '+str(e)
        finally:
            if self.journal:self.journal.close();self.journal_file.close()
        state=dict(execution_model_sha256=sha(Path(__file__).read_bytes()),key_script=self.key_script,key_events=self.key_events,irq_period=self.irq_period,irq_count=self.irq_count,video=self.video,sound=self.sound,psp_tail=self.tail.hex(),reason=self.reason,sequence=self.seq,phase=self.phase,
            module_loads=self.module_loads,registers={r:self.reg(r) for r in REGS},checkpoints=self.checkpoints,events=self.events,file_io=self.file_io,vectors=self.vectors,
            ports=[dict(direction=k[0],port=k[1],count=v) for k,v in sorted(self.ports.items())],visited=self.visited)
        write_json(self.out/'state.json',state)
        (self.out/'memory.bin').write_bytes(bytes(self.u.mem_read(0,0x100000)))
        (self.out/'executed-mask.bin').write_bytes(self.exec_mask)
        print(self.reason,self.seq,f'{self.reg("cs"):04X}:{self.reg("ip"):04X}',len(self.visited),'unique instructions',flush=True)
        return state

if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('--video',default='tandy',choices=['cga','ega','tandy']);p.add_argument('--sound',default='adlib',choices=['pc','adlib','roland']);p.add_argument('--steps',type=int,default=3000000);p.add_argument('--stop',type=lambda x:int(x,16));p.add_argument('--no-trace',action='store_true');p.add_argument('--out',type=Path);p.add_argument('--keys',type=Path);p.add_argument('--irq-period',type=int,default=20000);a=p.parse_args()
    state=Machine(a.video,a.sound,out=a.out,limit=a.steps,stop=a.stop,trace=not a.no_trace,irq_period=a.irq_period,keys=read_json(a.keys) if a.keys else None).run()

    if state['reason'] not in ('STEP_BUDGET','REQUESTED_FRONTIER','BLOCKING_BIOS_KEYBOARD') and not state['reason'].startswith('DOS_EXIT_'):raise SystemExit(1)
