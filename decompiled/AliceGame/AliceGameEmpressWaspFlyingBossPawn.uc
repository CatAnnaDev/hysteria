class AliceGameEmpressWaspFlyingBossPawn extends AliceGameKynapseFlyPawn
    placeable
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    LightEnvironment="Default__AliceGameEmpressWaspFlyingBossPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameEmpressWaspFlyingBossPawn.PawnKynapseHandle"
    WeaponParas(0)=(WeaponClass="NPCWeapon_General_Melee_Blunt1",bAvailable=True,DefaultAttachedSocketName="WeaponSocket",CollisionPhysicsAssets=(),WeaponArcheType="None",ComponentIndex=0,WeaponMeleeRange=300.0,RangeAttackSocket="None",RangeAttackSocketArray=(),ProjectileArchetype="None",bCannotBeShieldByAlice=False)
    Mesh="Default__AliceGameEmpressWaspFlyingBossPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameEmpressWaspFlyingBossPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameEmpressWaspFlyingBossPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameEmpressWaspFlyingBossPawn.CollisionCylinder"
    Components(1)="Default__AliceGameEmpressWaspFlyingBossPawn.Arrow"
    Components(2)="Default__AliceGameEmpressWaspFlyingBossPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameEmpressWaspFlyingBossPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameEmpressWaspFlyingBossPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameEmpressWaspFlyingBossPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameEmpressWaspFlyingBossPawn.CollisionCylinder"
}
