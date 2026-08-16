class LightmassImportanceVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display,Collision,Brush,Attachment,Physics,Volume);

defaultproperties
{
    BrushColor=(B=25,G=255,R=255,A=255)
    bColored=True
    BrushComponent="Default__LightmassImportanceVolume.BrushComponent0"
    bCollideActors=False
    Components(0)="Default__LightmassImportanceVolume.BrushComponent0"
    CollisionComponent="Default__LightmassImportanceVolume.BrushComponent0"
}
