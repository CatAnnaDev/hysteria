class ForceFieldShape extends Object
    abstract
    native
    notplaceable
    editinlinenew;

event PrimitiveComponent GetDrawComponent()
{
}

event FillByCylinder(float BottomRadius, float TopRadius, float Height, float HeightOffset)
{
}

event FillByCapsule(float Height, float Radius)
{
}

event FillByBox(Vector Dimension)
{
}

event FillBySphere(float Radius)
{
}

defaultproperties
{
}
