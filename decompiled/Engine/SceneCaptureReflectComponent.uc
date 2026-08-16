class SceneCaptureReflectComponent extends SceneCaptureComponent
    native
    notplaceable
    hidecategories(Object);

var(Capture) TextureRenderTarget2D TextureTarget;
var(Capture) float ScaleFOV;

defaultproperties
{
    ScaleFOV=1.0
    FrameRate=1000.0
}
