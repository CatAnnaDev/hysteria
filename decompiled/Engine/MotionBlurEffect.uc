class MotionBlurEffect extends PostProcessEffect
    native
    notplaceable
    hidecategories(Object);

var() float MaxVelocity;
var() float MotionBlurAmount;
var() bool FullMotionBlur;
var() float CameraRotationThreshold;
var() float CameraTranslationThreshold;

defaultproperties
{
    MaxVelocity=1.0
    MotionBlurAmount=0.5
    FullMotionBlur=True
    CameraRotationThreshold=90.0
    CameraTranslationThreshold=10000.0
    bShowInEditor=False
}
