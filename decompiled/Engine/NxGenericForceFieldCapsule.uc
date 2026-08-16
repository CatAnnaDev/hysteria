class NxGenericForceFieldCapsule extends NxGenericForceField
    native
    placeable
    hidecategories(Navigation);

var export editinline DrawCapsuleComponent RenderComponent;
var() float CapsuleHeight;
var() float CapsuleRadius;

defaultproperties
{
    RenderComponent="Default__NxGenericForceFieldCapsule.DrawCapsule0"
    CapsuleHeight=200.0
    CapsuleRadius=200.0
    Components(0)="Default__NxGenericForceFieldCapsule.DrawCapsule0"
    Components(1)="Default__NxGenericForceFieldCapsule.Sprite"
}
