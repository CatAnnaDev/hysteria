class InterpTrackFaceFX extends InterpTrack
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

struct native FaceFXSoundCueKey
{
    var const SoundCue FaceFXSoundCue;
};

struct native FaceFXTrackKey
{
    var float StartTime;
    var string FaceFXGroupName;
    var string FaceFXSeqName;
};

var() array<FaceFXAnimSet> FaceFXAnimSets;
var array<FaceFXTrackKey> FaceFXSeqs;
var transient FaceFXAsset CachedActorFXAsset;
var const array<FaceFXSoundCueKey> FaceFXSoundCueKeys;

defaultproperties
{
    TrackInstClass="InterpTrackInstFaceFX"
    TrackTitle="FaceFX"
    bOnePerGroup=True
}
