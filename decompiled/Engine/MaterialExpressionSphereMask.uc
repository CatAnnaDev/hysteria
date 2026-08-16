class MaterialExpressionSphereMask extends MaterialExpression
    native
    notplaceable
    within Material
    hidecategories(Object);

var ExpressionInput A;
var ExpressionInput B;
var() float AttenuationRadius;
var() float HardnessPercent;

defaultproperties
{
    AttenuationRadius=256.0
    HardnessPercent=100.0
    MenuCategories(0)="HighLevel"
}
