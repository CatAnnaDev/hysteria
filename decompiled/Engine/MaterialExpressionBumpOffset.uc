class MaterialExpressionBumpOffset extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

var ExpressionInput Coordinate;
var ExpressionInput Height;
var() float HeightRatio;
var() float ReferencePlane;

defaultproperties
{
    HeightRatio=0.05
    ReferencePlane=0.5
    MenuCategories(0)="Utility"
}
