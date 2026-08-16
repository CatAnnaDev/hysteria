class HairComponent extends PrimitiveComponent
    native
    notplaceable
    editinlinenew;

var() Hair Template;
var(Simulation) PhysicsAsset PhysicsAsset;
var(Simulation) Vector Force;
var(Simulation) Vector PerturbAmplitude;
var(Simulation) Vector PerturbTemporalPeriod;
var(Simulation) Vector PerturbSpatialPeriod;
var(Simulation) Vector PerturbPhaseShift;
var(Simulation) float Damping;
var(Simulation) int Iteration;
var(Simulation) float LengthScale;
var(Render) MaterialInterface Material;
var(Render) int TessellationStep;
var(Render) float StrandWidth;
var(Render) int SortOffset;
var(Debug) bool bVisualizeStrands;
var(Debug) bool bVisualizePatches;
var(Debug) bool bVisualizeSpheres;
var(Debug) bool bVisualizeTessellation;
var native bool bJustAttached;
var native bool bPendingReset;
var const native Pointer Simulator;
var const native Pointer ReleaseResourcesFence;
var native float DeltaTime;
var transient export editinline SkeletalMeshComponent OverrideMesh;

native function Reset()
{
}

defaultproperties
{
    Force=(X=0.0,Y=0.0,Z=-980.0)
    PerturbTemporalPeriod=(X=2.0,Y=2.1,Z=2.2)
    PerturbSpatialPeriod=(X=0.1,Y=0.1,Z=0.1)
    Damping=7.0
    Iteration=1
    LengthScale=1.0
    TessellationStep=2
    StrandWidth=1.5
    SortOffset=4
    ReplacementPrimitive="None"
    bAcceptsLights=True
    bTickInEditor=True
    TickGroup="TG_PreAsyncWork"
}
