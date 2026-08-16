class MaterialExpressionAntialiasedTextureMask extends MaterialExpressionTextureSampleParameter2D
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object,Object,Object);

enum ETextureColorChannel
{
    TCC_Red,
    TCC_Green,
    TCC_Blue,
    TCC_Alpha,
};

var() float Threshold;
var() ETextureColorChannel Channel;

defaultproperties
{
    Threshold=0.5
    Channel="TCC_Alpha"
    MenuCategories(0)="HighLevel"
    MenuCategories(1)="Parameters"
}
