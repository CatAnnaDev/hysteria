class SkelControlShake extends SkelControlBase
    native
    notplaceable
    hidecategories(Object,Object);

var bool bApplyTranslation;
var(Adjustments) bool bApplyRotation;
var bool bAddTranslation;
var(Rotation) bool bAddRotation;
var(Rotation) bool bRemoveMeshRotation;
var(Adjustments) float MaxAngle;
var(Adjustments) int Frequency;
var Vector BoneTranslation;
var EBoneControlSpace BoneTranslationSpace;
var(Rotation) EBoneControlSpace BoneRotationSpace;
var name TranslationSpaceBoneName;
var(Rotation) Rotator BoneRotation;
var(Rotation) name RotationSpaceBoneName;
var float fTimes;

defaultproperties
{
    bApplyRotation=True
    bAddRotation=True
    MaxAngle=30.0
    Frequency=60
    BoneRotationSpace="BCS_ActorSpace"
    CategoryDesc="Single Bone"
}
