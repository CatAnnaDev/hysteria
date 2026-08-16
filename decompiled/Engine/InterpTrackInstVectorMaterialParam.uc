class InterpTrackInstVectorMaterialParam extends InterpTrackInst
    native
    notplaceable;

struct native VectorMaterialParamMICData
{
    var const array<MaterialInstanceConstant> MeshMICs;
    var const array<Vector> MeshMICResetVectors;
    var const array<MaterialInstanceConstant> DecalMICs;
    var const array<Vector> DecalMICResetVectors;
};

var array<VectorMaterialParamMICData> MICInfos;
var InterpTrackVectorMaterialParam InstancedTrack;

defaultproperties
{
}
