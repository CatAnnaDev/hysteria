class MaterialExpressionFresnel extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

var() float Exponent;
var ExpressionInput Normal;

defaultproperties
{
    Exponent=3.0
    MenuCategories(0)="VectorOps"
}
