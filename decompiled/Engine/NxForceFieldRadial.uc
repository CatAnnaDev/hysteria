class NxForceFieldRadial extends NxForceField
    native
    placeable
    hidecategories(Navigation);

var() editinline ForceFieldShape Shape;
var native export editinline ActorComponent DrawComponent;
var() interp float ForceStrength;
var() interp float ForceRadius;
var() interp float SelfRotationStrength;
var() export ERadialImpulseFalloff ForceFalloff;
var const native transient Pointer Kernel;

native function DoInitRBPhys()
{
}

defaultproperties
{
    ForceRadius=200.0
    Components(0)="Default__NxForceFieldRadial.Sprite"
}
