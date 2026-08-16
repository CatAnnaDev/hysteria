class UIAnimationSeq extends UIAnimation
    native
    notplaceable
    hidecategories(Object,UIRoot,Object);

var name SeqName;
var array<UIAnimTrack> Tracks;
var EUIAnimationLoopMode LoopMode;

native final function float GetSequenceLength()
{
}

native final function bool GetTrackLength(int TrackIndex, out float out_TrackLength)
{
    TrackIndex;
    out_TrackLength;
}

native final function bool GetFrameLength(int TrackIndex, int FrameIndex, out float out_FrameLength)
{
    TrackIndex;
    FrameIndex;
    out_FrameLength;
}

native final function bool IsValidFrameIndex(int TrackIndex, int FrameIndex)
{
    TrackIndex;
    FrameIndex;
}

defaultproperties
{
}
