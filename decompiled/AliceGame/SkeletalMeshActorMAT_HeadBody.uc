class SkeletalMeshActorMAT_HeadBody extends SkeletalMeshActorMAT
    native
    placeable
    hidecategories(Navigation);

var() SkeletalMesh HeadMesh;
var() export editconst editinline SkeletalMeshComponent HeadComponent;

simulated event PostBeginPlay()
{
    HeadComponent.SetSkeletalMesh(HeadMesh);
    HeadComponent.SetParentAnimComponent(SkeletalMeshComponent);
    HeadComponent.SetRefSkelMesh(HeadMesh);
    SkeletalMeshComponent.SetLightEnvironment(HeadComponent.LightEnvironment);
    PostBeginPlay();
}

native function SkeletalMeshComponent GetFaceFXSkelMeshComp()
{
}

defaultproperties
{
    HeadComponent="Default__SkeletalMeshActorMAT_HeadBody.HeadMeshComponent"
    SkeletalMeshComponent="Default__SkeletalMeshActorMAT_HeadBody.SkeletalMeshComponent0"
    LightEnvironment="Default__SkeletalMeshActorMAT_HeadBody.MyLightEnvironment"
    FacialAudioComp="Default__SkeletalMeshActorMAT_HeadBody.FaceAudioComponent"
    Components(0)="Default__SkeletalMeshActorMAT_HeadBody.MyLightEnvironment"
    Components(1)="Default__SkeletalMeshActorMAT_HeadBody.SkeletalMeshComponent0"
    Components(2)="Default__SkeletalMeshActorMAT_HeadBody.FaceAudioComponent"
    Components(3)="Default__SkeletalMeshActorMAT_HeadBody.HeadMeshComponent"
    CollisionComponent="Default__SkeletalMeshActorMAT_HeadBody.SkeletalMeshComponent0"
}
