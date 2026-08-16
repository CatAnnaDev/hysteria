class WaterVolume extends PhysicsVolume
    notplaceable
    hidecategories(Navigation,Object,Movement,Display);

var() SoundCue EntrySound;
var() SoundCue ExitSound;
var() class<Actor> EntryActor;
var() class<Actor> ExitActor;
var() class<Actor> PawnEntryActor;

function PlayExitSplash(Actor Other)
{
    if (ExitSound != none)
    {
        Other.PlaySound(ExitSound);
        if (Other.Instigator != none)
        {
            Other.MakeNoise(1.0);
        }
    }
    if (ExitActor != none)
    {
        Spawn(ExitActor);
    }
}

event UnTouch(Actor Other)
{
    if (Other.CanSplash())
    {
        PlayExitSplash(Other);
    }
}

function PlayEntrySplash(Actor Other)
{
    if (EntrySound != none)
    {
        Other.PlaySound(EntrySound);
        if (Other.Instigator != none)
        {
            Other.MakeNoise(1.0);
        }
    }
    if (EntryActor != none)
    {
        Spawn(EntryActor);
    }
}

simulated event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    Touch(Other, OtherComp, HitLocation, HitNormal);
    if (Other.CanSplash())
    {
        PlayEntrySplash(Other);
    }
}

defaultproperties
{
    bWaterVolume=True
    FluidFriction=2.4
    LocationName="under water"
    BrushComponent="Default__WaterVolume.BrushComponent0"
    Components(0)="Default__WaterVolume.BrushComponent0"
    CollisionComponent="Default__WaterVolume.BrushComponent0"
}
