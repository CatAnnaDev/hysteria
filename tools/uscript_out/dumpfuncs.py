import sys, struct, os
sys.path.insert(0,'.')
from ufunc import *
BASE="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/users/crossover/Desktop/AMR/AliceGame/CookedPC/"
out=open('funcs.tsv','w')
for f in ['Core.u','Engine.u','GameFramework.u','GFxUI.u','IpDrv.u','Kynapse.u','OnlineSubsystemPC.u','AliceGame.u']:
    p=P(BASE+f)
    n=0
    for i,e in enumerate(p.exports):
        if p.class_of(e)!='Function': continue
        fr,fl,inat,noff=func_info(p,e)
        b=p.b
        memsz=ri(b,e['off']+40); stosz=ri(b,e['off']+44)
        path=p.path(i+1)
        out.write("%s\t%s\t%s\t%d\t%d\t%d\t%s\t%s\n"%(f,path,fr,e['size'],memsz,stosz,('0x%08x'%fl) if fl is not None else 'PARSEFAIL',flagstr(fl) if fl is not None else '-'))
        n+=1
    print(f,n,'functions',file=sys.stderr)
out.close()
