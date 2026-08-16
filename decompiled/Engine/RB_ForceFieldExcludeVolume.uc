class RB_ForceFieldExcludeVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display);

var() int ForceFieldChannel;
var const native int SceneIndex;

defaultproperties
{
    ForceFieldChannel=1
    BrushComponent="Default__RB_ForceFieldExcludeVolume.BrushComponent0"
    Components(0)="Default__RB_ForceFieldExcludeVolume.BrushComponent0"
    CollisionComponent="Default__RB_ForceFieldExcludeVolume.BrushComponent0"
}
