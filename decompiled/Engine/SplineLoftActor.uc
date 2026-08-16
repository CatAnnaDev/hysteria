class SplineLoftActor extends SplineActor
    native
    placeable
    hidecategories(Navigation);

var() float ScaleX;
var() float ScaleY;
var export editinline array<SplineMeshComponent> SplineMeshComps;
var() const StaticMesh DeformMesh;
var() const array<MaterialInterface> DeformMeshMaterials;
var() float Roll;
var() Vector WorldXDir;
var() Vector2D Offset;
var() bool bSmoothInterpRollAndScale;
var() bool bAcceptsLights;

native function ClearLoftMesh()
{
}

defaultproperties
{
    ScaleX=1.0
    ScaleY=1.0
    WorldXDir=(X=1.0,Y=0.0,Z=0.0)
    bSmoothInterpRollAndScale=True
    bAcceptsLights=True
    bStatic=True
    bWorldGeometry=True
    bGameRelevant=True
    bMovable=False
    bCollideActors=True
    bBlockActors=True
    bEdShouldSnap=True
    Components(0)="Default__SplineLoftActor.Sprite"
}
