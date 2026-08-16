class MaterialExpressionTicker extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

var() bool bIgnorePause;
var() float DefaultFPS;
var() float DefaultSpeed;
var ExpressionInput FPS;
var ExpressionInput Speed;

defaultproperties
{
    bIgnorePause=True
    DefaultFPS=24.0
    DefaultSpeed=0.1
    MenuCategories(0)="Utility"
}
