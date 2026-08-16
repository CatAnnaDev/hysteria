class AnimNodeBlend extends AnimNodeBlendBase
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var float Child2Weight;
var float Child2WeightTarget;
var float BlendTimeToGo;
var() bool bSkipBlendWhenNotRendered;

native final function SetBlendTarget(float BlendTarget, float BlendTime)
{
    BlendTarget;
    BlendTime;
}

defaultproperties
{
    bSkipBlendWhenNotRendered=True
    Children(0)=(Name="Child1",Anim="None",Weight=1.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(1)=(Name="Child2",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    bFixNumChildren=True
}
