class InterpTrackAnimControl extends InterpTrackFloatBase
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

struct native AnimControlTrackKey
{
    var float StartTime;
    var name AnimSeqName;
    var float AnimStartOffset;
    var float AnimEndOffset;
    var float AnimPlayRate;
    var bool bLooping;
    var bool bReverse;
    var bool bDiscardRootMotion;
    var bool bDiscardRootMotionFull;
    var bool bMoveRootMotion;
};

var array<AnimSet> AnimSets;
var() name SlotName;
var array<AnimControlTrackKey> AnimSeqs;

defaultproperties
{
    TrackInstClass="InterpTrackInstAnimControl"
    TrackTitle="Anim"
    bIsAnimControlTrack=True
}
