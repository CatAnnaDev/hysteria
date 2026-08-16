class MaterialExpressionSineParameter extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

var ExpressionInput Input;
var() float Period;
var() float ParamA;
var() float ParamB;

defaultproperties
{
    Period=1.0
    ParamA=0.5
    ParamB=0.5
    MenuCategories(0)="Math"
}
