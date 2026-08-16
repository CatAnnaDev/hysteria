class RadialBlurComponent extends ActorComponent
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() const MaterialInterface Material;
var() const ESceneDepthPriorityGroup DepthPriorityGroup;
var() const interp float BlurScale;
var() const interp float BlurFalloffExponent;
var() const interp float BlurOpacity;
var() const float MaxCullDistance;
var() const float DistanceFalloffExponent;
var() const bool bRenderAsVelocity;
var() const bool bEnabled;
var const native transient Matrix LocalToWorld;

function OnUpdatePropertyBlurOpacity()
{
    SetBlurOpacity(BlurOpacity);
}

function OnUpdatePropertyBlurFalloffExponent()
{
    SetBlurFalloffExponent(BlurFalloffExponent);
}

function OnUpdatePropertyBlurScale()
{
    SetBlurScale(BlurScale);
}

native function SetEnabled(bool bInEnabled)
{
    bInEnabled;
}

native function SetBlurOpacity(float InBlurOpacity)
{
    InBlurOpacity;
}

native function SetBlurFalloffExponent(float InBlurFalloffExponent)
{
    InBlurFalloffExponent;
}

native function SetBlurScale(float InBlurScale)
{
    InBlurScale;
}

native function SetMaterial(MaterialInterface InMaterial)
{
    InMaterial;
}

defaultproperties
{
    DepthPriorityGroup="SDPG_Foreground"
    BlurScale=1.0
    BlurFalloffExponent=1.5
    BlurOpacity=1.0
    MaxCullDistance=2000.0
    DistanceFalloffExponent=1.5
    bEnabled=True
}
