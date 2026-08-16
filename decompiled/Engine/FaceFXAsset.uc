class FaceFXAsset extends Object
    native
    notplaceable
    hidecategories(Object);

var const editoronly SkeletalMesh DefaultSkelMesh;
var const native Pointer FaceFXActor;
var const native array<byte> RawFaceFXActorBytes;
var const native array<byte> RawFaceFXSessionBytes;
var() editoronly array<MorphTargetSet> PreviewMorphSets;
var transient array<FaceFXAnimSet> MountedFaceFXAnimSets;
var editoronly notforconsole array<SoundCue> ReferencedSoundCues;
var int NumLoadErrors;

native final function UnmountFaceFXAnimSet(FaceFXAnimSet AnimSet)
{
    AnimSet;
}

native final function MountFaceFXAnimSet(FaceFXAnimSet AnimSet)
{
    AnimSet;
}

defaultproperties
{
}
