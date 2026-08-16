class AliceGameAnimNode_BlendByAngleBetweenInputAndPlayer extends AliceGameAnimNode_BlendList
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

var Vector Acceleration;
var Vector PreviousAcceleration;
var float AccelVariation;
var int LastChannel;
var() float BlendTime;
var() array<float> Constraints;
var float Angle;
var int LastChildIndex;
var int PendingChildIndex;
var float PendingTimeToGo;

defaultproperties
{
    Constraints(0)=-120.0
    Constraints(1)=-60.0
    Constraints(2)=0.0
    Constraints(3)=60.0
    Constraints(4)=120.0
    Children(0)=(Name="180 left",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(1)=(Name="90 left",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(2)=(Name="blending left",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(3)=(Name="blending right",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(4)=(Name="90 right",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(5)=(Name="180 right",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    bFixNumChildren=True
    bSkipTickWhenZeroWeight=True
}
