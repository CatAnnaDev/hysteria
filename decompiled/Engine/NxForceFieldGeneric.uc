class NxForceFieldGeneric extends NxForceField
    native
    placeable
    hidecategories(Navigation);

enum FFG_ForceFieldCoordinates
{
    FFG_CARTESIAN,
    FFG_SPHERICAL,
    FFG_CYLINDRICAL,
    FFG_TOROIDAL,
};

var() editinline ForceFieldShape Shape;
var native export editinline ActorComponent DrawComponent;
var() float RoughExtentX;
var() float RoughExtentY;
var() float RoughExtentZ;
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

native function DoInitRBPhys()
{
}

defaultproperties
{
    RoughExtentX=200.0
    RoughExtentY=200.0
    RoughExtentZ=200.0
    TorusRadius=1.0
    Components(0)="Default__NxForceFieldGeneric.Sprite"
}
