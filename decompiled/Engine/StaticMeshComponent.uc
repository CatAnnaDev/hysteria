class StaticMeshComponent extends MeshComponent
    native
    noexport
    notplaceable
    editinlinenew
    hidecategories(Object);

struct StaticMeshComponentLODInfo
{
    var const array<ShadowMap2D> ShadowMaps;
    var const array<Object> ShadowVertexBuffers;
    var const native Pointer LightMap;
    var const native Pointer OverrideVertexColors;
};

var() int ForcedLodModel;
var int PreviousLODLevel;
var() const StaticMesh StaticMesh;
var() Color WireframeColor;
var() bool bIgnoreInstanceForTextureStreaming;
var const deprecated bool bOverrideLightMapResolution;
var() const bool bOverrideLightMapRes;
var const deprecated int OverriddenLightMapResolution;
var() const int OverriddenLightMapRes;
var() float OverriddenLODMaxRange;
var(AdvancedLighting) const int SubDivisionStepSize;
var(AdvancedLighting) const bool bUseSubDivisions;
var const transient bool bForceStaticDecals;
var(Physics) bool bNeverBecomeDynamic;
var const bool bOwnerBlockWeapons;
var const array<Guid> IrrelevantLights;
var const native array<StaticMeshComponentLODInfo> LODData;
var(Lightmass) LightmassPrimitiveSettings LightmassSettings;

native function bool CanBecomeDynamic()
{
}

native final function SetForceStaticDecals(bool bInForceStaticDecals)
{
    bInForceStaticDecals;
}

native simulated function DisableRBCollisionWithSMC(PrimitiveComponent OtherSMC, bool bDisabled)
{
    OtherSMC;
    bDisabled;
}

native simulated function bool SetStaticMesh(StaticMesh NewMesh, optional bool bForce)
{
    NewMesh;
    bForce;
}

defaultproperties
{
    WireframeColor=(B=255,G=255,R=0,A=255)
    OverriddenLightMapRes=64
    SubDivisionStepSize=32
    bUseSubDivisions=True
    LightmassSettings=(bUseTwoSidedLighting=False,bShadowIndirectOnly=False,bUseEmissiveForStaticLighting=False,EmissiveLightFalloffExponent=2.0,EmissiveLightExplicitInfluenceRadius=0.0,EmissiveBoost=1.0,DiffuseBoost=1.0,SpecularBoost=1.0,FullyOccludedSamplesFraction=1.0)
    ReplacementPrimitive="None"
    bAcceptsStaticDecals=True
    CollideActors=True
    BlockActors=True
    BlockZeroExtent=True
    BlockNonZeroExtent=True
    BlockRigidBody=True
    TickGroup="TG_PreAsyncWork"
}
