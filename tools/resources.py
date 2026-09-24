"""Original SHADOW resource directory and ENC stream, decoded independently.
Evidence: 153A:0534..0635 and 0000:ECF2..EE03 in Oracle A.
"""
from common import *
from extract import mz,extract
import struct

def resources():
    data=(ROOT/'assets/OVERKILL').read_bytes()
    pinned=next(r for r in read_json(ROOT/'metadata/inputs.json')['files'] if r['path']=='assets/OVERKILL')
    if len(data)!=pinned['size'] or sha(data)!=pinned['sha256']:raise ValueError('Original OVERKILL asset hash mismatch')
    h,_,_,_=mz(data)
    # Mirror original (pages-1)*512+last-page-bytes; pinned file has partial final page.
    base=(struct.unpack_from('<H',data,4)[0]-1)*512+struct.unpack_from('<H',data,2)[0]
    count,key=struct.unpack_from('<HH',data,base);size=struct.unpack_from('<H',data,base+10)[0]
    if data[base+4:base+10]!=b'SHADOW' or size!=26:raise ValueError('Unexpected container directory')
    low=key&255;step=key>>8;rows=[]
    for i in range(count):
        row=bytearray()
        for value in data[base+12+i*size:base+12+(i+1)*size]:row.append(value^low);low=(low+step)&255
        offset,length=struct.unpack_from('<II',row,5);start=base+offset
        if start+length>len(data):raise ValueError('Resource outside original file')
        rows.append(dict(index=i,name=bytes(row[13:]).split(b'\0')[0].decode('ascii'),offset=start,size=length,sha256=sha(data[start:start+length]),directory_record_hex=row.hex()))
    return data,rows

def decode_enc(data):
    # Original clears [DCB8, ECA6); final 18 ring bytes inherit the initial image.
    initial,_=extract();ring=bytearray(initial[0xdcb8:0xecb8]);ring[:0xfee]=bytes(0xfee)
    cursor=0xfee;pos=0;flags=0;pending=None;out=bytearray()
    def get():
        nonlocal pos,pending
        if pending is not None:value=pending;pending=None;return value
        if pos>=len(data):raise ValueError('ENC stream lacks terminator')
        value=data[pos];pos+=1;return value
    def emit(value):
        nonlocal cursor
        out.append(value);ring[cursor]=value;cursor=(cursor+1)&4095
        if len(out)>1048576:raise ValueError('Unbounded ENC output')
    while True:
        flags>>=1
        if not flags&0x100:flags=get()|0xff00
        if flags&1:emit(get());continue
        low=get();high=get()
        if low==high==0:
            value=get()
            if value==0:return bytes(out),pos
            pending=value
        index=low|((high>>4)<<8);length=(high&15)+3
        for _ in range(length):emit(ring[index]);index=(index+1)&4095

def driver(name):
    data,rows=resources();row=next(r for r in rows if r['name']==name.upper()+'.ENC')
    decoded,used=decode_enc(data[row['offset']:row['offset']+row['size']])
    return decoded,dict(row,decoded_size=len(decoded),decoded_sha256=sha(decoded),compressed_consumed=used)
if __name__=='__main__':
    _,rows=resources();write_json(ROOT/'build/resource-directory.json',rows)
    for name in ('adlib','roland'):
        b,m=driver(name);print(name,m);(ROOT/'build'/f'{name}-decoded.bin').write_bytes(b)
