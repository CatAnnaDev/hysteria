class InterpTrackFloatMaterialParam extends InterpTrackFloatBase
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

var() const array<MaterialReferenceList> Materials;
var const deprecated MaterialInterface Material;
var() name ParamName;

defaultproperties
{
    TrackInstClass="InterpTrackInstFloatMaterialParam"
    TrackTitle="Float Material Param"
}
