class AliceGameLondonCopPawn extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

defaultproperties
{
    LightEnvironment="Default__AliceGameLondonCopPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameLondonCopPawn.PawnKynapseHandle"
    WeaponParas(0)=(WeaponClass="NPCWeapon_General_Melee_Blunt1",bAvailable=True,DefaultAttachedSocketName="CardGuard_Staff",CollisionPhysicsAssets=(),WeaponArcheType="None",ComponentIndex=0,WeaponMeleeRange=300.0,RangeAttackSocket="None",RangeAttackSocketArray=(),ProjectileArchetype="None",bCannotBeShieldByAlice=False)
    Mesh="Default__AliceGameLondonCopPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameLondonCopPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameLondonCopPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameLondonCopPawn.CollisionCylinder"
    Components(1)="Default__AliceGameLondonCopPawn.Arrow"
    Components(2)="Default__AliceGameLondonCopPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameLondonCopPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameLondonCopPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameLondonCopPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameLondonCopPawn.CollisionCylinder"
}
