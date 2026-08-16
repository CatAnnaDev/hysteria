class ApexClothingAsset extends ApexAsset
    native
    notplaceable
    hidecategories(Object,Object);

var native Pointer MApexAsset;
var() const editfixedsize editoronly array<MaterialInterface> Materials;
var const deprecated ApexGenericAsset ApexClothingLibrary;
var() const bool bUseHardwareCloth;
var() const bool bFallbackSkinning;
var() const bool bSlowStart;
var() const bool bRecomputeNormals;
var() const int UVChannelForTangentUpdate;
var() const float MaxDistanceBlendTime;
var() const float ContinuousRotationThreshold;
var() const float ContinuousDistanceThreshold;
var() const float LodWeightsMaxDistance;
var() const float LodWeightsDistanceWeight;
var() const float LodWeightsBias;
var() const float LodWeightsBenefitsBias;

defaultproperties
{
    bUseHardwareCloth=True
    bSlowStart=True
    MaxDistanceBlendTime=1.0
    ContinuousRotationThreshold=84.0
    ContinuousDistanceThreshold=50.0
    LodWeightsMaxDistance=10000.0
    LodWeightsDistanceWeight=1.0
}
