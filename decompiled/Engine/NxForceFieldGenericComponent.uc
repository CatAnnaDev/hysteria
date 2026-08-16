class NxForceFieldGenericComponent extends NxForceFieldComponent
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Collision,Lighting,Physics,Rendering,Object);

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
var const native transient Pointer Kernel;

defaultproperties
{
    RoughExtentX=200.0
    RoughExtentY=200.0
    RoughExtentZ=200.0
    TorusRadius=1.0
    Shape="Default__NxForceFieldGenericComponent.Shape0"
    ReplacementPrimitive="None"
}
