class ActorFactoryPhysXDestructible extends ActorFactory
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object);

var() PhysXDestructible PhysXDestructible;
var() Vector DrawScale3D;

defaultproperties
{
    DrawScale3D=(X=1.0,Y=1.0,Z=1.0)
    MenuName="Add PhysXDestructibleActor"
    NewActorClass="PhysXDestructibleActor"
}
