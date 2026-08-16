class GameDecalManager extends DecalManager
    abstract
    native
    notplaceable
    config(Game)
    hidecategories(Navigation);

var float MinDecalDistanceSq;

final function GameDecal SpawnDecalMinimal(out const Vector DecalLocation, const float InDecalLifeSpan, const float InCanSpawnDistance)
{
    local GameDecal Result;
    local ActiveDecalInfo DecalInfo;
    
    if (IsTooCloseToActiveDecal(DecalLocation, InCanSpawnDistance) == false)
    {
        Result = GameDecal(GetPooledComponent());
        Result.Location = DecalLocation;
        if (Result.MITV_Decal == none)
        {
            Result.MITV_Decal = new(Result) class'Engine.MaterialInstanceTimeVarying';
        }
        DecalInfo.Decal = Result;
        DecalInfo.LifetimeRemaining = InDecalLifeSpan;
        ActiveDecals.AddItem(DecalInfo);
    }
    return Result;
}

native final function bool IsTooCloseToActiveDecal(out const Vector DecalLocation, const float InCanSpawnDistance)
{
    DecalLocation;
    InCanSpawnDistance;
}

defaultproperties
{
    DecalTemplate="Default__GameDecalManager.BaseDecal"
}
