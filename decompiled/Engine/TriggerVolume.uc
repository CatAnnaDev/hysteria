class TriggerVolume extends Volume
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
    if (BrushComponent != none)
    {
        bProjTarget = BrushComponent.BlockZeroExtent;
    }
}

defaultproperties
{
    BrushColor=(B=100,G=255,R=100,A=255)
    bColored=True
    BrushComponent="Default__TriggerVolume.BrushComponent0"
    bProjTarget=True
    Components(0)="Default__TriggerVolume.BrushComponent0"
    CollisionComponent="Default__TriggerVolume.BrushComponent0"
    SupportedEvents(0)="SeqEvent_Touch"
    SupportedEvents(1)="SeqEvent_TakeDamage"
}
