class NxRadialForceField extends NxForceField
    native
    placeable
    hidecategories(Navigation);

var export editinline DrawSphereComponent RenderComponent;
var() interp float ForceStrength;
var() interp float ForceRadius;
var() export ERadialImpulseFalloff ForceFalloff;
var const native transient Pointer LinearKernel;

defaultproperties
{
    RenderComponent="Default__NxRadialForceField.DrawSphere0"
    ForceStrength=10.0
    ForceRadius=200.0
    Components(0)="Default__NxRadialForceField.DrawSphere0"
    Components(1)="Default__NxRadialForceField.Sprite"
}
