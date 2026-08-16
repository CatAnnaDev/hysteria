class ForceFieldShapeSphere extends ForceFieldShape
    native
    notplaceable
    editinlinenew;

var export editinline DrawSphereComponent Shape;

event PrimitiveComponent GetDrawComponent()
{
    return Shape;
}

event FillByCylinder(float BottomRadius, float TopRadius, float Height, float HeightOffset)
{
    local float topDistance, bottomDistance, centerBelowTop, centerAboveBottom;
    
    centerBelowTop = Height / float(2) + HeightOffset;
    centerAboveBottom = Height / float(2) - HeightOffset;
    topDistance = Sqrt(TopRadius * TopRadius + centerBelowTop * centerBelowTop);
    bottomDistance = Sqrt(BottomRadius * BottomRadius + centerAboveBottom * centerAboveBottom);
    Shape.SphereRadius = FMax(topDistance, bottomDistance);
}

event FillByCapsule(float Height, float Radius)
{
    Shape.SphereRadius = Height / float(2) + Radius;
}

event FillByBox(Vector Extent)
{
    Shape.SphereRadius = VSize(Extent);
}

event FillBySphere(float Radius)
{
    Shape.SphereRadius = Radius;
}

event float GetRadius()
{
    return Shape.SphereRadius;
}

defaultproperties
{
    Shape="Default__ForceFieldShapeSphere.DrawSphere0"
}
