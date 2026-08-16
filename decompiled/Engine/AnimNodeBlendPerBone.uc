class AnimNodeBlendPerBone extends AnimNodeBlend
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var() const bool bForceLocalSpaceBlend;
var() array<name> BranchStartBoneName;
var array<float> Child2PerBoneWeight;
var array<byte> LocalToCompReqBones;

defaultproperties
{
    Children(0)=(Name="Source",Anim="None",Weight=1.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(1)=(Name="Target",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    CategoryDesc="Filter"
}
