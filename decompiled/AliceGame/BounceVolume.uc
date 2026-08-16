class BounceVolume extends Volume
    placeable
    hidecategories(Navigation,Object,Movement,Display);

event Touch(Actor Other, PrimitiveComponent OtherComp, Vector HitLocation, Vector HitNormal)
{
    if (Other.IsA('RailRideActor'))
    {
        RailRideActor(Other).BounceOff(HitNormal);
    }
}

defaultproperties
{
    BrushComponent="Default__BounceVolume.BrushComponent0"
    Components(0)="Default__BounceVolume.BrushComponent0"
    CollisionComponent="Default__BounceVolume.BrushComponent0"
}
