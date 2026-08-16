class SkeletalMeshHairActor extends SkeletalMeshActor
    placeable
    hidecategories(Navigation);

var(Hair) export editinline Hair Hair;
var(Hair) export editinline HairComponent HairComponent;
var(Hair) name HairAttachBoneName;

event PreBeginPlay()
{
    if (HairComponent != none)
    {
        HairComponent.Template = Hair;
        HairComponent.SetLightEnvironment(SkeletalMeshComponent.LightEnvironment);
        HairComponent.OverrideMesh = SkeletalMeshComponent;
        SkeletalMeshComponent.AttachComponent(HairComponent, HairAttachBoneName);
    }
}

defaultproperties
{
    HairComponent="Default__SkeletalMeshHairActor.AliceHairComponent"
    HairAttachBoneName="Bip01-Head"
    SkeletalMeshComponent="Default__SkeletalMeshHairActor.SkeletalMeshComponent0"
    LightEnvironment="Default__SkeletalMeshHairActor.MyLightEnvironment"
    FacialAudioComp="Default__SkeletalMeshHairActor.FaceAudioComponent"
    Components(0)="Default__SkeletalMeshHairActor.MyLightEnvironment"
    Components(1)="Default__SkeletalMeshHairActor.SkeletalMeshComponent0"
    Components(2)="Default__SkeletalMeshHairActor.FaceAudioComponent"
    CollisionComponent="Default__SkeletalMeshHairActor.SkeletalMeshComponent0"
}
