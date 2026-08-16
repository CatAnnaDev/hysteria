class CameraShake extends Object
    native
    notplaceable
    editinlinenew;

enum EInitialOscillatorOffset
{
    EOO_OffsetRandom,
    EOO_OffsetZero,
};

struct native VOscillator
{
    var() FOscillator X;
    var() FOscillator Y;
    var() FOscillator Z;
};

struct native ROscillator
{
    var() FOscillator Pitch;
    var() FOscillator Yaw;
    var() FOscillator Roll;
};

struct native FOscillator
{
    var() float Amplitude;
    var() float Frequency;
    var() EInitialOscillatorOffset InitialOffset;
};

var() bool bSingleInstance;
var(AnimShake) bool bGamePlayCamera;
var(AnimShake) bool bRandomAnimSegment;
var(Oscillation) float OscillationDuration;
var(Oscillation) float OscillationBlendInTime;
var(Oscillation) float OscillationBlendOutTime;
var(Oscillation) ROscillator RotOscillation;
var(Oscillation) VOscillator LocOscillation;
var(Oscillation) FOscillator FOVOscillation;
var(AnimShake) CameraAnim Anim;
var(AnimShake) float AnimPlayRate;
var(AnimShake) float AnimScale;
var(AnimShake) float AnimBlendInTime;
var(AnimShake) float AnimBlendOutTime;
var(AnimShake) float AnimScaleRange;
var(AnimShake) float RandomAnimSegmentDuration;

simulated function float GetLocOscillationMagnitude()
{
    local Vector V;
    
    V.X = LocOscillation.X.Amplitude;
    V.Y = LocOscillation.Y.Amplitude;
    V.Z = LocOscillation.Z.Amplitude;
    return VSize(V);
}

simulated function float GetRotOscillationMagnitude()
{
    local Vector V;
    
    V.X = RotOscillation.Pitch.Amplitude;
    V.Y = RotOscillation.Yaw.Amplitude;
    V.Z = RotOscillation.Roll.Amplitude;
    return VSize(V);
}

defaultproperties
{
    OscillationBlendInTime=0.1
    OscillationBlendOutTime=0.2
    AnimPlayRate=1.0
    AnimScale=1.0
    AnimBlendInTime=0.2
    AnimBlendOutTime=0.2
}
