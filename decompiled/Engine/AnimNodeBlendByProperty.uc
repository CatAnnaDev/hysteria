class AnimNodeBlendByProperty extends AnimNodeBlendList
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var() name PropertyName;
var() bool bUseOwnersBase;
var() bool bUseSpecificBlendTimes;
var(Editor) bool bSynchronizeNodesInEditor;
var transient name CachedPropertyName;
var transient Property CachedProperty;
var transient Actor CachedOwner;
var() float BlendTime;
var() float FloatPropMin;
var() float FloatPropMax;
var() float BlendToChild1Time;
var() float BlendToChild2Time;

defaultproperties
{
    bSynchronizeNodesInEditor=True
    BlendTime=0.1
    FloatPropMax=1.0
    BlendToChild1Time=0.1
    BlendToChild2Time=0.1
    bForceChildFullWeightWhenBecomingRelevant=False
    Children(0)=(Name="Child1",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(1)=(Name="Child2",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
}
