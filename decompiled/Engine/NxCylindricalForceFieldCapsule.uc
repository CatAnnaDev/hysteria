class NxCylindricalForceFieldCapsule extends NxCylindricalForceField
    native
    placeable
    hidecategories(Navigation);

var() export editinline DrawCapsuleComponent RenderComponent;

native function DoInitRBPhys()
{
}

defaultproperties
{
    RenderComponent="Default__NxCylindricalForceFieldCapsule.DrawCapsule0"
    ForceHeight=200.0
    Components(0)="Default__NxCylindricalForceFieldCapsule.DrawCapsule0"
    Components(1)="Default__NxCylindricalForceFieldCapsule.Sprite"
}
