class CurveEdPresetCurve extends Object
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

struct native PresetGeneratedPoint
{
    var float KeyIn;
    var float KeyOut;
    var bool TangentsValid;
    var float TangentIn;
    var float TangentOut;
    var EInterpCurveMode IntepMode;
};

var() const localized string CurveName;
var array<PresetGeneratedPoint> Points;

defaultproperties
{
}
