class ActorFactoryFracturedStaticMesh extends ActorFactory
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object);

var() FracturedStaticMesh FracturedStaticMesh;
var() Vector DrawScale3D;

defaultproperties
{
    DrawScale3D=(X=1.0,Y=1.0,Z=1.0)
    MenuName="Add FracturedStaticMesh"
    MenuPriority=35
    NewActorClass="FracturedStaticMeshActor"
}
