class SkelControlLookAt extends SkelControlBase
    native
    notplaceable
    hidecategories(Object,Object);

var(LookAt) Vector TargetLocation;
var(LookAt) EBoneControlSpace TargetLocationSpace;
var(LookAt) EAxis LookAtAxis;
var(LookAt) EAxis UpAxis;
var(Limit) EBoneControlSpace AllowRotationSpace;
var(LookAt) name TargetSpaceBoneName;
var(LookAt) bool bInvertLookAtAxis;
var(LookAt) bool bDefineUpAxis;
var(LookAt) bool bInvertUpAxis;
var(Limit) bool bEnableLimit;
var(Limit) bool bLimitBasedOnRefPose;
var(Limit) bool bDisableBeyondLimit;
var(Limit) bool bNotifyBeyondLimit;
var(Limit) bool bShowLimit;
var(Limit) bool bAllowRotationX;
var(Limit) bool bAllowRotationY;
var(Limit) bool bAllowRotationZ;
var(LookAt) float TargetLocationInterpSpeed;
var Vector DesiredTargetLocation;
var(Limit) float MaxAngle;
var(Limit) float OuterMaxAngle;
var(Limit) float DeadZoneAngle;
var(Limit) name AllowRotationOtherBoneName;
var const transient float LookAtAlpha;
var const transient float LookAtAlphaTarget;
var const transient float LookAtAlphaBlendTimeToGo;
var const transient Vector LimitLookDir;
var const transient Vector BaseLookDir;
var const transient Vector BaseBonePos;
var const transient float LastCalcTime;

native final function bool CanLookAtPoint(Vector PointLoc, optional bool bDrawDebugInfo, optional bool bDebugUsePersistentLines, optional bool bDebugFlushLinesFirst)
{
    PointLoc;
    bDrawDebugInfo;
    bDebugUsePersistentLines;
    bDebugFlushLinesFirst;
}

native final function SetLookAtAlpha(float DesiredAlpha, float DesiredBlendTime)
{
    DesiredAlpha;
    DesiredBlendTime;
}

native final function InterpolateTargetLocation(float DeltaTime)
{
    DeltaTime;
}

native final function SetTargetLocation(Vector NewTargetLocation)
{
    NewTargetLocation;
}

defaultproperties
{
    LookAtAxis="AXIS_X"
    UpAxis="AXIS_Z"
    AllowRotationSpace="BCS_BoneSpace"
    bLimitBasedOnRefPose=True
    bShowLimit=True
    bAllowRotationX=True
    bAllowRotationY=True
    bAllowRotationZ=True
    TargetLocationInterpSpeed=10.0
    OuterMaxAngle=90.0
    LookAtAlpha=1.0
    LookAtAlphaTarget=1.0
}
