class FogVolumeConeDensityComponent extends FogVolumeDensityComponent
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() interp float MaxDensity;
var() interp Vector ConeVertex;
var() interp float ConeRadius;
var() interp Vector ConeAxis;
var() interp float ConeMaxAngle;
var const export editinline DrawLightConeComponent PreviewCone;

defaultproperties
{
    MaxDensity=0.002
    ConeRadius=600.0
    ConeAxis=(X=0.0,Y=0.0,Z=-1.0)
    ConeMaxAngle=30.0
}
