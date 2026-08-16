class AnimNotify_ViewShake extends AnimNotify_Scripted
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var editconst float Duration;
var editconst Vector RotAmplitude;
var editconst Vector RotFrequency;
var editconst Vector LocAmplitude;
var editconst Vector LocFrequency;
var editconst float FOVAmplitude;
var editconst float FOVFrequency;
var() bool bDoControllerVibration;
var() bool bUseBoneLocation;
var() float ShakeRadius;
var() name BoneName;
var() export editinline CameraShake ShakeParams;

event Notify(Actor Owner, AnimNodeSequence AnimSeqInstigator)
{
    local Vector ViewShakeOrigin;
    
    if (bUseBoneLocation && AnimSeqInstigator != none && AnimSeqInstigator.SkelComponent != none)
    {
        ViewShakeOrigin = AnimSeqInstigator.SkelComponent.GetBoneLocation(BoneName);
    }
    else
    {
        ViewShakeOrigin = Owner.Location;
    }
    if (Owner != none)
    {
        class'Camera'.static.PlayWorldCameraShake(ShakeParams, Owner, ViewShakeOrigin, 0.0, ShakeRadius, 1.0, bDoControllerVibration);
    }
}

defaultproperties
{
    Duration=1.0
    RotAmplitude=(X=100.0,Y=100.0,Z=200.0)
    RotFrequency=(X=10.0,Y=10.0,Z=25.0)
    LocAmplitude=(X=0.0,Y=3.0,Z=6.0)
    LocFrequency=(X=1.0,Y=10.0,Z=20.0)
    FOVAmplitude=2.0
    FOVFrequency=5.0
    ShakeRadius=4096.0
}
