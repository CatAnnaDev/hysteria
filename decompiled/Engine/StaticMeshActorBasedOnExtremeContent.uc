class StaticMeshActorBasedOnExtremeContent extends Actor
    native
    placeable
    hidecategories(Navigation);

struct native SMMaterialSetterDatum
{
    var() int MaterialIndex;
    var() MaterialInterface TheMaterial;
};

var() const export editconst editinline StaticMeshComponent StaticMeshComponent;
var() array<SMMaterialSetterDatum> ExtremeContent;
var() array<SMMaterialSetterDatum> NonExtremeContent;

simulated function SetMaterialBasedOnExtremeContent()
{
    local int Idx;
    
    if (WorldInfo.GRI.ShouldShowGore())
    {
        for (Idx = 0; Idx < ExtremeContent.Length; ++Idx)
        {
            StaticMeshComponent.SetMaterial(ExtremeContent[Idx].MaterialIndex, ExtremeContent[Idx].TheMaterial);
        }
    }
    else
    {
        for (Idx = 0; Idx < NonExtremeContent.Length; ++Idx)
        {
            StaticMeshComponent.SetMaterial(NonExtremeContent[Idx].MaterialIndex, NonExtremeContent[Idx].TheMaterial);
        }
    }
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
    SetMaterialBasedOnExtremeContent();
}

defaultproperties
{
    StaticMeshComponent="Default__StaticMeshActorBasedOnExtremeContent.StaticMeshComponent0"
    bStatic=True
    bWorldGeometry=True
    bGameRelevant=True
    bMovable=False
    bCollideActors=True
    bBlockActors=True
    bEdShouldSnap=True
    Components(0)="Default__StaticMeshActorBasedOnExtremeContent.StaticMeshComponent0"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__StaticMeshActorBasedOnExtremeContent.StaticMeshComponent0"
}
