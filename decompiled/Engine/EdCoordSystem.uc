class EdCoordSystem extends Object
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

var() Matrix M;
var() string Desc;

defaultproperties
{
    M=(XPlane=(X=0.0,Y=1.0,Z=0.0,W=0.0),YPlane=(X=0.0,Y=0.0,Z=1.0,W=0.0),ZPlane=(X=0.0,Y=0.0,Z=0.0,W=1.0),WPlane=(X=1.0,Y=0.0,Z=0.0,W=0.0))
    Desc="Coord System"
}
