class AliceExplosionLight extends PointLightComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

struct native AliceExplosionLightTemplate
{
    var() array<LightValues> TimeShift;
    var() float HighDetailFrameTime;
    var() bool bCheckFrameRate;
    var() bool CastShadows;
};

struct native LightValues
{
    var() float StartTime;
    var() float Radius;
    var() float Brightness;
    var() Color LightColor;
};

var bool bCheckFrameRate;
var bool bInitialized;
var float HighDetailFrameTime;
var float Lifetime;
var int TimeShiftIndex;
var() array<LightValues> TimeShift;
var delegate<OnLightFinished> __OnLightFinished__Delegate;

native final function SetTemplate(out const AliceExplosionLightTemplate Template)
{
    Template;
}

delegate OnLightFinished(AliceExplosionLight Light)
{
}

native final function ResetLight()
{
}

defaultproperties
{
    bCheckFrameRate=True
    HighDetailFrameTime=0.015
    Radius=256.0
    Brightness=8.0
    LightColor=(B=255,G=255,R=255,A=255)
    CastShadows=False
}
