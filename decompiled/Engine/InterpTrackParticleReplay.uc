class InterpTrackParticleReplay extends InterpTrack
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

struct native ParticleReplayTrackKey
{
    var float Time;
    var() float Duration;
    var() int ClipIDNumber;
};

var editinline array<ParticleReplayTrackKey> TrackKeys;
var const transient editoronly bool bIsCapturingReplay;
var const transient editoronly float FixedTimeStep;

defaultproperties
{
    TrackInstClass="InterpTrackInstParticleReplay"
    TrackTitle="Particle Replay"
}
