class MaterialExpressionTransformPosition extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

enum EMaterialPositionTransform
{
    TRANSFORMPOS_World,
};

var ExpressionInput Input;
var() const EMaterialPositionTransform TransformType;

defaultproperties
{
    MenuCategories(0)="VectorOps"
}
