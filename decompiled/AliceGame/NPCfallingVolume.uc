class NPCfallingVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display);

simulated function bool StopsProjectile(Projectile P)
{
    return false;
}

simulated event PostBeginPlay()
{
    PostBeginPlay();
}

defaultproperties
{
    BrushColor=(B=255,G=0,R=100,A=255)
    bColored=True
    BrushComponent="Default__NPCfallingVolume.BrushComponent0"
    Components(0)="Default__NPCfallingVolume.BrushComponent0"
    CollisionComponent="Default__NPCfallingVolume.BrushComponent0"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
}
