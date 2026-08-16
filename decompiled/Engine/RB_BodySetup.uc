class RB_BodySetup extends KMeshProps
    native
    notplaceable
    hidecategories(Object);

enum ESleepFamily
{
    SF_Normal,
    SF_Sensitive,
};

struct KCachedConvexData
{
    var native array<KCachedConvexDataElement> CachedConvexElements;
};

struct KCachedConvexDataElement
{
    var native array<byte> ConvexElementData;
};

var() ESleepFamily SleepFamily;
var() editconst name BoneName;
var() bool bFixed;
var() bool bNoCollision;
var() bool bBlockZeroExtent;
var() bool bBlockNonZeroExtent;
var() bool bEnableContinuousCollisionDetection;
var() bool bAlwaysFullAnimWeight;
var() bool bConsiderForBounds;
var() PhysicalMaterial PhysMaterial;
var() float MassScale;
var() array<name> EffectSocketNameArray;
var const native array<Pointer> CollisionGeom;
var const native array<Vector> CollisionGeomScale3D;
var() const array<Vector> PreCachedPhysScale;
var const native array<KCachedConvexData> PreCachedPhysData;
var const int PreCachedPhysDataVersion;

defaultproperties
{
    bBlockZeroExtent=True
    bBlockNonZeroExtent=True
    bConsiderForBounds=True
    MassScale=1.0
}
