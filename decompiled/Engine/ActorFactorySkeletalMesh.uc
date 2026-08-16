class ActorFactorySkeletalMesh extends ActorFactory
    native
    notplaceable
    editinlinenew
    collapsecategories
    config(Editor)
    hidecategories(Object);

var() SkeletalMesh SkeletalMesh;
var() AnimSet AnimSet;
var() name AnimSequenceName;

defaultproperties
{
    GameplayActorClass="SkeletalMeshActorSpawnable"
    MenuName="Add SkeletalMesh"
    MenuPriority=13
    NewActorClass="SkeletalMeshActor"
}
