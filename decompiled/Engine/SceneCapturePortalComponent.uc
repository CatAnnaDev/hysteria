class SceneCapturePortalComponent extends SceneCaptureComponent
    native
    notplaceable
    hidecategories(Object);

var(Capture) const TextureRenderTarget2D TextureTarget;
var(Capture) const float ScaleFOV;
var(Capture) const Actor ViewDestination;

native final function SetCaptureParameters(optional TextureRenderTarget2D NewTextureTarget = TextureTarget, optional float NewScaleFOV = ScaleFOV, optional Actor NewViewDest = ViewDestination)
{
    NewTextureTarget;
    NewScaleFOV;
    NewViewDest;
}

defaultproperties
{
    ScaleFOV=1.0
    FrameRate=1000.0
}
