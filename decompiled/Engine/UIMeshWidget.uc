class UIMeshWidget extends UIObject
    native
    placeable
    config(UI)
    hidecategories(Object,UIRoot,Object);

var(Appearance) const export editconst editinline StaticMeshComponent Mesh;

defaultproperties
{
    Mesh="Default__UIMeshWidget.WidgetMesh"
    bSupportsPrimaryStyle=False
    bDebugShowBounds=True
    DebugBoundsColor=(B=64,G=0,R=128,A=255)
    bSupports3DPrimitives=True
    EventProvider="Default__UIMeshWidget.WidgetEventComponent"
}
