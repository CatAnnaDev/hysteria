class StaticMeshCollectionActor extends StaticMeshActorBase
    native
    notplaceable
    config(Engine)
    hidecategories(Navigation);

var const export editinline array<StaticMeshComponent> StaticMeshComponents;
var config int MaxStaticMeshComponents;

defaultproperties
{
    MaxStaticMeshComponents=100
}
