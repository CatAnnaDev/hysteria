class SplineMeshComponent extends StaticMeshComponent
    native
    notplaceable
    editinlinenew
    hidecategories(Object);

struct native SplineMeshParams
{
    var Vector StartPos;
    var Vector StartTangent;
    var Vector2D StartScale;
    var float StartRoll;
    var Vector2D StartOffset;
    var Vector EndPos;
    var Vector EndTangent;
    var Vector2D EndScale;
    var float EndRoll;
    var Vector2D EndOffset;
};

var SplineMeshParams SplineParams;
var Vector SplineXDir;
var bool bSmoothInterpRollScale;

defaultproperties
{
    SplineXDir=(X=1.0,Y=0.0,Z=0.0)
    ReplacementPrimitive="None"
    bUseAsOccluder=False
    bUsePrecomputedShadows=True
}
