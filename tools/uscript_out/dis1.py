import sys; sys.path.insert(0,'.')
from ufunc import *
from disasm import Dis
BASE="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/users/crossover/Desktop/AMR/AliceGame/CookedPC/"
want=set(sys.argv[2:])
p=P(BASE+sys.argv[1]); d=Dis(p)
for i,e in enumerate(p.exports):
    if p.class_of(e)!='Function': continue
    path=p.path(i+1)
    if path not in want: continue
    off=e['off']; sz=ri(p.b,off+44); s=p.b[off+48:off+48+sz]
    print('===== %s  (%s)  storage=%d'%(path,flagstr(func_info(p,e)[1]),sz))
    try:
        for l in d.run(s): print('   '+l)
    except Exception as ex: print('   DISASM FAIL',ex)
