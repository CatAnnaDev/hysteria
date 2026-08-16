class RB_RadialImpulseComponent extends PrimitiveComponent
    native
    notplaceable
    hidecategories(Object);

var() ERadialImpulseFalloff ImpulseFalloff;
var() float ImpulseStrength;
var() float ImpulseRadius;
var() bool bVelChange;
var() bool bCauseFracture;
var export editinline DrawSphereComponent PreviewSphere;

native function FireImpulse(Vector Origin)
{
    Origin;
}

defaultproperties
{
    ImpulseStrength=900.0
    ImpulseRadius=200.0
    ReplacementPrimitive="None"
    TickGroup="TG_PreAsyncWork"
}
