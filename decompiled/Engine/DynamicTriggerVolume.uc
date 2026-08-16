class DynamicTriggerVolume extends TriggerVolume
    placeable
    hidecategories(Navigation,Object,Display);

var() bool bEnabled;

simulated event PostBeginPlay()
{
    PostBeginPlay();
    SetCollision(bEnabled, bBlockActors);
}

defaultproperties
{
    bEnabled=True
    BrushColor=(B=255,G=255,R=100,A=255)
    BrushComponent="Default__DynamicTriggerVolume.BrushComponent0"
    bStatic=False
    bAlwaysRelevant=True
    bOnlyDirtyReplication=True
    Components(0)="Default__DynamicTriggerVolume.BrushComponent0"
    CollisionComponent="Default__DynamicTriggerVolume.BrushComponent0"
}
