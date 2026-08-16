class AliceGameDoomAgilePawn extends AliceGameKynapseFlyPawn
    placeable
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    MagicAcheivmentIdentify=6
    LightEnvironment="Default__AliceGameDoomAgilePawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameDoomAgilePawn.PawnKynapseHandle"
    WeaponParas(0)=(WeaponClass="NPCWeapon_General_Melee_Blunt1",bAvailable=True,DefaultAttachedSocketName="WeaponSocket",CollisionPhysicsAssets=(),WeaponArcheType="None",ComponentIndex=0,WeaponMeleeRange=300.0,RangeAttackSocket="None",RangeAttackSocketArray=(),ProjectileArchetype="None",bCannotBeShieldByAlice=False)
    Mesh="Default__AliceGameDoomAgilePawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameDoomAgilePawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameDoomAgilePawn.FaceAudioComponent"
    Components(0)="Default__AliceGameDoomAgilePawn.CollisionCylinder"
    Components(1)="Default__AliceGameDoomAgilePawn.Arrow"
    Components(2)="Default__AliceGameDoomAgilePawn.FaceAudioComponent"
    Components(3)="Default__AliceGameDoomAgilePawn.MyLightEnvironment"
    Components(4)="Default__AliceGameDoomAgilePawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameDoomAgilePawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameDoomAgilePawn.CollisionCylinder"
}
