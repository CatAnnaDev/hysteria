class ForceFeedbackManager extends Object
    abstract
    native
    notplaceable
    transient
    within PlayerController;

var bool bAllowsForceFeedback;
var bool bIsPaused;
var ForceFeedbackWaveform FFWaveform;
var int CurrentSample;
var float ElapsedTime;
var float ScaleAllWaveformsBy;

simulated function PauseWaveform(optional bool bPause)
{
    bIsPaused = bPause;
}

simulated function StopForceFeedbackWaveform(optional ForceFeedbackWaveform WaveForm)
{
    if (WaveForm == none || WaveForm == FFWaveform)
    {
        FFWaveform = none;
    }
}

simulated function PlayForceFeedbackWaveform(ForceFeedbackWaveform WaveForm)
{
    if (WaveForm != none && FFWaveform != none && WaveForm.Samples.Length > 0 && WaveForm.Samples[0].Duration < FFWaveform.Samples[0].Duration)
    {
        return;
    }
    CurrentSample = 0;
    ElapsedTime = 0.0;
    bIsPaused = false;
    if (WaveForm != none && WaveForm.Samples.Length > 0 && bAllowsForceFeedback == true)
    {
        FFWaveform = WaveForm;
    }
    else
    {
        FFWaveform = none;
    }
}

defaultproperties
{
    bAllowsForceFeedback=True
    ScaleAllWaveformsBy=1.0
}
