class Brush extends Actor
    native
    notplaceable
    hidecategories(Navigation,Object,Movement,Display);

enum ECsgOper
{
    CSG_Active,
    CSG_Add,
    CSG_Subtract,
    CSG_Intersect,
    CSG_Deintersect,
};

struct native export GeomSelection
{
    var int Type;
    var int Index;
    var int SelectionIndex;
};

var() ECsgOper CsgOper;
var() Color BrushColor;
var int PolyFlags;
var() bool bColored;
var bool bSolidWhenSelected;
var bool bPlaceableFromClassBrowser;
var const export Model Brush;
var const export editconst editinline BrushComponent BrushComponent;
var array<GeomSelection> SavedSelections;

defaultproperties
{
    BrushComponent="Default__Brush.BrushComponent0"
    bStatic=True
    bHidden=True
    bNoDelete=True
    bEdShouldSnap=True
    Components(0)="Default__Brush.BrushComponent0"
    CollisionType="COLLIDE_CustomDefault"
    CollisionComponent="Default__Brush.BrushComponent0"
}
