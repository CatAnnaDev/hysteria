class MaterialExpressionConstantBiasScale extends MaterialExpression
    native
    notplaceable
    within Material
    hidecategories(Object);

var ExpressionInput Input;
var() float Bias;
var() float Scale;

defaultproperties
{
    Bias=1.0
    Scale=0.5
    MenuCategories(0)="Utility"
}
