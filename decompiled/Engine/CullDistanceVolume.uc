class CullDistanceVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display,Advanced,Attachment,Collision,Volume);

struct native CullDistanceSizePair
{
    var() float Size;
    var() float CullDistance;
};

var() array<CullDistanceSizePair> CullDistances;
var() bool bEnabled;

defaultproperties
{
    CullDistances(0)=(Size=0.0,CullDistance=0.0)
    CullDistances(1)=(Size=10000.0,CullDistance=0.0)
    bEnabled=True
    BrushComponent="Default__CullDistanceVolume.BrushComponent0"
    bCollideActors=False
    Components(0)="Default__CullDistanceVolume.BrushComponent0"
    CollisionComponent="Default__CullDistanceVolume.BrushComponent0"
}
