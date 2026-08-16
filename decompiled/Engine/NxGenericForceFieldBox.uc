class NxGenericForceFieldBox extends NxGenericForceField
    native
    placeable
    hidecategories(Navigation);

var export editinline DrawBoxComponent RenderComponent;
var() interp Vector BoxExtent;

native function DoInitRBPhys()
{
}

defaultproperties
{
    RenderComponent="Default__NxGenericForceFieldBox.DrawBox0"
    BoxExtent=(X=200.0,Y=200.0,Z=200.0)
    Components(0)="Default__NxGenericForceFieldBox.DrawBox0"
    Components(1)="Default__NxGenericForceFieldBox.Sprite"
}
