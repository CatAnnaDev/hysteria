class AliceGameAutomatonPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    LightEnvironment="Default__AliceGameAutomatonPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameAutomatonPawn.PawnKynapseHandle"
    WeaponParas(0)=(WeaponClass="NPCWeapon_General_Melee_Blunt1",bAvailable=True,DefaultAttachedSocketName="WeaponSocket01",CollisionPhysicsAssets=(),WeaponArcheType="None",ComponentIndex=0,WeaponMeleeRange=300.0,RangeAttackSocket="None",RangeAttackSocketArray=(),ProjectileArchetype="None",bCannotBeShieldByAlice=False)
    Mesh="Default__AliceGameAutomatonPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameAutomatonPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameAutomatonPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameAutomatonPawn.CollisionCylinder"
    Components(1)="Default__AliceGameAutomatonPawn.Arrow"
    Components(2)="Default__AliceGameAutomatonPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameAutomatonPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameAutomatonPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameAutomatonPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameAutomatonPawn.CollisionCylinder"
}
