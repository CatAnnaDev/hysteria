class PhysicsAssetInstance extends Object
    native
    notplaceable
    hidecategories(Object);

var const transient Actor Owner;
var const transient int RootBodyIndex;
var const export editinline array<RB_BodyInstance> Bodies;
var const export editinline array<RB_ConstraintInstance> Constraints;
var const native Map_Mirror CollisionDisableTable;
var const float LinearSpringScale;
var const float LinearDampingScale;
var const float LinearForceLimitScale;
var const float AngularSpringScale;
var const float AngularDampingScale;
var const float AngularForceLimitScale;
var const bool bInitBodies;

native final function RB_ConstraintInstance FindConstraintInstance(name ConName, PhysicsAsset InAsset)
{
    ConName;
    InAsset;
}

native final function RB_BodyInstance FindBodyInstance(name BodyName, PhysicsAsset InAsset)
{
    BodyName;
    InAsset;
}

native final function SetFullAnimWeightBonesFixed(bool bNewFixed, SkeletalMeshComponent SkelMesh)
{
    bNewFixed;
    SkelMesh;
}

native final function SetFullAnimWeightBlockRigidBody(bool bNewBlockRigidBody, SkeletalMeshComponent SkelMesh)
{
    bNewBlockRigidBody;
    SkelMesh;
}

native final function SetNamedBodiesBlockRigidBody(bool bNewBlockRigidBody, array<name> BoneNames, SkeletalMeshComponent SkelMesh)
{
    bNewBlockRigidBody;
    BoneNames;
    SkelMesh;
}

native final function SetNamedRBBoneSprings(bool bEnable, array<name> BoneNames, float InBoneLinearSpring, float InBoneAngularSpring, SkeletalMeshComponent SkelMeshComp)
{
    bEnable;
    BoneNames;
    InBoneLinearSpring;
    InBoneAngularSpring;
    SkelMeshComp;
}

native final function SetNamedMotorsAngularVelocityDrive(bool bEnableSwingDrive, bool bEnableTwistDrive, array<name> BoneNames, SkeletalMeshComponent SkelMeshComp, optional bool bSetOtherBodiesToComplement)
{
    bEnableSwingDrive;
    bEnableTwistDrive;
    BoneNames;
    SkelMeshComp;
    bSetOtherBodiesToComplement;
}

native final function SetNamedMotorsAngularPositionDrive(bool bEnableSwingDrive, bool bEnableTwistDrive, array<name> BoneNames, SkeletalMeshComponent SkelMeshComp, optional bool bSetOtherBodiesToComplement)
{
    bEnableSwingDrive;
    bEnableTwistDrive;
    BoneNames;
    SkelMeshComp;
    bSetOtherBodiesToComplement;
}

native final function SetAllMotorsAngularDriveParams(float InSpring, float InDamping, float InForceLimit, optional SkeletalMeshComponent SkelMesh, optional bool bSkipFullAnimWeightBodies)
{
    InSpring;
    InDamping;
    InForceLimit;
    SkelMesh;
    bSkipFullAnimWeightBodies;
}

native final function SetAllMotorsAngularVelocityDrive(bool bEnableSwingDrive, bool bEnableTwistDrive, SkeletalMeshComponent SkelMeshComp, optional bool bSkipFullAnimWeightBodies)
{
    bEnableSwingDrive;
    bEnableTwistDrive;
    SkelMeshComp;
    bSkipFullAnimWeightBodies;
}

native final function SetAllMotorsAngularPositionDrive(bool bEnableSwingDrive, bool bEnableTwistDrive, optional SkeletalMeshComponent SkelMesh, optional bool bSkipFullAnimWeightBodies)
{
    bEnableSwingDrive;
    bEnableTwistDrive;
    SkelMesh;
    bSkipFullAnimWeightBodies;
}

native final function ForceAllBodiesBelowUnfixed(out const name InBoneName, PhysicsAsset InAsset, SkeletalMeshComponent InSkelMesh, bool InbInstanceAlwaysFullAnimWeight)
{
    InBoneName;
    InAsset;
    InSkelMesh;
    InbInstanceAlwaysFullAnimWeight;
}

native final function SetNamedBodiesFixed(bool bNewFixed, array<name> BoneNames, SkeletalMeshComponent SkelMesh, optional bool bSetOtherBodiesToComplement, optional bool bSkipFullAnimWeightBodies)
{
    bNewFixed;
    BoneNames;
    SkelMesh;
    bSetOtherBodiesToComplement;
    bSkipFullAnimWeightBodies;
}

native final function SetAllBodiesFixed(bool bNewFixed)
{
    bNewFixed;
}

native final function float GetTotalMassBelowBone(name InBoneName, PhysicsAsset InAsset, SkeletalMesh InSkelMesh)
{
    InBoneName;
    InAsset;
    InSkelMesh;
}

native final function SetAngularDriveScale(float InAngularSpringScale, float InAngularDampingScale, float InAngularForceLimitScale)
{
    InAngularSpringScale;
    InAngularDampingScale;
    InAngularForceLimitScale;
}

native final function SetLinearDriveScale(float InLinearSpringScale, float InLinearDampingScale, float InLinearForceLimitScale)
{
    InLinearSpringScale;
    InLinearDampingScale;
    InLinearForceLimitScale;
}

defaultproperties
{
    LinearSpringScale=1.0
    LinearDampingScale=1.0
    LinearForceLimitScale=1.0
    AngularSpringScale=1.0
    AngularDampingScale=1.0
    AngularForceLimitScale=1.0
    bInitBodies=True
}
