class ActorFactoryStaticMesh extends ActorFactory
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object);

var() StaticMesh StaticMesh;
var() Vector DrawScale3D;

defaultproperties
{
    DrawScale3D=(X=1.0,Y=1.0,Z=1.0)
    MenuName="Add StaticMesh"
    MenuPriority=30
    NewActorClass="StaticMeshActor"
}
