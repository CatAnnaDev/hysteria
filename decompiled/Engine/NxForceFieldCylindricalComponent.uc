class NxForceFieldCylindricalComponent extends NxForceFieldComponent
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Collision,Lighting,Physics,Rendering,Object);

var() interp float RadialStrength;
var() interp float RotationalStrength;
var() interp float LiftStrength;
var() interp float ForceRadius;
var() interp float ForceTopRadius;
var() interp float LiftFalloffHeight;
var() interp float EscapeVelocity;
var() interp float ForceHeight;
var() interp float HeightOffset;
var() bool UseSpecialRadialForce;
var const native transient Pointer Kernel;

defaultproperties
{
    ForceRadius=200.0
    Shape="Default__NxForceFieldCylindricalComponent.Shape0"
    ReplacementPrimitive="None"
}
