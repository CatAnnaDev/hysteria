class MaterialExpressionSceneTexture extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

enum ESceneTextureType
{
    SceneTex_Lighting,
};

var ExpressionInput Coordinates;
var() ESceneTextureType SceneTextureType;
var() bool ScreenAlign;

defaultproperties
{
    MenuCategories(0)="Texture"
}
