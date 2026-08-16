class AliceGameAnimNode_BlendByLegState extends AliceGameAnimNode_BlendList
    native
    notplaceable
    hidecategories(Object,Object,Object,Object);

enum ELegState
{
    ELS_None,
    ELS_Idle,
    ELS_LeftLeg,
    ELS_RightLeg,
};

var() float BlendTime;
var float Threshold_FootStep;
var ELegState LegState;
var ELegState oldLegState;

defaultproperties
{
    BlendTime=0.1
    Threshold_FootStep=18.0
    LegState="ELS_Idle"
    Children(0)=(Name="ELS_LeftLeg",Anim="None",Weight=1.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    Children(1)=(Name="ELS_RightLeg",Anim="None",Weight=0.0,TotalWeight=0.0,BlendWeight=0.0,bHasRootMotion=0,RootMotion=(Rotation=(X=0.0,Y=0.0,Z=0.0,W=0.0),Translation=(X=0.0,Y=0.0,Z=0.0),Scale=0.0),bMirrorSkeleton=False,bIsAdditive=False,DrawY=0)
    bFixNumChildren=True
}
