class PressureTriggerVolume extends Volume
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
    BrushColor=(B=255,G=0,R=100,A=255)
    bColored=True
    BrushComponent="Default__PressureTriggerVolume.BrushComponent0"
    BlockRigidBody=True
    bProjTarget=True
    Components(0)="Default__PressureTriggerVolume.BrushComponent0"
    CollisionComponent="Default__PressureTriggerVolume.BrushComponent0"
    SupportedEvents(0)="Engine.SeqEvent_Touch"
    SupportedEvents(1)="Engine.SeqEvent_TakeDamage"
}
