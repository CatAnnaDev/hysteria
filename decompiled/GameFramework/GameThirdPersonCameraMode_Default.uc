class GameThirdPersonCameraMode_Default extends GameThirdPersonCameraMode
    native
    notplaceable
    config(Camera);

var() const float WorstLocAimingZOffset;
var transient bool bTemporaryOriginRotInterp;
var() const float TemporaryOriginRotInterpSpeed;

defaultproperties
{
    WorstLocAimingZOffset=-10.0
    TemporaryOriginRotInterpSpeed=12.0
    BlendTime=0.25
    bValidateWorstLoc=False
    StrafeLeftAdjustment=(X=0.0,Y=-15.0,Z=0.0)
    StrafeRightAdjustment=(X=0.0,Y=15.0,Z=0.0)
    StrafeOffsetScalingThreshold=200.0
    RunFwdAdjustment=(X=20.0,Y=0.0,Z=0.0)
    RunBackAdjustment=(X=-30.0,Y=0.0,Z=0.0)
    RunOffsetScalingThreshold=200.0
    WorstLocOffset=(X=-8.0,Y=1.0,Z=95.0)
    ViewOffset=(OffsetHigh=(X=-128.0,Y=56.0,Z=40.0),OffsetMid=(X=-160.0,Y=48.0,Z=16.0),OffsetLow=(X=-160.0,Y=48.0,Z=56.0))
    ViewOffset_ViewportAdjustments[1]=(OffsetHigh=(X=0.0,Y=-20.0,Z=0.0),OffsetMid=(X=0.0,Y=-20.0,Z=0.0),OffsetLow=(X=0.0,Y=-20.0,Z=0.0))
    ViewOffset_ViewportAdjustments[2]=(OffsetHigh=(X=0.0,Y=0.0,Z=-12.0),OffsetMid=(X=0.0,Y=0.0,Z=-12.0),OffsetLow=(X=0.0,Y=0.0,Z=-12.0))
    ViewOffset_ViewportAdjustments[3]=(OffsetHigh=(X=0.0,Y=0.0,Z=17.0),OffsetMid=(X=0.0,Y=0.0,Z=17.0),OffsetLow=(X=0.0,Y=0.0,Z=17.0))
    ViewOffset_ViewportAdjustments[4]=(OffsetHigh=(X=0.0,Y=0.0,Z=-15.0),OffsetMid=(X=0.0,Y=0.0,Z=-15.0),OffsetLow=(X=0.0,Y=0.0,Z=-15.0))
}
