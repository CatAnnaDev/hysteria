class AliceGameBitchBabyPawn extends AliceGameKynapseFlyPawn
    placeable
    config(Game)
    hidecategories(Navigation);

var bool bDeathbyAliceReflectProject;

function ModifyDiedByWeapon()
{
    if (bDeathbyAliceReflectProject)
    {
        DiedByWeaponIndectify = 7;
    }
}

function HackPawnMarkDeathType(class<DamageType> DamageType, Actor Causer)
{
    local NpcProjectile ReflectProjectile;
    
    ReflectProjectile = NpcProjectile(Causer);
    if (ReflectProjectile != none && ReflectProjectile.IsReflectByAliceWeapon())
    {
        bDeathbyAliceReflectProject = true;
    }
}

defaultproperties
{
    MagicAcheivmentIdentify=5
    LightEnvironment="Default__AliceGameBitchBabyPawn.MyLightEnvironment"
    KynapseHandle="Default__AliceGameBitchBabyPawn.PawnKynapseHandle"
    WeaponParas(0)=(WeaponClass="NPCWeapon_General_Melee_Blunt1",bAvailable=True,DefaultAttachedSocketName="WeaponSocket",CollisionPhysicsAssets=(),WeaponArcheType="None",ComponentIndex=0,WeaponMeleeRange=300.0,RangeAttackSocket="None",RangeAttackSocketArray=(),ProjectileArchetype="None",bCannotBeShieldByAlice=False)
    Mesh="Default__AliceGameBitchBabyPawn.DemoPawnSkeletalMeshComponent"
    CylinderComponent="Default__AliceGameBitchBabyPawn.CollisionCylinder"
    FacialAudioComp="Default__AliceGameBitchBabyPawn.FaceAudioComponent"
    Components(0)="Default__AliceGameBitchBabyPawn.CollisionCylinder"
    Components(1)="Default__AliceGameBitchBabyPawn.Arrow"
    Components(2)="Default__AliceGameBitchBabyPawn.FaceAudioComponent"
    Components(3)="Default__AliceGameBitchBabyPawn.MyLightEnvironment"
    Components(4)="Default__AliceGameBitchBabyPawn.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__AliceGameBitchBabyPawn.PawnKynapseHandle"
    CollisionComponent="Default__AliceGameBitchBabyPawn.CollisionCylinder"
}
