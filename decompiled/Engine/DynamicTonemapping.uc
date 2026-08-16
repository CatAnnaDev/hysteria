class DynamicTonemapping extends PostProcessEffect
    native
    notplaceable
    hidecategories(Object);

var() float MiddleGray;
var() float LuminanceScale;
var() float MinGray;
var() float AdaptationRate;
var() float MinColorScale;
var() float MaxColorScale;
var() bool bShowDebugInfo;

defaultproperties
{
    MiddleGray=0.1
    LuminanceScale=1.0
    MinGray=0.01
    AdaptationRate=30.0
    MinColorScale=1.0
    MaxColorScale=5.0
    bShowInEditor=False
}
