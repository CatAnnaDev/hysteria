class InterpCurveEdSetup extends Object
    native
    notplaceable;

struct native CurveEdTab
{
    var string TabName;
    var array<CurveEdEntry> Curves;
    var float ViewStartInput;
    var float ViewEndInput;
    var float ViewStartOutput;
    var float ViewEndOutput;
};

struct native CurveEdEntry
{
    var Object CurveObject;
    var Color CurveColor;
    var string CurveName;
    var int bHideCurve;
    var int bColorCurve;
    var int bFloatingPointColorCurve;
    var int bClamp;
    var float ClampLow;
    var float ClampHigh;
};

var array<CurveEdTab> Tabs;
var int ActiveTab;

defaultproperties
{
    Tabs(0)=(TabName="Default",Curves=(),ViewStartInput=0.0,ViewEndInput=1.0,ViewStartOutput=-1.0,ViewEndOutput=1.0)
}
