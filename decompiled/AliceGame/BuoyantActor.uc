class BuoyantActor extends KActor
    native
    placeable;

var transient float Volume;
var transient BuoyantVolume BuoyantVolume;

defaultproperties
{
    StaticMeshComponent="Default__BuoyantActor.StaticMeshComponent0"
    LightEnvironment="Default__BuoyantActor.MyLightEnvironment"
    bNoEncroachCheck=False
    Components(0)="Default__BuoyantActor.MyLightEnvironment"
    Components(1)="Default__BuoyantActor.StaticMeshComponent0"
    CollisionComponent="Default__BuoyantActor.StaticMeshComponent0"
}
