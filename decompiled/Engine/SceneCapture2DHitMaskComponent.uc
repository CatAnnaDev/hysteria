class SceneCapture2DHitMaskComponent extends SceneCaptureComponent
    native
    notplaceable
    hidecategories(Object);

var const transient TextureRenderTarget2D TextureTarget;
var const transient export editinline SkeletalMeshComponent SkeletalMeshComp;
var int RenderSection;
var int ForceLOD;
var float FadingStartTimeAfterHit;
var float FadingPercentage;
var float FadingDurationTime;
var float FadingIntervalTime;

native final function SetCaptureParameters(const Vector InMaskPosition, const float InMaskRadius, const Vector InStartupPosition)
{
    InMaskPosition;
    InMaskRadius;
    InStartupPosition;
}

native final function SetCaptureTargetTexture(const TextureRenderTarget2D InTextureTarget)
{
    InTextureTarget;
}

defaultproperties
{
    ForceLOD=-1
    FadingStartTimeAfterHit=10.0
    FadingPercentage=0.99
    FadingDurationTime=50.0
    FadingIntervalTime=3.0
}
