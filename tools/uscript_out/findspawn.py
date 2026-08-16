import sys, struct
sys.path.insert(0,'.')
from ufunc import *
BASE="/Users/anna/Library/Application Support/CrossOver/Bottles/Steam/drive_c/users/crossover/Desktop/AMR/AliceGame/CookedPC/"
PKGS=['Core.u','Engine.u','GameFramework.u','GFxUI.u','IpDrv.u','Kynapse.u','OnlineSubsystemPC.u','AliceGame.u']
TARGETS={'Actor.Spawn','Actor.Destroy','Object.DynamicLoadObject','Pawn.CreateInventory',
         'InventoryManager.CreateInventory','GameInfo.SpawnDefaultPawnFor','Controller.Possess',
         'PlayerController.Possess','Controller.UnPossess','GameViewportClient.CreatePlayer',
         'GameInfo.RestartPlayer','GameInfo.Login','GameViewportClient.AddLocalPlayer'}
out=open('spawncallers.tsv','w')
for f in PKGS:
    p=P(BASE+f)
    refs={}
    for j,imp in enumerate(p.imports):
        outer=imp['outer']
        on=p.ref_name(outer) if outer else ''
        key="%s.%s"%(on,imp['name'])
        if key in TARGETS: refs[-(j+1)]=key
    for j,e in enumerate(p.exports):
        if p.class_of(e)!='Function': continue
        outer=p.ref_name(e['oi'])
        key="%s.%s"%(outer,e['name'])
        if key in TARGETS: refs[j+1]=key
    if not refs: continue
    inv={v:k for k,v in refs.items()}
    for i,e in enumerate(p.exports):
        if p.class_of(e)!='Function': continue
        off=e['off']; stosz=ri(p.b,off+44); s=p.b[off+48:off+48+stosz]
        hits=[]
        for k in range(len(s)-4):
            if s[k] in (0x1B,0x1C,0x1D,0x1E,0x46):
                v=struct.unpack_from('<i',s,k+1)[0]
                if v in refs: hits.append((s[k],refs[v]))
        if hits:
            out.write("%s\t%s\t%s\n"%(f,p.path(i+1),";".join("%02X:%s"%h for h in hits)))
out.close()
