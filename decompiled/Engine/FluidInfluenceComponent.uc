class FluidInfluenceComponent extends PrimitiveComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object,Collision,Lighting,Physics,PrimitiveComponent,Rendering)
    autoexpandcategories(FluidInfluenceComponent);

enum EInfluenceType
{
    Fluid_Flow,
    Fluid_Raindrops,
    Fluid_Wave,
    Fluid_Sphere,
};

var() bool bActive;
var(FluidRaindrops) interp bool RaindropFillEntireFluid;
var transient bool bIsToggleTriggered;
var() FluidSurfaceActor FluidActor;
var() EInfluenceType InfluenceType;
var() float MaxDistance;
var(FluidWave) interp float WaveStrength;
var(FluidWave) interp float WaveFrequency;
var(FluidWave) interp float WavePhase;
var(FluidWave) interp float WaveRadius;
var(FluidRaindrops) interp float RaindropAreaRadius;
var(FluidRaindrops) interp float RaindropRadius;
var(FluidRaindrops) interp float RaindropStrength;
var(FluidRaindrops) interp float RaindropRate;
var(FluidFlow) interp float FlowSpeed;
var(FluidFlow) interp int FlowNumRipples;
var(FluidFlow) interp float FlowSideMotionRadius;
var(FluidFlow) interp float FlowWaveRadius;
var(FluidFlow) interp float FlowStrength;
var(FluidFlow) interp float FlowFrequency;
var(FluidSphere) interp float SphereOuterRadius;
var(FluidSphere) interp float SphereInnerRadius;
var(FluidSphere) interp float SphereStrength;
var native transient float CurrentAngle;
var native transient float CurrentTimer;
var native transient FluidSurfaceActor CurrentFluidActor;

defaultproperties
{
    bActive=True
    RaindropFillEntireFluid=True
    InfluenceType="Fluid_Wave"
    MaxDistance=1000.0
    WaveStrength=40.0
    WaveFrequency=1.0
    WaveRadius=50.0
    RaindropAreaRadius=300.0
    RaindropRadius=10.0
    RaindropStrength=5.0
    RaindropRate=20.0
    FlowSpeed=100.0
    FlowNumRipples=10
    FlowSideMotionRadius=30.0
    FlowWaveRadius=50.0
    FlowStrength=20.0
    FlowFrequency=4.0
    SphereOuterRadius=100.0
    SphereInnerRadius=50.0
    SphereStrength=-40.0
    ReplacementPrimitive="None"
    bTickInEditor=True
}
