class BrushComponent extends PrimitiveComponent
    native
    noexport
    notplaceable
    editinlinenew
    collapsecategories;

struct KCachedConvexData_Mirror
{
    var array<int> CachedConvexElements;
};

var const Model Brush;
var KAggregateGeom BrushAggGeom;
var const native transient Pointer BrushPhysDesc;
var const native transient KCachedConvexData_Mirror CachedPhysBrushData;
var const int CachedPhysBrushDataVersion;
var() bool bBlockComplexCollisionTrace;

defaultproperties
{
    ReplacementPrimitive="None"
    HiddenGame=True
    bUseAsOccluder=True
    AlwaysLoadOnClient=False
    AlwaysLoadOnServer=False
}
