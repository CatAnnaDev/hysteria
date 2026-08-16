class SceneCapture2DComponent extends SceneCaptureComponent
    native
    notplaceable
    hidecategories(Object);

var(Capture) const TextureRenderTarget2D TextureTarget;
var(Capture) const float FieldOfView;
var(Capture) const float NearPlane;
var(Capture) const float FarPlane;
var bool bUpdateMatrices;
var const transient Matrix ViewMatrix;
var const transient Matrix ProjMatrix;

native final function SetView(Vector NewLocation, Rotator NewRotation)
{
    NewLocation;
    NewRotation;
}

native final function SetCaptureParameters(optional TextureRenderTarget2D NewTextureTarget = TextureTarget, optional float NewFOV = FieldOfView, optional float NewNearPlane = NearPlane, optional float NewFarPlane = FarPlane)
{
    NewTextureTarget;
    NewFOV;
    NewNearPlane;
    NewFarPlane;
}

defaultproperties
{
    FieldOfView=80.0
    NearPlane=20.0
    FarPlane=500.0
    bUpdateMatrices=True
    ViewMatrix=(XPlane=(X=0.0,Y=1.0,Z=0.0,W=0.0),YPlane=(X=0.0,Y=0.0,Z=1.0,W=0.0),ZPlane=(X=0.0,Y=0.0,Z=0.0,W=1.0),WPlane=(X=1.0,Y=0.0,Z=0.0,W=0.0))
    ProjMatrix=(XPlane=(X=0.0,Y=1.0,Z=0.0,W=0.0),YPlane=(X=0.0,Y=0.0,Z=1.0,W=0.0),ZPlane=(X=0.0,Y=0.0,Z=0.0,W=1.0),WPlane=(X=1.0,Y=0.0,Z=0.0,W=0.0))
}
