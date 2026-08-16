class SkelControlSpline extends SkelControlBase
    native
    notplaceable
    hidecategories(Object,Object);

enum ESplineControlRotMode
{
    SCR_NoChange,
    SCR_AlongSpline,
    SCR_Interpolate,
};

var(Spline) int SplineLength;
var(Spline) EAxis SplineBoneAxis;
var(Spline) ESplineControlRotMode BoneRotMode;
var(Spline) bool bInvertSplineBoneAxis;
var(Spline) float EndSplineTension;
var(Spline) float StartSplineTension;

defaultproperties
{
    SplineLength=2
    SplineBoneAxis="AXIS_X"
    EndSplineTension=10.0
    StartSplineTension=10.0
}
