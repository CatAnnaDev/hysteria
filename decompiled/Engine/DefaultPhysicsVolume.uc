class DefaultPhysicsVolume extends PhysicsVolume
    native
    notplaceable
    transient
    hidecategories(Navigation,Object,Movement,Display);

event Destroyed()
{
    LogInternal(string(self) $ " destroyed!");
    assert(false);
}

defaultproperties
{
    BrushComponent="Default__DefaultPhysicsVolume.BrushComponent0"
    bStatic=False
    bNoDelete=False
    Components(0)="Default__DefaultPhysicsVolume.BrushComponent0"
    TickGroup="TG_DuringAsyncWork"
    CollisionComponent="Default__DefaultPhysicsVolume.BrushComponent0"
}
