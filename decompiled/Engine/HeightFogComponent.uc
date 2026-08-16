class HeightFogComponent extends ActorComponent
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object);

var() const bool bEnabled;
var const bool bCustomizedHeight;
var const float Height;
var() const interp float Density;
var() const interp float LightBrightness;
var() const interp Color LightColor;
var() const interp float ExtinctionDistance;
var() const interp float StartDistance;
var() const float InterpolationTime;
var float BlendTimeToGo;
var float BlendWeight;
var float OldBlendWeight;

native final function SetEnabled(bool bSetEnabled)
{
    bSetEnabled;
}

defaultproperties
{
    bEnabled=True
    Density=5e-05
    LightBrightness=0.1
    LightColor=(B=255,G=255,R=255,A=0)
    ExtinctionDistance=100000000.0
    BlendWeight=1.0
}
