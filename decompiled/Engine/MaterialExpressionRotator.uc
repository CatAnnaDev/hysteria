class MaterialExpressionRotator extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

var ExpressionInput Coordinate;
var ExpressionInput Time;
var() float CenterX;
var() float CenterY;
var() float Speed;

defaultproperties
{
    CenterX=0.5
    CenterY=0.5
    Speed=0.25
    MenuCategories(0)="Coordinates"
}
