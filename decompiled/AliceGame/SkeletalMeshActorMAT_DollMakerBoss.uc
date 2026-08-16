class SkeletalMeshActorMAT_DollMakerBoss extends SkeletalMeshActorMAT
    native
    placeable
    hidecategories(Navigation);

var() export editinline array<ClothComponent> WireComponents;
var() array<name> wireBones;

simulated event PreBeginPlay()
{
    PreBeginPlay();
    SkeletalMeshComponent.AttachComponent(WireComponents[0], wireBones[0]);
    SkeletalMeshComponent.AttachComponent(WireComponents[1], wireBones[1]);
}

defaultproperties
{
    WireComponents(0)="Default__SkeletalMeshActorMAT_DollMakerBoss.Wire0"
    WireComponents(1)="Default__SkeletalMeshActorMAT_DollMakerBoss.Wire1"
    wireBones(0)="Bip01-L-Clavicle"
    wireBones(1)="Bip01-R-Clavicle"
    SkeletalMeshComponent="Default__SkeletalMeshActorMAT_DollMakerBoss.SkeletalMeshComponent0"
    LightEnvironment="Default__SkeletalMeshActorMAT_DollMakerBoss.MyLightEnvironment"
    FacialAudioComp="Default__SkeletalMeshActorMAT_DollMakerBoss.FaceAudioComponent"
    Components(0)="Default__SkeletalMeshActorMAT_DollMakerBoss.MyLightEnvironment"
    Components(1)="Default__SkeletalMeshActorMAT_DollMakerBoss.SkeletalMeshComponent0"
    Components(2)="Default__SkeletalMeshActorMAT_DollMakerBoss.FaceAudioComponent"
    Components(3)="Default__SkeletalMeshActorMAT_DollMakerBoss.Wire0"
    Components(4)="Default__SkeletalMeshActorMAT_DollMakerBoss.Wire1"
    CollisionComponent="Default__SkeletalMeshActorMAT_DollMakerBoss.SkeletalMeshComponent0"
}
