class SkeletalMeshActorMAT_DollMakerHandBoy extends SkeletalMeshActorMAT
    native
    placeable
    hidecategories(Navigation);

var() export editinline ClothComponent WireComponent;
var() name wireBone;

simulated event PreBeginPlay()
{
    PreBeginPlay();
    SkeletalMeshComponent.AttachComponent(WireComponent, wireBone);
}

defaultproperties
{
    WireComponent="Default__SkeletalMeshActorMAT_DollMakerHandBoy.Wire"
    wireBone="Bip01-Head"
    SkeletalMeshComponent="Default__SkeletalMeshActorMAT_DollMakerHandBoy.SkeletalMeshComponent0"
    LightEnvironment="Default__SkeletalMeshActorMAT_DollMakerHandBoy.MyLightEnvironment"
    FacialAudioComp="Default__SkeletalMeshActorMAT_DollMakerHandBoy.FaceAudioComponent"
    Components(0)="Default__SkeletalMeshActorMAT_DollMakerHandBoy.MyLightEnvironment"
    Components(1)="Default__SkeletalMeshActorMAT_DollMakerHandBoy.SkeletalMeshComponent0"
    Components(2)="Default__SkeletalMeshActorMAT_DollMakerHandBoy.FaceAudioComponent"
    Components(3)="Default__SkeletalMeshActorMAT_DollMakerHandBoy.Wire"
    CollisionComponent="Default__SkeletalMeshActorMAT_DollMakerHandBoy.SkeletalMeshComponent0"
}
