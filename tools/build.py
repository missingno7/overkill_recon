"""Compile maintained sources using TASM 1.0 via the pinned nmlgc MS-DOS Player.
OMF LEDATA is combined in the explicitly recorded modern physical chunk order.
No binary bytes from the assets or extraction output enter this assembly step.
"""
from common import *
from dos import dos
from omf import segments
import shutil

def assemble():
    manifest=read_json(ROOT/'metadata/source-map.json'); output=bytearray(); build=ROOT/'build'/'asm'; build.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(ROOT/'include/ENCODING.INC',build/'ENCODING.INC')
    for part in manifest['chunks']:
        path=ROOT/part['path']; name=path.name; shutil.copyfile(path,build/name)
        obj=build/(path.stem+'.OBJ');obj.unlink(missing_ok=True)
        log=dos('TASM.EXE',[f'{name},{path.stem}.OBJ,{path.stem}.LST'],build)
        (build/(path.stem+'.log')).write_text(log)
        segs=segments(obj.read_bytes())
        if len(segs)!=1:raise ValueError('Expected one modern physical chunk per object')
        output.extend(segs[0][1])
    (ROOT/'build/program.bin').write_bytes(output)
    print('Assembled',len(output),'bytes from maintained ASM.')
    return bytes(output)
if __name__=='__main__':assemble()
