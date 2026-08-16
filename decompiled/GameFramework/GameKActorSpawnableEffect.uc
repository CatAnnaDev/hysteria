class GameKActorSpawnableEffect extends KActor
    notplaceable;

simulated event Tick(float DeltaTime)
{
    Tick(DeltaTime);
    if (LifeSpan < 1.0)
    {
        SetDrawScale(LifeSpan);
    }
}

simulated event FellOutOfWorld(class<DamageType> dmgType)
{
    Destroy();
}

simulated event PostBeginPlay()
{
}

defaultproperties
{
    StaticMeshComponent="Default__GameKActorSpawnableEffect.StaticMeshComponent0"
    LightEnvironment="Default__GameKActorSpawnableEffect.MyLightEnvironment"
    bNoDelete=False
    bBlocksNavigation=False
    bCollideActors=False
    bBlockActors=False
    Components(0)="Default__GameKActorSpawnableEffect.MyLightEnvironment"
    Components(1)="Default__GameKActorSpawnableEffect.StaticMeshComponent0"
    RemoteRole="ROLE_None"
    LifeSpan=30.0
    CollisionComponent="Default__GameKActorSpawnableEffect.StaticMeshComponent0"
}
