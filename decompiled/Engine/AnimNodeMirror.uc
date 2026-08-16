class AnimNodeMirror extends AnimNodeBlendBase
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var() bool bEnableMirroring;

defaultproperties
{
    bEnableMirroring=True
    Children(0)=(Name="Child",Anim="None",Weight=1.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    bFixNumChildren=True
    CategoryDesc="Mirror"
}
