class AnimNodeScalePlayRate extends AnimNodeBlendBase
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var() float ScaleByValue;

defaultproperties
{
    ScaleByValue=1.0
    Children(0)=(Name="Input",Anim="None",Weight=1.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    bFixNumChildren=True
    bSkipTickWhenZeroWeight=True
}
