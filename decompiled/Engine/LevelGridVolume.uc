class LevelGridVolume extends Volume
    native
    placeable
    hidecategories(Navigation,Object,Movement,Display,Advanced,Attachment,Collision,Volume,Physics,Location)
    autoexpandcategories(LevelGridVolume);

enum LevelGridCellShape
{
    LGCS_Box,
    LGCS_Hex,
};

struct native LevelGridCellCoordinate
{
    var int X;
    var int Y;
    var int Z;
};

var() const string LevelGridVolumeName;
var() const LevelGridCellShape CellShape;
var() const int Subdivisions[3];
var() const float LoadingDistance;
var() const float KeepLoadedRange;
var const transient KConvexElem CellConvexElem;

defaultproperties
{
    Subdivisions=1
    Subdivisions[1]=1
    Subdivisions[2]=1
    LoadingDistance=20480.0
    KeepLoadedRange=2048.0
    BrushColor=(B=80,G=80,R=80,A=255)
    bColored=True
    BrushComponent="Default__LevelGridVolume.BrushComponent0"
    bCollideActors=False
    Components(0)="Default__LevelGridVolume.BrushComponent0"
    Components(1)="Default__LevelGridVolume.LevelGridVolumeRenderer"
    CollisionComponent="Default__LevelGridVolume.BrushComponent0"
}
