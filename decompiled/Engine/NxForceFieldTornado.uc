class NxForceFieldTornado extends NxForceField
    native
    placeable
    hidecategories(Navigation);

var() editinline ForceFieldShape Shape;
var native export editinline ActorComponent DrawComponent;
var() interp float RadialStrength;
var() interp float RotationalStrength;
var() interp float LiftStrength;
var() interp float ForceRadius;
var() interp float ForceTopRadius;
var() interp float LiftFalloffHeight;
var() interp float EscapeVelocity;
var() interp float ForceHeight;
var() interp float HeightOffset;
var() bool BSpecialRadialForceMode;
var() interp float SelfRotationStrength;
var const native transient Pointer Kernel;

native function DoInitRBPhys()
{
}

defaultproperties
{
    ForceRadius=200.0
    ForceTopRadius=200.0
    ForceHeight=200.0
    Components(0)="Default__NxForceFieldTornado.Sprite"
}
