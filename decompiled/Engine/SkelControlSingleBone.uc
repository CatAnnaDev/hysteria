class SkelControlSingleBone extends SkelControlBase
    native
    notplaceable
    hidecategories(Object,Object);

var(Adjustments) bool bApplyTranslation;
var(Adjustments) bool bApplyRotation;
var(Translation) bool bAddTranslation;
var(Rotation) bool bAddRotation;
var(Rotation) bool bRemoveMeshRotation;
var(Translation) Vector BoneTranslation;
var(Translation) EBoneControlSpace BoneTranslationSpace;
var(Rotation) EBoneControlSpace BoneRotationSpace;
var(Translation) name TranslationSpaceBoneName;
var(Rotation) Rotator BoneRotation;
var(Rotation) name RotationSpaceBoneName;

defaultproperties
{
    CategoryDesc="Single Bone"
}
