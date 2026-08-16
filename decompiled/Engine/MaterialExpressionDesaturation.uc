class MaterialExpressionDesaturation extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

var ExpressionInput Input;
var ExpressionInput Percent;
var() LinearColor LuminanceFactors;

defaultproperties
{
    LuminanceFactors=(R=0.3,G=0.59,B=0.11,A=0.0)
    MenuCategories(0)="Color"
    MenuCategories(1)="Utility"
}
