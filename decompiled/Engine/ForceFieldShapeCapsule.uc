class ForceFieldShapeCapsule extends ForceFieldShape
    native
    notplaceable
    editinlinenew;

var export editinline DrawCapsuleComponent Shape;

event PrimitiveComponent GetDrawComponent()
{
    return Shape;
}

event FillByCylinder(float BottomRadius, float TopRadius, float Height, float HeightOffset)
{
    Shape.CapsuleRadius = FMax(BottomRadius, TopRadius);
    Shape.CapsuleHeight = Height;
}

event FillByCapsule(float Height, float Radius)
{
    Shape.CapsuleHeight = Height;
    Shape.CapsuleRadius = Radius;
}

event FillByBox(Vector Extent)
{
    Shape.CapsuleRadius = Sqrt(Extent.X * Extent.X + Extent.Y * Extent.Y);
    Shape.CapsuleHeight = Extent.Z * float(2);
}

event FillBySphere(float Radius)
{
    Shape.CapsuleRadius = Radius;
    Shape.CapsuleHeight = 0.0;
}

event float GetRadius()
{
    return Shape.CapsuleRadius;
}

event float GetHeight()
{
    return Shape.CapsuleHeight;
}

defaultproperties
{
    Shape="Default__ForceFieldShapeCapsule.DrawCapsule0"
}
