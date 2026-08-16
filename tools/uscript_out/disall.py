import sys; sys.path.insert(0,'.')
from ufunc import *
from disasm import Dis
BASE="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/users/crossover/Desktop/AMR/AliceGame/CookedPC/"
out=open(sys.argv[2],'w')
p=P(BASE+sys.argv[1]); d=Dis(p)
for i,e in enumerate(p.exports):
    if p.class_of(e)!='Function': continue
    off=e['off']; sz=ri(p.b,off+44); s=p.b[off+48:off+48+sz]
    out.write('===== %s  (%s)\n'%(p.path(i+1),flagstr(func_info(p,e)[1])))
    try:
        for l in d.run(s): out.write('   '+l+'\n')
    except Exception as ex: out.write('   DISASM FAIL %s\n'%ex)
out.close()
