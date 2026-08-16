class SkeletalMeshActorBasedOnExtremeContent extends SkeletalMeshActor
    native
    placeable
    hidecategories(Navigation);

struct native SkelMaterialSetterDatum
{
    var() int MaterialIndex;
    var() MaterialInterface TheMaterial;
};

var() array<SkelMaterialSetterDatum> ExtremeContent;
var() array<SkelMaterialSetterDatum> NonExtremeContent;

simulated function SetMaterialBasedOnExtremeContent()
{
    local int Idx;
    
    if (WorldInfo.GRI.ShouldShowGore())
    {
        for (Idx = 0; Idx < ExtremeContent.Length; ++Idx)
        {
            SkeletalMeshComponent.SetMaterial(ExtremeContent[Idx].MaterialIndex, ExtremeContent[Idx].TheMaterial);
        }
    }
    else
    {
        for (Idx = 0; Idx < NonExtremeContent.Length; ++Idx)
        {
            SkeletalMeshComponent.SetMaterial(NonExtremeContent[Idx].MaterialIndex, NonExtremeContent[Idx].TheMaterial);
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
    SkeletalMeshComponent="Default__SkeletalMeshActorBasedOnExtremeContent.SkeletalMeshComponent0"
    LightEnvironment="Default__SkeletalMeshActorBasedOnExtremeContent.MyLightEnvironment"
    FacialAudioComp="Default__SkeletalMeshActorBasedOnExtremeContent.FaceAudioComponent"
    Components(0)="Default__SkeletalMeshActorBasedOnExtremeContent.MyLightEnvironment"
    Components(1)="Default__SkeletalMeshActorBasedOnExtremeContent.SkeletalMeshComponent0"
    Components(2)="Default__SkeletalMeshActorBasedOnExtremeContent.FaceAudioComponent"
    CollisionComponent="Default__SkeletalMeshActorBasedOnExtremeContent.SkeletalMeshComponent0"
}
