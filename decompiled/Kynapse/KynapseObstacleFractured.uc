class KynapseObstacleFractured extends FracturedStaticMeshActor
    native
    placeable
    hidecategories(Navigation);

simulated event Explode()
{
    Explode();
    Destroy();
}

simulated event TakeDamage(int Damage, Controller EventInstigator, Vector HitLocation, Vector Momentum, class<DamageType> DamageType, optional TraceHitInfo HitInfo, optional Actor DamageCauser)
{
    TakeDamage(Damage, EventInstigator, HitLocation, Momentum, DamageType, HitInfo, DamageCauser);
    Destroy();
}

defaultproperties
{
    FracturedStaticMeshComponent="Default__KynapseObstacleFractured.FracturedStaticMeshComponent0"
    SkinnedComponent="Default__KynapseObstacleFractured.FracturedSkinnedComponent0"
    bNoDelete=False
    bMovable=True
    Components(0)="Default__KynapseObstacleFractured.LightEnvironment0"
    Components(1)="Default__KynapseObstacleFractured.FracturedSkinnedComponent0"
    Components(2)="Default__KynapseObstacleFractured.FracturedStaticMeshComponent0"
    Components(3)="Default__KynapseObstacleFractured.KyFractureCpnt"
    CollisionComponent="Default__KynapseObstacleFractured.FracturedStaticMeshComponent0"
}
