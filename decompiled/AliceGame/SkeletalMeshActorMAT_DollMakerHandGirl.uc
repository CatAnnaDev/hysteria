class SkeletalMeshActorMAT_DollMakerHandGirl extends SkeletalMeshActorMAT
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
    WireComponent="Default__SkeletalMeshActorMAT_DollMakerHandGirl.Wire"
    wireBone="Bip01-Head"
    SkeletalMeshComponent="Default__SkeletalMeshActorMAT_DollMakerHandGirl.SkeletalMeshComponent0"
    LightEnvironment="Default__SkeletalMeshActorMAT_DollMakerHandGirl.MyLightEnvironment"
    FacialAudioComp="Default__SkeletalMeshActorMAT_DollMakerHandGirl.FaceAudioComponent"
    Components(0)="Default__SkeletalMeshActorMAT_DollMakerHandGirl.MyLightEnvironment"
    Components(1)="Default__SkeletalMeshActorMAT_DollMakerHandGirl.SkeletalMeshComponent0"
    Components(2)="Default__SkeletalMeshActorMAT_DollMakerHandGirl.FaceAudioComponent"
    Components(3)="Default__SkeletalMeshActorMAT_DollMakerHandGirl.Wire"
    CollisionComponent="Default__SkeletalMeshActorMAT_DollMakerHandGirl.SkeletalMeshComponent0"
}
