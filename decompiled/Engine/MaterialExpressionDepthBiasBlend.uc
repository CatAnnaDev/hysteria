class MaterialExpressionDepthBiasBlend extends MaterialExpressionTextureSample
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object,Object);

var() bool bNormalize;
var() float BiasScale;
var ExpressionInput Bias;

defaultproperties
{
    BiasScale=1.0
    MenuCategories(0)="Obsolete"
}
