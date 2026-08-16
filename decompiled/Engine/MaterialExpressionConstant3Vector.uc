class MaterialExpressionConstant3Vector extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

var float R;
var float G;
var float B;
var() LinearColor ParameterValue;

defaultproperties
{
    ParameterValue=(R=0.0,G=0.0,B=0.0,A=1.0)
    MenuCategories(0)="Constants"
    MenuCategories(1)="Vectors"
}
