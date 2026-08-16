class TurretMine extends TurretBomb
    notplaceable
    hidecategories(Navigation);

var Alice2DTurretMine TurretMine;
var bool bExploded;

simulated event Destroyed()
{
    if (!bExploded)
    {
        TurretMine.PlayMineExplodeEffect(self, Location, Rotation);
    }
    Destroyed();
}

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    local Volume V;
    local Trigger T;
    local EmitterSpawnable E;
    local RailRideActor Boat;
    
    Boat = RailRideActor(Other);
    if (Boat != none)
    {
        return;
    }
    if (TurretMine(Other) != none)
    {
        return;
    }
    V = Volume(Other);
    if (V != none && BounceVolume(Other) == none)
    {
        return;
    }
    T = Trigger(Other);
    if (T != none)
    {
        return;
    }
    E = EmitterSpawnable(Other);
    if (E != none)
    {
        return;
    }
    TurretMine.PlayMineExplodeEffect(self, HitLocation, Rotation);
    MyOwner.NumberOfProj--;
    bExploded = true;
    Destroy();
}

defaultproperties
{
    StaticMeshComponent="Default__TurretMine.StaticMeshComponent0"
    LightEnvironment="Default__TurretMine.MyLightEnvironment"
    Components(0)="Default__TurretMine.MyLightEnvironment"
    Components(1)="Default__TurretMine.StaticMeshComponent0"
    CollisionComponent="Default__TurretMine.StaticMeshComponent0"
}
