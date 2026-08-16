class AliceGameBolterflyPawn extends AliceGameKynapseFlyPawn
    placeable
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    MagicAcheivmentIdentify=4
    LightEnvironment="Default__AliceGameBolterflyPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameBolterflyPawn.PawnKynapseHandle"
    AttachLeechLoopingCue="SFX_Bolterfly.sfx_bolterfly_leech01_Cue"
    AttachLeechSndCueFadeTime=0.1
    AmbientSound="SFX_Bolterfly.sfx_bolterfly_move01_Cue"
    WeaponParas(0)=(WeaponClass="NPCWeapon_General_Melee_Blunt1",bAvailable=True,DefaultAttachedSocketName="WeaponSocket",CollisionPhysicsAssets=(),WeaponArcheType="None",ComponentIndex=0,WeaponMeleeRange=300.0,RangeAttackSocket="None",RangeAttackSocketArray=(),ProjectileArchetype="None",bCannotBeShieldByAlice=False)
    Mesh="Default__AliceGameBolterflyPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameBolterflyPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameBolterflyPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameBolterflyPawn.CollisionCylinder"
    Components(1)="Default__AliceGameBolterflyPawn.Arrow"
    Components(2)="Default__AliceGameBolterflyPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameBolterflyPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameBolterflyPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameBolterflyPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameBolterflyPawn.CollisionCylinder"
}
