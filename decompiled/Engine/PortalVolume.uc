class PortalVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display,Advanced,Attachment,Collision,Volume);

var array<PortalTeleporter> Portals;

defaultproperties
{
    BrushComponent="Default__PortalVolume.BrushComponent0"
    bCollideActors=False
    Components(0)="Default__PortalVolume.BrushComponent0"
    CollisionComponent="Default__PortalVolume.BrushComponent0"
    SupportedEvents(0)="SeqEvent_Touch"
}
