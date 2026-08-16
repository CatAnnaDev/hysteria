class FogVolumeLinearHalfspaceDensityComponent extends FogVolumeDensityComponent
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Object,Object);

var() interp float PlaneDistanceFactor;
var() interp Plane HalfspacePlane;

defaultproperties
{
    PlaneDistanceFactor=0.1
    HalfspacePlane=(X=-300.0,Y=0.0,Z=0.0,W=1.0)
}
