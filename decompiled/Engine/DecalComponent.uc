class DecalComponent extends PrimitiveComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Collision,Object,Physics,PrimitiveComponent);

enum EFilterMode
{
    FM_None,
    FM_Ignore,
    FM_Affect,
};

enum EDecalTransform
{
    DecalTransform_OwnerAbsolute,
    DecalTransform_OwnerRelative,
    DecalTransform_SpawnRelative,
};

struct native DecalReceiver
{
    var const export editinline PrimitiveComponent Component;
    var const native Pointer RenderData;
};

var(Decal) const MaterialInterface DecalMaterial;
var(Decal) float Width;
var(Decal) float Height;
var(Decal) float TileX;
var(Decal) float TileY;
var(Decal) float OffsetX;
var(Decal) float OffsetY;
var(Decal) float DecalRotation;
var float FieldOfView;
var(Decal) float NearPlane;
var(Decal) float FarPlane;
var transient Vector Location;
var transient Rotator Orientation;
var Vector HitLocation;
var Vector HitNormal;
var Vector HitTangent;
var Vector HitBinormal;
var(Decal) bool bNoClip;
var(Decal) bool bAffectOtherLevels;
var const bool bStaticDecal;
var(DecalFilter) bool bProjectOnBackfaces;
var(DecalFilter) bool bProjectOnHidden;
var(DecalFilter) bool bProjectOnBSP;
var(DecalFilter) bool bProjectOnStaticMeshes;
var(DecalFilter) bool bProjectOnSkeletalMeshes;
var(DecalFilter) bool bProjectOnTerrain;
var bool bFlipBackfaceDirection;
var bool bMovableDecal;
var transient bool bHasBeenAttached;
var transient export editinline PrimitiveComponent HitComponent;
var transient name HitBone;
var transient int HitNodeIndex;
var transient int HitLevelIndex;
var transient int FracturedStaticMeshComponentIndex;
var const transient array<int> HitNodeIndices;
var const duplicatetransient array<DecalReceiver> DecalReceivers;
var const native transient duplicatetransient array<Pointer> StaticReceivers;
var const native transient duplicatetransient Pointer ReleaseResourcesFence;
var transient array<Plane> Planes;
var(DecalRender) float DepthBias;
var(DecalRender) float SlopeScaleDepthBias;
var(DecalRender) int SortOrder;
var(DecalRender) float BackfaceAngle;
var(DecalRender) float BackfaceAngleOnTerrain;
var(DecalRender) Vector2D BlendRange;
var const EDecalTransform DecalTransform;
var(DecalFilter) EFilterMode FilterMode;
var(DecalFilter) array<Actor> Filter;
var(DecalFilter) export editinline array<PrimitiveComponent> ReceiverImages;
var(DecalRender) Vector ParentRelativeLocation;
var(DecalRender) Rotator ParentRelativeOrientation;
var const transient Vector OriginalParentRelativeLocation;
var const transient Vector OriginalParentRelativeOrientationVec;

native final function MaterialInterface GetDecalMaterial()
{
}

native final function SetDecalMaterial(MaterialInterface NewDecalMaterial)
{
    NewDecalMaterial;
}

native final function ResetToDefaults()
{
}

defaultproperties
{
    Width=200.0
    Height=200.0
    TileX=1.0
    TileY=1.0
    FieldOfView=80.0
    FarPlane=300.0
    bProjectOnBSP=True
    bProjectOnStaticMeshes=True
    bProjectOnSkeletalMeshes=True
    bProjectOnTerrain=True
    HitNodeIndex=-1
    HitLevelIndex=-1
    DepthBias=-6e-05
    BackfaceAngle=0.2588
    BackfaceAngleOnTerrain=0.7071
    BlendRange=(X=89.5,Y=180.0)
    DecalTransform="DecalTransform_SpawnRelative"
    ReplacementPrimitive="None"
    bAcceptsDynamicDecals=False
    bCastDynamicShadow=False
    bAcceptsDynamicLights=False
}
