class AnimNodeAdditiveBlending extends AnimNodeBlend
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var() bool bPassThroughWhenNotRendered;

defaultproperties
{
    bPassThroughWhenNotRendered=True
    Child2Weight=1.0
    Child2WeightTarget=1.0
    Children(0)=(Name="Base Anim Input",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(1)=(Name="Additive Anim Input",Anim="None",Weight=1.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    bSkipTickWhenZeroWeight=True
    CategoryDesc="Additive"
}
