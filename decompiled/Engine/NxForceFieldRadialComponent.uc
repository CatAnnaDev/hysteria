class NxForceFieldRadialComponent extends NxForceFieldComponent
    native
    notplaceable
    editinlinenew
    collapsecategories
    hidecategories(Collision,Lighting,Physics,Rendering,Object);

var() interp float ForceStrength;
var() interp float ForceRadius;
var() interp float SelfRotationStrength;
var() export ERadialImpulseFalloff ForceFalloff;
var const native transient Pointer Kernel;

defaultproperties
{
    ForceStrength=200.0
    ForceRadius=200.0
    SelfRotationStrength=200.0
    Shape="Default__NxForceFieldRadialComponent.Shape0"
    ReplacementPrimitive="None"
}
