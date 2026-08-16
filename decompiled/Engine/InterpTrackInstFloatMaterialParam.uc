class InterpTrackInstFloatMaterialParam extends InterpTrackInst
    native
    notplaceable;

struct native FloatMaterialParamMICData
{
    var const array<MaterialInstanceConstant> MeshMICs;
    var const array<float> MeshMICResetFloats;
    var const array<MaterialInstanceConstant> DecalMICs;
    var const array<float> DecalMICResetFloats;
};

var array<FloatMaterialParamMICData> MICInfos;
var InterpTrackFloatMaterialParam InstancedTrack;

defaultproperties
{
}
