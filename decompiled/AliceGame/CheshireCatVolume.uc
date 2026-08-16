class CheshireCatVolume extends Volume
    placeable
    hidecategories(Navigation,Object,Movement,Display);

var() bool bNoHintsZone;
var() bool bSoundOnlyZone;

function bool IsInBox(Vector In, Box _box)
{
    return In.X > _box.Min.X && In.X < _box.Max.X && In.Y > _box.Min.Y && In.Y < _box.Max.Y && In.Z > _box.Min.Z && In.Z < _box.Max.Z;
}

function bool IsInside(Vector Point)
{
    local Box volumeBox;
    
    GetComponentsBoundingBox(volumeBox);
    if (IsInBox(Point, volumeBox))
    {
        return true;
    }
    else
    {
        return false;
    }
}

defaultproperties
{
    BrushColor=(B=0,G=255,R=0,A=255)
    bColored=True
    BrushComponent="Default__CheshireCatVolume.BrushComponent0"
    Components(0)="Default__CheshireCatVolume.BrushComponent0"
    CollisionComponent="Default__CheshireCatVolume.BrushComponent0"
}
