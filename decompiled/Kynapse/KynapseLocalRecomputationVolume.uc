class KynapseLocalRecomputationVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display,Actor,Advanced,Attachment,Brush,Collision,Volume);

var() bool bEnabled;

defaultproperties
{
    bEnabled=True
    bColored=True
    BrushComponent="Default__KynapseLocalRecomputationVolume.BrushComponent0"
    Components(0)="Default__KynapseLocalRecomputationVolume.BrushComponent0"
    CollisionComponent="Default__KynapseLocalRecomputationVolume.BrushComponent0"
}
