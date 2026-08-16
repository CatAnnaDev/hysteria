class FoliageComponent extends PrimitiveComponent
    native
    notplaceable;

struct native StoredFoliageInstance extends FoliageInstanceBase
{
    var Color StaticLighting[3];
};

struct native FoliageInstanceBase
{
    var Vector Location;
    var Vector XAxis;
    var Vector YAxis;
    var Vector ZAxis;
    var float DistanceFactorSquared;
};

var const array<StoredFoliageInstance> LitInstances;
var const array<Guid> StaticallyRelevantLights;
var const array<Guid> StaticallyIrrelevantLights;
var const float DirectionalStaticLightingScale[3];
var const float SimpleStaticLightingScale[3];
var const StaticMesh InstanceStaticMesh;
var const MaterialInterface Material;
var float MaxDrawRadius;
var float MinTransitionRadius;
var float MinThinningRadius;
var Vector MinScale;
var Vector MaxScale;
var float SwayScale;
var LightmassPrimitiveSettings LightmassSettings;

defaultproperties
{
    LightmassSettings=(bUseTwoSidedLighting=False,bShadowIndirectOnly=False,bUseEmissiveForStaticLighting=False,EmissiveLightFalloffExponent=2.0,EmissiveLightExplicitInfluenceRadius=0.0,EmissiveBoost=1.0,DiffuseBoost=1.0,SpecularBoost=1.0,FullyOccludedSamplesFraction=1.0)
    ReplacementPrimitive="None"
    bForceDirectLightMap=True
    bAcceptsLights=True
    bUsePrecomputedShadows=True
}
