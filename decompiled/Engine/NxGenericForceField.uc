class NxGenericForceField extends NxForceField
    abstract
    native
    notplaceable
    hidecategories(Navigation);

var() FFG_ForceFieldCoordinates Coordinates;
var() Vector Constant;
var() Vector PositionMultiplierX;
var() Vector PositionMultiplierY;
var() Vector PositionMultiplierZ;
var() Vector PositionTarget;
var() Vector VelocityMultiplierX;
var() Vector VelocityMultiplierY;
var() Vector VelocityMultiplierZ;
var() Vector VelocityTarget;
var() Vector Noise;
var() Vector FalloffLinear;
var() Vector FalloffQuadratic;
var() float TorusRadius;
var const native transient Pointer LinearKernel;

defaultproperties
{
    TorusRadius=1.0
}
