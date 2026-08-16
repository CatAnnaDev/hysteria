class ParticleSystemReplay extends Object
    native
    notplaceable
    hidecategories(Object)
    autoexpandcategories(ParticleSystemReplay);

struct native ParticleSystemReplayFrame
{
    var const native array<ParticleEmitterReplayFrame> Emitters;
};

struct native ParticleEmitterReplayFrame
{
    var const native int EmitterType;
    var const native int OriginalEmitterIndex;
    var const native Pointer FrameState;
};

var() native int ClipIDNumber;
var const native array<ParticleSystemReplayFrame> Frames;

defaultproperties
{
}
