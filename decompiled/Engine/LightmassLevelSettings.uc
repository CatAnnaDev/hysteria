class LightmassLevelSettings extends Object
    native
    notplaceable
    deprecated
    hidecategories(Object);

var(General) int NumIndirectLightingBounces;
var(General) Color EnvironmentColor;
var(General) float EnvironmentIntensity;
var(General) float EmissiveBoost;
var(General) float DiffuseBoost;
var float SpecularBoost;
var(Occlusion) bool bUseAmbientOcclusion;
var(Occlusion) bool bVisualizeAmbientOcclusion;
var(Occlusion) float DirectIlluminationOcclusionFraction;
var(Occlusion) float IndirectIlluminationOcclusionFraction;
var(Occlusion) float OcclusionExponent;
var(Occlusion) float FullyOccludedSamplesFraction;
var(Occlusion) float MaxOcclusionDistance;

defaultproperties
{
    NumIndirectLightingBounces=3
    EnvironmentIntensity=1.0
    EmissiveBoost=1.0
    DiffuseBoost=5.0
    SpecularBoost=1.0
    DirectIlluminationOcclusionFraction=0.5
    IndirectIlluminationOcclusionFraction=1.0
    OcclusionExponent=1.0
    FullyOccludedSamplesFraction=1.0
    MaxOcclusionDistance=200.0
}
