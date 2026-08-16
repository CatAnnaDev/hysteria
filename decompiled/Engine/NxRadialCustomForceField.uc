class NxRadialCustomForceField extends NxRadialForceField
    native
    placeable
    hidecategories(Navigation);

var() interp float SelfRotationStrength;
var const native transient Pointer Kernel;

defaultproperties
{
    RenderComponent="Default__NxRadialCustomForceField.DrawSphere0"
    Components(0)="Default__NxRadialCustomForceField.DrawSphere0"
    Components(1)="Default__NxRadialCustomForceField.Sprite"
}
