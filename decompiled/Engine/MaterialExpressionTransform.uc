class MaterialExpressionTransform extends MaterialExpression
    native
    notplaceable
    collapsecategories
    within Material
    hidecategories(Object,Object);

enum EMaterialVectorCoordTransform
{
    TRANSFORM_World,
    TRANSFORM_View,
    TRANSFORM_Local,
    TRANSFORM_Tangent,
};

enum EMaterialVectorCoordTransformSource
{
    TRANSFORMSOURCE_World,
    TRANSFORMSOURCE_Local,
    TRANSFORMSOURCE_Tangent,
};

var ExpressionInput Input;
var() const EMaterialVectorCoordTransformSource TransformSourceType;
var() const EMaterialVectorCoordTransform TransformType;

defaultproperties
{
    TransformSourceType="TRANSFORMSOURCE_Tangent"
    MenuCategories(0)="VectorOps"
}
