"""Small strict OMF reader for absolute reconstruction segments.
FIXUPP is rejected: this image builder must not silently ignore relocations.
"""
import struct

def index(data,p):
    n=data[p]; p+=1
    if n&128: n=((n&127)<<8)|data[p];p+=1
    return n,p

def segments(data):
    p=0; names=['']; segs={}; unresolved=[]
    while p<len(data):
        typ=data[p]; size=struct.unpack_from('<H',data,p+1)[0]
        raw=data[p:p+3+size]
        if len(raw)!=3+size or sum(raw)&255: raise ValueError('Invalid OMF record/checksum')
        d=raw[3:-1]; p+=3+size
        if typ==0x96:
            q=0
            while q<len(d): n=d[q];q+=1;names.append(d[q:q+n].decode('ascii'));q+=n
        elif typ==0x98:
            q=1
            if (d[0]>>5)==0:q+=3
            length=struct.unpack_from('<H',d,q)[0];q+=2
            if d[0]&2:length=65536
            name,q=index(d,q)
            segs[len(segs)+1]={'name':names[name],'data':bytearray(length),'written':set()}
        elif typ==0xa0:
            num,q=index(d,0); off=struct.unpack_from('<H',d,q)[0];q+=2
            s=segs[num]; payload=d[q:]
            if off+len(payload)>len(s['data']): raise ValueError('LEDATA overflow')
            if any(x in s['written'] for x in range(off,off+len(payload))):raise ValueError('Overlapping LEDATA')
            s['data'][off:off+len(payload)]=payload;s['written'].update(range(off,off+len(payload)))
        elif typ in (0x9c,0x9d): unresolved.append(d.hex())
        elif typ in (0xa2,0xa3):raise ValueError('LIDATA not supported: use explicit data')
    if unresolved:raise ValueError('Unexpected OMF FIXUPP: '+str(unresolved[:3]))
    for s in segs.values():
        if len(s['written'])!=len(s['data']):raise ValueError('OMF has uninitialized holes')
    return [(s['name'],bytes(s['data'])) for s in segs.values()]
