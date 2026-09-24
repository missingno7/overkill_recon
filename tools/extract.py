"""Pure byte decoders for the observed nested LZEXE and EXEPACK streams.
No legacy modules, captured memory, accelerated hooks or generated files are inputs.
"""
from common import *
import struct

def word(data, p): return struct.unpack_from('<H', data, p)[0]

def mz(data):
    if data[:2] != b'MZ' or len(data)<28: raise ValueError('Not MZ')
    names='magic last_page pages relocations header_paragraphs min_extra max_extra ss sp checksum ip cs relocation_offset overlay_number'.split()
    h=dict(zip(names,struct.unpack_from('<14H',data)))
    end=(h['pages']-1)*512+(h['last_page'] or 512)
    start=h['header_paragraphs']*16
    if not 28<=start<=end<=len(data): raise ValueError('Invalid MZ bounds')
    h.update(header_bytes=start, executable_bytes=end, appended_bytes=len(data)-end)
    rel=[]
    for n in range(h['relocations']):
        off,seg=struct.unpack_from('<HH',data,h['relocation_offset']+4*n)
        rel.append(seg*16+off)
    return h,data[start:end],rel,data[end:]

LZ_SIG=bytes.fromhex('d1ed4a7505ad89c5b2107303a4ebf131c9')

def unlz(image, cs):
    s=cs*16
    if image[s+0x69:s+0x69+len(LZ_SIG)]!=LZ_SIG: raise ValueError('Unknown LZ stub')
    ip,new_cs,sp,ss,compressed_paras,extra,stub_size=struct.unpack_from('<7H',image,s)
    pos=(cs-compressed_paras)*16
    stream_start=pos
    bits=word(image,pos); pos+=2; remaining=16
    def byte():
        nonlocal pos
        v=image[pos]; pos+=1; return v
    def bit():
        nonlocal pos,bits,remaining
        result=bits&1; bits>>=1; remaining-=1
        # Original stub prefetches the next word before consuming a literal.
        if remaining==0: bits=word(image,pos); pos+=2; remaining=16
        return result
    out=bytearray(); commands=0
    while True:
        commands+=1
        if commands>1000000: raise ValueError('LZ command budget')
        if bit(): out.append(byte()); continue
        if bit():
            lo=byte(); hi=byte(); distance=((hi>>3)<<8|lo)-8192
            count=(hi&7)+2
            if (hi&7)==0:
                n=byte()
                if n==0: break
                if n==1: continue  # Segment normalization preserves linear position.
                count=n+1
        else:
            count=2+2*bit()+bit(); distance=byte()-256
        if not -len(out)<=distance<0: raise ValueError('LZ backreference out of bounds')
        for _ in range(count): out.append(out[distance])
    rel=[]; p=s+0x158; linear=0
    while True:
        delta=image[p]; p+=1
        if delta==0:
            delta=word(image,p); p+=2
            if delta==1: break
            if delta==0: linear+=0xfff0; continue
        linear+=delta
        if linear+2>len(out): raise ValueError('LZ relocation out of bounds')
        rel.append(linear)
    info=dict(kind='LZEXE_0.91_style',entry_cs=cs,entry_ip=14,next_cs=new_cs,next_ip=ip,ss=ss,sp=sp,
              stream_start=stream_start,stream_end=pos,output_bytes=len(out),sha256=sha(out),
              relocations=rel,stub_offset=s,stub_bytes=stub_size,relocation_stream_end=p)
    return bytes(out),new_cs,ip,info

def unexepack(image,cs):
    s=cs*16
    ip,new_cs,mem_start,stub_size,sp,ss,dest_len,signature=struct.unpack_from('<8H',image,s)
    if signature!=0x4252: raise ValueError('Missing EXEPACK RB marker')
    p=s-1
    while image[p]==0xff: p-=1
    end=dest_len*16; out=bytearray(image[:s]); out.extend(bytes(end-len(out))); commands=[]
    while True:
        cmd=image[p]; count=word(image,p-2); p-=3
        if not 0<count<=end: raise ValueError('EXEPACK output bounds')
        if cmd&0xfe==0xb0:
            value=image[p]; p-=1; out[end-count:end]=bytes([value])*count
        elif cmd&0xfe==0xb2:
            out[end-count:end]=image[p-count+1:p+1]; p-=count
        else: raise ValueError(f'Bad EXEPACK opcode {cmd:02x}')
        commands.append(dict(output_start=end-count,output_end=end,command=cmd,count=count))
        end-=count
        if cmd&1: break
    literal_prefix_bytes=end
    # Stub instruction at A1 says MOV SI,0132. Do not infer a generic stub length.
    if image[s+0xa1:s+0xa4]!=bytes.fromhex('be3201'): raise ValueError('Unknown relocation table offset')
    p=s+0x132; rel=[]
    for block in range(16):
        count=word(image,p); p+=2
        for _ in range(count):
            site=block*65536+word(image,p); p+=2
            if site+2>len(out): raise ValueError('EXEPACK relocation out of bounds')
            rel.append(site)
    if p!=s+stub_size: raise ValueError('EXEPACK relocation extent mismatch')
    info=dict(kind='EXEPACK',entry_cs=cs,entry_ip=16,next_cs=new_cs,next_ip=ip,ss=ss,sp=sp,
              output_bytes=len(out),sha256=sha(out),relocations=rel,stub_offset=s,stub_bytes=stub_size,
              commands=commands,literal_prefix_bytes=literal_prefix_bytes,relocation_stream_end=p)
    return bytes(out),info

def extract(name='OVERKILL',output=None):
    data=(ROOT/'assets'/name).read_bytes(); h,image,rel,overlay=mz(data)
    stages=[]; cs=h['cs']; ip=h['ip']
    if rel: raise ValueError('Unexpected outer DOS relocations')
    while image[cs*16+0x69:cs*16+0x69+len(LZ_SIG)]==LZ_SIG:
        image,cs,ip,info=unlz(image,cs); stages.append(info)
        if info['relocations']: raise ValueError('Nested LZ relocation handling needs review')
    if image[cs*16+14:cs*16+16]==b'RB':
        image,info=unexepack(image,cs); stages.append(info)
        cs,ip=info['next_cs'],info['next_ip']; rel=info['relocations']
    manifest=dict(asset=name,asset_sha256=sha(data),mz=h,stages=stages,
                  program_bytes=len(image),program_sha256=sha(image),entry_cs=cs,entry_ip=ip,
                  relocations=rel,overlay_sha256=sha(overlay))
    if output:
        output.mkdir(parents=True,exist_ok=True)
        (output/'program.bin').write_bytes(image)
        (output/'overlay.bin').write_bytes(overlay)
        write_json(output/'extraction.json',manifest)
    return image,manifest

if __name__=='__main__':
    for name in ('OVERKILL','OVERKILL.EXE'):
        image,m=extract(name,ROOT/'build'/'oracle'/name)
        print(name,len(image),f"{m['entry_cs']:04X}:{m['entry_ip']:04X}",m['program_sha256'],len(m['relocations']))
