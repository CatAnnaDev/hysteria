class AliceLocalizedStaticMeshActor extends StaticMeshActor
    native
    placeable
    hidecategories(Navigation);

struct native LocalizationMaterialSet
{
    var() const int MaterialIndex;
    var() const array<MaterialInterface> Materials;
};

var() const array<LocalizationMaterialSet> LocalizationMaterialSets;

defaultproperties
{
    StaticMeshComponent="Default__AliceLocalizedStaticMeshActor.StaticMeshComponent0"
    Components(0)="Default__AliceLocalizedStaticMeshActor.StaticMeshComponent0"
    CollisionComponent="Default__AliceLocalizedStaticMeshActor.StaticMeshComponent0"
}
