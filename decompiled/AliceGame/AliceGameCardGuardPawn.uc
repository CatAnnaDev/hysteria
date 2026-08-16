class AliceGameCardGuardPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    MagicAcheivmentIdentify=2
    LightEnvironment="Default__AliceGameCardGuardPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameCardGuardPawn.PawnKynapseHandle"
    WeaponParas(0)=(WeaponClass="NPCWeapon_General_Melee_Blunt1",bAvailable=True,DefaultAttachedSocketName="Staff",CollisionPhysicsAssets=(),WeaponArcheType="None",ComponentIndex=0,WeaponMeleeRange=300.0,RangeAttackSocket="None",RangeAttackSocketArray=(),ProjectileArchetype="None",bCannotBeShieldByAlice=False)
    Mesh="Default__AliceGameCardGuardPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameCardGuardPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameCardGuardPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameCardGuardPawn.CollisionCylinder"
    Components(1)="Default__AliceGameCardGuardPawn.Arrow"
    Components(2)="Default__AliceGameCardGuardPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameCardGuardPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameCardGuardPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameCardGuardPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameCardGuardPawn.CollisionCylinder"
}
