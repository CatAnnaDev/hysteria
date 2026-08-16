class AnimSet extends Object
    native
    notplaceable
    hidecategories(Object);

struct native AnimSetMeshLinkup
{
    var QWord SkelMeshLinkupRUID;
    var array<int> BoneToTrackTable;
    var array<byte> BoneUseAnimTranslation;
    var array<byte> ForceUseMeshTranslation;
};

var() bool bAnimRotationOnly;
var array<name> TrackBoneNames;
var array<AnimSequence> Sequences;
var transient array<AnimSetMeshLinkup> LinkupCache;
var() array<name> UseTranslationBoneNames;
var() array<name> ForceMeshTranslationBoneNames;
var name PreviewSkelMeshName;

defaultproperties
{
    bAnimRotationOnly=True
}
