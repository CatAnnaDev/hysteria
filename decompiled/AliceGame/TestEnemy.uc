class TestEnemy extends AliceGameKynapseWalkingPawn
    placeable
    config(Game)
    hidecategories(Navigation);

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    LogInternal("You have Touched me!");
}

event TakeDamage(int Damage, Controller InstigatedBy, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    LogInternal("TakeDamge happened!");
    TakeDamage(Damage, InstigatedBy, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
}

defaultproperties
{
    LightEnvironment="Default__TestEnemy.MyLightEnvironment"
    KynapseHandle="Default__TestEnemy.PawnKynapseHandle"
    Mesh="Default__TestEnemy.AlicePawnSkeletalMeshComponent"
    CylinderComponent="Default__TestEnemy.CollisionCylinder"
    FacialAudioComp="Default__TestEnemy.FaceAudioComponent"
    Components(0)="Default__TestEnemy.CollisionCylinder"
    Components(1)="Default__TestEnemy.Arrow"
    Components(2)="Default__TestEnemy.FaceAudioComponent"
    Components(3)="Default__TestEnemy.MyLightEnvironment"
    Components(4)="Default__TestEnemy.DemoPawnSkeletalMeshComponent"
    Components(5)="Default__TestEnemy.PawnKynapseHandle"
    Components(6)="Default__TestEnemy.AlicePawnSkeletalMeshComponent"
    CollisionComponent="Default__TestEnemy.CollisionCylinder"
}
