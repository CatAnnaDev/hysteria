class RB_ConstraintInstance extends Object
    native
    notplaceable
    hidecategories(Object);

var const transient Actor Owner;
var const transient export editinline PrimitiveComponent OwnerComponent;
var const int ConstraintIndex;
var const native int SceneIndex;
var const native bool bInHardware;
var(Linear) const bool bLinearXPositionDrive;
var(Linear) const bool bLinearXVelocityDrive;
var(Linear) const bool bLinearYPositionDrive;
var(Linear) const bool bLinearYVelocityDrive;
var(Linear) const bool bLinearZPositionDrive;
var(Linear) const bool bLinearZVelocityDrive;
var(Angular) const bool bSwingPositionDrive;
var(Angular) const bool bSwingVelocityDrive;
var(Angular) const bool bTwistPositionDrive;
var(Angular) const bool bTwistVelocityDrive;
var(Angular) const bool bAngularSlerpDrive;
var bool bTerminated;
var const native Pointer ConstraintData;
var(Linear) const Vector LinearPositionTarget;
var(Linear) const Vector LinearVelocityTarget;
var(Linear) const float LinearDriveSpring;
var(Linear) const float LinearDriveDamping;
var(Linear) const float LinearDriveForceLimit;
var(Angular) const Quat AngularPositionTarget;
var(Angular) const Vector AngularVelocityTarget;
var(Angular) const float AngularDriveSpring;
var(Angular) const float AngularDriveDamping;
var(Angular) const float AngularDriveForceLimit;
var const native Pointer DummyKinActor;

native final function MoveKinActorTransform(out Matrix NewTM)
{
    NewTM;
}

native final function SetLinearLimitSize(float NewLimitSize)
{
    NewLimitSize;
}

native final function SetAngularDOFLimitScale(float InSwing1LimitScale, float InSwing2LimitScale, float InTwistLimitScale, RB_ConstraintSetup InSetup)
{
    InSwing1LimitScale;
    InSwing2LimitScale;
    InTwistLimitScale;
    InSetup;
}

native final function SetAngularDriveParams(float InSpring, float InDamping, float InForceLimit)
{
    InSpring;
    InDamping;
    InForceLimit;
}

native final function SetAngularVelocityTarget(Vector InVelTarget)
{
    InVelTarget;
}

native final function SetAngularPositionTarget(out const Quat InPosTarget)
{
    InPosTarget;
}

native final function SetLinearDriveParams(float InSpring, float InDamping, float InForceLimit)
{
    InSpring;
    InDamping;
    InForceLimit;
}

native final function SetLinearVelocityTarget(Vector InVelTarget)
{
    InVelTarget;
}

native final function SetLinearPositionTarget(Vector InPosTarget)
{
    InPosTarget;
}

native final function SetAngularVelocityDrive(bool bEnableSwingDrive, bool bEnableTwistDrive)
{
    bEnableSwingDrive;
    bEnableTwistDrive;
}

native final function SetAngularPositionDrive(bool bEnableSwingDrive, bool bEnableTwistDrive)
{
    bEnableSwingDrive;
    bEnableTwistDrive;
}

native final function SetLinearVelocityDrive(bool bEnableXDrive, bool bEnableYDrive, bool bEnableZDrive)
{
    bEnableXDrive;
    bEnableYDrive;
    bEnableZDrive;
}

native final function SetLinearPositionDrive(bool bEnableXDrive, bool bEnableYDrive, bool bEnableZDrive)
{
    bEnableXDrive;
    bEnableYDrive;
    bEnableZDrive;
}

native final function Vector GetConstraintLocation()
{
}

native final function PhysicsAssetInstance GetPhysicsAssetInstance()
{
}

native final function TermConstraint()
{
}

native final function InitConstraint(PrimitiveComponent PrimComp1, PrimitiveComponent PrimComp2, RB_ConstraintSetup Setup, float Scale, Actor InOwner, PrimitiveComponent InPrimComp, bool bMakeKinForBody1)
{
    PrimComp1;
    PrimComp2;
    Setup;
    Scale;
    InOwner;
    InPrimComp;
    bMakeKinForBody1;
}

defaultproperties
{
    LinearDriveSpring=50.0
    LinearDriveDamping=1.0
    AngularPositionTarget=(X=0.0,Y=0.0,Z=0.0,W=1.0)
    AngularDriveSpring=50.0
    AngularDriveDamping=1.0
}
