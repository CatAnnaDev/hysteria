class FluidSurfaceComponent extends PrimitiveComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object)
    autoexpandcategories(FluidSurfaceComponent,Fluid,FluidDetail);

struct LightMapRef
{
    var const native Pointer Reference;
};

var() MaterialInterface FluidMaterial;
var(Lighting) int LightMapResolution;
var(Lightmass) LightmassPrimitiveSettings LightmassSettings;
var(Fluid) bool EnableSimulation;
var(Fluid) bool EnableDetail;
var(FluidDebug) transient bool bPause;
var(FluidDebug) transient bool bShowSimulationNormals;
var(FluidDebug) bool bShowSimulationPosition;
var(FluidDebug) bool bShowDetailNormals;
var(FluidDebug) bool bShowDetailPosition;
var(FluidDebug) transient bool bShowFluidSimulation;
var(FluidDebug) transient bool bShowFluidDetail;
var(FluidDebug) bool bTestRipple;
var(FluidDebug) bool bTestRippleCenterOnDetail;
var(Fluid) int SimulationQuadsX;
var(Fluid) int SimulationQuadsY;
var(Fluid) float GridSpacing;
var(Fluid) float GridSpacingLowRes;
var(Fluid) Actor TargetSimulation;
var(Fluid) float GPUTessellationFactor;
var(Fluid) float FluidDamping;
var(Fluid) float FluidTravelSpeed;
var(Fluid) float FluidHeightScale;
var(Fluid) float FluidUpdateRate;
var(Fluid) float ForceImpact;
var(Fluid) float ForceContinuous;
var(Fluid) float LightingContrast;
var(Fluid) Actor TargetDetail;
var(Fluid) float DeactivationDistance;
var(FluidDetail) int DetailResolution;
var(FluidDetail) float DetailSize;
var(FluidDetail) float DetailDamping;
var(FluidDetail) float DetailTravelSpeed;
var(FluidDetail) float DetailTransfer;
var(FluidDetail) float DetailHeightScale;
var(FluidDetail) float DetailUpdateRate;
var(FluidDebug) float NormalLength;
var(FluidDebug) float TestRippleSpeed;
var(FluidDebug) float TestRippleFrequency;
var(FluidDebug) float TestRippleRadius;
var float FluidWidth;
var float FluidHeight;
var native transient float TestRippleTime;
var native transient float TestRippleAngle;
var native transient float DeactivationTimer;
var native transient float ViewDistance;
var native transient Vector SimulationPosition;
var native transient Vector DetailPosition;
var const array<byte> ClampMap;
var const array<ShadowMap2D> ShadowMaps;
var const native LightMapRef LightMap;
var const native transient Pointer FluidSimulation;

native final function SetSimulationPosition(Vector WorldPos)
{
    WorldPos;
}

native final function SetDetailPosition(Vector WorldPos)
{
    WorldPos;
}

native final function ApplyForce(Vector WorldPos, float Strength, float Radius, optional bool bImpulse)
{
    WorldPos;
    Strength;
    Radius;
    bImpulse;
}

defaultproperties
{
    LightMapResolution=128
    LightmassSettings=(bUseTwoSidedLighting=False,bShadowIndirectOnly=False,bUseEmissiveForStaticLighting=False,EmissiveLightFalloffExponent=2.0,EmissiveLightExplicitInfluenceRadius=0.0,EmissiveBoost=1.0,DiffuseBoost=1.0,SpecularBoost=1.0,FullyOccludedSamplesFraction=1.0)
    EnableSimulation=True
    EnableDetail=True
    bShowFluidSimulation=True
    bShowFluidDetail=True
    SimulationQuadsX=200
    SimulationQuadsY=200
    GridSpacing=10.0
    GridSpacingLowRes=800.0
    GPUTessellationFactor=1.0
    FluidDamping=1.0
    FluidTravelSpeed=1.0
    FluidHeightScale=1.0
    FluidUpdateRate=30.0
    ForceImpact=-3.0
    ForceContinuous=-200.0
    LightingContrast=1.0
    DeactivationDistance=3000.0
    DetailResolution=256
    DetailSize=500.0
    DetailDamping=1.0
    DetailTravelSpeed=1.0
    DetailTransfer=0.5
    DetailHeightScale=1.0
    DetailUpdateRate=30.0
    NormalLength=10.0
    TestRippleSpeed=1.0
    TestRippleFrequency=1.0
    TestRippleRadius=30.0
    FluidWidth=2000.0
    FluidHeight=2000.0
    ReplacementPrimitive="None"
    bIgnoreNearPlaneIntersection=True
    bForceDirectLightMap=True
    bAcceptsLights=True
    bUsePrecomputedShadows=True
    CollideActors=True
    BlockZeroExtent=True
    BlockNonZeroExtent=True
    bTickInEditor=True
}
