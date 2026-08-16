class InterpTrackVectorMaterialParam extends InterpTrackVectorBase
    native
    notplaceable
    collapsecategories
    hidecategories(Object);

var() const array<MaterialReferenceList> Materials;
var const deprecated MaterialInterface Material;
var() name ParamName;

defaultproperties
{
    TrackInstClass="InterpTrackInstVectorMaterialParam"
    TrackTitle="Vector Material Param"
}
