class RB_BodyInstance extends Object
    native
    notplaceable
    hidecategories(Object);

var const transient export editinline PrimitiveComponent OwnerComponent;
var const int BodyIndex;
var Vector Velocity;
var Vector PreviousVelocity;
var const native int SceneIndex;
var const native Pointer BodyData;
var const native Pointer BoneSpring;
var const native Pointer BoneSpringKinActor;
var(BoneSpring) bool bEnableBoneSpringLinear;
var(BoneSpring) bool bEnableBoneSpringAngular;
var(BoneSpring) bool bDisableOnOverextension;
var(BoneSpring) bool bNotifyOwnerOnOverextension;
var(BoneSpring) bool bTeleportOnOverextension;
var(BoneSpring) bool bUseKinActorForBoneSpring;
var(BoneSpring) bool bMakeSpringToBaseCollisionComponent;
var(Physics) const bool bOnlyCollideWithPawns;
var(Physics) const bool bEnableCollisionResponse;
var(Physics) const bool bPushBody;
var transient bool bForceUnfixed;
var transient bool bInstanceAlwaysFullAnimWeight;
var(BoneSpring) const float BoneLinearSpring;
var(BoneSpring) const float BoneLinearDamping;
var(BoneSpring) const float BoneAngularSpring;
var(BoneSpring) const float BoneAngularDamping;
var(BoneSpring) float OverextensionThreshold;
var() float CustomGravityFactor;
var transient float LastEffectPlayedTime;
var(Physics) const PhysicalMaterial PhysMaterialOverride;
var(Physics) float ContactReportForceThreshold;
var(Physics) float InstanceMassScale;
var(Physics) float InstanceDampingScale;

native final function UpdateDampingProperties()
{
}

native final function UpdateMassProperties(RB_BodySetup Setup)
{
    Setup;
}

native final function SetContactReportForceThreshold(float Threshold)
{
    Threshold;
}

native final function EnableCollisionResponse(bool bEnableResponse)
{
    bEnableResponse;
}

native final function SetPhysMaterialOverride(PhysicalMaterial NewPhysMaterial)
{
    NewPhysMaterial;
}

native final function SetBlockRigidBody(bool bNewBlockRigidBody)
{
    bNewBlockRigidBody;
}

native final function SetBoneSpringTarget(out const Matrix InBoneTarget, bool bTeleport)
{
    InBoneTarget;
    bTeleport;
}

native final function SetBoneSpringParams(float InLinearSpring, float InLinearDamping, float InAngularSpring, float InAngularDamping)
{
    InLinearSpring;
    InLinearDamping;
    InAngularSpring;
    InAngularDamping;
}

native final function EnableBoneSpring(bool bInEnableLinear, bool bInEnableAngular, out const Matrix InBoneTarget)
{
    bInEnableLinear;
    bInEnableAngular;
    InBoneTarget;
}

native final function Vector GetUnrealWorldVelocityAtPoint(Vector Point)
{
    Point;
}

native final function Vector GetUnrealWorldAngularVelocity()
{
}

native final function Vector GetUnrealWorldVelocity()
{
}

native final function Matrix GetUnrealWorldTM()
{
}

native final function PhysicsAssetInstance GetPhysicsAssetInstance()
{
}

native final function bool IsValidBodyInstance()
{
}

native final function bool IsFixed()
{
}

native final function SetFixed(bool bNewFixed)
{
    bNewFixed;
}

native final function float GetBodyMass()
{
}

defaultproperties
{
    bEnableCollisionResponse=True
    BoneLinearSpring=10.0
    BoneLinearDamping=0.1
    BoneAngularSpring=1.0
    BoneAngularDamping=0.1
    CustomGravityFactor=1.0
    ContactReportForceThreshold=-1.0
    InstanceMassScale=1.0
    InstanceDampingScale=1.0
}
