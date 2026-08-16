class AimSwitchActor_Hatter extends AimSwitchActorBase
    placeable
    hidecategories(Navigation);

defaultproperties
{
    AudioComp="Default__AimSwitchActor_Hatter.MyAudioComponent"
    IdleAnimName="HatterAimSwitch_Idle"
    DamageAnimName="HatterAimSwitch_Reaction"
    ReliefAnimName="HatterAimSwitch_rewind"
    DamageLimit=20
    SkeletalMeshComponent="Default__AimSwitchActor_Hatter.SkeletalMeshComponent0"
    LightEnvironment="Default__AimSwitchActor_Hatter.MyLightEnvironment"
    FacialAudioComp="Default__AimSwitchActor_Hatter.FaceAudioComponent"
    Components(0)="Default__AimSwitchActor_Hatter.MyLightEnvironment"
    Components(1)="Default__AimSwitchActor_Hatter.SkeletalMeshComponent0"
    Components(2)="Default__AimSwitchActor_Hatter.FaceAudioComponent"
    Components(3)="Default__AimSwitchActor_Hatter.CollisionCylinder"
    Components(4)="Default__AimSwitchActor_Hatter.MyAudioComponent"
    CollisionComponent="Default__AimSwitchActor_Hatter.CollisionCylinder"
}
