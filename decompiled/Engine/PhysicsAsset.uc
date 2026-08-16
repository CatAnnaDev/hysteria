class PhysicsAsset extends Object
    native
    notplaceable
    hidecategories(Object);

var const editoronly SkeletalMesh DefaultSkelMesh;
var const export editinline array<RB_BodySetup> BodySetup;
var const native Map_Mirror BodySetupIndexMap;
var const array<int> BoundsBodies;
var const export editinline array<RB_ConstraintSetup> ConstraintSetup;
var const export editinline PhysicsAssetInstance DefaultInstance;

native function bool DetectAABBHitGround(out PhysicalMaterial PhysMat, out Vector HitLocation, SkeletalMeshComponent SkelComp, Vector GroundLoc, Vector vExtent, optional bool bDebugInfo = false)
{
    PhysMat;
    HitLocation;
    SkelComp;
    GroundLoc;
    vExtent;
    bDebugInfo;
}

native function bool DetectRBHitGround(name BodyName, SkeletalMeshComponent SkelComp, Vector GroundLoc, Vector vExtent)
{
    BodyName;
    SkelComp;
    GroundLoc;
    vExtent;
}

native final function int FindBodyIndex(name BodyName)
{
    BodyName;
}

defaultproperties
{
}
