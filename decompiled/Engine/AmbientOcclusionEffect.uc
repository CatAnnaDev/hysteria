class AmbientOcclusionEffect extends PostProcessEffect
    native
    notplaceable
    hidecategories(Object);

enum EAmbientOcclusionQuality
{
    AO_High,
    AO_Medium,
    AO_Low,
};

var(Color) interp LinearColor OcclusionColor;
var(Color) float OcclusionPower;
var(Color) float OcclusionScale;
var(Color) float OcclusionBias;
var(Color) float MinOcclusion;
var deprecated bool SSAO2;
var(Occlusion) float OcclusionRadius;
var deprecated float OcclusionAttenuation;
var(Occlusion) EAmbientOcclusionQuality OcclusionQuality;
var(Occlusion) float OcclusionFadeoutMinDistance;
var(Occlusion) float OcclusionFadeoutMaxDistance;
var(Halo) float HaloDistanceThreshold;
var(Halo) float HaloDistanceScale;
var(Halo) float HaloOcclusion;
var(Filter) float EdgeDistanceThreshold;
var(Filter) float EdgeDistanceScale;
var(Filter) float FilterDistanceScale;
var deprecated int FilterSize;
var(History) float HistoryConvergenceTime;
var float HistoryWeightConvergenceTime;

defaultproperties
{
    OcclusionColor=(R=0.0,G=0.0,B=0.0,A=1.0)
    OcclusionPower=4.0
    OcclusionScale=20.0
    MinOcclusion=0.1
    OcclusionRadius=25.0
    OcclusionQuality="AO_Medium"
    OcclusionFadeoutMinDistance=4000.0
    OcclusionFadeoutMaxDistance=4500.0
    HaloDistanceThreshold=40.0
    HaloDistanceScale=0.1
    HaloOcclusion=0.04
    EdgeDistanceThreshold=10.0
    EdgeDistanceScale=0.003
    FilterDistanceScale=10.0
    HistoryWeightConvergenceTime=0.07
    bAffectsLightingOnly=True
    SceneDPG="SDPG_World"
}
