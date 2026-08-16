class ClothComponent extends SkeletalMeshComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

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
var(ClothSpec) float GuideRestitutionRoot;
var(ClothSpec) float GuideRestitutionDecay;
var(ClothSpec) float MaxGuideDistance;
var(ClothSpec) array<name> BranchRingLinks;
var(ClothSpec) float WorldScale;
var(ClothSpec) float RingGuideRestitutionRoot;
var(ClothSpec) float RingGuideRestitutionDecay;
var(ClothSpec) int SpringLinkPerRingLink;
var(ClothSpec) name FixedBone;
var(ClothSpec) Vector FixedBonePosition;
var(ClothSpec) float FixedBoneGuideRestitution;
var(ClothSpec) float FixedBoneMaxGuideDistance;
var(ClothSpec) name FixedTargetClothName;
var(ClothSpec) name FixedTargetBone;
var(ClothSpec) name ClothName;
var(Debug) bool bVisualizeSimulation;
var(Debug) bool bVisualizeSpheres;
var(Debug) bool bVisualizeBones;
var native bool bJustAttached;
var native bool bPendingReset;
var const native Pointer Simulator;
var native float DeltaTime;
var native int boneNodeCount;
var native int FixedNodeIndex;
var native int FixedTargetNodeIndex;

native function SetClothSpec(name TargetClothName, float NewGuideRestitutionDecay)
{
    TargetClothName;
    NewGuideRestitutionDecay;
}

native function DeleteSimulator()
{
}

native function Reset()
{
}

defaultproperties
{
    Force=(X=0.0,Y=0.0,Z=-980.0)
    PerturbTemporalPeriod=(X=1.0,Y=1.1,Z=1.2)
    PerturbSpatialPeriod=(X=0.01,Y=0.01,Z=0.01)
    Damping=5.0
    Iteration=1
    GuideRestitutionRoot=1000.0
    GuideRestitutionDecay=0.75
    MaxGuideDistance=10.0
    RingGuideRestitutionRoot=1000.0
    RingGuideRestitutionDecay=0.6
    SpringLinkPerRingLink=2
    FixedBoneGuideRestitution=1000.0
    ReplacementPrimitive="None"
}
