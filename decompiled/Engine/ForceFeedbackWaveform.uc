class ForceFeedbackWaveform extends Object
    native
    notplaceable
    editinlinenew;

enum EWaveformFunction
{
    WF_Constant,
    WF_LinearIncreasing,
    WF_LinearDecreasing,
    WF_Sin0to90,
    WF_Sin90to180,
    WF_Sin0to180,
    WF_Noise,
};

struct native WaveformSample
{
    var() byte LeftAmplitude;
    var() byte RightAmplitude;
    var() EWaveformFunction LeftFunction;
    var() EWaveformFunction RightFunction;
    var() float Duration;
};

var() bool bIsLooping;
var() array<WaveformSample> Samples;

defaultproperties
{
}
