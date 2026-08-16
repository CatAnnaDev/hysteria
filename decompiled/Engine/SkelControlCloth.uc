class SkelControlCloth extends SkelControlBase
    native
    notplaceable
    hidecategories(Object,Object);

struct native SimBone
{
    var const native Pointer Simulator;
    var array<int> BoneIndices;
};

var(Simulation) Vector Force;
var(Simulation) Vector PerturbAmplitude;
var(Simulation) Vector PerturbTemporalPeriod;
var(Simulation) Vector PerturbSpatialPeriod;
var(Simulation) Vector PerturbPhaseShift;
var(Simulation) Vector RadialForcePosition;
var(Simulation) float RadialForceMagnitude;
var(Simulation) float Damping;
var(Simulation) int Iteration;
var(Simulation) PhysicsAsset ClothPhysicsAsset;
var(Cloth) int ParentBoneCount;
var(Cloth) float GuideRestitutionRoot;
var(Cloth) float GuideRestitutionDecay;
var(Cloth) float MaxGuideDistance;
var(Cloth) float WorldScale;
var(Cloth) EAxis BoneAxis;
var(Debug) bool bVisualizeSimulation;
var(Debug) bool bVisualizeSpheres;
var(Debug) bool bVisualizeBones;
var native bool bPendingReset;
var native float LastDeltaTime;
var transient array<SimBone> SimBones;

defaultproperties
{
    Force=(X=0.0,Y=0.0,Z=-980.0)
    PerturbTemporalPeriod=(X=1.0,Y=1.1,Z=1.2)
    PerturbSpatialPeriod=(X=0.01,Y=0.01,Z=0.01)
    Damping=5.0
    Iteration=2
    ParentBoneCount=2
    GuideRestitutionRoot=2000.0
    GuideRestitutionDecay=0.75
    MaxGuideDistance=100.0
    BoneAxis="AXIS_X"
    CategoryDesc="Cloth"
}
