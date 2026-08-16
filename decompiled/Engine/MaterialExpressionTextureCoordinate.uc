class MaterialExpressionTextureCoordinate extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

var() int CoordinateIndex;
var() float UTiling;
var() float VTiling;
var() bool UnMirrorU;
var() bool UnMirrorV;

defaultproperties
{
    UTiling=1.0
    VTiling=1.0
    MenuCategories(0)="Coordinates"
}
