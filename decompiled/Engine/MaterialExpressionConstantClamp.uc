class MaterialExpressionConstantClamp extends MaterialExpression
    native
    notplaceable
    within Material
    hidecategories(Object);

var ExpressionInput Input;
var() float Min;
var() float Max;

defaultproperties
{
    Max=1.0
    MenuCategories(0)="Utility"
}
