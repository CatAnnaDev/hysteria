class MaterialExpressionDepthBiasedBlend extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

var() bool bNormalize;
var() float BiasScale;
var ExpressionInput RGB;
var ExpressionInput Alpha;
var ExpressionInput Bias;

defaultproperties
{
    BiasScale=1.0
    MenuCategories(0)="Obsolete"
}
