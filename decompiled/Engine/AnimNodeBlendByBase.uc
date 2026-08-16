class AnimNodeBlendByBase extends AnimNodeBlendList
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

enum EBaseBlendType
{
    BBT_ByActorTag,
    BBT_ByActorClass,
};

var() EBaseBlendType Type;
var() name ActorTag;
var() class<Actor> ActorClass;
var() float BlendTime;
var transient Actor CachedBase;

defaultproperties
{
    BlendTime=0.2
    Children(0)=(Name="Normal",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(1)=(Name="Based",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    bFixNumChildren=True
    bSkipTickWhenZeroWeight=True
}
