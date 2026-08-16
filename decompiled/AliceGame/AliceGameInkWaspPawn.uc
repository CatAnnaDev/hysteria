class AliceGameInkWaspPawn extends AliceGameKynapseFlyPawn
    placeable
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    LightEnvironment="Default__AliceGameInkWaspPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameInkWaspPawn.PawnKynapseHandle"
    WeaponParas(0)=(WeaponClass="NPCWeapon_General_Melee_Blunt1",bAvailable=True,DefaultAttachedSocketName="WeaponSocket",CollisionPhysicsAssets=(),WeaponArcheType="None",ComponentIndex=0,WeaponMeleeRange=300.0,RangeAttackSocket="None",RangeAttackSocketArray=(),ProjectileArchetype="None",bCannotBeShieldByAlice=False)
    Mesh="Default__AliceGameInkWaspPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameInkWaspPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameInkWaspPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameInkWaspPawn.CollisionCylinder"
    Components(1)="Default__AliceGameInkWaspPawn.Arrow"
    Components(2)="Default__AliceGameInkWaspPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameInkWaspPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameInkWaspPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameInkWaspPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameInkWaspPawn.CollisionCylinder"
}
