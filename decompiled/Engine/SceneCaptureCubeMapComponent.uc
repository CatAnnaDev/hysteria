class SceneCaptureCubeMapComponent extends SceneCaptureComponent
    native
    notplaceable
    hidecategories(Object);

var(Capture) TextureRenderTargetCube TextureTarget;
var(Capture) float NearPlane;
var(Capture) float FarPlane;
var const native transient Vector WorldLocation;

defaultproperties
{
    NearPlane=20.0
    FarPlane=500.0
}
