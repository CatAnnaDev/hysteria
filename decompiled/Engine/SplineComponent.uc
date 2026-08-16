class SplineComponent extends PrimitiveComponent
    native
    notplaceable;

var() InterpCurveVector SplineInfo;
var() editconst float SplineCurviness;
var() Color SplineColor;
var() float SplineDrawRes;
var() float SplineArrowSize;
var() bool bSplineDisabled;
var() InterpCurveFloat SplineReparamTable;

native function Vector GetTangentAtDistanceAlongSpline(float Distance)
{
    Distance;
}

native function Vector GetLocationAtDistanceAlongSpline(float Distance)
{
    Distance;
}

native function float GetSplineLength()
{
}

native function UpdateSplineReparamTable()
{
}

native function UpdateSplineCurviness()
{
}

defaultproperties
{
    SplineColor=(B=255,G=0,R=255,A=255)
    SplineDrawRes=0.1
    SplineArrowSize=60.0
    ReplacementPrimitive="None"
}
