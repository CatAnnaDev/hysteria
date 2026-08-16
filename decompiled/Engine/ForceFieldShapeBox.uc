class ForceFieldShapeBox extends ForceFieldShape
    native
    notplaceable
    editinlinenew;

var export editinline DrawBoxComponent Shape;

event PrimitiveComponent GetDrawComponent()
{
    return Shape;
}

event FillByCylinder(float BottomRadius, float TopRadius, float Height, float HeightOffset)
{
    Shape.BoxExtent.X = FMax(BottomRadius, TopRadius);
    Shape.BoxExtent.Y = Shape.BoxExtent.X;
    Shape.BoxExtent.Z = Height / float(2) + Abs(HeightOffset);
}

event FillByCapsule(float Height, float Radius)
{
    Shape.BoxExtent.X = Radius;
    Shape.BoxExtent.Y = Radius;
    Shape.BoxExtent.Z = Radius + Height / float(2);
}

event FillByBox(Vector Extent)
{
    Shape.BoxExtent = Extent;
}

event FillBySphere(float Radius)
{
    Shape.BoxExtent.X = Radius;
    Shape.BoxExtent.Y = Radius;
    Shape.BoxExtent.Z = Radius;
}

event Vector GetRadii()
{
    return Shape.BoxExtent;
}

defaultproperties
{
    Shape="Default__ForceFieldShapeBox.DrawBox0"
}
